BMXRPC ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;;Stolen from:* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  GENERIC LOOKUP UTILITY FOR RETURNING MATCHING RECORDS
 ;;  OR TABLES TO RPC'S.
 ;
 ; *** NOTE: I have discovered a number of cases where these calls
 ;           produce errors (with error messages to IO) or simply
 ;           do not work correctly.  ANY CALL to this utility 
 ;           should be thoroughly tested in the M environment
 ;           before being used as an RPC.
 ;
 ;----------
LOOKUP(BMXGBL,BMXFL,BMXFLDS,BMXFLG,BMXIN,BMXMX,BMXIX,BMXSCR,BMXMC) ;EP
 ;---> Places matching records from requested file into a
 ;---> result global, ^BMXTEMP($J).  The exact global name
 ;---> is returned in the first parameter (BMXGBL).
 ;---> Records are returned one per node in the result global.
 ;---> Each record is terminated with a $C(30), for parsing out
 ;---> on the VB side, since the Broker concatenates all nodes
 ;---> into a single string when passing the data out of M.
 ;---> Requested fields within records are delimited by "^".
 ;---> NOTE: The first "^"-piece of every node is the IEN of
 ;---> that entry in its file; the requested fields follow.
 ;---> The final record (node) contains Error Delimiter,
 ;     $C(31)_$C(31), followed by error text, if any.
 ;
 ;---> Parameters:
 ;     1 - BMXGBL   (ret) Name of result global for Broker.
 ;     2 - BMXFL    (req) File for lookup.
 ;     3 - BMXFLDS  (opt) Fields to return w/each entry.
 ;     4 - BMXFLG   (opt) Flags in DIC(0); If null, "M" is sent.
 ;     5 - BMXIN    (opt) Input to match on (see Algorithm below).
 ;     6 - BMXMX    (opt) Maximum number of entries to return.
 ;     7 - BMXIX    (opt) Indexes to search.
 ;     8 - BMXSCR   (opt) Screen/filter (M code).
 ;     9 - BMXMC    (opt) Mixed Case: 1=mixed case, 0=no change.
 ;                        (Converts data in uppercase to mixed case.)
 ;
 ;---> Set variables, kill temp globals.
 N (BMXGBL,BMXFL,BMXFLDS,BMXFLG,BMXIN,BMXMX,BMXIX,BMXSCR,BMXMC) ;IHS/OIT/HMW SAC Exemption Applied For
 S BMX31=$C(31)_$C(31)
 S BMXGBL="^BMXTEMP("_$J_")",BMXERR="",U="^"
 K ^BMXTMP($J),^BMXTEMP($J)
 ;
 ;---> If file number not provided, return error.
 I '$G(BMXFL) D ERROUT("File number not provided.",1) Q
 ;
 ;---> If no fields provided, pass .01.
 ;---> IEN will always be the first piece of data returned.
 ;---> NOTE: If .01 is NOT included, but the Index to lookup on is
 ;--->       NOT on the .01, then the .01 will be returned
 ;--->       automatically as the second ^-piece of data in the
 ;--->       Result Global.  
 ;--->       So it would be: IEN^.01^requested fields...
 I $G(BMXFLDS)="" S BMXFLDS=".01"
 ;
 ;---> If no index or flag provided, set flag="M".
 I $G(BMXFLG)="" D
 .I $G(BMXIX)="" S BMXFLG="M" Q
 .S BMXFLG=""
 ;
 ;---> If no Maximum Number provided, set it to 200.
 I '$G(BMXMX) S BMXMX=200
 ;
 ;---> Define index and screen.
 S:'$D(BMXIX) BMXIX=""
 S:'$D(BMXSCR) BMXSCR=""
 ;
 ;---> Set Target Global for output and errors.
 S BMXG="^BMXTMP($J)"
 ;
 ;---> If Mixed Case not set, set to No Change.
 I '$D(BMXMC) S BMXMC=0
 ;
 ;---> Silent Fileman call.
 D
 .I $G(BMXIN)="" D  Q
 ..D LIST^DIC(BMXFL,,BMXFLDS,,BMXMX,0,,BMXIX,BMXSCR,,BMXG,BMXG)
 .D FIND^DIC(BMXFL,,BMXFLDS,BMXFLG,BMXIN,BMXMX,BMXIX,BMXSCR,,BMXG,BMXG)
 ;
 D WRITE
 Q
 ;
 ;
 ;----------
WRITE ;EP
 ;---> Collect data for matching records and write in result global.
 ;
 ;---> First, check for errors.
 ;---> If errors exist, write them and quit.
 N I,N,X
 I $D(^BMXTMP($J,"DIERR")) I $O(^("DIERR",0)) D  Q
 .S N=0,X=""
 .F  S N=$O(^BMXTMP($J,"DIERR",N)) Q:'N  D
 ..N M S M=0
 ..F  S M=$O(^BMXTMP($J,"DIERR",N,"TEXT",M)) Q:'M  D
 ...S X=X_^BMXTMP($J,"DIERR",N,"TEXT",M)_"  "
 .D ERROUT(X,1)
 ;
 ;
 ;---> Write Field Names
 S $P(ASDX,"^",1)="IEN"
 F ASDC=1:1:$L(BMXFLDS,";") D
 . S ASDXFNUM=$P(BMXFLDS,";",ASDC)
 . S ASDXFNAM=$P(^DD(BMXFL,ASDXFNUM,0),"^")
 . S:ASDXFNAM="" ASDXFNAM="UNKNOWN"_ASDC
 . S $P(ASDX,"^",ASDC+1)=ASDXFNAM
 S ^BMXTEMP($J,1)=ASDX_$C(30)
 ;---> Write valid results.
 ;---> Loop through the IEN node (...2,N) of the temp global.
 N I,N,X S N=0
 F I=2:1 S N=$O(^BMXTMP($J,"DILIST",2,N)) Q:'N  D
 .;---> Always set first piece of X=IEN of entry.
 .S X=^BMXTMP($J,"DILIST",2,N)
 .;
 .;---> Collect other fields and concatenate to X.
 .N M S M=0
 .F  S M=$O(^BMXTMP($J,"DILIST","ID",N,M)) Q:'M  D
 ..S X=X_U_^BMXTMP($J,"DILIST","ID",N,M)
 .;
 .;---> Convert data to mixed case if BMXMC=1.
 .S:BMXMC X=$$T^BMXTRS(X)
 .;
 .;---> Set data in result global.
 .S ^BMXTEMP($J,I)=X_$C(30)
 ;
 ;---> If no results, report it as an error.
 D:'$O(^BMXTEMP($J,0))
 .I BMXIN]"" S BMXERR="No entry matches """_BMXIN_"""." Q
 .S BMXERR="Either the lookup file is empty"
 .S BMXERR=BMXERR_" or all entries are screened (software error)."
 ;
 ;---> Tack on Error Delimiter and any error.
 S ^BMXTEMP($J,I)=BMX31_BMXERR
 Q
 ;
 ;
 ;----------
ERROUT(BMXERR,I) ;EP
 ;---> Save next line for Error Code File if ever used.
 ;---> If necessary, use I>1 to avoid overwriting valid data.
 S:'$G(I) I=1
 S ^BMXTEMP($J,I)=BMX31_BMXERR
 Q
 ;
 ;
PASSERR(BMXGBL,BMXERR) ;EP
 ;---> If the RPC routine calling the BMX Generic Lookup above
 ;---> detects a specific error prior to the call and wants to pass 
 ;---> that error in the result global rather than a generic error,
 ;---> then a call to this function (PASSERR) can be made.
 ;---> This call will store the error text passed in the result global.
 ;---> The calling routine should then quit (abort its call to the
 ;---> BMX Generic Lookup function above).
 ;
 ;---> Parameters:
 ;     1 - BMXGBL  (ret) Name of result global for Broker.
 ;     2 - BMXERR  (req) Text of error to be stored in result global.
 ;
 S:$G(BMXERR)="" BMXERR="Error not passed (software error)."
 ;
 N BMX31 S BMX31=$C(31)_$C(31)
 K ^BMXTMP($J),^BMXTEMP($J)
 S BMXGBL="^BMXTEMP("_$J_")"
 S ^BMXTEMP($J,1)=BMX31_BMXERR
 Q

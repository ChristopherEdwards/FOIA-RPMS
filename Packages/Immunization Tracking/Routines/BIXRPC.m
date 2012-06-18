BIXRPC ;IHS/CMI/MWR - BI REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
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
LOOKUP(BIGBL,BIFL,BIFLDS,BIFLG,BIIN,BIMX,BIIX,BISCR,BIMC) ;EP
 ;---> Places matching records from requested file into a
 ;---> result global, ^BITEMP($J).  The exact global name
 ;---> is returned in the first parameter (BIGBL).
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
 ;     1 - BIGBL   (ret) Name of result global for Broker.
 ;     2 - BIFL    (req) File for lookup.
 ;     3 - BIFLDS  (opt) Fields to return w/each entry.
 ;     4 - BIFLG   (opt) Flags in DIC(0); If null, "M" is sent.
 ;     5 - BIIN    (opt) Input to match on (see Algorithm below).
 ;     6 - BIMX    (opt) Maximum number of entries to return.
 ;     7 - BIIX    (opt) Indexes to search.
 ;     8 - BISCR   (opt) Screen/filter (M code).
 ;     9 - BIMC    (opt) Mixed Case: 1=mixed case, 0=no change.
 ;                        (Converts data in uppercase to mixed case.)
 ;
 ;---> Set variables, kill temp globals.
 N (BIGBL,BIFL,BIFLDS,BIFLG,BIIN,BIMX,BIIX,BISCR,BIMC)
 S BI31=$C(31)_$C(31)
 S BIGBL="^BITEMP("_$J_")",BIERR="",U="^"
 K ^BITMP($J),^BITEMP($J)
 ;
 ;---> If file number not provided, return error.
 I '$G(BIFL) D ERROUT("File number not provided.",1) Q
 ;
 ;---> If no fields provided, pass .01.
 ;---> IEN will always be the first piece of data returned.
 ;---> NOTE: If .01 is NOT included, but the Index to lookup on is
 ;--->       NOT on the .01, then the .01 will be returned
 ;--->       automatically as the second ^-piece of data in the
 ;--->       Result Global.
 ;--->       So it would be: IEN^.01^requested fields...
 I $G(BIFLDS)="" S BIFLDS=".01"
 ;
 ;---> If no index or flag provided, set flag="M".
 I $G(BIFLG)="" D
 .I $G(BIIX)="" S BIFLG="M" Q
 .S BIFLG=""
 ;
 ;---> If no Maximum Number provided, set it to 200.
 I '$G(BIMX) S BIMX=200
 ;
 ;---> Define index and screen.
 S:'$D(BIIX) BIIX=""
 S:'$D(BISCR) BISCR=""
 ;
 ;---> Set Target Global for output and errors.
 S BIG="^BITMP($J)"
 ;
 ;---> If Mixed Case not set, set to No Change.
 I '$D(BIMC) S BIMC=0
 ;
 ;---> Silent Fileman call.
 D
 .I $G(BIIN)="" D  Q
 ..D LIST^DIC(BIFL,,BIFLDS,,BIMX,0,,BIIX,BISCR,,BIG,BIG)
 .D FIND^DIC(BIFL,,BIFLDS,BIFLG,BIIN,BIMX,BIIX,BISCR,,BIG,BIG)
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
 I $D(^BITMP($J,"DIERR")) I $O(^("DIERR",0)) D  Q
 .S N=0,X=""
 .F  S N=$O(^BITMP($J,"DIERR",N)) Q:'N  D
 ..N M S M=0
 ..F  S M=$O(^BITMP($J,"DIERR",N,"TEXT",M)) Q:'M  D
 ...S X=X_^BITMP($J,"DIERR",N,"TEXT",M)_"  "
 .D ERROUT(X,1)
 ;
 ;
 ;---> Write valid results.
 ;---> Loop through the IEN node (...2,N) of the temp global.
 N I,N,X S N=0
 F I=1:1 S N=$O(^BITMP($J,"DILIST",2,N)) Q:'N  D
 .;---> Always set first piece of X=IEN of entry.
 .S X=^BITMP($J,"DILIST",2,N)
 .;
 .;---> Collect other fields and concatenate to X.
 .N M S M=0
 .F  S M=$O(^BITMP($J,"DILIST","ID",N,M)) Q:'M  D
 ..S X=X_U_^BITMP($J,"DILIST","ID",N,M)
 .;
 .;---> Convert data to mixed case if BIMC=1.
 .S:BIMC X=$$T^BITRS(X)
 .;
 .;---> Set data in result global.
 .S ^BITEMP($J,I)=X_$C(30)
 ;
 ;---> If no results, report it as an error.
 D:'$O(^BITEMP($J,0))
 .I BIIN]"" S BIERR="No entry matches """_BIIN_"""." Q
 .S BIERR="Either the lookup file is empty"
 .S BIERR=BIERR_" or all entries are screened (software error)."
 ;
 ;---> Tack on Error Delimiter and any error.
 S ^BITEMP($J,I)=BI31_BIERR
 Q
 ;
 ;
 ;----------
ERROUT(BIERR,I) ;EP
 ;---> Save next line for Error Code File if ever used.
 ;---> If necessary, use I>1 to avoid overwriting valid data.
 ;D ERRCD^BIUTL2(BIERR,.BIERR)
 S:'$G(I) I=1
 S ^BITEMP($J,I)=BI31_BIERR
 Q
 ;
 ;
PASSERR(BIGBL,BIERR) ;EP
 ;---> If the RPC routine calling the BI Generic Lookup above
 ;---> detects a specific error prior to the call and wants to pass
 ;---> that error in the result global rather than a generic error,
 ;---> then a call to this function (PASSERR) can be made.
 ;---> This call will store the error text passed in the result global.
 ;---> The calling routine should then quit (abort its call to the
 ;---> BI Generic Lookup function above).
 ;
 ;---> Parameters:
 ;     1 - BIGBL  (ret) Name of result global for Broker.
 ;     2 - BIERR  (req) Text of error to be stored in result global.
 ;
 S:$G(BIERR)="" BIERR="Error not passed (software error)."
 ;
 N BI31 S BI31=$C(31)_$C(31)
 K ^BITMP($J),^BITEMP($J)
 S BIGBL="^BITEMP("_$J_")"
 S ^BITEMP($J,1)=BI31_BIERR
 Q

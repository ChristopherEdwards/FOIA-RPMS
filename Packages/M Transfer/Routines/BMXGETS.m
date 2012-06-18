BMXGETS ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;;Horace Whitt
 ;;Interface to GETS^DIQ
 ;
 ;----------
GETS(BMXGBL,BMXFL,BMXIENS,BMXFLDS,BMXFLG,BMXMC,BMXNUM) ;EP
 ;---> The final record (node) contains Error Delimiter,
 ;     $C(31)_$C(31), followed by error text, if any.
 ;
 ;---> Parameters:
 ;     1 - BMXGBL   (ret) Name of result global for Broker.
 ;     2 - BMXFL    (req) File number for lookup.
 ;     3 - BMXFLDS  (req) Fields to return w/each entry in IENS format.
 ;     4 - BMXFLG   (opt) Flags - See GETS^DIQ documentation
 ;     9 - BMXMC    (opt) Mixed Case: 1=mixed case, 0=no change.
 ;                        (Converts data in uppercase to mixed case.)
 ;     6 - BMXNUM   (opt) Include IEN as first returned field (1=true)
 ;
 ;---> Set variables, kill temp globals.
 N BMX31
 S BMX31=$C(31)_$C(31)
 S BMXGBL="^BMXTEMP("_$J_")",BMXERR="",U="^"
 K ^BMXTMP($J),^BMXTEMP($J)
 ;
 ;---> If file number not provided, return error.
 I '$G(BMXFL) D ERROUT("File number not provided.",1) Q
 ;
 I $G(BMXFLDS)="" S BMXFLDS=".01"
 ;
 ;---> Set Target Global for output and errors.
 S BMXG="^BMXTMP($J)"
 ;
 ;---> If Mixed Case not set, set to No Change.
 I '$D(BMXMC) S BMXMC=0
 ;
 ;---> If Return IEN not set, set to No
 I '$D(BMXNUM) S BMXNUM=0
 S BMXNUM=+BMXNUM
 ;
 ;---> Fileman call
 D GETS^DIQ(BMXFL,BMXIENS,BMXFLDS,BMXFLG,BMXG,BMXG)
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
 N I,N,X,F,ASDX,ASDC,ASDXFNUM,ASDXFNAM
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
 I BMXNUM S $P(ASDX,"^",1)="IEN"
 ;F ASDC=1:1:$L(BMXFLDS,";") D
 S ASDC=1
 S ASDXFNUM=0
 F  S ASDXFNUM=$O(^BMXTMP($J,BMXFL,BMXIENS,ASDXFNUM)) Q:'ASDXFNUM  D
 . ;S ASDXFNUM=$P(BMXFLDS,";",ASDC)
 . S ASDXFNAM=$P(^DD(BMXFL,ASDXFNUM,0),"^")
 . S:ASDXFNAM="" ASDXFNAM="UNKNOWN"_ASDC
 . S $P(ASDX,"^",ASDC+BMXNUM)=ASDXFNAM
 . S ASDC=ASDC+1
 S ^BMXTEMP($J,1)=ASDX_$C(30)
 ;---> Write valid results.
AAA ;---> Loop through results global
 S I=2,N=0 F  S N=$O(^BMXTMP($J,BMXFL,N)) Q:'N  D
 . S X="",F=0
 . I BMXNUM S X=+N
 . F  S F=$O(^BMXTMP($J,BMXFL,N,F)) Q:'F  D
 . . S:X'="" X=X_U
 . . I $P(^DD(BMXFL,F,0),U,2) D  I 1 ;Multiple or WP
 . . . ;Get the subfile number into FL1
 . . . S FL1=+$P(^DD(BMXFL,F,0),U,2)
 . . . S FLD1=$O(^DD(FL1,0))
 . . . I $P(^DD(FL1,FLD1,0),U,2)["W" D  ;WP
 . . . . S WPL=0 F  S WPL=$O(^BMXTMP($J,BMXFL,N,F,WPL)) Q:'WPL  D
 . . . . . S X=X_^BMXTMP($J,BMXFL,N,F,WPL)_" "
 . . . . . Q
 . . . . Q
 . . . D  ;It's a multiple.  Implement in next phase
 . . . . Q  ;
 . . . Q
 . . E  D  ;Not a multiple
 . . . S X=X_^BMXTMP($J,BMXFL,N,F)
 . . . Q
 . . Q
 . ;---> Convert data to mixed case if BMXMC=1.
ZZZ . S:BMXMC X=$$T^BMXTRS(X)
 . ;
 . ;---> Set data in result global.
 . S ^BMXTEMP($J,I)=X_$C(30)
 . S I=I+1
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

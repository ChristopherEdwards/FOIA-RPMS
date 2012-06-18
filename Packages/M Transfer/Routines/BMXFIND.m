BMXFIND ; IHS/OIT/HMW - BMX GENERIC FIND ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
TABLE(BMXGBL,BMXFL)    ;EP
 ;
 ;---> If file number not provided check for file name.
 ;S ^HW("BMXTABLE")=BMXFL
 S BMX31=$C(31)_$C(31)
 I +BMXFL'=BMXFL D
 . S BMXFL=$TR(BMXFL,"_"," ")
 . I '$D(^DIC("B",BMXFL)) S BMXFL="" Q
 . S BMXFL=$O(^DIC("B",BMXFL,0))
 I '$G(BMXFL) D ERROUT("File number not provided.",1) Q
 D FIND(.BMXGBL,BMXFL,"*",,,10,,,,1)
 Q
 ;
FIND(BMXGBL,BMXFL,BMXFLDS,BMXFLG,BMXIN,BMXMX,BMXIX,BMXSCR,BMXMC,BMXNUM) ;EP
 ;
 ;TODO:
 ; -- Return column info even if no rows returned
 ;
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
 ;    10 - BMXNUM   (opt) Include IEN in returned recordset (1=true)
 ;
 ;---> Set variables, kill temp globals.
 ;N (BMXGBL,BMXFL,BMXFLDS,BMXFLG,BMXIN,BMXMX,BMXIX,BMXSCR,BMXMC)
 S BMX31=$C(31)_$C(31)
 S BMXGBL="^BMXTEMP("_$J_")",BMXERR="",U="^"
 K ^BMXTMP($J),^BMXTEMP($J)
 ;
 ;---> If file number not provided check for file name.
 I +BMXFL'=BMXFL D
 . I '$D(^DIC("B",BMXFL)) S BMXFL="" Q
 . S BMXFL=$O(^DIC("B",BMXFL,0))
 I '$G(BMXFL) D ERROUT("File number not provided.",1) Q
 ;
 ;---> If no fields provided, pass .01.
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
 ;---> If Return IEN not set, set to No
 I '$D(BMXNUM) S BMXNUM=0
 S BMXNUM=+BMXNUM
 ;
 ;---> Silent Fileman call.
 D
 .I $G(BMXIN)="" D  Q
 ..D LIST^DIC(BMXFL,,,,BMXMX,0,,BMXIX,BMXSCR,,BMXG,BMXG)
 .D FIND^DIC(BMXFL,,,BMXFLG,BMXIN,BMXMX,BMXIX,BMXSCR,,BMXG,BMXG)
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
 ;---> Write valid results.
 ;---> Loop through the IEN node (...2,N) of the temp global.
 ;     and call GETS^DIQ for each record
 N I,N,X S N=0
 S BMXA="A"
 ;B
 S I=0
 S BMXFLDF=0
RESULTS F  S N=$O(^BMXTMP($J,"DILIST",2,N)) Q:'N  D
 . S X=^BMXTMP($J,"DILIST",2,N)
 . S I=I+1
 . K A
 . D GETS^DIQ(BMXFL,X_",",BMXFLDS,,BMXA,BMXA)
 . ;--->Once only, write field names
 . D:'BMXFLDF FIELDS
 . ;
 . ;
 . ;---> Loop through results global
 . S F=0,BMXCNT=0
 . F  S F=$O(A(BMXFL,X_",",F)) Q:'F  S BMXCNT=BMXCNT+1
 . S F=0
 . S BMXREC=""
 . S:BMXNUM ^BMXTEMP($J,I)=X_"^"
 . S BMXCNTB=0
 . S BMXORD=BMXNUM
 . F  S F=$O(A(BMXFL,X_",",F)) Q:'F  S BMXCNTB=BMXCNTB+1 D  S:BMXCNTB<BMXCNT ^BMXTEMP($J,I)=^BMXTEMP($J,I)_U
 . . S BMXORD=BMXORD+1
 . . I $P(^DD(BMXFL,F,0),U,2) D  I 1 ;Multiple or WP
 . . . ;Get the subfile number into FL1
 . . . S FL1=+$P(^DD(BMXFL,F,0),U,2)
 . . . S FLD1=$O(^DD(FL1,0))
 . . . I $P(^DD(FL1,FLD1,0),U,2)["W" D  ;WP
 . . . . S WPL=0,BMXLTMP=0
 . . . . F  S WPL=$O(A(BMXFL,X_",",F,WPL)) Q:'WPL  S I=I+1 D
 . . . . . S ^BMXTEMP($J,I)=A(BMXFL,X_",",F,WPL)_" "
 . . . . . S BMXLTMP=BMXLTMP+$L(A(BMXFL,X_",",F,WPL))+1
 . . . . . Q
 . . . . S:BMXLTMP>BMXLEN(BMXORD) BMXLEN(BMXORD)=BMXLTMP
 . . . . Q
 . . . D  ;It's a multiple.  Implement in next phase
 . . . . Q  ;
 . . . Q
 . . E  D  ;Not a multiple
 . . . S I=I+1
 . . . S ^BMXTEMP($J,I)=A(BMXFL,X_",",F)
 . . . S:$L(A(BMXFL,X_",",F))>BMXLEN(BMXORD) BMXLEN(BMXORD)=$L(A(BMXFL,X_",",F))
 . . . Q
 . . Q
 . ;---> Convert data to mixed case if BMXMC=1.
 . ;S:BMXMC BMXREC=$$T^BMXTRS(BMXREC)
 . ;---> Set data in result global.
 . S ^BMXTEMP($J,I)=^BMXTEMP($J,I)_$C(30)
 ;
 ;---> If no results, report it as an error.
 D:'$O(^BMXTEMP($J,0))
 .I BMXIN]"" S BMXERR="No entry matches """_BMXIN_"""." Q
 .S BMXERR="Either the lookup file is empty"
 .S BMXERR=BMXERR_" or all entries are screened (software error)."
 ;
 ;---> Tack on Error Delimiter and any error.
 S I=I+1
 S ^BMXTEMP($J,I)=BMX31_BMXERR
 ;---> Column types and widths
 S C=0
 F  S C=$O(BMXLEN(C)) Q:'C  D
 . I BMXLEN(C)>99999 S BMXLEN(C)=99999
 . S ^BMXTEMP($J,C)=BMXTYP(C)_$$NUMCHAR(BMXLEN(C))_^BMXTEMP($J,C)
 Q
 ;
 ;
NUMCHAR(BMXN)      ;EP
 ;---> Returns Field Length left-padded with 0
 ;
 N BMXC
 S BMXC="00000"_BMXN
 Q $E(BMXC,$L(BMXC)-4,$L(BMXC))
 ;
 ;---> Dead code follows
 N C,BMXC,F,N,J
 S BMXC=""
 S N=BMXN
 S:N>99999 N=99999
 S:N<0 N=0
 F J=1:1:$L(N) D
 . S F=10**(J-1)
 . S C=65+(N-((N\(10*F))*(10*F))\F)
 . S C=$C(C)
 . S BMXC=C_BMXC
 S BMXC="AAAAA"_BMXC
 Q $E(BMXC,$L(BMXC)-4,$L(BMXC))
 ;
 ;
FIELDS ;---> Write Field Names
 ;Field name is TAAAAANAME
 ;Where T is the field type (T=Text; D=Date)
 ;      AAAAA is the field size (see NUMCHAR routine)
 ;      NAME is the field name
 S BMXFLDF=1
 K BMXLEN,BMXTYP
 D:$D(A)
 . I BMXNUM S ^BMXTEMP($J,I)="IEN^",BMXLEN(I)=10,BMXTYP(I)="T",I=I+1 ;TODO: Change from text to number
 . S ASDXFNUM=0
 . S BMXIENS=$O(A(BMXFL,0))
 . F  S ASDXFNUM=$O(A(BMXFL,BMXIENS,ASDXFNUM)) Q:'ASDXFNUM  D
 . . S ASDXFNAM=$P(^DD(BMXFL,ASDXFNUM,0),"^") ;Get type here
 . . S ASDXFNAM=$TR(ASDXFNAM," ","_")
 . . S BMXTYP(I)="T"
 . . S BMXLEN(I)=0 ;Start with length zero
 . . S:ASDXFNAM="" ASDXFNAM="UNKNOWN"_I
 . . S ^BMXTEMP($J,I)=ASDXFNAM_"^"
 . . S I=I+1
 . S ^BMXTEMP($J,I-1)=$E(^BMXTEMP($J,I-1),1,$L(^BMXTEMP($J,I-1))-1)_$C(30)
 Q
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

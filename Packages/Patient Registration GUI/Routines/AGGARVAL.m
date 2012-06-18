AGGARVAL ;VNGT/HS/BEE-AGG Alternate Resource RPC Calls ; 07 Apr 2010  7:05 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
MCDELG(DATA,MDESD,MDEED,MDECV,MDELIG) ;EP -- AGG VALIDATE MEDICAID ELIG ENTRY
 ;
 ;Input
 ;  MDESD - AGGMDESD - Medicaid Eligibility Start Date
 ;  MDEED - AGGMDEED - Medicaid Eligibility End Date
 ;  MDECV - AGGMDECV - Medicaid Eligibility Coverage
 ;  MDELIG   - Current list of Eligibility Entries
 ;
 NEW UID,II,LIST,BN,BQ,AGGMDESD,AGGMDEED,AGGMDECV,RESULT,EXPDT,EFFDT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGARVAL",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGARVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT^T00100ERROR"_$C(30)
 ;
 ; Get list of current eligibility entries
 S MDELIG=$G(MDELIG,"")
 I MDELIG="" D
 . S LIST="",BN=""
 . F  S BN=$O(MDELIG(BN)) Q:BN=""  S LIST=LIST_MDELIG(BN)
 . K MDELIG
 . S MDELIG=LIST
 . K LIST
 ;
 ;Parse Parameters
 S (AGGMDESD,AGGMDEED,AGGMDECV)=""
 F BQ=1:1:$L(MDELIG,$C(28)) D
 . N PDATA,NAME,VALUE,BP,BV
 . S PDATA=$P(MDELIG,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1) I NAME="" Q
 . S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 . F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP),@NAME=$G(@NAME)_$S(BP=1:"",1:$C(29))_BV
 ;
 ;Reset Return Result
 S RESULT="1^"
 ;
 ;If no current entries pass test
 I AGGMDESD="" S II=II+1,@DATA@(II)=RESULT_$C(30) G DONE
 ;
 ;Convert dates
 S MDESD=$$DATE^AGGUL1(MDESD) S:MDESD="" MDESD=9999999
 S MDEED=$$DATE^AGGUL1(MDEED) S:MDEED="" MDEED=9999999
 ;
 ;Loop through current entries and check for overlap
 ;
 ;First check for the same coverage
 F BQ=1:1:$L(AGGMDESD,$C(29)) D  I RESULT'="1^" Q
 . ;
 . ;Check for overlapping date range
 . S EXPDT=$$DATE^AGGUL1($P($P(AGGMDEED,$C(29),BQ)," ")) S:EXPDT="" EXPDT=9999999
 . S EFFDT=$$DATE^AGGUL1($P($P(AGGMDESD,$C(29),BQ)," ")) S:EFFDT="" EFFDT=0
 . ;
 . ;Cannot have same start date
 . I MDESD=EFFDT S RESULT="-1^" Q
 . ;
 . ;Check coverage
 . I MDECV'=$P(AGGMDECV,$C(29),BQ) Q
 . ;
 . ;Other date checks
 . I MDESD'<EFFDT,MDESD'>EXPDT S RESULT="-1^" Q
 . I MDEED'<EFFDT,MDEED'>EXPDT S RESULT="-1^" Q
 . I MDESD<EFFDT,MDEED>EXPDT S RESULT="-1^" Q
 . Q
 I RESULT="-1^" S RESULT=RESULT_"YOU HAVE ENTERED A COVERAGE DATE RANGE WHICH OVERLAPS WITH ANOTHER ALREADY EXISTING FOR THIS PATIENT! THE ENTRY WILL NOT BE ALLOWED!"
 ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 ;
 ;Clear out variables
 F BQ=1:1:$L(MDELIG,$C(28)) S NAME=$P($P(MDELIG,$C(28),BQ),"=") I NAME]"" K @NAME
 ;
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
MCDACT(RIEN) ;Check if Medicaid Entry is Active
 ;
 ;Input: RIEN - ^AUPNMCD Pointer
 ;Output: ACTIVE/INACTIVE
 ;
 N RESULT,IEN,EFFDT,EXPDT
 ;
 S (RESULT,IEN)=0 F  S IEN=$O(^AUPNMCD(RIEN,11,IEN)) Q:'IEN  D  I RESULT=1 Q
 . S EFFDT=$$GET1^DIQ(9000004.11,IEN_","_RIEN_",",.01,"I") S:EFFDT="" EFFDT=0
 . S EXPDT=$$GET1^DIQ(9000004.11,IEN_","_RIEN_",",.02,"I") S:EXPDT="" EXPDT=9999999
 . I DT'<EFFDT,DT'>EXPDT S RESULT=1
 ;
 S RESULT=$S(RESULT=1:"ACTIVE",1:"INACTIVE")
 Q RESULT
 ;
MCRACT(DFN) ;Check if Medicare Entry is Active
 ;
 ;Input: DFN - ^AUPNMCR Pointer
 ;Output: ACTIVE/INACTIVE/Null-For no Medicare
 ;
 N RESULT,IEN,EFFDT,EXPDT
 ;
 I '$D(^AUPNMCR(DFN)) Q ""
 S (RESULT,IEN)=0 F  S IEN=$O(^AUPNMCR(DFN,11,IEN)) Q:'IEN  D  I RESULT=1 Q
 . S EFFDT=$$GET1^DIQ(9000003.11,IEN_","_DFN_",",.01,"I") S:EFFDT="" EFFDT=0
 . S EXPDT=$$GET1^DIQ(9000003.11,IEN_","_DFN_",",.02,"I") S:EXPDT="" EXPDT=9999999
 . I DT'<EFFDT,DT'>EXPDT S RESULT=1
 ;
 S RESULT=$S(RESULT=1:"ACTIVE",1:"INACTIVE")
 Q RESULT
 ;
PVTACT(IENS) ;Check if Private Insurance entry is active for patient
 ;Check member info first and if blank look at policy holder info
 ; 
 ;Input: IENS - Lookup string to ^AUPNPRVT entry
 ;Ouput: ACTIVE/INACTIVE/Null - For no information
 NEW POLIEN,EFFDT,EXPDT,RESULT
 ;
 I $G(IENS)="" Q ""
 S RESULT=""
 ;
 ;First look for member effective/expiration dates
 S EFFDT=$$GET1^DIQ(9000006.11,IENS,.06,"I")
 S EXPDT=$$GET1^DIQ(9000006.11,IENS,.07,"I")
 I EFFDT]""!(EXPDT]"") D  Q RESULT
 . S:EFFDT="" EFFDT=0
 . S:EXPDT="" EXPDT=9999999
 . I DT'<EFFDT,DT'>EXPDT S RESULT="ACTIVE" Q
 . S RESULT="INACTIVE"
 ;
 ;If no member effective/expiration dates look at policy holder
 S POLIEN=$$GET1^DIQ(9000006.11,IENS,.08,"I")
 I POLIEN="" Q ""
 S EFFDT=$$GET1^DIQ(9000003.1,POLIEN_",",.17,"I") S:EFFDT="" EFFDT=0
 S EXPDT=$$GET1^DIQ(9000003.1,POLIEN_",",.18,"I") S:EXPDT="" EXPDT=9999999
 I DT'<EFFDT,DT'>EXPDT Q "ACTIVE"
 Q "INACTIVE"
 ;
INIT(DATA,RIEN,DFN) ;EP - AGG MEDICAID INIT TRIG
 ; Input
 ;   RIEN - Pointer to the Patient's Medicaid Entry
 ;   DFN - Patient IEN
 ;
 NEW UID,II,HDR,SOURCE,HELP,TYPE,VALUE,ABLE,VISIBLE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGUPMCR",UID))
 K @DATA
 ;
 S II=0,RIEN=$G(RIEN)
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGARVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 D HDR^AGGWTRIG
 S @DATA@(II)=HDR_$C(30)
 ;
 S RIEN=$G(RIEN)
 ;
 ;Always disable Date of Last Update field
 S SOURCE="AGGLSTDT",HELP="",TYPE="D",VALUE="" S:RIEN]"" VALUE=$$FMTE^AGGUL1($$GET1^DIQ(9000004,RIEN_",",.08,"I")) S ABLE="N" S:VALUE="" VISIBLE="N" D UP^AGGWTRIG
 S:RIEN="" SOURCE="AGGMDNME",HELP="",TYPE="X",VALUE=$$GET1^DIQ(2,DFN_",",.01,"E"),ABLE="Y",VISIBLE="Y" D UP^AGGWTRIG
 S:RIEN="" SOURCE="AGGMDDOB",HELP="",TYPE="D",VALUE=$$FMTE^AGGUL1($$GET1^DIQ(2,DFN_",",.03,"I")),ABLE="Y",VISIBLE="Y" D UP^AGGWTRIG
 ;
XINIT S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
VAL(DATA,VFILE,PARMS) ;EP -- AGG MEDICARE ELIG VAL
 ;
 ;Input
 ;  VFILE - The vfile number or name
 ;  PARMS - The parameters being checked for validation
 ;
 NEW UID,II,BQ,LIST,BN,PDATA,NAME,VALUE,HDR,CODN,VALID,VALFLD,BI,VFLD,TYPE,X,RESULT,AGGMCCOV
 NEW VFIEN,MSG,HNDLR,IEN,CODE,REVAL,MCELIG
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGARVAL",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGARVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S VFILE=$G(VFILE,"") I VFILE="" S BMXSEC="RPC Failed: No Window selected" Q
 S VFIEN=$O(^AGG(9009068.3,"B",VFILE,""))
 ;
 S @DATA@(II)="I00010RESULT^T00100MSG^T00001HANDLER^I00010IEN^T00008CODE^T00100REVALIDATE"_$C(30)
 ; Get list of parameters
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 I PARMS="" S II=II+1,@DATA@(II)="1^"_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_U_$G(CODE)_U_$G(REVAL)_$C(30) G XDONE
 ;
 ;Special Handling for Type of Coverage Validation - Multiple Field Passed
 I $P($P(PARMS,$C(28)),"=")="AGGMCCOV" D
 .S AGGMCCOV=$P($P(PARMS,$C(28)),"=",2)
 .S MCELIG=$P(PARMS,"MCELIG=",2)
 .S CODN=$O(^AGG(9009068.3,VFIEN,10,"B","Type of Coverage","")) Q:CODN=""
 .S VALID=$P($G(^AGG(9009068.3,VFIEN,10,CODN,2)),U,2)
 .S VALFLD=$P($G(^AGG(9009068.3,VFIEN,10,CODN,2)),U,1)
 ;
 ;Regular Parameter Parsing
 I $P($P(PARMS,$C(28)),"=")'="AGGMCCOV" F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . I NAME["{"!(NAME["}") S NAME=$$STRIP^XLFSTR(NAME,"{}")
 . S @NAME=VALUE
 . ; If value is DFN, it exists at the PCC Visit level not individual
 . ; V File level.
 . I VFILE'=9000010&(NAME="DFN"!(NAME="APCDDATE")) Q
 . S CODN=$O(^AGG(9009068.3,VFIEN,10,"AC",NAME,""))
 . I CODN="" S BMXSEC="RPC Failed: Parameter does not exist for this Window" Q
 . I $G(VALID)="" S VALID=$P($G(^AGG(9009068.3,VFIEN,10,CODN,2)),U,2)
 . I $G(VALFLD)="" S VALFLD=$P($G(^AGG(9009068.3,VFIEN,10,CODN,2)),U,1)
 ;
 ; Check that values exist for all fields needed for the validation
 F BI=1:1:$L(VALFLD,";") S VFLD=$P(VALFLD,";",BI) D
 . I VFLD["*" S VFLD=$$STRIP^XLFSTR(VFLD,"*") Q
 . I VFLD["{"!(VFLD["}") S VFLD=$$STRIP^XLFSTR(VFLD,"{}") Q
 . I $G(@VFLD)="" S BMXSEC="RPC Failed: Missing validation value for "_VFLD
 I $G(BMXSEC)'="" Q
 ;
 S VALID=$TR(VALID,"~","^"),RESULT=0
 ; Execute the validation tag
 D @VALID
 S II=II+1,@DATA@(II)=RESULT_U_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_U_$G(CODE)_U_$G(REVAL)_$C(30)
 ; Clean up validation variables
 F BI=1:1:$L(VALFLD,";") D
 . S VFLD=$P(VALFLD,";",BI),VFLD=$$STRIP^XLFSTR(VFLD,"*"),VFLD=$$STRIP^XLFSTR(VFLD,"{}")
 . K @VFLD
 ;
XDONE ;
 S II=II+1,@DATA@(II)=$C(31)
 S NAME=""
 F  S NAME=$O(^AGG(9009068.3,VFIEN,10,"AC",NAME)) Q:NAME=""  K @NAME
 Q
 ;
PRTD(TYPCV,MCELIG) ;EP - New Part D Check for current Part A/B
 N BQ
 S RESULT=-1,MSG=""
 I TYPCV'="D" S RESULT=1 Q
 F BQ=1:1:$L(MCELIG,$C(28)) D  Q:RESULT=1
 . N PDATA,NAME,VALUE,I
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1)
 . Q:NAME'="AGGMCCOV"
 . S VALUE=$P(PDATA,"=",2,99)
 . F I=1:1:$L(VALUE,$C(29)) I $P(VALUE,$C(29),I)="A"!($P(VALUE,$C(29),I)="B") S RESULT=1 Q
 Q:RESULT=1
 S MSG="Patient must have Medicare Part A or Part B before being eligible for Part D"
 Q
 ;
DTEMS(STRT,END) ; EP - Elig dates validation for Medicare
 S RESULT=1
 S STRT=$$DATE^AGGUL1(STRT),END=$$DATE^AGGUL1(END)
 I $G(STRT)'="",2600000>STRT S RESULT=-1,MSG="Start Date cannot be before 1960" Q
 I $G(STRT)'="",DT+20000<STRT S RESULT=-1,MSG="Start Date cannot be greater than 2 years from today" Q
 ;
 I $G(STRT)'="",$G(END)="" Q
 I $G(STRT)'="",$G(END)'="",STRT<END S RESULT=1 Q
 I $G(STRT)'="",$G(END)'="",STRT>END S RESULT=-1,MSG="Starting date cannot be greater than the Ending date" Q
 Q
 ;
DTEME(END,STRT) ; EP
 S RESULT=1
 S STRT=$$DATE^AGGUL1(STRT),END=$$DATE^AGGUL1(END)
 I $G(END)'="",2600000>END S RESULT=-1,MSG="End Date cannot be before 1960" Q
 I $G(END)'="",DT+20000<END S RESULT=-1,MSG="End Date cannot be greater than 2 years from today" Q
 ;
 I $G(STRT)'="",$G(END)="" Q
 I $G(STRT)'="",$G(END)'="",STRT<END S RESULT=1 Q
 I $G(STRT)'="",$G(END)'="",STRT>END S RESULT=-1,MSG="Ending date cannot be less than the Starting date" Q
 Q

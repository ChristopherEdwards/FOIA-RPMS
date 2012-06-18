BTPWPDSP ;VNGT/HS/BEE - Display CMET Queued Records ; 17 Jul 2008  1:24 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
RET(DATA,CNT,SRC,PARMS) ; EP - BTPW GET QUEUED EVENTS
 ; Input parameters
 ;   CNT   - Count of # of records to return
 ;   SRC   - Values to continue search on
 ;   PARMS - Delimited list of input variables
 ;             -> STATUS  - Status
 ;             -> TMFRAME - Time frame
 ;             -> CAT     - Category
 ;             -> COMM    - Community
 ;             -> COMMTX  - Community Taxonomy
 ;
 NEW UID,II,STATUS,TMFRAME,CAT,COMM,COMMTX,BQ,CIN,BDT,QFL,CATLST,EDT,OSTAT,CMIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPDSP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPDSP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Re-Assemble parameter list if in an array
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Set up incoming variables
 S (CAT,STATUS,TMFRAME,COMM,COMMTX,CMIEN)=""
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 .N PDATA,NAME,VALUE,BP,BV
 .S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 .S NAME=$P(PDATA,"=",1) Q:NAME=""
 .S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 .F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP),@NAME=@NAME_$S(BP=1:"",1:$C(29))_BV
 ;
 ;Initialize/save original values
 S OSTAT=STATUS
 S SRC=$G(SRC,"")
 S CNT=+$G(CNT)
 ;
 ;Handle blank status
 S:STATUS="" STATUS="P"_$C(29)_"N"_$C(29)_"S"_$C(29)_"T"
 ;
 ;Set up search beginning/end dates
 S (BDT,EDT)=""
 I TMFRAME'="" D
 . I $E(TMFRAME,1)=">" S TMFRAME=$E(TMFRAME,2,99),EDT=$$DATE^BQIUL1(TMFRAME) Q
 . S BDT=$$DATE^BQIUL1(TMFRAME)
 ;
 ;Set up Community Taxonomy
 I COMMTX'="" D
 . N CM,TREF
 . S TREF="COMM" K @TREF
 . D BLD^BQITUTL(COMMTX,TREF)
 . S CM="" F  S CM=$O(COMM(CM)) Q:CM=""  S COMM=$G(COMM)_$S($G(COMM)]"":$C(29),1:"")_CM K COMM(CM)
 ;
 ;Set up Category List Array
 I CAT'="",CAT'=0 D
 . F BQ=1:1:$L(CAT,$C(29)) S CIN=$P(CAT,$C(29),BQ),CATLST(CIN)=""
 ;
 ;Set up Community List Array
 S:'$D(COMM) COMM=""
 I COMM'="",COMM'=0 D
 . F BQ=1:1:$L(COMM,$C(29)) S CIN=+$P(COMM,$C(29),BQ),COMM(CIN)=$P(^AUTTCOM(CIN,0),U,1)
 ;
 S @DATA@(II)="I00010HIDE_DFN^T00001SENS_FLAG^T00035PATIENT_NAME^T00030HRN^D00015DOB^T00001SEX^"
 S @DATA@(II)=@DATA@(II)_"T00040CATEGORY^I00010HIDE_CMET_IEN^T00010STATUS^I00010HIDE_EVENTTYPE_IEN^T00060EVENT^D00015EVNT_DATE^I00010HIDE_VISIT_IEN^"
 S @DATA@(II)=@DATA@(II)_"T00001COMM_FLAG^D00030RESULT^T01024HIDE_RESULT^T00050COMMUNITY^T00035DPCP^T00120DCAT^"
 S @DATA@(II)=@DATA@(II)_"T00010AGE^D00030LAST_MODIFIED_DT^T00030LAST_MODIFIED_BY^T01024STATUS_COMMENT^T01024HIDE_SEARCH"_$C(30)
 ;
 S QFL=0
 ;
 ;Search 0 - List of CMIENs
 I $G(CMIEN)'="" D CMIEN(CMIEN,.COMM,SRC) G DONE
 ;
 ;Search 1 - COMMUNITY, STATUS, VISIT DATE - INACTIVE
 ;I COMM'="",TMFRAME'="" D CMSTVD(STATUS,BDT,EDT,.COMM,.CATLST,SRC) G DONE
 ;
 ;Search 2 - CATEGORY, STATUS, VISIT DATE
 I CAT'="",TMFRAME'="" D CSVD(CAT,STATUS,.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 3 - STATUS, VISIT DATE
 I OSTAT'="",TMFRAME'="" D SV(STATUS,.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 4 - VISIT DATE
 I TMFRAME'="" D VD(.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 5 - Default search on STATUS
 D ST(.COMM,.CATLST,STATUS,SRC)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CAT(PIEN,TYP) ; EP - Get Procedure Category
 NEW CAT
 S TYP=$G(TYP,0)
 I 'TYP S CAT=$$GET1^DIQ(90621,PIEN_",",.1,"E")
 I TYP S CAT=$$GET1^DIQ(90621,PIEN_",",.1,"I")
 Q CAT
 ;
SCOMM(QIEN) ;EP - Get Status Comments
 N SIEN,SCOMM
 S SCOMM=""
 S SIEN=0
 F  S SIEN=$O(^BTPWQ(QIEN,3,SIEN)) Q:'SIEN  D
 . S SCOMM=SCOMM_$S(SCOMM]"":" ",1:"")_$G(^BTPWQ(QIEN,3,SIEN,0))
 Q SCOMM
 ;
REC(QIEN,COMM) ; EP - Assemble Single Record
 NEW TDATA,PROC,PROCNM,CAT,VISIT,PRCDT,STAT,DFN,PTNAME,DOB,HRN,PCOM,PTAGE,LMDT,LMBY,SCOMM,SIEN,SEX,TIEN,RES,DPCP,DXTG,HRES
 S TDATA=^BTPWQ(QIEN,0)
 S DFN=$P(TDATA,U,2)
 ;
 ;Community Check
 S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 I COMM'="",PCOM'="",'$D(COMM(PCOM)) Q
 I PCOM'="" S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"E")
 ;
 S PROC=$P(TDATA,U,1),PROCNM=$P(^BTPW(90621,PROC,0),U,1)
 S CAT=$$CAT(PROC)
 S VISIT=$P(TDATA,U,4)
 S PRCDT=$$FMTE^BQIUL1($P(TDATA,U,3))
 S STAT=$$GET1^DIQ(90629,QIEN_",",.08,"E")
 S HRN=$TR($$HRNL^BQIULPT(DFN),";",$C(10))
 S PTNAME=$$GET1^DIQ(2,DFN_",",.01,"E")
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I")
 S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 S TIEN=$P(TDATA,U,14)
 ;
 ;Result
 S RES=$$QLNK^BTPWPTRG(QIEN,.06),HRES=$P(RES,$C(28),2,3),RES=$P(RES,$C(28))
 ;
 ;DPCP/Active DX Tags
 S DPCP=$P($$DPCP^BQIULPT(DFN),U,2)
 S DXTG=$$DCAT^BQIULPT(DFN)
 ;
 S PTAGE=$$AGE^BQIAGE(DFN,,1)
 S LMDT=$$FMTE^BQIUL1($P(TDATA,U,11))
 S LMBY=$P(TDATA,U,12)
 ;
 ;Retrieve Status Comments
 S SCOMM=$$SCOMM(QIEN)
 ;
 S II=II+1,@DATA@(II)=DFN_U_$$SENS^BQIULPT(DFN)_U_PTNAME_U_HRN_U_DOB_U_SEX_U_CAT_U_QIEN_U_STAT_U_PROC_U_PROCNM_U_PRCDT_U_VISIT_U_$$CALR^BQIULPT(DFN)_U_RES_U_HRES_U_PCOM_U_DPCP_U_DXTG_U_PTAGE_U_LMDT_U_LMBY_U_SCOMM_U_SRC_$C(30)
 Q
 ;
ST(COMM,CTLST,STATUS,OSRC) ;EP - Search 5 - Default search on STATUS
 N IEN,CT,LII,STS,STSP,SRC,SFND,SSTRT
 ;
 ;Pull the last record info
 S SSTRT=1,STS=$P(OSRC,$C(29),2) I STS]"" F SFND=1:1:$L(STATUS,$C(29)) I $P(STATUS,$C(29),SFND)=STS S SSTRT=SFND
 S IEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 F STSP=SSTRT:1:$L(STATUS,$C(29)) S STS=$P(STATUS,$C(29),STSP) D  Q:QFL
 . F  S IEN=$O(^BTPWQ("AC",STS,IEN)) Q:IEN=""  D  Q:QFL
 .. S LII=II,SRC=IEN_$C(29)_STS
 .. ;
 .. ;Check for CATEGORY - if passed
 .. N CTG,CTGCHK S CTGCHK=1
 .. I $D(CTLST) D  Q:'CTGCHK
 ... S CTG=$$GET1^DIQ(90629,IEN_",",.13,"I")
 ... I CTG]"",$D(CTLST(CTG)) Q
 ... S CTGCHK=0
 .. K CTG,CTGCHK
 .. ;
 .. D REC(IEN,.COMM)
 .. I LII=II Q
 .. S CT=CT+1 I CNT,CT=CNT S QFL=1 Q
 Q
 ;
CMIEN(CMIEN,COMM,OSRC) ; EP - Search 0 - List of IENs
 N IEN,CT,LII,ISTRT,IFND,ILST,ITSP,SRC
 ;
 ;Pull the last record info
 S IEN=$G(OSRC)
 ;
 S CT=0
 ;
 ;Loop through the CMIEN list (at selected point) and retrieve records
 S ISTRT=1 I IEN]"" F IFND=1:1:$L(CMIEN,$C(29)) I $P(CMIEN,$C(29),IFND)=IEN S ISTRT=IFND
 F ITSP=ISTRT:1:$L(CMIEN,$C(29)) S IEN=$P(CMIEN,$C(29),ITSP) D  Q:QFL
 . S LII=II,SRC=IEN
 . D REC(IEN,.COMM)
 . I LII=II Q
 . S CT=CT+1 I CNT,CT=CNT S QFL=1 Q
 Q
 ;
VD(COMM,BDT,EDT,OSRC) ; EP - Search 4 - VISIT DATE
 N IEN,SBDT,CT,LII,SRC
 ;
 ;Pull the last record info
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S IEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F  S SBDT=$O(^BTPWQ("AH",SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 . F  S IEN=$O(^BTPWQ("AH",SBDT,IEN)) Q:IEN=""  D  Q:QFL
 .. S LII=II,SRC=IEN_$C(29)_SBDT
 .. D REC(IEN,.COMM)
 .. I LII=II Q
 .. S CT=CT+1 I CNT,CT=CNT S QFL=1 Q
 Q
 ;
SV(STATUS,COMM,BDT,EDT,OSRC) ; EP - Search 3 - STATUS, VISIT DATE
 N IEN,SBDT,CT,LII,STSP,SRC,SFND,STS,SSTRT
 ;
 ;Pull the last record info
 S SSTRT=1,STS=$P(OSRC,$C(29),3) I STS]"" F SFND=1:1:$L(STATUS,$C(29)) I $P(STATUS,$C(29),SFND)=STS S SSTRT=SFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S IEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F STSP=SSTRT:1:$L(STATUS,$C(29)) S STS=$P(STATUS,$C(29),STSP) D  Q:QFL
 . F  S SBDT=$O(^BTPWQ("AF",STS,SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 .. F  S IEN=$O(^BTPWQ("AF",STS,SBDT,IEN)) Q:IEN=""  D  Q:QFL
 ... S LII=II,SRC=IEN_$C(29)_SBDT_$C(29)_STS
 ... D REC(IEN,.COMM)
 ... I II=LII Q
 ... S CT=CT+1 I CNT,CT=CNT S QFL=1 Q
 . S SBDT=$S(BDT]"":BDT-.001,1:"")  ;Reset to original start date
 Q
 ;
CSVD(CATS,STATUS,COMM,BDT,EDT,OSRC) ; EP - Search 2 - CATEGORY, STATUS, VISIT DATE
 N IEN,SBDT,CT,LII,CATP,CAT,CSTRT,CFND,STSP,STS,SRC,SFND,SSTRT
 ;
 ;Pull the last record info
 S CSTRT=1,CAT=$P(OSRC,$C(29),4) I CAT]"" F CFND=1:1:$L(CATS,$C(29)) I $P(CATS,$C(29),CFND)=CAT S CSTRT=CFND
 S SSTRT=1,STS=$P(OSRC,$C(29),3) I STS]"" F SFND=1:1:$L(STATUS,$C(29)) I $P(STATUS,$C(29),SFND)=STS S SSTRT=SFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S IEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F CATP=CSTRT:1:$L(CATS,$C(29)) S CAT=$P(CATS,$C(29),CATP) D  Q:QFL
 . F STSP=SSTRT:1:$L(STATUS,$C(29)) S STS=$P(STATUS,$C(29),STSP) D  Q:QFL
 ..F  S SBDT=$O(^BTPWQ("AG",CAT,STS,SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 ... F  S IEN=$O(^BTPWQ("AG",CAT,STS,SBDT,IEN)) Q:IEN=""  D  Q:QFL
 .... S LII=II,SRC=IEN_$C(29)_SBDT_$C(29)_STS_$C(29)_CAT
 .... D REC(IEN,.COMM)
 .... I II=LII Q
 .... S CT=CT+1 I CNT,CT=CNT S QFL=1 Q
 .. S SBDT=$S(BDT]"":BDT-.001,1:"")  ;Reset to original start date
 . S SSTRT=1  ;Reset to 1 for later categories
 Q
 ;
CMSTVD(STATUS,BDT,EDT,COMM,CTLST,OSRC) ; EP - Search 1 - COMMUNITY, STATUS, VISIT DATE - Now INACTIVE
 N CM,IEN,SBDT,CT,LII,COMP,CSTRT,CFND,STSP,STS,SRC,SFND,SSTRT
 ;
 ;Pull the last record info
 S CSTRT=1,CM=$P(OSRC,$C(29),4) I CM]"" F CFND=1:1:$L(COMM,$C(29)) I $P(COMM,$C(29),CFND)=CM S CSTRT=CFND
 S SSTRT=1,STS=$P(OSRC,$C(29),3) I STS]"" F SFND=1:1:$L(STATUS,$C(29)) I $P(STATUS,$C(29),SFND)=STS S SSTRT=SFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S IEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F COMP=CSTRT:1:$L(COMM,$C(29)) S CM=$P(COMM,$C(29),COMP) D  Q:QFL
 . F STSP=SSTRT:1:$L(STATUS,$C(29)) S STS=$P(STATUS,$C(29),STSP) D  Q:QFL
 .. F  S SBDT=$O(^BTPWQ("AI",CM,STS,SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 ... F  S IEN=$O(^BTPWQ("AI",CM,STS,SBDT,IEN)) Q:IEN=""  D  Q:QFL
 .... S LII=II,SRC=IEN_$C(29)_SBDT_$C(29)_STS_$C(29)_CM
 .... ;
 .... ;Check for CATEGORY - if passed
 .... N CTG,CTGCHK S CTGCHK=1
 .... I $D(CTLST) D  Q:'CTGCHK
 ..... S CTG=$$GET1^DIQ(90629,IEN_",",.13,"I")
 ..... I CTG]"",$D(CTLST(CTG)) Q
 ..... S CTGCHK=0
 .... K CTG,CTGCHK
 .... ;
 .... D REC(IEN,.COMM)
 .... I II=LII Q
 .... S CT=CT+1 I CNT,CT=CNT S QFL=1 Q
 .. S SBDT=$S(BDT]"":BDT-.001,1:"")  ;Reset to original start date
 . S SSTRT=1  ;Reset to 1 for later communities
 Q
 ;
RES(QIEN) ;EP - Calculate Result field value
 N TDATA,PRCDT,RES
 S TDATA=$G(^BTPWQ(QIEN,0))
 S PRCDT=$$FMTE^BQIUL1($P(TDATA,U,3))
 S RES=$$QLNK^BTPWPTRG(QIEN,.06)
 S:RES]"" RES=PRCDT_$C(28)_$P(RES,$C(26),2)_$C(28)_$P(RES,$C(26),3)
 Q RES
 ;
EVTCOM(TIEN) ;EP - Get Event Comments - called by 90506.1 - BTPWQECM
 N SIEN,SCOMM
 S SCOMM=""
 S SIEN=0
 F  S SIEN=$O(^BTPWP(TIEN,4,SIEN)) Q:'SIEN  D
 . S SCOMM=SCOMM_$S(SCOMM]"":" ",1:"")_$G(^BTPWP(TIEN,4,SIEN,0))
 Q SCOMM
 ;
FNDCMT(TIEN) ;EP - Get Findings Comments - 90506.1 code BTPWTFNC
 N COM,CIEN,CLN,FCOM,FDATA,FIEN
 S COM=""
 ;
 D GETS^DIQ(90620,TIEN_",","10*","IE","FDATA")
 ;
 S FIEN=0 F  S FIEN=$O(FDATA(90620.01,FIEN)) Q:FIEN=""  D
 . ;
 . ;Skip ENTERED IN ERROR
 . I $G(FDATA(90620.01,FIEN,".08","I"))="Y" Q
 . ;
 . I COM'="" S COM=COM_$C(13)_$C(10)
 . ;
 . S CIEN=0 F CLN=1:1 S CIEN=$O(FDATA(90620.01,FIEN,1,CIEN)) Q:'CIEN  D
 .. S FCOM=$G(FDATA(90620.01,FIEN,1,CIEN))
 .. I COM'="" S COM=COM_$C(13)_$C(10)
 .. S COM=COM_FCOM
 ;
 Q COM
 ;
FUPCMT(TIEN) ;EP - Get Followup Comments - 90506.1 code BTPWTFUC
 N COM,CIEN,CLN,FCOM,FDATA,FIEN
 S COM=""
 ;
 D GETS^DIQ(90620,TIEN_",","12*","IE","FDATA")
 ;
 S FIEN=0 F  S FIEN=$O(FDATA(90620.012,FIEN)) Q:FIEN=""  D
 . ;
 . ;Skip ENTERED IN ERROR
 . I $G(FDATA(90620.012,FIEN,".07","I"))="Y" Q
 . ;
 . I COM'="" S COM=COM_$C(13)_$C(10)
 . ;
 . S CIEN=0 F CLN=1:1 S CIEN=$O(FDATA(90620.012,FIEN,1,CIEN)) Q:'CIEN  D
 .. S FCOM=$G(FDATA(90620.012,FIEN,1,CIEN))
 .. I COM'="" S COM=COM_$C(13)_$C(10)
 .. S COM=COM_FCOM
 ;
 Q COM
 ;
NOTCMT(TIEN) ;EP - Get Notification Comments - 90506.1 code BTPWTNOC
 N COM,CIEN,CLN,FCOM,FDATA,FIEN
 S COM=""
 ;
 D GETS^DIQ(90620,TIEN_",","11*","IE","FDATA")
 ;
 S FIEN=0 F  S FIEN=$O(FDATA(90620.011,FIEN)) Q:FIEN=""  D
 . ;
 . ;Skip ENTERED IN ERROR
 . I $G(FDATA(90620.011,FIEN,".09","I"))="Y" Q
 . ;
 . I COM'="" S COM=COM_$C(13)_$C(10)
 . ;
 . S CIEN=0 F CLN=1:1 S CIEN=$O(FDATA(90620.011,FIEN,1,CIEN)) Q:'CIEN  D
 .. S FCOM=$G(FDATA(90620.011,FIEN,1,CIEN))
 .. I COM'="" S COM=COM_$C(13)_$C(10)
 .. S COM=COM_FCOM
 ;
 Q COM
 ;
 ;
FLG(TIEN) ;EP - Determine if Panel View Flag Indicator should be set
 ;
 ;Check for IEN
 Q:$G(TIEN)="" ""
 ;
 ;Ignore Closed Events
 I $$GET1^DIQ(90620,TIEN_",",1.01,"I")="C" Q ""
 ;
 N FLG,FDATA,FND,FNDT,FIEN
 D GETS^DIQ(90620,TIEN_",","**","IE","FDATA")
 ;
 ;Set initial Flag Value to Null
 S FLG=""
 ;
 ;First Check Findings
 S FND=0 I $P($$FND^BTPWPCLO(TIEN),U)=1 S FND=1,FLG="C"
 I FND=0 S FNDT=FDATA(90620,TIEN_",",1.05,"I") I FNDT]"",FNDT<DT S FLG="T" Q FLG
 I FND=0 Q FLG
 ;
 ;Now Check Follow-ups
 S FND=0 I $P($$FOL^BTPWPCLO(TIEN),U)=1 S FND=1,FLG="C"
 I FND=0 S FNDT=FDATA(90620,TIEN_",",1.06,"I") I FNDT]"",FNDT<DT S FLG="T" Q FLG
 I FND=0 Q FLG
 ;
 ;Last - Check Notifications
 S FND=0 I $P($$NOT^BTPWPCLO(TIEN),U)=1 S FND=1,FLG="C"
 I FND=0 S FNDT=FDATA(90620,TIEN_",",1.07,"I") I FNDT]"",FNDT<DT S FLG="T" Q FLG
 ;
 Q FLG
 ;
PAD(X,LEN) ;Truncate or Pad the variable with spaces
 N SPACE
 S $P(SPACE," ",LEN)=" "
 Q $E(X_SPACE,1,LEN)
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q

BTPWPLND ;VNGT/HS/KML-GET PLANNED EVENTS ; 21 Sep 2009  12:00 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;**1**;Feb 07, 2011;Build 37
 ;
GET(DATA,CNT,SRC,PARMS) ; EP - BTPW GET PLANNED EVENTS
 ; Input parameters
 ;   CNT   - Count of # of records to return
 ;   SRC   - Values to continue search on
 ;   PARMS - Delimited list of input variables
 ;             -> TMFRAME - Time frame
 ;             -> CAT     - Category
 ;             -> COMM    - Community
 ;             -> COMMTX  - Community Taxonomy
 ;             -> CMIEN   - List of Event IENs to Return
 ;
 ; The Planned Events Tab of CMET includes the following columns: Category, Patient Name, 
 ; HRN, DOB, Age, Sex, Community, Planned Event Name, Planned Event Date, Preceding Event (Y/N )
 N UID,II,COMM,BJ,CIN,RESULT,QFL,CT,VALUE,WHEN,WHO,TRN,STAGE,HDR,CLOSE,CATLST,CMIEN
 N FDUE,NDUE,PCOM,PREV,PRVIEN,RDUE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPLND",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPLND D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
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
 S (CAT,TMFRAME,COMM,COMMTX,CMIEN)=""
 F BJ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 .N PDATA,NAME,VALUE,BP,BV
 .S PDATA=$P(PARMS,$C(28),BJ) Q:PDATA=""
 .S NAME=$P(PDATA,"=",1) Q:NAME=""
 .S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 .F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP),@NAME=@NAME_$S(BP=1:"",1:$C(29))_BV
 ;
 ;Initialize/save original values
 S SRC=$G(SRC,"")
 S CNT=+$G(CNT)
 ;
 ;Set up search beginning/end dates
 S (BDT,EDT)=""
 I (TMFRAME'="")&(TMFRAME'="Ever") D  ; treat "Ever" timeframe like null value
 . I TMFRAME="Past Due" S EDT=DT_U_1 Q
 . S BDT=DT
 . S EDT=$$DATE^BQIUL1(TMFRAME)
 ;
 ;Set up Category List Array
 I CAT'="",CAT'=0 D
 . F BJ=1:1:$L(CAT,$C(29)) S CIN=$P(CAT,$C(29),BJ),CATLST(CIN)=""
 ;
 ;Set up Community Taxonomy
 I COMMTX'="" D
 . N CM,TREF
 . S TREF="COMM" K @TREF
 . D BLD^BQITUTL(COMMTX,TREF)
 . S (COMM,CM)="" F  S CM=$O(COMM(CM)) Q:CM=""  S COMM=$G(COMM)_$S($G(COMM)]"":$C(29),1:"")_CM K COMM(CM)
 ;
 ;Set up Community List Array
 I COMM'="" D
 . F BJ=1:1:$L(COMM,$C(29)) S CIN=$P(COMM,$C(29),BJ),COMM(CIN)=$P(^AUTTCOM(CIN,0),U,1)
 ;
 ;Define Header
 D HDR
 S @DATA@(0)=HDR_$C(30) ; set up the zero subscript of the record
 ;
 S QFL=0
 ;
 ;Search 1 - List of CMIENs
 I $G(CMIEN)'="" D CMIEN(CMIEN,.COMM,SRC) G DONE
 ;
 ;Search 2 - COMMUNITY, STATE, DUE BY DATE - NOW INACTIVE
 ;I COMM'="",TMFRAME'="" D CMSTVD(BDT,EDT,.COMM,.CATLST,SRC) G DONE
 ;
 ;Search 3 - CATEGORY, STATE, DUE BY DATE
 I CAT'="",TMFRAME'="" D CSVD(CAT,.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 4 - STATE, DUE BY DATE
 I TMFRAME'="" D SV(.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 5 - CATEGORY, STATE
 I CAT'="" D STCT(.COMM,.CATLST,CAT,SRC) G DONE
 ;
 ;Search 6 - STATE
 D ST(.COMM,SRC)
 ;
DONE ;
 I II=0,'$D(@DATA@(II)) S:$E(HDR,$L(HDR))="^" HDR=$E(HDR,1,$L(HDR)-1) S @DATA@(II)=HDR_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CMIEN(CMIEN,COMM,OSRC) ; EP - Search 1 - List of IENs
 N IEN,CT,LII,ISTRT,IFND,ILST,ITSP,RESULT,SRC
 ;
 ;Pull the last record info
 S IEN=$G(OSRC)
 ;
 S CT=0
 ;
 ;Loop through the CMIEN list (at selected point) and retrieve records
 S ISTRT=1 I IEN]"" F IFND=1:1:$L(CMIEN,$C(29)) I $P(CMIEN,$C(29),IFND)=IEN S ISTRT=IFND
 F ITSP=ISTRT:1:$L(CMIEN,$C(29)) S IEN=$P(CMIEN,$C(29),ITSP) D  Q:QFL
 . ;
 . S SRC=IEN
 . ;
 . ;Get Event Information
 . D SNG(IEN,.COMM,.RESULT) I RESULT="" Q
 . S CT=CT+1 I CNT,CT=CNT S QFL=1
 . S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 Q
 ;
CMSTVD(BDT,EDT,COMM,CTLST,OSRC) ; EP - Search 2 - COMMUNITY, STATE, DUE BY DATE - NOW INACTIVE
 N CMIEN,CM,SBDT,CT,COMP,CSTRT,CFND,STSP,SRC,RESULT,PASTEV
 S PASTEV=0  ;  past events check
 S:$P(EDT,U,2) PASTEV=$P(EDT,U,2),EDT=$P(EDT,U)
 ;
 ;Pull the last record info
 S CSTRT=1,CM=$P(OSRC,$C(29),3) I CM]"" F CFND=1:1:$L(COMM,$C(29)) I $P(COMM,$C(29),CFND)=CM S CSTRT=CFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S CMIEN=$P(OSRC,$C(29),1)
 S CT=0  ; number of records retrieved counter
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F COMP=CSTRT:1:$L(COMM,$C(29)) S CM=$P(COMM,$C(29),COMP) D  Q:QFL
 . F  S SBDT=$O(^BTPWP("AP",CM,"F",SBDT)) Q:(SBDT="")  Q:('PASTEV)&(SBDT>EDT)  Q:(PASTEV)&(SBDT'<EDT)  D  Q:QFL
 .. F  S CMIEN=$O(^BTPWP("AP",CM,"F",SBDT,CMIEN)) Q:CMIEN=""  D  Q:QFL
 ... S SRC=CMIEN_$C(29)_SBDT_$C(29)_CM
 ... ;
 ... ;Check for CATEGORY - if passed
 ... N CTG,CTGCHK S CTGCHK=1
 ... I $D(CTLST) D  Q:'CTGCHK
 .... S CTG=$$GET1^DIQ(90620,CMIEN_",",.12,"I")
 .... I CTG]"",$D(CTLST(CTG)) Q
 .... S CTGCHK=0
 ... K CTG,CTGCHK
 ... ;
 ... ;Get Event Information
 ... D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 ... S CT=CT+1 I CNT'=0,CT=CNT S QFL=1
 ... S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 . S SBDT=$S(BDT]"":BDT-.001,1:"")  ;Reset to original start date
 Q
 ;
CSVD(CAT,COMM,BDT,EDT,OSRC) ; EP - Search 3 - CATEGORY, STATE, DUE BY DATE
 N CMIEN,SBDT,CT,CATP,CSTRT,CFND,STSP,SRC,PASTEV
 S PASTEV=0  ;  past events check
 S:$P(EDT,U,2) PASTEV=$P(EDT,U,2),EDT=$P(EDT,U)
 ;
 ;Pull the last record info
 S CSTRT=1,CTG=$P(OSRC,$C(29),3) I CTG]"" F CFND=1:1:$L(CAT,$C(29)) I $P(CAT,$C(29),CFND)=CTG S CSTRT=CFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S CMIEN=$P(OSRC,$C(29),1)
 S CT=0  ; number of records retrieved counter
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F CATP=CSTRT:1:$L(CAT,$C(29)) S CTG=$P(CAT,$C(29),CATP) D  Q:QFL
 . F  S SBDT=$O(^BTPWP("AN",CTG,"F",SBDT)) Q:(SBDT="")  Q:('PASTEV)&(SBDT>EDT)  Q:(PASTEV)&(SBDT'<EDT)  D  Q:QFL
 .. F  S CMIEN=$O(^BTPWP("AN",CTG,"F",SBDT,CMIEN)) Q:CMIEN=""  D  Q:QFL
 ... S SRC=CMIEN_$C(29)_SBDT_$C(29)_CTG
 ... D SNG(CMIEN,.COMM,.RESULT) Q:RESULT=""
 ... S CT=CT+1 I CNT,CT=CNT S QFL=1  ; number of records retrieved has met the max cnt needed
 ... S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 . S SBDT=$S(BDT]"":BDT-.001,1:"")  ;Reset to original start date
 Q
 ;
SV(COMM,BDT,EDT,OSRC) ; EP - Search 4 - STATE, DUE BY DATE
 N CMIEN,SBDT,CT,SRC,PASTEV
 S PASTEV=0  ;  past events check
 S:$P(EDT,U,2) PASTEV=$P(EDT,U,2),EDT=$P(EDT,U)
 ;
 ;Pull the last record info
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S CMIEN=$P(OSRC,$C(29),1)
 S CT=0  ; number of records retrieved counter
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F  S SBDT=$O(^BTPWP("AO","F",SBDT)) Q:(SBDT="")  Q:('PASTEV)&(SBDT>EDT)  Q:(PASTEV)&(SBDT'<EDT)  D  Q:QFL
 . F  S CMIEN=$O(^BTPWP("AO","F",SBDT,CMIEN)) Q:CMIEN=""  D  Q:QFL
 .. S SRC=CMIEN_$C(29)_SBDT
 .. D SNG(CMIEN,.COMM,.RESULT) Q:RESULT=""
 .. S CT=CT+1 I CNT,CT=CNT S QFL=1  ; number of records retrieved has met the max cnt needed
 .. S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 S SBDT=$S(BDT]"":BDT-.001,1:"")  ;Reset to original start date
 Q
 ;
STCT(COMM,CTLST,CAT,OSRC) ;EP - Search 5 - CATEGORY, STATE
 N CMIEN,SRC,CSTRT,CFND,CATP,CT,CTG
 ;
 ;Pull the last record info
 S CSTRT=1,CTG=$P(OSRC,$C(29),2) I CTG]"" F CFND=1:1:$L(CAT,$C(29)) I $P(CAT,$C(29),CFND)=CTG S CSTRT=CFND
 S CMIEN=$P(OSRC,$C(29),1),QFL=0
 S CT=0  ; number of records retrieved counter
 ;
 ;Loop through index (at selected point) and retrieve records
 F CATP=CSTRT:1:$L(CAT,$C(29)) S CTG=$P(CAT,$C(29),CATP) D  Q:QFL
 . F  S CMIEN=$O(^BTPWP("AF",CTG,"F",CMIEN)) Q:CMIEN=""  D  Q:QFL
 .. ;
 .. ;Get Event Information
 .. D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 .. S SRC=CMIEN_$C(29)_CTG
 .. S CT=CT+1 I CNT'=0,CT=CNT S QFL=1 ; number of records retrieved has met the max cnt needed
 .. S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 Q
 ;
ST(COMM,OSRC) ;EP - Search 6 - search on STATE
 N CMIEN,CT,SRC,RESULT
 ;
 ;Pull the last record info
 S CMIEN=$P(OSRC,$C(29),1),CT=0,QFL=0
 ;Loop through index (at selected point) and retrieve records
 F  S CMIEN=$O(^BTPWP("AC","F",CMIEN)) Q:CMIEN=""  D  Q:QFL
 . S SRC=CMIEN_$C(29)
 . D SNG(CMIEN,.COMM,.RESULT) Q:RESULT=""
 . S CT=CT+1 I CNT,CT=CNT S QFL=1
 . S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 Q
 ;
 ;
SNG(CMIEN,COMM,RESULT) ; Get the basic record information for a single record
 ; The Planned Events Tab includes the following columns: Category, Patient Name, 
 ; HRN, DOB, Age, Sex, Community, Planned Event Name, Planned Event Date, Preceding Event (Y/N)
 N DFN,PNAM,PCOM,TDATA,PROC,PROCNM,CAT,HRN,DOB,AGE,SEX,PRVDT,DUEDT,PREV,PRVEVT
 S TDATA=$G(^BTPWP(CMIEN,0)),DFN=$P(TDATA,U,2),PCOM="",PNAM=$P(^DPT(DFN,0),"^")
 ;
 ;Community check
 S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 I COMM'="",PCOM'="",'$D(COMM(PCOM)) S RESULT="" Q
 I PCOM'="" S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"E")  ;Community
 ;
 S PROC=$P(TDATA,U),PROCNM=$P(^BTPW(90621,PROC,0),U)  ;Procedure/Name (Event)
 S CAT=$$CAT^BTPWPDSP(PROC)  ;Category
 S HRN=$TR($$HRNL^BQIULPT(DFN),";",$C(10))   ;HRN
 S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I")) ;DOB
 S AGE=$$AGE^BQIAGE(DFN,,1)  ;Age
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I")  ;Sex
 S DUEDT=$$FMTE^BQIUL1($P(TDATA,U,13))  ;due by date
 S PREV=$P(TDATA,U,11)  ;Previous event
 S (PRVDT,PRVEVT)="" I PREV]"" S PRVDT=$$GET1^DIQ(90620,PREV_",",".03","I"),PRVDT=$$FMTE^BQIUL1(PRVDT),PRVEVT=$$GET1^DIQ(90620,PREV_",",".01","E") ;Prv DT
 S RESULT=CMIEN_U_CAT_U_DFN_U_$$SENS^BQIULPT(DFN)_U_PNAM_U_HRN_U_DOB_U_AGE_U_SEX_U_$$CALR^BQIULPT(DFN)_U_PCOM_U_PROCNM_U_DUEDT_U_PRVDT_U_PREV_U_PRVEVT
 Q
 ;
HDR ;
 S HDR="I00010HIDE_CMET_IEN^T00040CATEGORY^I00010HIDE_DFN^T00001SENS_FLAG^T00035PATIENT_NAME^T00030HRN^D00015DOB^T00010AGE^T00001SEX"
 S HDR=HDR_"^T00001COMM_FLAG^T00050COMMUNITY^T00060PLANNED_EVENT^D00015PLANNED_EVNT_DATE^D00030PRECEDING_EVENT^I00010HIDE_PREVIOUS_EVENT^T00060HIDE_PRVEVT^T01024HIDE_SEARCH"
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
EVTS(TIEN) ;EP - Calculate Event Summary Column Values - Executable code 90506.1 BTPWTEVS entry
 N EVT,PROC,PRCDT,EVLMB,EVLMD,CVAR,WP,CIEN,CLN
 ;
 S EVT="TEST VALUE FOR COLUMN"
 S PROC=$$GET1^DIQ(90620,TIEN_",",.01,"E")                   ;Procedure/Name (Event)
 S PRCDT=$$FMTE^BQIUL1($$GET1^DIQ(90620,TIEN_",",.03,"I"))   ;Event Date
 S EVLMB=$$GET1^DIQ(90620,TIEN_",",1.03,"E")                 ;Event Tracked By
 S EVLMD=$$FMTE^BQIUL1($$GET1^DIQ(90620,TIEN_",",1.02,"I"))  ;Event Tracked Date
 S EVT="Event Name: "_PROC
 S EVT=EVT_$C(13)_$C(10)_"Event Date: "_PRCDT
 ;
 ;Pull previous history value
 S CVAR=$$GET1^DIQ(90620,TIEN_",",4,"","WP")
 ;
 ;Pull Event Comment Field
 S FCOM=""
 S CIEN=0 F CLN=1:1 S CIEN=$O(WP(CIEN)) Q:'CIEN  D
 . S FCOM=$G(WP(CIEN))
 . S:CLN=1 EVT=EVT_$C(13)_$C(10)_"Event Comments:"
 . S:FCOM]"" EVT=EVT_$C(13)_$C(10)_FCOM
 ;
 S EVT=EVT_$C(13)_$C(10)_"Event Tracked By: "_EVLMB
 S EVT=EVT_$C(13)_$C(10)_"Event Tracked Date/Time: "_EVLMD
 ;
 Q EVT
 ;
FNDS(TIEN) ;EP - Calculate Findings - Executable code for 90506.1 BTPWTFDA entry
 N FDATA,FVAL,FCOM,FIEN,CIEN,CLN
 D GETS^DIQ(90620,TIEN_",","10*","IE","FDATA")
 ;
 S FVAL="",FIEN=0 F  S FIEN=$O(FDATA(90620.01,FIEN)) Q:FIEN=""  D
 . ;
 . ;Skip ENTERED IN ERROR
 . I $G(FDATA(90620.01,FIEN,".08","I"))="Y" Q
 . ;
 . S:FVAL]"" FVAL=FVAL_$C(13)_$C(10)_$C(13)_$C(10)
 . ;
 . S FVAL=FVAL_"Finding: "_$E($G(FDATA(90620.01,FIEN,".02","E")),1,35)   ;Finding
 . ;S FVAL=FVAL_"    Interpretation: "_$E($G(FDATA(90620.01,FIEN,".03","E")),1,15)    ;Finding Interpretation
 . S FVAL=FVAL_$C(13)_$C(10)_"Finding Date: "_$E($$FMTE^BQIUL1($P($G(FDATA(90620.01,FIEN,".01","I")),".")),1,11)  ;Finding Date
 . ;
 . ;Pull Comment Field
 . S FCOM=""
 . S CIEN=0 F CLN=1:1 S CIEN=$O(FDATA(90620.01,FIEN,1,CIEN)) Q:'CIEN  D
 .. S FCOM=$G(FDATA(90620.01,FIEN,1,CIEN))
 .. S:CLN=1 FVAL=FVAL_$C(13)_$C(10)_"Finding Comments:"
 .. S FVAL=FVAL_$C(13)_$C(10)_FCOM
 . ;
 . S FVAL=FVAL_$C(13)_$C(10)_"Finding Entered By: "_$E($G(FDATA(90620.01,FIEN,".05","E")),1,26)                  ;Last Modified By
 . S FVAL=FVAL_$C(13)_$C(10)_"Finding Entered Date/Time: "_$$FMTE^BQIUL1($G(FDATA(90620.01,FIEN,".04","I")))  ;Last Modified Date 
 . ;
 Q FVAL
 ;
FUPS(TIEN) ;EP - Calculate Follow-Ups(s) Field
 ;
 N FDATA,FUP,FCOM,FIEN,CIEN,CLN
 D GETS^DIQ(90620,TIEN_",","12*","IE","FDATA")
 ;
 S FUP=""
 S FIEN="" F  S FIEN=$O(FDATA(90620.012,FIEN)) Q:FIEN=""  D
 . ;
 . ;Skip ENTERED IN ERROR
 . I $G(FDATA(90620.012,FIEN,".07","I"))="Y" Q
 . ;
 . S:FUP]"" FUP=FUP_$C(13)_$C(10)_$C(13)_$C(10)
 . S FUP=FUP_"Follow-up: "_$G(FDATA(90620.012,FIEN,".02","E"))  ;Follow-up
 . S FUP=FUP_$C(13)_$C(10)_"Follow-up Due Date: "_$E($$FMTE^BQIUL1($P($G(FDATA(90620.012,FIEN,".05","I")),".")),1,11)  ;Follow-up Due Date
 . ;
 . ;Pull Comment Field
 . S FCOM=""
 . S CIEN=0 F CLN=1:1 S CIEN=$O(FDATA(90620.012,FIEN,1,CIEN)) Q:'CIEN  D
 .. S FCOM=$G(FDATA(90620.012,FIEN,1,CIEN))
 .. S:CLN=1 FUP=FUP_$C(13)_$C(10)_"Follow-up Comments:"
 .. S FUP=FUP_$C(13)_$C(10)_FCOM
 . ;
 . S FUP=FUP_$C(13)_$C(10)_"Follow-up Entered By: "_$G(FDATA(90620.012,FIEN,".04","E"))  ;Follow-up Entered By
 . S FUP=FUP_$C(13)_$C(10)_"Date Follow-up Entered: "_$$FMTE^BQIUL1($P($G(FDATA(90620.012,FIEN,".03","I")),"."))  ;Follow-up Entered Date
 . ;
 Q FUP
 ;
NOTS(TIEN) ;EP - Calculate Notification(s) Field
 ;
 N FDATA,NOT,FCOM,FIEN,CIEN,FCOM,CLN
 D GETS^DIQ(90620,TIEN_",","11*","IE","FDATA")
 ;
 S NOT=""
 S FIEN="" F  S FIEN=$O(FDATA(90620.011,FIEN)) Q:FIEN=""  D
 . ;
 . ;Skip ENTERED IN ERROR
 . I $G(FDATA(90620.011,FIEN,".09","I"))="Y" Q
 . ;
 . S:NOT]"" NOT=NOT_$C(13)_$C(10)_$C(13)_$C(10)
 . S NOT=NOT_"Patient Notification: "_$G(FDATA(90620.011,FIEN,".02","E"))  ;Type
 . S NOT=NOT_$C(13)_$C(10)_"Patient Notification Date: "_$$FMTE^BQIUL1($P($G(FDATA(90620.011,FIEN,".01","I")),"."))  ;Notification Date
 . ;
 . ;Pull Comment Field
 . S FCOM=""
 . S CIEN=0 F CLN=1:1 S CIEN=$O(FDATA(90620.011,FIEN,1,CIEN)) Q:'CIEN  D
 .. S FCOM=$G(FDATA(90620.011,FIEN,1,CIEN))
 .. S:CLN=1 NOT=NOT_$C(13)_$C(10)_"Patient Notification Comments:"
 .. S NOT=NOT_$C(13)_$C(10)_FCOM
 . ;
 . S NOT=NOT_$C(13)_$C(10)_"Patient Notification Entered By: "_$G(FDATA(90620.011,FIEN,".04","E"))  ;Notification Entered By
 . S NOT=NOT_$C(13)_$C(10)_"Date Patient Notification Entered: "_$$FMTE^BQIUL1($P($G(FDATA(90620.011,FIEN,".03","I")),"."))  ;Notification Entered Date
 Q NOT

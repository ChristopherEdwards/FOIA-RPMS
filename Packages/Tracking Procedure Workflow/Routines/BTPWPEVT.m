BTPWPEVT ;VNGT/HS/BEE-Get the tracked events ; 21 Sep 2009  12:00 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
GET(DATA,CNT,SRC,PARMS) ; EP - BTPW GET TRACKED EVENTS
 ; Input parms
 ;   CNT   - Count of # of records to return
 ;   SRC   - Values to continue search
 ;   PARMS - Delimited list of input vars
 ;             -> STATE   - State List (O - Open, C - Closed)
 ;             -> TMFRAME - Time frame
 ;             -> CAT     - Cat
 ;             -> COMM    - Comm
 ;             -> COMMTX  - Comm Tax
 ;             -> CMIEN   - List of Event IENs to Return
 ;
 NEW UID,II,COMM,BJ,CIN,RESULT,QFL,CT,VALUE,WHEN,WHO,TRN,STAGE,HDR,CLOSE,STATE,CATLST
 NEW FDUE,NDUE,PCOM,PREV,PRVIEN,RDUE,OSTATE,CMIEN,TMFRAME,BDT,EDT,CAT,COMM,COMMTX
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPEVT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPEVT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Re-Assemble parm list
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Set incoming var
 S (CAT,STATE,TMFRAME,COMM,COMMTX,CMIEN)=""
 F BJ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 .N PDATA,NAME,VALUE,BP,BV
 .S PDATA=$P(PARMS,$C(28),BJ) Q:PDATA=""
 .S NAME=$P(PDATA,"=",1) Q:NAME=""
 .S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 .F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP),@NAME=@NAME_$S(BP=1:"",1:$C(29))_BV
 ;
 ;Init/save orig val
 S OSTATE=STATE
 S SRC=$G(SRC,"")
 S CNT=+$G(CNT)
 ;
 ;Handle blank state
 S:STATE="" STATE="O"
 ;
 ;Set search beg/end dates
 S (BDT,EDT)=""
 I TMFRAME'="" D
 . I $E(TMFRAME,1)=">" S TMFRAME=$E(TMFRAME,2,99),EDT=$$DATE^BQIUL1(TMFRAME) Q
 . S BDT=$$DATE^BQIUL1(TMFRAME)
 ;
 ;Set Cat List Array
 I CAT'="",CAT'=0 D
 . F BJ=1:1:$L(CAT,$C(29)) S CIN=$P(CAT,$C(29),BJ),CATLST(CIN)=""
 ;
 ;Set Community Tax
 I COMMTX'="" D
 . N CM,TREF
 . S TREF="COMM" K @TREF
 . D BLD^BQITUTL(COMMTX,TREF)
 . S (COMM,CM)="" F  S CM=$O(COMM(CM)) Q:CM=""  S COMM=$G(COMM)_$S($G(COMM)]"":$C(29),1:"")_CM K COMM(CM)
 ;
 ;Set Comm List Array
 I COMM'="" D
 . F BJ=1:1:$L(COMM,$C(29)) S CIN=$P(COMM,$C(29),BJ),COMM(CIN)=$P(^AUTTCOM(CIN,0),U,1)
 ;
 ;Header
 D HDR
 S @DATA@(0)=HDR_$C(30)
 ;
 S QFL=0
 ;
 ;Search 1 - CMIEN list
 I $G(CMIEN)'="" D CMIEN(CMIEN,.COMM,SRC) G DONE
 ;
 ;Search 3 - CATEGORY, STATE, VISIT DATE
 I CAT'="",TMFRAME'="" D CSVD(CAT,STATE,.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 4 - STATE, VISIT DATE
 I OSTATE'="",TMFRAME'="" D SV(STATE,.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 5 - VISIT DATE
 I TMFRAME'="" D VD(.COMM,BDT,EDT,SRC) G DONE
 ;
 ;Search 6 - CATEGORY, STATE
 I STATE'="",CAT'="" D STCT(.COMM,.CATLST,STATE,CAT,SRC) G DONE
 ;
 ;Search 7 - Default search on STATUS
 D ST(.COMM,STATE,SRC)
 ;
DONE ;
 I II=0,'$D(@DATA@(II)) S:$E(HDR,$L(HDR))="^" HDR=$E(HDR,1,$L(HDR)-1) S @DATA@(II)=HDR_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CMIEN(CMIEN,COMM,OSRC) ; EP - Search 1 - List of IENs
 N IEN,CT,LII,ISTRT,IFND,ILST,ITSP,RESULT,SRC
 ;
 ;Last record info
 S IEN=$G(OSRC)
 ;
 S CT=0
 ;
 ;Loop through CMIEN list (at selected point) and retrieve records
 S ISTRT=1 I IEN]"" F IFND=1:1:$L(CMIEN,$C(29)) I $P(CMIEN,$C(29),IFND)=IEN S ISTRT=IFND
 F ITSP=ISTRT:1:$L(CMIEN,$C(29)) S IEN=$P(CMIEN,$C(29),ITSP) D  Q:QFL
 . ;
 . S SRC=IEN
 . ;
 . ;Get Event Info
 . D SNG(IEN,.COMM,.RESULT) I RESULT="" Q
 . S CT=CT+1 I CNT,CT=CNT S QFL=1
 . S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 Q
 ;
CSVD(CAT,STATE,COMM,BDT,EDT,OSRC) ; EP - Search 3 - CATEGORY, STATE, VISIT DATE
 N CMIEN,SBDT,CT,CATP,CT,CSTRT,CFND,STSP,ST,SRC,SFND,SSTRT,CTG
 ;
 ;Last record info
 S CSTRT=1,CTG=$P(OSRC,$C(29),4) I CTG]"" F CFND=1:1:$L(CAT,$C(29)) I $P(CAT,$C(29),CFND)=CTG S CSTRT=CFND
 S SSTRT=1,ST=$P(OSRC,$C(29),3) I ST]"" F SFND=1:1:$L(STATE,$C(29)) I $P(STATE,$C(29),SFND)=ST S SSTRT=SFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S CMIEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F CATP=CSTRT:1:$L(CAT,$C(29)) S CTG=$P(CAT,$C(29),CATP) D  Q:QFL
 . F STSP=SSTRT:1:$L(STATE,$C(29)) S ST=$P(STATE,$C(29),STSP) D  Q:QFL
 ..F  S SBDT=$O(^BTPWP("AI",CTG,ST,SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 ... F  S CMIEN=$O(^BTPWP("AI",CTG,ST,SBDT,CMIEN)) Q:CMIEN=""  D  Q:QFL
 .... S SRC=CMIEN_$C(29)_SBDT_$C(29)_ST_$C(29)_CTG
 .... ;
 .... ;Get Event Info
 .... D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 .... S CT=CT+1 I CNT,CT=CNT S QFL=1
 .... S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 .. S SBDT=$S(BDT]"":BDT-.001,1:"")
 . S SSTRT=1
 Q
 ;
SV(STATE,COMM,BDT,EDT,OSRC) ; EP - Search 4 - STATE, VISIT DATE
 N CMIEN,SBDT,CT,STSP,SRC,SFND,ST,SSTRT
 ;
 ;Last record info
 S SSTRT=1,ST=$P(OSRC,$C(29),3) I ST]"" F SFND=1:1:$L(STATE,$C(29)) I $P(STATE,$C(29),SFND)=ST S SSTRT=SFND
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S CMIEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F STSP=SSTRT:1:$L(STATE,$C(29)) S ST=$P(STATE,$C(29),STSP) D  Q:QFL
 . F  S SBDT=$O(^BTPWP("AL",ST,SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 .. F  S CMIEN=$O(^BTPWP("AL",ST,SBDT,CMIEN)) Q:CMIEN=""  D  Q:QFL
 ... S SRC=CMIEN_$C(29)_SBDT_$C(29)_ST
 ... ; 
 ... ;Get Event Info
 ... D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 ... S CT=CT+1 I CNT,CT=CNT S QFL=1
 ... S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 . S SBDT=$S(BDT]"":BDT-.001,1:"")
 Q
 ;
 ;
VD(COMM,BDT,EDT,OSRC) ; EP - Search 5 - VISIT DATE
 N CMIEN,SBDT,CT
 ;
 ;Last record info
 S:$P(OSRC,$C(29),2)'="" SBDT=$P(OSRC,$C(29),2)
 S CMIEN=$P(OSRC,$C(29),1)
 ;
 S CT=0
 ;
 ;Loop through index (at selected point) and retrieve records
 S SBDT=$S($G(SBDT)]"":SBDT-.001,BDT]"":BDT-.001,1:"")
 F  S SBDT=$O(^BTPWP("AH",SBDT)) Q:(SBDT="")!((EDT]"")&(SBDT'<EDT))  D  Q:QFL
 . F  S CMIEN=$O(^BTPWP("AH",SBDT,CMIEN)) Q:CMIEN=""  D  Q:QFL
 .. S SRC=CMIEN_$C(29)_SBDT
 .. ; 
 .. ;Get Event Info
 .. D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 .. S CT=CT+1 I CNT,CT=CNT S QFL=1
 .. S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 Q
 ;
STCT(COMM,CTLST,STATE,CAT,OSRC) ;EP - Search 6 - CATEGORY, STATE
 N ST,STSP,SRC,SFND,SSTRT,CSTRT,CFND,CATP,CT,CTG
 ;
 ;Last record info
 S CSTRT=1,CTG=$P(OSRC,$C(29),3) I CTG]"" F CFND=1:1:$L(CAT,$C(29)) I $P(CAT,$C(29),CFND)=CTG S CSTRT=CFND
 S SSTRT=1,ST=$P(OSRC,$C(29),2) I ST]"" F SFND=1:1:$L(STATE,$C(29)) I $P(STATE,$C(29),SFND)=ST S SSTRT=SFND
 S CMIEN=$P(OSRC,$C(29),1)
 ;
 S CT=0,QFL=0
 ;
 ;Loop through index (at selected point) and retrieve records
 F CATP=CSTRT:1:$L(CAT,$C(29)) S CTG=$P(CAT,$C(29),CATP) D  Q:QFL
 . F STSP=SSTRT:1:$L(STATE,$C(29)) S ST=$P(STATE,$C(29),STSP) D  Q:QFL
 .. F  S CMIEN=$O(^BTPWP("AF",CTG,ST,CMIEN)) Q:CMIEN=""  D  Q:QFL
 ... ;
 ... ;Get Event Info
 ... D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 ... S SRC=CMIEN_$C(29)_ST_$C(29)_CTG
 ... S CT=CT+1 I CNT'=0,CT=CNT S QFL=1
 ... S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 . S SSTRT=1
 Q
 ;
ST(COMM,STATE,OSRC) ;EP - Search 7 - Default search on STATUS
 N ST,STSP,SRC,SFND,SSTRT
 ;
 ;Last record info
 S SSTRT=1,ST=$P(OSRC,$C(29),2) I ST]"" F SFND=1:1:$L(STATE,$C(29)) I $P(STATE,$C(29),SFND)=ST S SSTRT=SFND
 S CMIEN=$P(OSRC,$C(29),1)
 ;
 S CT=0,QFL=0
 ;
 ;Loop through index (at selected point) and retrieve records
 F STSP=SSTRT:1:$L(STATE,$C(29)) S ST=$P(STATE,$C(29),STSP) D  Q:QFL
 . F  S CMIEN=$O(^BTPWP("AC",ST,CMIEN)) Q:CMIEN=""  D  Q:QFL
 .. D SNG(CMIEN,.COMM,.RESULT) I RESULT="" Q
 .. S SRC=CMIEN_$C(29)_ST
 .. S CT=CT+1 I CNT'=0,CT=CNT S QFL=1
 .. S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 Q
 ;
HDR ;
 S HDR="I00010HIDE_CMET_IEN^I00010HIDE_DFN^T00001SENS_FLAG^I00010HIDE_VISIT_IEN^I00010HIDE_EVENTTYPE_IEN^T00050HRN^D00015DOB^T00001COMM_FLAG^"
 S HDR=HDR_"T00040CATEGORY^T00100PATIENT_NAME^T00010AGE^T00001SEX^T00050COMMUNITY^T00100DESIGNATED_PCP^T00060EVENT^D00030EVNT_DATE^"
 S HDR=HDR_"T01024FINDINGS^T01024HIDE_FINDINGS^T01024FOLLOW_UPS^T01024HIDE_FOLLOW_UPS^T01024NOTIFICATIONS^T01024HIDE_NOTIFICATIONS^"
 S HDR=HDR_"T00015STATE^T00050TRACKED_BY^D00030TRACKED_DTM^T00050INTERPRETATION^T00050HIDE_INTERPRETATION^D00030RESULT^T01024HIDE_RESULT^T01024HIDE_SEARCH"
 Q
 ;
SNG(CMIEN,COMM,RESULT) ; Get the basic record information for a single record
 NEW DFN,PNAM,PCOM,TDATA,PROC,PROCNM,CAT,STATUS,HRN,DOB,AGE,SEX,PRCDT,RES,PEV,FND,FUP,NOT,STATE,TWHO,TWHEN,WHIEN,WHRES
 NEW FNDT,FLDT,NODT,VISIT,QIEN,DPCP,HFND,HFUP,HNOT,HRES
 ;
 S TDATA=$G(^BTPWP(CMIEN,0)),DFN=$P(TDATA,U,2),PCOM="",PNAM=$P(^DPT(DFN,0),"^",1)
 ;
 ;Status Check - Must be Tracked
 S QIEN=$P(TDATA,U,14)
 I QIEN]"" S STATUS=$$GET1^DIQ(90629,QIEN_",",.08,"I") I STATUS'="",STATUS'="T" S RESULT="" Q
 ;
 ;Community check
 S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 I COMM'="",PCOM'="",'$D(COMM(PCOM)) S RESULT="" Q
 I PCOM'="" S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"E")  ;Comm
 ;
 S PROC=$P(TDATA,U,1),PROCNM=$P(^BTPW(90621,PROC,0),U,1)  ;Procedure/Name (Event)
 S CAT=$$CAT^BTPWPDSP(PROC)  ;Cat
 S HRN=$TR($$HRNL^BQIULPT(DFN),";",$C(10))   ;HRN
 S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I")) ;DOB
 S AGE=$$AGE^BQIAGE(DFN,,1)  ;Age
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I")  ;Sex
 S PRCDT=$$FMTE^BQIUL1($P(TDATA,U,3))  ;Event Date
 S VISIT=$P(TDATA,U,4)
 S DPCP=$P($$DPCP^BQIULPT(DFN),U,2)
 S INT=$$INTER(CMIEN),HINT=$P(INT,$C(26),2),INT=$P(INT,$C(26))
 ;
 ;Result
 S RES=$$LNK^BTPWPTRG(CMIEN,.06),HRES=$P(RES,$C(28),2,3),RES=$P(RES,$C(28))
 ;
 S FND=$$FND(CMIEN),HFND=$P(FND,$C(28),2),FND=$P(FND,$C(28))  ;Findings
 S FUP=$$FUP(CMIEN),HFUP=$P(FUP,$C(28),2),FUP=$P(FUP,$C(28))  ;Follow Ups
 S NOT=$$NOT(CMIEN),HNOT=$P(NOT,$C(28),2),NOT=$P(NOT,$C(28))  ;Notifications
 ;
 S STATE=$$GET1^DIQ(90620,CMIEN_",",1.01,"E")  ;STATE
 S TWHO=$$GET1^DIQ(90620,CMIEN_",",1.03,"E")  ;TRACKED BY
 S TWHEN=$$FMTE^BQIUL1($$GET1^DIQ(90620,CMIEN_",",1.02,"I"))  ;TRACKED DATE/TIME
 ;
 S RESULT=CMIEN_U_DFN_U_$$SENS^BQIULPT(DFN)_U_VISIT_U_PROC_U_HRN_U_DOB_U_$$CALR^BQIULPT(DFN)_U_CAT_U_PNAM_U_AGE_U_SEX_U_PCOM_U_DPCP_U_PROCNM_U_PRCDT_U_FND_U_HFND_U_FUP_U_HFUP_U_NOT_U_HNOT_U_STATE_U_TWHO_U_TWHEN_U_INT_U_HINT_U_RES_U_HRES
 ;
 Q
 ;
RES(TIEN) ;EP - Calc Result
 N TDATA,PRCDT,RES
 S TDATA=$G(^BTPWP(TIEN,0))
 S PRCDT=$$FMTE^BQIUL1($P(TDATA,U,3))
 S RES=$$LNK^BTPWPTRG(TIEN,.06)
 S:RES]"" RES=PRCDT_$C(28)_$P(RES,$C(26),2)_$C(28)_$P(RES,$C(26),3)
 Q RES
 ;
FND(TIEN) ;EP - Calc Findings
 N FND,FNDT
 S FND="",FNDT=$$GET1^DIQ(90620,TIEN_",",1.05,"I") D
 . N FIEN,FNODE,FVAL,FFLG,FSTR
 . ;
 . ;Look for findings
 . S (FFLG,FIEN)=0,FSTR="" F  S FIEN=$O(^BTPWP(TIEN,10,FIEN)) Q:'FIEN  D
 .. N FD,FV
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.01,FIEN_","_TIEN_",",.08,"I")="Y" Q
 .. ;
 .. S FD=$E($$FMTE^BQIUL1($P($$GET1^DIQ(90620.01,FIEN_","_TIEN_",",.01,"I"),".")),1,11)
 .. S FV=$$GET1^DIQ(90620.01,FIEN_","_TIEN_",",.02,"E")
 .. I FD="",FV="" Q
 .. S FVAL="Finding Date: "_FD
 .. S FVAL=FVAL_"    Finding: "_FV,FFLG=1
 .. S FSTR=FSTR_$S(FSTR]"":$C(13)_$C(10),1:"")_FVAL
 . I FFLG=1 S FND="CHECK"_$C(28)_FSTR Q
 . ;
 . ;If no findings, check for past due
 . I FFLG=0 D
 .. I FNDT]"",FNDT<DT S FND="TICKLER"_$C(28)_"Entry of Finding is overdue. Due Date: "_$P($$GET1^DIQ(90620,TIEN_",",1.05,"E"),"@")
 ;
 Q FND
 ;
FUP(TIEN) ;EP - Calc Follow Ups
 N FUP,FNDT,FLUN
 ;
 ;Look for follow-up needed
 S FLUN=$$GET1^DIQ(90620,TIEN_",",1.11,"I") I FLUN="N" Q "N/A"_$C(28)_"Follow-up Not Recommended"
 ;
 S FUP="",FNDT=$$GET1^DIQ(90620,TIEN_",",1.06,"I") D
 . N FIEN,FNODE,FVAL,FFLG,FSTR
 . ;
 . ;Look for follow ups
 . S (FFLG,FIEN)=0,FSTR="" F  S FIEN=$O(^BTPWP(TIEN,12,FIEN)) Q:'FIEN  D
 .. N FD,FV
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.012,FIEN_","_TIEN_",",.07,"I")="Y" Q
 .. ;
 .. S FD=$E($$FMTE^BQIUL1($$GET1^DIQ(90620.012,FIEN_","_TIEN_",",.05,"I")),1,11)
 .. S FV=$$GET1^DIQ(90620.012,FIEN_","_TIEN_",",.02,"E")
 .. I FD="",FV="" Q
 .. S FVAL="Follow-Up Date: "_FD
 .. S FVAL=FVAL_"    Follow-Up: "_FV,FFLG=1
 .. S FSTR=FSTR_$S(FSTR]"":$C(13)_$C(10),1:"")_FVAL
 . I FFLG=1 S FUP="CHECK"_$C(28)_FSTR Q
 . ;
 . ;If no follow ups, check for past due
 . I FFLG=0 D
 .. I FNDT]"",FNDT<DT S FUP="TICKLER"_$C(28)_"Entry of recommended follow-up is overdue. Due Date: "_$P($$GET1^DIQ(90620,TIEN_",",1.06,"E"),"@")
 ;
 Q FUP
 ;
NOT(TIEN) ;EP - Calc Notifications
 N NOT,FNDT
 S NOT="",FNDT=$$GET1^DIQ(90620,TIEN_",",1.07,"I") D
 . N FIEN,FNODE,FVAL,FFLG,FSTR
 . ;
 . ;Look for notifications
 . S (FFLG,FIEN)=0,FSTR="" F  S FIEN=$O(^BTPWP(TIEN,11,FIEN)) Q:'FIEN  D
 .. N ND,NV
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.011,FIEN_","_TIEN_",",.09,"I")="Y" Q
 .. ;
 .. S ND=$E($$FMTE^BQIUL1($$GET1^DIQ(90620.011,FIEN_","_TIEN_",",.01,"I")),1,11)
 .. S NV=$$GET1^DIQ(90620.011,FIEN_","_TIEN_",",.02,"E")
 .. I ND="",NV="" Q
 .. S FVAL="Notification Date: "_ND
 .. S FVAL=FVAL_"    Notification: "_NV,FFLG=1
 .. S FSTR=FSTR_$S(FSTR]"":$C(13)_$C(10),1:"")_FVAL
 . I FFLG=1 S NOT="CHECK"_$C(28)_FSTR Q
 . ;
 . ;If no notifications, check for past due
 . I FFLG=0 D
 .. I FNDT]"",FNDT<DT S NOT="TICKLER"_$C(28)_"Entry of the type of Patient Notification is overdue. Due Date: "_$P($$GET1^DIQ(90620,TIEN_",",1.07,"E"),"@")
 ;
 Q NOT
 ;
STACOM(QIEN) ;EP - Get State Comments
 N SIEN,SCOMM
 S SCOMM=""
 S SIEN=0
 F  S SIEN=$O(^BTPWP(QIEN,3,SIEN)) Q:'SIEN  D
 . S SCOMM=SCOMM_$S(SCOMM]"":" ",1:"")_$G(^BTPWP(QIEN,3,SIEN,0))
 Q SCOMM
 ;
INTER(TIEN,WHIEN) ;EP - BTPWTINT - Return interpretation value for the event
 N WHRES,WHDT,IEN
 ;
 S (WHDT,WHRES)=""
 I $G(TIEN)'="",$G(WHIEN)="" S WHIEN=$$GET1^DIQ(90620,TIEN_",",.09,"I")
 I WHIEN]"" D  Q:WHRES["Abnormal" WHRES
 . S WHRES=$$GET1^DIQ(9002086.1,WHIEN_",",.05,"I")
 . S:WHRES'="" WHRES=$$GET1^DIQ(9002086.31,WHRES_",",.21,"E")
 . S WHRES=$S(WHRES="NORMAL":"Normal",WHRES="ABNORMAL":"Abnormal",WHRES="NO RESULT":"N/A",1:"")_$C(26)_"WH RECORD"
 . S WHDT=$$GET1^DIQ(9002086.1,WHIEN_",",.03,"I")
 ;
 ;Loop through current findings
 I $G(TIEN)'="" D
 . S IEN=0 F  S IEN=$O(^BTPWP(TIEN,10,IEN)) Q:'IEN  D  Q:WHRES["Abnormal"
 .. N FDT,INT
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.01,IEN_","_TIEN_",",.08,"I")="Y" Q
 .. ;
 .. S FDT=$$GET1^DIQ(90620.01,IEN_","_TIEN_",",.01,"I")
 .. S INT=$$GET1^DIQ(90620.01,IEN_","_TIEN_",",.03,"E")
 .. I INT="Abnormal" S WHRES=INT_$C(26)_"CMET" Q
 .. I INT]"",FDT>WHDT S WHRES=INT_$C(26)_"CMET"
 ;
 Q WHRES
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q

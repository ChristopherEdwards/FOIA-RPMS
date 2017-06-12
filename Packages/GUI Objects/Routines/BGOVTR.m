BGOVTR ; IHS/BAO/TMD - pull Visit files associated with problems  ;14-Mar-2016 04:13;du
 ;;1.1;BGO COMPONENTS;**13,19,20**;Mar 20, 2007;Build 6
 ;---------------------------------------------
 ;Get data from V TREATMENT/REGIMEN file
 ;Input= DFN = patient IEN
 ;       PRIEN = problem number
 ;       NUM = number to return, default is 1
 ;       CNT = output counter
 ;      SVIEN= visit IEN
 ;        PRV= provider
 ;--------------------------------------------
 ;Return array
 ;Array(n)="T" [1] ^ TR IEN[2] ^ SNOMED term [3] ^ Prob IEN  [4] ^ Vst Date [5] ^ Facility [6] ^ Prv IEN [7] ^ Location [8] ^ Entered Dt [9] ^ Visit IEN [10] ^ V Cat [11] ^Locked [12] ^ Prov name [13]
 ;
GET(DATA,DFN,PROB,NUM,CNT,SVIEN,PRV) ;EP
 N CT,INVDT,VIN,SNO
 I $G(DATA)="" S DATA=$$TMPGBL
 I $G(NUM)="" S NUM=1
 I $G(CNT)="" S CNT=0
 I $G(PROB)="" S CNT=CNT+1 S DATA(CNT)="-1^Problem not defined" Q
 S PRV=$G(PRV)
 S SVIEN=$G(SVIEN)
 S CT=0,GOOD=0
 I SVIEN="" D
 .I PRV="" D
 ..S INVDT="" F  S INVDT=$O(^AUPNVTXR("APRB",DFN,PROB,INVDT)) Q:INVDT=""!(CT+1>NUM)  D
 ...S VIN="" F  S VIN=$O(^AUPNVTXR("APRB",DFN,PROB,INVDT,VIN)) Q:VIN=""  D
 ....D DATA(VIN,.GOOD)
 ....I GOOD=1 S CT=CT+1
 .E  D
 ..S INVDT="" F  S INVDT=$O(^AUPNVTXR("APRV",PROB,PRV,INVDT)) Q:INVDT=""!(CT+1>NUM)  D
 ...S VIN="" F  S VIN=$O(^AUPNVTXR("APRV",PROB,PRV,INVDT,VIN)) Q:VIN=""  D
 ....D DATA(VIN,.GOOD)
 ....I GOOD=1 S CT=CT+1
 I SVIEN'="" D
 .S VIN="" S VIN=$O(^AUPNVTXR("AD",VIEN,VIN)) Q:'+VIN  D
 ..D DATA(VIN,.GOOD)
 Q
DATA(VIN,GOOD) ;Get the data for this entry
 N X,REC,VCAT,VDT,LOC,FAC,FACNAM,EXNAME,PRVIEN,PRVNAME,SNOMED
 N FNUM,VDATE,VIEN,EDATE,DFN,STDT,COMM,CT2
 S REC=$G(^AUPNVTXR(VIN,0))
 Q:REC=""
 Q:$P(REC,U,5)=1
 S SNOMED=$P(REC,U,1)
 S CT2=$$CONC^BSTSAPI(SNOMED_"^^^1")
 S FNUM=9000010.61
 S PRVIEN=$P($G(^AUPNVTXR(VIN,12)),U,4)
 S PRVNAME=$S('PRVIEN:"",1:$P($G(^VA(200,+PRVIEN,0)),U))
 S VIEN=$P(REC,U,3)
 Q:'VIEN
 S LOC=$P($G(^AUPNVSIT(VIEN,0)),U,6)
 S FAC=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U,10),1:"")
 S FACNAM=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U),1:"")
 S:FACNAM FACNAM=$P($G(^DIC(4,FACNAM,0)),U)
 S:$P($G(^AUPNVSIT(VIEN,21)),U)'="" FACNAM=$P(^(21),U)
 S VCAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 S VDT=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 S EDATE=$$GET1^DIQ(9000010,VIEN,1201,"I")
 I EDATE="" S EDATE=VDT
 S VDATE=$$FMTDATE^BGOUTL(VDT)
 S EDATE=$$FMTDATE^BGOUTL(EDATE)
 S CNT=CNT+1,GOOD=1
 S @DATA@(CNT)="T"_U_VIN_U_SNOMED_U_PROB_U_VDATE_U_FACNAM_U_PRVIEN_U_LOC_U_EDATE_U_VIEN_U_VCAT_U_$$ISLOCKED^BEHOENCX(VIEN)_U_PRVNAME_U_$P(CT2,U,4)
 Q
 ; Delete a V Visit Instruction entry
DEL(RET,VTR) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VTR)
 Q
 ;Set data into this file
 ;LIST(n) = VTR IEN [1] ^ SNOMED [2] ^ Visit IEN [3] ^ Problem IEN [4] ^ Patient IEN [5] ^ Evnt Dt [6] ^ Provider [7]
SET(RET,DFN,LIST) ;EP
 N VFIEN,NEW,INP,VIEN,PROB,ECVT,PRV,TIEN,FDA,IEN,FNUM,INSTR,SNOMED,I,EVDT,VFNEW
 S RET="",TIEN=""
 S FNUM=9000010.61
 S I="" F  S I=$O(LIST(I)) Q:I=""!(RET'="")  D
 .S INP=$G(LIST(I))
 .S VFIEN=+INP
 .I VFIEN=0 S VFIEN="",NEW=1
 .S VFNEW='VFIEN
 .S SNOMED=$P(INP,U,2)
 .S VIEN=$P(INP,U,3)
 .S PROB=$P(INP,U,4)
 .I 'VIEN S RET=$$ERR^BGOUTL(1008) Q
 .;S DFN=$P(INP,U,5)
 .S EVDT=$P(INP,U,5)
 .I '+EVDT S EVDT=$$NOW^XLFDT
 .S PRV=$P(INP,U,6) I PRV="" S PRV=DUZ
 .S RET=$$CHKVISIT^BGOUTL(VIEN,DFN)
 .Q:RET
 .I 'VFIEN D  Q:'VFIEN
 ..D VFNEW^BGOUTL2(.RET,FNUM,SNOMED,VIEN)
 ..S:RET>0 VFIEN=RET,RET=""
 .S FDA=$NA(FDA(FNUM,VFIEN_","))
 .S @FDA@(.04)="`"_PROB
 .S @FDA@(1201)=EVDT
 .S @FDA@(1204)="`"_PRV
 .I VFNEW D
 ..S @FDA@(1216)="N"
 ..S @FDA@(1217)="`"_DUZ
 .S @FDA@(1218)="N"
 .S @FDA@(1219)="`"_DUZ
 .S RET=$$UPDATE^BGOUTL(.FDA,"E@")
 .I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 .Q:RET
 .S TIEN=TIEN_U_VFIEN
 S RET=TIEN
 Q
 ;Get the list of treatment regimens from the subset
GETTR(DATA,DFN) ;EP
 N OUT,IN,X,CNT,NODE,SNO
 S OUT=$$SNOTMP^BGOSNLK
 S IN="IHS Treatment Regimen^36^1"
 S X=$$SUBLST^BSTSAPI(.OUT,.IN)
 ;1 means success
 I X>0 D
 .M DATA=OUT
 Q
 ;
 ;Input=VIEN
 ;Output=Array
 ;Format= Problem IEN [1] ^ SNOMED CT [2] ^ Txt [3] ^Date enered [4]
 ;^Provider IEN [5] ^ Provider Name [6] ^ V treat IEN [7]
GETPVTR(RET,VIEN) ;Get visit Treatment for problems
 N PROB,EIEN,TREAT,CDATE,EPRV,PRVNAME,CNT,PIEN,CT2
 I $G(RET)="" S RET=$$TMPGBL
 S CNT=0
 S EIEN="" F  S EIEN=$O(^AUPNVTXR("AD",VIEN,EIEN)) Q:EIEN=""  D
 .S PROB=$$GET1^DIQ(9000010.61,EIEN,.04,"I")
 .Q:PROB=""
 .S TREAT=$$GET1^DIQ(9000010.61,EIEN,.01)
 .S CT2=$$CONC^BSTSAPI(TREAT_"^^^1")
 .S CT2=$P(CT2,U,4)
 .S CDATE=$$GET1^DIQ(9000010.61,EIEN,1201,"I")
 .S CDATE=$$FMTDATE^BGOUTL(CDATE)
 .S EPRV=$$GET1^DIQ(9000010.61,EIEN,1204,"I")
 .S PRVNAME=$$GET1^DIQ(9000010.61,EIEN,1204)
 .S CNT=CNT+1
 .S @RET@(CNT)=PROB_U_TREAT_U_CT2_U_CDATE_U_EPRV_U_PRVNAME_U_EIEN
 Q
 ;---------------------------------------------
 ;Get data from CONSULT/REQUEST FILE file
 ;Input= DFN = patient IEN
 ;       PROB = problem number
 ;       NUM = number to return, default is 1
 ;       CNT = output counter
 ;Output="S" (type) ^ Concult service ^ consult date ^ consult status
 ;--------------------------------------------
GETCON(DATA,DFN,PROB,NUM,CNT,PRV) ;EP Get any consults associated with this problem
 N RET,IEN,CDATE,VDT,STAT,SER,CCNT,CPRV,PRVNAME
 I $G(DATA)="" S DATA=$$TMPGBL
 I $G(NUM)="" S NUM=999
 I $G(CNT)="" S CNT=0
 S CCNT=1,PRVNAME="",PRV=$G(PRV)
 I PRV="" D
 .S IEN=$C(0)
 .F  S IEN=$O(^GMR(123,"I",PROB,IEN),-1) Q:'+IEN!(CCNT>NUM)  D
 ..D CONS(.DATA)
 E  D
 .S INVDT="" F  S INVDT=$O(^GMR(123,"APRV",PROB,PRV,INVDT)) Q:'+INVDT!(CCNT>NUM)  D
 ..S IEN="" F  S IEN=$O(^GMR(123,"APRV",PROB,PRV,INVDT,IEN)) Q:'+IEN  D
 ...D CONS(.DATA)
 Q
CONS(DATA) ;Get consult data
 S SER=$$GET1^DIQ(123,IEN,1)
 S VDT=$P($G(^GMR(123,IEN,0)),U,1)
 S CDATE=$$FMTDATE^BGOUTL(VDT)
 S STAT=$$GET1^DIQ(123,IEN,8)
 S CPRV=$$GET1^DIQ(123,IEN,10,"I")
 S PRVNAME=$$GET1^DIQ(123,IEN,10)
 S CNT=CNT+1,CCNT=CCNT+1
 S @DATA@(CNT)="S"_U_SER_U_CDATE_U_STAT_U_CPRV_U_PRVNAME
 Q
 ;---------------------------------------------
 ;Get data from V REFERRAL  file
 ;Input= DFN = patient IEN
 ;       PROB = problem number
 ;       NUM = number to return, default is 999
 ;       CNT = output counter
 ;       VIEN= visit IEN
 ;       PRV = provider
 ;--------------------------------------------
GETREF(DATA,DFN,PROB,NUM,CNT,VIEN,PRV) ;EP Get any referrals associated with this problem
 N RET,IEN,CDATE,VDT,STAT,SNO,RIEN,SER,TO,RCNT,RPRV,PRVNAME,INVDT
 I $G(DATA)="" S DATA=$$TMPGBL
 I $G(NUM)="" S NUM=999
 I $G(CNT)="" S CNT=0
 S VIEN=$G(VIEN),PRV=$G(PRV)
 S RCNT=1
 I VIEN="" D
 .I PRV="" D
 ..S INVDT="" F  S INVDT=$O(^AUPNVREF("APRB",DFN,PROB,INVDT)) Q:'+INVDT!(RCNT>NUM)  D
 ...S IEN="" F  S IEN=$O(^AUPNVREF("APRB",DFN,PROB,INVDT,IEN)) Q:'+IEN  D
 ....D STREF(IEN)
 .E  D
 ..S INVDT="" F  S INVDT=$O(^AUPNVREF("APRV",PROB,PRV,INVDT)) Q:'+INVDT!(RCNT>NUM)  D
 ...S IEN="" F  S IEN=$O(^AUPNVREF("APRV",PROB,PRV,INVDT,IEN)) Q:'+IEN  D
 ....D STREF(IEN)
 I VIEN'="" D
 .S IEN=0
 .S IEN=$O(^AUPNVREF("AD",VIEN,IEN)) Q:'+IEN  D STREF(IEN)
 Q
STREF(IEN) ;Store the referral
 S RIEN=$$GET1^DIQ(9000010.59,IEN,.06,"I")
 S CDATE=$$GET1^DIQ(9000010.59,IEN,1201,"I")
 S CDATE=$$FMTDATE^BGOUTL(CDATE)
 S STAT=$$GET1^DIQ(90001,RIEN,.15)
 S SER=$$GET1^DIQ(90001,RIEN,.07)
 S RPRV=$$GET1^DIQ(90001,RIEN,.06,"I")
 S PRVNAME=$$GET1^DIQ(90001,RIEN,.06)
 I SER="" S TO=$$GET1^DIQ(90001,RIEN,.08)
 I SER="" S TO=$$GET1^DIQ(90001,RIEN,.09)
 S CNT=CNT+1,RCNT=RCNT+1
 S @DATA@(CNT)="R"_U_SER_U_CDATE_U_STAT_U_RPRV_U_PRVNAME
 Q
 ;---------------------------------------------
 ;Get data from V EDUCATION FILE file
 ;Input= DFN = patient IEN
 ;       PROB = problem number
 ;       NUM = number to return, default is 999
 ;       CNT = output counter
 ;Output= "E" (TYPE) ^ education topic ^ entered date
 ;--------------------------------------------
GETEDU(DATA,DFN,PROB,NUM,CNT,VIEN,PRV) ;EP Get any education associated with this problme
 N RET,IEN,CDATE,VDT,STAT,INVDT,TOPIC,ECNT,EPRV,PRVNAME,SNO
 I $G(DATA)="" S DATA=$$TMPGBL
 I $G(NUM)="" S NUM=999
 I $G(CNT)="" S CNT=0
 S PRV=$G(PRV)
 S VIEN=$G(VIEN)
 S ECNT=1
 S INVDT=""
 ;Get the SNOMED CT for this problem
 F  S INVDT=$O(^AUPNVPED("APRB",DFN,PROB,INVDT)) Q:'+INVDT!(ECNT>NUM)  D
 .S IEN="" F  S IEN=$O(^AUPNVPED("APRB",DFN,PROB,INVDT,IEN)) Q:'+IEN!(ECNT>NUM)  D
 ..S TOPIC=$$GET1^DIQ(9000010.16,IEN,.01)
 ..S CDATE=$$GET1^DIQ(9000010.16,IEN,1201,"I")
 ..S CDATE=$$FMTDATE^BGOUTL(CDATE)
 ..S EPRV=$$GET1^DIQ(9000010.16,IEN,1204,"I")
 ..S SNO=$$GET1^DIQ(9000010.16,IEN,1301)
 ..Q:PRV'=""&(PRV'=EPRV)
 ..S PRVNAME=$$GET1^DIQ(9000010.16,IEN,1204)
 ..S CNT=CNT+1,ECNT=ECNT+1
 ..S @DATA@(CNT)="E"_U_TOPIC_U_CDATE_U_PRV_U_PRVNAME_U_IEN_U_SNO
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOVIN",$J) Q $NA(^($J))
 ; Return file number
FNUM() Q 9000010.61

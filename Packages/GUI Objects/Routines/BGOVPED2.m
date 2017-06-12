BGOVPED2 ; IHS/BAO/TMD - Patient Education ;04-Apr-2016 08:54;du
 ;;1.1;BGO COMPONENTS;**8,13,14,20**;Mar 20, 2007
 ;---------------------------------------------
 ;  Return IEN of code given the name
 ;  INP = Name of code
 ;  TYPE=ICD or SNOMED
 ;RET=IEN of code in patient education file
FIND(RET,INP) ;EP
 N MAJOR,TYPE,CODE,IEN,ABB,LOOKUP,CTYPE
 S MAJOR=$P(INP,"-",1),TYPE=$P($P(INP,"-",2),U)
 S CTYPE=$P(INP,U,2)
 S CODE=0
 ;Patch 20 changed lookup
 I +MAJOR!($E(MAJOR,1,1)="V")!(CTYPE="ICD") D
 .S CODE=$$LOOK($P(INP,U,1))
 .;Try a second time with upper case
 .I CODE=0 D
 ..S INP=$$UPPER(INP)
 ..S CODE=$$LOOK($P(INP,U,1))
 .I CODE=0 S CODE=$$CREATE(MAJOR,TYPE)
 E  D
 .S MAJOR=$$UPPER(MAJOR)
 .S IEN=$O(^AUTTEDMT("B",MAJOR,"")) Q:IEN=""  D
 ..S ABB=$P($G(^AUTTEDMT(IEN,0)),U,2)
 ..S LOOKUP=ABB_"-"_$$UPPER(TYPE)
 ..S CODE=$$LOOK(LOOKUP)
 ..I CODE=0 D
 ...S LOOKUP=ABB_"-"_TYPE
 ...S CODE=$$LOOK(LOOKUP)
 I CODE=0 D CREATE(MAJOR,$$UPPER(TYPE))
 S RET=CODE
 Q
LOOK(NAME) ;Check for the code
 N EDU,GOOD,IEN
 S GOOD=0,IEN=0
 S EDU="" F  S EDU=$O(^AUTTEDT("B",NAME,EDU)) Q:EDU=""!(+GOOD)  D
 .I $P($G(^AUTTEDT(EDU,0)),U,3)="" S GOOD=1,IEN=EDU
 Q IEN
CREATE(ICD,TOPIC) ;Add this ICD9 related code to the database
 N ED,INP,RET,IEN,DATA,TIEN
 S ED=0,IEN="",TIEN=""
 I CTYPE="ICD" D
 .;S INP=ICD_U_"1^^^0"
 .;D ICDLKUP^BGOICDLK(.RET,INP)
 .I $$AICD^BGOUTL2 D
 ..S X=$$ICDDX^ICDEX(ICD,$$NOW^XLFDT)
 ..S IEN=$P(X,U,1)
 .E  D
 ..S X=$$ICDDX^ICDCODE(ICD,$$NOW^XLFDT)
 ..S IEN=$P(X,U,1)
 ..;I '$D(@RET@(1)) S DATA="" Q
 ..;S DATA=@RET@(1)
 ..;S IEN=$P(DATA,U,2)
 E  S IEN=ICD
 S TOPIC=$$UPPER(TOPIC)
 S TIEN=$O(^APCDEDCV("B",TOPIC,TIEN))
 I +IEN&(+TIEN) D
 .S INP=IEN_U_TIEN
 .I CTYPE="ICD" D SETDXTOP^BGOVPED(.RET,INP,1)
 .E  D SETSNTOP^BGOVPED(.RET,INP)
 .S ED=$P(RET,U,1)
 Q ED
UPPER(X) ; Convert lower case X to UPPER CASE
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;-----------------------------------------------------------------
 ; Send and store an array of patient educations for a patient and a vis
 ; Input parameter
 ;  PT=DFN [1] ^ VIEN [2]
 ;  INP=COMPREHENSION [1] ^ LENGTH [2] ^ READINESS [3] ^ NUMBER [4]
 ;  EDU(ARRAY) = PROB IEN [1] ^ SNOMED CONCEPT CT [2] ^ TOPIC [3] ^ IEN [4]
 ; Output string
 ;  IENs stored separated by ^
PROBEDU(RET,PT,INP,EDU) ;EP
 N VIEN,DFN,COMP,LEN,NUM,READ,ICHK,SNO,TOPIC,TOPIEN,TOPID,INPST,DATA,LOC,EIEN
 S DFN=$P(PT,U,1),VIEN=$P(PT,U,2),EIEN=""
 S RET="",TOPIEN=""
 I 'DFN!('VIEN) S RET="-1^Patient or visit not defined" Q
 S NUM=$P(INP,U,4)
 S LEN=$P(INP,U,2)
 I LEN=0 S LEN=""
 I +LEN>0 S LEN=LEN\NUM
 S LOC=$P($G(^AUPNVSIT(VIEN,0)),U,22)
 S COMP=$P(INP,U,1),READY=$P(INP,U,3)
 S ICHK="" F  S ICHK=$O(EDU(ICHK)) Q:ICHK=""  D
 .S PROB=$P(EDU(ICHK),U,1)
 .S SNO=$P(EDU(ICHK),U,2)
 .S TOPIC=$P(EDU(ICHK),U,3)
 .S EIEN=$P(EDU(ICHK),U,4)
 .I SNO=""!(TOPIC="") S RET=RET_U_"-1^Snomed education not defined" Q
 .S TOPIC=$$UPPER(TOPIC)
 .S TOPID=$O(^APCDEDCV("B",TOPIC,""))
 .I TOPID="" S TOPID=$O(^APCDEDCV("C",TOPIC,""))
 .I TOPID="" S RET=RET_U_"-1^Topic not identified" Q
 .D SETSNTOP^BGOVPED(.TOPIEN,SNO_U_TOPID)
 .I TOPIEN="" S RET=RET_U_"-1^Unable to store education topic" Q
 .S INPST=EIEN_U_$P(TOPIEN,U,1)_U_DFN_U_VIEN_U_DUZ_U_COMP_U_"I"_U_LEN_U_U_U_U_U_U_LOC_U_U_U_READY_U_U_PROB
 .S DATA=""
 .D SET^BGOVPED(.DATA,INPST)
 .I RET="" S RET=DATA
 .E  S RET=RET_U_DATA
 Q
 ;
 ;Convert the convoluted array returned by CLININD^ORWDXIHS to a numerically indexed one
 ; that's easy for VB6 to handle.
GETPROBS(RET,INP) ; EP
 N CNT,CR,VAR,DFN,VIEN,OID,SNOMED
 S INP=$G(INP)
 S DFN=$P(INP,U,1),VIEN=$P(INP,U,2),OID=$P(INP,U,3),SNOMED=$P(INP,U,4)
 D CLININD^ORWDXIHS(.CR,DFN,VIEN,OID,SNOMED) ; Pass along whatever we got (or didn't get)
 S RET=$$TMPGBL^BGOUTL
 S VAR="CR",CNT=0
 I $D(@VAR)#10 S @RET@(CNT)=@VAR ; Put any scalar value in the first (zero) node
 F  S VAR=$Q(@VAR) Q:VAR=""  S CNT=CNT+1,@RET@(CNT)=@VAR
 Q
 ;Input=VIEN
 ;Output=Array
 ;Format= Problem IEN [1] ^ Topic [2] ^ Date enered [3] ^Provider IEN [4] ^ Provider Name [5] ^ VPED IEN [6]
 ;CODE[7] ^ TYPE [8] ^ LEVEL [9] ^ TIME [10] ^READINESS [11] ^ Mnemonic [12]
GETPVED(RET,VIEN) ;Get visit education for problems
 N PROB,EIEN,TOPIC,CDATE,EPRV,PRVNAME,CNT,CODE,TXT,PIEN,LEVEL,TIME,READY,TOPICIEN,MN
 I $G(RET)="" S RET=$$TMPGBL
 S CNT=0
 S EIEN="" F  S EIEN=$O(^AUPNVPED("AD",VIEN,EIEN)) Q:EIEN=""  D
 .S PROB=$$GET1^DIQ(9000010.16,EIEN,1103,"I")
 .Q:PROB=""
 .S TOPIC=$$GET1^DIQ(9000010.16,EIEN,.01)
 .S TOPICIEN=$$GET1^DIQ(9000010.16,EIEN,.01,"I")
 .S PIEN=$$GET1^DIQ(9000010.16,EIEN,.01,"I")
 .S CDATE=$$GET1^DIQ(9000010.16,EIEN,1201,"I")
 .S CDATE=$$FMTDATE^BGOUTL(CDATE)
 .S EPRV=$$GET1^DIQ(9000010.16,EIEN,1204,"I")
 .S PRVNAME=$$GET1^DIQ(9000010.16,EIEN,1204)
 .S CODE=$P($G(^AUTTEDT(PIEN,0)),U,1)
 .S TXT=$P(CODE,"-",2),CODE=$P(CODE,"-",1)
 .S LEVEL=$$GET1^DIQ(9000010.16,EIEN,.06)
 .S TIME=$$GET1^DIQ(9000010.16,EIEN,.08)
 .S READY=$$GET1^DIQ(9000010.16,EIEN,1102)
 .S MN=$$GET1^DIQ(9999999.09,TOPICIEN,1)
 .S CNT=CNT+1
 .S @RET@(CNT)=PROB_U_TOPIC_U_CDATE_U_EPRV_U_PRVNAME_U_EIEN_U_CODE_U_TXT_U_LEVEL_U_TIME_U_READY_U_MN
 Q
TOPIC(RET) ;Return list of education topics with mnenomics
 N CNT,PARAM,ENT,FMT,USR,ERR,TMP,TXT,MN
 S CNT=0
 S RET=$$TMPGBL
 S PARAM="BGO PROBLEM EDUCATION",ENT="ALL",FMT="B"
 D GETLST^XPAR(.TMP,$$ENT^CIAVMRPC(PARAM,.ENT,.USR),PARAM,.FMT,.ERR)
 F  S CNT=$O(TMP(CNT)) Q:CNT=""  D
 .S IEN=$P($G(TMP(CNT,"V")),U,1)
 .S TXT=$P($G(TMP(CNT,"V")),U,2)
 .S MN=$$GET1^DIQ(9001002.5,IEN,.02)
 .S @RET@(CNT)=CNT_U_TXT_U_MN
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOVPED",$J) Q $NA(^($J))

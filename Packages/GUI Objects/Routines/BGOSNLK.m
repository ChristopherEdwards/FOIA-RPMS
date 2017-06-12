BGOSNLK ; IHS/MSC/MGH - SNOMED Picklists ;05-Dec-2014 07:22;du
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007;Build 1
 ;Input is the name of the picklist
GETLST(RET,INP) ;Return items from a SNOMED picklist
 N FNUM,GRP,PICK,ITM,SNO,DESC,TXT,STAT,CNT,IN,OUT,X,DATA,ICD
 S RET=$$TMPGBL^BGOUTL
 S CNT=0
 S FNUM=90362.34
 S PICK="" S PICK=$O(^BGOSNOPR("B",INP,PICK))
 Q:PICK=""
 S ITM=0 F  S ITM=$O(^BGOSNOPR(PICK,1,ITM)) Q:'+ITM  D
 .S DATA=$G(^BGOSNOPR(PICK,1,ITM,0))
 .S SNO=$P(DATA,U,1)
 .S DESC=$P(DATA,U,2)
 .S STAT=$P(DATA,U,6)
 .S ICD=""
 .S GRP=$P($G(^BGOSNOPR(PICK,1,ITM,1)),U,2)
 .;look it up in Apelon
 .;changed to use new API
 .;S X=$$CONC^BSTSAPI(SNO_"^36^^1")
 .S X=$$CONC^AUPNSICD(SNO_"^^^1")
 .I $P(X,U,1)'="" D
 ..S DESC=$P(X,U,3)
 ..S TXT=$P(X,U,4)
 ..S ICD=$P(X,U,5)
 .S CNT=CNT+1
 .S @RET@(CNT)=TXT_U_DESC_U_SNO_U_ICD_U_STAT_U_GRP
 Q
SUBSET(RET,INP) ;Return data from a subset
 N CNT,SUBSET,IN,OUT,X,SNO,ICD,DESC,TXT
 S CNT=0
 I $G(RET)="" S RET=$$TMPGBL^BGOUTL
 ;look it up in Apelon
 S OUT=$$SNOTMP
 S IN=INP_"^^1"
 S X=$$SUBLST^BSTSAPI(.OUT,.IN)
 ;1 means success
 I X>0 D
 .S CNT="" F  S CNT=$O(@OUT@(CNT)) Q:CNT=""  D
 ..S ICD=""
 ..S NODE=$G(@OUT@(CNT))
 ..S SNO=$P(NODE,U,1)
 ..;IHS/MSC/MGH changed to use new api
 ..;S X=$$CONC^BSTSAPI(SNO_"^36^^1")
 ..S X=$$CONC^AUPNSICD(SNO_"^^^1")
 ..I X'="" S ICD=$P($P(X,U,5),";",1)
 ..S DESC=$P(NODE,U,2),TXT=$P(NODE,U,3)
 ..S @RET@(CNT)=TXT_U_DESC_U_SNO_U_ICD_U_""_U_TXT
 Q
SNOTMP() K ^TMP("BGOSN"_$G(X),$J) Q $NA(^($J))
 ;
UPDATE() ;Update picklists from Apelon
 N X,ARR,I,RET
 S X=$$SUBSET^BSTSAPI("ARR")
 S I=0 F  S I=$O(ARR(I)) Q:I=""  D
 .S NAME=$G(ARR(I))
 .I $E(NAME,1,4)="PICK" D
 ..S IEN="" S IEN=$O(^BGOSNOPR("SS",$E(NAME,1,30),IEN))
 ..I IEN="" D
 ...S PICK=$E(NAME,6,$L(NAME))
 ...;S PICK=$$UPPER(PICK)
 ...S IEN=$$NEW(NAME,PICK)
 ..Q:IEN=""
 ..S PICK=$P($G(^BGOSNOPR(IEN,0)),U,1)
 ..W !,"Updating "_PICK
 ..D IMPORT(.RET,NAME,PICK)
 ..I $$UPPER($E(PICK,1,8))="PRENATAL" D
 ...N IENS,FDA,ERR
 ...S IENS=IEN_","
 ...S FDA(90362.34,IENS,.09)=1
 ...D UPDATE^DIE(,"FDA","","ERR")
 ..S INP=IEN_U_DUZ_U_1
 ..D SETMGR^BGOSNOPR(.RET,INP)
 Q
 ;Import data from an Apelon subset to a SNOMED picklist
 ;Input parameters
 ;1)The Apelon subset
 ;2)The name of the SNOMED picklist
IMPORT(RET,SUBSET,INP) ;EP
 N PICK,OUT,IN,X,NODE,CK,SNO,AIEN,FNUM,FDA,IEN,ERR,NEW
 S NEW=0
 S PICK="" S PICK=$O(^BGOSNOPR("B",INP,PICK))
 I PICK="" S NEW=1 S PICK=$$NEW(SUBSET,INP)
 Q:PICK<1
 S OUT=$$SNOTMP
 S IN=SUBSET
 S X=$$SUBLST^BSTSAPI(.OUT,.IN)
 ;1 means success
 I X>0 D
 .S CNT="" F  S CNT=$O(@OUT@(CNT)) Q:CNT=""  D
 ..S NODE=$G(@OUT@(CNT))
 ..S SNO=$P(NODE,U,1)
 ..;Don't load again if its already there
 ..S CK=$O(^BGOSNOPR(PICK,1,"B",SNO,""))
 ..Q:+CK
 ..N FDA,IEN,ERR
 ..S AIEN="+1,"_PICK_","
 ..S FDA(90362.342,AIEN,.01)=SNO
 ..S FDA(90362.342,AIEN,.02)=$P(NODE,U,2)
 ..S FDA(90362.342,AIEN,.03)=0
 ..S FDA(90362.342,AIEN,6)=$P(NODE,U,3)
 ..D UPDATE^DIE(,"FDA","IEN","ERR")
 ..I '$D(ERR) S RET=IEN(1)
 ..E  S RET=RET_"-1^Error adding item"_SNO
 .S INP=PICK_U_DUZ_U_1
 .D SETMGR^BGOSNOPR(.RET,INP)
 I NEW S RET=PICK
 E  S RET="-"_PICK
 Q
NEW(SUBSET,NAME) ;Create a new picklist
 N IEN,FDA,DIR,RET
 S IEN="+1,"
 S FDA(90362.34,IEN,.01)=NAME
 S FDA(90362.34,IEN,.08)=SUBSET
 S FDA(90362.34,IEN,.05)=DUZ
 D UPDATE^DIE(,"FDA","IEN","ERR")
 I $D(ERR) S RET=-1
 E  S RET=IEN(1)
 I RET>0 D
 .N INP,RET1
 .S INP=RET_U_DUZ_U_1
 .D SETMGR^BGOSNOPR(.RET1,INP)
 Q RET
CONCLKUP(RET,CONCID) ;EP
 ;Changed to use new api
 S CONCID=$G(CONCID)_"^^^1"
 S RET=$$CONC^AUPNSICD(CONCID)
 Q
GETSUB(RET,PREFIX) ;Return list of subsets to select from
 N X,ARR,I,CNT
 S RET=$$TMPGBL^BGOUTL
 S PREFIX=$S($G(PREFIX)="":"PICK",1:$G(PREFIX))
 S CNT=0
 S X=$$SUBSET^BSTSAPI("ARR","36^1")
 S I=0 F  S I=$O(ARR(I)) Q:I=""  D
 .S NAME=$G(ARR(I))
 .I $E(NAME,1,4)=PREFIX D
 ..S CNT=CNT+1
 ..S @RET@(CNT)=$G(ARR(I))
 Q
TREAT(RET,VIEN) ;Find all the treatment/regimens
 N FNUM,GRP,SUB,ARR,X,GRP,ITM,CNT,IN,OUT,X,VDT,FCNT
 S RET=$$TMPGBL^BGOUTL
 S SUB="TREG "
 S X=$$SUBSET^BSTSAPI("ARR","36^1")
 Q:X=0
 S CNT=0,FCNT=0
 S VDT=$$GET1^DIQ(9000010,VIEN,.01,"I")
 F  S CNT=$O(ARR(CNT)) Q:CNT=""  D
 .S NAME=$G(ARR(CNT))
 .I $E(NAME,1,4)="TREG" D
 ..S GRP=$E(NAME,6,$L(NAME))
 ..D DATA(NAME,GRP,VDT)
 Q
DATA(NAME,GRP,VDT) ;Get the subset data
 N OUT,IN,X,Y,TXT,DESC,SNO,ICD,NODE,NUM
 S OUT=$$SNOTMP
 S IN=NAME_"^^1"
 S X=$$SUBLST^BSTSAPI(.OUT,.IN)
 ;1 means success
 I X>0 D
 .S NUM="" F  S NUM=$O(@OUT@(NUM)) Q:NUM=""  D
 ..S NODE=$G(@OUT@(NUM))
 ..S SNO=$P(NODE,U,1)
 ..S DESC=$P(NODE,U,2)
 ..S TXT=$P(NODE,U,3)
 ..;IHS/MSC/MGH changed to use new API
 ..;S Y=$$CONC^BSTSAPI(SNO_"^^"_VDT_"^1")
 ..S Y=$$CONC^AUPNSICD(SNO_"^^"_VDT_"^1")
 ..I Y'="" S ICD=$P($P(Y,U,5),";",1)
 ..S FCNT=FCNT+1
 ..S @RET@(FCNT)=TXT_U_DESC_U_SNO_U_ICD_U_U_GRP
 Q
UPPER(X) ;Turn value to upper case
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")

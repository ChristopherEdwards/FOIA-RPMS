BTIUPDD ; IHS/MSC/MGH - Problem Objects ;12-Jul-2016 17:33;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1012,1013,1014,1016,1017**;MAR 20, 2013;Build 7
 ;4/13/13
 ;
 Q
 ;
DETAIL(DFN,TARGET,TYPE,ACT,NUM) ; Get problem details
 N PROB,CNT,RET,PRIEN,I,STAT
 K @TARGET
 I $G(TYPE)="" S TYPE="ASEO"
 I $G(ACT)="" S ACT="L"
 ;For Visit instructions and treatments, the default is the latest visit
 I $G(NUM)="" S NUM=1
 S RET=""
 S (CNT,PRIEN)=0
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .;Check for which statuses to return
 .S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 .Q:STAT="D"
 .Q:TYPE'[STAT
 .D DETAIL^BGOPRDD(.RET,PRIEN,DFN,"A",100,"")             ;Get a detail report on one problem
 .S I=0 F  S I=$O(@RET@(I)) Q:I=""  D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=@RET@(I)
 .K RET
 I CNT=0 S @TARGET@(1,0)="No active problems"
 Q "~@"_$NA(@TARGET)
 ;
 ;Get the problems associated with this visit and only the latest or items updated during this visit
VST(DFN,TARGET,VIEN,CP) ;Problems updated this visit
 N PROB,CNT,RET,PRIEN,I,VST,ARRAY
 S CNT=0,CP=$G(CP),ARRAY=""
 K @TARGET
 S VIEN=$G(VIEN)
 I VIEN'="" G GETPRB
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S VIEN=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 D GETPRB
 I CNT=0 S @TARGET@(1,0)="No Problems used as POVs in this visit record"
 Q "~@"_$NA(@TARGET)
 ;
GETPRB ;Get problems to update
 I $G(VIEN)="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S PRIEN=0
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .;Check for which statuses to return
 .S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 .Q:STAT="D"
 .I $D(^AUPNPROB(PRIEN,14,"B",VIEN)) D
 ..D GETDATA(.ARRAY,PRIEN,VIEN)
 ;IHS/MSC/MGH Patch 1014
 D ADDITEMS(.ARRAY)
 Q
GETDATA(ARRAY,PRIEN,VIEN) ;Get data for a problem
 N NARR,STATUS,ICD,POVNAR
 S POVNAR=$$POV^BTIUPDD(VIEN,PRIEN)
 S NARR=$$GET1^DIQ(9000011,PRIEN,.05)
 S ARRAY($P(POVNAR,U,2),NARR,PRIEN)=$P(POVNAR,U,1)
 Q
ADDITEMS(ARRAY) ;Add the other pieces to display
 N NARR,STATUS,ICD,POVNAR,STAT,PRIEN
 S STAT="" F  S STAT=$O(ARRAY(STAT)) Q:STAT=""  D
 .S NARR="" F  S NARR=$O(ARRAY(STAT,NARR)) Q:NARR=""  D
 ..S PRIEN="" F  S PRIEN=$O(ARRAY(STAT,NARR,PRIEN)) Q:PRIEN=""  D
 ...S POVNAR=$G(ARRAY(STAT,NARR,PRIEN))
 ...S STATUS=$$GET1^DIQ(9000011,PRIEN,.12)
 ...S ICD=$$GET1^DIQ(9000011,PRIEN,.01)
 ...D ADD("Problem: "_NARR)
 ...;Find changed narrative
 ...D ADD(" POV : "_POVNAR_"("_STAT_")")
 ...D ADD(" Status: "_STATUS)
 ...;D ADD(" Mapped ICD: "_ICD_" Status: "_STATUS)
 ...D QUAL^BTIUPV1(PRIEN,.CNT)
 ...I CP=1 D
 ....D FINDCP^BTIUPV1(PRIEN,"G",.CNT)  ;Add goals
 ....D FINDCP^BTIUPV1(PRIEN,"P",.CNT)  ;Add care plans
 ...D VIDT^BTIUPV1(PRIEN,VIEN,.CNT)   ;Visit instruction
 ...D VTRDT^BTIUPV1(PRIEN,VIEN,.CNT)  ;V treatment/regimens
 ...D REFDT^BTIUPV1(PRIEN,VIEN,.CNT)  ;V REFERRALS
 ...D EDU^BTIUPV1(PRIEN,VIEN,.CNT)  ;V education by date
 Q
ADD(DATA) ;add to list
 S CNT=CNT+1
 S @TARGET@(CNT,0)=DATA
 Q
POV(VIEN,PRIEN) ;Check to see if POV narrative is different from problem narrative
 ;IHS/MSC/MGH added normal/abnormal qualifier
 N POV,POVIEN,MATCH,PRIM,NORM,STR,ENTRY
 S MATCH=0,POV=""
 S POVIEN="",STR=""
 F  S POVIEN=$O(^AUPNVPOV("AD",VIEN,POVIEN)) Q:POVIEN=""!(MATCH=1)  D
 .I $P($G(^AUPNVPOV(POVIEN,0)),U,16)=PRIEN S MATCH=1
 .S POV=$$GET1^DIQ(9000010.07,POVIEN,.04)
 .S PRIM=$$GET1^DIQ(9000010.07,POVIEN,.12,"I")
 .I PRIM="" S PRIM="S"
 .S NORM=$$GET1^DIQ(9000010.07,POVIEN,.29,"E")
 .S ENTRY=$$GET1^DIQ(9000010.07,POVIEN,1216,"I")
 .I NORM="" S STR=POV_U_PRIM_U_ENTRY
 .I NORM'="" S STR=POV_";"_NORM_U_PRIM_U_ENTRY
 Q STR
TMPGBL(X) ;EP
 K ^TMP("BGOPRDD",$J) Q $NA(^($J))

BTIUPDD3 ; IHS/MSC/MGH - Problem and OB by entry date ;25-May-2016 16:23;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1017**;MAR 20, 2013;Build 7
 ;
 Q
 ;
 ;
 ;Get the problems associated with this visit and only the latest or items updated during this visit
VST(DFN,TARGET,VIEN) ;Problems updated this visit
 N PROB,CNT,RET,I,VST
 S CNT=0
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
 N POV,PRIEN,PCNT,ARRAY
 S ARRAY=""
 I $G(VIEN)="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S PCNT=0,PRIEN=0
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .;Check for which statuses to return
 .S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 .Q:STAT="D"
 .I $D(^AUPNPROB(PRIEN,14,"B",VIEN)) D
 ..D GETDATA(.ARRAY,PRIEN,VIEN)
 ;IHS/MSC/MGH Patch 1014
 D ADDITMS(.ARRAY)
 Q
GETDATA(ARRAY,PRIEN,VIEN) ;Get data for a problem
 N NARR,STATUS,ICD
 Q:'+PRIEN
 S NARR=$$POV^BTIUPDD(VIEN,PRIEN)
 Q:$P(NARR,U,1)=""!($P(NARR,U,2)="")!($P(NARR,U,3)="")
 S ARRAY($P(NARR,U,2),$P(NARR,U,3),$P(NARR,U,1),PRIEN)=""
 Q
 ;S NARR=$$GET1^DIQ(9000010.07,POV,.04)
ADDITMS(ARRAY) ;Get items in order
 N STAT,NARR,PRIEN,ENTRY
 S STAT="" F  S STAT=$O(ARRAY(STAT)) Q:STAT=""  D
 .S ENTRY="" F  S ENTRY=$O(ARRAY(STAT,ENTRY)) Q:ENTRY=""  D
 ..S NARR="" F  S NARR=$O(ARRAY(STAT,ENTRY,NARR)) Q:NARR=""  D
 ...S PRIEN="" F  S PRIEN=$O(ARRAY(STAT,ENTRY,NARR,PRIEN)) Q:PRIEN=""  D
 ....S PCNT=PCNT+1
 ....D ADD($J(PCNT,2)_")"_NARR_" "_"("_STAT_")")
 ....D QUAL^BTIUPV1(PRIEN,.CNT)
 ....D VOB^BTIUPV2(DFN,PRIEN,VIEN,.CNT)  ;V OB notes
 Q
ADD(DATA) ;add to list
 S CNT=CNT+1
 S @TARGET@(CNT,0)=DATA
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOPRDD",$J) Q $NA(^($J))

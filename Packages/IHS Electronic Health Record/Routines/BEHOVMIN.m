BEHOVMIN ;MSC/IND/DKM - Installation Support ;16-Jul-2014 10:21;MGH
 ;;1.1;BEH COMPONENTS;**001002,001005,001006,001010**;Mar 20, 2007
 ;=================================================================
PREINIT ;EP - Preinitialization
 ;D BEHMSR("02 SATURATION","O2 SATURATION")
 Q
POSTINIT ;EP - Postinitialization
 ;N LP,CLS
 ;F LP=0:1 S CLS=$P($T(CANENTER+LP),";;",2) Q:'$L(CLS)  D
 ;.D ADD^XPAR("CLS."_CLS,"BEHOVM DATA ENTRY",,"YES")
 ;D ADD^XPAR("PKG","BEHOVM USE VMSR",,$G(DUZ("AG"))="I")
 ;D REGMENU^BEHUTIL("BEHOVM MAIN",,"VIT")
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,DIR
 S ZTRTN="BMI^BEHOVMIN",ZTIO="",ZTSAVE("DUZ")=""
 S ZTDESC="Store BMI on historical wts."
 D ^%ZTLOAD
 I $G(ZTSK) D
 .K ^XTMP("BEHVMBMI")
 .N X,X1,X2 S X1=DT,X2=30
 .D C^%DTC
 .S ^XTMP("BEHVMBMI",0)=X_"^"_DT_"^"
 .S ^XTMP("BEHVMBMI","COUNT")=0
 .W !!,"A task has been queued in the background."
 .W !,"  The task number is "_$G(ZTSK)_"."
 .W !,"  To check on the status of the task, in programmer mode "
 .W !,"    type D STATUS^BEHOVMIN"
 Q
 ; Rename .01 field of BEH Measurement file
BEHMSR(X,Y) ;
 N IEN,FDA
 S IEN=$O(^BEHOVM(90460.01,"B",X,0))
 Q:'IEN
 S FDA(90460.01,IEN_",",.01)=Y
 D FILE^DIE(,"FDA")
 Q
BMI ;EP-
 ;Loop through all Wt measurements for all patients. Get the visit IEN
 ;check for a BMI already on that visit. If not, calculate and store
 N VTWT,IEN,NODE,VSIT,WT,VTBMI,OK,PT,WTDT,RET,CNT
 S OK=0
 S ^XTMP("BEHVMBMI","STARTDT")=$$NOW^XLFDT
 S VTWT=$$VTYPE^BEHOVM("WT"),VTBMI=$$VTYPE^BEHOVM("BMI")
 S IEN="",CNT=0
 F  S IEN=$O(^AUPNVMSR("B",VTWT,IEN)) Q:IEN=""  D
 .S NODE=$G(^AUPNVMSR(IEN,0))
 .S VSIT=$P(NODE,U,3)
 .Q:'VSIT
 .S WT=$P(NODE,U,4)
 .S PT=$P(NODE,U,2)
 .S WTDT=$$GET1^DIQ(9000010.01,IEN,1201,"I")
 .I WTDT="" S WTDT=$$GET1^DIQ(9000010,VSIT,.01,"I")
 .Q:'WTDT
 .;Check if BMI already exists on this visit; quit if true
 .S OK=$$CHECK(VSIT)
 .Q:+OK
 .S RET=""
 .D BMISAVE^BEHOVM4(.RET,PT,WT,WTDT,VSIT)
 .I RET'=""  D
 ..S CNT=CNT+1
 ..S ^XTMP("BEHVMBMI","COUNT")=CNT
 .K RET
 S ^XTMP("BEHVMBMI","ENDDT")=$$NOW^XLFDT
 Q
 ;
CHECK(VSIT) ;See if BMI already exists
 N I,RET
 S RET=0
 S I="" F  S I=$O(^AUPNVMSR("AD",VSIT,I)) Q:'+I!(+RET)  D
 .I $P($G(^AUPNVMSR(I,0)),U,1)=VTBMI S RET=1
 Q RET
STATUS ;check on status of VS xref indexing
 I $G(^XTMP("BEHVMBMI","ENDDT")) D
 . N START,END,X,Y
 . W !,"Data update completed!"
 . S Y=$G(^XTMP("BEHVMBMI","STARTDT")) D DD^%DT
 . W !,"Task started: "_Y
 . S Y=$G(^XTMP("BEHVMBMI","ENDDT")) D DD^%DT
 . W !,"Task ended:   "_Y
 . S Y=$G(^XTMP("BEHVMBMI","COUNT"))
 . W !,"Items Stored: "_Y
 I '$G(^XTMP("BEHVMBMI","ENDDT")) D
 . W !,"Still working on the update."
 . I $G(^XTMP("BEHVMBMI","COUNT"))=0 W !,"You must have tasked it!"
 Q
 ; List of user classes that can enter vitals by default
CANENTER ;;PROVIDER
 ;;NURSE
 ;;NURSE PRACTITIONER
 ;;NURSE LICENSED PRACTICAL
 ;;NURSING ASSISTANT
 ;;NURSING SUPERVISOR
 ;;NURSE CLINICAL SPECIALIST
 ;;

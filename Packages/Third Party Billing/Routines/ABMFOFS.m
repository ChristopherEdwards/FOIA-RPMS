ABMFOFS ; IHS/ASDST/DMJ - UPDATE FEE TABLE FROM FOREIGN FILE ; 
 ;;2.6;IHS Third Party Billing;**1,2**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20355 - Modified default to be Read
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - corrected cnts for categories
 ;   and display
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Effective dates added to fee sched
 ;
START ;START HERE
 W !!,"FEE SCHEDULE UPDATE FROM FOREIGN FILE"
 W !!,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")," It is advisable to do a global save of global ^ABMDFEE prior to"
 W !,"running this procedure.",!
 S DIR(0)="Y",DIR("A")="Continue",DIR("B")="NO"
 D ^DIR K DIR
 Q:Y'=1
 S DIC="^ABMDFEE("
 S DIC(0)="AEMQ"
 S DIC("A")="Enter Fee Schedule to Update: "
 S DIC("B")=1
 D ^DIC K DIC
 Q:Y<0
 S ABMTB=+Y
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DIR(0)="D"
 S DIR("A")="What is the effective date? "
 S DIR("B")="TODAY"
 D ^DIR K DIR
 Q:$D(DIRUT)
 S ABMEDT=Y
 D ^XBFMK
 S DIR(0)="N^0:200"
 S DIR("A")="What percentile are you loading? "
 D ^DIR K DIR
 Q:$D(DIRUT)
 S ABMPRCNT=Y
 ;end new code 3PMS10003A
DF ;DESCRIBE FLAT FILE
 W !!,"FOREIGN HOST FILE DESCRIPTION",!
 S DIR(0)="FA",DIR("A")="What is the host file record delimiter? ",DIR("B")="," D ^DIR K DIR Q:$D(DIRUT)  S ABMDLM=Y
 S DIR(0)="NA",DIR("A")="Which piece of the host file record contains the cpt code? ",DIR("B")=1 D ^DIR K DIR Q:$D(DIRUT)  S ABMCPC=Y
 S DIR(0)="NA",DIR("A")="Which piece of the host file record contains the price? ",DIR("B")=2 D ^DIR K DIR Q:$D(DIRUT)  S ABMPPC=Y
 W !!,"Some providers of fee schedules (Medicode for example) break out"
 W !,"the professional and technical portions into separate records."
 W !,"The next section will determine how to identify the different"
 W !,"record types.",!
 ;start old code abm*2.6*2 3PMS10003A
 ;S DIR(0)="Y",DIR("A")="Include only certain record types",DIR("B")="NO"  D ^DIR K DIR
 ;I Y=1 D
 ;.S DIR(0)="NA",DIR("A")="Examine piece: ",DIR("B")=4 D ^DIR K DIR
 ;.Q:'Y
 ;.S ABMIPC=+Y
 ;.S DIR(0)="F^1:30",DIR("A")="for value ",DIR("B")="G" D ^DIR K DIR
 ;.Q:Y=""
 ;.S ABMIVAL=Y
 ;end old code start new code
 W !,"This section will load the different record types (global/technical/professional)"
 ;global
 S DIR(0)="NA",DIR("A")="What column is the record type located in: ",DIR("B")=4 D ^DIR K DIR
 Q:'Y
 S ABMIPC=+Y
 S DIR(0)="F^1:30",DIR("A")="Indicate value that identifies GLOBAL charge ",DIR("B")="G" D ^DIR K DIR
 Q:Y=""
 S ABMGVAL=Y
 ;technical
 S DIR(0)="F^1:30",DIR("A")="Indicate value that identifies TECHNICAL charge ",DIR("B")="TC" D ^DIR K DIR
 Q:Y=""
 S ABMTVAL=Y
 ;professional
 S DIR(0)="F^1:30",DIR("A")="Indicate value that identifies PROFESSIONAL charge ",DIR("B")="26" D ^DIR K DIR
 Q:Y=""
 S ABMPVAL=Y
 K ABMCNT
 ;end new code 3PMS10003A
BY ;BYPASS WITH ABMTB DEFINED
 I '$G(DT) S DT=$$HTFM^XLFDT($H)\1
 W !!,"OPEN AND READ FOREIGN FILE",!
 S %ZIS("HFSMODE")="R"
 S %ZIS("B")="HOST FILE SERVER" D ^%ZIS Q:POP
 F ABMCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X:DTIME Q:$$STATUS^%ZISH
 .;I $G(ABMIVAL)'="" Q:($$TRIM^ABMUTLP($P(X,ABMDLM,ABMIPC),"R"," ")'=ABMIVAL)  ;abm*2.6*2 3PMS10003A
 .S ABMIVAL=$$TRIM^ABMUTLP($P(X,ABMDLM,ABMIPC),"LR"," ")  ;abm*2.6*2 3PMS10003A
 .S ABMCODE=$P(X,ABMDLM,ABMCPC)
 .;start old code abm*2.6*2 3PMS10003A
 .;S ABMCODE=$TR(ABMCODE,"""")
 .;Q:$L(ABMCODE)<4
 .;I $L(ABMCODE)=4,'$D(^AUTTADA("B",ABMCODE)) Q
 .;I $L(ABMCODE)'=4,'$D(^ICPT("B",ABMCODE)) Q
 .;end old code start new code 3PMS10003A
 .S ABMCODE=$TR(ABMCODE," """)
 .I $L(ABMCODE)<4 D  Q
 ..I DUZ(0)["@" U 0 W !,ABMCODE_" "_ABMIVAL
 .I $L(ABMCODE)=4,'$D(^AUTTADA("B",ABMCODE)) D  Q
 ..I DUZ(0)["@" U 0 W !,ABMCODE_" "_ABMIVAL
 .I $L(ABMCODE)'=4,'$D(^ICPT("B",ABMCODE)) D  Q
 ..I DUZ(0)["@" U 0 W !,ABMCODE_" "_ABMIVAL
 .;end new code 3PMS10003A
 .I ((ABMIVAL'="")&(("^"_ABMGVAL_"^"_ABMTVAL_"^"_ABMPVAL_"^")'[("^"_ABMIVAL_"^"))) D  Q
 ..I DUZ(0)["@" U 0 W !,ABMCODE_" "_ABMIVAL
 .S ABMPRICE=$P(X,ABMDLM,ABMPPC)
 .;S ABMPRICE=+$TR(ABMPRICE,"$"",")  ;abm*2.6*2 3PMS10003A
 .S ABMPRICE=+$TR(ABMPRICE,"$"", ")  ;abm*2.6*2 3PMS10003A
 .D SEC
 .D:ABMSC'=21 FILE
 .D:ABMSC=21 DFILE
 .I '(ABMCNT#10) U IO(0) W "."
 D HK
 Q
SEC ;WHAT SECTION?
 I $L(ABMCODE)=4 S ABMSC=21 Q
 I ABMCODE?1U4N S ABMSC=13 Q
 I ABMCODE<10000 S ABMSC=23 Q
 I ABMCODE<70000 S ABMSC=11 Q
 I ABMCODE<80000 S ABMSC=15 Q
 I ABMCODE<90000 S ABMSC=17 Q
 S ABMSC=19
 I '$D(^ABMDFEE(ABMTB,ABMSC)) D
 .S ^ABMDFEE(ABMTB,ABMSC,0)="^9002274.01"_ABMSC_"P^^"
 Q
FILE ;FILE CODE
 S ABMPTR=$O(^ICPT("B",ABMCODE,0))
 Q:'ABMPTR
 ;S ^ABMDFEE(ABMTB,ABMSC,ABMPTR,0)=ABMPTR_"^"_ABMPRICE_"^"_DT  ;abm*2.6*2 3PMS10003A
 S:ABMIVAL="G"!(ABMIVAL="") ^ABMDFEE(ABMTB,ABMSC,ABMPTR,0)=ABMPTR_"^"_ABMPRICE_"^"_DT  ;abm*2.6*2 3PMS10003A
 S ^ABMDFEE(ABMTB,ABMSC,"B",ABMPTR,ABMPTR)=""
 S ABMCNT(ABMSC)=+$G(ABMCNT(ABMSC))+1  ;abm*2.6*1 NO HEAT
 D EFFDT  ;abm*2.6*2 3PMS10003A
 Q
DFILE ;FILE ADA CODE IN DENTAL SECTION
 S ABMPTR=$O(^AUTTADA("B",ABMCODE,0))
 Q:'ABMPTR
 ;S ^ABMDFEE(ABMTB,21,1_ABMCODE,0)=ABMPTR_"^"_ABMPRICE_"^"_ABMCODE_"^"_DT  ;abm*2.6*2 3PMS10003A
 S:ABMIVAL="G"!(ABMIVAL="") ^ABMDFEE(ABMTB,21,1_ABMCODE,0)=ABMPTR_"^"_ABMPRICE_"^"_ABMCODE_"^"_DT  ;abm*2.6*2 3PMS10003A
 S ^ABMDFEE(ABMTB,21,"B",ABMPTR,1_ABMCODE)=""
 S ABMCNT(21)=+$G(ABMCNT(21))+1  ;abm*2.6*1 NO HEAT
 D EFFDT  ;abm*2.6*2 3PMS10003A
 Q
 ;start new code abm*2.6*2 3PMS10003A
EFFDT ;
 D ^XBFMK
 S DA(2)=ABMTB
 S DA(1)=$S(ABMSC=21:1_ABMCODE,1:ABMPTR)
 S DIC="^ABMDFEE("_DA(2)_","_ABMSC_","_DA(1)_",1,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(9002274.01_ABMSC,1,0),U,2)
 S X=ABMEDT
 D ^DIC
 S ABMENTRY=+Y
 D ^XBFMK
 S DA(2)=ABMTB
 S DA(1)=$S(ABMSC=21:1_ABMCODE,1:ABMPTR)
 S DIE="^ABMDFEE("_DA(2)_","_ABMSC_","_DA(1)_",1,"
 S DA=ABMENTRY
 I ((ABMIVAL=ABMGVAL)!($G(ABMIVAL)="")) S DR=".02////"_ABMPRICE
 I (ABMIVAL=ABMTVAL) S DR=".03////"_ABMPRICE
 I (ABMIVAL=ABMPVAL) S DR=".04////"_ABMPRICE
 I $G(DR)'="" S DR=DR_";.05////"_DT_";.06////"_DUZ
 D ^DIE
 S ABMCNT(ABMSC,$S(($G(ABMIVAL)'=""):ABMIVAL,1:"G"))=+$G(ABMCNT(ABMSC,$S(($G(ABMIVAL)'=""):ABMIVAL,1:"G")))+1
 Q
 ;end new code 3PMS10003A
HK ;HOUSE CLEANING
 D ^%ZISC
 ;start new code abm*2.6*2 3PMS10003A
 W !!,"Will now ensure all global charges are populated where applicable..."
 S ABMSC=0
 F  S ABMSC=$O(^ABMDFEE(ABMTB,ABMSC)) Q:(+$G(ABMSC)=0)  D
 .S ABMCD=0
 .F  S ABMCD=$O(^ABMDFEE(ABMTB,ABMSC,ABMCD)) Q:(+$G(ABMCD)=0)  D
 ..I $D(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,"B",ABMEDT)) D
 ...S ABMEDFN=$O(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,"B",ABMEDT,0))
 ...Q:(+$P($G(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,ABMEDFN,0)),U,2)'=0)  ;already has global charge
 ...I (+$P($G(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,ABMEDFN,0)),U,3)'=0)&(+$P($G(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,ABMEDFN,0)),U,4)'=0)  D
 ....D ^XBFMK
 ....S DA(2)=ABMTB
 ....S DA(1)=ABMCD
 ....S DIE="^ABMDFEE("_DA(2)_","_ABMSC_","_DA(1)_",1,"
 ....S DA=ABMEDFN
 ....S DR=".02////"_($P($G(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,ABMEDFN,0)),U,3)+($P($G(^ABMDFEE(ABMTB,ABMSC,ABMCD,1,ABMEDFN,0)),U,4)))
 ....D ^DIE
 ;end new code 3PMS10003A
 ;W !!,ABMCNT," records updated.",!  ;abm*2.6*1 NO HEAT
 ;start new code abm*2.6*1 NO HEAT
 W !!,"Records updated by category"
 S ABMRCNT=0
 F  S ABMRCNT=$O(ABMCNT(ABMRCNT)) Q:'ABMRCNT  D
 .W !?3,$G(ABMCNT(ABMRCNT)),?10
 .I ABMRCNT=11 W "SURGICAL "
 .I ABMRCNT=13 W "HCPCS "
 .I ABMRCNT=15 W "RADIOLOGY "
 .I ABMRCNT=17 W "LABORATORY "
 .I ABMRCNT=19 W "MEDICAL "
 .I ABMRCNT=21 W "DENTAL "
 .I ABMRCNT=23 W "ANESTHESIA "
 .I ABMRCNT=25 W "DRUG "
 .;start new code abm*2.6*2 3PMS10003A
 .S ABMIVAL=""
 .F  S ABMIVAL=$O(ABMCNT(ABMRCNT,ABMIVAL)) Q:($G(ABMIVAL)="")  D
 ..W !?5,ABMIVAL,?8,$G(ABMCNT(ABMRCNT,ABMIVAL))
 .;end new code 3PMS10003A
 ;end new code NO HEAT
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DA(1)=ABMTB
 S DIC="^ABMDFEE("_DA(1)_",1,"
 S DIC(0)="MQL"
 S DIC("P")=$P(^DD(9002274.01,1,0),U,2)
 D NOW^%DTC
 S X=%
 S DIC("DR")=".02////"_DUZ_";.03////"_ABMPRCNT
 D ^DIC
 ;end new code 3PMS10003A
 S DIR(0)="E" D ^DIR K DIR
 K ABMSC,ABMCODE,ABMPRICE,ABMDLM,ABMCPC,ABMPPC,ABMCNT,ABMIPC,ABMIVAL
 Q

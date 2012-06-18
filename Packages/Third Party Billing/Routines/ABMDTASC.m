ABMDTASC ; IHS/ASDST/DMJ - UPDATE ASC FEE TABLE ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ; IHS/SD/SDR - v2.5 p9 - IM12137 - Added code to put group 9 prompts in
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to populated effective dates
 ;
START ;START
 W !!,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 W " We recommend doing a global save of global ^ABMDFEE before proceeding.",!!
 S DIC="^ABMDFEE(",DIC(0)="AEMNQ"
 S DIC("A")="Enter the Number of your ASC Fee Schedule: "
 S DIC("B")=2
 D ^DIC K DIC
 Q:+Y<0  S ABMJ=+Y
 D CURRATE
 D RATE
 Q:$D(DUOUT)!$D(DTOUT)
 S $P(ABMEQ,"=",80)=""
 W !!,ABMEQ,!
 F ABMI=1:1:9 W !,"Rate for ASC Payment Group ",ABMI,": $",ABM(ABMI)
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="NO"
 D ^DIR K DIR
 Q:Y'=1
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DIR(0)="D"
 S DIR("A")="What is the effective date? "
 S DIR("B")="TODAY"
 D ^DIR K DIR
 Q:$D(DIRUT)
 S ABMEDT=Y
 ;end new code 3PMS10003A
 D LOOP
 K ABMPG,ABMEQ
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DA(1)=ABMJ
 S DIC="^ABMDFEE("_DA(1)_",1,"
 S DIC(0)="MQL"
 S DIC("P")=$P(^DD(9002274.01,1,0),U,2)
 D NOW^%DTC
 S X=%
 S DIC("DR")=".02////"_DUZ_";.06////Y"
 D ^DIC
 ;end new code 3PMS10003A
 W !!,"Finished.",!!
 S DIR(0)="E" D ^DIR K DIR
 Q
CURRATE ;
 S ABMI=9999
 F  S ABMI=$O(^ICPT(ABMI)) Q:ABMI>69999  D
 .S ABMPG=$P($$IHSCPT^ABMCVAPI(ABMI,""),U,6)  ;CSV-c
 .Q:'ABMPG
 .Q:ABMPG>9
 .Q:'$D(^ABMDFEE(ABMJ,11,ABMI,0))
 .S ABMRATE(+ABMPG)=$P($G(^ABMDFEE(ABMJ,11,ABMI,0)),U,2)
 W !!,"CURRENT RATES"
 F ABMI=1:1:9 W !,?3,"Rate for ASC Payment Group ",ABMI,":$",+$G(ABMRATE(ABMI))
 W !
 K ABMRATE
 Q
RATE ;ENTER RATES FOR THE ASC PAYMENT GROUPS
 K DUOUT,DTOUT
 S DIR(0)="N"
 W !,"NEW RATES"
 F ABMI=1:1:9 D  Q:$D(DUOUT)!$D(DTOUT)
 .S DIR("A")="Enter Rate for ASC Payment Group #"_ABMI
 .D ^DIR
 .Q:$D(DUOUT)!$D(DTOUT)
 .S ABM(ABMI)=Y
 K DIR
 Q
LOOP ;LOOP THROUGH CPT SURGERY
 S ABMI=9999
 F  S ABMI=$O(^ICPT(ABMI)) Q:ABMI>69999  D
 .S ABMPG=$P($$IHSCPT^ABMCVAPI(ABMI,""),U,6)  ;CSV-c
 .Q:'ABMPG
 .Q:ABMPG>9
 .;I '$D(^ABMDFEE(ABMJ,11,ABMI,0)) D NEW Q:+Y<0  ;abm*2.6*2 3PMS10003A
 .I '$D(^ABMDFEE(ABMJ,11,ABMI,0)) D NEW  ;abm*2.6*2 3PMS10003A
 .S $P(^ABMDFEE(ABMJ,11,ABMI,0),U,2)=ABM(+ABMPG)
 .D EFFDT  ;abm*2.6*2 3PMS10003A
 .W "."
 Q
NEW ;NEW ENTRY IN FEE TABLE
 S ^ABMDFEE(ABMJ,11,ABMI,0)=ABMI
 S ^ABMDFEE(ABMJ,11,"B",ABMI,ABMI)=""
 Q
 ;start new code abm*2.6*2 3PMS10003A
EFFDT ;
 D ^XBFMK
 S DA(2)=ABMJ
 S DA(1)=ABMI
 S DIC="^ABMDFEE("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(9002274.0111,1,0),U,2)
 S X=ABMEDT
 D ^DIC
 S ABMENTRY=+Y
 D ^XBFMK
 S DA(2)=ABMJ
 S DA(1)=ABMI
 S DIE="^ABMDFEE("_DA(2)_",11,"_DA(1)_",1,"
 S DA=ABMENTRY
 S DR=".02////"_ABM(+ABMPG)
 S DR=DR_";.05////"_DT_";.06////"_DUZ
 D ^DIE
 Q
 ;end new code 3PMS10003A

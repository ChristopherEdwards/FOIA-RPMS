ABMDFAWP ; IHS/ASDST/DMJ - IMPORT AWP FROM DRUG FILE ;   
 ;;2.6;IHS Third Party Billing System;**2**;NOV 09, 2009
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - put data in new effective date multiple
START ;START
 K ABMID
 W !!,"This option will transfer the AWP price per dispense unit"
 W !,"or the cost per dispense unit from the drug file to the Third"
 W !,"Party Billing Fee Table, and will apply an optional user specified"
 W !,"percentage increase or decrease.",!!
 W $$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")," We advise saving global ABMDFEE before continuing.",!
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="NO"
 D ^DIR K DIR Q:Y'=1
 W !
 S DIC="^ABMDFEE("
 S DIC(0)="AEMQ"
 S DIC("A")="Update which Fee Table Entry? "
 S DIC("B")=1
 D ^DIC
 Q:Y<0
 S ABMTABLE=+Y
 S DIR(0)="S^1:Average Wholesale Price (AWP) per Dispense Unit                                 (field# 9999999.32);2:Price (cost) per Dispense Unit (field# 16)"
 S DIR("A")="Select Field from Drug File to Transfer"
 S DIR("B")=1
 D ^DIR K DIR
 Q:'Y
 S ABMFIELD=+Y
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DIR(0)="D"
 S DIR("A")="What is the effective date? "
 S DIR("B")="TODAY"
 D ^DIR K DIR
 Q:$D(DIRUT)
 S ABMEDT=Y
 ;end new code 3PMS10003A
 W !
 S DIR(0)="Y"
 S DIR("A")="Apply percentage increase or decrease"
 S DIR("B")="NO"
 D ^DIR K DIR
 I Y D
 .S DIR(0)="S^1:INCREASE;2:DECREASE" D ^DIR K DIR Q:'Y
 .S ABMID=Y
 .S DIR(0)="N^0:"_$S(ABMID=1:99999,1:100)
 .S DIR("A")="Enter percent"
 .S DIR("B")=10
 .D ^DIR K DIR
 .S ABMPCT=+Y
 .S ABMOPCT=ABMPCT  ;store what user entered  ;abm*2.6*2 3PMS10003A
 W !!,"I will move the ",$P("Average Wholesale Price per Dispense Unit^Price (cost) per Dispense Unit","^",ABMFIELD)," field from the "
 ;W !,"Drug File to the 3P Fee Table.",!  ;abm*2.6*2 3PMS10003A
 W !,"Drug File to the 3P Fee Table with an effective date of "_$$SDT^ABMDUTL(ABMEDT)_".",!  ;abm*2.6*2 3PMS10003A
 I $G(ABMID) D
 .W !,"I will apply a ",ABMPCT," percent ",$P("increase^decrease","^",ABMID),".",!
 S DIR(0)="Y"
 S DIR("A")="Continue",DIR("B")="NO"
 D ^DIR K DIR
 Q:Y'=1
 S ABMSUB=$S(ABMFIELD=1:999999931,1:660)
 S ABMPCE=$S(ABMFIELD=1:2,1:6)
 I $G(ABMID)=2 D
 .S ABMPCT=100-ABMPCT
 .S ABMPCT=ABMPCT/100
 I $G(ABMID)=1 D
 .S ABMPCT=ABMPCT/100
 .S ABMPCT=1+ABMPCT
LOOP ;LOOP THROUGH DRUG FILE
 ;S DA(1)=ABMTABLE  ;abm*2.6*2 3PMS10003A
 ;S DIE="^ABMDFEE(DA(1),25,"  ;abm*2.6*2 3PMS10003A
 I '$D(^ABMDFEE(ABMTABLE,25,0)) S ^ABMDFEE(ABMTABLE,25,0)="^9002274.0125P"  ;abm*2.6*2 3PMS10003A
 S ABMI=0
 F  S ABMI=$O(^PSDRUG(ABMI)) Q:'ABMI  D
 .S ABMPRICE=$P($G(^PSDRUG(ABMI,ABMSUB)),U,ABMPCE)
 .I $G(ABMID) D
 ..S ABMPRICE=ABMPRICE*ABMPCT
 ..S ABMPRICE=$J(ABMPRICE,1,3)
 .S:+ABMPRICE<0 ABMPRICE=0
 .Q:'ABMPRICE
 .I '$D(^ABMDFEE(ABMTABLE,25,ABMI)) D
 ..S ^ABMDFEE(ABMTABLE,25,ABMI,0)=ABMI
 ..S ^ABMDFEE(ABMTABLE,25,"B",ABMI,ABMI)=""
 .D ^XBFMK  ;abm*2.6*2 3PMS10003A
 .S DA(1)=ABMTABLE  ;abm*2.6*2 3PMS10003A
 .S DIE="^ABMDFEE("_DA(1)_",25,"  ;abm*2.6*2 3PMS10003A
 .S DR=".02///"_ABMPRICE
 .S DA=ABMI
 .D ^DIE
 .D EFFDT
 .W "."
 ;start new code abm*2.6*2 3PMS10003A
 D ^XBFMK
 S DA(1)=ABMTABLE
 S DIC="^ABMDFEE("_DA(1)_",1,"
 S DIC(0)="MQL"
 S DIC("P")=$P(^DD(9002274.01,1,0),U,2)
 D NOW^%DTC
 S X=%
 S DIC("DR")=".02////"_DUZ
 I +$G(ABMPCT)'=0 S DIC("DR")=DIC("DR")_";.04////"_$S(ABMID=1:"I",1:"D")_";.05////"_ABMOPCT
 D ^DIC
 ;end new code 3PMS10003A
 K DIC,ABMPRICE,ABMPCT,ABMID,ABMSUB,ABMI,ABMPCE
 W !!,"Finished.",!
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;start new code abm*2.6*2 3PMS10003A
EFFDT ;
 D ^XBFMK
 S DA(2)=ABMTABLE
 S DA(1)=ABMI
 S DIC="^ABMDFEE("_DA(2)_",25,"_DA(1)_",1,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(9002274.0125,1,0),U,2)
 S X=ABMEDT
 D ^DIC
 S ABMENTRY=+Y
 D ^XBFMK
 S DA(2)=ABMTABLE
 S DA(1)=ABMI
 S DIE="^ABMDFEE("_DA(2)_",25,"_DA(1)_",1,"
 S DA=ABMENTRY
 S DR=".02////"_ABMPRICE
 S DR=DR_";.05////"_DT_";.06////"_DUZ
 D ^DIE
 Q
 ;end new code 3PMS10003A

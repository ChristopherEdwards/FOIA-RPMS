ABMDE8C ; IHS/ASDST/DMJ - Page 8 - ROOM AND BOARD ; 
 ;;2.6;IHS Third Party Billing System;**2,6,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16660 - 4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p10 - IM20018 - Added CPT prompt
 ; IHS/SD/SDR - v2.5 p12 - IM24096 - Changed code to correct inpatient rev codes
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - DOS defaults but no prompt to edit it
 ;
DISP ;EP
 K ABMZ,DIC S ABMZ("TITL")="REVENUE CODE",ABMZ("PG")="8C"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
FEE S ABMZ("CAT")=31,ABMZ("SUB")=25,ABMZ("DAYS")=0
 S ABMZ("DR")=";W !;.02//1",ABMZ("CHRG")=";W !;.03",ABMZ("ITEM")="REVENUE CODE",ABMZ("DIC")="^AUTTREVN("
 S ABMZ("X")="X",(ABMZ("TOTL"),ABMZ("DAYS"))=0
 D C^ABMDE8X
 D HD G LOOP
HD W !?71,"TOTAL"
 W !?5,"REVENUE CODE",?37,"CPT",?44,"CHARGE",?54,"DAYS",?61,"UNITS",?71,"CHARGE"
 W !?5,"=============================",?37,"===",?44,"======",?54,"====",?61,"=====",?70,"========="
 Q
LOOP ;LOOP
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 I ABMZ("NUM")>0 W !?54,"====",?70,"=========",!?53,$J(ABMZ("DAYS"),4),?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),25,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("UNIT")=$P(ABM("X0"),U,2)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMZ(ABM("I"))=$$GETREV^ABMDUTL(ABM("X"))_U_ABM_U_$P(ABM("X0"),U,2)_U_$S($P(ABM("X0"),U,7):$P($G(^ICPT($P(ABM("X0"),U,7),0)),U),1:"")
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 I ABM("X")\10=17,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U)'=85 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".51////85" D ^DIE
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",4) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",4)),!
 W ?5,$P(ABMZ(ABM("I")),U)
 S ABMU(1)="?36"_U_$P(ABMZ(ABM("I")),U,4)
 S ABMU(2)="?44"_U_$J($P(ABM("X0"),U,3)+$P(ABM("X0"),U,6),6,2)
 I (+ABM("X")>99&(+ABM("X")<220)) S ABMU(3)="?54"_U_$J(ABMZ("UNIT"),3),ABMZ("DAYS")=ABMZ("UNIT")+ABMZ("DAYS")
 E  S ABMU(3)="?56"_U_0
 S ABMU(4)="?62"_U_$J(ABMZ("UNIT"),3)
 S ABMU(5)="?70"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,3))+$P(ABM("X0"),U,6),",",2),9)
 S ABMZ("TOTL")=($P(ABM("X0"),U,3)*ABMZ("UNIT"))+$P(ABM("X0"),U,6)+ABMZ("TOTL")
 S ABMU("TXT")=$P(^AUTTREVN(ABM("X"),0),U,2)
 S ABMU("RM")=37,ABMU("LM")=10 D ^ABMDWRAP
 Q
 ;
XIT K ABM
 Q
A ;ADD ENTRY
 S DIC("P")=$P(^DD(9002274.3,25,0),U,2)
 S DIC="^AUTTREVN(",DIC(0)="AEMQ"
 K DIC("A")
 D ^DIC
 Q:+Y<0  S ABMZ("RVCODE")=+Y
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),DA(1),25,",X=ABMZ("RVCODE")
 K DD,DO D FILE^DICN
 Q:+Y<0  S DA=+Y
 S ABMZ("NUM")=+$G(ABMZ("NUM"))+1
 D DEL100
E ;EDIT EXISTING ENTRY
 I '$G(ABMZ("NUM")) G A
 I '$G(ABMZ("RVCODE")) D
 .K DA
 .S DA(1)=ABMP("CDFN")
 .I ABMZ("NUM")=1 S Y=1
 .E  S DIR(0)="NO^1:"_ABMZ("NUM") D ^DIR K DIR Q:'Y
 .S DA=$P(ABMZ(Y),"^",2)
 .S ABMZ("RVCODE")=$P(^ABMDCLM(DUZ(2),DA(1),25,DA,0),U)
 Q:'$G(DA)
 ;S ABMZ("UC")=$P($G(^ABMDFEE(ABMP("FEE"),31,ABMZ("RVCODE"),0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("UC")=$P($$ONE^ABMFEAPI(ABMP("FEE"),31,ABMZ("RVCODE"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DIE="^ABMDCLM(DUZ(2),DA(1),25,"
 S DR=".02;.03//"_ABMZ("UC")_";.07"
 ;S:'$P(^AUTTREVN(ABMZ("RVCODE"),0),"^",5) DR=DR_";.04"  ;abm*2.6*6 NOHEAT
 S DR=DR_";.04"  ;abm*2.6*6 NOHEAT
 D ^DIE
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,DA,0)),U,7)'="",($P($G(^DIC(81.1,$P($G(^ICPT($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,DA,0)),U,7),0)),U,3),0)),U)["IMMUNIZATION") S DR="15//" D ^DIE  ;abm*2.6*6 5010  ;abm*2.6*8 HEAT41190
 S ABMTCPT=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,DA,0)),U,7)  ;abm*2.6*8 HEAT41190
 I ABMTCPT'="",$P($G(^ICPT($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),25,DA,0)),U,7),0)),U,3),($P($G(^DIC(81.1,$P($G(^ICPT(ABMTCPT,0)),U,3),0)),U)["IMMUNIZATION") S DR="15//" D ^DIE  ;abm*2.6*8 HEAT41190
 Q
DEL100 ;if 100 ask to delete
 Q:ABMZ("RVCODE")'=100
 W !!,"You have entered an all inclusive revenue code. Do you want to"
 W !,$$EN^ABMVDF("RVN"),"DELETE ALL",$$EN^ABMVDF("RVF")," line items from the other pages?",!
 S DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR
 Q:Y'=1
 W !
 N I F I=21,23,27,33,35,37,39,43,45 D
 .Q:'$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),I,0))
 .W !,$P(^DD(9002274.3,I,0),U)," deleted."
 .K ^ABMDCLM(DUZ(2),ABMP("CDFN"),I)
 W !
 Q

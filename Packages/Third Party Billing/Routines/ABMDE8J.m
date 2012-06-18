ABMDE8J ; IHS/ASDST/DMJ - Page 8 - SUPPLIES ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;
 ; IHS/DSD/LSL - 09/01/98 - Patch 2 - NOIS NDA-0898-180038
 ;             0.00 charges on HCFA because version 2.0 does not assume
 ;             1 for units.  Modify code to set units to 1 if not
 ;             already defined.
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ;
DISP K ABMZ,DIC
 S ABMZ("TITL")="CHARGE MASTER",ABMZ("PG")="8J"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D J^ABMDE8X
 S $P(ABMZ("="),"=",81)=""
 S ABMZ("SUB")=45
 S ABMZ("ITEM")="Supply Item",ABMZ("DIC")="^ABMCM("
 S ABMZ("X")="X",(ABM("FEE"),ABMZ("TOTL"))=0
 D HD G LOOP
HD W !?5,"REVN",?75,"TOTAL"
 W !?5,"CODE",?31,"ITEM",?65,"QTY",?74,"CHARGE"
 W !,ABMZ("=")
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),45,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 I ABMZ("NUM")>0 W !,?72,"========",!?5,"TOTAL",?71,$J("$"_($FN(ABMZ("TOTL"),",",2)),9)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),45,ABM("X"),0)
 Q:'$D(^ABMCM(+ABM("X0"),0))
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMZ(ABM("I"))=$P(^ABMCM(+ABM("X0"),0),U)_U_ABM("X")_U_$P(ABM("X0"),U,2)
EOP I $Y>(IOSL-8) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",2) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",2)),!
 W ?6,$P(ABM("X0"),"^",5)
 W ?12,$E($P(^ABMCM(+ABM("X0"),0),U),1,50)
 W ?65,$J(ABMZ("UNIT"),3)
 W ?72,$J($FN(($P(ABM("X0"),U,4)*ABMZ("UNIT")),",",2),8)
 S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")
 Q
XIT K ABM,ABMMODE
 Q
A ;ADD ENTRY
 I '$D(ABMDCLM(DUZ(2),ABMP("CDFN"),45)) D
 .S ^ABMDCLM(DUZ(2),ABMP("CDFN"),45,0)="^9002274.3045P^^"
 K DIC S DIC="^ABMCM(",DIC(0)="AEMQ"
 D ^DIC
 Q:+Y<0  S ABMZ("ITEM")=+Y
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),DA(1),45,",X=+Y
 K DD,DO D FILE^DICN
 Q:Y<0  S DA=+Y
 I '$G(ABMZ("NUM")) S ABMZ("NUM")=1
E ;EDIT EXISTING ENTRY
 D MODE^ABMDE8X
 I '$G(ABMZ("NUM")) G A
 I '$G(ABMZ("ITEM")) D  Q:'Y
 .S DA(1)=ABMP("CDFN")
 .I ABMZ("NUM")=1 S Y=1
 .E  S DIR(0)="NO^1:"_ABMZ("NUM") D ^DIR K DIR Q:'Y
 .S DA=$P(ABMZ(Y),"^",2)
 .S ABMZ("ITEM")=$P(^ABMDCLM(DUZ(2),DA(1),45,DA,0),U)
 S DIE="^ABMDCLM(DUZ(2),DA(1),45,"
 S DR=".02//"_$$SDT^ABMDUTL(ABMP("VDT"))
 D ^DIE Q:$D(Y)
 S DR=".03//1"
 D ^DIE Q:$D(Y)
 ;S DR=".04//"_+$P($G(^ABMDFEE(ABMP("FEE"),32,ABMZ("ITEM"),0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S DR=".04//"_+$P($$ONE^ABMFEAPI(ABMP("FEE"),32,ABMZ("ITEM"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 D ^DIE Q:$D(Y)
 I ^ABMDEXP(ABMMODE(10),0)["UB" D  Q:$D(Y)
 .S DR=".05//"_$P(^ABMCM(ABMZ("ITEM"),0),"^",2)
 .D ^DIE
 S ABMZ("HCPCS")=$P($$CPT^ABMCVAPI(+$P(^ABMCM(ABMZ("ITEM"),0),U,3),ABMP("VDT")),U,2)  ;CSV-c
 S DR=".07//"_ABMZ("HCPCS")
 D ^DIE Q:$D(Y)
 S ABM("X0")=^ABMDCLM(DUZ(2),DA(1),45,DA,0)
 I (^ABMDEXP(ABMMODE(10),0)["HCFA")!(^ABMDEXP(ABMMODE(10),0)["CMS") D
 .D DX^ABMDEMLC
 .S DR=".06////"_$G(Y(0))
 .D ^DIE
 S DR=".17///M" D ^DIE
 W !!
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" K DIR("B") D ^DIR K DIR
 Q

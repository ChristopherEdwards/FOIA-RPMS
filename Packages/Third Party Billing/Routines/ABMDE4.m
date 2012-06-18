ABMDE4 ; IHS/ASDST/DMJ - Edit Page 4 - Providers ;  
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Only allows providers on page 4
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20059
 ;   All providers displayed instead of one for each type
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4207 - If subpart NPI is populated show it
 ;   on page4
 ;
 Q:$D(ABMP("WORKSHEET"))
 K ABM,ABME,ABMZ
OPT K ABME D DISP G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 W !! S ABMP("OPT")="ADVNJBQ" S:ABM("NUM")=0 ABMP("ED")=1 D SEL^ABMDEOPT K ABMP("ED") I "AVD"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("DO")=$S($E(Y)="A":"A1",$E(Y)="V":"^ABMDE4A",1:"D1") D @ABM("DO")
 G OPT
 ;
DISP S ABMZ("TITL")="PROVIDER DATA",ABMZ("PG")=4
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1 G PROV
 D SUM^ABMDE1
 ;
PROV ; Provider Info
 K ABM("A"),ABM("O")
 S ABM("SUB")=41
 S ABM("DR")=";.03"
 S ABM("ITEM")="Provider"
 S ABM("DIC")="^VA(200,"
 S ABM("PRIM")=""
 S ABM("MD")=0
 S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIUS=""!(ABMNPIUS="L") D
 .W !?17,"PROVIDER",?39,"NUMBER",?59,"DISCIPLINE"
 .W !?8,"==========================",?36,"============",?50,"============================="
 I ABMNPIUS="N" D
 .W !?17,"PROVIDER",?40,"NPI",?59,"DISCIPLINE"
 .W !?8,"==========================",?36,"============",?50,"============================="
 I ABMNPIUS="B" D
 .W !?15,"PROVIDER",?34,"NPI",?45,"NUMBER",?62,"DISCIPLINE"
 .W !?8,"=====================",?30,"==========",?42,"===========",?55,"======================="
 S ABM("NUM")=0,ABM=""
 S ABM("I")=1
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM)) Q:ABM=""  D
 .S ABM("X")=""
 .F  S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM,ABM("X"))) Q:ABM("X")=""  D
 ..S ABM("NUM")=ABM("I") D PRV
 .S ABM("I")=ABM("I")+1
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["HCFA-1500",ABMP("EXP")'=15,$P(^ABMDPARM(DUZ(2),1,0),U,17)=2 Q
 I '$D(ABM("A")) D
 .Q:ABMP("EXP")=22
 .Q:ABMP("EXP")=23
 .S ABME(92)=""
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O")),$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0)),ABMP("PAGE")'[8 S ABME(2)=""
ER I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
PRV ;provider display
 S ABMTYP("A")="(attn)"
 S ABMTYP("O")="(oper)"
 S ABMTYP("T")="(other)"
 S ABMTYP("F")="(refer)"
 S ABMTYP("R")="(rend)"
 S ABMTYP("P")="(pursvc)"
 S ABMTYP("S")="(suprvs)"
 D SEL^ABMDE4X,AFFL^ABMDE4X
 I ABMNPIUS=""!(ABMNPIUS="L") D
 .W !,ABMTYP($P(ABM("X0"),U,2))
 .I $D(ABM($P(ABM("X0"),U,2))) W ?8,$P(ABM($P(ABM("X0"),U,2)),U),?36,ABM("PNUM"),?50,ABM("DISC")
 ;
 I ABMNPIUS="N" D
 .W !,ABMTYP($P(ABM("X0"),U,2))
 .I $D(ABM($P(ABM("X0"),U,2))) D
 ..W ?8,$P(ABM($P(ABM("X0"),U,2)),U)
 ..;W ?36,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)_"*",1:"")  ;abm*2.6*1 HEAT4207
 ..;start new code abm*2.6*1 HEAT4207
 ..S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ..W ?36,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)_"*",1:"")
 ..;end new code HEAT4207
 ..W ?50,ABM("DISC")
 ;
 I ABMNPIUS="B" D
 .W !,ABMTYP($P(ABM("X0"),U,2))
 .I $D(ABM($P(ABM("X0"),U,2))) D
 ..W ?8,$E($P(ABM($P(ABM("X0"),U,2)),U),1,20)
 ..;W ?30,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)_"*",1:"")  ;abm*2.6*1 HEAT4207
 ..;start new code abm*2.6*1 HEAT4207
 ..S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ..;W ?30,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)_"*",1:"")  ;abm*2.6*1
 ..;end new code HEAT4207
 ..S ABMNPI=0
 ..S ABMNPI=$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)
 ..I +ABMNPI<1 S ABMNPI=$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)_"*"
 ..W ?30,ABMNPI
 ..W ?42,ABM("PNUM")
 ..W ?55,ABM("DISC")
 Q
 ;
A1 ; Add Multiple
 W ! K DIC
 S DIC="^VA(200,",DIC(0)="QEAM"
 S DIC("A")="Select "_ABM("ITEM")_": "
 S DIC("S")="I $D(^VA(200,Y,""PS""))"
 D ^DIC K DIC
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(X="")
 I $D(ABM("A")) S ABM("ANS")="O"
 E  S ABM("ANS")="A"
 W ! S ABM("Y")=Y
 S DIR(0)="S^A:Attending;O:Operating;T:Other;F:Referring;R:Rendering;P:Purchased Service;S:Supervising"
 S DIR("A")="Provider Status",DIR("B")=ABM("ANS")
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("ANS")=Y,Y=ABM("Y")
 I $D(ABM("A"))&(ABM("ANS")="A") W !!?5,*7,"***Attending Provider are Already Established!***",!?5,"      (Delete as necessary to facilitate editing)",! H 2 Q
 I $D(ABM("O"))&(ABM("ANS")="O") W !!?5,*7,"***Operating Provider are Already Established!***",!?5,"      (Delete as necessary to facilitate editing)",! H 2 Q
A2 I +Y>0 K DD,DO S X=+Y,DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_","_ABM("SUB")_",",DIC("DR")=".02////"_ABM("ANS"),DIC(0)="LE"
 I  S:ABM("NUM")=0 ^ABMDCLM(DUZ(2),DA(1),ABM("SUB"),0)="^9002274.30"_ABM("SUB")_"P^^" D FILE^DICN
 Q
 ;
D1 ; Delete Multiple
 K DA
 I ABM("NUM")=0 W *7 Q
 S DIC="^ABMDCLM(DUZ(2),ABMP(""CDFN""),41,",DIC(0)="AEMQ"
 I ABM("NUM")=1 S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,0))
 I '$G(DA) D
 .S DIC("A")="Select Provider: " D ^DIC
 .Q:+Y<0  S DA=+Y
 Q:'$G(DA)
 S DIR(0)="Y",DIR("A")="SURE",DIR("B")="NO" D ^DIR K DIR Q:Y'=1
 S DIK=DIC,DA(1)=ABMP("CDFN") D ^DIK
 K DIC
 Q
 ;
XIT K ABM,ABME
 Q

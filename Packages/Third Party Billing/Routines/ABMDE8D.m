ABMDE8D ; IHS/SD/SDR - Page 8 - MEDICATIONS ; APR 05, 2002
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P8 - Rewrote routine - Request to completely change display
 ; IHS/SD/SDR - v2.5 p9 - IM16660 - 4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p9 - task 1 - Use service line provider multiple
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ;
DISP K ABMZ,DIC
 S ABMZ("TITL")="MEDICATIONS",ABMZ("PG")="8D"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D D^ABMDE8X
 S $P(ABMZ("="),"=",81)=""
 S ABMZ("SUB")=23,ABMZ("DIAG")=";.13"
 S ABMZ("ITEM")="Medication",ABMZ("DIC")="^PSDRUG("
 S ABMZ("X")="X",(ABM("FEE"),ABMZ("TOTL"))=0
 D HD G LOOP
HD W !?5,"REVN",?11,"CHARGE",?60,"DAYS",?74,"TOTAL"
 W !?5,"CODE",?11,"DATE",?30,"MEDICATION",?60,"SUPPLY",?68,"QTY",?74,"CHARGE"
 W !,ABMZ("=")
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 I ABMZ("NUM")>0 W !,?72,"========",!?5,"TOTAL",?71,$J("$"_($FN(ABMZ("TOTL"),",",2)),9)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),0)
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 Q:'$D(^PSDRUG(+ABM("X0"),0))  S ABMZ(ABM("I"))=$P(^(0),U)_U_ABM("X")_U_$P(ABM("X0"),U,2)
EOP I $Y>(IOSL-8) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),U,14) D
 .W ?5,$$GETREV^ABMDUTL($P(ABM("X0"),U,2))  ;rev code
 .W ?11,$$CDT^ABMDUTL($P(ABM("X0"),U,14))  ;charge date
 .I $P(ABM("X0"),U,28)'="",($P(ABM("X0"),U,14)'=$P(ABM("X0"),U,28)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,28))
 I $P(ABM("X0"),U,26)'="" W " (+)"  ;date disc
 I $P(ABM("X0"),U,27)'="" W " (*)"  ;RTS
 W ?30,$S($P(ABM("X0"),U,22)]"":"  Rx:"_$P($G(^PSRX($P(ABM("X0"),U,22),0)),U)_" ",$P($G(ABM("X0")),U,6)'="":" Rx: "_$P(ABM("X0"),U,6)_" ",1:"<No Rx>")  ;Rx number
 S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P","C","D",0))
 S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P","C","R",0))
 I ABMRPRV'="" D  ;rendering provider on line item
 .W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)_")"
 W !
 W ?4,$S($P($G(ABM("X0")),U,24)]"":$P(ABM("X0"),U,24)_" ",1:"<NO NDC>        ")  ;NDC number
 S ABMU("TXT")=$P(ABMZ(ABM("I")),U)  ;Medication
 N M7,M8,M9
 S M7=$P(ABM("X0"),U,7)  ;additive
 S M8=$P(ABM("X0"),U,8)  ;solution
 S M9=" "_$P(ABM("X0"),U,9)  ;narrative
 S ABMU("TXT")=ABMU("TXT")_" "_$S(M7&($D(^PS(52.6,+M7,0))):$P(^PS(52.6,M7,0),U)_M9,M8&($D(^PS(52.7,+M8,0))):$P(^(0),U)_M9,1:"")
 S ABMU("RM")=57
 S ABMU("LM")=22
 D ^ABMDWRAP
 W ?60,$J($P(ABM("X0"),U,20),3)  ;days supply
 W ?68,$J(ABMZ("UNIT"),3)  ;quantity
 W ?72,$J($FN(($P(ABM("X0"),U,4)*ABMZ("UNIT"))+$P(ABM("X0"),U,5),",",2),8)  ;total charge
 I $P(ABM("X0"),U,6)]"" D
 .N DA S DA=$O(^PSRX("B",$P(ABM("X0"),"^",6),0)) Q:'DA
 .S DIC="^PSRX(",DR=12,DIQ="ABM(",DIQ(0)="E" D EN^DIQ1 K DIQ
 .Q:ABM(52,DA,12,"E")=""
 .S ABMU("TXT")=$G(ABMU("TXT"))_" Comments: "_ABM(52,DA,12,"E")
 S ABM("FEE")=ABM("FEE")+$P(ABM("X0"),U,5)
 S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")+$P(ABM("X0"),U,5)
 Q
XIT K ABM,ABMMODE
 Q
A ;EP  ADD ENTRY
 K DIC
 S DIC="^PSDRUG("
 S DIC(0)="AEMQ"
 S DIC("P")=$P(^DD(9002274.3,23,0),U,2)
 D ^DIC
 Q:+Y<0  S ABMZ("DRUG")=+Y
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),DA(1),23,",X=+Y
 K DD,DO
 D FILE^DICN
 Q:Y<0  S DA=+Y
 I '$G(ABMZ("NUM")) S ABMZ("NUM")=1
E ;EDIT EXISTING ENTRY
 I +$G(ABMZ("NUM"))=0 W *7,!!,"There are no entries to edit, you must first ADD an entry.",! K DIR S DIR(0)="E" D ^DIR K DIR Q
 I '$G(ABMZ("DRUG")) D  Q:'Y
 .S DA(1)=ABMP("CDFN")
 .I ABMZ("NUM")=1 S Y=1
 .E  S DIR(0)="NO^1:"_ABMZ("NUM") D ^DIR K DIR Q:'Y
 .S DA=$P(ABMZ(Y),U,2)
 .S ABMZ("DRUG")=$P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),U)
 D MODE^ABMDE8X
 S DIE="^ABMDCLM(DUZ(2),DA(1),23,"
 D PPDU Q:$D(DIRUT)
 S DR=DR_".22Prescription"
 S ABMSCRIP=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)
 D ^DIE
 I ABMSCRIP'="",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)="" D  Q  ;the Prescription was removed
 .K DIR,DIE,DIC
 .S DA(1)=ABMP("CDFN")
 .S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",23,"
 .D ^DIK
 ;if prescription, get data from there and just ask about Dxs
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)'="" D
 .S ABMIEN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)
 .K DR
 .S DR=".06////@"  ;remove other Prescription#
 .S DR=DR_";.03Units (at $"_ABMZ("PPDU")_" per unit)//"_$P($G(^PSRX(ABMIEN,0)),U,7)_";.04///"_ABMZ("PPDU") D ^DIE
 .D DFEE S DR=".16Times Dispensed (at $"_ABMZ("DISPFEE")_" per each time dispensed) //1"
 .D ^DIE Q:$D(Y)
 .S DR=".05///"_(ABMZ("DISPFEE")*X) D ^DIE
 .S DR=".25////"_$P($G(^PSRX(ABMIEN,0)),U,13)  ;date written
 .S DR=DR_";.2////"_$P($G(^PSRX(ABMIEN,0)),U,8)  ;days supply
 .S DR=DR_";.24////"_$P($G(^PSRX(ABMIEN,2)),U,7)  ;NDC
 .D ^DIE
 .D PROV
 ;
 ;no prescription, prompt for all fields
 E  D
 .S DR=".14//"_$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,14)'="":$$SDT^ABMDUTL($P(^(0),U,14)),$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,1)'=$P(^(7),U,2):$$SDT^ABMDUTL($P(^(7),U)),1:"/"_$$SDT^ABMDUTL($P(^(7),U)))
 .S DR=DR_";.28//"_$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0),U,14))
 .S DR=DR_";.03Units (at $"_ABMZ("PPDU")_" per unit);.04///"_ABMZ("PPDU")
 .D ^DIE Q:$D(Y)
 .S DR=".17///M" D ^DIE
 .S ABM("X0")=^ABMDCLM(DUZ(2),DA(1),23,DA,0)
 .D DFEE S DR=".16Times Dispensed (at $"_ABMZ("DISPFEE")_" per each time dispensed) //1"
 .D ^DIE Q:$D(Y)
 .S DR=".05///"_(ABMZ("DISPFEE")*X) D ^DIE
 .S DR=".2;.06;.22////@;.19Refill"
 .S DR=DR_";.24//"_$S($P($G(^PSDRUG(+ABM("X0"),2)),U,4)]"":$P(^(2),U,4),1:"")
 .S DR=DR_";.25"
 .D ^DIE
 .D PROV
 .;
 I (^ABMDEXP(ABMMODE(4),0)["HCFA")!(^ABMDEXP(ABMMODE(4),0)["CMS") D
 .D DX^ABMDEMLC S DR=".13////"_$G(Y(0)) D ^DIE
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
PPDU ;PRICE PER DISPENSE UNIT
 S DR=""
 S:^ABMDEXP(ABMMODE(4),0)["UB" DR=".02//250;"
 ;S ABMZ("PPDU")=+$P($G(^ABMDFEE(ABMP("FEE"),25,ABMZ("DRUG"),0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("PPDU")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),25,ABMZ("DRUG"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S:'ABMZ("PPDU") ABMZ("PPDU")=+$P($G(^PSDRUG(ABMZ("DRUG"),660)),U,6)
 S DIR(0)="Y",DIR("A")="Is this entry an IV"
 S DIR("B")=$S($P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),"^",15)'="":"YES",1:"NO")
 D ^DIR K DIR S ABMZ("IV")=Y I Y=1 D
 .S DIR(0)="N^0:9999:3",DIR("B")=ABMZ("PPDU"),DIR("A")="IV Price per Unit"
 .I $P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),U,4) S DIR("B")=$P(^(0),U,4)
 .D ^DIR K DIR S ABMZ("PPDU")=Y
 .S DR=".02//IV;.15;.07;.08;.09;"
 Q
DFEE ;GET DISPENSE FEE
 S ABMZ("DISPFEE")=0
 I ABMP("VTYP")'=111,ABMP("VTYP")'=831 S ABMZ("DISPFEE")=$P($G(^ABMDPARM(DUZ(2),1,0)),U,3) Q
 I $P($G(ABM("X0")),U,15)="" S ABMZ("DISPFEE")=$P($G(^ABMDPARM(DUZ(2),1,4)),U,6) Q
 S ABMZ("DISPFEE")=$P($G(^ABMDPARM(DUZ(2),1,4)),U,$F("APHSC",$P(ABM("X0"),U,15))-1)
 Q
PROV ;
 N DIC,DR,DIE
 S DA(2)=ABMP("CDFN")
 S (DA(1),ABMSIEN)=DA
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 S DIC(0)="AELMQ"
 S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 S DIC("P")=$P(^DD(ABMFLNM,.18,0),U,2)
 S DIC("DR")=".01;.02//R"
 D ^DIC
 K DIC,DR,DIE
 I +Y>0,(+$P(Y,U,3)=0) D
 .K DIE,DA,DR
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=ABMSIEN
 .S DIE="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DA=+Y
 .S DR=".01//;.02"
 .D ^DIE
 S DA=+$G(DA(1))
 S DA(1)=ABMP("CDFN")
 Q

ABMDE8A ; IHS/ASDST/DMJ - Page 8 - MEDICAL CARE ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - v2.4 p7 - 9/7/01 NOIS HQW-0701-100066
 ;     Modifications done related to Medicare Part B
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to include 2nd and 3rd modifiers on display
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - IM16660
 ;   4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Use provider multiple at line item
 ; IHS/SD/SDR - v2.5 p10 - IM19843
 ;   Added new prompt SERVICE TO DATE/TIME
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
DISP ;
 K ABMZ
 S ABMZ("TITL")="MEDICAL SERVICES"
 S ABMZ("PG")="8A"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
PC ; Medical Care
 S:'$D(ABMP("FEE")) ABMP("FEE")=1
 S ABMZ("CAT")=19
 S ABMZ("SUB")=27
 S ABMZ("DR")=";W !;.07//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.12//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.03//1"
 D
 .S ABMDPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","A",0))
 .S ABMDPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,+ABMDPRV,0)),U)
 S ABMZ("CHRG")=";W !;.04"
 S ABMZ("ITEM")="Medical Service (CPT Code)"
 S ABMZ("DIC")="^ICPT("
 S ABMZ("X")="X"
 S ABMZ("MAX")=30
 S ABMZ("TOTL")=0
 D MODE^ABMDE8X
 I ^ABMDEXP(ABMMODE(1),0)["UB" D
 .S ABMZ("REVN")=";W !;.02//960"
 I ^ABMDEXP(ABMMODE(1),0)["HCFA"!(^ABMDEXP(ABMMODE(1),0)["CMS") S ABMZ("DIAG")=";.06"
 D A^ABMDE8X
 D HD
 G LOOP
 ;
HD ;
 W !?5,"REVN",?60,"UNIT",?71,"TOTAL"
 W !?5,"CODE",?10,"        CPT - MEDICAL SERVICES",?59,"CHARGE",?66,"QTY",?71,"CHARGE"
 W !?5,"====",?10,"===============================================",?59,"======",?66,"===",?70,"========="
 Q
 ;
LOOP ;
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 S ABMZ("MOD")=.05_U_1_U_.08_U_.09
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 ;
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("MOD")=""
 F ABM("M")=5,8,9 S:$P(ABM("X0"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X0"),U,ABM("M")) I $P(ABM("X0"),U,ABM("M"))=90 S ABME(172)=""
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI(+$P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM_U_$P(ABM("X0"),U,2)  ;CSV-c
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 ;
EOP ;
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)  D HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",7) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",7))
 .I $P(ABM("X0"),U,12)'="",($P(ABM("X0"),U,7)'=$P(ABM("X0"),U,12)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,12))
 .S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P","C","D",0))  ;ordering
 .S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P","C","R",0))  ;rendering
 .I ABMRPRV'="" D  ;provider on line item
 ..W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P",ABMRPRV,0),U,2)_")"
 .W !
 W ?5,$$GETREV^ABMDUTL($P(ABM("X0"),U,2))
 W ?10,$P(ABMZ(ABM("I")),U) W:ABMZ("MOD")]"" ABMZ("MOD")
 K ABMU
 S ABMU(1)="?59"_U_$J($P(ABM("X0"),U,4),6,2)
 S ABMU(2)="?66"_U_$J(ABMZ("UNIT"),2)
 S ABMU(3)="?70"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,4)),",",2),9)
 S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")
 I $P(^ABMDPARM(DUZ(2),1,0),U,14)'="Y" S ABMU("TXT")=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),0),U,3)  ;CSV-c
 E  S ABMU("TXT")="",ABM("CP")=0 F  S ABM("CP")=$O(^ICPT($P(ABM("X0"),U),"D",ABM("CP"))) Q:'ABM("CP")  Q:'$D(^(ABM("CP"),0))  S ABMU("TXT")=ABMU("TXT")_^(0)_" "
 S ABMU("RM")=58,ABMU("LM")=16+$L(ABMZ("MOD")) S:ABMZ("MOD") ABMU("TAB")=3+$L(ABMZ("MOD")) D ^ABMDWRAP
 Q
 ;
XIT ;
 K ABM,ABMMODE
 Q

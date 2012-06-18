ABMDE8E ; IHS/ASDST/DMJ - Page 8 - LABORATORY ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DSD/LSL - 09/01/98 - Patch 2 - NOIS NDA-0898-180038
 ;             0.00 charges on HCFA because version 2.0 does not assume
 ;             1 for units.  Modify code to set units to 1 if not
 ;             already defined.
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers as well as units
 ; IHS/SD/SDR - V2.5 P8 - IM10618
 ;    Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - IM16660
 ;   4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;   Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p10 - IM19843
 ;   Added new prompt SERVICE TO DATE/TIME
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
DISP K ABMZ S ABMZ("TITL")="LABORATORY SERVICES",ABMZ("PG")="8E"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D E^ABMDE8X
FEE S ABMZ("CAT")=17
 S ABMZ("SUB")=37
 D MODE^ABMDE8X
 S:((^ABMDEXP(ABMMODE(5),0)["HCFA")!(^ABMDEXP(ABMMODE(5),0)["CMS")) ABMZ("DIAG")=";.09"
 S ABMZ("DR")=";W !;.05//"_$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U)'=$P(^(7),U,2):$$SDT^ABMDUTL(ABMP("VDT")),1:"/"_ABMP("VDT"))
 S ABMZ("DR")=ABMZ("DR")_";W !;.12//"_$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U)'=$P(^(7),U,2):$$SDT^ABMDUTL(ABMP("VDT")),1:"/"_ABMP("VDT"))_";.03//1"
 S ABMZ("CHRG")=";W !;.04",ABMZ("ITEM")="Laboratory (CPT Code)"
 S ABMZ("DIC")="^ICPT(",ABMZ("X")="X",ABMZ("TOTL")=0
 I ^ABMDEXP(ABMMODE(5),0)["UB" S ABMZ("REVN")=";W !;.02//300"
 D HD G LOOP
HD W !?5,"REVN",?60,"UNIT",?71,"TOTAL"
 W !?5,"CODE",?10,"        CPT - LABORATORY SERVICES",?59,"CHARGE",?66,"QTY",?71,"CHARGE"
 W !?5,"====",?10,"===============================================",?59,"======",?66,"===",?70,"========="
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 S ABMZ("MOD")=.06_U_5_U_.07_U_.08
 I $D(ABMP(638)),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U)>0 S ABMZ("OUTLAB")=$P(^(8),U)
 I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMZ("MOD")=""
 F ABM("M")=6,7,8 S:$P(ABM("X0"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X0"),U,ABM("M")) I $P(ABM("X0"),U,ABM("M"))=90 S ABME(172)=""
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM_U_$P(ABM("X0"),U,2,7)  ;CSV-c
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",5) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),U,5))
 .I $P(ABM("X0"),U,12)'="",($P(ABM("X0"),U,12)'=$P(ABM("X0"),U,5)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,12))
 .S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM,"P","C","D",0))
 .S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM,"P","C","R",0))
 .I ABMRPRV'="" D  ;rendering provider on line item
 ..W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABM,"P",ABMRPRV,0),U,2)_")"
 .W !
 W ?5,$$GETREV^ABMDUTL($P(ABM("X0"),U,2))
 W ?10,$P(ABMZ(ABM("I")),U) W:ABMZ("MOD")]"" ABMZ("MOD")
 K ABMU S ABMU(1)="?59"_U_$J($P(ABM("X0"),U,4),6,2)
 S ABMU(2)="?66"_U_$J(ABMZ("UNIT"),2)
 S ABMU(3)="?70"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,4)),",",2),9)
 S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")
 I $P(^ABMDPARM(DUZ(2),1,0),U,14)'="Y" S ABMU("TXT")=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,3)  ;CSV-c
 ;start CSV-c
 E  D
 .S ABMU("TXT")=""
 .K ABMZCPTD
 .D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),"ABMZCPTD","",ABMP("VDT"))
 .S ABM("CP")=0
 .F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:(+ABM("CP")=0)  D
 ..Q:($G(ABMZCPTD(ABM("CP")))="")
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABM("CP"))_" "
 ;end CSV-c
 S ABMU("RM")=58,ABMU("LM")=16+$L(ABMZ("MOD")) S:ABMZ("MOD")]"" ABMU("TAB")=3+$L(ABMZ("MOD")) D ^ABMDWRAP
 Q
 ;
XIT K ABM,ABMMODE
 Q

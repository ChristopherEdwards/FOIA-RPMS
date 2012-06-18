ABMDE8H ; IHS/ASDST/DMJ - Page 8 - MISC INFO ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers and units
 ; IHS/SD/SDR - V2.5 P8 - IM16018/IM11164 - Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - IM16660 - 4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p9 - task 1 - Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p10 - IM20454 - Fixed so 2nd and 3rd modifiers would be prompted for
 ; IHS/SD/SDR - v2.5 p10 - IM19843 - Added new prompt SERVICE TO DATE/TIME
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added prompts for DME billing fields
 ;
DISP K ABMZ S ABMZ("TITL")="MISC. SERVICES",ABMZ("PG")="8H"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
MS ; Misc. Services
 S ABMZ("CAT")=13
 S ABMZ("SUB")=43
 D MODE^ABMDE8X
 S:((^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS")) ABMZ("DIAG")=";.06"
 S ABMZ("DR")=";W !;.07//"_$$SDT^ABMDUTL(ABMP("VDT"))_";W !;.12//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.03"
 S ABMZ("CHRG")=";.04"
 I ABMZ("SUB")=43&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,4)="Y") S ABMZ("DR")=ABMZ("DR")_";11;12;13;14"   ;abm*2.6*6 5010
 S ABMZ("ITEM")="Misc. Services (HCPCS Code)"
 S ABMZ("DIC")="^ICPT(",ABMZ("X")="X",ABMZ("MAX")=10,ABMZ("TOTL")=0
 I ^ABMDEXP(ABMMODE(8),0)["UB" S ABMZ("DR")=";W !;.02"_ABMZ("DR")
 D H^ABMDE8X
 D HD G LOOP
HD ;
 W !?5,"REVN",?60,"UNIT",?71,"TOTAL"
 W !?5,"CODE",?10,"        HCPCS - MISC. SERVICES",?59,"CHARGE",?66,"QTY",?71,"CHARGE"
 W !?5,"====",?10,"===============================================",?59,"======",?66,"===",?70,"========="
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 S ABMZ("MOD")=.05_U_5_U_.08_U_.09
 I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM_U_$P(ABM("X0"),U,2)  ;CSV-c
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",7) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",7))
 .I $P(ABM("X0"),U,12)'="",($P(ABM("X0"),U,12)'=$P(ABM("X0"),U,7)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,12))
 .S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM,"P","C","D",0))
 .S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM,"P","C","R",0))
 .I ABMRPRV'="" D  ;rendering provider on line item
 ..W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM,"P",ABMRPRV,0)),U,2)_")"
 .W !
 W ?5,$$GETREV^ABMDUTL($P(ABM("X0"),"^",2))
 W ?10,$P(ABMZ(ABM("I")),U)
 S ABMZ("MOD")=""
 F ABM("M")=5,8,9 S:$P(ABM("X0"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X0"),U,ABM("M"))
 W ?10 W:ABMZ("MOD")]"" ABMZ("MOD")_" "
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
 I ABMU("TXT")]"" S ABMU("RM")=59,ABMU("LM")=16 D ^ABMDWRAP I 1
 E  W ?17,$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,3)  ;CSV-c
 Q
 ;
XIT K ABM,ABMMODE
 Q

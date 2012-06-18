ABMDE8K ; IHS/SD/SDR - Page 8 - AMBULANCE INFO ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;   New routine for page 8K-ambulance
 ; IHS/SD/SDR - v2.5 p10 - IM9843
 ;   Added new prompt SERVICE TO DATE/TIME
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
DISP K ABMZ S ABMZ("TITL")="AMBULANCE SERVICES",ABMZ("PG")="8K"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
AMB ; Amb. Services
 S ABMZ("CAT")=13
 S ABMZ("SUB")=47
 D MODE^ABMDE8X
 S:((^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS")) ABMZ("DIAG")=";.06"
 S ABMZ("DR")=";W !;.07//"_$$SDT^ABMDUTL(ABMP("VDT"))_";W !;.12//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.03;.11"
 S ABMZ("CHRG")=";.04"
 S ABMZ("ITEM")="Amb. Services (HCPCS Code)"
 S ABMZ("DIC")="^ICPT(",ABMZ("X")="X",ABMZ("MAX")=10,ABMZ("TOTL")=0
 I ^ABMDEXP(ABMMODE(8),0)["UB" S ABMZ("DR")=";W !;.02"_ABMZ("DR")
 D K^ABMDE8X
 D HD G LOOP
HD W !?5,"REVN",?60,"UNIT",?71,"TOTAL"
 W !?5,"CODE",?10,"        HCPCS - AMBULANCE SERVICES",?59,"CHARGE",?66,"QTY",?71,"CHARGE"
 W !?5,"====",?10,"===============================================",?59,"======",?66,"===",?70,"========="
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 S ABMZ("MOD")=.05_U_5_.08_U_.09
 I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM_U_$P(ABM("X0"),U,2)  ;CSV-c
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",7) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",7))
 .I $P(ABM("X0"),U,12)'="",($P(ABM("X0"),U,12)'=$P(ABM("X0"),U,7)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,12))
 .I $P(ABM("X0"),U,11) D
 ..W " ("_$P($G(^VA(200,$P(ABM("X0"),U,11),0)),U)_")"
 .W !
 W ?6,$P(ABM("X0"),"^",2)
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
 .D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),ABMZCPTD,"",ABMP("VDT"))
 .S ABM("CP")=0
 .F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:'$D(ABMZCPTD(ABM("CP")))  D
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABM("CP"))_" "
 ;end CSV-c
 I ABMU("TXT")]"" S ABMU("RM")=59,ABMU("LM")=16 D ^ABMDWRAP I 1
 E  W ?17,$P(^ICPT($P(ABM("X0"),U),0),U,2)
 Q
 ;
XIT K ABM,ABMMODE
 Q

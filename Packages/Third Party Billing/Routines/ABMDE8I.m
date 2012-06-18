ABMDE8I ; IHS/ASDST/DMJ - Page 8 - DENTAL ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
DISP K ABMZ,ABME,ABM S ABMZ("TITL")="INPATIENT DENTAL SERVICES",ABMZ("PG")="8I"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D ^ABMDE6X K ABME(137)
FEE S ABMZ("CAT")=21
 S ABMZ("SUB")=33
 D MODE^ABMDE8X
 S:((^ABMDEXP(ABMMODE(9),0)["HCFA")!(^ABMDEXP(ABMMODE(9),0)["CMS")) ABMZ("DIAG")=";.04"
 S ABMZ("DR")=";W !;.07//"_ABMP("VISTDT")_";W !;.05;W !;.06",ABMZ("CHRG")=";W !;.08",ABMZ("ITEM")="Dental (ADA Code)",ABMZ("DIC")="^AUTTADA(",ABMZ("X")="X",ABM("TOTL")=0
 I ^ABMDEXP(ABMMODE(9),0)["UB" S ABMZ("DR")=";W !;.02"_ABMZ("DR")
 D HD G LOOP
HD W !?4,"VISIT",?61,"OPER"
 W !?4,"DATE",?11,"        INPATIENT DENTAL SERVICE",?61,"SITE",?66,"SURF",?73,"CHARGE"
 W !?4,"=====",?11,"================================================",?61,"====",?66,"=====",?73,"======"
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 D  Q:'ABM  D PC1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I +ABM,$D(ABM("X")) S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM,ABM("X"))) I +ABM("X") S ABMZ("NUM")=ABM("I") Q
 .S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM)) Q:'ABM  S ABM("X")=$O(^(ABM,"")),ABMZ("NUM")=ABM("I")
 .Q
 W !?72,"=======",!?70,$J(("$"_$FN(ABM("TOTL"),",",2)),9)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM("X"),0)
 S ABMZ(ABM("I"))=$P(^AUTTADA(+ABM("X0"),0),U)_U_ABM("X")
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),U,7)]"" W ?4,$E($P(ABM("X0"),U,7),4,5)_"/"_$E($P(ABM("X0"),U,7),6,7)
 W ?11,$P(^AUTTADA(+ABM("X0"),0),U)," ",$E($P(^(0),U,2),1,43)
 W ?62 W $S($P(ABM("X0"),U,5)="":"",$D(^ADEOPS($P(ABM("X0"),U,5),88)):$P(^(88),U),1:"")
 W ?66,$J($P(ABM("X0"),U,6),4)
 W ?73,$J($FN($P(ABM("X0"),U,8),",",2),6)
 S ABM("TOTL")=ABM("TOTL")+$P(ABM("X0"),U,8)
 Q
 ;
XIT K ABM,ABMMODE
 Q
 ;
V1 S ABMZ("TITL")="DENTAL VIEW OPTION" D SUM^ABMDE1
 D ^ABMDERR
 Q

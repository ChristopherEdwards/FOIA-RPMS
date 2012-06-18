ABMDE9A ; IHS/ASDST/DMJ - Page 9 - UB-82 CODES-Cont ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code to put Zip code for AO on page 9D
 ;
DISP3 ;EP - Entry Point for Condition Codes
 K ABMZ S ABMZ("TITL")="CONDITION CODES",ABMZ("PG")="9C"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
COND ; Condition codes
 S ABMZ("SUB")=53,ABMZ("DR")="",ABMZ("ITEM")="Condition Code",ABMZ("DIC")="^ABMDCODE(",ABMZ("X")="DINUM",ABMZ("MAX")=5
 D HD3 G LOOP3
HD3 W !?6,"COND"
 W !?6,"CODE",?14,"             CONDITION CODE DESCRIPTION"
 W !?6,"====",?14,"============================================================"
 Q
LOOP3 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),53,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D COND1
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
COND1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),53,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ(ABM("I"))=$E(("00"_$P(^ABMDCODE(ABM("X"),0),U)),$L($P(^(0),U))+1,4)_U_ABM_U_$P(ABM("X0"),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT D HD3
 W !,"[",ABM("I"),"]",?7,$P(ABMZ(ABM("I")),U),?14,$P(^ABMDCODE(ABM("X"),0),U,3)
 Q
 ;
DISP4 ;EP - Entry Point for Value Codes
 K ABMZ S ABMZ("TITL")="VALUE CODES",ABMZ("PG")="9D"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
VALU ; Value codes
 S ABMZ("SUB")=55
 S ABMZ("DR")=";W !;.02Amount OR Zip Code"
 S ABMZ("ITEM")="Value Code"
 S ABMZ("DIC")="^ABMDCODE("
 S ABMZ("X")="DINUM"
 S ABMZ("MAX")=4
 D HD4 G LOOP4
HD4 W !?6,"VALU"
 W !?6,"CODE",?14,"           VALUE CODE DESCRIPTION",?67,"AMOUNT"
 W !?6,"====",?14,"==================================================",?66,"========"
 Q
LOOP4 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),55,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D VALU1
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
VALU1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),55,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ(ABM("I"))=$E(("00"_$P(^ABMDCODE(ABM("X"),0),U)),$L($P(^(0),U))+1,4)_U_ABM_U_$P(ABM("X0"),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT D HD4
 W !,"[",ABM("I"),"]",?7,$P(ABMZ(ABM("I")),U)
 W ?14,$P(^ABMDCODE(ABM("X"),0),U,3)
 W ?66,$S("A0^32"[$P(ABMZ(ABM("I")),U):$P(ABM("X0"),U,2),1:$J($P(ABM("X0"),U,2),8,2))
 Q
 ;
XIT Q

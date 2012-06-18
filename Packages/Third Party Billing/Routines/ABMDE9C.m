ABMDE9C ; IHS/ASDST/DMJ - Edit Page 9 - UB-82 CODES ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM13796
 ;    <UNDEF>LOOP^ABMDE9C
 ;
DISP ;EP - Entry Point for Occurance Codes
 K ABMZ S ABMZ("TITL")="OCCURRENCE CODES",ABMZ("PG")="9A"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 D HD
 ;
OCCR ; Occurance codes
 S ABMZ("SUB")=51,ABMZ("DR")=";W !;.02",ABMZ("ITEM")="Occurance Code",ABMZ("DIC")="^ABMDCODE(",ABMZ("X")="DINUM",ABMZ("MAX")=5
 G LOOP
HD W !?6,"OCCR"
 W !?6,"CODE",?14,"             OCCURRENCE DESCRIPTION",?68,"DATE"
 W !?6,"====",?14,"==================================================",?66,"========"
 Q
LOOP ;
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABM)) Q:'ABM!$D(DIRUT)  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D OCCR1
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
OCCR1 ;
 I $D(DIROUT)!$D(DUOUT)!$D(DTOUT)!$D(DIRUT) G XIT
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ(ABM("I"))=$E(($P(^ABMDCODE(ABM("X"),0),U)+100),2,3)_U_ABM_U_$P(ABM("X0"),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!$D(DIRUT)  D HD
 W !,"[",ABM("I"),"]",?7,$P(ABMZ(ABM("I")),U),?14,$P(^ABMDCODE(ABM("X"),0),U,3),?66 S ABM("DT")=$P(ABM("X0"),U,2) D DT W ABM("DT")
 Q
 ;
DISP2 ;EP - Entry Point for Occurance Span Codes
 K ABMZ S ABMZ("TITL")="OCCURRENCE SPAN CODES",ABMZ("PG")="9B"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
SPAN ; Occurrence Span codes
 S ABMZ("SUB")=57,ABMZ("DR")=";W !;.02;W !;.03",ABMZ("ITEM")="Occurrence Span",ABMZ("DIC")="^ABMDCODE(",ABMZ("X")="X",ABMZ("MAX")=2
 D HD2 G LOOP2
HD2 W !?6,"SPAN"
 W !?6,"CODE",?14,"       OCCURRENCE SPAN DESCRIPTION",?58,"FROM",?69,"TO"
 W !?6,"====",?14,"========================================",?56,"========",?66,"========"
 Q
LOOP2 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),57,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D SPAN1
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
 ;
SPAN1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),57,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ(ABM("I"))=$E((100+$P(^ABMDCODE(ABM("X"),0),U)),2,3)_U_ABM_U_$P(ABM("X0"),U,2)
 I $Y>(IOSL-8) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT D HD2
 W !,"[",ABM("I"),"]",?7,$P(ABMZ(ABM("I")),U),?14,$P(^ABMDCODE(ABM("X"),0),U,3),?56 S ABM("DT")=$P(ABM("X0"),U,2) D DT W ABM("DT") S ABM("DT")=$P(ABM("X0"),U,3) D DT W ?66,ABM("DT")
 Q
 ;
XIT K ABM,ABMZ
 Q
 ;
DT ;date conversion
 I ABM("DT")]"" S ABM("DT")=$$HDT^ABMDUTL(ABM("DT"))
 Q

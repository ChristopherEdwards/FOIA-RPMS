ABMDE9B ; IHS/ASDST/DMJ - Page 9 - UB-82 CODES-Cont ;
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337
 ;   Added code for ADA formats
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6439 - added page 9G
 ;
DISP5 ;EP - Entry Point for Spec Prog code
 K ABMZ S ABMZ("TITL")="SPECIAL PROGRAM CODES",ABMZ("PG")="9E"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
SPCL ; Special Program
 S ABMZ("SUB")=59,ABMZ("DR")="",ABMZ("ITEM")="Special Program Code",ABMZ("DIC")="^ABMDCODE(",ABMZ("X")="DINUM",ABMZ("MAX")=1
 D HD5 G LOOP5
HD5 W !?6,"PRGM"
 W !?6,"CODE",?14,"           SPECIAL PROGRAM DESCRIPTION"
 W !?6,"====",?14,"============================================================"
 Q
LOOP5 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D SPCL1
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
SPCL1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ(ABM("I"))=$E(("00"_$P(^ABMDCODE(ABM("X"),0),U)),$L($P(^(0),U))+1,4)_U_ABM_U_$P(ABM("X0"),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT D HD5
 W !,"[",ABM("I"),"]",?7,$P(ABMZ(ABM("I")),U),?14,$P(^ABMDCODE(ABM("X"),0),U,3)
 Q
 ;
DISP6 ;EP - Entry Point for Remarks
 N I F I=1:1:4 D
 .Q:'$D(^ABMDEXP(ABMP("EXP"),2,I,0))
 .Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),61,I,0))
 .S ^ABMDCLM(DUZ(2),ABMP("CDFN"),61,I,0)=^ABMDEXP(ABMP("EXP"),2,I,0)
 .S ^ABMDCLM(DUZ(2),ABMP("CDFN"),61,0)="^^"_I_"^"_I_"^"_DT
 K ABMZ S ABMZ("TITL")="REMARKS",ABMZ("PG")="9F"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
REM ; Remarks
 D HD6,REM1
 Q
 ;start new code abm*2.6*1 HEAT6439
DISP7 ;EP - Entry Point for Claim Attachments
 K ABMZ S ABMZ("TITL")="CLAIM ATTACHMENTS",ABMZ("PG")="9G"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
CATTCH ; Claim Attachments
 S ABMZ("SUB")=71,ABMZ("DR")=";W !;.02Transmission Code//;.03Control Number//",ABMZ("ITEM")="Claim Attachment",ABMZ("DIC")="^ABMDCODE(",ABMZ("X")="X",ABMZ("MAX")=10
 D HD7 G LOOP7
HD7 W !?5,"REPORT TYPE"
 W ?26,"TRNS TYPE"
 W ?45,"CONTROL NUMBER"
 W !?5,"====================",?26,"==================",?45,"============================"
 Q
LOOP7 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0
 S ABM=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),71,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D ATTCH1
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
ATTCH1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),71,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ(ABM("I"))=$E(("00"_$P(^ABMDCODE(ABM("X"),0),U)),$L($P(^(0),U))+1,4)_U_ABM_U_$P(ABM("X0"),U,2)_U_$P(ABM("X0"),U,3)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT D HD7
 W !,"[",ABM("I"),"]",?5,$P(ABMZ(ABM("I")),U),?8,$E($P(^ABMDCODE(ABM("X"),0),U,3),1,17)
 S ABMTCODE=$P(ABMZ(ABM("I")),U,3)
 W ?26,ABMTCODE_" "
 W $S(ABMTCODE="AA":"Avail On Req",ABMTCODE="BM":"By Mail",ABMTCODE="EL":"Elec Only",ABMTCODE="EM":"E-Mail",ABMTCODE="FX":"By Fax",1:"")
 W ?45,$E($P(ABMZ(ABM("I")),U,4),1,35)
 Q
 ;end new code HEAT6439
HD6 ;
 W !?15,"REMARKS"
 W !?6,"========================================"
 I ABMP("EXP")=28 W !,?7,"(19 characters - 1st line; 24 characters x 3 lines max)"
 E  W !,?7,"(48 characters x 4 lines max)"
 W !,?5,"------------------------------------------------"
 N I F I=1:1:4 D
 .W !,"[",I,"]  "
 .W $G(^ABMDCLM(DUZ(2),ABMP("CDFN"),61,I,0))
 W !,?5,"------------------------------------------------",!
 I ABMP("EXP")=12 W !!,"ADA-94 ONLY CONTAINS 62 CHARACTERS.  ADDITIONAL DATA MAY BE CUT OFF"
 I ABMP("EXP")=18 W !!,"ADA-99 ONLY CONTAINS 45 CHARACTERS.  ADDITIONAL DATA MAY BE CUT OFF"
 I ABMP("EXP")=25 W !!,"ADA-2002 ONLY CONTAINS 80 CHARACTERS.  ADDITIONAL DATA MAY BE CUT OFF"
 Q
REM1 ;
 Q:$G(ABMQUIET)
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=61 D ^DIE
 Q
 ;
V1 S ABMZ("TITL")="PAGE 9 - VIEW OPTION" D SUM^ABMDE1
 D ^ABMDERR
 Q
 ;
XIT Q

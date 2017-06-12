ABMDE5D ; IHS/ASDST/DMJ - Edit Page 5 - ICD PROCEDURE VIEW ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**10,14,19**;NOV 12, 2009;Build 300
 ;
 ;IHS/DED/DMJ - 5/12/1999 - NOIS HQW-0599-100027
 ;      Changed mm/dd DOS display to full Charge Date
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;IHS/SD/SDR - 2.6*14 - ICD10 - ICD10 changes
 ;IHS/SD/SDR - 2.6*19 - HEAT239182 - Updated so only ICD9 or only ICD10 can be selected on a claim based on the DOS and the ICD10 effective date
 ;
DISP2 ;EP - Entry Point to Display Dx Info
 K ABMZ S ABMZ("TITL")="ICD PROCEDURES",ABMZ("PG")="5B"
 D B^ABMDE5X
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
PROC ; ICD Procedure Info
 S ABMZ("SUB")=19,ABMZ("ITEM")="Procedure",ABMZ("DIC")="^ICD0("
 ;start new abm*2.6*19 IHS/SD/SDR HEAT239182
 I ABMP("ICD10")>ABMP("VDT") S ABMZ("DICS")="I $P($$ICDOP^ABMCVAPI(+Y,ABMP(""VDT"")),U,15)'=31"
 E  S ABMZ("DICS")="I $P($$ICDOP^ABMCVAPI(+Y,ABMP(""VDT"")),U,15)=31"
 ;end new abm*2.6*19 IHS/SD/SDR HEAT239182
 S ABMZ("X")="DINUM"
 S ABMZ("DR")=";W !;.03//"_ABMP("VISTDT")
 S ABMZ("NARR")=";.04////"_U_4_U_5
 D HD2 G LOOP2
HD2 ;
 W !,"ICD Indicator for "_$$GET1^DIQ(9999999.18,ABMP("INS"),".01","E")_" : "  ;abm*2.6*14 ICD10 002H
 W $S(ABMP("ICD10")>ABMP("VDT"):"ICD-9",1:"ICD-10"),!  ;abm*2.6*14 ICD10 002H
 ;W !,"BIL",?4,"SERV",?12,"ICD0"  ;abm*2.6*10 ICD10 002H
 W !,"BIL",?4,"SERV",?16,"ICD"  ;abm*2.6*10 ICD10 002H
 ;W !,"SEQ",?4,"DATE",?12,"CODE -",?19,"PROCEDURE DESCRIPTION",?54,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002H
 W !,"SEQ",?4,"DATE",?11,"IND",?16,"CODE -",?23,"PROCEDURE DESCRIPTION",?56,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002H
 ;W !,"===",?4,"=====",?11,"===================================",?48,"================================"  ;abm*2.6*10 ICD10 002H
 W !,"===",?4,"=====",?11,"===",?16,"===================================",?52,"============================"  ;abm*2.6*10 ICD10 002H
 Q
LOOP2 ;LOOP 2
 ;start old code abm*2.6*14 ICD10 002H
 ;S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM=0
 ;F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM)) Q:'ABM!($D(DIROUT))!($D(DTOUT))!($D(DUOUT))  D
 ;.S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM,0))
 ;.S ABMZ("NUM")=ABM("I")
 ;.D PX
 ;G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;S ABM("L")=ABMZ("LNUM")+1,ABMZ("DR2")=";.02////"_ABM("L")
 ;I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 ;end old start new code abm*2.6*14 ICD10 002H
 ;this will remove codes from page 5B if the code set on the sequenced codes doesn't match the code set for the insurer
 ;manual claims will be a problem (because it will delete everything), but for a PCC claim all POVs will be viewable on
 ;the View option of page5B
 S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",0))
 I +ABMI'=0 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABMI,0))
 I (+$G(ABM)'=0) D
 .S ABMICDI=+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM,0)),U,6)
 .I (ABMICDI=1&(ABMP("ICD10")>ABMP("VDT")))!((ABMICDI=0)&(ABMP("ICD10")<ABMP("VDT"))) D
 ..;remove all entries
 ..K ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB")) S ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),0)="^9002274.30"_ABMZ("SUB")_"P^^"
 ..D B^ABMDE5X
 ;end new code ICD10 002H
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM=0
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM)) Q:'ABM  S ABM("X")=$O(^(ABM,"")),ABMZ("NUM")=ABM("I") D PX
 S ABM("L")=ABMZ("LNUM")+1,ABMZ("DR2")=";.02////"_ABM("L")
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 ;end new code ICD10 002H
 Q
PX ;
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM("X"),0)
 S ABM("ICD0IEN")=$P(ABM("X0"),U)
 ;Q:'$D(^ICD0(ABM("ICD0IEN"),0))  S ABMZ(ABM("I"))=$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3)_U_$P(ABM("X0"),U,4)  ;CSV-c  ;abm*2.6*14 ICD10 002H
 Q:'$D(^ICD0(ABM("ICD0IEN"),0))  S ABMZ(ABM("I"))=$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3)_U_$P(ABM("X0"),U,4)_U_U_$P(ABM("X0"),U,6)  ;CSV-c  ;abm*2.6*14 ICD10 002H
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD2
 ;S ABM("Y")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM("X"),0),U,3) S:ABMZ("LNUM")<$P(^(0),U,2) ABMZ("LNUM")=$P(^(0),U,2) I $D(^(1)),$P(^ABMDPARM(DUZ(2),1,0),U,14)="Y" S ABMU("TXT")=$$ICDDX^ABMCVAPI(ABM("X"),ABMP("VDT"))  ;CSV-c  ;abm*2.6*14
 S ABM("Y")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM("X"),0),U,3) S:ABMZ("LNUM")<$P(^(0),U,2) ABMZ("LNUM")=$P(^(0),U,2) I $D(^(1)),$P(^ABMDPARM(DUZ(2),1,0),U,14)="Y" S ABMU("TXT")=$$ICDDX^ABMCVAPI(+ABM("X"),ABMP("VDT"))  ;CSV-c ;abm*2.6*14 +'d
 E  S ABMU("TXT")=$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,4)  ;CSV-c
 W !,$J(ABM("I"),2),?4,"CHARGE DATE: ",$$SDT^ABMDUTL(ABM("Y"))
 W !,?12,$S($P(ABM("X0"),U,6)=1:"10",1:"9")  ;abm*2.6*14 ICD10 002H
 ;W !,?11,$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,2)," -" I $D(^(1)),$P(^ABMDPARM(DUZ(2),1,0),U,14)="Y" S ABMU("TXT")=$P($$ICDDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U)  ;CSV-c  ;abm*2.6*10 ICD10 002H
 ;W !,?16,$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,2)," -" I $D(^(1)),$P(^ABMDPARM(DUZ(2),1,0),U,14)="Y" S ABMU("TXT")=$P($$ICDDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U)  ;CSV-c  ;abm*2.6*10 ICD10 002H  ;abm*2.6*14 ICD10 002H
 W ?16,$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,2)," -"  ;abm*2.6*14 ICD10 002H
 ;E  S ABMU("TXT")=$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,5)  ;CSV-c  ;ABM*2.6*14 ICD10 002H
 S ABMU("TXT")=$P($$ICDOP^ABMCVAPI(ABM("ICD0IEN"),ABMP("VDT")),U,5) ;abm*2.6*14 ICD10 002H
 ;S ABMU("LM")=19,ABMU("RM")=46,ABMU("TAB")=5  ;abm*2.6*10 ICD10 002H
 S ABMU("LM")=22,ABMU("RM")=50,ABMU("TAB")=5  ;abm*2.6*10 ICD10 002H
 ;S ABMU("2TXT")=$S($P(ABM("X0"),U,4)]"":$P($G(^AUTNPOV($P(ABM("X0"),U,4),0)),U),1:""),ABMU("2TAB")=-2,ABMU("2LM")=48,ABMU("2RM")=80  ;abm*2.6*10 ICD10 002H
 S ABMU("2TXT")=$S($P(ABM("X0"),U,4)]"":$P($G(^AUTNPOV($P(ABM("X0"),U,4),0)),U),1:""),ABMU("2TAB")=-2,ABMU("2LM")=52,ABMU("2RM")=80  ;abm*2.6*10 ICD10 002H
 D ^ABMDWRAP
 Q
 ;
XIT K ABME
 Q

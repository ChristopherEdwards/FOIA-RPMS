ABMDE5 ; IHS/SD/SDR - Edit Page 5 - DIAGNOSIS ; 
 ;;2.6;IHS Third Party Billing;**1,3,4,6,10,14,16,18**;NOV 12, 2009;Build 289
 ;
 ; IHS/SD/SDR - 11/4/02 - V2.5 P2 - NDA-0500-180002
 ;     Modified to display E-codes
 ; IHS/SD/SDR - v2.5 p9 - IM19297
 ;    8 Dxs for 837 formats
 ; IHS/SD/SDR - v2.5 p11 - Added two more E-Codes for FL72 on
 ;   the new UB-04 format
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;   Changed display to include POA
 ;
 ;IHS/SD/SDR - v2.6 CSV
 ;IHS/SD/SDR - abm*2.6*1 - HEAT7045 - Display page5B if procedure exists
 ;IHS/SD/SDR - abm*2.6*3 - NOHEAT - Fix display of 5B; wasn't displaying if no procs existed
 ;IHS/SD/SDR - abm*2.6*6 - HEAT29426 - <UNDEF>PRTTXT+3^ABMDWRAP error if ICD long desc missing; defaulted to short desc.
 ;IHS/SD/SDR - 2.6*14 ICD10 changes; also added refresh option for page 5A.  Will allow user to basically do RBCL option
 ;  for 17 multiple within claim editor.
 ;IHS/SD/SDR - 2.6*14 - dual coding - added screen so only ICD9 or ICD10 can be added based on ICD Indicator
 ;IHS/SD/SDR - 2.6*16 - HEAT217211 - Added PLACE OF OCCURRENCE to display
 ;IHS/SD/SDR - 2.6*18 - HEAT239392 - There are two PLACE OF OCCURRENCEs.  It should display the appropriate one based on ICD9 vs ICD10.
 ;
OPT K ABM,ABME,ABMZ,ABMU
 D DISP Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)
 ;W !! S ABMP("OPT")="ADESVNJBQ" S:$G(ABMZ("NUM"))=0 ABMP("DFLT")="A" D SEL^ABMDEOPT K ABMP("ED") I "ADESVN"'[$E(Y) G XIT  ;abm*2.6*14 ICD10 Refresh page 5A
 W !! S ABMP("OPT")="ADESVNRIJBQ" S:$G(ABMZ("NUM"))=0 ABMP("DFLT")="A" D SEL^ABMDEOPT K ABMP("ED") I "ADESVNRI"'[$E(Y) G XIT  ;abm*2.6*14 ICD10 Refresh page 5A
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;I ABMP("PX")'="I"&($E(Y)="N") G XIT  ;abm*2.6*1 HEAT7045
 ;I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0))&($E(Y)="N") G XIT  ;abm*2.6*1 HEAT7045  ;abm*2.6*3 NOHEAT
 I (((ABMP("PX")'="I")&($E(Y)="N"))&'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0))) G XIT  ;abm*2.6*3 NOHEAT
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB"&($E(Y)="N") G XIT
 I $E(Y)="A",($G(ABMP("EXP"))=21)!($G(ABMP("EXP"))=22)!($G(ABMP("EXP"))=23),($G(ABMZ("NUM"))>7) D  ;more than 8 dxs for 837s
 .S ABMBFY=Y
 .S DIR(0)="Y"
 .S DIR("A",1)="THE MODE OF EXPORT YOU ARE SUBMITTING FOR ONLY ALLOWS 8 DIAGNOSIS CODES."
 .S DIR("A")="ARE YOU SURE YOU WANT TO CONTINUE ENTERING ADDITIONAL CODES?"
 .S DIR("B")="Y"
 .D ^DIR
 .K DIR
 .I +Y<1 Q
 .S Y=ABMBFY
 G OPT2:$E(Y)="N"
 ;S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="D":"D1^ABMDEMLB",$E(Y)="E":"E1^ABMDEMLE",$E(Y)="V":"^ABMDE5A",1:"S1^ABMDEMLA") D @ABM("DO")  ;abm*2.6*14 ICD10 Refresh page 5A
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="D":"D1^ABMDEMLB",$E(Y)="E":"E1^ABMDEMLE",$E(Y)="V":"^ABMDE5A",$E(Y)="R":"REFRESH^ABMDE5A",$E(Y)="I":"IND^ABMDE5A",1:"S1^ABMDEMLA") D @ABM("DO")  ;abm*2.6*14 ICD10 Refresh page 5A
 D RES^ABMDEMLA(17)
 G OPT
 ;
OPT2 K ABM,ABME,ABMZ
 D DISP2^ABMDE5D Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)
 ;W !! S ABMP("OPT")="ADESVNJBQ" D SEL^ABMDEOPT I "AVEVSDB"'[$E(Y) S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=5) ABMP("QUIT")="" G XIT  ;abm*2.6*14 ICD10 ICD Indicator
 W !! S ABMP("OPT")="ADESVNRIJBQ" D SEL^ABMDEOPT I "AVEVSDBRI"'[$E(Y) S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=5) ABMP("QUIT")="" G XIT  ;abm*2.6*14 ICD10 ICD Indicator
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT:$E(Y)="B"
 ;S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="E":"E1^ABMDEMLE",$E(Y)="D":"D1^ABMDEMLB",$E(Y)="V":"^ABMDE5B",1:"S1^ABMDEMLA") D @ABM("DO")  ;abm*2.6*14 ICD10 ICD Indicator
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="E":"E1^ABMDEMLE",$E(Y)="D":"D1^ABMDEMLB",$E(Y)="V":"^ABMDE5B",$E(Y)="R":"REFRESH^ABMDE5A",$E(Y)="I":"IND^ABMDE5A",1:"S1^ABMDEMLA") D @ABM("DO")  ;abm*2.6*14 ICD10 ICD Indicator
 G OPT2
 ;
DISP S ABMZ("TITL")="DIAGNOSIS",ABMZ("PG")="5A"
 D A^ABMDE5X
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 E  D SUM^ABMDE1
 ;
DIAG ; Diagnosis Info
 S ABMZ("SUB")=17,ABMZ("ITEM")="Diagnosis",ABMZ("DIC")="^ICD9(",ABMZ("X")="DINUM",ABMZ("DR")="",ABMZ("NARR")=";.03////"_U_3_U_4
 ;start new abm*2.6*14 dual coding
 ;screens ICD dx entries based on ICD Indicator
 I ABMP("ICD10")>ABMP("VDT") S ABMZ("DICS")="I $P($$DX^ABMCVAPI(+Y,ABMP(""VDT"")),U,20)'=30"
 E  S ABMZ("DICS")="I $P($$DX^ABMCVAPI(+Y,ABMP(""VDT"")),U,20)=30"
 ;end new dual coding
 D HD G LOOP
HD ;
 ;I ABMP("ICD10")>ABMP("VDT") W !,"ICD INDICATOR: ICD-9",!  ;abm*2.6*10 ICD10 002G  ;abm*2.6*14 ICD10 002G
 W !,"ICD Indicator for "_$$GET1^DIQ(9999999.18,ABMP("INS"),".01","E")_" : "  ;abm*2.6*14 ICD10 002G
 W $S(ABMP("ICD10")>ABMP("VDT"):"ICD-9",1:"ICD-10"),!  ;abm*2.6*14 ICD10 002G
 ;W !,"BIL",?6,"ICD9"  ;abm*2.6*10 ICD10 002F
 W !,"BIL",?7,"ICD"  ;abm*2.6*10 ICD10 002F
 ;W !,"SEQ",?6," CODE "  ;abm*2.6*10 ICD10 002F
 W !,"SEQ",?6," CODE ",?14,"IND"  ;abm*2.6*10 ICD10 002F
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .;W ?13,"POA",?23,"Dx DESCRIPTION",?51,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002F
 .W ?18,"POA",?28,"Dx DESCRIPTION",?54,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002F
 ;E  W ?19,"Dx DESCRIPTION",?51,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002F
 E  W ?20,"Dx DESCRIPTION",?50,"PROVIDER'S NARRATIVE"  ;abm*2.6*10 ICD10 002F
 ;W !,"===",?5,"======="  ;abm*2.6*10 ICD10 002F
 W !,"===",?5,"========",?14,"==="  ;abm*2.6*10 ICD10 002F
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .;W ?13,"===",?17,"==========================",?44,"===================================="  ;abm*2.6*10 ICD10 002F
 .W ?18,"===",?22,"==========================",?49,"==============================="  ;abm*2.6*10 ICD10 002F
 ;E  W ?13,"==========================",?40,"======================================="  ;abm*2.6*10 ICD10 002F
 E  W ?18,"==========================",?45,"==================================="  ;abm*2.6*10 ICD10 002F
 Q
LOOP ;
 S ABMEFLG=0
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0
 ;start new code abm*2.6*14 ICD10 002F
 ;this will remove codes from page 5A if the code set on the sequenced codes doesn't match the code set for the insurer
 ;manual claims will be a problem (because it will delete everything), but for a PCC claim all POVs will be viewable on
 ;the View option of page5A
 S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",0))
 I +ABMI'=0 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMI,0))
 I (+$G(ABM)'=0) D
 .S ABMICDI=+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM,0)),U,6)
 .I (ABMICDI=1&(ABMP("ICD10")>ABMP("VDT")))!((ABMICDI=0)&(ABMP("ICD10")<ABMP("VDT"))) D
 ..;remove all entries
 ..K ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB")) S ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),0)="^9002274.30"_ABMZ("SUB")_"P^^"
 ..D A^ABMDE5X
 ;end new code 002F
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABM)) Q:'ABM  S ABM("X")=$O(^(ABM,"")),ABMZ("NUM")=ABM("I") D DX
 S ABM("L")=ABMZ("LNUM")+1,ABMZ("DR2")=";.02////"_ABM("L")
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
DX ;
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM("X"),0) S:ABMZ("LNUM")<$P(^(0),U,2) ABMZ("LNUM")=$P(^(0),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 ;ABMZ(ABM("I"))=code^multiple ien^code ien^provider narr^e-code^poa
 ;S ABMZ(ABM("I"))=$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3)_U_$P(ABM("X0"),U,4)_U_$P(ABM("X0"),U,5)  ;CSV-c  ;abm*2.6*14 ICD10 002F
 S ABMZ(ABM("I"))=$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3)_U_$P(ABM("X0"),U,4)_U_$P(ABM("X0"),U,5)_U_$P(ABM("X0"),U,6)  ;CSV-c  ;abm*2.6*14 ICD10 002F
 W !,$J(ABM("I"),2),?5,$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)  ;CSV-c  ;code
 ;W ?15,$S($P(+ABM("X"),U,6)=1:"10",1:"9")  ;abm*2.6*10 ICD10 002F  ;abm*2.6*14 ICD10 002F
 W ?15,$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,+ABM("X"),0)),U,6)=1:"10",1:"9")  ;abm*2.6*14 ICD10 002F
 ;W:$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) ?14,$P(ABM("X0"),U,5)  ;poa  ;abm*2.6*10 ICD10 002F
 W:$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) ?19,$P(ABM("X0"),U,5)  ;poa  ;abm*2.6*10 ICD10 002F
 ;I $G(ABMEFLG)=0,$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)["E" D ECODE  ;CSV-c  ;abm*2.6*14 ICD10 002F
 I $G(ABMEFLG)=0,$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)["E",(ABMP("ICD10")>ABMP("VDT")) D ECODE  ;CSV-c  ;abm*2.6*14 ICD10 002F
 S (ABMU("TXT"),ABMUTXT)=""  ;abm*2.6*6 HEAT29426
 I $D(^ICD9(ABM("X"),1)),$P(^ABMDPARM(DUZ(2),1,0),U,14)="Y" D  ;if there's a desc and site wants long desc
 .S ABMU("TXT")=""
 .K ABMZCPTD
 .;D ICDDX^ABMCVAPI($P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2),"ABMZCPTD","",ABMP("VDT"))  ;desc array
 .;S ABMU("TXT")=$$ICDDX^ABMCVAPI(+ABM("X"),$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2),"ABMZCPTD","",ABMP("VDT"))  ;desc array  ;abm*2.6*4 HEAT19688
 .S ABMUTXT=$$ICDDX^ABMCVAPI(+ABM("X"),$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2),"ABMZCPTD","",ABMP("VDT"))  ;desc array  ;abm*2.6*4 HEAT19688
 .S ABM("CP")=0
 .F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:(+ABM("CP")=0)  D
 ..Q:($G(ABMZCPTD(ABM("CP")))="")
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABM("CP"))_" "
 ;E  S ABMU("TXT")=$P($$DX^ABMCVAPI(ABM("X"),ABMP("VDT")),U,4)  ;CSV-c  ;abm*2.6*6 HEAT29426
 I $P($G(^ABMDPARM(DUZ(2),1,0)),U,14)'="Y"!(ABMU("TXT")="") S ABMU("TXT")=$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,4)  ;abm*2.6*6 HEAT29426
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .;S ABMU("LM")=17,ABMU("RM")=42,ABMU("TAB")=-3  ;abm*2.6*10 ICD10 002F
 .S ABMU("LM")=22,ABMU("RM")=42,ABMU("TAB")=-3  ;abm*2.6*10 ICD10 002F
 .;S ABMU("2LM")=44,ABMU("2RM")=80,ABMU("2TAB")=-3  ;abm*2.6*10 ICD10 002F
 .S ABMU("2LM")=49,ABMU("2RM")=80,ABMU("2TAB")=-3  ;abm*2.6*10 ICD10 002F
 E  D
 .;S ABMU("LM")=13,ABMU("RM")=38,ABMU("TAB")=-3  ;abm*2.6*10 ICD10 002F
 .;S ABMU("LM")=18,ABMU("RM")=38,ABMU("TAB")=-3  ;abm*2.6*10 ICD10 002F  ;abm*2.6*14 ICD10 002F
 .S ABMU("LM")=18,ABMU("RM")=43,ABMU("TAB")=-2  ;abm*2.6*14 ICD10 002F
 .;S ABMU("2LM")=40,ABMU("2RM")=80,ABMU("2TAB")=-3  ;abm*2.6*10 ICD10 002F
 .S ABMU("2LM")=45,ABMU("2RM")=80,ABMU("2TAB")=-3  ;abm*2.6*10 ICD10 002F
 ;S ABMU("2TXT")=$S($P(ABM("X0"),U,3)]"":$P($G(^AUTNPOV($P(ABM("X0"),U,3),0)),U),1:"")  ;abm*2.6*14 HEAT161263
 S IENS=ABM("X")_","_ABMP("CDFN")_","   ;abm*2.6*14 HEAT161263
 S ABMU("2TXT")=$S($P(ABM("X0"),U,3)]"":$$GET1^DIQ(9002274.3017,IENS,".03","E"),1:"")  ;abm*2.6*14 HEAT161263
 I ABMU("2TXT")["*ICD*" S ABMU("2TXT")=$P(ABMU("2TXT"),"  ")
 I ABMU("2TXT")]"",$D(^ICD9("BA",ABMU("2TXT"))) S ABMU("2TXT")=$P($$DX^ABMCVAPI($O(^(ABMU("2TXT"),"")),ABMP("VDT")),U,4)  ;CSV-c
 D ^ABMDWRAP
 I $P($G(ABM("X0")),U,4)'="" D
 .W !,?7,"CAUSE(E-CODE): "_$P($$DX^ABMCVAPI(+$P(ABM("X0"),U,4),ABMP("VDT")),U,2)  ;CSV-c
 ;start new abm*2.6*16 IHS/SD/SDR HEAT217211
 ;I $P($G(ABM("X0")),U,9)'="" D  ;abm*2.6*18 IHS/SD/SDR HEAT239392
 I (ABMP("VDT")'<ABMP("ICD10"))&($P($G(ABM("X0")),U,9)'="") D  ;abm*2.6*18 IHS/SD/SDR HEAT239392
 .W !,?7,"PLACE OF OCCURRENCE: "_$P($$DX^ABMCVAPI(+$P(ABM("X0"),U,9),ABMP("VDT")),U,2)  ;CSV-c
 ;end new abm*2.6*16 IHS/SD/SDR HEAT217211
 ;start new abm*2.6*18 IHS/SD/SDR HEAT239392
 I (ABMP("VDT")<ABMP("ICD10"))&(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM("X"),2)),U,6)'=0) D  ;abm*2.6*18 IHS/SD/SDR HEAT239392
 .W !,?7,"PLACE OF OCCURRENCE: "_$P($$DX^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM("X"),2)),U,6),ABMP("VDT")),U,2)  ;CSV-c
 ;end new abm*2.6*18 IHS/SD/SDR HEAT239392
 Q
 ;
XIT K ABM,ABMZ,ABME
 Q
ECODE ;
 N DIE,DA,DR
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,12)="" S DR=".857////"_ABM("X")
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,12)'="" D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,19)="",ABM("X")'=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,12) S DR=".858////"_ABM("X")
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,19)'="",(ABM("X")'=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,12)),(ABM("X")'=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,19)) S DR=".859////"_ABM("X")
 Q:($G(DR)="")
 D ^DIE
 S ABMEFLG=1
 Q

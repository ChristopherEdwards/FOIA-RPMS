ABMDE5 ; IHS/ASDST/DMJ - Edit Page 5 - DIAGNOSIS ; 
 ;;2.6;IHS Third Party Billing;**1,3,4,6**;NOV 12, 2009
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
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7045 - Display page5B if procedure exists
 ; IHS/SD/SDR - abm*2.6*3 - NOHEAT - Fix display of 5B; wasn't displaying if no procs existed
 ; IHS/SD/SDR - abm*2.6*6 - HEAT29426 - <UNDEF>PRTTXT+3^ABMDWRAP error if ICD long desc missing; defaulted to short desc.
 ;
OPT K ABM,ABME,ABMZ,ABMU
 D DISP Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)
 W !! S ABMP("OPT")="ADESVNJBQ" S:$G(ABMZ("NUM"))=0 ABMP("DFLT")="A" D SEL^ABMDEOPT K ABMP("ED") I "ADESVN"'[$E(Y) G XIT
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
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="D":"D1^ABMDEMLB",$E(Y)="E":"E1^ABMDEMLE",$E(Y)="V":"^ABMDE5A",1:"S1^ABMDEMLA") D @ABM("DO")
 D RES^ABMDEMLA(17)
 G OPT
 ;
OPT2 K ABM,ABME,ABMZ
 D DISP2^ABMDE5D Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)
 W !! S ABMP("OPT")="ADESVNJBQ" D SEL^ABMDEOPT I "AVEVSDB"'[$E(Y) S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=5) ABMP("QUIT")="" G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT:$E(Y)="B"
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="E":"E1^ABMDEMLE",$E(Y)="D":"D1^ABMDEMLB",$E(Y)="V":"^ABMDE5B",1:"S1^ABMDEMLA") D @ABM("DO")
 G OPT2
 ;
DISP S ABMZ("TITL")="DIAGNOSIS",ABMZ("PG")="5A"
 D A^ABMDE5X
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 E  D SUM^ABMDE1
 ;
DIAG ; Diagnosis Info
 S ABMZ("SUB")=17,ABMZ("ITEM")="Diagnosis",ABMZ("DIC")="^ICD9(",ABMZ("X")="DINUM",ABMZ("DR")="",ABMZ("NARR")=";.03////"_U_3_U_4
 D HD G LOOP
HD W !,"BIL",?6,"ICD9"
 W !,"SEQ",?5," CODE "
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .W ?13,"POA",?23,"Dx DESCRIPTION",?51,"PROVIDER'S NARRATIVE"
 E  W ?19,"Dx DESCRIPTION",?51,"PROVIDER'S NARRATIVE"
 W !,"===",?5,"======="
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .W ?13,"===",?17,"==========================",?44,"===================================="
 E  W ?13,"==========================",?40,"======================================="
 Q
LOOP ;
 S ABMEFLG=0
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1))=0,ABM="" F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABM)) Q:'ABM  S ABM("X")=$O(^(ABM,"")),ABMZ("NUM")=ABM("I") D DX
 S ABM("L")=ABMZ("LNUM")+1,ABMZ("DR2")=";.02////"_ABM("L")
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
DX S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),17,ABM("X"),0) S:ABMZ("LNUM")<$P(^(0),U,2) ABMZ("LNUM")=$P(^(0),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 ;ABMZ(ABM("I"))=code^multiple ien^code ien^provider narr^e-code^poa
 S ABMZ(ABM("I"))=$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3)_U_$P(ABM("X0"),U,4)_U_$P(ABM("X0"),U,5)  ;CSV-c
 W !,$J(ABM("I"),2),?5,$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)  ;CSV-c  ;code
 W:$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) ?14,$P(ABM("X0"),U,5)  ;poa
 I $G(ABMEFLG)=0,$P($$DX^ABMCVAPI(+ABM("X"),ABMP("VDT")),U,2)["E" D ECODE  ;CSV-c
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
 I $P($G(^ABMDPARM(DUZ(2),1,0)),U,14)'="Y"!(ABMU("TXT")="") S ABMU("TXT")=$P($$DX^ABMCVAPI(ABM("X"),ABMP("VDT")),U,4)  ;abm*2.6*6 HEAT29426
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y"&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) D
 .S ABMU("LM")=17,ABMU("RM")=42,ABMU("TAB")=-3
 .S ABMU("2LM")=44,ABMU("2RM")=80,ABMU("2TAB")=-3
 E  D
 .S ABMU("LM")=13,ABMU("RM")=38,ABMU("TAB")=-3
 .S ABMU("2LM")=40,ABMU("2RM")=80,ABMU("2TAB")=-3
 S ABMU("2TXT")=$S($P(ABM("X0"),U,3)]"":$P($G(^AUTNPOV($P(ABM("X0"),U,3),0)),U),1:"")
 I ABMU("2TXT")["*ICD*" S ABMU("2TXT")=$P(ABMU("2TXT"),"  ")
 I ABMU("2TXT")]"",$D(^ICD9("BA",ABMU("2TXT"))) S ABMU("2TXT")=$P($$DX^ABMCVAPI($O(^(ABMU("2TXT"),"")),ABMP("VDT")),U,4)  ;CSV-c
 D ^ABMDWRAP
 I $P($G(ABM("X0")),U,4)'="" D
 .W !,?7,"CAUSE(E-CODE): "_$P($$DX^ABMCVAPI($P(ABM("X0"),U,4),ABMP("VDT")),U,2)  ;CSV-c
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

BARRAOI ; IHS/SD/LSL - AGE OPEN ITEMS RPT JAN 16,1997 ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 03/11/03 - Routine created
 ;        Replaces BARRAGED
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ********************************************************************
EN ; EP
 ;
 K BARY,BAR,BARP
 S BAR("PRIVACY")=1                   ; Privacy act applies
 D:'$D(BARUSR) INIT^BARUTL            ; Set A/R basic variable
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D ASKQUES                            ; Ask user questions
 Q:$D(DTOUT)!$D(DUOUT)
 D SETHDR
 S BARQ("RC")="COMPUTE^BARRAOI"    ; Compute routine
 S BARQ("RP")="PRINT^BARRAOI"      ; Print routine
 S BARQ("NS")="BAR"                   ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"          ; Clean-up routine
 D ^BARDBQUE                          ; Double queuing
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
ASKQUES ;
 ; Ask user questions
 D MSG^BARRSEL                        ; Message about BILL/VIS loc
 D LOC^BARRSL1                        ; Ask loc - return BARY("LOC")
 Q:$D(DTOUT)!($D(DUOUT))              ; Q if time or "^" out
 W:'$D(BARY("LOC")) "ALL"
 D AGE                                ; Ask age group - return BARAGE
 Q:$D(DTOUT)!($D(DUOUT))
 D ASKAP                              ; Ask Patient or Insurer
 Q:$D(DTOUT)!($D(DUOUT))
 I BARAP="P" D  Q:($D(DTOUT)!($D(DUOUT)))
 . D ASKPAT
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:'$D(BARY("PAT")) "ALL"
 I BARAP="I" D  Q:($D(DTOUT)!($D(DUOUT)))
 . D ACCT
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:'$D(BARY("ACCT")) "ALL"
 K DIR,DIC,X,Y,DA
 Q
 ; ********************************************************************
 ;
AGE ;
 ; Ask user to select age group for bill
 K DIR
 S DIR(0)="S^1:0-30;2:31-60;3:61-90;4:91-120;5:120+"
 S DIR("A")="Select aging range for bills"
 D ^DIR
 I Y<0!($D(DUOUT))!($D(DTOUT)) Q
 S BAR("SELECTION")=Y(0)
 S:Y=5 BAR("SELECTION")="OVER 120"
 S BARAGE=$S(Y=1:7.3,Y=2:7.4,Y=3:7.5,Y=4:7.6,Y=5:7.7)
 Q
 ; ********************************************************************
 ;
ASKAP ;
 ; Ask user if want report by insurer or payer
 S (BARY("OBAL"),BARY("STCR"))=1      ; Need to loop "OBAL" x-ref
 S BARAP="I"
 K DIR
 S DIR(0)="SO^I:INSURER;P:PATIENT"
 S DIR("B")="I"
 S DIR("A")="Should the report contain data for Insurer or Patient (I/P)"
 D ^DIR
 I Y=""!($D(DUOUT))!($D(DTOUT)) Q
 S BARAP=Y
 S BARAP("NAME")=Y(0)
 Q
 ; ********************************************************************
 ;
ASKPAT ;
 ; Ask user for Patient Name
 K DIC,BARZ
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 S DIC("A")="Select Patient: "
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 D ^DIC
 K DIC
 Q:+Y<0
 K BARY("OBAL"),BARY("STCR")
 S BARY("PAT")=+Y
 S BARY("PAT","NM")=$P($G(^DPT(+BARY("PAT"),0)),U)
 Q
 ; ********************************************************************
 ;
ACCT ;
 ; Ask user for AR Account
 W !
 K DIC
 S DIC("A")="Select Insurer or press <RETURN> for all Insurers: "
 S DIC="90050.02"
 S DIC(0)="AEMQZ"
 S DIC("S")="I $P(^(0),U,10)=$$GET1^DIQ(200,DUZ,29,""I"")"
 K DD,DO
 D ^DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<0
 K BARY("OBAL"),BARY("STCR")
 S BARY("ACCT")=+Y
 S BARY("ACCT","NM")=Y(0,0)
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Set Header array
 S BAR("HD",0)=""
 S BAR("TXT")="Aged Open Items Report"
 S BAR("LVL")=0
 S BAR("CONJ")=""
 D CHK^BARRHD                         ; Line 1 of Report header
 S BAR("LVL")=BAR("LVL")+1
 S BAR("HD",BAR("LVL"))=""
 S BAR("TXT")="Bills "_BAR("SELECTION")_" days old"
 S BAR("CONJ")="for "
 D CHK^BARRHD
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK^BARRHD
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
COMPUTE ; EP
 S BAR("SUBR")="BAR-AOI"
 S BARP("RTN")="BARRAOI"
 K ^TMP($J,"BAR-AOI")
 I BAR("LOC")="BILLING" D LOOP^BARRUTL Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D LOOP^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; ********************************************************************
 ;
DATA ; EP
 S BARP("HIT")=0
 D BILL^BARRCHK
 Q:'BARP("HIT")
 S BARAMT=$$GET1^DIQ(90050.01,BAR,BARAGE)
 Q:'+BARAMT                           ; Bill not right age
 S BARLOC=""
 S:BAR("L")]"" BARLOC=$$VAL^XBDIQ1(4,BAR("L"),.01)
 S:BARLOC="" BARLOC="No Visit Location"       ; Visit Location Name
 S BARACCT=""
 S:BAR("I")]"" BARACCT=$$VAL^XBDIQ1(90050.02,BAR("I"),.01)
 S:BARACCT="" BARACCT="No A/R Account"        ; A/R Account Name
 S BARPAT=""
 S:BAR("P")]"" BARPAT=$$VAL^XBDIQ1(9000001,BAR("P"),.01)
 S:BARPAT="" BARPAT="No Patient Name"         ; Patient Name
 S BARBILL=$P(BAR(0),U)                       ; Bill Number
 ;
 S ^TMP($J,"BAR-AOI",BARLOC,BARACCT,BARPAT,BARBILL)=BAR("D")_U_BARAMT
 ;
 S BARHOLD=$G(^TMP($J,"BAR-AOI",BARLOC,BARACCT))
 S ^TMP($J,"BAR-AOI",BARLOC,BARACCT)=BARHOLD+BARAMT
 ;
 S BARHOLD=$G(^TMP($J,"BAR-AOI",BARLOC))
 S ^TMP($J,"BAR-AOI",BARLOC)=BARHOLD+BARAMT
 ;
 S BARHOLD=$G(^TMP($J,"BAR-AOI"))
 S ^TMP($J,"BAR-AOI")=BARHOLD+BARAMT
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRINT ; EP
 K BARHOLD,BARAMT,BARBILL,BARPAT,BARACCT,BARLOC,BAR("D")
 S BAR("PG")=0
 S BAR("COL")="W !?6,""PATIENT NAME"",?30,""BILL NUMBER"",?56,""DOS"",?68,BAR(""SELECTION"")"
 D HDB^BARRPSRB
 I '$D(^TMP($J,"BAR-AOI")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 S BARLOC=""
 F  S BARLOC=$O(^TMP($J,"BAR-AOI",BARLOC)) Q:BARLOC=""  D LOC Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
LOC ;
 ; For each Location do
 W !?5,"VISIT Location:  ",BARLOC
 S BARACCT=""
 F  S BARACCT=$O(^TMP($J,"BAR-AOI",BARLOC,BARACCT)) Q:BARACCT=""  D ACCOUNT Q:$G(BAR("F1"))
 D LOCTOTAL
 Q
 ; ********************************************************************
 ;
ACCOUNT ;
 ; For each AR Account w/in Visit location Do
 W !?10,"A/R Account:  ",BARACCT,!
 S BARPAT=""
 F  S BARPAT=$O(^TMP($J,"BAR-AOI",BARLOC,BARACCT,BARPAT)) Q:BARPAT=""  D PAT Q:$G(BAR("F1"))
 D ACCTOTAL
 Q
 ; ********************************************************************
 ;
PAT ;
 ; For each patient w/in AR Account w/in Visit location do
 S BARBILL=""
 F  S BARBILL=$O(^TMP($J,"BAR-AOI",BARLOC,BARACCT,BARPAT,BARBILL)) Q:BARBILL=""  D DETAIL Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
 ;
DETAIL ;
 ; Write detail line of report
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-AOI",BARLOC,BARACCT,BARPAT,BARBILL))
 W !?3,$E(BARPAT,1,25)                ; Patient Name
 W ?30,$E(BARBILL,1,20)               ; Bill Name
 W ?52,$$SDT^BARDUTL($P(BARTMP,U))    ; DOS
 W ?64,$J($FN($P(BARTMP,U,2),",",2),12)   ; $ amt aged
 Q
 ; ********************************************************************
 ;
ACCTOTAL ;
 ; A/R Account total
 W !?64,"------------"
 W !?5,"  * ",$E(BARACCT,1,45)," TOTAL"
 W ?63,$J($FN(^TMP($J,"BAR-AOI",BARLOC,BARACCT),",",2),13),!
 Q
 ; ********************************************************************
 ;
LOCTOTAL ;
 ; Visit location total
 W ?64,"------------"
 W !?5," ** ",$E(BARLOC,1,45)," TOTAL"
 W ?63,$J($FN(^TMP($J,"BAR-AOI",BARLOC),",",2),13),!
 Q
 ; ********************************************************************
 ;
TOTAL ;
 ; Report Total
 W ?64,"============"
 W !?5,"*** REPORT TOTAL"
 W ?62,$J($FN(^TMP($J,"BAR-AOI"),",",2),14)
 Q

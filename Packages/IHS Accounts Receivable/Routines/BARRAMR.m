BARRAMR ; IHS/SD/LSL - Aging management report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 08/29/00 - Routine created
 ;     Really Age Detail and Bills Listing Reports
 ;
 ; IHS/SD/LSL - 04/19/02 - V1.6 Patch 2
 ;     Modified to accomodate new "Location to sort report by" parameter
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 S BARP("RTN")="BARRAMR"
 S BAR("PRIVACY")=1                ; Privacy act applies
 D:'$D(BARUSR) INIT^BARUTL         ; Set A/R basic variable
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D ^BARRSEL                        ; Select exclusion parameters
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 I $D(BARY("RTYP")) S BAR("HD",0)=BARY("RTYP","NM")_" "_BARMENU
 E  S BAR("HD",0)=BARMENU
 D ^BARRHD                         ; Report header
 S BARQ("RC")="COMPUTE^BARRAMR"    ; Compute routine
 S BARQ("RP")="PRINT^BARRAMR"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; *********************************************************************
 ;
COMPUTE ;
 ;
 S BAR("SUBR")="BAR-AMR"
 K ^TMP($J,"BAR-AMR")
 S BARP("RTN")="BARRAMR"     ; Routine used to get data if no parameters
 I BAR("LOC")="BILLING" D LOOP^BARRUTL Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D LOOP^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ; EP
 ; Called by BARRUTL if no parameters
 S BARP("HIT")=0
 D BILL^BARRCHK
 Q:'BARP("HIT")
 S BAR("BAL")=$P(BAR(0),U,15)     ; Current bill amt
 ; Quit if Age Detail report and absolute value of balance < a penny
 I BAR("OPT")="AGE",$FN(BAR("BAL"),"-")<.01 Q
 S BAR("PAT")=$$VAL^XBDIQ1(9000001,BAR("P"),.01)
 S BAR("SORT")=$S(BARY("SORT")="C":BAR("C"),1:BAR("V"))
 I BAR("I")]"" S BAR("ACCT")=$$VAL^XBDIQ1(90050.02,BAR("I"),.01)
 E  S BAR("ACCT")="No A/R Account"
 S BAR("L")=$$VAL^XBDIQ1(9999999.06,BAR("L"),.01)
 ; For detail
 S ^TMP($J,"BAR-AMR",BAR("L")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR("PAT")_U_BAR)=""
 ; For summary
 S $P(BAR("ST",BAR("L"),BAR("SORT"),BAR("ACCT")),U)=$P($G(BAR("ST",BAR("L"),BAR("SORT"),BAR("ACCT"))),U)+1
 S $P(BAR("ST",BAR("L"),BAR("SORT"),BAR("ACCT")),U,2)=$P($G(BAR("ST",BAR("L"),BAR("SORT"),BAR("ACCT"))),U,2)+$P(BAR(0),U,13)
 S $P(BAR("ST",BAR("L"),BAR("SORT"),BAR("ACCT")),U,3)=$P($G(BAR("ST",BAR("L"),BAR("SORT"),BAR("ACCT"))),U,3)+BAR("BAL")
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 ; Print
 S BAR("PG")=0
 I BARY("RTYP")=1 D DETAIL^BARRAMR2,FOOTER
 I BARY("RTYP")=2 D SUMM^BARRAMR3,FOOTER
 I BARY("RTYP")=3 D
 . D DETAIL^BARRAMR2
 . Q:$G(BAR("F1"))
 . Q:'$D(@BAR)            ; No data
 . D PAZ^BARRUTL
 . D SUMM^BARRAMR3
 . D FOOTER
 Q
 ; *********************************************************************
 ;
FOOTER ;
 Q:$G(BAR("F1"))
 I $D(BAR("ST")) D
 . W !!!!?16,"*****  R E P O R T  C O M P L E T E  *****"
 Q

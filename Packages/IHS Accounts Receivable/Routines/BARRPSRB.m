BARRPSRB ; IHS/SD/LSL - Period Summary Report Print ; 08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/ASDS/LSL - 02/27/03 - V1.7 Patch 1
 ;     Routine created.  Called from BARRPSRA
 ;     PRINT^BARRASMA - Print report
 ;
 ; IHS/SD/LSL - 08/01/03 - V1.7 Patch 2
 ;     Add call to PSR^EISS for print of summary data
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 ; Print reports
 F I=1:1:4 K BAR(I)
 F I=1:1:5 K BAR("SUB"_I)
 S BAR("PG")=0
 S BARDASH="                     --------------- -------------- -------------- -------------"
 S BAREQUAL="                    =============== ============== ============== ============="
 S BAR("COL")="W !,BARY(""STCR"",""NM""),?25,""Billed Amt"",?43,""Payment"",?55,""Adjustment"",?72,""Refund"""
 I ",1,2,3,4,"[(","_BARY("STCR")_",") D STANDARD
 I $G(BAR("F1")) D XIT Q
 I $G(BARY("RTYP"))=1 D SUMMARY
 I $G(BAR("F1")) D XIT Q
 I $G(BARY("RTYP"))=2 D DETAIL
 I $G(BAR("F1")) D XIT Q
 I $G(BARY("RTYP"))=3 D BILL
 I $G(BAR("F1")) D XIT Q
 Q
 ; *********************************************************************
 ;
STANDARD ;
 ; Print report if user selected SORT CRITERIA a/r account, visit, or
 ; clinic
 ;
 D HDB
 I '$D(^TMP($J,"BAR-PSR")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-PSR",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-PSR",BAR("SUB1"))) Q:BAR("SUB1")=""  D STNDLOC Q:$G(BAR("F1"))
 D STNDTOT
 Q
 ; ********************************************************************
 ;
STNDLOC ;
 ; For each Visit Location (Standard Format) Do...
 I BAR("SUB1")'=BARHOLD("SUB1") D HD
 Q:$G(BAR("F1"))
 S BARHOLD("SUB1")=BAR("SUB1")
 I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB1"),!
 S BAR("SUB2")=""
 F  S BAR("SUB2")=$O(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2"))) Q:BAR("SUB2")=""  D STNDDET Q:$G(BAR("F1"))
 D STNDLTOT
 Q
 ; ********************************************************************
 ;
STNDDET ;
 ; For each Clinic/Visit Type/AR Account/Dsch Svc (Standard) do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2")))
 S BARNAME=BAR("SUB2")
 W !,$E(BARNAME,1,19)            ; clinic/vis typ/A/R acct/discharge svc
 D STNDLINE
 Q
 ; ********************************************************************
 ;
STNDLTOT ;
 ; Visit Location Totals (Standard format)
 Q:$G(BAR("F1"))
 W !,BARDASH,!
 S BARTMP=$G(^TMP($J,"BAR-PSR",BAR("SUB1")))
 W "*** VISIT Loc Total"
 D STNDLINE
 Q
 ; *********************************************************************
 ;
STNDTOT ;
 ; Report Totals (Standard format)
 Q:$G(BAR("F1"))
 W !,BAREQUAL,!
 S BARTMP=$G(^TMP($J,"BAR-PSR"))
 W "***** REPORT TOTAL"
 D STNDLINE
 Q
 ; *********************************************************************
 ; *********************************************************************
 ;
SUMMARY ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type w/o payers
 ;
 D HDB
 I '$D(^TMP($J,"BAR-PSRT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-PSRT",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"))) Q:BAR("SUB1")=""  D SUMLOC  Q:$G(BAR("F1"))
 W !
 D SUMTOT
 I BARY("STCR")=5,'$D(BARY("ALL")) D PSR^BAREISS
 Q
 ; ********************************************************************
 ;
SUMLOC ;
 ; For each visit location (Summary format) do...
 I BAR("SUB1")'=BARHOLD("SUB1") D HD
 Q:$G(BAR("F1"))
 S BARHOLD("SUB1")=BAR("SUB1")
 I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB1"),!
 S BAR("SUB3")=""
 F  S BAR("SUB3")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"))) Q:BAR("SUB3")=""  D SUMDET Q:$G(BAR("F1"))
 W !
 D SUMLTOT
 Q
 ; ********************************************************************
 ;
SUMDET ;
 ; For each Billing Entity/Allowance category (summary) do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")))
 W !,$E(BAR("SUB3"),1,19)
 D STNDLINE
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
DETAIL ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers
 D HDB
 I '$D(^TMP($J,"BAR-PSRT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-PSRT",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"))) Q:BAR("SUB1")=""  D DETLOC  Q:$G(BAR("F1"))
 W !
 D SUMTOT
 Q
 ; ********************************************************************
 ;
DETLOC ;
 ; For each visit location (Detail format) do...
 I BAR("SUB1")'=BARHOLD("SUB1") D HD
 Q:$G(BAR("F1"))
 S BARHOLD("SUB1")=BAR("SUB1")
 I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB1"),!
 S BAR("SUB3")=""
 F  S BAR("SUB3")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"))) Q:BAR("SUB3")=""  D DETBEAL Q:$G(BAR("F1"))
 D SUMLTOT
 Q
 ; ********************************************************************
 ;
DETBEAL ;
 ; For each Billing Entity/Allowance category (Detail format) do...
 W !,BAR("SUB3")
 S BAR("SUB4")=""
 F  S BAR("SUB4")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"))) Q:BAR("SUB4")=""  D DETDET Q:$G(BAR("F1"))
 W !
 D BEALTOT
 Q
 ; ********************************************************************
 ;
DETDET ;
 ; For each A/R Account (Detail Format) do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")))
 W !?3,$E(BAR("SUB4"),1,15)
 D STNDLINE
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
BILL ;
 ; Summary / by payer / By Bill
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers AND bills
 D HDB
 I '$D(^TMP($J,"BAR-PSRT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-PSRT",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"))) Q:BAR("SUB1")=""  D BILLLOC  Q:$G(BAR("F1"))
 W !
 D SUMTOT
 Q
 ; ********************************************************************
 ;
BILLLOC ;
 ; For each visit location (Detail format) do...
 I BAR("SUB1")'=BARHOLD("SUB1") D HD
 Q:$G(BAR("F1"))
 S BARHOLD("SUB1")=BAR("SUB1")
 I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB1"),!
 S BAR("SUB3")=""
 F  S BAR("SUB3")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"))) Q:BAR("SUB3")=""  D BILLBEAL Q:$G(BAR("F1"))
 W !
 D SUMLTOT
 Q
 ; ********************************************************************
 ;
BILLBEAL ;
 ; For each Billing Entity/Allowance category (Detail format) do...
 W $$EN^BARVDF("HIN")
 W !,$$CJ^XLFSTR(BAR("SUB3"),IOM),!
 W $$EN^BARVDF("HIF")
 S BAR("SUB4")=""
 F  S BAR("SUB4")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"))) Q:BAR("SUB4")=""  D BILLACCT Q:$G(BAR("F1"))
 D BEALTOT
 Q
 ; ********************************************************************
 ;
BILLACCT ;
 ; For each A/R Account (Bill detail) do ...
 W !?3,BAR("SUB4")
 S BAR("SUB5")=""
 F  S BAR("SUB5")=$O(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5"))) Q:BAR("SUB5")=""  D BILLDET Q:$G(BAR("F1"))
 D ACCTTOT
 Q
 ; ********************************************************************
 ;
BILLDET ;
 ; For each Bill (Bill Format) do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")))
 W !?6,$E(BAR("SUB5"),1,15)
 D STNDLINE
 Q
 ; ********************************************************************
 ;
SUMTOT ;
 ; Report totals (summary, detail, bill)
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT"))
 W BAREQUAL,!
 W "***** REPORT Total"
 D STNDLINE
 Q
 ; ********************************************************************
 ;
SUMLTOT ;
 ; Visit Location totals (summary, detail, bill)
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT",BAR("SUB1")))
 W BARDASH,!
 W "*** VISIT Loc Total"
 D STNDLINE
 Q
 ; ********************************************************************
 ;
BEALTOT ;
 ; Billing Entity / Allowance Category totals (detail, bill)
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")))
 W BARDASH,!
 I BARY("STCR")=5 W " ** Allow Cat Total"
 I BARY("STCR")=6 W " ** Bill Entity Total"
 I BARY("STCR")=7 W " ** Ins Type Total"
 D STNDLINE
 Q
 ; ********************************************************************
 ;
ACCTTOT ;
 ; A/R  Account totals (bill)
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")))
 W !,BARDASH,!
 W "  * A/R Acct Total"
 D STNDLINE
 W !
 Q
 ; ********************************************************************
 ;
STNDLINE ;
 W ?20,$J($FN($P(BARTMP,U),",",2),15)      ; Amount billed
 W ?36,$J($FN($P(BARTMP,U,2),",",2),14)      ; Payments
 W ?51,$J($FN($P(BARTMP,U,3),",",2),14)      ; Adjustments
 W ?66,$J($FN($P(BARTMP,U,4),",",2),13)      ; Refunds
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
HD ; EP
 D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 ; -------------------------------
 ;
HDB ; EP
 ; Page and column header
 S BAR("PG")=BAR("PG")+1
 S BAR("I")=""
 D WHD^BARRHD                   ; Report header
 X BAR("COL")
 S $P(BAR("DASH"),"=",$S($D(BAR(133)):132,1:81))=""
 W !,BAR("DASH"),!
 Q
 ; ********************************************************************
 ;
XIT ;
 K ^TMP($J,"BAR-PSR")
 K ^TMP($J,"BAR-PSRT")
 Q

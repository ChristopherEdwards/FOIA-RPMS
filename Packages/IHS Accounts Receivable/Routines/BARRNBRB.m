BARRNBRB ; IHS/SD/POT - Non Ben Payment Report PART 2
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**24**;OCT 26, 2005;Build 69
 ; IHS/SD/POT 07/15/13 HEAT114352 NEW REPORT BAR*1.8*24
 ; IHS/SD/POT 01/14/14 FIXED: IDENTIFY PAYMENTS TO OTHER PAT
 ; IHS/SD/POT 03/21/14 ADJUSTED TOTAL BILL LINE
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 S BARMODE="S"
 I $G(BARY("RTYP"))=1 S BARMODE="D"
 ; Print reports
 F I=1:1:4 K BAR(I)
 F I=1:1:5 K BAR("SUB"_I)
 S BAR("PG")=0
 S BARDASH="                     --------------- -------------- -------------- -------------"
 S BAREQUAL="                    =============== ============== ============== ============="
 ;
 D BILL
 ;;;D STANDARD 1/13/2014
 D XIT
 Q
 ; *********************************************************************
 ;
STANDARD ;
 ; Print report if user selected SORT CRITERIA a/r account, visit, or
 ; clinic
 ;
 D HDB
 I '$D(^TMP($J,"BAR-NBR")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-NBR",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-NBR",BAR("SUB1"))) Q:BAR("SUB1")=""  D STNDLOC Q:$G(BAR("F1"))
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
 F  S BAR("SUB2")=$O(^TMP($J,"BAR-NBR",BAR("SUB1"),BAR("SUB2"))) Q:BAR("SUB2")=""  D STNDDET Q:$G(BAR("F1"))
 D STNDLTOT
 Q
 ; ********************************************************************
 ;
STNDDET ;
 ; For each Clinic/Visit Type/AR Account/Dsch Svc (Standard) do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-NBR",BAR("SUB1"),BAR("SUB2")))
 S BARNAME=BAR("SUB2")
 W !,$E(BARNAME,1,19)            ; clinic/vis typ
 D STNDLINE
 Q
 ; ********************************************************************
 ;
STNDLTOT ;
 ; Visit Location Totals (Standard format)
 Q:$G(BAR("F1"))
 W !,BARDASH,!
 S BARTMP=$G(^TMP($J,"BAR-NBR",BAR("SUB1")))
 W "*** VISIT Loc Total"
 D STNDLINE
 Q
 ; *********************************************************************
 ;
STNDTOT ;
 ; Report Totals (Standard format)
 Q:$G(BAR("F1"))
 W !,BAREQUAL,!
 S BARTMP=$G(^TMP($J,"BAR-NBR"))
 W "***** REPORT TOTAL"
 D STNDLINE
 Q
 ; *********************************************************************
 ;
SUMMARY ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type w/o payers
 ;
 D HDB
 I '$D(^TMP($J,"BAR-NBRT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-NBRT",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"))) Q:BAR("SUB1")=""  D SUMLOC  Q:$G(BAR("F1"))
 W !
 D SUMTOT
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
 F  S BAR("SUB3")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"))) Q:BAR("SUB3")=""  D SUMDET Q:$G(BAR("F1"))
 W !
 D SUMLTOT
 Q
 ; ********************************************************************
 ;
SUMDET ;
 QUIT
 ; ********************************************************************
 ;
DETAIL ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers
 D HDB
 I '$D(^TMP($J,"BAR-NBRT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-NBRT",""))
 S BAR("SUB1")=""
 F  S BAR("SUB1")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"))) Q:BAR("SUB1")=""  D DETLOC  Q:$G(BAR("F1"))
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
 F  S BAR("SUB3")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"))) Q:BAR("SUB3")=""  D DETBEAL Q:$G(BAR("F1"))
 D SUMLTOT
 Q
 ; ********************************************************************
 ;
DETBEAL ;
 ; For each Billing Entity/Allowance category (Detail format) do...
 W !,BAR("SUB3")
 S BAR("SUB4")=""
 F  S BAR("SUB4")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"))) Q:BAR("SUB4")=""  D DETDET Q:$G(BAR("F1"))
 W !
 D BEALTOT
 Q
 ; ********************************************************************
 ;
DETDET ;
 Q  ;
 ; ********************************************************************
 ;
BILL ;
 ; Summary / by payer / By Bill
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers AND bills
 D HDB
 I '$D(^TMP($J,"BAR-NBRT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB1")=$O(^TMP($J,"BAR-NBRT",""))
 S BAR("SUB1")=""  F  S BAR("SUB1")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"))) Q:BAR("SUB1")=""  D BILLLOC  Q:$G(BAR("F1"))
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
 F  S BAR("SUB3")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"))) Q:BAR("SUB3")=""  D BILLBEAL Q:$G(BAR("F1"))
 W !
 D SUMLTOT
 Q
 ; ********************************************************************
 ;
BILLBEAL ;
 ; For each Billing Entity/Allowance category (Detail format) do...
 W $$EN^BARVDF("HIN")
 ;;;W !,$$CJ^XLFSTR(BAR("SUB3"),IOM),! ;P.OTT
 W $$EN^BARVDF("HIF")
 S BAR("SUB4")=""
 F  S BAR("SUB4")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"))) Q:BAR("SUB4")=""  D BILLACCT Q:$G(BAR("F1"))
 D BEALTOT
 Q
 ; ********************************************************************
 ;
BILLACCT ;
 ; For each A/R Account (Bill detail) do ...
 S BAR("SUB5")=""
 F  S BAR("SUB5")=$O(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5"))) Q:BAR("SUB5")=""  D BILLDET Q:$G(BAR("F1"))
 D ACCTTOT
 Q
 ; ********************************************************************
 ;
BILLDET ;
 ; For each Bill (Bill Format) do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")))
 ;
 I BARMODE="D" D  Q  ;DETAILED
 . D BILLLOOP
 . D BILLLINE
 . ;D STNDLINE
 . W !
 . Q
 S BARTMP=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")))
 W !,$P(BAR("SUB5"),"-")  ;SUMMARY FOR BILL
 D STNDLINE
 Q
 ; ********************************************************************
 ;
BILLLOOP ;^TMP(4212,"BAR-NBR9",29055,5496)="3060413.141933^29055A-IH-12770^101^101^0^12770"
 ;FROM BILL_NUMBER-FULL^BILLED^BALANCE^INS^PAT^PATIENT_IEN
 ;TO: ^BILLED^BALANCE^INS^PAT^
 N BARBILL,BARBL,BARTMP1,BARTMP2,BARD1,BARD2,BARD3,BARD4,BARCNT
 S BARBILL=$P(BAR("SUB5"),"-")  ; p.ott BILL # PART1
 S BARBL="0" F  S BARBL=$O(^TMP($J,"BAR-NBR9",BARBILL,BARBL)) Q:+BARBL=0  D  Q:$G(BAR("F1"))
 . S BARTMP1=$G(^TMP($J,"BAR-NBR9",BARBILL,BARBL))
 . S BARFULL=$P(BARTMP1,"^",1)
 . S BARD1=$P(BARTMP1,"^",2) ;AMT BILLED
 . S BARD4=$P(BARTMP1,"^",3) ;BALANCE
 . W !,BARFULL
 . S BARCNT=0
 . S BARTR="0" F  S BARTR=$O(^TMP($J,"BAR-NBR9",BARBILL,BARBL,BARTR)) Q:+BARTR=0  D  Q:$G(BAR("F1"))
 . . S BARTMP2=$G(^TMP($J,"BAR-NBR9",BARBILL,BARBL,BARTR))
 . . ;S BARTRT=$P(BARTMP2,"^",3) I BARTRT'=40 Q  ;W !,BARTR," NO PAYMENT" QUIT
 . . S BARFLG=$P(BARTMP2,"^",8),BARAMT=$P(BARTMP2,"^",7)
 . . S BARD2=0,BARD3=0
 . . S BARD2=BARAMT I BARFLG S BARD3=BARAMT,BARD2=0 ;PAT OR INS?
 . . S BARCNT=BARCNT+1 ;I BARCNT>1 W !
 . . W ! ;,BARTR
 . . I BARD3>0 W ?10,$$MDY(BARTR\1) ;DISPLAY DATE ONLY FOR PAT PAYMENTS (!)
 . . D STNDLN2(BARBL)
 . I BARCNT=0 D
 . . W ?36,$J($FN(0,",",2),14)      ; INS
 . . W ?51,$J($FN(0,",",2),14)      ; PAT
 . Q
 W !,BARDASH
 ;W !,"*** BILL ",BARBILL," Total"
 W !,"*** ",BARBILL," Total"
 Q
STNDLN2(BARBL) ;
 I BARCNT=1 W ?20,$J($FN(BARD1,",",2),15)     ; Amount billed
 W ?36,$J($FN(BARD2,",",2),14)      ; INS
 W ?51,$J($FN(BARD3,",",2),14)      ; PAT
 I BARFLG<0 W "*" ;1/14/2014
 I BARCNT=1 W ?66,$J($FN(BARD4,",",2),13)     ; 
 Q
SUMTOT ;
 ; Report totals (summary, detail, bill)
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-NBRT"))
 W BAREQUAL,!
 W "***** REPORT Total"
 D STNDLINE
 Q
 ; ********************************************************************
 ;
SUMLTOT ;
 ; Visit Location totals (summary, detail, bill)
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-NBRT",BAR("SUB1")))
 W BARDASH,!
 W "*** VISIT Loc Total"
 D STNDLINE
 Q
 ; ********************************************************************
 ;
BEALTOT ;
 ; Billing Entity / Allowance Category totals (detail, bill)
 Q  ;P.OTT
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3")))
 W BARDASH,!
 W " ** Total"
 D STNDLINE
 Q
 ; ********************************************************************
 ;
ACCTTOT ;
 ; A/R  Account totals (bill)
 Q  ;P.OTT
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")))
 W !,BARDASH,!
 W "  * A/R Acct Total"
 D STNDLINE
 W !
 Q
 ; ********************************************************************
 ;
BILLLINE ;SUM FOR BILL (XXXX (A,B,C)
 N BARBILL,BARTMP
 S BARBILL=$P(BAR("SUB5"),"-")  ; p.ott BILL # PART1
 S BARTMP=$G(^TMP($J,"BAR-NBR9",BARBILL))
 W ?20,$J($FN($P(BARTMP,U),",",2),15)        ; Amount billed
 W ?36,$J($FN($P(BARTMP,U,2),",",2),14)      ; Patient Payments
 W ?51,$J($FN($P(BARTMP,U,3),",",2),14)      ; insurance payments
 W ?66,$J($FN($P(BARTMP,U,4),",",2),13)      ; balance
 Q
STNDLINE ;
 W ?20,$J($FN($P(BARTMP,U),",",2),15)        ; Amount billed
 W ?36,$J($FN($P(BARTMP,U,2),",",2),14)      ; Patient Payments
 W ?51,$J($FN($P(BARTMP,U,3),",",2),14)      ; insurance payments
 W ?66,$J($FN($P(BARTMP,U,4),",",2),13)      ; balance
 Q
 ; ********************************************************************
 ;
B13(BARBL) ;
 Q
B15(BARBL) ;
 Q
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
 D HDRBAR(BARMODE) ;12/31/2013
 S $P(BAR("DASH"),"=",$S($D(BAR(133)):132,1:81))=""
 W !,BAR("DASH"),!
 Q
 ; ********************************************************************
 ;
XIT ;
 K ^TMP($J,"BAR-NBR")
 K ^TMP($J,"BAR-NBRT")
 Q
HDRBAR(BARMODE) ;
 I BARMODE="D" D  Q
 . W !,"Bill",?10,"Pt Payment",?29,"Amount",?43,"Insurance",?58,"Patient"
 . W !,"Number",?9,"Posted Date",?29,"Billed",?43,"Payment",?58,"Payment",?72,"Balance"
 I BARMODE="S" D  Q
 . W !,"Bill",?29,"Amount",?43,"Insurance",?58,"Patient"
 . W !,"Number",?29,"Billed",?43,"Payment",?58,"Payment",?72,"Balance"
 Q
MDY(BARD) ;  format Date from FM to MM/DD/YYYY
 N BARFMMM,BARFMDD,BARFMYY
 S BARFMMM=$E(BARD,4,5)
 S BARFMDD=$E(BARD,6,7)
 S BARFMYY=$E(BARD,1,3)+1700
 Q BARFMMM_"/"_BARFMDD_"/"_BARFMYY
 ;----------EOR--------------

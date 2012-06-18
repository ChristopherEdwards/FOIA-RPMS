BARRASMB ; IHS/SD/LSL - Age Summary Report Print Logic ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/ASDS/LSL - 11/24/03 - Routine created
 ;     Called from BARRASM
 ;     PRINT^BARRASMA - Print report
 ;     Split from BARRASMA in V1.7 Patch 4 as BARRASMA became too large
 ;
 ; IHS/SD/LSL - 02/20/03 - V1.7 Patch 1
 ;     Added DISCHARGE SERVICE sort and report.  Add time run to report
 ;     headers. (While still BARRASMA)
 ;
 ; IHS/SD/LSL - 08/01/03 - V1.7 Patch 2
 ;     Add call to ASM^BAREISS to print of summary data
 ;     (While still BARRASMA)
 ;
 ; IHS/SD/LSL - 11/24/03 - V1.7 Patch 4
 ;     Add Visit Location Sort level to accomodate EISS
 ;
 Q
 ; *********************************************************************
PRINT ; EP
 ; Print reports
 F I=1:1:6 K BAR(I)
 K BAR("SUB0")
 K BAR("SUB1"),BAR("SUB2"),BAR("SUB3"),BARTMP,BARTMPS,BARTMPS2,BARNAME
 S BAR("PG")=0
 S BARDASH="                    --------- --------- --------- --------- --------- ----------"
 S BAREQUAL="                    ========= ========= ========= ========= ========= =========="
 S BAR("COL")="W !,BARY(""STCR"",""NM""),?22,""CURRENT"",?34,""31-60"",?44,""61-90"",?53,""91-120"",?65,""120+"",?73,""BALANCE"""
 I ",1,2,3,4,"[(","_BARY("STCR")_",") D STANDARD
 Q:$G(BAR("F1"))
 I $G(BARY("RTYP"))=1 D SUMMARY
 Q:$G(BAR("F1"))
 I $G(BARY("RTYP"))=2 D DETAIL
 Q:$G(BAR("F1"))
 I $G(BARY("RTYP"))=3 D BILL
 Q:$G(BAR("F1"))
 Q
 ; *********************************************************************
 ;
STANDARD ;
 ; Print report if user selected SORT CRITERIA a/r account, visit, or
 ; clinic
 ;
 D HDB                                     ; Page and column header
 I '$D(^TMP($J,"BAR-ASM")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASM",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASM",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 . I BARHOLD("SUB0")'=BAR("SUB0") D HD
 . Q:$G(BAR("F1"))
 . S BARHOLD("SUB0")=BAR("SUB0")
 . I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 . S BAR("SUB1")=""
 . F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 . . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . . S BARTMP=$G(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")))
 . . S BARNAME=BAR("SUB1")
 . . W !,$E(BARNAME,1,19)            ; clinic/vis typ/A/R acct/discharge svc
 . . W ?20,$J($P(BARTMP,U),9,2)      ; CURRENT
 . . W ?30,$J($P(BARTMP,U,2),9,2)    ; 31-60
 . . W ?40,$J($P(BARTMP,U,3),9,2)    ; 61-90
 . . W ?50,$J($P(BARTMP,U,4),9,2)    ; 90-120
 . . W ?60,$J($P(BARTMP,U,5),9,2)    ; 120+
 . . W ?70,$J($P(BARTMP,U,6),10,2)   ; BALANCE
 . ;
 . ; Visit Location Totals
 . Q:$G(BAR("F1"))
 . W !,BARDASH
 . S BARTMP=$G(^TMP($J,"BAR-ASM",BAR("SUB0")))
 . W !,"*** VISIT loc Total"
 . W ?20,$J($P(BARTMP,U),9,2)      ; CURRENT
 . W ?30,$J($P(BARTMP,U,2),9,2)     ; 31-60
 . W ?40,$J($P(BARTMP,U,3),9,2)     ; 61-90
 . W ?50,$J($P(BARTMP,U,4),9,2)     ; 90-120
 . W ?60,$J($P(BARTMP,U,5),9,2)     ; 120+
 . W ?70,$J($P(BARTMP,U,6),10,2)    ; BALANCE
 Q:$G(BAR("F1"))
 ;
 ; Report Totals
 W !,BAREQUAL
 S BARTMP=$G(^TMP($J,"BAR-ASM"))
 W !?20,$J($P(BARTMP,U),9,2)       ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9,2)      ; 31-60
 W ?40,$J($P(BARTMP,U,3),9,2)      ; 61-90
 W ?50,$J($P(BARTMP,U,4),9,2)      ; 90-120
 W ?60,$J($P(BARTMP,U,5),9,2)      ; 120+
 W ?70,$J($P(BARTMP,U,6),10,2)     ; BALANCE
 Q
 ; *********************************************************************
 ;
SUMMARY ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type w/o payers
 ;
 D HDB                             ; Page and column header
 I '$D(^TMP($J,"BAR-ASMT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASMT",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 . I BAR("SUB0")'=BARHOLD("SUB0") D HD
 . Q:$G(BAR("F1"))
 . S BARHOLD("SUB0")=BAR("SUB0")
 . I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 . S BAR("SUB1")=""
 . F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 . . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . . S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1")))
 . . W !,$E(BAR("SUB1"),1,19)        ; Billing Entity/Allowance Category/Insurer Type
 . . D SUM2
 . Q:$G(BAR("F1"))
 . S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 . W !,BARDASH,!,"*** VISIT Loc Total"
 . D SUM2
 Q:$G(BAR("F1"))
 W !
 D TOTAL                           ; Report Totals
 I BARY("STCR")=5,'$D(BARY("ALL")) D ASM^BAREISS
 Q
 ; *********************************************************************
 ;
DETAIL ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers
 ;
 D HDB                               ; Page and column header
 I '$D(^TMP($J,"BAR-ASMT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASMT",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 . I BAR("SUB0")'=BARHOLD("SUB0") D HD
 . Q:$G(BAR("F1"))
 . S BARHOLD("SUB0")=BAR("SUB0")
 . I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 . S BAR("SUB1")=""
 . F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 . . S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1")))
 . . W !,$E(BAR("SUB1"),1,19)          ; Billing Entity/Allowance Category
 . . S BAR("SUB2")=""
 . . F  S BAR("SUB2")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"))) Q:BAR("SUB2")=""  D  Q:$G(BAR("F1"))
 . . . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . . . S BARTMPS=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2")))
 . . . W !?1,$E(BAR("SUB2"),1,18)      ; A/R Account
 . . . D ACCOUNT
 . . . Q:$G(BAR("F1"))
 . . Q:$G(BAR("F1"))
 . . W !,BARDASH,!
 . . I BARY("STCR")=5 W "ALLOW CAT TOTAL"
 . . I BARY("STCR")=6 W "BILL ENTITY TOTAL"
 . . I BARY("STCR")=7 W "INS TYPE TOTAL"
 . . D SUM2              ; Subtotals by Billing Entity/Allowance Category
 . Q:$G(BAR("F1"))
 . S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 . W !,BARDASH,!,"*** VISIT Loc Total"
 . D SUM2
 Q:$G(BAR("F1"))
 W !
 D TOTAL               ; Report Totals
 Q
 ; ********************************************************************
 ;
BILL ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers AND bills
 ;
 D HDB                                     ; Page and column header
 I '$D(^TMP($J,"BAR-ASMT")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASMT",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 . I BAR("SUB0")'=BARHOLD("SUB0") D HD
 . Q:$G(BAR("F1"))
 . S BARHOLD("SUB0")=BAR("SUB0")
 . I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 . S BAR("SUB1")=""
 . F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 . . S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1")))
 . . W $$EN^BARVDF("HIN")
 . . W !!,$$CJ^XLFSTR(BAR("SUB1"),IOM),!        ; Billing Entity/Allowance Category
 . . W $$EN^BARVDF("HIF")
 . . S BAR("SUB2")=""
 . . F  S BAR("SUB2")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"))) Q:BAR("SUB2")=""  D  Q:$G(BAR("F1"))
 . . . S BARTMPS=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2")))
 . . . W !?1,BAR("SUB2")      ; A/R Account
 . . . S BAR("SUB3")=""
 . . . F  S BAR("SUB3")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"),BAR("SUB3"))) Q:BAR("SUB3")=""  D  Q:$G(BAR("F1"))
 . . . . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . . . . S BARTMPS2=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"),BAR("SUB3")))
 . . . . W !?2,$E(BAR("SUB3"),1,17)
 . . . . W ?20,$J($P(BARTMPS2,U),9,2)     ; CURRENT
 . . . . W ?30,$J($P(BARTMPS2,U,2),9,2)    ; 31-60
 . . . . W ?40,$J($P(BARTMPS2,U,3),9,2)    ; 61-90
 . . . . W ?50,$J($P(BARTMPS2,U,4),9,2)    ; 90-120
 . . . . W ?60,$J($P(BARTMPS2,U,5),9,2)    ; 120+
 . . . . W ?70,$J($P(BARTMPS2,U,6),10,2)   ; BALANCE
 . . . Q:$G(BAR("F1"))
 . . . W !,BARDASH,!
 . . . W "A/R ACCOUNT TOTAL"
 . . . D ACCOUNT
 . . . W !
 . . Q:$G(BAR("F1"))
 . . W BARDASH,!
 . . I BARY("STCR")=5 W "ALLOW CAT TOTAL"
 . . I BARY("STCR")=6 W "BILL ENTITY TOTAL"
 . . I BARY("STCR")=7 W "INS TYPE TOTAL"
 . . D SUM2              ; Subtotals by Billing Entity/Allowance Category
 . Q:$G(BAR("F1"))
 . S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 . W !,BARDASH,!,"*** VISIT Loc Total"
 . D SUM2
 Q:$G(BAR("F1"))
 W !
 D TOTAL               ; Report Totals
 Q
 ; ********************************************************************
 ;
ACCOUNT ;
 ; Account line on Summary reports
 W ?20,$J($P(BARTMPS,U),9,2)     ; CURRENT
 W ?30,$J($P(BARTMPS,U,2),9,2)    ; 31-60
 W ?40,$J($P(BARTMPS,U,3),9,2)    ; 61-90
 W ?50,$J($P(BARTMPS,U,4),9,2)    ; 90-120
 W ?60,$J($P(BARTMPS,U,5),9,2)    ; 120+
 W ?70,$J($P(BARTMPS,U,6),10,2)   ; BALANCE
 Q
 ; ********************************************************************
 ;
SUM2 ;
 ; Billing Entity/Allowance Category Summary line
 W ?20,$J($P(BARTMP,U),9,2)      ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9,2)    ; 31-60
 W ?40,$J($P(BARTMP,U,3),9,2)    ; 61-90
 W ?50,$J($P(BARTMP,U,4),9,2)    ; 90-120
 W ?60,$J($P(BARTMP,U,5),9,2)    ; 120+
 W ?70,$J($P(BARTMP,U,6),10,2)   ; BALANCE
 Q
 ; ********************************************************************
 ;
TOTAL ;
 ; Report totals for Billing Entity/Allowance Category Reports
 W BAREQUAL
 S BARTMP=$G(^TMP($J,"BAR-ASMT"))
 W !?20,$J($P(BARTMP,U),9,2)       ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9,2)      ; 31-60
 W ?40,$J($P(BARTMP,U,3),9,2)      ; 61-90
 W ?50,$J($P(BARTMP,U,4),9,2)      ; 90-120
 W ?60,$J($P(BARTMP,U,5),9,2)      ; 120+
 W ?70,$J($P(BARTMP,U,6),10,2)     ; BALANCE
 Q
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
 S $P(BAR("DASH"),"=",$S($D(BAR(132)):132,1:80))=""
 W !,BAR("DASH"),!
 Q

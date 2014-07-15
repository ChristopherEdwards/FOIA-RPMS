BARRPSRA ; IHS/SD/PKD - New Period Summary Report ; 03/28/2011
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,6,7,21,23**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/SD/LSL - 02/20/03 - V1.7 Patch 1
 ;      Routine created to replace previous PSR
 ;
 ; IHS/SD/LSL - 08/01/03 - V1.7 Patch 2
 ;     Add Location IEN to Location level of summary data for EISS
 ; MAR 2013 P.OTTIS ADDED NEW VA billing
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R Variables
 S BARP("RTN")="BARRPSRA"             ; Routine used to gather data
 S BAR("PRIVACY")=1                  ; Privacy act applies (used BARRHD)
 S BAR("LOC")="VISIT"                ; PSR should always be VISIT
 D ASK^BARRASMA                      ; Ask all question (From ASM rtn)
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) D XIT Q
 D DATES                             ; Ask transaction date range
 I +BARSTART<1 D XIT Q               ; Dates answered wrong
 D SETHDR                            ; Build header array
 S BARQ("RC")="COMPUTE^BARRPSRA"      ; Build tmp global with data
 S BARQ("RP")="PRINT^BARRPSRB"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; *********************************************************************
 ;
DATES ;
 ; Ask beginning and ending Transaction Dates.
 W !!," ============ Entry of TRANSACTION DATE Range =============",!
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 S BAREND=$$DATE^BARDUTL(2)
 I BAREND<1 W ! G DATES
 I BAREND<BARSTART D  G DATES
 .W *7
 .W !!,"The END date must not be before the START date.",!
 S BARY("DT",1)=BARSTART
 S BARY("DT",2)=BAREND
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Build header array
 S BAR("OPT")="PSR"
 S BARY("DT")="T"
 S BAR("LVL")=0
 S BAR("HD",0)="Period Summary Report"
 I ",1,2,3,4,"[(","_BARY("STCR")_",") S BAR("HD",0)=BAR("HD",0)_" by "_BARY("STCR","NM")
 I BARY("STCR")=5 D ALLOW^BARRHD,CHK^BARRHD
 I BARY("STCR")=6 D BIL^BARRHD,CHK^BARRHD
 I BARY("STCR")=7 D ITYP^BARRHD,CHK^BARRHD
 I $G(BARY("RTYP"))=2 D
 . S BAR("LVL")=$G(BAR("LVL"))+1
 . S BAR("HD",BAR("LVL"))=""
 . S BAR("TXT")="PAYER"
 . S BAR("CONJ")="Sorted by "
 . D CHK^BARRHD
 I $G(BARY("RTYP"))=3 D
 . S BAR("TXT")="BILL w/in PAYER"
 . S BAR("CONJ")="Sorted by "
 . D CHK^BARRHD
 D DT^BARRHD
 S BAR("LVL")=$G(BAR("LVL"))+1
 S BAR("HD",BAR("LVL"))=""
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
 ; *********************************************************************
 ;
COMPUTE ; EP
 S BAR("SUBR")="BAR-PSR"
 K ^TMP($J,"BAR-PSR")
 K ^TMP($J,"BAR-PSRT")
 I BAR("LOC")="BILLING" D TRANS^BARRUTL Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D TRANS^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ; EP
 ; Gather data for transactions found in TRANS^BARRUTL
 ;
 ; BAR("SUB1") = Visit Location
 ; BAR("SUB2") = Clinic / visit type / A/R Account / Discharge Service
 ; BAR("SUB3") = Billing Entity / Allowance Category / insurer Type
 ; BAR("SUB4") = A/R Account
 ; BAR("SUB5") = A/R Bill
 ;
 ; BAR(1) = Billed Amount
 ;            Tran Type Bill New             (49) +
 ;            Tran Type Flat Rate Adjustment (503)
 ;            Tran Type Status Chg           (993)
 ; BAR(2) = Payment
 ;            Tran Type Payment              (40)
 ; BAR(3) = Adjustment
 ;            Adj Cat Copay                  (14) +
 ;            Adj Cat Deductible             (13) +
 ;            Adj Cat Grouper Allowance      (16) +
 ;            Adj Cat Non Payment            (4) +
 ;            Adj Cat Payment Credit         (20) +
 ;            Adj Cat Penalty                (15) +
 ;            Adj Cat Write-off              (3) +
 ;            Tran Status 3P Credit          (108)
 ;            Adj Cat Sent to Collections    (25)  ;HEAT30281 IHS/SD/PKD 1.8*21
 ; BAR(4) = Refund
 ;            Tran Type Refund (if tied to bill)   (39) +
 ;            Adj Cat Refund                 (19)
 ; -------------------------------
 ;
 F I=1:1:4 S BAR(I)=0
 F I=1:1:5 K BAR("SUB"_I)
 S BARP("HIT")=0
 D TRANS^BARRCHK
 Q:'BARP("HIT")
 S BARTR("ADJ CAT")=$P(BARTR(1),U,2)           ; Adjustment Category
 I ",3,4,13,14,15,16,19,20,25"'[(","_BARTR("ADJ CAT")_",")&(",40,49,39,108,503,993,"'[(","_BARTR("T")_",")) Q
 S:(BARTR("T")=49!(BARTR("T")=503)) BAR(1)=BARTR("CR-DB")
 S:BARTR("T")=40 BAR(2)=BARTR("CR-DB")
 ; IHS/SD/PKD bar*1.8*21 Add Sent to Collection to Adjustments HEAT30281
 S:(",3,4,13,14,15,16,20,25,"[(","_BARTR("ADJ CAT")_",")) BAR(3)=BARTR("CR-DB")
 S:BARTR("T")=108 BAR(3)=BARTR("CR-DB")
 S:(BARTR("T")=39!(BARTR("ADJ CAT")=19)) BAR(4)=BARTR("CR-DB")
 ;
 ; -------------------------------
 S BAR("SUB1")=$$GET1^DIQ(9999999.06,BARTR("L"),.01)
 S:BAR("SUB1")="" BAR("SUB1")="No Visit Location"
 I ",1,2,3,4,"[(","_BARY("STCR")_",") D  Q
 . I BARY("STCR")=1 D
 . . S BAR("SUB2")=BARTR("I")
 . . I BAR("SUB2")]"" S BAR("SUB2")=$$GET1^DIQ(90050.02,BAR("SUB2"),.01)
 . . I BAR("SUB2")="" S BAR("SUB2")="No A/R Account"
 . I BARY("STCR")=2 D
 . . S BAR("SUB2")=BAR("C")
 . . I BAR("SUB2")]"",BAR("SUB2")'=99999 S BAR("SUB2")=$$GET1^DIQ(40.7,BAR("SUB2"),.01)
 . . I BAR("SUB2")=""!(BAR("SUB2")=99999) S BAR("SUB2")="No Clinic Type"
 . I BARY("STCR")=3 D
 . . S BAR("SUB2")=BAR("V")
 . . I BAR("SUB2")]"",BAR("SUB2")'=99999 S BAR("SUB2")=$$GET1^DIQ(9002274.8,BAR("SUB2"),.01)
 . . I BAR("SUB2")=""!(BAR("SUB2")=99999) S BAR("SUB2")="No Visit Type"
 . I BARY("STCR")=4 D
 . . S BAR("SUB2")=BAR("DS")
 . . I BAR("SUB2")]"",BAR("SUB2")'=99999 S BAR("SUB2")=$$GET1^DIQ(45.7,BAR("SUB2"),.01)
 . . I BAR("SUB2")=""!(BAR("SUB2")=99999) S BAR("SUB2")="No Discharge Service"
 . D STANDARD
 I BARY("STCR")=5 D
 . S BAR("SUB3")="OTHER"
 . ;
 . I BARTR("ALL")="D" S BAR("SUB3")="MEDICAID"
 . I BARTR("ALL")="K" S BAR("SUB3")="MEDICAID"
 . I BARTR("ALL")="FPL" S BAR("SUB3")="MEDICAID"
 . ;
 . I BARTR("ALL")="R" S BAR("SUB3")="MEDICARE"
 . I BARTR("ALL")="MH" S BAR("SUB3")="MEDICARE"
 . I BARTR("ALL")="MD" S BAR("SUB3")="MEDICARE"
 . I BARTR("ALL")="MC" S BAR("SUB3")="MEDICARE"
 . I BARTR("ALL")="MCC" S BAR("SUB3")="MEDICARE"
 . ;
 . I BARTR("ALL")="H" S BAR("SUB3")="PRIVATE INSURANCE"
 . I BARTR("ALL")="M" S BAR("SUB3")="PRIVATE INSURANCE"
 . I BARTR("ALL")="P" S BAR("SUB3")="PRIVATE INSURANCE"
 . I BARTR("ALL")="F" S BAR("SUB3")="PRIVATE INSURANCE"
 . ;
 . I BARTR("ALL")="V" S BAR("SUB3")="VETERAN ADMINISTRATION"
 . ;
 I BARY("STCR")=6 D
 . I $L(BARTR("BI")) S BAR("SUB3")=$P($T(@BARTR("BI")),";;",2)  ;BAR*1.8*1 IM21585
 . I BAR("SUB3")="" S BAR("SUB3")=BARTR("BI")
 I BARY("STCR")=7 D
 . I $L(BARTR("BI")) S BAR("SUB3")=$P($T(@BARTR("BI")),";;",3)  ;BAR*1.8*1 IM21585
 . I BAR("SUB3")="" S BAR("SUB3")=BARTR("BI")
 S BAR("SUB4")=BARTR("I")
 I BAR("SUB4")]"" S BAR("SUB4")=$$GET1^DIQ(90050.02,BAR("SUB4"),.01)
 I BAR("SUB4")="" S BAR("SUB4")="No A/R Account"
 S BAR("SUB5")=$$GET1^DIQ(90050.01,BAR,.01)
 I $G(BARY("RTYP"))=2 D
 . D DETAIL
 I $G(BARY("RTYP"))=3 D
 . D BILL
 . D DETAIL
 D SUMMARY
 Q
 ; *********************************************************************
 ;
STANDARD ;
 ; Temp global for SORT CRITERIA Clinic or Visit or A/R Account
 ; or Discharge Service
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2")))
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2")),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1"),BAR("SUB2")),U,4)=$P(BARHLD,U,4)-BAR(4)
 ;
 ; Visit Location Totals
 S BARHLD=$G(^TMP($J,"BAR-PSR",BAR("SUB1")))
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1")),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSR",BAR("SUB1")),U,4)=$P(BARHLD,U,4)-BAR(4)
 ;
 ; Report Total
 S BARHLD=$G(^TMP($J,"BAR-PSR"))
 S $P(^TMP($J,"BAR-PSR"),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSR"),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSR"),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSR"),U,4)=$P(BARHLD,U,4)-BAR(4)
 Q
 ; *********************************************************************
 ;
SUMMARY ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize.
 ;
 ; Detail Lines
  S BARHLD=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")))
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3")),U,4)=$P(BARHLD,U,4)-BAR(4)
 ;
 ; Visit Location Totals
 S BARHLD=$G(^TMP($J,"BAR-PSRT",BAR("SUB1")))
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1")),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1")),U,4)=$P(BARHLD,U,4)-BAR(4)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1")),U,5)=BARTR("L")
 ;
 ; Report Total
 S BARHLD=$G(^TMP($J,"BAR-PSRT"))
 S $P(^TMP($J,"BAR-PSRT"),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSRT"),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSRT"),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSRT"),U,4)=$P(BARHLD,U,4)-BAR(4)
 Q
 ; *********************************************************************
 ;
DETAIL ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize by payor w/in.
 ;
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")))
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")),U,4)=$P(BARHLD,U,4)-BAR(4)
 Q
 ; *********************************************************************
 ;
BILL ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize by BILL w/in payor w/in.
 ;
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")))
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U)=$P(BARHLD,U)-BAR(1)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-PSRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U,4)=$P(BARHLD,U,4)-BAR(4)
 Q
 ; *********************************************************************
 ;
XIT ;
 D ^BARVKL0
 Q
 ; ********************************************************************
 ;THIS TABLE REPLICATES ^AUTTINTY INSURER TYPE (21 ENTRIES) P.OTT 4/12/2013
 ;AND MAPS INSURER TYPE CODE TO CATEGORY (IE: W --> OTHER)
H ;;PRIVATE INSURANCE;;HMO
M ;;PRIVATE INSURANCE;;MEDICARE SUPPL.
D ;;MEDICAID;;MEDICAID FI
R ;;MEDICARE;;MEDICARE FI
P ;;PRIVATE INSURANCE;;PRIVATE INSURANCE
W ;;OTHER;;WORKMEN'S COMP
C ;;OTHER;;CHAMPUS
N ;;OTHER;;NON-BENEFICIARY (NON-INDIAN)
I ;;OTHER;;INDIAN PATIENT
K ;;MEDICAID;;CHIP (KIDSCARE)
T ;;OTHER;;THIRD PARTY LIABILITY 
G ;;OTHER;;GUARANTOR
MD ;;MEDICARE;;MCR PART D
MH ;;MEDICARE;;MEDICARE HMO
MMC ;;MEDICARE;;MCR MANAGED CARE
TSI ;;OTHER;;TRIBAL SELF INSURED
SEP ;;OTHER;;STATE EXCHANGE PLAN
FPL ;;MEDICAID;;FPL 133 PERCENT
MC ;;MEDICARE;;MCR PART C
F ;;PRIVATE INSURANCE;;FRATERNAL ORGANIZATION
V ;;VETERAN;;VETERANS MEDICAL BENEFITS
  ;;***END OF TABLE** 

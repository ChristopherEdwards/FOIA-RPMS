BARRASM ; IHS/SD/LSL - Age Summary Report ; 09/15/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,6,7**;MAR 27,2007
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/ASDS/LSL - 02/27/02 - Routine created to replace BARRSAGE
 ;
 ; IHS/SD/LSL - 02/20/03 - V1.7 Patch 1
 ;     Modified to include report by Discharge Service
 ;     When sort by Clinic, make it alphabetical
 ;
 ; IHS/SD/LSL - 11/24/03 - V1.7 Patch 4
 ;     Add Visit Location Sort level to accomodate EISS
 Q
 ; *********************************************************************
EN ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R Variables
 S BARP("RTN")="BARRASM"             ; Routine used to gather data
 S BAR("PRIVACY")=1                  ; Privacy act applies (used BARRHD)
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D ASK^BARRASMA                      ; Ask all question
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 D SETHDR                            ; Build header array
 S BARQ("RC")="COMPUTE^BARRASM"      ; Build tmp global with data
 S BARQ("RP")="PRINT^BARRASMB"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; *********************************************************************
 ;
SETHDR ;
 ; Build header array
 S BAR("LVL")=0
 S BAR("HD",0)="Age Summary Report"
 I $D(BARP("UAGE")) S BAR("HD",0)="UFMS "_BAR("HD",0)_" for FY "_$P(BARP("UAGE"),U) ;MRS:BAR*1.8*7 TO131 REQ_2 
 I ",1,2,3,4,"[(","_BARY("STCR")_",") S BAR("HD",0)=BAR("HD",0)_" by "_BARY("STCR","NM")
 I BARY("STCR")=5 D ALLOW^BARRHD,CHK^BARRHD
 I BARY("STCR")=6 D BIL^BARRHD,CHK^BARRHD
 I BARY("STCR")=7 D ITYP^BARRHD,CHK^BARRHD
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
COMPUTE ;EP - CALLED FROM BARBIZ
 S BAR("SUBR")="BAR-ASM"
 K ^TMP($J,"BAR-ASM")
 K ^TMP($J,"BAR-ASMT")
 D NOW^%DTC
 S BARRUN=%
 I BAR("LOC")="BILLING" D LOOP^BARRUTL Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D LOOP^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ;
 ; Gather data for bills found in LOOP^BARRUTL
 ;
 ; BAR("SUB0") = Visit Location
 ; BAR("SUB1") = Clinic / visit type / A/R Account / Discharge Service
 ; BAR("SUB2") = Billing Entity / Allowance Category / Insurer Type
 ; BAR("SUB3") = A/R Account
 ; BAR("SUB4") = A/R Bill
 ;
 ; BAR(1) =  0-30 (Current)
 ; BAR(2) = 31-60
 ; BAR(3) = 61-90
 ; BAR(4) = 91-120
 ; BAR(5) = 120+
 ; BAR(6) = Account Balance
 ; -------------------------------
 ;
 F I=1:1:6 S BAR(I)=0
 K BAR("SUB0")
 K BAR("SUB1"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")
 S BARP("HIT")=0
 I $D(BARP("UAGE")) Q:'$$UAGE^BARRASM2(BAR)       ;MRS:BAR*1.8*7 TO131 REQ_2
 D BILL^BARRCHK
 Q:'BARP("HIT")
 S BAR(1)=$$GET1^DIQ(90050.01,BAR,7.3)
 S BAR(2)=$$GET1^DIQ(90050.01,BAR,7.4)
 S BAR(3)=$$GET1^DIQ(90050.01,BAR,7.5)
 S BAR(4)=$$GET1^DIQ(90050.01,BAR,7.6)
 S BAR(5)=$$GET1^DIQ(90050.01,BAR,7.7)
 S BAR(6)=$$GET1^DIQ(90050.01,BAR,15,"I")
 S BARRAGE=$$GET1^DIQ(90050.01,BAR,7.2)
 S ^BARASMD(BARRUN,BAR)=BAR(6)_U_BARRAGE_U_BAR("I")
 S BAR("SUB0")=$$GET1^DIQ(9999999.06,BAR("L"),.01)
 S:BAR("SUB0")="" BAR("SUB0")="No Visit Location"
 I ",1,2,3,4,"[(","_BARY("STCR")_",") D  Q
 . I BARY("STCR")=1 D
 . . S BAR("SUB1")=BAR("I")
 . . I BAR("SUB1")]"" S BAR("SUB1")=$$GET1^DIQ(90050.02,BAR("SUB1"),.01)
 . . I BAR("SUB1")="" S BAR("SUB1")="No A/R Account"
 . I BARY("STCR")=2 D
 . . S BAR("SUB1")=BAR("C")
 . . I BAR("SUB1")]"",BAR("SUB1")'=99999 S BAR("SUB1")=$$GET1^DIQ(40.7,BAR("SUB1"),.01)
 . . I BAR("SUB1")=""!(BAR("SUB1")=99999) S BAR("SUB1")="No Clinic Type"
 . I BARY("STCR")=3 D
 . . S BAR("SUB1")=BAR("V")
 . . I BAR("SUB1")]"",BAR("SUB1")'=99999 S BAR("SUB1")=$$GET1^DIQ(9002274.8,BAR("SUB1"),.01)
 . . I BAR("SUB1")=""!(BAR("SUB1")=99999) S BAR("SUB1")="No Visit Type"
 . I BARY("STCR")=4 D
 . . S BAR("SUB1")=BAR("DS")
 . . I BAR("SUB1")]"",BAR("SUB1")'=99999 S BAR("SUB1")=$$GET1^DIQ(45.7,BAR("SUB1"),.01)
 . . I BAR("SUB1")=""!(BAR("SUB1")=99999) S BAR("SUB1")="No Discharge Service"
 . D STANDARD
 I BARY("STCR")=5 D
 . S BAR("SUB2")="OTHER"
 . S:BAR("ALL")="D" BAR("SUB2")="MEDICAID"
 . S:BAR("ALL")="R" BAR("SUB2")="MEDICARE"
 . ;S:BAR("ALL")="K" BAR("SUB2")="CHIPS"  ;BAR*1.8*6 DD 4.1.1 IM21585
 . S:BAR("ALL")="P" BAR("SUB2")="PRIVATE INSURANCE"
 I BARY("STCR")=6 D
 . ;I $L(BAR("BI"))=1 S BAR("SUB2")=$P($T(@BAR("BI")),";;",2)
 . I $L(BAR("BI")) S BAR("SUB2")=$P($T(@BAR("BI")),";;",2)  ;BAR*1.8*1 IM21585
 . E  S BAR("SUB2")=BAR("BI")
 I BARY("STCR")=7 D
 . ;I $L(BAR("BI"))=1 S BAR("SUB2")=$P($T(@BAR("BI")),";;",3)
 . I $L(BAR("BI")) S BAR("SUB2")=$P($T(@BAR("BI")),";;",3)  ;BAR*1.8*1 IM21585
 . E  S BAR("SUB2")="No Insurer Type"
 S BAR("SUB3")=BAR("I")
 I BAR("SUB3")]"" S BAR("SUB3")=$$GET1^DIQ(90050.02,BAR("SUB3"),.01)
 I BAR("SUB3")="" S BAR("SUB3")="No A/R Account"
 S BAR("SUB4")=$$GET1^DIQ(90050.01,BAR,.01)
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
 S BARHLD=$G(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")))
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")),U,6)=$P(BARHLD,U,6)+BAR(6)
 ;
 ; Visit location totals
 S BARHLD=$G(^TMP($J,"BAR-ASM",BAR("SUB0")))
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0")),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0")),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0")),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASM",BAR("SUB0")),U,6)=$P(BARHLD,U,6)+BAR(6)
 ;
 ; Report Total
 S BARHLD=$G(^TMP($J,"BAR-ASM"))
 S $P(^TMP($J,"BAR-ASM"),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASM"),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASM"),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASM"),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASM"),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASM"),U,6)=$P(BARHLD,U,6)+BAR(6)
 Q
 ; *********************************************************************
 ;
SUMMARY ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize.
 ;
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")))
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2")),U,6)=$P(BARHLD,U,6)+BAR(6)
 ;
 ; Visit location totals
 S BARHLD=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U,6)=$P(BARHLD,U,6)+BAR(6)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0")),U,7)=BAR("L")   ; DUZ(2) value
 ;
 ; Report Total
 S BARHLD=$G(^TMP($J,"BAR-ASMT"))
 S $P(^TMP($J,"BAR-ASMT"),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASMT"),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASMT"),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASMT"),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASMT"),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASMT"),U,6)=$P(BARHLD,U,6)+BAR(6)
 Q
 ; *********************************************************************
 ;
DETAIL ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize by payor w/in.
 ;
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")))
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3")),U,6)=$P(BARHLD,U,6)+BAR(6)
 Q
 ; *********************************************************************
 ;
BILL ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize by bill w/in payer w/in all cat/bill ent
 ;
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")))
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")),U)=$P(BARHLD,U)+BAR(1)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB2"),BAR("SUB3"),BAR("SUB4")),U,6)=$P(BARHLD,U,6)+BAR(6)
 Q
 ; ********************************************************************
 ;
 ;IM20678 BAR*1.8*1 ADDED LINES FOR THIRD PARTY LIABILITY
 ;AND GUARANTOR
 ;IM21585 BAR*1.8*1 ADDED LINES FOR MEDICARE HMO
R ;;MEDICARE;;MEDICARE FI
D ;;MEDICAID;;MEDICAID FI
F ;;PRIVATE INSURANCE;;FRATERNAL ORGANIZATION
P ;;PRIVATE INSURANCE;;PRIVATE INSURANCE
H ;;PRIVATE INSURANCE;;HMO
M ;;PRIVATE INSURANCE;;MEDICARE SUPPL.
N ;;NON-BENEFICIARY PATIENTS;;NON-BENEFICIARY (NON-INDIAN)
I ;;BENEFICIARY PATIENTS;;INDIAN PATIENT
W ;;WORKMEN'S COMP;;WORKMEN'S COMP
C ;;CHAMPUS;;CHAMPUS
K ;;CHIP;;CHIP (KIDSCARE)
T ;;THIRD PARTY LIABILITY;;THIRD PARTY LIABILITY
G ;;GUARANTOR;;GUARANTOR
MD ;;MCR PART D;;MCR PART D
MH ;;MEDICARE HMO;;MEDICARE HMO

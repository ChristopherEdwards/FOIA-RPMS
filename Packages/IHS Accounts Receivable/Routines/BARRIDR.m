BARRIDR ; IHS/SD/LSL - Inpatient Primary Diagnosis Report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ITSC/SD/LSL - 03/17/03 - Routine created
 ;        New report
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 S BARP("RTN")="BARRIDR"
 S BAR("PRIVACY")=1                ; Privacy act applies
 D:'$D(BARUSR) INIT^BARUTL         ; Set A/R basic variable
 S BAR("LOC")="VISIT"              ; Always visit location
 D ^BARRSEL                        ; Select exclusion parameters
 I $D(BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 S BAR("HD",0)=BARMENU
 D ^BARRHD                         ; Report header
 S BARQ("RC")="COMPUTE^BARRIDR"    ; Compute routine
 S BARQ("RP")="PRINT^BARRIDR"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; *********************************************************************
 ;
COMPUTE ;
 ;
 S BAR("SUBR")="BAR-IDR"
 K ^TMP($J,"BAR-IDR")
 S BARP("RTN")="BARRIDR"     ; Routine used to get data if no parameters
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D LOOP^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ; EP
 ; Called by BARRUTL
 S BARDSCHG=$$GET1^DIQ(90050.01,BAR,23)
 Q:BARDSCHG=""                     ; Must have discharge service
 K BARDSCHG
 ;
 S BARP("HIT")=0
 D BILL^BARRCHK
 Q:'BARP("HIT")
 ;
 ; Visit location
 S BAR1=$$GET1^DIQ(9999999.06,BAR("L"),.01)
 ;
 ; Billing Entity/Allowance Category
 I $D(BARY("ALL")) D
 . S BAR2="OTHER"
 . ;S:BAR("ALL")="D" BAR2="MEDICAID"  ;BAR*1.8*6 DD 4.1.1
 . S:BAR("ALL")="D"!(BAR("ALL")="K") BAR2="MEDICAID"  ;BAR*1.8*6 DD 4.1.1
 . ;S:BAR("ALL")="R" BAR2="MEDICARE"  ;BAR*1.8*6 DD 4.1.1
 . S:BAR("ALL")="R"!(BAR("ALL")="MD")!(BAR("ALL")="MH") BAR2="MEDICARE"  ;BAR*1.8*6 DD 4.1.1
 . ;S:BAR("ALL")="K" BAR2="CHIP"  ;BAR*1.8*6 DD 4.1.1
 . ;S:BAR("ALL")="P" BAR2="PRIVATE INSURANCE"  ;BAR*1.8*6 DD 4.1.1
 . S:BAR("ALL")="P"!(BAR("ALL")="F")!(BAR("ALL")="M")!(BAR("ALL")="H")!(BAR("ALL")="T") BAR2="PRIVATE INSURANCE"  ;BAR*1.8*6 DD 4.1.1
 E  D
 . I $L(BAR("BI"))=1 S BAR2=$P($T(@BAR("BI")),";;",2)
 . E  S BAR2=BAR("BI")
 ;
 ; Discharge Service
 S BAR3=BAR("DS")
 I BAR("DS")]"",BAR("DS")'=99999 S BAR3=$$GET1^DIQ(45.7,BAR("DS"),.01)
 I BAR3=""!BAR3=99999 S BAR3="No Discharge Service"
 ;
 ; Covered days
 S BARCDAY=""
 S BAR3PLOC=$$FIND3PB^BARUTL(DUZ(2),BAR)
 I BAR3PLOC]"" D
 . S BAR3PDUZ=$P(BAR3PLOC,",")
 . S BAR3PIEN=$P(BAR3PLOC,",",2)
 . S BARCDAY=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,7)),U,3)
 S BARCDAY=+BARCDAY
 ;
 K BARBAMT,BARPAID,BARCOPAY,BARDED,BARADJ,BARCODED,BARADJ2
 S BARBAMT=$P($G(^BARBL(DUZ(2),BAR,0)),U,13)    ; Bill Amount
 S BARPAID=$$TRANS^BARDUTL(DUZ(2),BAR,"P")       ; All $ for pay trans
 S BARCOPAY=$$TRANS^BARDUTL(DUZ(2),BAR,"C")     ; All $ for copay trans
 S BARDED=$$TRANS^BARDUTL(DUZ(2),BAR,"D")       ; All $ for deduct tran
 S BARADJ=$$TRANS^BARDUTL(DUZ(2),BAR,"A")       ; All $ for adjust tran
 S BARCODED=BARCOPAY+BARDED
 S BARADJ2=BARADJ-BARCODED
 ;
 ; Detail data (by diagnosis)
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")))
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")),U)=$P(BARHOLD,U)+1
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")),U,2)=$P(BARHOLD,U,2)+BARCDAY
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")),U,3)=$P(BARHOLD,U,3)+BARBAMT
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")),U,4)=$P(BARHOLD,U,4)+BARPAID
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")),U,5)=$P(BARHOLD,U,5)+BARCODED
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3,BAR("DX")),U,6)=$P(BARHOLD,U,6)+BARADJ2
 ;
 ; Total by Discharge Service
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3))
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3),U)=$P(BARHOLD,U)+1
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3),U,2)=$P(BARHOLD,U,2)+BARCDAY
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3),U,3)=$P(BARHOLD,U,3)+BARBAMT
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3),U,4)=$P(BARHOLD,U,4)+BARPAID
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3),U,5)=$P(BARHOLD,U,5)+BARCODED
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2,BAR3),U,6)=$P(BARHOLD,U,6)+BARADJ2
 ;
 ; Total by Billing Entity/Allowance Category
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BAR1,BAR2))
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2),U)=$P(BARHOLD,U)+1
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2),U,2)=$P(BARHOLD,U,2)+BARCDAY
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2),U,3)=$P(BARHOLD,U,3)+BARBAMT
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2),U,4)=$P(BARHOLD,U,4)+BARPAID
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2),U,5)=$P(BARHOLD,U,5)+BARCODED
 S $P(^TMP($J,"BAR-IDR",BAR1,BAR2),U,6)=$P(BARHOLD,U,6)+BARADJ2
 ;
 ; Total by Visit Location
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BAR1))
 S $P(^TMP($J,"BAR-IDR",BAR1),U)=$P(BARHOLD,U)+1
 S $P(^TMP($J,"BAR-IDR",BAR1),U,2)=$P(BARHOLD,U,2)+BARCDAY
 S $P(^TMP($J,"BAR-IDR",BAR1),U,3)=$P(BARHOLD,U,3)+BARBAMT
 S $P(^TMP($J,"BAR-IDR",BAR1),U,4)=$P(BARHOLD,U,4)+BARPAID
 S $P(^TMP($J,"BAR-IDR",BAR1),U,5)=$P(BARHOLD,U,5)+BARCODED
 S $P(^TMP($J,"BAR-IDR",BAR1),U,6)=$P(BARHOLD,U,6)+BARADJ2
 ;
 ; Report Total
 S BARHOLD=$G(^TMP($J,"BAR-IDR"))
 S $P(^TMP($J,"BAR-IDR"),U)=$P(BARHOLD,U)+1
 S $P(^TMP($J,"BAR-IDR"),U,2)=$P(BARHOLD,U,2)+BARCDAY
 S $P(^TMP($J,"BAR-IDR"),U,3)=$P(BARHOLD,U,3)+BARBAMT
 S $P(^TMP($J,"BAR-IDR"),U,4)=$P(BARHOLD,U,4)+BARPAID
 S $P(^TMP($J,"BAR-IDR"),U,5)=$P(BARHOLD,U,5)+BARCODED
 S $P(^TMP($J,"BAR-IDR"),U,6)=$P(BARHOLD,U,6)+BARADJ2
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 ; Print
 K BAR1,BAR2,BAR3,BARHOLD,BARCDAY,BARBAMT,BARPAID,BARCODED,BARADJ
 K BARADJ2,BAR3PLOC,BAR3PIEN,BAR3PDUZ
 S BAR("PG")=0
 S BAR("COL1")="W !?18,""COVERED"",?31,""AMOUNT"",?45,""AMOUNT"",?56,""COPAYS/"""
 S BAR("COL2")="W !,""DIAGNOSIS BILLS"",?19,""DAYS"",?31,""BILLED"""
 S BAR("COL2")=BAR("COL2")_",?46,""PAID"",?54,""DEDUCTIBLES"",?69,""ADJUSTMENTS"""
 S BARDASH="         -----  -------  ------------  ------------  ------------  ------------"
 S BAREQUAL="         =====  =======  ============  ============  ============  ============"
 ;
 D HDB
 I '$D(^TMP($J,"BAR-IDR")) D  Q
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 ;
 S BARL=""
 F  S BARL=$O(^TMP($J,"BAR-IDR",BARL)) Q:BARL=""  D LOC  Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
LOC ;
 ; For each location do...
 W !,"VISIT LOCATION:  ",BARL
 S BAR2=""
 F  S BAR2=$O(^TMP($J,"BAR-IDR",BARL,BAR2)) Q:BAR2=""  D ALLBI  Q:$G(BAR("F1"))
 D LOCTOT
 Q
 ; ********************************************************************
 ;
ALLBI ;
 ; For each Billing entity / Allowance Category do...
 I $D(BARY("ALL")) W !?3,"ALLOWANCE CATEGORY:  "
 E  W !?3,"BILLING ENTITY:  "
 W BAR2
 S BARDS=""
 F  S BARDS=$O(^TMP($J,"BAR-IDR",BARL,BAR2,BARDS)) Q:BARDS=""  D DSCH Q:$G(BAR("F1"))
 D ALLBITOT
 Q
 ; ********************************************************************
 ;
DSCH ;
 ; For each Discharge Service do...
 W !?6,"DISCHARGE SERVICE:  ",BARDS,!
 S BARDX=""
 F  S BARDX=$O(^TMP($J,"BAR-IDR",BARL,BAR2,BARDS,BARDX)) Q:BARDX=""  D DX Q:$G(BAR("F1"))
 D DSCHTOT
 Q
 ; ********************************************************************
 ;
DX ;
 ; For each Diagnosis do...
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BARL,BAR2,BARDS,BARDX))
 W !?1,$E(BARDX,1,6)                       ; Diagnosis
 D STNDLINE
 Q
 ; ********************************************************************
 ;
STNDLINE ;
 ; Write standard line
 W ?9,$J($P(BARHOLD,U),5)                 ; Bill Count
 W ?16,$J($P(BARHOLD,U,2),7)              ; Covered Days
 W ?25,$J($FN($P(BARHOLD,U,3),",",2),12)   ; Billed Amount
 W ?39,$J($FN($P(BARHOLD,U,4),",",2),12)   ; Paid Amount
 W ?53,$J($FN($P(BARHOLD,U,5),",",2),12)   ; co-pay/deductible Amount
 W ?67,$J($FN($P(BARHOLD,U,6),",",2),12)   ; Adjustment Amount
 Q
 ;
DSCHTOT ;
 ; Discharge service subtotal
 W !,BARDASH
 W !,"   *DSVC"
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BARL,BAR2,BARDS))
 D STNDLINE
 W !
 Q
 ; ********************************************************************
 ;
ALLBITOT ;
 ; Billing Entity / Allowance Category subtotal
 W BARDASH
 I $D(BARY("ALL")) W !,"  **ALLOW"
 E  W !,"  **BILL"
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BARL,BAR2))
 D STNDLINE
 W !
 Q
 ; ********************************************************************
 ;
LOCTOT ;
 ; Location subtotal
 W BARDASH
 W !," ***V LOC"
 S BARHOLD=$G(^TMP($J,"BAR-IDR",BARL))
 D STNDLINE
 W !
 Q
 ; ********************************************************************
 ;
TOTAL ;
 ; Report Total
 W BAREQUAL
 W !,"****TOTAL"
 S BARHOLD=$G(^TMP($J,"BAR-IDR"))
 D STNDLINE
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
 X BAR("COL1")
 X BAR("COL2")
 S $P(BAR("DASH"),"=",$S($D(BAR(133)):132,1:81))=""
 W !,BAR("DASH"),!
 Q
 ; ********************************************************************
 ;
R ;;MEDICARE
D ;;MEDICAID
F ;;PRIVATE INSURANCE
P ;;PRIVATE INSURANCE
H ;;PRIVATE INSURANCE
M ;;PRIVATE INSURANCE
N ;;NON-BENEFICIARY PATIENTS
I ;;BENEFICIARY PATIENTS
W ;;WORKMEN'S COMP
C ;;CHAMPUS
K ;;CHIP

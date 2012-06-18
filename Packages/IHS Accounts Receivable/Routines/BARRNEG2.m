BARRNEG2 ; IHS/SD/LSL - Print Large Balance Report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7**;OCT 26, 2005
 ;
 ; IHS/SD/SDR - V1.8 p6 - DD 4.1.3
 ;       Routine created.  New reports
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ********************************************************************
 Q
 ;
NEGB ;EP
 ; Print Negative Balance Report
 ;
 S BAR("PG")=0
 S BAR("COL")="W !,""BILL NUMBER"",?14,""DOS"",?22,""DT BILLED"""
 S BAR("COL")=BAR("COL")_",?32,""BILLED AMT"",?45,""PYMTS"",?56,""ADJS"",?68,""BALANCE"""
 S BARDASH="W ?32,""-----------------------------------------------"""
 S BAREQUAL="W ?32,""==============================================="""
 ;
 D HDB^BARRPSRB
 I '$D(^TMP($J,"BAR-NEG")) D  Q
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARL=""
 F  S BARL=$O(^TMP($J,"BAR-NEG",BARL)) Q:BARL=""  D LOC  Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
LOC ; For each visit location
 W !,"VISIT LOCATION:  ",BARL
 D ALLCAT
 D LOCTOT
 Q
ALLCAT ;
 S BARALLC=""
 F  S BARALLC=$O(^TMP($J,"BAR-NEG",BARL,BARALLC)) Q:BARALLC=""  D
 .W !,"ALLOWANCE CATEGORY:  ",BARALLC
 .I $D(BARY("SORT")) D CLINVIS
 .I '$D(BARY("SORT")) D STND
 .D ALLCTOT
 Q
 ; ********************************************************************
CLINVIS ; For Clinic / Visit Type Sort
 S BAR2=""
 F  S BAR2=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2)) Q:BAR2=""  D CVLOOP  Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
CVLOOP ;
 ; For Each Clinic / Visit type
 I BARY("SORT")="C" W !?3,"CLINIC:  ",BAR2
 E  W !?3,"VISIT TYPE:  ",BAR2
 S BARACT=""
 F  S BARACT=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2,BARACT)) Q:BARACT=""  D CVACCT  Q:$G(BAR("F1"))
 D CVTOT
 Q
 ; ********************************************************************
CVACCT ;
 ; For Each CV AR Account
 W !?6,"A/R ACCOUNT:  ",BARACT,!
 S BAR3P=0
 F  S BAR3P=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2,BARACT,BAR3P)) Q:'+BAR3P  D CVAPPR  Q:$G(BAR("F1"))
 D CVACTOT
 Q
 ; ********************************************************************
CVAPPR ;
 ; For each CV 3P Approval Date
 S BARBL=""
 F  S BARBL=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2,BARACT,BAR3P,BARBL)) Q:BARBL=""  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 . S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2,BARACT,BAR3P,BARBL))
 . D STNDLINE
 Q
 ; ********************************************************************
CVACTOT ;
 ; CV AR Account Total
 W !
 X BARDASH
 W !?1,"AR Account Subtotal ($):"
 S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2,BARACT))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
CVTOT ;
 ; Clinic / Visit type total
 X BARDASH
 I BARY("SORT")="C" W !?5,"Clinic Subtotal ($):"
 E  W !?1,"Visit Type Subtotal ($):"
 S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL,BARALLC,BAR2))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
STND ;
 ; For not Clinic / Visit Type Sort
 S BARACT=""
 F  S BARACT=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BARACT)) Q:BARACT=""  D ACCT  Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
ACCT ;
 ; For each AR Account
 W !?3,"A/R ACCOUNT:  ",BARACT,!
 S BAR3P=0
 F  S BAR3P=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BARACT,BAR3P)) Q:'+BAR3P  D APPR  Q:$G(BAR("F1"))
 D ACTOT
 Q
 ; ********************************************************************
APPR ;
 ; For each 3P Approval Date
 S BARBL=""
 F  S BARBL=$O(^TMP($J,"BAR-NEG",BARL,BARALLC,BARACT,BAR3P,BARBL)) Q:BARBL=""  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 . S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL,BARALLC,BARACT,BAR3P,BARBL))
 . D STNDLINE
 Q
 ; ********************************************************************
STNDLINE ;
 ; Write Data line
 W !,$P(BARBL,"-")                         ; AR Bill
 W ?12,$$SHDT^BARDUTL($P(BARHOLD,U))         ; DOS Begin
 W ?22,$$SHDT^BARDUTL(BAR3P)                 ; 3P Approval Date
 W ?31,$J($FN($P(BARHOLD,U,2),",",2),11)    ; Billed Amount
 W ?43,$J($FN($P(BARHOLD,U,3),",",2),10)     ; Summary of payments
 W ?54,$J($FN($P(BARHOLD,U,4),",",2),10)     ; Summary of adjustments
 W ?68,$J($FN($P(BARHOLD,U,5),",",2),11)    ; Balance on Bill
 Q
 ; ********************************************************************
ACTOT ;
 ; AR Account Total
 W !
 X BARDASH
 W !?1,"AR Account Subtotal ($):"
 S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL,BARALLC,BARACT))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
ALLCTOT ;
 ; Allowance Category total
 X BARDASH
 W !?2,"All. Cat. Subtotal ($):"
 S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL,BARALLC))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
LOCTOT ;
 ; Visit Location total
 X BARDASH
 W !?2,"Visit Loc Subtotal ($):"
 S BARHOLD=$G(^TMP($J,"BAR-NEG",BARL))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
TOTAL ;
 ; Report total
 X BAREQUAL
 W !?7,"Report Total ($):"
 S BARHOLD=$G(^TMP($J,"BAR-NEG"))
 D STNDTOT
 Q
 ; ********************************************************************
STNDTOT ;
 ; Write total lines
 W ?31,$J($FN($P(BARHOLD,U,2),",",2),11)          ; Billed Amount
 W ?43,$J($FN($P(BARHOLD,U,3),",",2),10)          ; Summary of pymts
 W ?54,$J($FN($P(BARHOLD,U,4),",",2),10)          ; Summary of adjs
 W ?68,$J($FN($P(BARHOLD,U,5),",",2),11)          ; Balance on Bill
 Q

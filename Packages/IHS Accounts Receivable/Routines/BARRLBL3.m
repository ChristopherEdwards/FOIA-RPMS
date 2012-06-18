BARRLBL3 ; IHS/SD/LSL - Print Small Balance Report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/04/2003 - Version 1.8
 ;       Routine created.  New reports
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ********************************************************************
 Q
 ;
SMALL ;EP
 ; Print Small Balance Report
 ;
 S BAR("PG")=0
 S BAR("COL")="W !,""BILL NUMBER"",?23,""DOS"",?32,""DATE BILLED"""
 S BAR("COL")=BAR("COL")_",?48,""BILLED AMT"",?66,""BALANCE"",?75,""AGE"""
 S BARDASH="W ?45,""-------------  -------------  ----"""
 S BAREQUAL="W ?45,""=============  =============  ===="""
 ;
 D HDB^BARRPSRB
 I '$D(^TMP($J,"BAR-LBL")) D  Q
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARL=""
 F  S BARL=$O(^TMP($J,"BAR-LBL",BARL)) Q:BARL=""  D LOC  Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
LOC ;
 ; For each visit location
 W !,"VISIT LOCATION:  ",BARL
 I $D(BARY("SORT")) D CLINVIS
 I '$D(BARY("SORT")) D STND
 D LOCTOT
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
CLINVIS ;
 ; For Clinic / Visit Type Sort
 S BAR2=""
 F  S BAR2=$O(^TMP($J,"BAR-LBL",BARL,BAR2)) Q:BAR2=""  D CVLOOP  Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
 ;
CVLOOP ;
 ; For Each Clinic / Visit type
 I BARY("SORT")="C" W !?3,"CLINIC:  ",BAR2
 E  W !?3,"VISIT TYPE:  ",BAR2
 S BARACT=""
 F  S BARACT=$O(^TMP($J,"BAR-LBL",BARL,BAR2,BARACT)) Q:BARACT=""  D CVACCT  Q:$G(BAR("F1"))
 D CVTOT
 Q
 ; ********************************************************************
 ;
CVACCT ;
 ; For Each CV AR Account
 W !?6,"A/R ACCOUNT:  ",BARACT,!
 S BAR3P=0
 F  S BAR3P=$O(^TMP($J,"BAR-LBL",BARL,BAR2,BARACT,BAR3P)) Q:'+BAR3P  D CVAPPR  Q:$G(BAR("F1"))
 D CVACTOT
 Q
 ; ********************************************************************
 ;
CVAPPR ;
 ; For each CV 3P Approval Date
 S BARBL=""
 F  S BARBL=$O(^TMP($J,"BAR-LBL",BARL,BAR2,BARACT,BAR3P,BARBL)) Q:BARBL=""  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 . S BARHOLD=$G(^TMP($J,"BAR-LBL",BARL,BAR2,BARACT,BAR3P,BARBL))
 . D STNDLINE
 Q
 ; ********************************************************************
 ;
CVACTOT ;
 ; CV AR Account Total
 W !
 X BARDASH
 W !?6,"AR Account Subotal ($) and Average (#):"
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARL,BAR2,BARACT))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
 ;
CVTOT ;
 ; Clinic / Visit type total
 X BARDASH
 I BARY("SORT")="C" W !?9,"Clinic Subtotal ($) and Average (#):"
 E  W !?5,"Visit Type Subtotal ($) and Average (#):"
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARL,BAR2))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
 ; ********************************************************************
STND ;
 ; For not Clinic / Visit Type Sort
 S BARACT=""
 F  S BARACT=$O(^TMP($J,"BAR-LBL",BARL,BARACT)) Q:BARACT=""  D ACCT  Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
 ;
ACCT ;
 ; For each AR Account
 W !?3,"A/R ACCOUNT:  ",BARACT,!
 S BAR3P=0
 F  S BAR3P=$O(^TMP($J,"BAR-LBL",BARL,BARACT,BAR3P)) Q:'+BAR3P  D APPR  Q:$G(BAR("F1"))
 D ACTOT
 Q
 ; ********************************************************************
 ;
APPR ;
 ; For each 3P Approval Date
 S BARBL=""
 F  S BARBL=$O(^TMP($J,"BAR-LBL",BARL,BARACT,BAR3P,BARBL)) Q:BARBL=""  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 . S BARHOLD=$G(^TMP($J,"BAR-LBL",BARL,BARACT,BAR3P,BARBL))
 . D STNDLINE
 Q
 ; ********************************************************************
 ;
STNDLINE ;
 ; Write Data line
 W !,$E(BARBL,1,18)                         ; AR Bill
 W ?20,$$SDT^BARDUTL($P(BARHOLD,U))         ; DOS Begin
 W ?33,$$SDT^BARDUTL(BAR3P)                 ; 3P Approval Date
 W ?45,$J($FN($P(BARHOLD,U,3),",",2),13)    ; Billed Amount
 W ?60,$J($FN($P(BARHOLD,U,4),",",2),13)    ; Balance on Bill
 W ?75,$J($P(BARHOLD,U,5),4)                ; Days since 3P Approved
 Q
 ; ********************************************************************
 ;
ACTOT ;
 ; AR Account Total
 W !
 X BARDASH
 W !?6,"AR Account Subotal ($) and Average (#):"
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARL,BARACT))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
 ;
LOCTOT ;
 ; Visit Location total
 X BARDASH
 W !?7,"Visit Loc Subotal ($) and Average (#):"
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARL))
 D STNDTOT
 W !
 Q
 ; ********************************************************************
 ;
TOTAL ;
 ; Report total
 X BAREQUAL
 W !?12,"Report Total ($) and Average (#):"
 S BARHOLD=$G(^TMP($J,"BAR-LBL"))
 D STNDTOT
 Q
 ; ********************************************************************
 ;
STNDTOT ;
 ; Write total lines
 W ?45,$J($FN($P(BARHOLD,U,2),",",2),13)        ; Billed Amount
 W ?60,$J($FN($P(BARHOLD,U,3),",",2),13)        ; Balance on Bill
 W ?75,$J(($P(BARHOLD,U,4)/$P(BARHOLD,U,5)),4,0)  ; Days since 3P Approve
 Q

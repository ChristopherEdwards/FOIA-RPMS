BARRTAR3 ; IHS/SD/LSL - Transaction report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,7**;MAR 27,2007
 ;
 ; IHS/ASDS/LSL - 10/06/00 - Routine created
 ;     Summary print of Transaction report
 ;
 ; IHS/SD/LSL - 07/10/02 - V1/6 Patch 2
 ;     Modified to print missing clinics and missing visit types
 ;
 ; IHS/SD/LSL - 10/24/02 - V1.7 - PAB-1002-90130
 ;      Modified to accomodate DUZ(2) subscript
 ;      
 ;      IHS/SD/RTL - 5/23/05 - V1.8 Patch 1 - IM17362
 ;         TAR report bombing - missing collection batch
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892     
 Q
 ; *********************************************************************
 ;
SUMM ; EP
 S BAR("COL")="W !,""A/R Account"",?15,""PAY-AMT"",?26,""PRV-CRD"",?37,""REFUND"",?48,""PAYMENT"",?59,""BILL AMT"",?70,""ADJUSTMENT"""
 S BAR("HD",0)="SUMMARY Transaction"_$P(BAR("HD",0),"Transaction",2,99)
 D HDB^BARRTAR2
 S BARDASH="               ---------- ---------- ---------- ---------- ---------- ----------"
 S BAREQUAL="               ========== ========== ========== ========== ========== =========="
 S (BAR("0TOTA"),BAR("0TOTB"),BAR("0TOTC"),BAR("0TOTD"),BAR("0TOTE"),BAR("0TOTF"))=0
 S (BAR("OL"),BAR("OB"),BAR("OIT"),BAR("OS"))=""
 I '$D(^TMP($J,"BAR-TARS")) D  Q
 . W !!!,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 S (BAR("AR"),BAR("OAR"))=""
 F  S BAR("AR")=$O(^TMP($J,"BAR-TARS",BAR("AR"))) Q:BAR("AR")']""!($G(BAR("F1")))  D
 . I +BAR("AR") W !!,"A/R Entry Clerk: ",$P(^VA(200,BAR("AR"),0),U)
 . S BAR("DUZ")=0
 . F  S BAR("DUZ")=$O(^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"))) Q:'+BAR("DUZ")!($G(BAR("F1")))  D
 . . S (BAR("L"),BAR("OL"))=""
 . . F  S BAR("L")=$O(^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"),BAR("L"))) Q:BAR("L")=""!($G(BAR("F1")))  D LOC
 Q:$G(BAR("F1"))
 W !,BAREQUAL
 W !,"REPORT TOTAL"
 W ?15,$J($FN(BAR("0TOTA"),",",2),10)
 W ?26,$J($FN(BAR("0TOTB"),",",2),10)
 W ?37,$J($FN(BAR("0TOTC"),",",2),10)
 W ?48,$J($FN(BAR("0TOTD"),",",2),10)
  W ?59,$J($FN(BAR("0TOTE"),",",2),10)
  W ?70,$J($FN(BAR("0TOTF"),",",2),10)
 Q
 ; *********************************************************************
 ;
LOC ;
 S BAR("B")=""
 F  S BAR("B")=$O(^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("B"))) Q:BAR("B")=""!($G(BAR("F1")))  D BATCH
 Q:$G(BAR("F1"))
 W !,BARDASH
 W !,"Location Tot:"
 W ?15,$J($FN(BAR("1TOTA"),",",2),10)
 W ?26,$J($FN(BAR("1TOTB"),",",2),10)
 W ?37,$J($FN(BAR("1TOTC"),",",2),10)
 W ?48,$J($FN(BAR("1TOTD"),",",2),10)
 W ?59,$J($FN(BAR("1TOTE"),",",2),10)
 W ?70,$J($FN(BAR("1TOTF"),",",2),10)
 Q
 ; *********************************************************************
 ;
BATCH ;
 S BAR("IT")=""
 F  S BAR("IT")=$O(^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("B"),BAR("IT"))) Q:BAR("IT")=""!($G(BAR("F1")))  D ITEM
 Q:$G(BAR("F1"))
 W !,BARDASH
 W !,"   Batch Tot:"
 W ?15,$J($FN(BAR("2TOTA"),",",2),10)
 W ?26,$J($FN(BAR("2TOTB"),",",2),10)
 W ?37,$J($FN(BAR("2TOTC"),",",2),10)
 W ?48,$J($FN(BAR("2TOTD"),",",2),10)
 W ?59,$J($FN(BAR("2TOTE"),",",2),10)
 W ?70,$J($FN(BAR("2TOTF"),",",2),10)
 Q
 ; *********************************************************************
 ;
ITEM ;
 S BAR("S")=""
 F  S BAR("S")=$O(^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("B"),BAR("IT"),BAR("S"))) Q:BAR("S")=""!($G(BAR("F1")))  D SORT
 Q:$G(BAR("F1"))
 W !,BARDASH
 W !,"    Item Tot:"
 W ?15,$J($FN(BAR("3TOTA"),",",2),10)
 W ?26,$J($FN(BAR("3TOTB"),",",2),10)
 W ?37,$J($FN(BAR("3TOTC"),",",2),10)
 W ?48,$J($FN(BAR("3TOTD"),",",2),10)
 W ?59,$J($FN(BAR("3TOTE"),",",2),10)
 W ?70,$J($FN(BAR("3TOTF"),",",2),10)
 Q
 ; *********************************************************************
 ;
SORT ;
 S BAR("ACCT")=""
 F  S BAR("ACCT")=$O(^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("B"),BAR("IT"),BAR("S"),BAR("ACCT"))) Q:BAR("ACCT")=""!($G(BAR("F1")))  D ACCT
 Q:$G(BAR("F1"))
 W !,BARDASH
 I BARY("SORT")="C" W !,"  Clinic Tot:"
 E  W !,"   Visit Tot:"
 W ?15,$J($FN(BAR("4TOTA"),",",2),10)
 W ?26,$J($FN(BAR("4TOTB"),",",2),10)
 W ?37,$J($FN(BAR("4TOTC"),",",2),10)
 W ?48,$J($FN(BAR("4TOTD"),",",2),10)
 W ?59,$J($FN(BAR("4TOTE"),",",2),10)
 W ?70,$J($FN(BAR("4TOTF"),",",2),10)
 Q
 ; *********************************************************************
 ;
ACCT ;
 Q:$G(BAR("F1"))
 I $Y>(IOSL-5) D HD^BARRTAR2 Q:$G(BAR("F1"))
 I BAR("OL")'=BAR("L") W ! D HD1 W !
 E  I BAR("OB")'=BAR("B") W ! D HD2 W !
 E  I BAR("OIT")'=BAR("IT") W ! D HD3 W !
 E  I BAR("OS")'=BAR("S") W ! D HD4 W !
 S BAR("DATA")=^TMP($J,"BAR-TARS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("B"),BAR("IT"),BAR("S"),BAR("ACCT"))
 W !,$E(BAR("ACCT"),1,14)                     ; A/R Account
 W ?15,$J($FN($P(BAR("DATA"),U,2),",",2),10)  ; Pay Amt
 W ?26,$J($FN($P(BAR("DATA"),U,3),",",2),10)  ; Prev Credit
 W ?37,$J($FN($P(BAR("DATA"),U,4),",",2),10)  ; Refunds
 W ?48,$J($FN($P(BAR("DATA"),U,5),",",2),10)  ; payment
 W ?59,$J($FN($P(BAR("DATA"),U,6),",",2),10)  ; bill amt
 W ?70,$J($FN($P(BAR("DATA"),U,7),",",2),10)  ; adjustments
 F I=0:1:4 D                                  ; Accumulate totals
 . S Y=1
 . F X="TOTA","TOTB","TOTC","TOTD","TOTE","TOTF" D
 . . S Y=Y+1
 . . S BARV=I_X
 . . S BARV2="BAR("""_BARV_""")"
 . . S @BARV2=@BARV2+$P(BAR("DATA"),U,Y)
 K I,X,Y
 Q
 ; *********************************************************************
 ;
HD1 ;     
 W !?10,"Visit Location.......: ",BAR("L")
 S BAR("OL")=BAR("L")
 S (BAR("1TOTA"),BAR("1TOTB"),BAR("1TOTC"),BAR("1TOTD"),BAR("1TOTE"),BAR("1TOTF"))=0
 D HD2
 Q
 ; *********************************************************************
 ;
HD2 ;     
 W !?10,"Collection Batch.....: "
 ;I +BAR("B") W $P(^BARCOL(DUZ(2),BAR("B"),0),U)
 I +BAR("B"),$P($G(^BARCOL(DUZ(2),BAR("B"),0)),U)'="" D
 .W $P(^BARCOL(DUZ(2),BAR("B"),0),U)  ;IM17362
 E  W BAR("B")
 S BAR("OB")=BAR("B")
 S (BAR("2TOTA"),BAR("2TOTB"),BAR("2TOTC"),BAR("2TOTD"),BAR("2TOTE"),BAR("2TOTF"))=0
 D HD3
 Q
 ; *********************************************************************
 ;
HD3 ;     
 W !?10,"Collection Batch Item: ",BAR("IT")
 S BAR("OIT")=BAR("IT")
 S (BAR("3TOTA"),BAR("3TOTB"),BAR("3TOTC"),BAR("3TOTD"),BAR("3TOTE"),BAR("3TOTF"))=0
 D HD4
 Q
 ; *********************************************************************
 ;
HD4 ;
 W !?10
 I BARY("SORT")="C" D
 . W "Clinic Type..........: "
 . I BAR("S")=99999 W "NO CLINIC" Q
 . W $P(^DIC(40.7,BAR("S"),0),U)
 I BARY("SORT")="V" D
 . W "Visit Type...........: "
 . I BAR("S")=99999 W "NO VISIT TYPE" Q
 . W $P(^ABMDVTYP(BAR("S"),0),U)
 S BAR("OS")=BAR("S")
 S (BAR("4TOTA"),BAR("4TOTB"),BAR("4TOTC"),BAR("4TOTD"),BAR("4TOTE"),BAR("4TOTF"))=0
 Q

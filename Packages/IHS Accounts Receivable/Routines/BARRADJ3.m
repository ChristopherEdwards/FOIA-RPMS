BARRADJ3 ; IHS/SD/LSL - TRANSACTION/ADJUSTMENT REPORT ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7**;MAY 26, 2008
 Q
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; *********************************************************************
SUMM ; EP
 S BAR("COL")="W !,?57,""Amount"",?68,""Transaction"""
 S BAR("COL",0)="W !?33,""Bill Count"",?57,""Billed"",?71,""Amount"""
 S BAR("HD",0)="SUMMARY Transaction"_$P(BAR("HD",0),"Transaction",2,99)
 D HDB^BARRADJ2
 S BARDASH="---------- ----------"
 S BAREQUAL="========== =========="
 ;
 ;INITIALIZE TOTALS
 K VLOCBTOT,TRANBTOT,ADJTBTOT,SORTBTOT,ARBTOT
 K VLOCTTOT,TRANTTOT,ADJTTTOT,SORTTTOT,ARTTOT
 ;
 ;
 S GRANBILL=0  ;BILL AMT GRAND TOT
 S GRANTRAN=0  ;TRANS AMT GRAND TOT
 I '$D(^TMP($J,"BAR-TSRS")) D  Q
 . W $$CJ^XLFSTR("*** NO DATA TO PRINT FOR "_$P($G(^DIC(4,DUZ(2),0)),U)_" ***",IOM)
 . D EOP^BARUTL(0)
 S (BAR("AR"),BAR("OAR"))=""
 F  S BAR("AR")=$O(^TMP($J,"BAR-TSRS",BAR("AR"))) Q:BAR("AR")']""!($G(BAR("F1")))  D
 . I +BAR("AR") W !!,"A/R Entry Clerk: ",$P(^VA(200,BAR("AR"),0),U)
 . S BAR("DUZ")=0
 . F  S BAR("DUZ")=$O(^TMP($J,"BAR-TSRS",BAR("AR"),BAR("DUZ"))) Q:'+BAR("DUZ")!($G(BAR("F1")))  D
 . . S (BAR("L"),BAR("OL"))=""
 . . F  S BAR("L")=$O(^TMP($J,"BAR-TSRS",BAR("AR"),BAR("DUZ"),BAR("L"))) Q:BAR("L")=""!($G(BAR("F1")))  D TRANS
 Q:$G(BAR("F1"))
 W !?52,BAREQUAL
 W !,"REPORT TOTAL"
 W ?52,$J($FN(GRANBILL,",",2),10)
 W ?67,$J($FN(GRANTRAN,",",2),10)
 Q
 ; *********************************************************************
 ;
TRANS ;
 S BAR("ADJCAT")="NOT USED"
 S BAR("TRANS")=""
 F  S BAR("TRANS")=$O(^TMP($J,"BAR-TSRS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("ADJCAT"),BAR("TRANS"))) Q:BAR("TRANS")=""!($G(BAR("F1")))  D SORT
 Q:$G(BAR("F1"))
 W !,?52,BARDASH
 W !,"Transaction Tot:"
 W ?52,$J($FN($P(BAR("DATA"),U,6),",",2),10)  ; bill amt
 S TRANAMT=$P(BAR("DATA"),U,2)+$P(BAR("DATA"),U,3)+$P(BAR("DATA"),U,4)+$P(BAR("DATA"),U,5)+$P(BAR("DATA"),U,7)
 W ?67,$J($FN($P(TRANSAMT,U,7),",",2),10)  ; adjustments
 Q
 ; *********************************************************************
 ;
SORT ;
 S BAR("SORT")=""
 F  S BAR("SORT")=$O(^TMP($J,"BAR-TSRS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("TRANS"),BAR("ADJCAT"),BAR("SORT"))) Q:BAR("SORT")=""!($G(BAR("F1")))  D
 .Q:$G(BAR("F1"))
 .W !?52,BARDASH
 .S SORTBTOT=$G(SORTBTOT)+$P(BAR("DATA"),U,6)
 .S TRANAMT=$P(BAR("DATA"),U,2)+$P(BAR("DATA"),U,3)+$P(BAR("DATA"),U,4)+$P(BAR("DATA"),U,5)+$P(BAR("DATA"),U,7)
 .S SORTTTOT=$G(SORTTTOT)+TRANAMT
 I BARY("SORT")="C" W !,"  Clinic Tot:"
 E  W !,"   Visit Tot:"
 ;W ?15,$J($FN(BAR("4TOTA"),",",2),10)
 ;W ?26,$J($FN(BAR("4TOTB"),",",2),10)
 ;W ?37,$J($FN(BAR("4TOTC"),",",2),10)
 ;W ?48,$J($FN(BAR("4TOTD"),",",2),10)
 W ?52,$J($FN(SORTBTOT,",",2),10)  ; bill amt
 W ?67,$J($FN(SORTTTOT,",",2),10)  ; adjustments
 Q
 ; *********************************************************************
 ;
ACCT ;
 Q:$G(BAR("F1"))
 I $Y>(IOSL-5) D HD^BARRADJ2 Q:$G(BAR("F1"))
 I BAR("OL")'=BAR("L") W ! D HD1 W !
 E  I BAR("OTRANS")'=BAR("TRANS") W ! D HD2 W !
 E  I BAR("OADJCAT")'=BAR("ADJCAT") W ! D HD3 W !
 E  I BAR("OSORT")'=BAR("SSORT") W ! D HD4 W !
 S BAR("DATA")=^TMP($J,"BAR-TSRS",BAR("AR"),BAR("DUZ"),BAR("L"),BAR("TRANS"),BAR("ADJCAT"),BAR("SORT"))
 ;W ?15,$J($FN($P(BAR("DATA"),U,2),",",2),10)  ; Pay Amt
 ;W ?26,$J($FN($P(BAR("DATA"),U,3),",",2),10)  ; Prev Credit
 ;W ?37,$J($FN($P(BAR("DATA"),U,4),",",2),10)  ; Refunds
 ;W ?48,$J($FN($P(BAR("DATA"),U,5),",",2),10)  ; payment
 ;W ?38,BAR("4TOTG")
 W ?52,$J($FN($P(BAR("DATA"),U,6),",",2),10)  ; bill amt
 S TRANAMT=$P(BAR("DATA"),U,2)+$P(BAR("DATA"),U,3)+$P(BAR("DATA"),U,4)+$P(BAR("DATA"),U,5)+$P(BAR("DATA"),U,7)
 W ?67,$J($FN($P(BAR("DATA"),U,7),",",2),10)  ; adjustments
 F I=0:1:4 D                                ; Accumulate totals
 . S Y=1
 . F X="TOTA","TOTB","TOTC","TOTD","TOTE","TOTF","TOTG" D
 . . S Y=Y+1
 . . S BARV=I_X
 . . S BARV2="BAR("""_BARV_""")"
 . . S @BARV2=@BARV2+$P(BAR("DATA"),U,Y)
 . . I X="TOTG" S @BARV2=@BARV2+1
 K I,X,Y
 S BAR("0TOTH")=BAR("0TOTH")+BAR("0TOTG")
 Q
 ; *********************************************************************
 ;
HD1 ;     
 W !?10,"Visit Location.......: ",BAR("L")
 S BAR("OL")=BAR("L")
 S (BAR("1TOTA"),BAR("1TOTB"),BAR("1TOTC"),BAR("1TOTD"),BAR("1TOTE"),BAR("1TOTF"),BAR("1TOTG"))=0
 D HD2
 Q
 ; *********************************************************************
 ;
HD2 ;     
 W !?10,"Transaction Type.....: "
 I +BAR("B"),$P($G(^BARCOL(DUZ(2),BAR("TRANS"),0)),U)'="" D
 .W $P(^BARCOL(DUZ(2),BAR("TRANS"),0),U)  ;IM17362
 E  W BAR("B")
 S BAR("OTRANS")=BAR("TRANS")
 S (BAR("2TOTA"),BAR("2TOTB"),BAR("2TOTC"),BAR("2TOTD"),BAR("2TOTE"),BAR("2TOTF"),BAR("2TOTG"))=0
 D HD3
 Q
 ; *********************************************************************
 ;
HD3 ;     
 W !?10,"Collection Batch Item: ",BAR("IT")
 S BAR("OIT")=BAR("IT")
 S (BAR("3TOTA"),BAR("3TOTB"),BAR("3TOTC"),BAR("3TOTD"),BAR("3TOTE"),BAR("3TOTF"),BAR("3TOTG"))=0
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
 . W $P($G(^ABMDVTYP(BAR("S"),0)),U)
 S BAR("OSORT")=BAR("SORT")
 S (BAR("4TOTA"),BAR("4TOTB"),BAR("4TOTC"),BAR("4TOTD"),BAR("4TOTE"),BAR("4TOTF"),BAR("4TOTG"))=0
 Q

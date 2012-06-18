BARRPRP2 ; IHS/SD/LSL - Payment Summary Report by Collection Batch ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/SD/LSL - 04/18/03 - V1.8
 ;      Routine created
 Q
 ; *********************************************************************
PRINT ;
 D SETHDR
 I '$D(^TMP($J,"BAR-PRP")) D  Q           ; No data - quit
 . D HDB^BARRPSRB
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 D:+BARASK PRTCV
 D:'+BARASK PRTDET
 Q:$G(BAR("F1"))
 D PRTBATCH
 K ^TMP($J,"BAR-PRP")
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Build header array
 S BAR("PG")=0
 S BAR("OPT")="PRP"
 S BARY("DT")="T"
 S BAR("LVL")=0
 S BAR("HD",0)="PAYMENT SUMMARY REPORT"
 ;
 I $D(BARY("ITYP")) D
 . S BAR("LVL")=BAR("LVL")+1
 . S BAR("HD",BAR("LVL"))="FOR INSURER TYPE:  "_BARY("ITYP","NM")
 I $D(BARY("COLPT")) D
 . S BAR("LVL")=BAR("LVL")+1
 . S BAR("HD",BAR("LVL"))="FOR COLLECTION POINT:  "_BARY("COLPT","NM")
 ;
 S BAR("LVL")=BAR("LVL")+1
 S BAR("HD",BAR("LVL"))="BATCH DATES OF "
 S BAR("HD",BAR("LVL"))=BAR("HD",BAR("LVL"))_$$SDT^BARDUTL(BARSTART)
 S BAR("HD",BAR("LVL"))=BAR("HD",BAR("LVL"))_" TO "
 S BAR("HD",BAR("LVL"))=BAR("HD",BAR("LVL"))_$$SDT^BARDUTL(BAREND)
 ;
 S BAR("LVL")=BAR("LVL")+1
 S BAR("HD",BAR("LVL"))="BATCHED AMOUNT:  $"_$J($FN($P($G(BARBTOT),U),",",2),15)
 ;
 S BAR("COL")="W !?2,""MONTH"",?16,""# BILLS"",?26,""BILLED AMOUNT"",?48,""PAYMENTS"""
 S BARDASH="W ?18,""----"",?24,""---------------"",?41,""---------------"""
 S BAREQUAL="W !?18,""===="",?24,""==============="",?41,""==============="""
 K BARTOT
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRTCV ;
 ; Print Report sorted by Clinic/Visit Type
 D HDB^BARRPSRB
 S BARVIS=""
 F  S BARVIS=$O(^TMP($J,"BAR-PRP",BARVIS)) Q:BARVIS=""  D LOCCV  Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
LOCCV ;
 ; For each visit location do  (clinic/visit type)
 K BARLTOT
 W !,"VISIT LOCATION:  ",BARVIS
 S BARS=""
 F  S BARS=$O(^TMP($J,"BAR-PRP",BARVIS,BARS)) Q:BARS=""  D SORTCV Q:$G(BAR("F1"))
 D LOCTOT
 Q
 ; ********************************************************************
 ;
SORTCV ;
 ; For each clinic/visit type do...
 K BARCVTOT
 W:BARY("SORT")="C" !?3,"CLINIC: ",BARS,!
 W:BARY("SORT")="V" !?3,"VISIT TYPE: ",BARS,!
 S BARDOS=0
 F  S BARDOS=$O(^TMP($J,"BAR-PRP",BARVIS,BARS,BARDOS)) Q:'+BARDOS  D  Q:$G(BAR("F1"))
 . S BARHOLD=$G(^TMP($J,"BAR-PRP",BARVIS,BARS,BARDOS))
 . D DETAIL
 . D GETOTCV
 . D GETOT
 W !
 X BARDASH
 W:BARY("SORT")="C" !?5,"CLINIC TOTAL"
 W:BARY("SORT")="V" !?1,"VISIT TYPE TOTAL"
 W ?18,$J($P(BARCVTOT,U),4)
 W ?24,$J($FN($P(BARCVTOT,U,2),",",2),15)
 W ?41,$J($FN($P(BARCVTOT,U,3),",",2),15)
 W !
 Q
 ; ********************************************************************
 ;
DETAIL ;
 ; Detail line
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 S Y=BARDOS
 D DD^%DT
 W !?2,Y                                       ; DOS (Month/year)
 W ?18,$J($P(BARHOLD,U),4)                     ; Bill count
 W ?24,$J($FN($P(BARHOLD,U,2),",",2),15)       ; Billed Amount
 W ?41,$J($FN($P(BARHOLD,U,3),",",2),15)       ; Paid Amount
 Q
 ; ********************************************************************
 ;
GETOTCV ;
 ; Get clinic/visit subtotal
 S $P(BARCVTOT,U)=$P($G(BARCVTOT),U)+$P(BARHOLD,U)
 S $P(BARCVTOT,U,2)=$P($G(BARCVTOT),U,2)+$P(BARHOLD,U,2)
 S $P(BARCVTOT,U,3)=$P($G(BARCVTOT),U,3)+$P(BARHOLD,U,3)
 Q
 ; ********************************************************************
 ;
GETOT ;
 ; Get visit location subtotal
 S $P(BARLTOT,U)=$P($G(BARLTOT),U)+$P(BARHOLD,U)
 S $P(BARLTOT,U,2)=$P($G(BARLTOT),U,2)+$P(BARHOLD,U,2)
 S $P(BARLTOT,U,3)=$P($G(BARLTOT),U,3)+$P(BARHOLD,U,3)
 ; Get report total
 S $P(BARTOT,U)=$P($G(BARTOT),U)+$P(BARHOLD,U)
 S $P(BARTOT,U,2)=$P($G(BARTOT),U,2)+$P(BARHOLD,U,2)
 S $P(BARTOT,U,3)=$P($G(BARTOT),U,3)+$P(BARHOLD,U,3)
 Q
 ; ********************************************************************
 ;
LOCTOT ;
 I '+BARASK W !
 X BARDASH
 W !?2,"VISIT LOC TOTAL"
 W ?18,$J($P(BARLTOT,U),4)
 W ?24,$J($FN($P(BARLTOT,U,2),",",2),15)
 W ?41,$J($FN($P(BARLTOT,U,3),",",2),15)
 Q
 ; ********************************************************************
 ;
TOTAL ;
 X BAREQUAL
 W !?5,"REPORT TOTAL"
 W ?18,$J($P(BARTOT,U),4)
 W ?24,$J($FN($P(BARTOT,U,2),",",2),15)
 W ?41,$J($FN($P(BARTOT,U,3),",",2),15)
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRTDET ;
 ; Print Detail Report
 D HDB^BARRPSRB
 S BARVIS=""
 F  S BARVIS=$O(^TMP($J,"BAR-PRP",BARVIS)) Q:BARVIS=""  D LOC  Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
LOC ;
 ; For each visit location do  (clinic/visit type)
 K BARLTOT
 W !,"VISIT LOCATION:  ",BARVIS,!
 S BARDOS=0
 F  S BARDOS=$O(^TMP($J,"BAR-PRP",BARVIS,BARDOS)) Q:'+BARDOS  D  Q:$G(BAR("F1"))
 . S BARHOLD=$G(^TMP($J,"BAR-PRP",BARVIS,BARDOS))
 . D DETAIL
 . D GETOT
 D LOCTOT
 Q
 ; ********************************************************************
 ;
PRTBATCH ;
 ; Print batch listing at end of report
 D PAZ^BARRUTL
 Q:$G(BAR("F1"))
 S BAREQUAL="W !?31,""==============="",?47,""==============="",?63,""==============="""
 S BATHDR="               ** BATCH LISTING **"
 S BARLVL=$O(BAR("HD",99),-1)
 S BAR("HD",BARLVL)=BAR("HD",BARLVL)_BATHDR
 S BAR("COL")="W !,""COLLECTION BATCHES"",?32,""BATCHED AMOUNT"",?49,""POSTED AMOUNT"",?63,""UNPOSTED AMOUNT"""
 D HDB^BARRPSRB
 S BARBNAME=""
 F  S BARBNAME=$O(BARB(BARBNAME)) Q:BARBNAME=""  D BATCHDET Q:$G(BAR("F1"))
 X BAREQUAL
 W !?20,"TOTALS"
 W ?31,$J($FN($P(BARBTOT,U),",",2),15)
 W ?47,$J($FN($P(BARBTOT,U,2),",",2),15)
 W ?63,$J($FN($P(BARBTOT,U,3),",",2),15)
 Q
 ; ********************************************************************
 ;
BATCHDET ;
 ; Write batch detail lines
 S BARHOLD=$G(BARB(BARBNAME))
 W !,$E(BARBNAME,1,30)
 W ?31,$J($FN($P(BARHOLD,U),",",2),15)
 W ?47,$J($FN($P(BARHOLD,U,2),",",2),15)
 W ?63,$J($FN($P(BARHOLD,U,3),",",2),15)
 Q

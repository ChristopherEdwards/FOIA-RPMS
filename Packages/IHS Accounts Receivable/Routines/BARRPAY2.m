BARRPAY2   ; IHS/SD/PKD - TOP PAYERS REPORT ; 07/2/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ; Print:  called from BARRPAY
 ; New Reports - Top Payers - PKD 
 Q
 ; *******************************
PRINT ; EP   - 
 ; Need to resort ^TMP($J,"BAR-PAY" by Amount Paid
 S BAR("COL")="W !,"_"""A/R ACCOUNT                      TX CNT        AMOUNT PD           ALLOWABLE"""
 K ^TMP($J,"BAR-PAYS")  ; Sort into this
 K SUBTOT
 N ALLOW,AMT,ARACCT,CNT,DATA,LOC,LOCNM,PAYER,TMP,SUBTOT
SORT  ; sort by high paid amts
 ;"ARACT" ,LOC , PAYER)= COUNT ^ AMOUNT ^ ALLOWED AMT 
 S LOC="" F  S LOC=$O(^TMP($J,"BAR-PAY","ARACT",LOC)) Q:'LOC  D  ;
 . S ARACCT="" F  S ARACCT=$O(^TMP($J,"BAR-PAY","ARACT",LOC,ARACCT),1,TMP) Q:'ARACCT  D  ; TMP contains DATA
 . . S BARACX=$P(^BARAC(DUZ(2),ARACCT,0),U)  ; ADDED LINE
 . . S PAYER=$P(^AUTNINS(+BARACX,0),U,1)_U_ARACCT  ; allow for dupl names
 . . S LOCNM=$P(^BAR(90052.05,DUZ(2),LOC,0),U,4)
 . . S CNT=$P(TMP,U),AMT=$P(TMP,U,2),ALLOW=$P(TMP,U,3)
 . . S ^TMP($J,"BAR-PAYS",-AMT,LOCNM,PAYER)=CNT_U_ALLOW  ;
SUBSORT  ; Sort by Visit Location & Additional Requested sort
 ;  . S ^TMP($J,"BAR-PAY",BARTAG,VISITLOC,SORT(1),BARPAYER)=TMP
  S BARTAG="" F  S BARTAG=$O(^TMP($J,"BAR-PAY",BARTAG)) Q:BARTAG=""  D  Q:$G(BAR("F1"))
 . S LOC="" F  S LOC=$O(^TMP($J,"BAR-PAY",BARTAG,LOC)) Q:'LOC  D  Q:$G(BAR("F1"))
 . . S SORT(1)=""  F  S SORT(1)=$O(^TMP($J,"BAR-PAY",BARTAG,LOC,SORT(1))) Q:SORT(1)=""  D  Q:$G(BAR("F1"))
 . . . S ARACCT="" F  S ARACCT=$O(^TMP($J,"BAR-PAY",BARTAG,LOC,SORT(1),ARACCT),1,DATA) Q:ARACCT=""  D  Q:$G(BAR("F1"))  ;
 . . . . S BARACX=$P(^BARAC(DUZ(2),ARACCT,0),U)
 . . . . S CNT=$P(DATA,U),AMT=$P(DATA,U,2),ALLOW=$P(DATA,U,3)
 . . . . S PAYER=$P(^AUTNINS(+BARACX,0),U,1)_U_ARACCT  ; allow for dupl names
 . . . . S LOCNM=$P(^BAR(90052.05,DUZ(2),LOC,0),U,4)
 . . . . S ^TMP($J,"BAR-PAYS1",SORT(1),-AMT,LOCNM,PAYER)=CNT_U_ALLOW
 S BAR("PG")=0
 D HDB^BARRPSRB
 ;
 N LIMIT,AMT
 I $D(SUBNM) D PRTSBTL
 K SUBTOT  Q:$G(BAR("F1"))
GRTOT S AMT="" F LIMIT=1:1:BAR("NBR TO PRINT") S AMT=$O(^TMP($J,"BAR-PAYS",AMT)) Q:AMT=""  D  Q:$G(BAR("F1"))
 . S LOCNM="" F  S LOCNM=$O(^TMP($J,"BAR-PAYS",AMT,LOCNM)) Q:LOCNM=""  D  Q:$G(BAR("F1"))
 . . S PAYER="" F  S PAYER=$O(^TMP($J,"BAR-PAYS",AMT,LOCNM,PAYER),1,DATA) Q:PAYER=""  D  Q:$G(BAR("F1"))
 . . . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 . . . W !,$P(PAYER,U),?32,$J($P(DATA,U),7),?40,$J($FN(-AMT,",",2),16),?59,$J($FN($P(DATA,U,2),",",2),16)  ; strips off the AUTIN IEN
 . . . I $I(SUBTOT("CNT"),$P(DATA,U))  ; Increment totals
 . . . I $I(SUBTOT("AMT"),-AMT)
 . . . I $I(SUBTOT("ALLOW"),$P(DATA,U,2))
 . . . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 Q:$G(BAR("F1"))
 I $D(SUBTOT) D
 . W !!,"GRAND TOTALS",?33,$J($FN($G(SUBTOT("CNT")),","),6)
 . W ?40,$J($FN($G(SUBTOT("AMT")),",",2),16),?59,$J($FN($G(SUBTOT("ALLOW")),",",2),16),!!
 E  W !!!,"Nothing to report",!!!
 D PAZ^BARRUTL
 Q
PRTSBTL  ;
 N SUBTOTG  ; Grand Totals
 S SORT(1)="" F  S SORT(1)=$O(^TMP($J,"BAR-PAYS1",SORT(1))) Q:SORT(1)=""  D  D SORTSUB Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 . W !,?10,SUBNM,SORT(1)
 . S AMT=""  F LIMIT=1:1:BAR("NBR TO PRINT") S AMT=$O(^TMP($J,"BAR-PAYS1",SORT(1),AMT)) Q:AMT=""  D  Q:$G(BAR("F1"))
 . . S VLOC=""  S VLOC=$O(^TMP($J,"BAR-PAYS1",SORT(1),AMT,VLOC)) Q:VLOC=""  D  Q:$G(BAR("F1"))
 . . . S PAYER="" F  S PAYER=$O(^TMP($J,"BAR-PAYS1",SORT(1),AMT,VLOC,PAYER),1,DATA) Q:PAYER=""  D  Q:$G(BAR("F1"))
 . . . . W !,$P(PAYER,U),?32,$J($FN($P(DATA,U),","),7),?40,$J($FN(-AMT,",",2),16),?59,$J($FN($P(DATA,U,2),",",2),16)  ; strips off the IEN of Payer
 . . . . I $I(SUBTOT("CNT"),$P(DATA,U)),$I(SUBTOTG("GRCNT"),$P(DATA,U))  ; $Increment totals- Rpt Sort & Grand
 . . . . I $I(SUBTOT("AMT"),-AMT),$I(SUBTOTG("GRAMT"),-AMT)
 . . . . I $I(SUBTOT("ALLOW"),$P(DATA,U,2)),$I(SUBTOTG("GRALLOW"),$P(DATA,U,2))
 . . . . I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 Q:$G(BAR("F1"))
 I $D(SUBTOTG) D
 . W !!,"TOTALS",?33,$J($FN($G(SUBTOTG("GRCNT")),","),6)
 . W ?40,$J($FN($G(SUBTOTG("GRAMT")),",",2),16),?59,$J($FN($G(SUBTOTG("GRALLOW")),",",2),16),!!
 D PAZ^BARRUTL I $Y>(IOSL-5) D HDB^BARRPSRB
  Q
 ; 
SORTSUB  ;
 Q:'$D(SUBTOT)
 W !,?5,"SUB-TOTALS",?33,$J($FN($G(SUBTOT("CNT")),","),6),?40,$J($FN($G(SUBTOT("AMT")),",",2),16),?59,$J($FN($G(SUBTOT("ALLOW")),",",2),16),!
 K SUBTOT
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 Q

BARRPTD2 ; IHS/SD/pkd - Payment Summary Report by TDN or Date Range ;06/09/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ; 
 ; IHS/SD/PKD - 6/9/10 - V1.8*19 based on BARRPRP* routines
 ;      Routine created
 Q
 ; *********************************************************************
PRINT ;
 S BAR(132)=1,BAR(133)=1  ; Width of printing parameters ;pkd
 N LOC S LOC=$O(^TMP($J,"BAR-PTD"))
 I LOC="" S LOC=DUZ(2)  ; Need LOC for Headers 
 I BARTEXT&($D(^TMP($J,"BAR-PTD"))) D FILEHDR I 1
 E  D SETHDR
 I '$D(^TMP($J,"BAR-PTD")) D  Q           ; No data - quit
 . S IOM=132 D HDB^BARRPSRB
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D PAZ^BARRUTL S QUIT='Y  ;pause
 D DETAIL
 Q:$G(BAR("F1"))
 K ^TMP($J,"BAR-PTD")
 ;
 N TP S TP="C IO(0)" X TP
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Build header array
 I BARTEXT&($D(^TMP($J,"BAR-PTD"))) D FILEHDR Q
 S BAR("PG")=0,BAR(133)=1  ; char / line
 S BAR("OPT")="TDN"
 S BARY("DT")="T"
 S BAR("LVL")=0
 S BAR("HD",0)="PAYMENT SUMMARY REPORT BY TDN       "
 ;
 I BARSRT=1 D  ; 1= Batch Range entered
 . S BAR("LVL")=BAR("LVL")+1
 . S BAR("HD",BAR("LVL"))="Batch Dates:  "_$$SDT^BARDUTL(BARSTART)_" to "_$$SDT^BARDUTL(BAREND)
 I BARSRT=2 D  ; 2 = TDN (1 or more) entered
 . S BAR("LVL")=BAR("LVL")+1
 . S BAR("HD",BAR("LVL"))="FOR TDNs As Entered  "
 I $G(LOC) S DUZ(2)=LOC  ; if >1 location being processed
 S BAR("HD",BAR("LVL"))=BAR("HD",BAR("LVL"))_"                      "_"LOCATION: "_$P(^BAR(90052.05,DUZ(2),LOC,0),U,4)
 ;
 S BAR("LVL")=BAR("LVL")+1
 S BAR("HD",BAR("LVL"))="BATCHED AMOUNT:  $"_$J($FN($P($G(^TMP($J,"BAR-PTD")),U,2),",",2),15)
 ;
 S BAR("COL")="W !,""TREASURY DEPOSIT     COLLECTION"",?55,""BATCHED    POSTED      TRUE      REFUND     TRANSFER    UNPOSTED"""
 S BAR("COL")=BAR("COL")_",!,""    NUMBER           BATCH"",?55,""AMOUNT     AMOUNT      UNALL     AMOUNT      AMOUNT      AMOUNT  """
 S BARDASH="W ?22,""----"",?53,""----------"",?64,""----------"""
 Q
 ; ********************************************************************
FILEHDR  ; output to file?
 Q:$G(FILEHDR)  S FILEHDR=1  ; Output headers only once
 ; File Output Header
 N TP S TP="O IO U IO" X TP
 S HDR="LOCATION^TDN^COLLECTION BATCH NAME^BATCHED AMOUNT^POSTED AMOUNT"
 S HDR=HDR_"^TRUE UNALLOCATED^REFUND AMOUNT^TRANSFER AMOUNT^UNPOSTED AMOUNT"
 W !,HDR
 Q
 ;**********************************************
DETAIL  ; Print per LOCATION
 S LOC="" F  S LOC=$O(^TMP($J,"BAR-PTD",LOC)) Q:'LOC  D  Q:$G(QUIT)
 . S LOCANAME=$P(^BAR(90052.05,DUZ(2),LOC,0),U,4)
 . D SETHDR  ; Get new Location Name
 . D:BARSRT=1 DTDET
 . D:BARSRT=2 TDNDET
 . D LOCTOT
 D TOTAL  ; Grand Totals
 Q
 ;
DTDET  ;
 ; Print Report - subTotals on Date Change
 ; 				  Location Change
 ; 				  SORT1 = DATE  SORT2 = TDN
 I 'BARTEXT D HDB^BARRPSRB
 S SORT1=""
 F  S SORT1=$O(^TMP($J,"BAR-PTD",LOC,SORT1)) Q:SORT1=""  D  Q:$G(QUIT)
 . S SORT2="" F  S SORT2=$O(^TMP($J,"BAR-PTD",LOC,SORT1,SORT2)) Q:SORT2=""  D  Q:$G(QUIT)
 . . S BATCH="" F TCT=0:1 S BATCH=$O(^TMP($J,"BAR-PTD",LOC,SORT1,SORT2,BATCH)) Q:BATCH=""  D  Q:$G(QUIT)
 . . . D DETLN
 . . I TCT>1 D TDNSUB  ; I >1 COLLECTION BATCH/TDN, print subtotal for TDN
 Q
 ; ********************************************************************
TDNDET  ; 
 ; Print Report - SORT1 - TDN  SORT2 DT
 I 'BARTEXT D HDB^BARRPSRB
 S SORT1=""  F  S SORT1=$O(^TMP($J,"BAR-PTD",LOC,SORT1)) Q:SORT1=""  D  Q:$G(QUIT)
 . S SORT2="" F  S SORT2=$O(^TMP($J,"BAR-PTD",LOC,SORT1,SORT2)) Q:SORT2=""  D  Q:$G(QUIT)
 . . S BATCH="" F TCT=0:1 S BATCH=$O(^TMP($J,"BAR-PTD",LOC,SORT1,SORT2,BATCH)) Q:BATCH=""  D  Q:$G(QUIT)
 . . . D DETLN
 . . I TCT>1 D TDNSUB  ; I >1 COLLECTION BATCH/TDN, print subtotal for TDN
 Q
TDNSUB ; print TDN subtotal
 Q
 ;
DETLN  ;  Same output for DATE RANGE or LIST OF TDN'S
 N PC
 S LINE=^TMP($J,"BAR-PTD",LOC,SORT1,SORT2,BATCH)
 ;S Y=$P(SORT2,".",1) X ^DD("DD")
 S SORTKEY="SORT1" I BARSRT=1 S SORTKEY="SORT2"
  I BARTEXT D FILEOUT Q
 W !,@SORTKEY,?21,BATCH,?52
 F PC=1:1:6 W $J($P(LINE,",",PC),11,2)
 I $Y>(IOSL-5) D PAZ^BARRUTL  S QUIT='Y  D HDB^BARRPSRB
 Q
FILEOUT ; Delimited output to file
 W !,LOCANAME,U,@SORTKEY,U,BATCH,U
 S LINE=$TR(LINE,",","^")  ; Remove this line if for comma delimiter
 W LINE
 Q
 ;
LOCTOT ;
 I BARTEXT D LOCTOTF Q
 I '+BARASK W !
 W !?2,"LOCATION TOTAL"
 S BARLTOT=^TMP($J,"BAR-PTD",LOC)
 D TOTOUT Q
 ;
LOCTOTF ; File Output
 Q  U IO  ; Leave in case they want totals to output file
 W !,"LOCATION TOTAL",U,^TMP($J,"BAR-PTD",LOC)
 Q
TOTOUT  ;
 I BARTEXT D TOTFIL Q
 X BARDASH
 S BARDSH1=" ----------"
 N PC
 F PC=1:1:4 W BARDSH1
 W !,?21,$J($P(BARLTOT,U),4)
 W ?53,$J($FN($P(BARLTOT,U,2),",",2),10)
 F PC=3:1:7 W $J($FN($P(BARLTOT,U,PC),",",2),11)
 Q:$G(FILEWRITE)
 I $O(^TMP($J,"BAR-PTD",LOC)) D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
TOTAL ;
 W !
 S BARLTOT=^TMP($J,"BAR-PTD")
 W !?5,"REPORT TOTAL"
 D TOTOUT
 S DUZ(2)=DUZ2  ; Restore Log-in Location
 N TP S TP="C IO(0)" X TP
 Q
 ;
TOTFIL  ;
 q  U IO  ; leave in case they want total lines in output file
 W !,"TOTALS: ",U,^TMP($J,"BAR-PTD")
 K FILEHDR
 N TP S TP="C IO U 0" X TP
 ;C IO U 0
 Q
 ;**************************************************************

BARRTAR2 ; IHS/SD/LSL - Transaction report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,7**;MAR 27,2007
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/ASDS/LSL - 10/05/00 - Routine created
 ;     Detail print of Transaction report
 ;
 ; IHS/SD/LSL - 07/10/02 - V1.6 Patch 2
 ;     Modified to print missing clinics and visit types
 ;
 ; IHS/SD/LSL - 10/24/02 - V1.7 - PAB-1002-90130
 ;      Modified to accomodate DUZ(2) subscript
 ;      
 ;    IHS/SD/RTL - 5/23/05 - V1.8 Patch 1 - IM17362
 ;      TAR report bombing - missing collection batch
 ;        
 Q
 ; *********************************************************************
 ;
DETAIL ; EP
 ; Print Detail
 S BAR("COL")="W !,""Bill Number"",?15,""PAY-AMT"",?26,""PRV-CRD"",?37,""REFUND"",?48,""PAYMENT"",?59,""BILL AMT"",?70,""ADJUSTMENT"""
 S BAR("HD",0)="DETAIL Transaction"_$P(BAR("HD",0),"Transaction",2,99)
 D HDB                    ; Page and column header
 F I=0:1:5 D              ; Initialize totals
 . S Y=1
 . F X="PATOT","PCTOT","RTOT","PTOT","BTOT","ATOT" D
 . . S Y=Y+1
 . . S BARV=X_I
 . . S BARV2="BAR("""_BARV_""")"
 . . S @BARV2=0
 K I,Y,X
 S BARDASH="               ---------- ---------- ---------- ---------- ---------- ----------"
 S BAREQUAL="               ========== ========== ========== ========== ========== =========="
 S BAR("AR")=""             ; Initialize A/R Clerk   (1)
 S BAR("L")=""              ; Initialize location    (2)
 S BAR("B")=""              ; Initialize Batch       (3)
 S BAR("IT")=""             ; Initialize Item        (4)
 S BAR("SORT")=""           ; Initialize sort        (5)
 S BAR("ACCT")=""           ; Initialize A/R account (6)
 S BAR("Z")="TMP("_$J_",""BAR-TAR"""
 S BAR="^"_BAR("Z")_")"
 I '$D(@BAR) D  Q         ; No data, message, quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ; traverse the temp global...
 F  S BAR=$Q(@BAR) Q:BAR'[BAR("Z")  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))  D SUBHD
 . S BAR("TXT")=$P($P(BAR,",",4,99),"""",2)
 . S BAR("TXT")=$P(BAR,",",3)_U_BAR("TXT")  ; Subscipts
 . S BAR("TXTO")=BAR("TXT")
 . S BAR("TXT")=$P(BAR("TXTO"),U)_U_$P(BAR("TXTO"),U,3,99)_U_$P(BAR("TXTO"),U,2)
 . S BAR("NODE")=@BAR                       ; Data
 . S BAR(1)=$P(BAR("NODE"),U)               ; Bill number
 . S BAR(2)=$P(BAR("NODE"),U,2)             ; PAY-AMT
 . S BAR(3)=$P(BAR("NODE"),U,3)             ; PRV-CRD
 . S BAR(4)=$P(BAR("NODE"),U,4)             ; Refund
 . S BAR(5)=$P(BAR("NODE"),U,5)             ; Payment
 . S BAR(6)=$P(BAR("NODE"),U,6)             ; Bill Amount
 . S BAR(7)=$P(BAR("NODE"),U,7)             ; Adjustment
 . I $D(BARY("AR")),BAR("AR")'=$P(BAR("TXT"),U) D
 . . S BAR("L")=""
 . . D SUBHD
 . S BAR("AR")=$P(BAR("TXT"),U)
 . ;;
 . I BAR("L")'=$P(BAR("TXT"),U,2) D
 . . I BAR("L")]"" D
 . . . Q:$G(BAR("F1"))
 . . . W !,BARDASH
 . . . D SUB5,SUB4,SUB3,SUB2,SUB
 . . . W !
 . . W !?10,"Visit Location.......: ",$P(BAR("TXT"),U,2)
 . . S (BAR("B"),BAR("IT"),BAR("SORT"),BAR("ACCT"))=""
 . S BAR("L")=$P(BAR("TXT"),U,2)
 . ;;
 . I BAR("B")'=$P(BAR("TXT"),U,3) D
 . . I BAR("B")]"" D
 . . . Q:$G(BAR("F1"))
 . . . W !,BARDASH
 . . . D SUB5,SUB4,SUB3,SUB2
 . . . W !
 . . W !?10,"Collection Batch.....: "
 . . ;I +$P(BAR("TXT"),U,3) W $P(^BARCOL($P(BAR("TXT"),U,8),$P(BAR("TXT"),U,3),0),U)
 . . I +$P(BAR("TXT"),U,3),$P($G(^BARCOL($P(BAR("TXT"),U,8),$P(BAR("TXT"),U,3),0)),U)'="" D
 . . . W $P($G(^BARCOL($P(BAR("TXT"),U,8),$P(BAR("TXT"),U,3),0)),U)   ;IM17362
 . . E  W $P(BAR("TXT"),U,3)
 . . S (BAR("IT"),BAR("SORT"),BAR("ACCT"))=""
 . S BAR("B")=$P(BAR("TXT"),U,3)
 . ;;
 . I BAR("IT")'=$P(BAR("TXT"),U,4) D
 . . I BAR("IT")]"" D
 . . . Q:$G(BAR("F1"))
 . . . W !,BARDASH
 . . . D SUB5,SUB4,SUB3
 . . . W !
 . . W !?10,"Collection Batch Item: "
 . . ;I +$P(BAR("TXT"),U,4) W $P(^BARCOL($P(BAR("TXT"),U,8),BAR("B"),1,$P(BAR("TXT"),U,4),0),U)
 . . I +$P(BAR("TXT"),U,4),$P($G(^BARCOL($P(BAR("TXT"),U,8),BAR("B"),1,$P(BAR("TXT"),U,4),0)),U)'="" D
 . . . W $P(^BARCOL($P(BAR("TXT"),U,8),BAR("B"),1,$P(BAR("TXT"),U,4),0),U)  ;IM17362
 . . E  W $P(BAR("TXT"),U,4)
 . . S (BAR("SORT"),BAR("ACCT"))=""
 . S BAR("IT")=$P(BAR("TXT"),U,4)
 . ;;
 . I BAR("SORT")'=$P(BAR("TXT"),U,5) D
 . . I BAR("SORT")]"" D
 . . . Q:$G(BAR("F1"))
 . . . W !,BARDASH
 . . . D SUB5,SUB4
 . . . W !
 . . I BARY("SORT")="C" D
 . . . W !?10,"Clinic Type..........: "
 . . . I $P(BAR("TXT"),U,5)=99999 W "NO CLINIC" Q
 . . . W $P(^DIC(40.7,$P(BAR("TXT"),U,5),0),U)
 . . E  D
 . . . W !?10,"Visit Type...........: "
 . . . I $P(BAR("TXT"),U,5)=99999 W "NO VISIT TYPE" Q
 . . . W $P($G(^ABMDVTYP($P(BAR("TXT"),U,5),0)),U)
 . . S BAR("ACCT")=""
 . S BAR("SORT")=$P(BAR("TXT"),U,5)
 . ;;
 . I BAR("ACCT")'=$P(BAR("TXT"),U,6) D
 . . I BAR("ACCT")]"" D
 . . . Q:$G(BAR("F1"))
 . . . W !,BARDASH
 . . . D SUB5
 . . . W !
 . . W !?10,"A/R Account..........: ",$P(BAR("TXT"),U,6),!
 . S BAR("ACCT")=$P(BAR("TXT"),U,6)
 . W !,$E(BAR(1),1,14)                  ; A/R Bill
 . W ?15,$J($FN(BAR(2),",",2),10)       ; PAY-AMT
 . W ?26,$J($FN(BAR(3),",",2),10)       ; PRV-CRD
 . W ?37,$J($FN(BAR(4),",",2),10)       ; Refund
 . W ?48,$J($FN(BAR(5),",",2),10)       ; Payment
 . W ?59,$J($FN(BAR(6),",",2),10)       ; Bill Amt
 . W ?70,$J($FN(BAR(7),",",2),10)       ; Adjustment
 . F I=0:1:5 D                          ; Accumulate totals
 . . S Y=1
 . . F X="PATOT","PCTOT","RTOT","PTOT","BTOT","ATOT" D
 . . . S Y=Y+1
 . . . S BARV=X_I
 . . . S BARV2="BAR("""_BARV_""")"
 . . . S @BARV2=@BARV2+BAR(Y)
 Q:$G(BAR("F1"))
 W !,BARDASH
 D SUB5,SUB4,SUB3,SUB2,SUB,TOT
 Q
 ; *********************************************************************
 ;
HD ; EP
 D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
HDB ; EP
 ; Page and column header
 S BAR("PG")=BAR("PG")+1
 S BAR("I")=""
 D WHD^BARRHD                   ; Report header
 X BAR("COL")
 S $P(BAR("DASH"),"=",$S($D(BAR(132)):132,1:80))=""
 W !,BAR("DASH")
 Q
 ; *********************************************************************
 ;
SUBHD ;
 ; If A/R clerk specified
 Q:'$D(BARY("AR"))
 Q:'+$P(BAR("TXT"),U)
 W !!,"A/R Entry Clerk: ",$P(^VA(200,$P(BAR("TXT"),U),0),U)
 Q
 ; *********************************************************************
 ;
SUB ;
 ; Totals by Visit location.
 Q:'BAR("BTOT1")
 W !,"Location Tot:"
 W ?15,$J($FN(BAR("PATOT1"),",",2),10)
 W ?26,$J($FN(BAR("PCTOT1"),",",2),10)
 W ?37,$J($FN(BAR("RTOT1"),",",2),10)
 W ?48,$J($FN(BAR("PTOT1"),",",2),10)
 W ?59,$J($FN(BAR("BTOT1"),",",2),10)
 W ?70,$J($FN(BAR("ATOT1"),",",2),10)
 S (BAR("PATOT1"),BAR("PCTOT1"),BAR("RTOT1"),BAR("PTOT1"),BAR("BTOT1"),BAR("ATOT1"))=0
 Q
 ; *********************************************************************
 ;
SUB2 ;
 ; Totals by Collection Batch
 Q:'BAR("BTOT2")
 W !,"   Batch Tot:"
 W ?15,$J($FN(BAR("PATOT2"),",",2),10)
 W ?26,$J($FN(BAR("PCTOT2"),",",2),10)
 W ?37,$J($FN(BAR("RTOT2"),",",2),10)
 W ?48,$J($FN(BAR("PTOT2"),",",2),10)
 W ?59,$J($FN(BAR("BTOT2"),",",2),10)
 W ?70,$J($FN(BAR("ATOT2"),",",2),10)
 S (BAR("PATOT2"),BAR("PCTOT2"),BAR("RTOT2"),BAR("PTOT2"),BAR("BTOT2"),BAR("ATOT2"))=0
 Q
 ; *********************************************************************
 ;
SUB3 ;
 ; Totals by Collection Batch Item
 Q:'BAR("BTOT3")
 W !,"    Item Tot:"
 W ?15,$J($FN(BAR("PATOT3"),",",2),10)
 W ?26,$J($FN(BAR("PCTOT3"),",",2),10)
 W ?37,$J($FN(BAR("RTOT3"),",",2),10)
 W ?48,$J($FN(BAR("PTOT3"),",",2),10)
 W ?59,$J($FN(BAR("BTOT3"),",",2),10)
 W ?70,$J($FN(BAR("ATOT3"),",",2),10)
 S (BAR("PATOT3"),BAR("PCTOT3"),BAR("RTOT3"),BAR("PTOT3"),BAR("BTOT3"),BAR("ATOT3"))=0
 Q
 ; *********************************************************************
 ;
SUB4 ;
 ; Totals by Sort type
 Q:'BAR("BTOT4")
 I BARY("SORT")="C" W !,"  Clinic Tot:"
 E  W !,"   Visit Tot"
 W ?15,$J($FN(BAR("PATOT4"),",",2),10)
 W ?26,$J($FN(BAR("PCTOT4"),",",2),10)
 W ?37,$J($FN(BAR("RTOT4"),",",2),10)
 W ?48,$J($FN(BAR("PTOT4"),",",2),10)
 W ?59,$J($FN(BAR("BTOT4"),",",2),10)
 W ?70,$J($FN(BAR("ATOT4"),",",2),10)
 S (BAR("PATOT4"),BAR("PCTOT4"),BAR("RTOT4"),BAR("PTOT4"),BAR("BTOT4"),BAR("ATOT4"))=0
 Q
 ; *********************************************************************
 ;
SUB5 ;
 ; totals by A/R Account
 Q:'BAR("BTOT5")
 W !,"A/R Acct Tot:"
 W ?15,$J($FN(BAR("PATOT5"),",",2),10)
 W ?26,$J($FN(BAR("PCTOT5"),",",2),10)
 W ?37,$J($FN(BAR("RTOT5"),",",2),10)
 W ?48,$J($FN(BAR("PTOT5"),",",2),10)
 W ?59,$J($FN(BAR("BTOT5"),",",2),10)
 W ?70,$J($FN(BAR("ATOT5"),",",2),10)
 S (BAR("PATOT5"),BAR("PCTOT5"),BAR("RTOT5"),BAR("PTOT5"),BAR("BTOT5"),BAR("ATOT5"))=0
 Q
 ; *********************************************************************
 ;
TOT ;
 ; Report (a/r clerk) totals
 Q:'BAR("BTOT0")
 W !,BAREQUAL
 W !,"REPORT TOTAL"
 W ?15,$J($FN(BAR("PATOT0"),",",2),10)
 W ?26,$J($FN(BAR("PCTOT0"),",",2),10)
 W ?37,$J($FN(BAR("RTOT0"),",",2),10)
 W ?48,$J($FN(BAR("PTOT0"),",",2),10)
  W ?59,$J($FN(BAR("BTOT0"),",",2),10)
  W ?70,$J($FN(BAR("ATOT0"),",",2),10)
 S (BAR("PATOT0"),BAR("PCTOT0"),BAR("RTOT0"),BAR("PTOT0"),BAR("BTOT0"),BAR("ATOT0"))=0
 Q

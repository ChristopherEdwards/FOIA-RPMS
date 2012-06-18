BARRAMR3 ; IHS/SD/LSL - Aging management report ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 09/26/00 - Routine created
 ;     Summary print of Aging management report
 ;
 ; IHS/SD/LSL - 07/08/02 - V1.6 Patch 2
 ;     Modified to print missing clinics and visit types
 Q
 ; *********************************************************************
 ;
SUMM ; EP
 S BAR("COL")="W !,""A/R Account"",?32,""Bill Total"",?50,""Amount Billed"",?70,""Balance"""
 S:BAR("HD",0)["Bills" BAR("HD",0)="SUMMARY Bills"_$P(BAR("HD",0),"Bills",2,99)
 S:BAR("HD",0)["Aging" BAR("HD",0)="SUMMARY Aging"_$P(BAR("HD",0),"Aging",2,99)
 D HDB^BARRAMR2
 S (BAR("CNT"),BAR("AMT"),BAR("BAL"))=0
 I '$D(BAR("ST")) D  Q
 . W !!!,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 S (BAR("TCNT"),BAR("TAMT"),BAR("TBAL"))=0
 S (BAR(1),BAR("O1"),BAR("O2"))=""
 F  S BAR(1)=$O(BAR("ST",BAR(1))) Q:BAR(1)=""!($G(BAR("F1")))  D
 . I BAR(1)'=BAR("O1") D HD1
 . S BAR(2)=""
 . F  S BAR(2)=$O(BAR("ST",BAR(1),BAR(2))) Q:BAR(2)=""!($G(BAR("F1")))  D
 . . I BAR(2)'=BAR("O2") D HD2
 . . S BAR(3)=""
 . . F  S BAR(3)=$O(BAR("ST",BAR(1),BAR(2),BAR(3))) Q:BAR(3)=""!($G(BAR("F1")))  D
 . . . I $Y>(IOSL-5) D HD^BARRAMR2 Q:$G(BAR("F1"))
 . . . S BAR("CNT")=$P(BAR("ST",BAR(1),BAR(2),BAR(3)),U)
 . . . S BAR("AMT")=$P(BAR("ST",BAR(1),BAR(2),BAR(3)),U,2)
 . . . S BAR("BAL")=$P(BAR("ST",BAR(1),BAR(2),BAR(3)),U,3)
 . . . W !,$E(BAR(3),1,30)                     ; A/R Account
 . . . W ?35,$J(BAR("CNT"),4)                ; Bill count
 . . . W ?50,$J($FN(BAR("AMT"),",",2),13)    ; Amt billed
 . . . W ?65,$J($FN(BAR("BAL"),",",2),13)    ; Balance
 . . . S BAR("CNT1")=BAR("CNT1")+BAR("CNT")  ; Count per loc
 . . . S BAR("AMT1")=BAR("AMT1")+BAR("AMT")  ; Amt per loc
 . . . S BAR("BAL1")=BAR("BAL1")+BAR("BAL")  ; Balance per loc
 . . . S BAR("CNT2")=BAR("CNT2")+BAR("CNT")  ; Count per sort
 . . . S BAR("AMT2")=BAR("AMT2")+BAR("AMT")  ; Amt per sort
 . . . S BAR("BAL2")=BAR("BAL2")+BAR("BAL")  ; Balance per sort
 . . . S BAR("TCNT")=BAR("TCNT")+BAR("CNT")  ; Grand Count
 . . . S BAR("TAMT")=BAR("TAMT")+BAR("AMT")  ; Grand Amt
 . . . S BAR("TBAL")=BAR("TBAL")+BAR("BAL")  ; Grand Balance
 . . Q:$G(BAR("F1"))
 . . W !?35,"-----",?50,"-------------",?65,"-------------"
 . . I BARY("SORT")="C" W !,"Clinic type subtotal"
 . . E  W !," Visit type subtotal"
 . . W ?35,$J(BAR("CNT2"),4)                 ; Bill count
 . . W ?50,$J($FN(BAR("AMT2"),",",2),13)     ; Amt billed
 . . W ?65,$J($FN(BAR("BAL2"),",",2),13)     ; Balance
 . Q:$G(BAR("F1"))
 . W !?35,"-----",?50,"-------------",?65,"-------------"
 . W !,"Visit location total"
 . W ?35,$J(BAR("CNT1"),4)                  ; Bill count
 . W ?50,$J($FN(BAR("AMT1"),",",2),13)       ; Amt billed
 . W ?65,$J($FN(BAR("BAL1"),",",2),13)       ; Balance
 Q:$G(BAR("F1"))
 W !?35,"=====",?50,"=============",?65,"============="
 W !,"*** REPORT TOTAL ***"
 W ?35,$J(BAR("TCNT"),4)                   ; Bill count
 W ?50,$J($FN(BAR("TAMT"),",",2),13)       ; Amt billed
 W ?65,$J($FN(BAR("TBAL"),",",2),13)       ; Balance
 Q
 ; *********************************************************************
 ;
HD1 ;     
 W !!?5,"Visit Location: ",BAR(1)
 S BAR("O1")=BAR(1)
 S (BAR("CNT1"),BAR("AMT1"),BAR("BAL1"))=0
 Q
 ; *********************************************************************
 ;
HD2 ;
 W !!?10
 I BARY("SORT")="C" D
 . W "Clinic: "
 . I BAR(2)=99999 W "NO CLINIC"
 . E  W $P(^DIC(40.7,BAR(2),0),U)
 I BARY("SORT")="V" D
 . W "Visit Type: "
 . I BAR(2)=99999 W "NO VISIT TYPE"
 . E  W $P(^ABMDVTYP(BAR(2),0),U)
 W !
 S BAR("O2")=BAR(2)
 S (BAR("CNT2"),BAR("AMT2"),BAR("BAL2"))=0
 Q

BARRAMR2 ; IHS/SD/LSL - Aging management report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/ASDS/LSL - 09/26/00 - Routine created
 ;     Detail print of Aging management report
 ;
 ; IHS/SD/LSL - 07/08/02 - V1.6 Patch 2
 ;     Modified to print missing clinics and visit types
 Q
 ; *********************************************************************
 ;
DETAIL ; EP
 ; Print Detail
 S BAR("COL")="W !,""Patient"",?22,""Bill Number"",?42,""DOS"",?51,""Amount Billed"",?68,""Balance"""
 S:BAR("HD",0)["Bills" BAR("HD",0)="DETAIL Bills"_$P(BAR("HD",0),"Bills",2,99)
 S:BAR("HD",0)["Aging" BAR("HD",0)="DETAIL Aging"_$P(BAR("HD",0),"Aging",2,99)
 D HDB                    ; Page and column header
 S (BAR("CNT1"),BAR("CNT2"),BAR("CNT3"),BAR("CNT"))=0
 S (BAR("BTOT1"),BAR("BTOT2"),BAR("BTOT3"),BAR("BTOT"))=0
 S (BAR("ATOT1"),BAR("ATOT2"),BAR("ATOT3"),BAR("ATOT"))=0
 S BAR("ACCT")=""         ; Initialize account   (3)
 S BAR("L")=""            ; Initialize location  (1)
 S BAR("SORT")=""         ; Initialize sort      (2)
 S BAR("Z")="TMP("_$J_",""BAR-AMR"""
 S BAR="^"_BAR("Z")_")"
 I '$D(@BAR) D  Q         ; No data, message, quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ; traverse the temp global...
 F  S BAR=$Q(@BAR) Q:BAR'[BAR("Z")  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . S BAR("TXT")=$P($P(BAR,",",3,99),"""",2)
 . S BAR("B")=$G(^BARBL(DUZ(2),$P(BAR("TXT"),U,5),0))
 . Q:BAR("B")=""
 . S BAR("B1")=$G(^BARBL(DUZ(2),$P(BAR("TXT"),U,5),1))
 . S BAR("AMT")=$P(BAR("B"),U,13)       ; Bill amount
 . S BAR("BAL")=$P(BAR("B"),U,15)       ; Remaining balance
 . S BAR("DOS")=$P(BAR("B1"),U,2)       ; DOS begin
 . S Y=BAR("DOS") D DD^%DT              ; External format
 . S BAR("DOS")=Y
 . I BAR("L")'=$P(BAR("TXT"),U) D
 . . Q:$G(BAR("F1"))
 . . I BAR("L")]"" D
 . . . Q:$G(BAR("F1"))
 . . . D SUB3,SUB2,SUB
 . . . W !
 . . W !?5,"Visit Location: ",$P(BAR("TXT"),U)
 . . S (BAR("SORT"),BAR("ACCT"))=""
 . S BAR("L")=$P(BAR("TXT"),U)
 . I BAR("SORT")'=$P(BAR("TXT"),U,2) D
 . . I BAR("SORT")]"" D
 . . . Q:$G(BAR("F1"))
 . . . D SUB3,SUB2
 . . . W !
 . . I BARY("SORT")="C" D
 . . . W !?10,"    Clinic: "
 . . . I $P(BAR("TXT"),U,2)=99999 W "NO CLINIC"
 . . . E  W $P(^DIC(40.7,$P(BAR("TXT"),U,2),0),U)
 . . E  D
 . . . W !?10,"Visit Type: "
 . . . I $P(BAR("TXT"),U,2)=99999 W "NO VISIT TYPE"
 . . . E  W $P(^ABMDVTYP($P(BAR("TXT"),U,2),0),U)
 . . S BAR("ACCT")=""
 . S BAR("SORT")=$P(BAR("TXT"),U,2)
 . I BAR("ACCT")'=$P(BAR("TXT"),U,3) D
 . . I BAR("ACCT")]"" D
 . . . Q:$G(BAR("F1"))
 . . . D SUB3
 . . . W !
 . . W !?15,"A/R Account: ",$P(BAR("TXT"),U,3),!
 . S BAR("ACCT")=$P(BAR("TXT"),U,3)
 . W !,$E($P(BAR("TXT"),U,4),1,18)                  ; Patient name 
 . W ?20,$P(BAR("B"),U)                             ; A/R Bill
 . W ?38,BAR("DOS")                                 ; DOS Begin
 . W ?51,$J($FN($P(BAR("B"),U,13),",",2),13)        ; Bill Amount
 . W ?65,$J($FN($P(BAR("B"),U,15),",",2),13)        ; Remaining Balance
 . S BAR("CNT")=$G(BAR("CNT"))+1                    ; Total count
 . S BAR("CNT1")=$G(BAR("CNT1"))+1                  ; Count per location
 . S BAR("CNT2")=$G(BAR("CNT2"))+1                  ; Count per sort
 . S BAR("CNT3")=$G(BAR("CNT3"))+1                  ; Count per acct
 . S BAR("ATOT")=$G(BAR("ATOT"))+$P(BAR("B"),U,13)  ; Amount tot
 . S BAR("ATOT1")=$G(BAR("ATOT1"))+$P(BAR("B"),U,13)  ; Amount per loc
 . S BAR("ATOT2")=$G(BAR("ATOT2"))+$P(BAR("B"),U,13)  ; Amount per sort
 . S BAR("ATOT3")=$G(BAR("ATOT3"))+$P(BAR("B"),U,13)  ; Amount per acct
 . S BAR("BTOT")=$G(BAR("BTOT"))+$P(BAR("B"),U,15)  ; Amount tot
 . S BAR("BTOT1")=$G(BAR("BTOT1"))+$P(BAR("B"),U,15)  ; Amount per loc
 . S BAR("BTOT2")=$G(BAR("BTOT2"))+$P(BAR("B"),U,15)  ; Amount per sort
 . S BAR("BTOT3")=$G(BAR("BTOT3"))+$P(BAR("B"),U,15)  ; Amount per acct
 Q:$G(BAR("F1"))
 D SUB3,SUB2,SUB,TOT
 Q
 ; *********************************************************************
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
 X BAR("COL")
 S $P(BAR("DASH"),"=",$S($D(BAR(132)):132,1:80))=""
 W !,BAR("DASH")
 Q
 ; *********************************************************************
 ;
SUB ;
 Q:'BAR("CNT1")
 W !?51,"-------------",?65,"-------------"
 W !,"Visit location"
 W ?20,"Count: ",$J(BAR("CNT1"),4)
 W ?40,"Total:"
 W ?51,$J($FN(BAR("ATOT1"),",",2),13)
 W ?65,$J($FN(BAR("BTOT1"),",",2),13)
 S (BAR("CNT1"),BAR("ATOT1"),BAR("BTOT1"))=0
 Q
 ; *********************************************************************
 ;
SUB2 ;
 Q:'BAR("CNT2")
 W !?51,"-------------",?65,"-------------"
 I BARY("SORT")="C" W !,"Clinic Type"
 E  W !,"Visit Type"
 W ?20,"Count: ",$J(BAR("CNT2"),4)
 W ?40,"Total:"
 W ?51,$J($FN(BAR("ATOT2"),",",2),13)
 W ?65,$J($FN(BAR("BTOT2"),",",2),13)
 S (BAR("CNT2"),BAR("ATOT2"),BAR("BTOT2"))=0
 Q
 ; *********************************************************************
 ;
SUB3 ;
 Q:'BAR("CNT3")
 W !?51,"-------------",?65,"-------------"
 W !,"A/R Account"
 W ?20,"Count: ",$J(BAR("CNT3"),4)
 W ?40,"Total:"
 W ?51,$J($FN(BAR("ATOT3"),",",2),13)
 W ?65,$J($FN(BAR("BTOT3"),",",2),13)
 S (BAR("CNT3"),BAR("ATOT3"),BAR("BTOT3"))=0
 Q
 ; *********************************************************************
 ;
TOT ;
 Q:'BAR("CNT")
 W !?51,"=============",?65,"============="
 W !,"Report Totals"
 W ?20,"Count: ",$J(BAR("CNT"),4)
 W ?40,"Total:"
 W ?51,$J($FN(BAR("ATOT"),",",2),13)
 W ?65,$J($FN(BAR("BTOT"),",",2),13)
 S (BAR("CNT"),BAR("ATOT"),BAR("BTOT"))=0
 Q

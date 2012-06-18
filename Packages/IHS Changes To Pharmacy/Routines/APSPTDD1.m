APSPTDD1 ; IHS/DSD/ENM/CIA/PLS - TOTAL DRUGS DISPENSED PRINT ;14-Oct-2009 14:39;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008**;Sep 23, 2004
 ; Modified - IHS/CIA/PLS - 02/16/04
 ;            IHS/MSC/PLS - 01/05/09 - Routine updated
 ;THIS ROUTINE PRINTS THE PHARMACY DUR TOTAL # DRUGS DISPENSED LISTING
 ;IT IS CALLED BY APSPTDD
EN ;ENTRY POINT
 N DRG,UNIT,DIV,APSPPG,APSPDT,APSPQ
 N DN,I,X,PSOZDUR1,DX,DY
 S (DX,DY)=1 X:$D(^%ZOSF("XY"))#2 ^("XY")
 U IO
 S (TOTAL,APSPPG)=0,APSPQ=""
 ;
 S DRG="",UNIT="",DIV=0
 I '$D(^TMP($J,"PSODUR")) D HDR
 E  F  S DIV=$O(^TMP($J,"PSODUR",DIV)) Q:'DIV  W @IOF D HDR,LOOP,DIVSUB Q:APSPQ
 Q
LOOP F  S DRG=$O(^TMP($J,"PSODUR",DIV,DRG)) Q:DRG=""!APSPQ  D
 .F  S UNIT=$O(^TMP($J,"PSODUR",DIV,DRG,UNIT)) Q:UNIT=""!($D(DUOUT))!($D(DTOUT))  D DATE
 Q
DIVSUB ;DIVISION SUB
 Q:APSPQ
 S APSPPG=0
 I IOST["C-" D PAUS
 Q
DATE ;
 I $Y+4>IOSL,IOST["C-" D PAUS Q:APSPQ  W @IOF D HDR
 Q:APSPQ=1
 I $Y+4>IOSL,IOST["P-" W @IOF D HDR
 W !,DRG,?41,$J($P(^TMP($J,"PSODUR",DIV,DRG,UNIT),U,2),6),?55,UNIT,?70,$J(+^(UNIT),8)
 Q
PAUS N DTOUT,DUOUT,DIR
 S DIR("?")="Enter '^' to Halt or Press Return to continue"
 S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 D ^DIR
 I $D(DUOUT) S APSPQ=1
 Q
HDR ;
 S APSPPG=APSPPG+1
 W !,$$GET1^DIQ(59,DIV,.01)," ""Total Drugs Dispensed"" List"
 W ?73,"Page ",APSPPG
 W !,"Date of Listing: "
 W $$FMTE^XLFDT($$DT^XLFDT,"2ZD")
 I APSPCLS D
 .W ?31,"By: VA Drug Class - "_$$GET1^DIQ(50.605,APSPCLS,.01)
 E  W ?31,"By: Drug"
 W !,"Outpatient Drugs dispensed from "
 W APSPBDF," through ",APSPEDF,!
 W "Total Number of Days = "_($$FMDIFF^XLFDT(APSPED,APSPBD)),!
 S DN=0
 I 'APSPCLS,APSPDALL D
 .W "Drugs Selected ---->",?25,"All Drugs",!
 E  I 'APSPNOD D
 .W "Drug(s) Selected ----->" F I=0:0 S DN=$O(APSPDARY(DN)) Q:'DN  W ?25,$$GET1^DIQ(50,DN,.01),!
PRINT W !,?41,"Number",?55,"Type of Units",!
 W "Drug Name",?41,"of Rx's",?55,"Dispensed",?70,"Total"
 W ! F I=1:1:78 W "_"
 I '$D(^TMP($J,"PSODUR")) W !!?20,"NO DRUGS FOUND !"
 W !
 Q

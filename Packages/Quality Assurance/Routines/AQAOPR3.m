AQAOPR3 ; IHS/ORDC/LJF - PRINT SUMMARIES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is the main driver for printing occ summaries.  It contains the
 ;user interface and the DIP calls.  This report occurs on 2 menus.
 ;
CLOSED ; >>> ask if user wants to select closed or deleted occ
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Would you like to see any CLOSED or DELETED Occurrences"
 D ^DIR G END:$D(DIRUT) I Y=1 S AQAOINAC=""
 ;
ASK ; >>> ask for occ id or patient name or indicator
 S AQAORVW="" ;flag to allow referred to reviewer to see occ
 K AQAOARR S (X,Y)=0 F  Q:X=""  Q:X=U  Q:Y=-1  D
 .W !! K DIC S DIC="^AQAOC(",DIC(0)="AEMQZ"
 .S DIC("A")="OCCURRENCE (ID #, Patient, or Indicator):  "
 .S DIC("A")=$S('$D(AQAOARR):"Select ",1:"Select Another ")_DIC("A")
 .S DIC("S")="D OCCCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 .D ^DIC Q:X=""  Q:X="^"  Q:Y=-1
 .S AQAONAM=$P($G(^DPT($P(^AQAOC(+Y,0),U,2),0)),U)
 .S AQAOARR(+Y)=AQAONAM
 G END:'$D(AQAOARR)
 ;
 ;
DEV ; >>> get print device
 W !! S %ZIS="NQP" D ^%ZIS G END:POP S AQAODEV=ION
 S:$D(IO("S")) AQAOSLV="" I '$D(IO("Q")) G PRINT
 K IO("Q") S ZTRTN="PRINT^AQAOPR3",ZTDESC="OCC SUMMARIES"
 S ZTSAVE("AQAOARR(")="",ZTSAVE("AQAODEV")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC G END
 ;
 ;
PRINT ;ENTRY POINT >>> print each summary by looping through occurrences
 ;called by AQAOREV to print summary during review process
 S AQAOIFN=0,Y=""
 F  S AQAOIFN=$O(AQAOARR(AQAOIFN)) Q:AQAOIFN=""  Q:$G(Y)=0  D
 .S AQAONAM=AQAOARR(AQAOIFN) Q:AQAONAM=""
 .S L=0,DIC="^AQAOC(",FLDS="[AQAO LONG DISPLAY-E1]"
 .S BY="@NUMBER",(TO,FR)=AQAOIFN,IOP=AQAODEV
 .I $D(ZTQUEUED) S IOP="Q;"_AQAODEV,DQTIME="NOW"
 .D EN1^DIP K IOP ;display occurrence
 .I '$D(ZTQUEUED),'$D(AQAOSLV) D PRTOPT^AQAOVAR
 ;
 ;
END ; >>> eoj
 D KILL^AQAOUTIL K AQAOINAC Q

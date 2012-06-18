AQAOPR2 ; IHS/ORDC/LJF - PRINT REVIEW WORKSHEETS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contians the user interface to set up the printing of occ
 ;review worksheets.  THe user also gets the choice to include occ
 ;summaries and occ worksheets as well.
 ;
LEVEL ; >>> ask for review level for occurrences
 K DIR S DIR(0)="PO^9002168.7:EMZ"
 S DIR("A")="Select REVIEW STAGE for the worksheets" D ^DIR
 G END:$D(DIRUT),END:Y=-1 S AQAORLEV=Y
 ;
ASK ; >>> ask for occ id or patient name or indicator
 S AQAORVW="" ;flag to allow referred to reviewer to see occ
 K AQAOARR S (X,Y)=0 F  Q:X=""  Q:X=U  Q:Y=-1  D
 .W !! K DIC S DIC="^AQAOC(",DIC(0)="AEMQZ"
 .S DIC("A")="Select OCCURRENCE (ID #, Patient, or Indicator):  "
 .S DIC("S")="D OCCCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 .D ^DIC Q:X=""  Q:X="^"  Q:Y=-1
 .S AQAOARR($P(Y,U,2))=+Y
 G LEVEL:'$D(AQAOARR)
 ;
SUMM ; >>> print summaries also?
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("?")="Answer YES to print occurrence summaries as well as worksheets"
 S DIR("A")="Do you wish to also print OCCURRENCE SUMMARIES"
 D ^DIR G END:$D(DIRUT) S AQAOSUM=Y
 ;
WRKS ; >>> print occ worksheets also?
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("?")="Answer YES to print occurrence worksheets as well as review worksheets"
 S DIR("A")="Do you wish to also print OCCURRENCE WORKSHEETS"
 D ^DIR G END:$D(DIRUT) S AQAOWKS=Y
 ;
DEV ; >>> get print device
 W !! S %ZIS="NQP" D ^%ZIS G END:POP S AQAODEV=ION
 S:$D(IO("S")) AQAOSLV="" I '$D(IO("Q")) G ^AQAOPR21
 K IO("Q") S ZTRTN="^AQAOPR21",ZTDESC="OCC WORKSHEETS"
 F I="AQAORLEV","AQAOARR(","AQAOSUM","AQAODEV","AQAOWKS" S ZTSAVE(I)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 ;
END D KILL^AQAOUTIL Q

ABSPOSRA ; IHS/OIT/SCR - POS TRANSACTION POSTING SUMMARY REPORT ;
 ;;1.0;PHARMACY POINT OF SALE;**38**;JUN 21, 2001
 ;;POS ADAPTATION OF BARBLSUM - DISPLAY A BILL SUMMARY ;
 ;;
SEL ;EP
 S DIC=$$DIC^XBDIQ1(90050.01)
 S DIC(0)="AEQM"
 D ^DIC
 Q:Y'>0
 S BARBLDA=+Y
 ; -------------------------------
 ;
XBLM ;
 K DA
 S XBNS="BAR"
 S XBRP="DSP^BARBLSUM"
 S XBRX="EXIT^BARBLSUM"
 D ^XBDBQUE
 G SEL
 ; *********************************************************************
 ;
DSP ;EP
 D EN^BARPST5(BARBLDA)
 I $E(IOST)="C",IOT["TRM",'$D(ZTQUEUED),$Y+20>IOSL W $$EN^BARVDF("IOF")
 W !,?15,">> SUMMARY <<",!
 K BARBL
 D SUM^BARROLL(BARBLDA)
 I $E(IOST)="C",IOT["TRM",'$D(ZTQUEUED) W $$EN^BARVDF("IOF")
 Q
 ; *********************************************************************
 ;
EXIT ;EP
 D ^%ZISC
 Q

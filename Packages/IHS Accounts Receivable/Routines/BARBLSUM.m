BARBLSUM ; IHS/SD/LSL - DISPLAY A BILL SUMMARY ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;;
SEL ;EP
 S DIC=$$DIC^XBDIQ1(90050.01)
 S DIC(0)="AEQM"
 ; IHS/SD/PKD 10/22/10 More info on the Selection display
 S DIC("W")="D DISP^BARPUTL"
 D ^DIC
 Q:Y'>0
 S BARBLDA=+Y
 ; -------------------------------
 ;
XBLM ;
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 I Y="B" D  G SEL
 . S XBFLD("BROWSE")=1
 . D VIEWR^XBLM("DSP^BARBLSUM")
 . D FULL^VALM1
 . W $$EN^BARVDF("IOF")
 . D CLEAR^VALM1 ;clears out all list man stuff
 . K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 . K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMKEY,VALMLFT,VALMLST
 . K VALMMENU,VALMSGR,VALMUP,VALMWD,VALMY,XQORS,XQORSPEW,VALMCOFF
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

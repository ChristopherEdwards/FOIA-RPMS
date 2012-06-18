BDW1VBLL ;IHS/CMI/LAB - Display log of dw visit backload;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
EN1 ;
 W:$D(IOF) @IOF
 K BDWQUIT
 W !!,"Display DATA WAREHOUSE EXPORT Log Entry",!
 S DIC="^BDWBLOG(",DIC("A")="Enter Encounter Backload Log Entry: ",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G XIT
 S BDWLOG=+Y
 S DIR(0)="SO^B:BROWSE Output on Screen;P:PRINT Output to Printer",DIR("A")="Do you want to",DIR("B")="B" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 I Y="B" D BROWSE,XIT Q
 S XBRP="PRINT^BDW1VBLL",XBRC="PROC^BDW1VBLL",XBRX="XIT^BDW1VBLL",XBNS="BDW"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 D VIEWR^XBLM("PRINT^BDW1VBLL","Data Warehouse Visit Backload Log Display")
 Q
XIT ;EP
 D FULL^VALM1 W:$D(IOF) @IOF
 K BDWLOG,BDWREC
 Q
PROC ;
 Q
PRINT ;
 W:$D(IOF) @IOF W !?19,"DATA WAREHOUSE ENCOUNTER BACKLOAD LOG REPORT"
 W !?7,"Information for Log Entry ",BDWLOG," Beginning Date:  ",$$FMTE^XLFDT($P(^BDWBLOG(BDWLOG,0),U))
 S BDWREC=^BDWBLOG(BDWLOG,0)
 W !!?30,"Number:",?40,BDWLOG
 W !?22,"Beginning Date:",?40,$$FMTE^XLFDT($P(BDWREC,U))
 W !?25,"Ending Date:",?40,$$FMTE^XLFDT($P(BDWREC,U,2))
 W !?17,"Run Start Date/Time:",?40,$$FMTE^XLFDT($P(BDWREC,U,3))
 W !?18,"Run Stop Date/Time:",?40,$$FMTE^XLFDT($P(BDWREC,U,4))
 W !?22,"Total Run Time:",?40,$$VAL^XBDIQ1(90214,BDWLOG,.13)
 W !?24,"Run Location:",?40,$$VAL^XBDIQ1(90214,BDWLOG,.09)
 W !?15,"Message Header Record:",?40,$$VAL^XBDIQ1(90214,BDWLOG,.12)
 W !?14,"Message Trailer Record:",?40,$$VAL^XBDIQ1(90214,BDWLOG,.14)
 W !?17,"Transmission Status:",?40,$$VAL^XBDIQ1(90214,BDWLOG,.15)
 W !!?4,"Total Number of Visits Processed:",?40,$$VAL^XBDIQ1(90214,BDWLOG,.08)
 W !?5,"Total Number of Visits Exported: ",?40,$$VAL^XBDIQ1(90214,BDWLOG,.18)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,3) W !?14,"Deleted visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3103)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,2) W !?7,"Zero dep entry visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3102)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,8) W !?18,"MFI visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3108)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,4) W !?11,"NO PATIENT visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3104)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,5) W !?10,"NO LOCATION visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3105)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,6) W !?5,"NO TYPE OF VISIT visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3106)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,32)),U,7) W !?1,"NO SERVICE CATEGORY visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3107)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWBLOG(BDWLOG,31)),U,1) W !?9,"DEMO PATIENT visits skipped:",?40,$$VAL^XBDIQ1(90214,BDWLOG,3101)
TEXT ;
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)
 S DIR(0)="FO^1:1",DIR("A")="Press 'ENTER' to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
FF ;
 I $E(IOST)="C" S DIR(0)="E",DIR("A")="Press 'ENTER' to continue or '^' to exit" D ^DIR K DIR I $D(DIRUT) S BDWQUIT=1 Q
 W:$D(IOF) @IOF
 W !?40,"Data Warehouse Transmission Log - Page 2",!!
 Q

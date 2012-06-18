BDWDLOG ; IHS/CMI/LAB - DISPLAY DW EXPORT LOG DATA AUGUST 14, 1992 ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
EN1 ;
 W:$D(IOF) @IOF
 K BDWQUIT
 W !!,"Display DATA WAREHOUSE EXPORT Log Entry",!
 S DIC="^BDWXLOG(",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G XIT
 S BDWLOG=+Y
 S DIR(0)="SO^B:BROWSE Output on Screen;P:PRINT Output to Printer",DIR("A")="Do you want to",DIR("B")="B" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 I Y="B" D BROWSE,XIT Q
 S XBRP="PRINT^BDWDLOG",XBRC="PROC^BDWDLOG",XBRX="XIT^BDWDLOG",XBNS="BDW"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 D VIEWR^XBLM("PRINT^BDWDLOG","Data Warehouse Log Display")
 Q
XIT ;EP
 D FULL^VALM1
 K BDWLOG,BDWREC
 Q
PROC ;
 Q
PRINT ;
 W:$D(IOF) @IOF W !?19,"DATA WAREHOUSE EXPORT LOG REPORT"
 W !?7,"Information for Log Entry ",BDWLOG," Beginning Date:  ",$$FMTE^XLFDT($P(^BDWXLOG(BDWLOG,0),U))
 S BDWREC=^BDWXLOG(BDWLOG,0)
 W !!?35,"Number:",?45,BDWLOG
 W !?27,"Beginning Date:",?45,$$FMTE^XLFDT($P(BDWREC,U))
 W !?30,"Ending Date:",?45,$$FMTE^XLFDT($P(BDWREC,U,2))
 W !?22,"Run Start Date/Time:",?45,$$FMTE^XLFDT($P(BDWREC,U,3))
 W !?23,"Run Stop Date/Time:",?45,$$FMTE^XLFDT($P(BDWREC,U,4))
 W !?33,"Run Time:",?45,$P(BDWREC,U,13)
 W !?29,"Run Location:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.09)
 W !?30,"Export Type:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.07)
 W !?22,"Transmission Status:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.15)
 W !!,"Total Number of Registration + Encounter Messages Exported:  ",$$VAL^XBDIQ1(90213,BDWLOG,.06)
 W !?5,"Number of Registration Messages Sent:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.11)
 W !?5,"Total Number of Encounters Processed:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.08)
 W !?6,"Total Number of Encounters Exported:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.18)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 W !?13,"Number of Encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,.05)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,3) W !?15,"Deleted Encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3103)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,2) W !?8,"Zero dep entry encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3102)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,11) W !?19,"MFI encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3111)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,4) W !?12,"NO PATIENT encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3104)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,5) W !?11,"NO LOCATION encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3105)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,6) W !?6,"NO TYPE OF VISIT encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3106)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,7) W !?3,"NO SERVICE CATEGORY encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3107)
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 I $P($G(^BDWXLOG(BDWLOG,31)),U,1) W !?10,"DEMO PATIENT encounters skipped:",?45,$$VAL^XBDIQ1(90213,BDWLOG,3101)
TEXT ;
 I $Y>(IOSL-3) D FF Q:$D(BDWQUIT)
 W !!,"To list the visits that were skipped, use option DWER."
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)
 S DIR(0)="FO^1:1",DIR("A")="Press 'ENTER' to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
FF ;
 I $E(IOST)="C" S DIR(0)="E",DIR("A")="Press 'ENTER' to continue or '^' to exit" D ^DIR K DIR I $D(DIRUT) S BDWQUIT=1 Q
 W:$D(IOF) @IOF
 W !?40,"Data Warehouse Transmission Log - Page 2",!!
 Q

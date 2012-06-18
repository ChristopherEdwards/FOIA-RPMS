APCLSILL ;IHS/CMI/LAB - AGGREGATE ILI REPORT;
 ;;3.0;IHS PCC REPORTS;**24,26,27,28**;FEB 05, 1997
 ;
START ;
 W:$D(IOF) @IOF
 W !,"**********  LIST OF ILI EXPORTS  **********",!
 D EN^XBVK("APCL")
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning date for export search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EOJ Q
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending date for export search:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
ZIS ;
 S XBRP="PRINT^APCLSILL",XBRC="PROC^APCLSILL",XBRX="EOJ^APCLSILL",XBNS="APCL"
 D ^XBDBQUE
 ;
EOJ ;ENTRY POINT
 D EN^XBVK("APCL")
 Q
PROC ;EP - called from xbdbque
 Q
PRINT ;
 S APCLPG=0
 D HEADER
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1)
 F  S APCLSD=$O(^APCLILIC(1,12,"B",APCLSD)) Q:APCLSD=""!($D(APCLQUIT))!(APCLSD>APCLED)  D
 .S APCLX=0 F  S APCLX=$O(^APCLILIC(1,12,"B",APCLSD,APCLX)) Q:APCLX'=+APCLX!($D(APCLQUIT))  D
 ..I $Y>(IOSL-3) D HEADER Q:$D(APCLQUIT)
 ..W $$FMTE^XLFDT(APCLSD),?20,$P(^APCLILIC(1,12,APCLX,0),U,2),?52,$P(^APCLILIC(1,12,APCLX,0),U,4),?70,$S($P(^APCLILIC(1,12,APCLX,0),U,5):"YES",1:"NO"),!
 D EOP
 Q
HEADER ;EP - report header
 I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 I APCLPG W:$D(IOF) @IOF
 S APCLPG=APCLPG+1
 W ?3,$P(^DIC(4,DUZ(2),0),U),?58,$$FMTE^XLFDT(DT),?72,"Page ",APCLPG,!
 W !,$$CTR("*** ILI Exports ***",80),!
 S X="Dates: "_$$FMTE^XLFDT(APCLBD)_" through "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!!
 W ?1,"DATE EXPORTED",?20,"FILENAME",?50,"# RECORDS",?65,"SUCCESSFULLY",!?68,"SENT?",!
 W $$REPEAT^XLFSTR("-",79),!
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------

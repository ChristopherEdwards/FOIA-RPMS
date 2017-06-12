BDMDD1Q ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 22 Feb 2014  3:43 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
SDPI ;EP
 ;print aggregate audit
 ;
 ;
PRINT ;
 ;S BDMPG=0
 S BDMQUIT=0
 D HEADER
 D PRINT1 ;print each indicator
 D EXIT
 Q
 ;
PRINT1 ;
 I BDMNOGO D
 .W !!,"*** Please NOTE:  ",BDMNOGO," Patients were not included in this cumulative audit",!,"because their date of onset was after the audit date.",!
 W !!,$P(BDMCUML(10),U,1)
 W !?5,$P(BDMCUML(10,1),U)
 W !?5,$P(BDMCUML(10,2),U)
 W !?5,$P(BDMCUML(10,3),U),?49,$$C($P(BDMCUML(10,3),U,2)),?61,$$C($P(BDMCUML(10,3),U,3)),?73,$$P($P(BDMCUML(10,3),U,3),$P(BDMCUML(10,3),U,2))
 W !?5,$P(BDMCUML(10,4),U)
 W !?5,$P(BDMCUML(10,5),U),?49,$$C($P(BDMCUML(10,5),U,2)),?61,$$C($P(BDMCUML(10,5),U,3)),?73,$$P($P(BDMCUML(10,5),U,3),$P(BDMCUML(10,5),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(20),U)
 W !?5,$P(BDMCUML(20,1),U),?49,$$C($P(BDMCUML(20,1),U,2)),?61,$$C($P(BDMCUML(20,1),U,3)),?73,$$P($P(BDMCUML(20,1),U,3),$P(BDMCUML(20,1),U,2))
 W !?5,$P(BDMCUML(20,2),U),?49,$$C($P(BDMCUML(20,2),U,2)),?61,$$C($P(BDMCUML(20,2),U,3)),?73,$$P($P(BDMCUML(20,2),U,3),$P(BDMCUML(20,2),U,2))
 W !?5,$P(BDMCUML(20,3),U),?49,$$C($P(BDMCUML(20,3),U,2)),?61,$$C($P(BDMCUML(20,3),U,3)),?73,$$P($P(BDMCUML(20,3),U,3),$P(BDMCUML(20,3),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(30),U)
 W !?5,$P(BDMCUML(30,1),U)
 W !?5,$P(BDMCUML(30,2),U),?49,$$C($P(BDMCUML(30,2),U,2)),?61,$$C($P(BDMCUML(30,2),U,3)),?73,$$P($P(BDMCUML(30,2),U,3),$P(BDMCUML(30,2),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(40),U)
 W !?5,$P(BDMCUML(40,1),U),?49,$$C($P(BDMCUML(40,1),U,2)),?61,$$C($P(BDMCUML(40,1),U,3)),?73,$$P($P(BDMCUML(40,1),U,3),$P(BDMCUML(40,1),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(50),U)
 W !?5,$P(BDMCUML(50,1),U),?49,$$C($P(BDMCUML(50,1),U,2)),?61,$$C($P(BDMCUML(50,1),U,3)),?73,$$P($P(BDMCUML(50,1),U,3),$P(BDMCUML(50,1),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(60),U)
 W !?5,$P(BDMCUML(60,1),U),?49,$$C($P(BDMCUML(60,1),U,2)),?61,$$C($P(BDMCUML(60,1),U,3)),?73,$$P($P(BDMCUML(60,1),U,3),$P(BDMCUML(60,1),U,2))
 W !?5,$P(BDMCUML(60,2),U),?49,$$C($P(BDMCUML(60,2),U,2)),?61,$$C($P(BDMCUML(60,2),U,3)),?73,$$P($P(BDMCUML(60,2),U,3),$P(BDMCUML(60,2),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(70),U)
 W !?5,$P(BDMCUML(70,1),U),?49,$$C($P(BDMCUML(70,1),U,2)),?61,$$C($P(BDMCUML(70,1),U,3)),?73,$$P($P(BDMCUML(70,1),U,3),$P(BDMCUML(70,1),U,2))
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(80),U)
 W !?5,$P(BDMCUML(80,1),U)
 W !?5,$P(BDMCUML(80,2),U),?49,$$C($P(BDMCUML(80,2),U,2)),?61,$$C($P(BDMCUML(80,2),U,3)),?73,$$P($P(BDMCUML(80,2),U,3),$P(BDMCUML(80,2),U,2))
 W !?5,$P(BDMCUML(80,3),U),?49,$$C($P(BDMCUML(80,3),U,2)),?61,$$C($P(BDMCUML(80,3),U,3)),?73,$$P($P(BDMCUML(80,3),U,3),$P(BDMCUML(80,3),U,2))
 W !?5,$P(BDMCUML(80,4),U)
 W !?5,$P(BDMCUML(80,5),U),?49,$$C($P(BDMCUML(80,5),U,2)),?61,$$C($P(BDMCUML(80,5),U,3)),?73,$$P($P(BDMCUML(80,5),U,3),$P(BDMCUML(80,5),U,2))
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 W !!,$P(BDMCUML(90),U)
 W !?5,$P(BDMCUML(90,1),U),?49,$$C($P(BDMCUML(90,1),U,2)),?61,$$C($P(BDMCUML(90,1),U,3)),?73,$$P($P(BDMCUML(90,1),U,3),$P(BDMCUML(90,1),U,2))
 W !?5,$P(BDMCUML(90,2),U),?49,$$C($P(BDMCUML(90,2),U,2)),?61,$$C($P(BDMCUML(90,2),U,3)),?73,$$P($P(BDMCUML(90,2),U,3),$P(BDMCUML(90,2),U,2))
 W !?5,$P(BDMCUML(90,3),U),?49,$$C($P(BDMCUML(90,3),U,2)),?61,$$C($P(BDMCUML(90,3),U,3)),?73,$$P($P(BDMCUML(90,3),U,3),$P(BDMCUML(90,3),U,2))
 W !?5,$P(BDMCUML(90,4),U),?49,$$C($P(BDMCUML(90,4),U,2)),?61,$$C($P(BDMCUML(90,4),U,3)),?73,$$P($P(BDMCUML(90,4),U,3),$P(BDMCUML(90,4),U,2))
 W !?5,$P(BDMCUML(90,5),U)
 W !?5,$P(BDMCUML(90,6),U),?49,$$C($P(BDMCUML(90,6),U,2)),?61,$$C($P(BDMCUML(90,6),U,3)),?73,$$P($P(BDMCUML(90,6),U,3),$P(BDMCUML(90,6),U,2))
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 W !!,"* Selected patients could be people with or without diabetes, the target "
 W !,"group for SDPI activities, or whatever group of people is relevant for "
 W !,"reporting purposes."
 W !,"**This item is only reported for patients without an active diagnosis "
 W !,"of depression, not all selected patients.",!
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0) Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
P(D,N) ;return %
 I 'D Q ""
 I 'N Q "  0%"
 NEW X S X=N/D,X=X*100,X=$J(X,3,0)
 Q X_"%"
C(X,X2,X3) ;
 I '$G(X2) S X2=0
 I '$G(X3) S X3=6
 D COMMA^%DTC
 Q X
HEADER ;EP
 G:'BDMPG HEADER1
 W !
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 I $G(BDMGUI) W !!
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("IHS DIABETES CARE AND OUTCOMES AUDIT REPORT - RPMS AUDIT",80),!
 N BDMDHDR
 S BDMDHDR="SDPI Required Key Measures Report [2015 Version] ("_$$DATE^BDMS9B1(BDMBDAT)_" to "_$$DATE^BDMS9B1(BDMADAT)_")"
 W $$CTR(BDMDHDR,80),!
 ;W $$CTR("AUDIT REPORT FOR 2016 (Audit Period "_$$DATE^BDMS9B1(BDMBDAT)_" to "_$$DATE^BDMS9B1(BDMADAT)_")"),!
 S X="Facility: "_$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U) W $$CTR(X,80),!
 ;S X="Annual Audit/SDPI Reporting" W !,$$CTR(X,80),!
 S X=$P(BDMCUML(10,3),U,3)_" patients were audited*" W !,$$CTR(X),!
 W $TR($J("",80)," ","-"),!
 W ?45,"# of ",?57,"#",?70,"Percent",!
 W ?45,"Patients",?57,"Considered",!
 W ?45,"(Numerator)",?57,"(Denominator)",!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
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

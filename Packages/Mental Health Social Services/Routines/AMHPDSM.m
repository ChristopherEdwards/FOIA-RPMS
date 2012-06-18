AMHPDSM ; IHS/CMI/LAB - All visit report driver ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ; 
 D INFORM
ZIS ;CALL TO XBDBQUE
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^AMHPDSM",XBRC="",XBRX="XIT^AMHPDSM",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
XIT ;EP
 D EN^XBVK("AMH")
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHPDSM"")"
 S XBNS="AMH",XBRC="",XBRX="XIT^AMHPDSM",XBIOP=0 D ^XBDBQUE
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,"****** PRINT/LIST PROBLEM/DSM CODE TABLE ******",!
 W !,"This report will print either to a printer or the screen, a list of all"
 W !,"active Problem/DSM codes.  It will list the code, narrative, the 2 digit"
 W !,"problem code it is mapped to and the ICD9-Diagnosis code it is"
 W !,"mapped to."
 Q
 ;
PRINT ;EP
 S AMHPG=0 D HEAD
 K AMHQUIT
 S AMHX="" F  S AMHX=$O(^AMHPROB("D",AMHX)) Q:AMHX=""!($D(AMHQUIT))  D
 .S AMHY=0 F  S AMHY=$O(^AMHPROB("D",AMHX,AMHY)) Q:AMHY'=+AMHY!($D(AMHQUIT))  D
 ..Q:$P(^AMHPROB(AMHY,0),U,13)
 ..Q:$P(^AMHPROB(AMHY,0),U,14)
 ..I $Y>(IOSL-4) D HEAD Q:$D(AMHQUIT)
 ..K ^UTILITY($J,"W") S X=$P(^AMHPROB(AMHY,0),U,2),DIWL=0,DIWR=52 D ^DIWP
 ..W !,$P(^AMHPROB(AMHY,0),U,1),?9,$G(^UTILITY($J,"W",0,1,0)),?65,$E($$VAL^XBDIQ1(9002012.2,AMHY,.03),1,12),?73,$$VAL^XBDIQ1(9002012.2,AMHY,.05)
 ..I $O(^UTILITY($J,"W",0,1)) D
 ...S X=1 S X=$O(^UTILITY($J,"W",0,X)) Q:X'=+X  W !?9,^UTILITY($J,"W",0,X,0)
 ..W !
 ..K ^UTILITY($J,"W")
 Q
HEAD I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?40,$$FMTE^XLFDT(DT),?68,"Page ",AMHPG,!
 W !,$$CTR("********** BEHAVIORAL HEALTH PROBLEM/DSM CODES **********",80),!
 W !,"CODE",?9,"NARRATIVE",?65,"PROBLEM",?73,"ICD-9",!,?65,"CODE",?73,"CODE"
 W !,$TR($J(" ",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------

AMHPACT ; IHS/CMI/LAB - All visit report driver ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ; 
 D INFORM
ZIS ;CALL TO XBDBQUE
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^AMHPACT",XBRC="",XBRX="XIT^AMHPACT",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
XIT ;EP
 D EN^XBVK("AMH")
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHPACT"")"
 S XBNS="AMH",XBRC="",XBRX="XIT^AMHPACT",XBIOP=0 D ^XBDBQUE
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,"****** PRINT/LIST ACTIVITY CODE TABLE ******",!
 W !,"This report will print either to a printer or the screen, a list of all"
 W !,"activity codes.  It will list the code, short description, the category,"
 W !,"and whether the code passes to PCC.",!
 Q
 ;
PRINT ;EP
 S AMHPG=0 D HEAD
 K AMHQUIT
 S AMHX="" F  S AMHX=$O(^AMHTACT("AC",AMHX)) Q:AMHX=""!($D(AMHQUIT))  D
 .S AMHY=0 F  S AMHY=$O(^AMHTACT("AC",AMHX,AMHY)) Q:AMHY'=+AMHY!($D(AMHQUIT))  D
 ..I $Y>(IOSL-3) D HEAD Q:$D(AMHQUIT)
 ..W !,$P(^AMHTACT(AMHY,0),U,1),?5,$E($P(^AMHTACT(AMHY,0),U,2),1,50),?56,$E($$VAL^XBDIQ1(9002012,AMHY,.03),1,12),?70,$$VAL^XBDIQ1(9002012,AMHY,.04),?76,$$VAL^XBDIQ1(9002012,AMHY,.08),!
 Q
HEAD I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?40,$$FMTE^XLFDT(DT),?68,"Page ",AMHPG,!
 W !,$$CTR("********** BEHAVIORAL HEALTH ACTIVITY CODES **********",80),!
 W !,"CODE",?5,"DESCRIPTION",?57,"CATEGORY",?70,"PCC",?76,"MNE"
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

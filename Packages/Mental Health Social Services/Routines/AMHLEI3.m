AMHLEI3 ; IHS/CMI/LAB - treatment plan update ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
PRINT ;EP
 I '$G(AMHPAT) W !!,"ERROR - Patient not defined!" Q
 D FULL^VALM1
 ;print or browse
 W ! S DIR(0)="S^P:PRINT Output on Paper;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D PAUSE,BACK^AMHLEI Q
 I $G(Y)="B" D BROWSE D BACK^AMHLEI Q
 D EN1
 D BACK^AMHLEI
 Q
BROWSE ;
 S AMHBROW=1 D VIEWR^XBLM("PRINT1^AMHLEI3","Display of Intake Document") K AMHBROW
 Q
EN1 ;EP - called from protocol
 ;DFN must be equal to patient
 Q:'$G(DFN)
 Q:'$D(^DPT(DFN))
 ;get device
 S XBRP="PRINT1^AMHLEI3",XBRC="",XBRX="XIT^AMHLEI3",XBNS="AMH;DFN"
 D ^XBDBQUE
 D BACK^AMHLEI
 Q
XIT ;
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
PRINT1 ;EP - called from xbdbque
 Q:'$G(DFN)
 I '$D(^AMHPINTK(DFN)) D HEAD W !!,"No INTAKE Document on file for ",$P(^DPT(DFN,0),U) Q
 S (AMHQUIT,AMHPG)=0
 D HEAD
 W !!?2,"Initial Intake:  ",?27,$$VAL^XBDIQ1(9002011.07,DFN,.07)
 W !?2,"      Provider:  ",?27,$$VAL^XBDIQ1(9002011.07,DFN,.08)
 W !!?2,"    Last Update:  ",?27,$$VAL^XBDIQ1(9002011.07,DFN,.02)
 W !?2,"      Provider:  ",?27,$$VAL^XBDIQ1(9002011.07,DFN,.02)
 I $O(^AMHPINTK(DFN,10,0)) D  Q:AMHQUIT
 .W !!?2,"Referred By:",!
 .K AMHPCNT,AMHPRNM S AMHPCNT=0,AMHNODE=10,AMHDA=DFN,AMHFILE=9002011.07 D WP^AMHLETP4
 .I $D(AMHPRNM) S X=0 F  S X=$O(AMHPRNM(X)) Q:X'=+X!(AMHQUIT)  D:$Y>(IOSL-3) HEAD Q:AMHQUIT  W ?5,AMHPRNM(X),!
 .Q:AMHQUIT
 W !!?2,"Intake Documentation/Narrative:",!
 K AMHPCNT,AMHPRNM S AMHPCNT=0,AMHNODE=41,AMHDA=DFN,AMHFILE=9002011.07 D WP^AMHLETP4
 I $D(AMHPRNM) S X=0 F  S X=$O(AMHPRNM(X)) Q:X'=+X!(AMHQUIT)  D:$Y>(IOSL-3) HEAD Q:AMHQUIT  W ?5,AMHPRNM(X),!
 Q:$G(AMHBROW)
 I $Y>(IOSL-8) D HEAD Q:AMHQUIT
 S X=IOSL-$Y S X=X-8 F I=1:1:X W !
 W !,"________________________________________",?52,"__________________"
 W !?60,"DATE"
 W !!!,"________________________________________",?52,"__________________"
 W !?60,"DATE"
 K AMHPG,AMHQUIT,AMHPRNM,AMHNODE,AMHPCNT,AMHFILE
 Q
HEAD ;ENTRY POINT
 I 'AMHPG G HEAD1
 NEW X
 I '$G(AMHBROW),$E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
HEAD1 ;EP
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$TR($J("",80)," ","*")
 W !,"*",?79,"*"
 W !,"*  INTAKE DOCUMENT",?45,"Printed: ",$$FMTE^XLFDT($$NOW^XLFDT),?79,"*"
 W !,"*  Name:  ",$P(^DPT(DFN,0),U),?68,"Page ",AMHPG,?79,"*"
 W !,"*  ",$E($P(^DIC(4,DUZ(2),0),U),1,25),?30,"DOB:  ",$$FMTE^XLFDT($P(^DPT(DFN,0),U,3),"2D"),?46,"Sex:  ",$P(^DPT(DFN,0),U,2),?54,"  Chart #:  ",$P(^AUTTLOC(DUZ(2),0),U,7),$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2),?79,"*"
 W !,"*",?79,"*"
 W !,$TR($J("",80)," ","*"),!
 Q

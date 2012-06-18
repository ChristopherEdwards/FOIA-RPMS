AMHLETR1 ; IHS/CMI/LAB - print report of tps needing resolved ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;fixed potential undef
 ;
 ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "**********  LIST TREATMENT PLANS BY NEXT REVIEW DATE  **********",!!
 W "This report will list all patients who have a treatment plan which is due",!,"to be reviewed in a date range specified by the user.",!
 D DBHUSRP^AMHUTIL
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range during which the treatment plan is to be reviewed.",!
 W ! S DIR(0)="D^::EP",DIR("A")="Enter BEGINNING Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_"::E",DIR("A")="Enter ENDING Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
PROG ;
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G THER
 S DIR(0)="9002011.56,.17",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
THER ;
 W !!,"You can limit the report output to treatment plans for one or all Providers",!
 K AMHTHER W ! S DIR(0)="S^O:One Provider;A:All Providers",DIR("A")="List treatment plans for",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) BD
 G:Y="A" DEMO
 S DIC("A")="Which Responsible Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I X="" G THER
 I Y<0 G THER
 S AMHTHER=+Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G THER
ZIS ;
 S XBRC="PROC^AMHLETR1",XBRP="PRINT^AMHLETR1",XBNS="AMH",XBRX="XIT^AMHLETR1"
 D ^XBDBQUE
XIT ;EP
 K AMHTP,AMHED,AMHBD,AMHBDD,AMHEDD,AMHBTH,AMHJOB,AMHTPR,AMHET,AMH80D,AMHTHER
 Q
 ;
PROC ;EP - entry point for processing
 S AMHJOB=$J,AMHBTH=$H,AMHTOT=0,AMHTP=0,AMHBT=$H
 F  S AMHTP=$O(^AMHPTXP(AMHTP)) Q:AMHTP'=+AMHTP  D PROC1
 S AMHET=$H
 K AMHTP
 Q
PROC1 ;
 S X=$G(^AMHPTXP(AMHTP,0))
 Q:$P(X,U,2)=""
 Q:'$$ALLOWP^AMHUTIL(DUZ,$P(X,U,2))
 Q:'$$ALLOWTP^AMHLETP(DUZ,AMHTP)
 Q:$$DEMO^AMHUTIL1($P(X,U,2),$G(AMHDEMO))
 I $G(AMHTHER),$P(X,U,4)'=AMHTHER Q
 I AMHPROG]"",$P(X,U,17)'=AMHPROG Q
 I $P(^AMHPTXP(AMHTP,0),U,12)]"" Q  ;don't display those resolved
 I $P(X,U,9)]"",$P(X,U,9)'<AMHBD,$P(X,U,9)'>AMHED S ^XTMP("AMHLETR1",AMHJOB,AMHBTH,AMHTP)=""
 Q
PRINT ;EP
 S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 S AMH80D="-------------------------------------------------------------------------------",AMHQUIT=0,AMHPG=0
 D HEAD
 I '$D(^XTMP("AMHLETR1",AMHJOB,AMHBTH)) W !!,"NO DATA TO REPORT" G DONE
 S AMHTP=0 F  S AMHTP=$O(^XTMP("AMHLETR1",AMHJOB,AMHBTH,AMHTP)) Q:AMHTP'=+AMHTP!(AMHQUIT)  D
 .I $Y>(IOSL-4) D HEAD Q:AMHQUIT
 .S AMHTPR=^AMHPTXP(AMHTP,0)
 .S Y=$P(AMHTPR,U,2) I Y D ^AUPNPAT
 .I $P(AMHTPR,U,2)="" W !,"????",?23,"????",?33,"????" G P1
 .W !,$S($P(AMHTPR,U,2):$P(^DPT($P(AMHTPR,U,2),0),U),1:"????"),?23,$$FMTE^XLFDT(AUPNDOB,"2D"),?33,$S($P($G(^AUPNPAT($P(AMHTPR,U,2),41,DUZ(2),0)),U,2):$P(^AUPNPAT($P(AMHTPR,U,2),41,DUZ(2),0),U,2),1:"???")
P1 .W ?41,$$FMTE^XLFDT($P(AMHTPR,U,1)),?54,$$FMTE^XLFDT($P(AMHTPR,U,9)),?68,$$FMTE^XLFDT($P(AMHTPR,U,3))
 .W !?3,"Program: ",$$VAL^XBDIQ1(9002011.56,AMHTP,.17),?33,"Responsible Provider: ",$S($P(AMHTPR,U,4):$P(^VA(200,$P(AMHTPR,U,4),0),U),1:"????")
DONE D DONE^AMHLEIN,^AMHEKL
 K ^XTMP("AMHLETR1",AMHJOB,AMHBTH),AMHJOB,AMHBTH
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEAD ;
 I 'AMHPG G HEAD1
 NEW X
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
HEAD1 ;EP
 S AMHPG=AMHPG+1
 W:$D(IOF) @IOF
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page 1 ",!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W ?13,"LISTING OF TREATMENT PLANS DUE TO BE REVIEWED",!
 W ?20,"Date Range: ",AMHBDD," to ",AMHEDD,!
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011.56,.17,AMHPROG) W $$CTR(X),!
 I $G(AMHTHER) S X="Responsible Provider:  "_$P(^VA(200,AMHTHER,0),U) W $$CTR(X),!
 W !,"PATIENT NAME",?23,"DOB",?33,"CHART #",?41,"DATE",?54,"REVIEW DATE",?68,"ANTICIPATED"
 W !?41,"ESTABLISHED",?68,"COMPLETION",!?68,"DATE"
 W !
 W AMH80D,!
 Q

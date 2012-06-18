AMHLETR2 ; IHS/CMI/LAB - print report of tps needing resolved ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;fixed potential undef
 ;
 ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "**********  LIST TREATMENT PLANS  **********",!!
 W "This report will list all patients who have a treatment plan on file."
 D DBHUSRP^AMHUTIL
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range during which the treatment plan was established.",!
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
 G:$D(DIRUT) XIT
 G:Y="A" SORT
 S DIC("A")="Which Designated Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I X="" G THER
 I Y<0 G THER
 S AMHTHER=+Y
SORT ;
 S AMHSORT=""
 S DIR(0)="S^P:Responsible Provider;N:Patient Name;D:Date Established",DIR("A")="Sort list by",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G THER
 S AMHSORT=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G THER
ZIS ;
 S XBRC="PROC^AMHLETR2",XBRP="PRINT^AMHLETR2",XBNS="AMH",XBRX="XIT^AMHLETR2"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("AMH")
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
 Q:$P(X,U,2)=""  ;no patient
 Q:'$$ALLOWP^AMHUTIL(DUZ,$P(X,U,2))
 Q:$$DEMO^AMHUTIL1($P(X,U,2),$G(AMHDEMO))
 Q:'$$ALLOWTP^AMHLETP(DUZ,AMHTP)
 I $G(AMHTHER),$P(X,U,4)'=AMHTHER Q
 I AMHPROG]"",$P(X,U,17)'=AMHPROG Q
 D @AMHSORT
 I $P(X,U,1)]"",$P(X,U,1)'<AMHBD,$P(X,U,1)'>AMHED S ^XTMP("AMHLETR2",AMHJOB,AMHBTH,AMHSORTV,AMHTP)=""
 Q
P ;
 S AMHSORTV=$P(X,U,4)
 I AMHSORTV S AMHSORTV=$P(^VA(200,AMHSORTV,0),U) Q
 S AMHSORTV="--"
 Q
N ;
 S P=$P(^AMHPTXP(AMHTP,0),U,2)
 I P="" S AMHSORVT="--" Q
 S AMHSORTV=$P(^DPT(P,0),U)
 I AMHSORTV="" S AMHSORTV="--"
 Q
D ;
 S AMHSORTV=$P(^AMHPTXP(AMHTP,0),U,1)
 I AMHSORTV="" S AMHSORTV="--" Q
 Q
PRINT ;EP
 S AMH80D="-------------------------------------------------------------------------------",AMHQUIT=0,AMHPG=0
 D HEAD
 I '$D(^XTMP("AMHLETR2",AMHJOB,AMHBTH)) W !!,"NO DATA TO REPORT" G DONE
 S AMHSORTV="" F  S AMHSORTV=$O(^XTMP("AMHLETR2",AMHJOB,AMHBTH,AMHSORTV)) Q:AMHSORTV=""!(AMHQUIT)  D PRT2
 D DONE
 Q
PRT2 ;
 S AMHTP=0 F  S AMHTP=$O(^XTMP("AMHLETR2",AMHJOB,AMHBTH,AMHSORTV,AMHTP)) Q:AMHTP'=+AMHTP!(AMHQUIT)  D
 .I $Y>(IOSL-4) D HEAD Q:AMHQUIT
 .S AMHTPR=^AMHPTXP(AMHTP,0)
 .S Y=$P(AMHTPR,U,2) I Y D ^AUPNPAT
 .W !,$S($P(AMHTPR,U,2):$P(^DPT($P(AMHTPR,U,2),0),U),1:"????"),?23,$$FMTE^XLFDT(AUPNDOB,"2D"),?33,$S($P($G(^AUPNPAT($P(AMHTPR,U,2),41,DUZ(2),0)),U,2):$P(^AUPNPAT($P(AMHTPR,U,2),41,DUZ(2),0),U,2),1:"???")
 .W ?41,$$FMTE^XLFDT($P(AMHTPR,U,1)),?54,$$FMTE^XLFDT($P(AMHTPR,U,9)),?68,$$FMTE^XLFDT($P(AMHTPR,U,3))
 .W !?3,"Program: ",$$VAL^XBDIQ1(9002011.56,AMHTP,.17),?33,"Responsible Provider: ",$S($P(AMHTPR,U,4):$P(^VA(200,$P(AMHTPR,U,4),0),U),1:"????")
 Q
DONE D DONE^AMHLEIN,^AMHEKL
 K ^XTMP("AMHLETR2",AMHJOB,AMHBTH),AMHJOB,AMHBTH
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
 W !?13,"**********  CONFIDENTIAL PATIENT INFORMATION  **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page 1 ",!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 S X="LISTING OF TREATMENT PLANS" W $$CTR(X),!
 W ?20,"Date Established: ",AMHBDD," to ",AMHEDD,!
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011.56,.17,AMHPROG) W $$CTR(X),!
 I $G(AMHTHER) S X="Responsible Provider:  "_$P(^VA(200,AMHTHER,0),U) W $$CTR(X),!
 W !,"PATIENT NAME",?23,"DOB",?33,"CHART #",?41,"DATE",?54,"REVIEW DATE",?68,"ANTICIPATED"
 W !?41,"ESTABLISHED",?68,"COMPLETION",!?68,"DATE"
 W !
 W AMH80D,!
 Q

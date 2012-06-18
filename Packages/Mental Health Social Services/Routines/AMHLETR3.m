AMHLETR3 ; IHS/CMI/LAB - print report of tps needing resolved ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "**********  LIST CASES OPENED WITH NO TREATMENT PLAN IN PLACE **********",!!
 W "This report will list all patients who have a case open date,"
 W !,"no case closed date and no treatment plan in place."
 W !
 I '$D(^AMHSITE(DUZ(2),16,DUZ)) D
 .W !,"This report will only include Cases on which you are the documented"
 .W !,"provider.",!!
 D DBHUSRP^AMHUTIL
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range during which the case was opened.",!
 W ! S DIR(0)="D^::EP",DIR("A")="Enter BEGINNING Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_"::E",DIR("A")="Enter ENDING Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
PROG ;
 W !!,"You can limit the report output to cases opened by one or all Programs",!
 S AMHPROG="" W ! S DIR(0)="S^O:One Program;A:All Programs",DIR("A")="List cases opened by",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) BD
 G:Y="A" THER
 K DIR S DIR(0)="9002011,.02",DIR("A")="Review Cases opened by which Program" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROG
 S AMHPROG=Y
THER ;
 W !!,"You can limit the report output to cases opened by one or all Providers",!
 S AMHPROV="" W ! S DIR(0)="S^O:One Provider;A:All Providers",DIR("A")="List cases opened by",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:Y="A" SORT
 S DIC("A")="Which Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I X="" G THER
 I Y<0 G THER
 S AMHPROV=+Y
SORT ;
 S AMHSORT=""
 S DIR(0)="S^P:Responsible Provider;N:Patient Name;C:Case Open Date",DIR("A")="Sort list by",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G THER
 S AMHSORT=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G SORT
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="PROC^AMHLETR3",XBRP="PRINT^AMHLETR3",XBNS="AMH",XBRX="XIT^AMHLETR3"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("AMH")
 K DFN
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHLETR3"")"
 S XBNS="AMH",XBRC="PROC^AMHLETR3",XBRX="XIT^AMHLETR3",XBIOP=0 D ^XBDBQUE
 Q
PROC ;EP - entry point for processing
 S AMHJOB=$J,AMHBTH=$H,AMHTOT=0,AMHCASE=0,AMHBT=$H
 F  S AMHCASE=$O(^AMHPCASE(AMHCASE)) Q:AMHCASE'=+AMHCASE  D PROC1
 S AMHET=$H
 K AMHCASE
 Q
PROC1 ;
 Q:'$$ALLOWCD^AMHLCD(DUZ,AMHCASE)
 S DFN=$P(^AMHPCASE(AMHCASE,0),U,2)
 Q:DFN=""
 Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 Q:$P(^AMHPCASE(AMHCASE,0),U,5)]""  ;CLOSED
 I AMHPROV,$P(^AMHPCASE(AMHCASE,0),U,8)'=AMHPROV Q  ;not this provider
 S AMHCPRV=$P(^AMHPCASE(AMHCASE,0),U,8)
 S AMHCPRG=$P(^AMHPCASE(AMHCASE,0),U,3)
 I AMHPROG]"",AMHCPRG'=AMHPROG Q  ;not a program of interest
 S AMHOD=$P(^AMHPCASE(AMHCASE,0),U)
 I AMHOD<AMHBD Q
 I AMHOD>AMHED Q
 ;is there a tp in place???
 Q:$$TP(AMHOD,DFN,AMHCPRV,AMHCPRG)  ;has a tp
 D @AMHSORT
 S ^XTMP("AMHLETR3",AMHJOB,AMHBTH,AMHSORTV,AMHCASE)=""
 Q
TP(DATE,PAT,PROV,PRG) ;
 I '$D(^AMHPTXP("AC",PAT)) Q 0  ;no tp's
 NEW C,X,G
 S G=0
 S X=0 F  S X=$O(^AMHPTXP("AC",PAT,X)) Q:X'=+X  D
 .Q:$P(^AMHPTXP(X,0),U,17)'=PRG
 .Q:$P(^AMHPTXP(X,0),U,4)'=PROV
 .Q:'$$ALLOWTP^AMHLETP(DUZ,X)
 .I $P(^AMHPTXP(X,0),U,12)]"",$P(^AMHPTXP(X,0),U,12)<DATE Q  ;closed before this case opened
 .Q:$P(^AMHPTXP(X,0),U)<DATE
 .Q:$P(^AMHPTXP(X,0),U,15)="I"
 .S G=1
 .Q
 Q G
P ;
 S AMHSORTV=$P(^AMHPCASE(AMHCASE,0),U,8)
 I AMHSORTV S AMHSORTV=$P(^VA(200,AMHSORTV,0),U) Q
 S AMHSORTV="--"
 Q
N ;
 S P=$P(^AMHPCASE(AMHCASE,0),U,2)
 I P="" S AMHSORVT="--" Q
 S AMHSORTV=$P(^DPT(P,0),U)
 I AMHSORTV="" S AMHSORTV="--"
 Q
C ;
 S AMHSORTV=$P(^AMHPCASE(AMHCASE,0),U,1)
 I AMHSORTV="" S AMHSORTV="--" Q
 Q
PRINT ;EP
 S AMHPG=0 S AMHQUIT=0
 D HEAD
 I '$D(^XTMP("AMHLETR3",AMHJOB,AMHBTH)) W !!,"NO DATA TO REPORT" G DONE
 S AMHSORTV="" F  S AMHSORTV=$O(^XTMP("AMHLETR3",AMHJOB,AMHBTH,AMHSORTV)) Q:AMHSORTV=""!(AMHQUIT)  D PRT2
 D DONE
 Q
PRT2 ;
 S AMHCASE=0 F  S AMHCASE=$O(^XTMP("AMHLETR3",AMHJOB,AMHBTH,AMHSORTV,AMHCASE)) Q:AMHCASE'=+AMHCASE!(AMHQUIT)  D
 .I $Y>(IOSL-4) D HEAD Q:AMHQUIT
 .S DFN=$P(^AMHPCASE(AMHCASE,0),U,2)
 .W !,$E($P(^DPT(DFN,0),U),1,21),?23,$$HRN^AUPNPAT(DFN,DUZ(2))
 .W ?31,$$D($P(^AMHPCASE(AMHCASE,0),U)),?41,$E($$VAL^XBDIQ1(9002011.58,AMHCASE,.03),1,10)
 .W ?53,$E($$VAL^XBDIQ1(9002011.58,AMHCASE,.08),1,15)
 .W ?72,$$D($$LVD^AMHDPEE(DFN,"ID"))
 Q
DONE ;
 K ^XTMP("AMHLETR3",AMHJOB,AMHBTH),AMHJOB,AMHBTH
 Q
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
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
 S X="LISTING OF CASES OPENED WITH NO TREATMENT PLAN IN PLACE" W $$CTR(X),!
 S X="Case Open Dates: "_AMHBDD_" to "_AMHEDD W $$CTR(X,80),!
 I $G(AMHPROV) S X="Responsible Provider:  "_$P(^VA(200,AMHPROV,0),U) W $$CTR(X),!
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011,.02,AMHPROG) W $$CTR(X),!
 W !,"PATIENT NAME",?23,"HRN",?31,"CASE OPEN",?41,"PROGRAM",?53,"PROVIDER",?70,"LAST VISIT"
 W !?31,"DATE",! W $$REPEAT^XLFSTR("-",80),!
 Q

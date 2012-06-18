AMHRPEC ; IHS/CMI/LAB - ACTIVE CLIENT LIST ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "**********  DURATION OF CARE REPORT  **********",!!
 W "This report will produce a list of all closed cases in a date"
 W !,"range that you specify.  In order to be included in this report"
 W !,"the case must have both a case open and a case closed date."
 W !,"The duration of care is calculated by counting the number of days"
 W !,"from the case open date to the case closed date."
 W !!,"Cases may be selected based on Open date, Closed date or both."
 W !,"Only those cases falling within the specified time frame will be"
 W !,"counted."
 W !!
 I '$D(^AMHSITE(DUZ(2),16,DUZ)) D
 .W !,"This report will only include Cases on which you are the documented"
 .W !,"provider.",!!
 D DBHUSRP^AMHUTIL
 D XIT
DATES K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR G:Y<1 XIT S AMHBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR G:Y<1 XIT  S AMHED=Y
 ;
 I AMHED<AMHBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S AMHSD=$$FMADD^XLFDT(AMHBD,-1)_".9999"
WHICH ;
 S (AMHOPEN,AMHCLOSE)=""
 S DIR(0)="S^O:Cases OPENED in that Date Range;C:Cases CLOSED in that Date Range;B:Cases either opened or closed in that Date Range"
 S DIR("A")="Please Select which Dates should be Used",DIR("B")="B" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="O" S AMHOPEN=1
 I Y="C" S AMHCLOSE=1
 I Y="B" S (AMHOPEN,AMHCLOSE)=1
PROG ;
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) WHICH
 I Y="A" G PROV
 S DIR(0)="9002011.58,.03",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
PROV ;
 W !
 S AMHPROV=""
 S DIR(0)="S^A:All Providers;O:One Provider",DIR("A")="Include cases opened by",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 I Y="A" G PAGE
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC
 K DIC,DA
 I Y=-1 G PROV
 S AMHPROV=+Y
 G ZIS
PAGE ;
 S AMHNPAG=0,DIR(0)="Y",DIR("A")="Do you want each Provider on a separate page",DIR("B")="N" K DA D ^DIR K DIR
 G:$D(DIRUT) PROV
 S AMHNPAG=Y
ZIS ;
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G PROV
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="PROC^AMHRPEC",XBRP="PRINT^AMHRPEC",XBNS="AMH",XBRX="XIT^AMHRPEC"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("AMH")
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHRPEC"")"
 S XBNS="AMH",XBRC="PROC^AMHRPEC",XBRX="XIT^AMHRPEC",XBIOP=0 D ^XBDBQUE
 Q
PROC ;EP - entry point for processing
 S AMHJOB=$J,AMHBTH=$H,AMHTOT=0,AMHTDAYS=0,AMHBT=$H,AMHCASE=0
 K AMHSUB
 D XTMP^AMHUTIL("AMHRPEC","BH - DURATION OF CARE REPORT")
 F  S AMHCASE=$O(^AMHPCASE(AMHCASE)) Q:AMHCASE'=+AMHCASE  D PROC1
 S AMHET=$H
 K AMHCASE
 Q
PROC1 ;
 I '$$ALLOWCD^AMHLCD(DUZ,AMHCASE) Q  ;not allowed this case
 Q:$P(^AMHPCASE(AMHCASE,0),U,5)=""  ;NO CLOSED DATE
 I AMHPROV,$P(^AMHPCASE(AMHCASE,0),U,8)'=AMHPROV Q  ;not this provider
 I AMHPROG]"",$P(^AMHPCASE(AMHCASE,0),U,3)'=AMHPROG Q  ;not this program
 S AMHOD=$P(^AMHPCASE(AMHCASE,0),U)
 S AMHCD=$P(^AMHPCASE(AMHCASE,0),U,5)
 Q:'$$CD(AMHOD,AMHCD,AMHOPEN,AMHCLOSE)
 S DFN=$P(^AMHPCASE(AMHCASE,0),U,2)
 Q:'DFN
 Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 S AMHTOT=AMHTOT+1
 S X=$$FMDIFF^XLFDT(AMHCD,AMHOD)
 S AMHTDAYS=AMHTDAYS+X
 S AMHX=$$VAL^XBDIQ1(9002011.58,AMHCASE,.08) I AMHX="" S AMHX="UNKNOWN PROVIDER"
 S ^XTMP("AMHRPEC",AMHJOB,AMHBTH,"CASES",AMHX,AMHOD,AMHCASE)=$$FMDIFF^XLFDT(AMHCD,AMHOD)
 S AMHSUB(AMHX)=$G(AMHSUB(AMHX))+1,AMHSUBD(AMHX)=$G(AMHSUBD(AMHX))+$$FMDIFF^XLFDT(AMHCD,AMHOD)
 Q
 ;
CD(O,C,WO,WC) ;
 I WO,O'<AMHBD,O'>AMHED Q 1
 I WC,C'<AMHBD,C'>AMHED Q 1
 Q 0
PRINT ;
 S X1=DT,X2=-365 D C^%DTC S AMHBD=X,AMHED=DT
 S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 S AMH80D="-------------------------------------------------------------------------------"
 S AMHPG=0
 I '$D(^XTMP("AMHRPEC",AMHJOB,AMHBTH)) W !!,"NO CASES TO REPORT" G DONE
 K AMHQ S AMHCNT=0
 S AMHPROV="" F  S AMHPROV=$O(^XTMP("AMHRPEC",AMHJOB,AMHBTH,"CASES",AMHPROV)) Q:AMHPROV=""!($D(AMHQ))  D
 .S AMHSUB=0,AMHCNT=AMHCNT+1
 .I AMHCNT=1!($G(AMHNPAG)) D HEAD
 .S AMHDATE="" F  S AMHDATE=$O(^XTMP("AMHRPEC",AMHJOB,AMHBTH,"CASES",AMHPROV,AMHDATE)) Q:AMHDATE=""!($D(AMHQ))  D
 ..S AMHCASE=0 F  S AMHCASE=$O(^XTMP("AMHRPEC",AMHJOB,AMHBTH,"CASES",AMHPROV,AMHDATE,AMHCASE)) Q:AMHCASE'=+AMHCASE!($D(AMHQ))  D PRINT1
 .I $Y>(IOSL-5) D HEAD Q:$D(AMHQ)
 .W !!,"Total Number of Cases for "_AMHPROV_": ",AMHSUB(AMHPROV),!
 .W "Average Duration of Care: ",$J((AMHSUBD(AMHPROV)/AMHSUB(AMHPROV)),8,2)," days",!!
 G:$D(AMHQ) DONE
 I $Y>(IOSL-5) D HEAD Q:$D(AMHQ)
 W !!,"Total Number of Cases: ",AMHTOT,!
 W "Average Duration of Care: ",$J((AMHTDAYS/AMHTOT),8,2)," days",!!
DONE ;
 K ^XTMP("AMHRPEC",AMHJOB,AMHBTH),AMHJOB,AMHBTH
 Q
PRINT1 ;
 I $Y>(IOSL-3) D HEAD Q:$D(AMHQ)
 S AMHX=^AMHPCASE(AMHCASE,0)
 S DFN=$P(AMHX,U,2)
 W !,$E($P(^DPT(DFN,0),U),1,15),?18,$$HRN^AUPNPAT(DFN,DUZ(2))
 S Y=$P(AMHX,U) W ?25,$E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 S Y=$P(AMHX,U,5) I Y]"" W ?35,$E(Y,4,5),"/",$E(Y,6,7),"/",$E(Y,2,3)
 W ?47,^XTMP("AMHRPEC",AMHJOB,AMHBTH,"CASES",AMHPROV,AMHDATE,AMHCASE)_" days"
 W ?57,$$VAL^XBDIQ1(9002011.58,AMHCASE,.09)
 W ?65,$E($$VAL^XBDIQ1(9002011.58,AMHCASE,.08),1,14)
 Q
HEAD I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 S X="********** CONFIDENTIAL PATIENT INFORMATION **********" W !,$$CTR(X,80)
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",AMHPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 S X="Case Dates: "_AMHBDD_" to "_AMHEDD W $$CTR(X,80),!
 S X="DURATION OF CARE REPORT" W $$CTR(X,80)
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011.58,.03,AMHPROG) W !,$$CTR(X,80)
PIH W !,"PATIENT NAME",?18,"CHART",?25,"CASE OPEN",?35,"CASE CLOSED",?47,"DURATION",?57,"POV",?65,"PROVIDER"
 W !?18,"NUMBER",?25,"DATE",?35,"DATE"
 W !,$$REPEAT^XLFSTR("-",80),!
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
D(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------

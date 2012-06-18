AMHRNOAT ; IHS/CMI/LAB - report of a patient's no show visits ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 S X="LISTING OF EHR VISITS WITH NO ACTIVITY TIME" W !,$$CTR^AMHLEIN(X,80)
 W !!,"This option will print a list of visits created through EHR/PCC "
 W !,"that do not have an Activity time. The user will be able to specify "
 W !,"the date range and whether to include all visits or just those visits"
 W !,"for one provider.",!
 D DBHUSR^AMHUTIL
GETDATES ;
 W !!,"Please enter the date range."
BD ;get beginning date
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter Ending Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
PROV ;
 S AMHPROV=""
 S DIR(0)="S^A:All Providers;O:One Provider",DIR("A")="Include visits for",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G SORT
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC
 K DIC,DA
 I Y=-1 G PROV
 S AMHPROV=+Y
SORT ;
 S AMHSORT=""
 S DIR(0)="S^P:Patient Name;D:Date of Visit",DIR("A")="How would you like the report sorted",DIR("B")="P" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROV
 S AMHSORT=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G SORT
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^AMHRNOAT",XBRC="PROC^AMHRNOAT",XBNS="AMH*",XBRX="XIT^AMHRNOAT"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHRNOAT"")"
 S XBNS="AMH",XBRC="PROC^AMHRNOAT",XBRX="XIT^AMHRNOAT",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all visits in date range and look for problem 8-8.9 or visit type of N
 S AMHJOB=$J,AMHTOT=0,AMHBT=$H,AMHPTOT=0
 D XTMP^AMHUTIL("AMHRNOAT","BH - NO ACTIVITY TIME VISITS")
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 S AMHODAT=AMHSD_".9999" F  S AMHODAT=$O(^AMHREC("B",AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)  D
 .S AMHR=0 F  S AMHR=$O(^AMHREC("B",AMHODAT,AMHR)) Q:AMHR'=+AMHR  D
 ..I AMHPROV,$$PPINT^AMHUTIL(AMHR)'=AMHPROV Q
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHR)
 ..S DFN=$P(^AMHREC(AMHR,0),U,8) Q:'DFN
 ..Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 ..Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 ..I $P(^AMHREC(AMHR,0),U,12) Q
 ..D SET
 ..Q
 .Q
 Q
SET ;
 S ^XTMP("AMHRNOAT",AMHJOB,AMHBT,"NO AT",$S(AMHSORT="P":$P(^DPT(DFN,0),U),1:(9999999-$P(AMHODAT,"."))),AMHR)="",AMHTOT=AMHTOT+1
 I $D(^XTMP("AMHRNOAT",AMHJOB,AMHBT,"PATIENTS",DFN)) Q
 S AMHPTOT=AMHPTOT+1
 S ^XTMP("AMHRNOAT",AMHJOB,AMHBT,"PATIENTS",DFN)=""
 Q
PRINT ;EP - called from xbdbque
 D PRINT1
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("AMHRNOAT",AMHJOB,AMHBT),AMHJOB,AMHBT
 Q
PRINT1 ;
 K AMHQ S AMHPG=0
 I '$D(^XTMP("AMHRNOAT",AMHJOB,AMHBT,"NO AT")) D HEADER W !!,"There were no visits without an activity time during the time period.",! Q
 D HEADER
 S AMHSORT="" F  S AMHSORT=$O(^XTMP("AMHRNOAT",AMHJOB,AMHBT,"NO AT",AMHSORT)) Q:AMHSORT=""!($D(AMHQ))  D
 .S AMHR=0 F  S AMHR=$O(^XTMP("AMHRNOAT",AMHJOB,AMHBT,"NO AT",AMHSORT,AMHR)) Q:AMHR'=+AMHR!($D(AMHQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 ..S DFN=$P(^AMHREC(AMHR,0),U,8)
 ..W !,$E($P(^DPT(DFN,0),U),1,18),?20,$$HRN^AUPNPAT(DFN,DUZ(2)),?27,$$FMTE^XLFDT($P(^AMHREC(AMHR,0),U)),?46,$E($$PPNAME^AMHUTIL(AMHR),1,12)
 ..W ?59,$$PRIMPOV^AMHUTIL1(AMHR,"C")_"-"
 ..S X=$$PRIMPOV^AMHUTIL1(AMHR,"I") I X W $E($P(^AMHPROB(X,0),U,2),1,14)
 .Q
 Q:$D(AMHQ)
 I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 W !!,"Total # of Patients: ",AMHPTOT,"     Total # of Visits: ",AMHTOT,!
 Q
XIT ;
 D EN^XBVK("AMH")
 D KILL^AUPNPAT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEADER ;EP
 I 'AMHPG G HEADER1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",AMHPG,!
 S AMHTEXT="Behaviorial Health Visits with No Activity Time"
 W !?(80-$L(AMHTEXT)/2),AMHTEXT,!
 S AMHTEXT="Visit Dates:  "_AMHBDD_" - "_AMHEDD
 W ?(80-$L(AMHTEXT)/2),AMHTEXT,!
 I AMHPROV S X="Provider: "_$P(^VA(200,AMHPROV,0),U) W $$CTR^AMHLEIN(X,80),!
 W !,"PATIENT NAME",?20,"HRN",?27,"DATE/TIME",?46,"PROVIDER",?59,"POV"
 W !,$TR($J(" ",80)," ","-")
 Q

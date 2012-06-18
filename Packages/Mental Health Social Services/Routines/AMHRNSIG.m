AMHRNSIG ; IHS/CMI/LAB - report of visits with no esig ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 S X="BEHAVIORAL HEALTH UNSIGNED PROGRESS NOTES" W !,$$CTR^AMHLEIN(X,80)
 W !!,"This report will display a list of all encounter records containing"
 W !,"unsigned SOAP/Progress Notes in a date range specified by the user.  After"
 W !,"the report is displayed, the user will have the option of affixing an"
 W !,"electronic signature to an unsigned SOAP/Progress Note."
 ;I '$P($G(^AMHSITE(DUZ(2),18)),U,6) W !!,"Electronic Signature is not turned on at your facilty.  You",!,"cannot run this report.",! D PAUSE^AMHLEA Q
 ;I '$P($G(^AMHSITE(DUZ(2),18)),U,7) W !!,"An Electronic Signature start date has not been recorded.  You",!,"cannot run this report.",! D PAUSE^AMHLEA Q
 S D=$$DATE^AMHESIG()
 W !!,"ESIG was implemented on ",$$FMTE^XLFDT(D),".  Only visits after this date will"
 W !,"display on this report.",!
 D DBHUSR^AMHUTIL
GETDATES ;
 W !!,"Please enter the range of dates for the Unsigned visits"
BD ;get beginning date
 S DIR(0)="D^"_$$DATE^AMHESIG()_",:DT:EP",DIR("A")="Enter Beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter Ending Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
PROG ;
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G PROV
 S DIR(0)="9002011,.02",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
PROV ;
 S AMHPROV=""
 S DIR(0)="S^A:All Providers;O:One Provider",DIR("A")="Include cases opened by",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) PROG
 I Y="A" G SORT
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC
 K DIC,DA
 I Y=-1 G PROV
 S AMHPROV=+Y
SORT ;
 S AMHSORT=""
 S DIR(0)="S^P:Patient Name;D:Date of Visit;R:Primary Provider",DIR("A")="How would you like the report sorted",DIR("B")="P" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROV
 S AMHSORT=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G SORT
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^AMHRNSIG",XBRC="PROC^AMHRNSIG",XBNS="AMH*",XBRX="XIT^AMHRNSIG"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHRNSIG"")"
 S XBNS="AMH",XBRC="PROC^AMHRNSIG",XBRX="XIT^AMHRNSIG",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all visits in date range and look for problem 8-8.9 or visit type of N
 S AMHJOB=$J,AMHTOT=0,AMHBT=$H,AMHPTOT=0
 D XTMP^AMHUTIL("AMHRNSIG","BH - NO ESIG")
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 S AMHODAT=AMHSD_".9999" F  S AMHODAT=$O(^AMHREC("B",AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)  D
 .S AMHR=0 F  S AMHR=$O(^AMHREC("B",AMHODAT,AMHR)) Q:AMHR'=+AMHR  D
 ..I AMHPROG]"",$P(^AMHREC(AMHR,0),U,2)'=AMHPROG Q
 ..I AMHPROV,$$PPINT^AMHUTIL(AMHR)'=AMHPROV Q
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHR)
 ..S DFN=$P(^AMHREC(AMHR,0),U,8) Q:'DFN
 ..Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 ..Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 ..;if any dx is 8 then do set and q
 ..Q:$P($G(^AMHREC(AMHR,11)),U,12)]""  ;already signed
 ..S ^XTMP("AMHRNSIG",AMHJOB,AMHBT,"VISITS",$$SORTVAL(AMHR,AMHSORT),AMHR)="",AMHTOT=AMHTOT+1
 ..Q
 .Q
 Q
 ;
SORTVAL(R,V) ;
 NEW G
 I V="P" D  Q G
 .S G=$P(^AMHREC(R,0),U,8) I G S G=$P($G(^DPT(G,0)),U)
 .I G="" S G="--"
 I V="R" S G=$$PPNAME^AMHUTIL(R) S:G="" G="--" Q G
 I V="D" Q $P(^AMHREC(R,0),U)
 Q ""
PRINT ;EP - called from xbdbque
 D PRINT1
 K ^XTMP("AMHRNSIG",AMHJOB,AMHBT)
 Q
PRINT1 ;
 K AMHQ S AMHPG=0
 I '$D(^XTMP("AMHRNSIG",AMHJOB,AMHBT,"VISITS")) D HEADER W !!,"There were no Unsigned Encounter Records during the time period.",! Q
 D HEADER
 S AMHSORT="" F  S AMHSORT=$O(^XTMP("AMHRNSIG",AMHJOB,AMHBT,"VISITS",AMHSORT)) Q:AMHSORT=""!($D(AMHQ))  D
 .S AMHR=0 F  S AMHR=$O(^XTMP("AMHRNSIG",AMHJOB,AMHBT,"VISITS",AMHSORT,AMHR)) Q:AMHR'=+AMHR!($D(AMHQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 ..S DFN=$P(^AMHREC(AMHR,0),U,8)
 ..W !,$E($P(^DPT(DFN,0),U),1,25),?27,$$HRN^AUPNPAT(DFN,DUZ(2)),?34,$$FMTE^XLFDT($P(^AMHREC(AMHR,0),U)),?53,$E($$PPNAME^AMHUTIL(AMHR),1,18)
 ..W ?73,$E($$VAL^XBDIQ1(9002011,AMHR,.02),1,1)
 ..W ?76,$E($$VAL^XBDIQ1(9002011,AMHR,.34),1,1)
 .Q
 Q:$D(AMHQ)
 I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 W !!,"Total # of Unsigned Visits: ",AMHTOT,!
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
 S AMHTEXT="UNSIGNED ENCOUNTER RECORDS"
 W !?(80-$L(AMHTEXT)/2),AMHTEXT,!
 S AMHTEXT="Date Range:  "_AMHBDD_" and "_AMHEDD
 W ?(80-$L(AMHTEXT)/2),AMHTEXT,!
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011,.02,AMHPROG) W $$CTR^AMHLEIN(X,80),!
 I AMHPROV S X="Provider: "_$P(^VA(200,AMHPROV,0),U) W $$CTR^AMHLEIN(X,80),!
 W !,"PATIENT NAME",?27,"HRN",?34,"DATE/TIME",?53,"PROVIDER",?73,"PG",?76,"GRP"
 W !,$TR($J(" ",80)," ","-")
 Q

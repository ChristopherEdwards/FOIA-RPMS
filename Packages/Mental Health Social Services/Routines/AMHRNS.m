AMHRNS ; IHS/CMI/LAB - report of a patient's no show visits ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 W !!,"This option will print a list of one patient's no show visits.",!
 D DBHUSR^AMHUTIL
GETPAT ;
 S DFN=""
 W !
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y<0 D XIT Q
 S (DFN,AMHPAT)=+Y
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 I AMHPAT,'$$ALLOWP^AMHUTIL(DUZ,AMHPAT) D NALLOWP^AMHUTIL D PAUSE^AMHLEA G GETPAT
GETDATES ;
 W !!,"Please enter the range of dates for the No Show visits"
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter ending Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
PROG ;select program to run report for
 S AMHPROG=""
 S DIR(0)="S^M:MENTAL HEALTH;S:SOCIAL SERVICES;C:CHEMICAL DEPENDENCY or ALCOHOL/SUBSTANCE ABUSE;O:OTHER;A:ALL",DIR("A")="List No Show for which Program",DIR("B")="M" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) BD
 S AMHPROG=Y,AMHPROG=$S(AMHPROG="A":"",1:AMHPROG)
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^AMHRNS",XBRC="PROC^AMHRNS",XBNS="AMH*",XBRX="XIT^AMHRNS"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHRNS"")"
 S XBNS="AMH",XBRC="PROC^AMHRNS",XBRX="XIT^AMHRNS",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all visits in date range and look for problem 8-8.9 or visit type of N
 S AMHJOB=$J,AMHTOT=0,AMHBT=$H
 D XTMP^AMHUTIL("AMHRNS","BH - NO SHOW FOR PATIENT")
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 S AMHODAT=AMHSD_".9999" F  S AMHODAT=$O(^AMHREC("AF",AMHPAT,AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)  D
 .S AMHR=0 F  S AMHR=$O(^AMHREC("AF",AMHPAT,AMHODAT,AMHR)) Q:AMHR'=+AMHR  D
 ..I AMHPROG]"",$P(^AMHREC(AMHR,0),U,2)'=AMHPROG Q
 ..;if any dx is 8 then do set and q
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHR)
 ..Q:'$$ALLOWP^AMHUTIL(DUZ,$P(^AMHREC(AMHR,0),U,8))
 ..S (AMHX,AMHDNKA)=0 F  S AMHX=$O(^AMHRPRO("AD",AMHR,AMHX)) Q:AMHX'=+AMHX!(AMHDNKA)  D
 ...I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8 S AMHDNKA=1 D SET Q  ;do not pass dnka
 ...I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.1 S AMHDNKA=1 D SET Q  ;do not pass dnka
 ...I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.11 S AMHDNKA=1 D SET Q  ;do not pass dnka
 ...I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.2 S AMHDNKA=1 D SET Q  ;do not pass dnka
 ...I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.21 S AMHDNKA=1 D SET Q
 ...I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.3 S AMHDNKA=1 D SET Q  ;do not pass dnka
 ...I $P(^AMHREC(AMHR,0),U,33)="N" D SET Q
 ...Q
 ..Q
 .Q
 Q
SET ;
 S ^XTMP("AMHRNS",AMHJOB,AMHBT,"NO SHOWS",AMHR)="",AMHTOT=AMHTOT+1
 Q
PRINT ;EP - called from xbdbque
 K AMHQ S AMHPG=0
 I '$D(^XTMP("AMHRNS",AMHJOB,AMHBT,"NO SHOWS")) D HEADER W !!,"There were no NO SHOW visits for this patient during the time period.",! Q
 D HEADER
 S AMHR=0 F  S AMHR=$O(^XTMP("AMHRNS",AMHJOB,AMHBT,"NO SHOWS",AMHR)) Q:AMHR'=+AMHR!($D(AMHQ))  D
 .I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 .W !!,$$FMTE^XLFDT($P(^AMHREC(AMHR,0),U)),?25,$E($$PPNAME^AMHUTIL(AMHR),1,20),?45,$E($$VAL^XBDIQ1(9002011,AMHR,.02),1,7)
 .W ?53,$$PRIMPOV^AMHUTIL1(AMHR,"C"),"-"
 .S X=$$PRIMPOV^AMHUTIL1(AMHR,"I") I X W $E($P(^AMHPROB(X,0),U,2),1,20)
 .Q
 W !!,"Total # of No Show Visits: ",AMHTOT,!
 K ^XTMP("AMHRNS",AMHJOB,AMHBT)
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
 S AMHTEXT="BEHAVIORAL HEALTH NO SHOW REPORT FOR "_$P(^DPT(AMHPAT,0),U)
 W !?(80-$L(AMHTEXT)/2),AMHTEXT,!
 S AMHTEXT="Appointment Dates:  "_AMHBDD_" and "_AMHEDD
 W ?(80-$L(AMHTEXT)/2),AMHTEXT,!
 ;S X=$P(^DPT(AMHPAT,0),U) W !,$$CTR(X,80),!
 W $TR($J(" ",80)," ","=")
 W !," DATE",?25,"PROVIDER",?45,"PROGRAM",?53,"POV"
 W !,$TR($J(" ",80)," ","-")
 Q

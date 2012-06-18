AMHRPS ; IHS/CMI/LAB - SUICIDE REPORT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 K AMHQUIT
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 I '$D(AMHTITLE) W !!,$C(7),$C(7),"Report type missing!",! K AMHQUIT Q
 D INFORM
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range during which the patient should have been seen ",!,"with one of these problems.",!
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter Ending Visit Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 ;
AGEGRP ;GET AGE GROUPS
 W !!
 D SETBIN
BIN ;
 W !,"The Age Groups to be used are currently defined as:",! D LIST
 S DIR(0)="YO",DIR("A")="Do you wish to modify these age groups" D ^DIR K DIR
 I $D(DIRUT) S AMHQUIT="" G BD
 I Y=0 G ZIS
RUN ;
 K AMHQUIT S AMHRY="",AMHRA=-1 W ! F  D AGE Q:AMHRX=""  I $D(AMHQUIT) G BIN
 D CLOSE I $D(AMHQUIT) G BIN
 D LIST
 G BIN
 ;
AGE ;
 S AMHRX=""
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the starting age of the "_$S(AMHRY="":"first",1:"next")_" age group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S AMHQUIT="" Q
 S AMHRX=Y
 I Y="" Q
 I AMHRX?1.3N,AMHRX>AMHRA D SET Q
 W $C(7) W !,"Make sure the age is higher the beginning age of the previous group.",! G RUN
 ;
SET S AMHRA=AMHRX
 I AMHRY="" S AMHRY=AMHRX Q
 S AMHRY=AMHRY_"-"_(AMHRX-1)_";"_AMHRX
 Q
 ;
CLOSE I AMHRY="" Q
GC ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the highest age for the last group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S AMHQUIT="" Q
 S AMHRX=Y I Y="" S AMHRX=199
 I AMHRX?1.3N,AMHRX'<AMHRA S AMHRY=AMHRY_"-"_AMHRX,AMHRBIN=AMHRY Q
 W "  ??",$C(7) G CLOSE
 Q
 ;
 ;
LIST ;
 S %=AMHRBIN
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,"-")," - ",$P(X,"-",2)
 W !
 Q
 ;
SETBIN ;
 S AMHRBIN="0-0;1-4;5-14;15-19;20-24;25-44;45-64;65-125"
 Q
ZIS ;
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G XIT
 W !,$C(7),"This report should be printed on 132 column paper or on a printer with ",!,"condensed print.",!
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="^AMHRPS1",XBRP="^AMHRPSP",XBNS="AMH",XBRX="XIT^AMHRPS"
 D ^XBDBQUE
XIT K ZTSK,Y,AMHBD,AMHED,IO("Q"),AMH80D,AMHBTH,AMHHRCN,AMHJOB,AMHLENG,AMHPCNT,AMHPG,AMHPROV,AMHX,DFN,DIC,DIR,DIRUT,DTOUT,DUOUT,XBNS,XBRC,XBRP,XBTX,D
 K AMHPRNM,AMHPRNT,AMHPROB,AMHPRV,AMHR,AMHRCNT,AMHRLOC,AMHSD,AMHTOT,AMHBDD,AMHBT,AMHEDD,AMHEDO,AMHBDO,AMHBT,AMHFOUND,AMHHIT,AMHID,AMHLINE,AMHP
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""^AMHRPSP"")"
 S XBNS="AMH",XBRC="^AMHRPS1",XBRX="XIT^AMHRPS",XBIOP=0 D ^XBDBQUE
 Q
INFORM ;inform user what this report is all about
 W !,AMHTITLE
 I AMHTITLE="ABUSE REPORT" D  I 1
 .W !,"This report focuses on patients who may have been victims of abuse or "
 .W !,"neglect.  It will present, by age and sex, the number of individual"
 .W !,"patients who were seen for the following Purpose of Visits (POV): "
 E  W !,"This report will present, by age and sex, the number of individual patients",!,"who were seen for the following Purpose of Visits (POV):",!
 S AMHX=0 F  S AMHX=$O(AMHPROB(AMHX)) Q:AMHX=""  S AMHY=$O(^AMHPROB("B",AMHX,"")) D
 .I $Y>(IOSL-4) D PAUSE^AMHLEA  W:$D(IOF) @IOF
 .I AMHY]"" W !?10,$P(^AMHPROB(AMHY,0),U)," - ",$P(^AMHPROB(AMHY,0),U,2)
 D DBHUSR^AMHUTIL
 Q

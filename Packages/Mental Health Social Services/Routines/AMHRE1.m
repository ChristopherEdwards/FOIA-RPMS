AMHRE1 ; IHS/CMI/LAB - ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 K AMHQ
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 D INFORM
TYPE ; type of problem code
 S AMHPTYPE=""
 S DIR(0)="S^P:Problem Code and all DSM codes grouped under it;D:Individual Problem or DSM codes",DIR("A")="Which Type",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S AMHPTYPE=Y
 I AMHPTYPE="P" G PROBCODE
PROBLIST ;get problem list
 K AMHPROB S AMHC=0
PROB1 ;
 W ! K DIC S DIC="^AMHPROB(",DIC(0)="AEMQ",DIC("A")="Enter "_$S(AMHC=0:"",1:"Another ")_"Problem/Diagnosis Code: " D ^DIC
 I Y=-1,'$D(AMHPROB) W !!,"No problems selected.  Exiting." D XIT Q
 I Y=-1,$O(AMHPROB(0)) G GETDATES
 I X="",$O(AMHPROB(0)) G GETDATES
 S AMHC=AMHC+1,AMHPROB(+Y)=""
 G PROB1
PROBCODE ;
 K AMHPROB S AMHC=0
PROB2 ;
 W ! K DIC S DIC="^AMHPROBC(",DIC(0)="AEMQ",DIC("A")="Enter "_$S(AMHC=0:"",1:"Another ")_"Problem Code: " D ^DIC
 I Y=-1,'$D(AMHPROB) W !!,"No problems selected.  Exiting." D XIT Q
 I Y=-1,$O(AMHPROB(0)) G GETDATES
 I X="",$O(AMHPROB(0)) G GETDATES
 W !!,"The following Problem/DSM codes will be included: "
 S X=0 F  S X=$O(^AMHPROB("AC",+Y,X)) Q:X'=+X  S AMHPROB(X)="" W "  ",$P(^AMHPROB(X,0),U) S AMHC=AMHC+1
 G PROB2
GETDATES ;
 W:$D(IOF) @IOF W !,"You have selected the following Problem/Diagnosis Codes"
 S X=0 F  S X=$O(AMHPROB(X)) Q:X'=+X  W !?5,$P(^AMHPROB(X,0),U),?13,$P(^AMHPROB(X,0),U,2)
BD ;get beginning date
 W !!!,"Please enter the date range during which the patient should have been seen ",!,"with one of these problems.",!
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter Ending Visit Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S AMHSD=$$FMADD^XLFDT(AMHBD,-1)_".9999"
 ;
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G GETDATES
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="PROC^AMHRE1",XBRP="PRINT^AMHRE1",XBNS="AMH",XBRX="XIT^AMHRE1"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("AMH"),^XBFMK
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHRE1"")"
 S XBNS="AMH",XBRC="PROC^AMHRE1",XBRX="XIT^AMHRE1",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 S AMHBT=$H
 S ^XTMP("AMHRE1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"BH PROBLEM REPORT"
 S AMHJ=$J,AMHH=$H,AMHCNT=0
 K ^XTMP("AMHRE1",AMHJ,AMHH)
 ;$O through all visits and set for patient once
 F  S AMHSD=$O(^AMHREC("B",AMHSD)) Q:AMHSD=""!((AMHSD\1)>AMHED)  D
 .S (AMHR,AMHRCNT)=0 F  S AMHR=$O(^AMHREC("B",AMHSD,AMHR)) Q:AMHR'=+AMHR  I $D(^AMHREC(AMHR,0)),$P(^(0),U,2)]"",$P(^(0),U,3)]"" S AMHR0=^(0) D PROC1
 S AMHET=$H
 Q
PROC1 ;
 Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHR)
 S DFN=$P(AMHR0,U,8) Q:DFN=""  ;do not use if no patient
 Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 Q:'$D(^AMHRPRO("AD",AMHR))  ;quit if no problems entered
 ;find pov
 S (AMHFOUND,X)=0,AMHSORT="" F  S X=$O(^AMHRPRO("AD",AMHR,X)) Q:X'=+X!(AMHFOUND)  S P=$P(^AMHRPRO(X,0),U) I $D(AMHPROB(P)) D
 .Q:$D(^XTMP("AMHRE1",AMHJ,AMHH,$P(^DPT(DFN,0),U),DFN,P))  ;already got this pov
 .S ^XTMP("AMHRE1",AMHJ,AMHH,$P(^DPT(DFN,0),U),DFN,P)=AMHR
 .Q
 Q
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;inform user what this report is all about
 W !!,"This report will list all patients who have been seen for a diagnosis/problem",!,"selected by the user in the date range selected by the user.  For example,"
 W !,"you may enter all suicide problem codes (39, 40, 41) and you will get a list",!,"of all patients seen for suicide and can then use this report",!,"to assist in follow up activities.",!
 W !!,"The report will list Designated Provider, Patient Name, date seen for",!,"this problem, and date last seen.",!!
 D DBHUSRP^AMHUTIL,DBHUSR^AMHUTIL,PAUSE^AMHLEA
 Q
PRINT ;EP - called from xbdbque
 S AMHPG=0 D HEADER
 I '$D(^XTMP("AMHRE1",AMHJ,AMHH)) W !!,"NO PATIENTS TO REPORT" G DONE
 S DFN="" K AMHQ
 S AMHNAME="" F  S AMHNAME=$O(^XTMP("AMHRE1",AMHJ,AMHH,AMHNAME)) Q:AMHNAME=""!($D(AMHQ))  D
 .S DFN=0 F  S DFN=$O(^XTMP("AMHRE1",AMHJ,AMHH,AMHNAME,DFN)) Q:DFN'=+DFN!($D(AMHQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 ..W !,$E(AMHNAME,1,25),?27,$$HRN^AUPNPAT(DFN,DUZ(2)),?34,$$D($$DOB^AUPNPAT(DFN)),?44,$P(^DPT(DFN,0),U,2) D
 ...S AMHP=0,AMHC=0 F  S AMHP=$O(^XTMP("AMHRE1",AMHJ,AMHH,AMHNAME,DFN,AMHP)) Q:AMHP'=+AMHP!($D(AMHQ))  D
 ....S AMHR=^XTMP("AMHRE1",AMHJ,AMHH,AMHNAME,DFN,AMHP)
 ....S AMHC=AMHC+1 I AMHC=1 W ?47,$$PPINI^AMHUTIL(AMHR),?55,$P(^AMHPROB(AMHP,0),U),?62,$$D($P(^AMHREC(AMHR,0),U)),?72,$$D($$LVD^AMHDPEE(DFN,"ID")) Q
 ....I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 ....W !?55,$P(^AMHPROB(AMHP,0),U),?62,$$D($P(^AMHREC(AMHR,0),U))
 ....Q
 ...Q
 ..I $Y>(IOSL-4) D HEADER Q:$D(AMHQ)
 ..I $P($G(^AMHPATR(DFN,0)),U,2)]"" W !?3,"Designated MH Prov: ",$E($$VAL^XBDIQ1(9002011.55,DFN,.02),1,20)
 ..S AMHS=0 I $P($G(^AMHPATR(DFN,0)),U,3) W !?3,"Designated SS Prov: ",$E($$VAL^XBDIQ1(9002011.55,DFN,.03),1,20) S AMHS=1
 ..I $P($G(^AMHPATR(DFN,0)),U,4) W ?$S(AMHS:42,1:3),"Desginated CD Prov: ",$E($$VAL^XBDIQ1(9002011.55,DFN,.04),1,20)
 ..Q
 .Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K AMHTS,AMHS,AMHM,AMHET
 K ^XTMP("AMHRE1",AMHJ,AMHH),AMHJ,AMHH
 Q
 ;
HEADER ;EP
 G:'AMHPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",AMHPG,!
 W !,$$CTR("PATIENTS SEEN WITH SELECTED DIAGNOSES/PROBLEMS",80),!
 S X="Visit Dates: "_$$FMTE^XLFDT(AMHBD)_" to "_$$FMTE^XLFDT(AMHED) W $$CTR(X,80),!
 W !,"PATIENT NAME",?27,"HRN",?34,"DOB",?43,"SEX",?47,"PROV DX",?55,"DX",?62,"DATE SEEN",?72,"LAST VIS"
 W !,$TR($J("",80)," ","-")
 Q

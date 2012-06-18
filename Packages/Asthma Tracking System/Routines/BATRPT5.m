BATRPT5 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("PERSISTENT PATIENTS WITH LESS THAN n REFILLS"),!,$$CTR^BATU("OF CONTROLLER MEDS IN A USER DEFINED RANGE"),!
 W !,"This report will list all persistent patients who have had N number of",!,"refills of controller medication in a user defined date range.",!,"The patients reviewed are those on the Asthma Register.",!
STAT ;
 S BATS=""
 S DIR(0)="90181.01,.02",DIR("A")="Review Patients with which Register Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BATS=Y,BATSF=Y(0)
DATES ;
 S (BATBD,BATED)=""
BD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date to Search for Controller Meds" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G STAT
 S BATBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date to search for Controller Meds:  " S Y=BATBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 I Y<BATBD W !!,"Ending date cannot be less than beginning date." G DATES
 S BATED=Y
 S X1=BATBD,X2=-1 D C^%DTC S BATSD=X
NUM ;how many
 S BATNR=0
 S DIR(0)="N^0:99:",DIR("A")="How many refills" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 S BATNR=Y
AGE ;Age Screening
 K BATAGE,BATAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to include visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) DATES
 I 'Y G SORT
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S BATAGET=Y
 ;
 ;
SORT ;
 S BATSORT=""
 S DIR(0)="S^N:Patient Name;D:Patient AGE;V:Patient's Next Asthma Visit Due Date;A:Last Asthma Severity;L:Last Asthma Visit",DIR("A")="Sort List by",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BATSORT=Y
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BATOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BATRPT5",XBRC="PROC^BATRPT5",XBRX="EXIT^BATRPT5",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRPT5"")"
 S XBRC="PROC^BATRPT5",XBRX="EXIT^BATRPT5",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S BATJ=$J,BATH=$H
 D XTMP^BATU("BATRPT5","ASTHMA REGISTER DUE LIST")
 S BATX=0 F  S BATX=$O(^BATREG(BATX)) Q:BATX'=+BATX  D
 .I $$DOD^AUPNPAT(BATX)]"" Q  ;DECEASED
 .S BATAGE=$$AGE^AUPNPAT(BATX,BATBD)
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .;only 2,3,4
 .S X=$$LASTSEVD^BATU(BATX,1,BATED)
 .I X=""!(X=1) Q
 .S BATCNT=$$GETMED(BATX,BATBD,BATED)
 .I BATCNT>BATNR Q  ;didn't have 4 or more
 .I BATCNT=BATNR Q
 .D GETSORT
 .S ^XTMP("BATRPT5",BATJ,BATH,"PATIENTS",BATSRTV,BATX)=BATCNT
 .Q
 Q
GETSORT ;
 S BATSRTV=""
 I BATSORT="N" S BATSRTV=$P(^DPT(BATX,0),U) Q
 I BATSORT="D" S BATSRTV=$$AGE^AUPNPAT(BATX) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="A" S BATSRTV=$$LASTSEVD^BATU(BATX,1,BATED) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="V" S BATSRTV=$P(^BATREG(BATX,0),U,7) I BATSRTV="" S BATSRTV="--"
 I BATSORT="L" S BATSRTV=$P(^BATREG(BATX,0),U,6) I BATSRTV="" S BATSRTV="--"
 Q
GETMED(P,BDATE,EDATE) ;all reliever meds count up
 NEW X,BATL,E,C
 K BATL
 S X=P_"^ALL MEDS [BAT ASTHMA CONTROLLER MEDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BATL(")
 S (X,C)=0 F  S X=$O(BATL(X)) Q:X'=+X  S C=C+1
 K BATL
 S X=P_"^ALL MEDS [BAT ASTHMA INHALED STEROIDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BATL(")
 S X=0 F  S X=$O(BATL(X)) Q:X'=+X  S C=C+1
 Q C
 ;
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 I '$D(^XTMP("BATRPT5",BATJ,BATH,"PATIENTS")) W !!,"No patients to list" G EOJ
 S BATST="" F  S BATST=$O(^XTMP("BATRPT5",BATJ,BATH,"PATIENTS",BATST)) Q:BATST=""!(BATQUIT)  D
 .S BATX=0 F  S BATX=$O(^XTMP("BATRPT5",BATJ,BATH,"PATIENTS",BATST,BATX)) Q:BATX'=+BATX!(BATQUIT)  D
 ..I $Y>(IOSL-4) D HEADER Q:BATQUIT
 ..S BATCNT=^XTMP("BATRPT5",BATJ,BATH,"PATIENTS",BATST,BATX)
 ..W !,$E($P(^DPT(BATX,0),U),1,22),?23,$$HRN^AUPNPAT(BATX,DUZ(2)),?30,$$AGE^AUPNPAT(BATX,DT,"R")
 ..W ?37,$E($$LASTSEVD^BATU(BATX,5,BATED),1,17),?55,$$FMTE^XLFDT($P($P(^BATREG(BATX,0),U,6),".")),?68,$$FMTE^XLFDT($P($P(^BATREG(BATX,0),U,7),"."))
 ..W !?5,"Number of Controller Refills: ",BATCNT
 ..Q
 .Q
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("BATRPT5",BATJ,BATH),BATX
 W:$D(IOF) @IOF
 Q
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  ASTHMA REGISTER PERSISTENT PATIENTS  ***",80),!
 W $$CTR^BATU("*** WITH LESS THAN "_BATNR_" REFILLS OF CONTROLLER MEDS ***",80),!
 S X="Due Dates: "_$$FMTE^XLFDT(BATBD)_" to "_$$FMTE^XLFDT(BATED) W $$CTR^BATU(X,80),!
 S X="Register Status: "_BATSF W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 W !,"PATIENT NAME",?24,"HRN",?31,"AGE",?37,"LAST SEVERITY",?55,"LAST VISIT",?68,"NEXT DUE"
 W !,$TR($J("",80)," ","-")
 Q

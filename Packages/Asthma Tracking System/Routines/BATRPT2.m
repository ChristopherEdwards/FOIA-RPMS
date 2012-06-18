BATRPT2 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("PATIENTS DUE OR OVERDUE FOR FOLLOWUP")
 W !!,"This report will produce a list of all patients on the register",!,"who are due for followup.  You will select the age range of",!,"interest and the date range for which the patient is due.",!
STAT ;
 S BATS=""
 S DIR(0)="90181.01,.02",DIR("A")="List Patients with which Register Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BATS=Y,BATSF=Y(0)
DATES ;
 S (BATBD,BATED)=""
BD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Due Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G STAT
 S BATBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^::EP",DIR("A")="Enter Ending Due Date:  " S Y=BATBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 I Y<BATBD W !!,"Ending date cannot be less than beginning date." G DATES
 S BATED=Y
 S X1=BATBD,X2=-1 D C^%DTC S BATSD=X
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
 S XBRP="PRINT^BATRPT2",XBRC="PROC^BATRPT2",XBRX="EXIT^BATRPT2",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRPT2"")"
 S XBRC="PROC^BATRPT2",XBRX="EXIT^BATRPT2",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S BATJ=$J,BATH=$H
 D XTMP^BATU("BATRPT2","ASTHMA REGISTER DUE LIST")
 S BATX=0 F  S BATX=$O(^BATREG(BATX)) Q:BATX'=+BATX  D
 .I $$DOD^AUPNPAT(BATX)]"" Q  ;DECEASED
 .I $P(^BATREG(BATX,0),U,2)'=BATS Q
 .S BATAGE=$$AGE^AUPNPAT(BATX,BATBD)
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .S BATLS=$$LASTSEV^BATU($P(^BATREG(BATX,0),"^"))
 .I BATLS=1 Q
 .S N=$$NEXT^BATU(BATX)
 .I N<BATBD Q
 .I N>BATED Q
 .D GETSORT
 .S ^XTMP("BATRPT2",BATJ,BATH,"PATIENTS",BATSRTV,BATX)=""
 .Q
 Q
GETSORT ;
 S BATSRTV=""
 I BATSORT="N" S BATSRTV=$P(^DPT(BATX,0),U) Q
 I BATSORT="D" S BATSRTV=$$AGE^AUPNPAT(BATX) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="A" S BATSRTV=$$LASTSEV^BATU(BATX) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="V" S BATSRTV=$P(^BATREG(BATX,0),U,7) I BATSRTV="" S BATSRTV="--"
 I BATSORT="L" S BATSRTV=$P(^BATREG(BATX,0),U,6) I BATSRTV="" S BATSRTV="--"
 Q
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 I '$D(^XTMP("BATRPT2",BATJ,BATH,"PATIENTS")) W !!,"No patients to list" G EOJ
 S BATST="" F  S BATST=$O(^XTMP("BATRPT2",BATJ,BATH,"PATIENTS",BATST)) Q:BATST=""!(BATQUIT)  D
 .S BATX=0 F  S BATX=$O(^XTMP("BATRPT2",BATJ,BATH,"PATIENTS",BATST,BATX)) Q:BATX'=+BATX!(BATQUIT)  D
 ..I $Y>(IOSL-4) D HEADER Q:BATQUIT
 ..W !,$E($P(^DPT(BATX,0),U),1,22),?23,$$HRN^AUPNPAT(BATX,DUZ(2)),?30,$$AGE^AUPNPAT(BATX,DT,"R")
 ..W ?37,$E($$LASTSEV^BATU(BATX,5),1,17),?55,$$FMTE^XLFDT($P($P(^BATREG(BATX,0),U,6),".")),?68,$$FMTE^XLFDT($P($P(^BATREG(BATX,0),U,7),"."))
 ..Q
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("BATRPT2",BATJ,BATH),BATX
 W:$D(IOF) @IOF
 Q
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  ASTHMA REGISTER PATIENTS DUE OR OVERDUE FOR FOLLOWUP  ***",80),!
 S X="Due Dates: "_$$FMTE^XLFDT(BATBD)_" to "_$$FMTE^XLFDT(BATED) W $$CTR^BATU(X,80),!
 S X="Register Status: "_BATSF W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 W !,"PATIENT NAME",?24,"HRN",?31,"AGE",?37,"LAST SEVERITY",?55,"LAST VISIT",?68,"NEXT DUE"
 W !,$TR($J("",80)," ","-")
 Q

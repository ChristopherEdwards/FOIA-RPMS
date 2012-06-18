BATRPT0 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,"This report will produce a list of all patients on the register who do not",!,"have severity documented.",!,"You will select which patients (based on status) to display.",!!
 S BATS=""
 S DIR(0)="90181.01,.02",DIR("A")="List Patients with which Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BATS=Y,BATSF=Y(0)
AGE ;Age Screening
 K BATAGE,BATAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to include visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) START
 I 'Y G SORT
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S BATAGET=Y
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
 S XBRP="PRINT^BATRPT0",XBRC="PROC^BATRPT0",XBRX="EXIT^BATRPT0",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRPT0"")"
 S XBRC="PROC^BATRPT0",XBRX="EXIT^BATRPT0",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S BATJ=$J,BATH=$H
 D XTMP^BATU("BATRPT0","ASTHMA REGISTER MASTER LIST")
 S BATX=0 F  S BATX=$O(^BATREG(BATX)) Q:BATX'=+BATX  D
 .I $P(^BATREG(BATX,0),U,2)'=BATS Q
 .S BATAGE=$$AGE^AUPNPAT(BATX,DT)
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .I $$LASTSEV^BATU(BATX)]"" Q
 .D GETSORT
 .S ^XTMP("BATRPT0",BATJ,BATH,"PATIENTS",BATSRTV,BATX)=""
 .Q
 Q
GETSORT ;
 S BATSRTV=""
 I BATSORT="N" S BATSRTV=$P(^DPT(BATX,0),U) Q
 I BATSORT="D" S BATSRTV=$$AGE^AUPNPAT(DFN) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="A" S BATSRTV=$$LASTSEV^BATU(BATX) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="V" S BATSRTV=$P(^BATREG(BATX,0),U,7) I BATSRTV="" S BATSRTV="--"
 I BATSORT="L" S BATSRTV=$P(^BATREG(BATX,0),U,6) I BATSRTV="" S BATSRTV="--"
 Q
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 I '$D(^XTMP("BATRPT0",BATJ,BATH,"PATIENTS")) W !!,"No patients to list" G EOJ
 S BATST="" F  S BATST=$O(^XTMP("BATRPT0",BATJ,BATH,"PATIENTS",BATST)) Q:BATST=""!(BATQUIT)  D
 .S DFN=0 F  S DFN=$O(^XTMP("BATRPT0",BATJ,BATH,"PATIENTS",BATST,DFN)) Q:DFN'=+DFN!(BATQUIT)  D
 ..I $Y>(IOSL-4) D HEADER Q:BATQUIT
 ..W !,$E($P(^DPT(DFN,0),U),1,22),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$AGE^AUPNPAT(DFN,DT,"R")
 ..W ?37,$E($$LASTSEV^BATU(DFN,5),1,17),?55,$$FMTE^XLFDT($P($P(^BATREG(DFN,0),U,6),".")),?68,$$FMTE^XLFDT($P($P(^BATREG(DFN,0),U,7),"."))
 ..Q
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("BATRPT0",BATJ,BATH),DFN
 W:$D(IOF) @IOF
 Q
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  ASTHMA REGISTER PATIENTS WITHOUT SEVERITY DOCUMENTED  ***",80),!
 S X="Register Status: "_BATSF W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 W !,"PATIENT NAME",?24,"HRN",?31,"AGE",?37,"LAST SEVERITY",?55,"LAST VISIT",?68,"NEXT DUE"
 W !,$TR($J("",80)," ","-")
 Q

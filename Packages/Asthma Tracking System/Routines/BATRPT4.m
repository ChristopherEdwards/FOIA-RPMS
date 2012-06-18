BATRPT4 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("PATIENTS WITH 4 OR MORE RELIEVER REFILLS IN 150 DAYS")
 W !!,"This report will list all patients who have had 4 or more refills of",!,"reliever medication a user defined 150 day period.",!,!,"All patients will be reviewed, not just those on the Asthma Register.",!
 W !!,"This report reviewd the entire patient file and may take several hours to",!,"run depending on the size of the patient database.",!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
DATE ;
 S BATED=""
 S DIR(0)="D^::EP",DIR("A")="Enter the Ending Date of the 150 day period" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BATED=Y
AGE ;Age Screening
 K BATAGE,BATAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to include visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) DATE
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
 S XBRP="PRINT^BATRPT4",XBRC="PROC^BATRPT4",XBRX="EXIT^BATRPT4",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRPT4"")"
 S XBRC="PROC^BATRPT4",XBRX="EXIT^BATRPT4",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S BATJ=$J,BATH=$H
 D XTMP^BATU("BATRPT4","ASTHMA REGISTER DUE LIST")
 S BATX=0 F  S BATX=$O(^AUPNPAT(BATX)) Q:BATX'=+BATX  D
 .I $$DOD^AUPNPAT(BATX)]"" Q  ;DECEASED
 .S BATAGE=$$AGE^AUPNPAT(BATX,$$FMADD^XLFDT(BATED,-150))
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .S BATCNT=$$GETMED(BATX,BATED)
 .I BATCNT<4 Q  ;didn't have 4 or more
 .D GETSORT
 .S ^XTMP("BATRPT4",BATJ,BATH,"PATIENTS",BATSRTV,BATX)=BATCNT
 .Q
 Q
GETSORT ;
 S BATSRTV=""
 I BATSORT="N" S BATSRTV=$P(^DPT(BATX,0),U) Q
 I BATSORT="D" S BATSRTV=$$AGE^AUPNPAT(BATX) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="A" S BATSRTV=$$LASTSEV^BATU(BATX) I BATSRTV="" S BATSRTV="--" Q
 I BATSORT="V" S BATSRTV=$P($G(^BATREG(BATX,0)),U,7) I BATSRTV="" S BATSRTV="--"
 I BATSORT="L" S BATSRTV=$P($G(^BATREG(BATX,0)),U,6) I BATSRTV="" S BATSRTV="--"
 Q
GETMED(P,EDATE) ;all reliever meds count up
 NEW X,BATL,E,BDATE
 K BATL
 S BDATE=$$FMADD^XLFDT(EDATE,-150)
 S X=P_"^ALL MEDS [BAT ASTHMA RELIEVER MEDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BATL(")
 I '$D(BATL(1)) Q 0
 NEW C S (X,C)=0 F  S X=$O(BATL(X)) Q:X'=+X  S C=C+1
 Q C
 ;
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 I '$D(^XTMP("BATRPT4",BATJ,BATH,"PATIENTS")) W !!,"No patients to list" G EOJ
 S BATST="" F  S BATST=$O(^XTMP("BATRPT4",BATJ,BATH,"PATIENTS",BATST)) Q:BATST=""!(BATQUIT)  D
 .S BATX=0 F  S BATX=$O(^XTMP("BATRPT4",BATJ,BATH,"PATIENTS",BATST,BATX)) Q:BATX'=+BATX!(BATQUIT)  D
 ..I $Y>(IOSL-4) D HEADER Q:BATQUIT
 ..W !,$E($P(^DPT(BATX,0),U),1,22),?23,$$HRN^AUPNPAT(BATX,DUZ(2)),?30,$$AGE^AUPNPAT(BATX,DT,"R")
 ..W ?37,$E($$LASTSEV^BATU(BATX,5),1,17),?55,$$FMTE^XLFDT($P($P($G(^BATREG(BATX,0)),U,6),".")),?68,$$FMTE^XLFDT($P($P($G(^BATREG(BATX,0)),U,7),"."))
 ..I '$D(^BATREG(BATX,0)) W !?5,"Patient NOT on Asthma Register"
 ..W !?5,"Number of Reliever Refills: ",^XTMP("BATRPT4",BATJ,BATH,"PATIENTS",BATST,BATX)
 ..Q
 .Q
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("BATRPT4",BATJ,BATH),BATX
 W:$D(IOF) @IOF
 Q
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  PATIENTS WITH 4 OR MORE RELIEVER MED REFILLS IN 150 DAYS  ***",80),!
 S X="Time Period: "_$$FMTE^XLFDT($$FMADD^XLFDT(BATED,-150))_" to "_$$FMTE^XLFDT(BATED) W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 W !,"PATIENT NAME",?24,"HRN",?31,"AGE",?37,"LAST SEVERITY",?55,"LAST VISIT",?68,"NEXT DUE"
 W !,$TR($J("",80)," ","-")
 Q

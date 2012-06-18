BATRPT8 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("% OF PERSISTENT PATIENTS SEEN FOR SCHEDULED ASTHMA VISIT")
 W !!,"This report give a % of persistent patients who have been",!,"seen for a scheduled asthma visit in a user defined time range.",!
STAT ;
 S BATS=""
 S DIR(0)="90181.01,.02",DIR("A")="List Patients with which Register Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BATS=Y,BATSF=Y(0)
AGE ;Age Screening
 K BATAGE,BATAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to include visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) STAT
 I 'Y G DATES
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S BATAGET=Y
 ;
 ;
DATES ;
 S (BATBD,BATED)=""
BD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date of Date Range" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G STAT
 S BATBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date of Date Range:  " S Y=BATBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BATED=Y
 S X1=BATBD,X2=-1 D C^%DTC S BATSD=X
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BATOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BATRPT8",XBRC="PROC^BATRPT8",XBRX="EXIT^BATRPT8",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRPT8"")"
 S XBRC="PROC^BATRPT8",XBRX="EXIT^BATRPT8",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S (BATDENOM,BATNUMER)=0
 S BATJ=$J,BATH=$H
 S BATX=0 F  S BATX=$O(^BATREG(BATX)) Q:BATX'=+BATX  D
 .I $$DOD^AUPNPAT(BATX)]"" Q  ;DECEASED
 .I $P(^BATREG(BATX,0),U,2)'=BATS Q
 .I $$LASTSEVD^BATU(BATX,1,BATED)=""!($$LASTSEVD^BATU(BATX,1,BATED)=1) Q
 .S BATAGE=$$AGE^AUPNPAT(BATX,BATBD)
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .S BATDENOM=BATDENOM+1
 .S (X,G)=0 F  S X=$O(^AUPNVAST("AC",BATX,X)) Q:X'=+X  D
 ..S D=$P($P(^AUPNVSIT($P(^AUPNVAST(X,0),U,3),0),U),".")
 ..I D<BATBD Q
 ..I D>BATED Q
 ..S G=1
 ..Q
 .S BATNUMER=BATNUMER+G
 .Q
 Q
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 W !,"              Total Number of Patients: ",?40,$J(BATDENOM,7)
 W !,"        Total Number with Asthma Visit: ",?40,$J(BATNUMER,7)
 S X=""
 I BATDENOM S X=$J(((BATNUMER/BATDENOM)*100),5,1)
 W !?40,$J(X,7),"%"
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) W !! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  % OF PERSISTENT PATIENTS SEEN FOR SCHEDULED ASTHMA VISIT  ***",80),!
 S X="Register Status: "_BATSF W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 S X="Date Range: "_$$FMTE^XLFDT(BATBD)_" - "_$$FMTE^XLFDT(BATED) W $$CTR^BATU(X,80),!
 W !,$TR($J("",80)," ","-")
 Q

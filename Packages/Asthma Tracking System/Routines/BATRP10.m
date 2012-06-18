BATRP10 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("% OF PERSISTENT PATIENTS BY AGE GROUP WHO ARE OLDER THAN 6")
 W !,$$CTR^BATU("WITH SPIROMETRY DOCUMENTED WITHIN A DATE RANGE")
 W !!,"This report will give a % of persistent asthma register patients",!,"who have spirometry documented in a date range specified by the user.",!,"The patient must be 6 years old at the beginning of the date range.",!
STAT ;
 S BATS=""
 S DIR(0)="90181.01,.02",DIR("A")="List Patients with which Register Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BATS=Y,BATSF=Y(0)
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
 S XBRP="PRINT^BATRP10",XBRC="PROC^BATRP10",XBRX="EXIT^BATRP10",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRP10"")"
 S XBRC="PROC^BATRP10",XBRX="EXIT^BATRP10",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S (BAT1D,BAT1N,BAT2D,BAT2N,BAT3D,BAT3N)=0
 S BATJ=$J,BATH=$H
 S BATX=0 F  S BATX=$O(^BATREG(BATX)) Q:BATX'=+BATX  D
 .I $$DOD^AUPNPAT(BATX)]"" Q  ;DECEASED
 .I $P(^BATREG(BATX,0),U,2)'=BATS Q
 .I $$LASTSEVD^BATU(BATX,1,BATED)=""!($$LASTSEVD^BATU(BATX,1,BATED)=1) Q
 .S BATAGE=$$AGE^AUPNPAT(BATX,BATBD)
 .Q:BATAGE<6  ;6 years and older
 .I BATAGE=6!(BATAGE=7)!(BATAGE=8) S BAT1D=BAT1D+1
 .I BATAGE>8&(BATAGE<19) S BAT2D=BAT2D+1
 .I BATAGE>18 S BAT3D=BAT3D+1
 .S X=$$SPIRO(BATX,BATBD,BATED)
 .I X,BATAGE<8 S BAT1N=BAT1N+1
 .I X,BATAGE>7,BATAGE<19 S BAT2N=BAT2N+1
 .I X,BATAGE>18 S BAT3N=BAT3N+1
 Q
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 W !,?40,"6-8 YRS",?53,"9-18 YRS",?65,"OVER 18 YRS"
 W !!,"Number of Patients",?40,$J(BAT1D,6),?53,$J(BAT2D,6),?65,$J(BAT3D,6)
 W !,"Number with Spirometry",?40,$J(BAT1N,6),?53,$J(BAT2N,6),?65,$J(BAT3N,6)
 W !
 I BAT1D W ?40,$J(((BAT1N/BAT1D)*100),5,1)_"%"
 I BAT2D W ?53,$J(((BAT2N/BAT2D)*100),5,1)_"%"
 I BAT3D W ?65,$J(((BAT3N/BAT3D)*100),5,1)_"%"
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) W !! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
SPIRO(P,BDATE,EDATE) ;
 ;did patient have spirometry inbetween BDATE and EDATE?
 I '$G(P) Q ""
 NEW X,Y,Z,D
 S (X,Y,Z)=0 F  S X=$O(^AUPNVAST("AC",P,X)) Q:X'=+X!(Z)  D
 .S D=$P(^AUPNVAST(X,0),U,3),D=$P($P(^AUPNVSIT(D,0),U),".")
 .Q:D<BATBD
 .Q:D>BATED
 .I $P(^AUPNVAST(X,0),U,5)]"" S Z=1 Q
 .I $P(^AUPNVAST(X,0),U,6)]"" S Z=1
 .Q
 Q Z
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  % OF PERSISTENT PATIENTS > 6 YEARS OLD WITH SPIROMETRY  ***",80),!
 S X="Register Status: "_BATSF W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 S X="Date Range: "_$$FMTE^XLFDT(BATBD)_" - "_$$FMTE^XLFDT(BATED) W $$CTR^BATU(X,80),!
 W !,$TR($J("",80)," ","-")
 Q

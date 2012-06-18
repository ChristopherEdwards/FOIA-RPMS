BATRPT9 ; IHS/CMI/LAB - master list of all active patients ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
START ;
 D EXIT
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("% OF PERSISTENT PATIENTS WITH CONTROLLER OR INHALED STEROID PERSCRIPTIONS")
 W !,$$CTR^BATU("FILLED IN A DATE RANGE SPECIFIED BY THE USER")
 W !!,"This report give a % of persistent patients who have had at least",!,"one fill of controller meds and the % of severe persistent patients",!,"who have had at least one fill of inhaled steroids.",!
STAT ;
 S BATS=""
 S DIR(0)="90181.01,.02",DIR("A")="List Patients with which Register Status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y="" D EXIT Q
 S BATS=Y,BATSF=Y(0)
AGE ;Age Screening
 K BATAGE,BATAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, answer No.  If you wish to include visits for only patients within a particular age range, enter 'Yes'."
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
 S XBRP="PRINT^BATRPT9",XBRC="PROC^BATRPT9",XBRX="EXIT^BATRPT9",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATRPT9"")"
 S XBRC="PROC^BATRPT9",XBRX="EXIT^BATRPT9",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 Q
PROC ;
 S (BAT1D,BAT1N,BAT2D,BAT2N)=0
 S BATJ=$J,BATH=$H
 S BATX=0 F  S BATX=$O(^BATREG(BATX)) Q:BATX'=+BATX  D
 .I $$DOD^AUPNPAT(BATX)]"" Q  ;DECEASED
 .I $P(^BATREG(BATX,0),U,2)'=BATS Q
 .I $$LASTSEVD^BATU(BATX,1,BATED)=""!($$LASTSEVD^BATU(BATX,1,BATED)=1) Q
 .S BATAGE=$$AGE^AUPNPAT(BATX,BATBD)
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .S BAT1D=BAT1D+1
 .S X=$$CONTR(BATX,BATBD,BATED)
 .I X S BAT1N=BAT1N+1
 .I $$LASTSEV^BATU(BATX)=2 Q
 .S BAT2D=BAT2D+1
 .S X=$$INHALED(BATX,BATBD,BATED)
 .I X S BAT2N=BAT2N+1
 Q
PRINT ;EP
 S BATQUIT=0,BATPG=0
 D HEADER
 W !!,"Controller Med Use"
 W !,"  Total Number of Patients (sev 2,3,4): ",?40,$J(BAT1D,7)
 W !," Total Number with Controller Med Fill: ",?40,$J(BAT1N,7)
 S X=""
 I BAT1D S X=$J(((BAT1N/BAT1D)*100),5,1)
 W !?40,$J(X,7),"%"
 W !!,"Inhaled Steroid Med Use"
 W !,"Total Number of Patients (severity 3,4): ",?40,$J(BAT2D,7)
 W !," Total Number with Inhaled Steroid Fill: ",?40,$J(BAT2N,7)
 S X=""
 I BAT2D S X=$J(((BAT2N/BAT2D)*100),5,1)
 W !?40,$J(X,7),"%"
EOJ ;
 I BATOPT'="B",$E(IOST)="C",IO=IO(0) W !! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
CONTR(P,BDATE,EDATE) ;EP
 NEW X,BATL,E
 S X=P_"^LAST MEDS [BAT ASTHMA CONTROLLER MEDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BATL(")
 I $D(BATL(1)) Q 1
 S X=P_"^LAST MEDS [BAT ASTHMA INHALED STEROIDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BATL(")
 I $D(BATL(1)) Q 1
 Q ""
INHALED(P,BDATE,EDATE) ;
 NEW X,BATL,E
 S X=P_"^LAST MEDS [BAT ASTHMA INHALED STEROIDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BATL(")
 I $D(BATL(1)) Q 1
 Q ""
 ;
HEADER ;EP
 G:'BATPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BATPG=BATPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BATPG,!
 W $$CTR^BATU($$LOC^BATU),!
 W !,$$CTR^BATU("***  % OF PERSISTENT PATIENTS AND CONTROLLER/INHALED STEROID USE  ***",80),!
 S X="Register Status: "_BATSF W $$CTR^BATU(X,80),!
 I $D(BATAGET) S X="Ages: "_BATAGET W $$CTR^BATU(X,80),!
 S X="Date Range: "_$$FMTE^XLFDT(BATBD)_" - "_$$FMTE^XLFDT(BATED) W $$CTR^BATU(X,80),!
 W !,$TR($J("",80)," ","-")
 Q

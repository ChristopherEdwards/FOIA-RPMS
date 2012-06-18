APCLEM1 ; IHS/CMI/LAB - ; 03 May 2011  5:14 PM
 ;;2.0;IHS PCC SUITE;**6,7**;MAY 14, 2009;Build 11
 ;
 ;
START ;
 D XIT
 D INFORM
GETDATES ;
BD ;
 W !!!,"Enter the time frame of interest.",! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
PROV ;
 K APCLPROV,APCLPRVN,APCLPRVD
 S APCLPT=""
 S DIR(0)="S^O:ONE Primary Care Provider;C:COHORT or Selected Set of Providers (Taxonomy)",DIR("A")="Prepare report for",DIR("B")="O" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETDATES
 S APCLPT=Y
 I APCLPT="C" G PROVC
PROV1 ;
 S DIC("A")="Which PROVIDER: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 GETDATES
 S APCLPROV(+Y)=""
 G LOCATION
PROVC ;cohort
 K APCLPROV
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLPROV(")
 I '$D(APCLPROV) G PROV
 I $D(APCLPROV("*")) W !,"Selecting all providers not allowed with this report" K APCLPROV G PROV
LOCATION ;
 W !!,"Enter the Visit Location(s) to be included in the numerator and",!,"denominator visit counts.",!
 K APCLLOC
 S APCLPT=""
 S DIR(0)="S^O:ONE Location of Encounter;C:COHORT or Selected Set of Locations (Taxonomy)",DIR("A")="Which set of Locations",DIR("B")="O" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROV
 S APCLPT=Y
 I APCLPT="C" G LOCC
LOC1 ;
 S DIC("A")="Which LOCATION: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOCATION
 S APCLLOC(+Y)=""
 G CLINIC
LOCC ;cohort
 K APCLLOC
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLLOC(")
 I '$D(APCLLOC) G LOCATION
 I $D(APCLLOC("*")) W !,"Selecting all locations is not allowed with this report" K APCLLOC G LOCC
CLINIC ;
 W !!,"Enter the list of clinics that you have determined to be primary care clinics."
 W !,"You can enter them 1 at a time or enter a taxonomy using the '[' notation."
 K APCLCLIN
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCLIN(")
 I '$D(APCLCLIN) G LOCATION
 I $D(APCLCLIN("*")) W !,"all not allowed with this report" K APCLCLIN G CLINIC
ZIS ;
 W !!,"You are currently logged in to division ",$P(^DIC(4,DUZ(2),0),U),!,"Patients must be registered (have a chart at) this location",!,"in order to be included in this report.",!
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CLINIC
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^APCLEM1",XBRC="PROC^APCLEM1",XBNS="APCL",XBRX="XIT^APCLEM1"
 D ^XBDBQUE
 Q
 ;
XIT ;
 D EN^XBVK("APCL")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLEM1"")"
 S XBNS="APCL",XBRC="PROC^APCLEM1",XBRX="XIT^APCLEM1",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 K APCLTOTP
 NEW A,P,X,C
 S APCLTOTV=0,APCLTOTR=0
 ;APCLTOTP(primary provider ien,clinic or "UNKNOWN"))=# of visits^# of visits to this provider
 S APCLSD=APCLSD_".9999" F  S APCLSD=$O(^AUPNVSIT("B",APCLSD)) Q:APCLSD=""!((APCLSD\1)>APCLED)  D V1
 ;
 Q
V1 ;
 S APCLVIEN="" F  S APCLVIEN=$O(^AUPNVSIT("B",APCLSD,APCLVIEN)) Q:APCLVIEN'=+APCLVIEN  D
 .Q:'$D(^AUPNVSIT(APCLVIEN,0))
 .Q:$P(^AUPNVSIT(APCLVIEN,0),U,11)
 .S APCLDFN=$P(^AUPNVSIT(APCLVIEN,0),U,5)
 .Q:APCLDFN=""
 .Q:'$D(^AUPNPAT(APCLDFN,0))
 .Q:'$D(^DPT(APCLDFN,0))
 .Q:'$D(^AUPNPAT(APCLDFN,41,DUZ(2),0))  ;no chart at duz(2)
 .S X=0,D=$$VD^APCLV(APCLVIEN)
 .S X=$S($P($G(^AUPNPAT(APCLDFN,41,DUZ(2),0)),U,3)="":1,$P($G(^AUPNPAT(APCLDFN,41,DUZ(2),0)),U,3)>D:1,1:0)
 .Q:'X  ;INACTIVE PATIENT
 .S X=0
 .S X=$S($P($G(^DPT(APCLDFN,.35)),U)="":1,1:0)
 .Q:'X  ;deceased patient
 .S APCLPP=$P(^AUPNPAT(APCLDFN,0),U,14)
 .Q:APCLPP=""
 .Q:'$D(APCLPROV(APCLPP))  ;not a designated provider we want so we don't want this visit
 .Q:'$D(^AUPNVPOV("AD",APCLVIEN))  ;NO POV, SKIP
 .Q:$$PRIMPROV^APCLV(APCLVIEN,"I")=""  ;NO PRIMARY PROVIDER SKIP
 .S C=$$CLINIC^APCLV(APCLVIEN)
 .Q:'C  ;NO CLINIC SO SKIP
 .Q:'$D(APCLCLIN(C))  ;NOT A CLINIC OF INTEREST SO SKIP
 .S C=$$CLINIC^APCLV(APCLVIEN,"E")
 .Q:"EDX"[$P(^AUPNVSIT(APCLVIEN,0),U,7)  ;skip chart reviews and telephone calls - PER CJ, INCLUDE THEM
 .S F=$P(^AUPNVSIT(APCLVIEN,0),U,6)
 .Q:'F
 .Q:'$D(APCLLOC(F))
 .S $P(APCLTOTP(APCLPP),U,1)=$P($G(APCLTOTP(APCLPP)),U,1)+1
 .S $P(APCLTOTP(APCLPP,C),U,1)=$P($G(APCLTOTP(APCLPP,C)),U,1)+1
 .S APCLTOTV=APCLTOTV+1
 .S A=$$PRIMPROV^APCLV(APCLVIEN,"I")
 .I A,A=APCLPP D
 ..S $P(APCLTOTP(APCLPP,C),U,2)=$P($G(APCLTOTP(APCLPP,C)),U,2)+1
 ..S $P(APCLTOTP(APCLPP),U,2)=$P($G(APCLTOTP(APCLPP)),U,2)+1
 ..S APCLTOTR=APCLTOTR+1
 Q
PRINT ;
 S APCLPG=0
 K APCLQUIT
 D HEADER
 S APCLPP=0 F  S APCLPP=$O(APCLTOTP(APCLPP)) Q:APCLPP'=+APCLPP!($D(APCLQUIT))  D
 .I $Y>(IOSL-4) D HEADER Q:$D(APCLQUIT)
 .W !,$P(^VA(200,APCLPP,0),U,1),!
 .S APCLC=0 F  S APCLC=$O(APCLTOTP(APCLPP,APCLC)) Q:APCLC=""!($D(APCLQUIT))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(APCLQUIT)
 ..W ?3,APCLC,?35,$$C($P(APCLTOTP(APCLPP,APCLC),U,2),0),?50,$$C($P(APCLTOTP(APCLPP,APCLC),U,1),0),?65,$$PER($P(APCLTOTP(APCLPP,APCLC),U,2),$P(APCLTOTP(APCLPP,APCLC),U,1)),!
 .W "Total for ",$E($P(^VA(200,APCLPP,0),U,1),1,20),?35,$$C($P(APCLTOTP(APCLPP),U,2),0),?50,$$C($P(APCLTOTP(APCLPP),U,1),0),?65,$$PER($P(APCLTOTP(APCLPP),U,2),$P(APCLTOTP(APCLPP),U,1)),!
 Q:$D(APCLQUIT)
 I $Y>(IOSL-4) D HEADER Q:$D(APCLQUIT)
 W !!,"Total:",?35,$$C(APCLTOTR,0),?50,$$C(APCLTOTV,0),?65,$$PER(APCLTOTR,APCLTOTV),!
 Q
PER(N,D) ;EP - return % of n/d
 I 'D Q "0%"
 NEW Z
 S Z=N/D,Z=Z*100,Z=$J(Z,3,0)
 Q $$STRIP^XLFSTR(Z," ")_"%"
C(X,X2,X3) ;EP
 D COMMA^%DTC
 Q $J($$STRIP^XLFSTR(X," "),7)
HEADER ;
 I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 I APCLPG W:$D(IOF) @IOF
 S APCLPG=APCLPG+1
 W !,$$CTR($$FMTE^XLFDT(DT),80),?70,"Page ",APCLPG,!
 W $$CTR($$LOC,80),!
 W $$CTR("Visit Dates: "_$$FMTE^XLFDT(APCLBD)_" - "_$$FMTE^XLFDT(APCLED),80),!
 W "PROVIDER/CLINIC",?35,"Numerator",?50,"Denominator",?65,"%",!
 W $$REPEAT^XLFSTR("-",79),!
 Q
INFORM ;tell user what is going on
 W:$D(IOF) @IOF
 W $$CTR("*******   CONTINUITY OF CARE TO A PRIMARY CARE PROVIDER  ******",80)
 W !,"This report measures the continuity of care to a designated"
 W !,"primary care provider."
 W !,"The continuity of care measures the number of times that a patient saw their"
 W !,"own designated primary care provider in a primary care clinic setting. "
 W !!,"Numerator: The number of times that a patient saw their designated primary"
 W !,"care provider in a primary care clinic setting."
 W !,"Denominator: The number of times that a patient has been seen by any provider"
 W !,"in a primary care clinic setting."
 W !,"This report should be run for one division at a time if you are operating"
 W !,"on a multi-divisional database."
 W !,"The user will be prompted to enter the following information:"
 W !?5,"- The designated primary care provider(s)"
 W !?5,"- The date range for visit selection"
 W !?5,"- The location(s) of encounter for visit selection.  You may choose one or"
 W !?10,"locations or facilities where the provider provides services."
 W !?5,"- The set of clinics you have determined to be 'Primary' clinics."
 W !?10,"A taxonomy or group of these clinics can be created for later use"
 W !,"In order to be included in the denominator the visit must be a "
 W !,"complete visit (have a POV and a provider.)"
 W !,"Inactive and deceased patients are excluded."
 D PAUSE^APCLVL01
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of Report.  Press return",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
POST ;EP
 S X=$$ADD^XPDMENU("APCLMENU","APCL IPC REPORTS MENU","IPC")
 S X=$$ADD^XPDMENU("APCL IPC REPORTS MENU","BDPMENU","BDP")
 S X=$$ADD^XPDMENU("APCL IPC REPORTS MENU","BSD MENU PRIMARY CARE","PCP")
 Q

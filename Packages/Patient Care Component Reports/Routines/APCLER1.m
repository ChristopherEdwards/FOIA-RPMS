APCLER1 ; IHS/CMI/LAB - APC visit counts by selected vars ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLSITE=DUZ(2)
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
 ;
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
CLINIC ;
 S APCLCLN=""
 S DIR(0)="S^A:ANY Clinic;O:One particular Clinic",DIR("A")="Include Returns from",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G LOC
CLN ;get clinic at which the patient should have been seen prior
    ;to returning to ER
 W !!,"You must indicate in which clinic the patient was to have seen seen prior",!,"to returning to the Emergency Room",!
 S DIC("A")="Which Clinic: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:X="^" CLINIC K DIC,DA G:Y<0 CLN
 S APCLCLN=+Y
LOC ;get location
 W ! S DIR(0)="YO",DIR("A")="Include visits from ALL Locations",DIR("?")="If you wish to include visits from ALL locations answer Yes.  If you wish to tabulate for only one location of encounter enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLLOC="" G HR
LOC1 ;enter location
 S DIC("A")="Which Location: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOC
 S APCLLOC=+Y
HR ;48 or 72 hr
 S APCLHR=""
 S DIR(0)="S^7:72 HOURS;4:48 HOURS",DIR("A")="Run Report for returns w/in how many hours",DIR("B")="7" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LOC
 S APCLHR=Y
DEF S X=30,DIC(0)="M",DIC="^DIC(40.7," D ^DIC K DIC,X I Y=-1 W !!,"CLINIC CODE 30 - EMERGENCY ROOM MISSING FROM FILE - NOTIFY YOUR SITE MANAGER!!" G XIT
 S APCLERCL=+Y
PROV ;one provider or all
 S APCLPROV=""
 S DIR(0)="S^A:ANY Provider;O:One particular Provider",DIR("A")="Include Returns from Clinic Visits to",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G ZIS
PRV ;get provider which the patient should have been seen prior
    ;to returning to ER
 W !!,"You must indicate in which provider the patient was to have seen seen prior",!,"to returning to the Emergency Room",!
 S DIC("A")="Which Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:X="^" PROV K DIC,DA G:Y<0 PRV
 S APCLPROV=+Y
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G PROV
 S XBRP="^APCLER1P",XBRC="^APCLER11",XBRX="XIT^APCLER1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCL1,APCL2,APCL3D,APCLAGE,APCLAP,APCLBD,APCLBDD,APCLBT,APCLBTH,APCLCLIN,APCLCLN,APCLDATE,APCLDFN,APCLDISC,APCLDT,APCLED,APCLEDD,APCLERCL,APCLET,APCLFAC,APCLFRST,APCLFVD,APCLHIGH,APCLHRCN,APCLIVD,APCLJOB,APCLLOC,APCLLOCC,APCLNAME
 K APCLODAT,APCLP,APCLPG,APLCPPOV,APCLQUIT,APCLSD,APCLSITE,APCLSKIP,APCLT1,APCLT2,APCLV,APCLVD,APCLVDFN,APCLVLOC,APCLVREC,APCLX,APCLY,APCLZ
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M,DA,D0,DR,DIC,DIE,DIR,DTOUT,DUOUT,H,M,S
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,"This report will produce a list of patient visits.  The visits are those",!,"for which the patient had a clinic visit and then returned within 48/72 hours  "
 W !,"of that visit to the Emergency Room.  The user selects which clinic"
 W !,"and which location of encounter.",!
 W "The user may limit the list to just visits to a particular provider."
 W !,"This list of visits can potentially be used for Ambulatory Indicator A-1",!,"of the Maryland Hospital Association Project.",!
 Q
 ;

APCLRT1 ; IHS/CMI/LAB - APC visit counts by selected vars ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
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
 S (APCLCLTY,APCLFCLN,APCLTCLN)=""
 S DIR(0)="S^S:Returns from one particular clinic to the same clinic;A:Returns from any clinic to any clinic;O:Returns from one particular clinic to any other clinic;P:Returns from any clinic to one particular clinic"
 S DIR("A")="Select which scenario",DIR("B")="O" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) GETDATES
 S APCLCLTY=Y
 I APCLCLTY="A" S APCLFCLN="",APCLTCLN="" G LOC
 I APCLCLTY="S" D SCLN I APCLFCLN="" G CLINIC
 I APCLCLTY="O" D FCLN I APCLFCLN="" G CLINIC
 I APCLCLTY="P" D TCLN I APCLTCLN="" G CLINIC
LOC ;get location
 K APCLLOC
 S DIR(0)="S^O:One Location;T:Taxonomy of Predefined Locations;A:All Locations"
 S DIR("A")="Include visits from which set of locations",DIR("B")="O" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) BD
 I Y="A" K APCLLOC G HR
 I Y="O" D O G:$D(APCLQ) LOC
 I Y="T" D T G:$D(APCLQ) LOC
HR ;48 or 72 hr
 S APCLHR=7
 ;S DIR(0)="S^7:72 HOURS;4:48 HOURS",DIR("A")="Run Report for returns w/in how many hours",DIR("B")="7" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G LOC
 ;S APCLHR=Y
DEF ;S X=30,DIC(0)="M",DIC="^DIC(40.7," D ^DIC K DIC,X I Y=-1 W !!,"CLINIC CODE 30 - EMERGENCY ROOM MISSING FROM FILE - NOTIFY YOUR SITE MANAGER!!" G XIT
 ;S APCLRTCL=+Y
PROV ;one provider or all
 S APCLPROV=""
 S DIR(0)="S^A:ANY Provider;O:One particular Provider",DIR("A")="Include Returns from Clinic Visits to",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G DX
PRV ;get provider which the patient should have been seen prior
 ;to returning to ER
 W !!,"You must indicate in which provider the patient was to have seen seen prior",!,"to returning to the Emergency Room",!
 S DIC("A")="Which Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:X="^" PROV K DIC,DA G:Y<0 PRV
 S APCLPROV=+Y
DX ;should other visit have the same diagnosis?
 S APCLSDX=""
 S DIR(0)="Y",DIR("A")="Should the visits have the same primary diagnosis",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROV
 S APCLSDX=Y
INC ;
 S APCLEINC=""
 S DIR(0)="Y",DIR("A")="Should Incomplete visits be excluded",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DX
 S APCLEINC=Y
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G PROV
 S XBRP="^APCLRT1P",XBRC="^APCLRT11",XBRX="XIT^APCLRT1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCL1,APCL2,APCL3D,APCLAGE,APCLAP,APCLBD,APCLBDD,APCLBT,APCLBTH,APCLCLIN,APCLCLN,APCLDATE,APCLDFN,APCLDISC,APCLDT,APCLED,APCLEDD,APCLRTCL,APCLET,APCLFAC,APCLFRST,APCLFVD,APCLHIGH,APCLHRCN,APCLIVD,APCLJOB,APCLLOC,APCLLOCC,APCLNAME
 K APCLODAT,APCLP,APCLPG,APLCPPOV,APCLQUIT,APCLSD,APCLSITE,APCLSKIP,APCLT1,APCLT2,APCLV,APCLVD,APCLVDFN,APCLVLOC,APCLVREC,APCLX,APCLY,APCLZ
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M,DA,D0,DR,DIC,DIE,DIR,DTOUT,DUOUT,H,M,S
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,"This report will produce a list of patient visits.  The visits are those",!,"for which the patient had a clinic visit and then returned within 72 hours  "
 W !,"of that visit to the same clinic or to another clinic."
 W !,"The user selects which clinic and which location of encounter.",!
 W "The user may limit the list to just visits to a particular provider."
 Q
 ;
TCLN ;get clinic at which the patient should have been seen prior
 S (APCLFCLN,APCLTCLN)=""
 W !!,"You must indicate in which clinic the patient returned to",!,"w/in 72 hours of another clinic visit."
 S DIC("A")="Which Clinic: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 Q:X="^"
 Q:Y<0
 S APCLTCLN=+Y,APCLFCLN=""
 Q
FCLN ;get clinic at which the patient should have been seen prior
 S (APCLFCLN,APCLTCLN)=""
 W !!,"You must indicate in which clinic the patient was seen and returned",!,"to any clinic w/in 72 hours.",!
 S DIC("A")="Which Clinic: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 Q:X="^"
 Q:Y<0
 S APCLFCLN=+Y,APCLTCLN=""
 Q
SCLN ;get clinic at which the patient should have been seen prior
 S (APCLFCLN,APCLTCLN)=""
 W !!,"You must indicate in which clinic the patient was seen and returned",!,"to w/in 72 hours.",!
 S DIC("A")="Which Clinic: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 Q:X="^"
 Q:Y<0
 S (APCLFCLN,APCLTCLN)=+Y
 Q
O ;EP one location
 K APCLQ
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOC(+Y)=""
 Q
T ;
 K APCLQ
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Which TAXONOMY: ",DIC("S")="I $P(^(0),U,15)=9999999.06" D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X=""  S APCLLOC(X)=""
 Q

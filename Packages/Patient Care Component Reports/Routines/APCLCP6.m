APCLCP6 ; IHS/CMI/LAB - activity report print ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLSITE=DUZ(2)
 I APCLSORV="APCLAP" S APCLSORT="PROVIDER",APCLNSP="APCLCP6"
 I APCLSORV="APCLSU" S APCLSORT="SERVICE UNIT",APCLNSP="APCLCP7"
 D INFORM
GETGROUP ;
 S DIC="^APCLACTG(",DIC("A")="Enter the Provider Discipline Group you wish to report on: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 W !,"Bye ... " G XIT
 S APCLACTG=+Y
 W !!,"You have selected the ",$P(Y,U,2)," discipline group.",!
 S DIC="^APCLACTG(",DA=+Y D EN^DIQ K DIC,DA
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETGROUP
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
LOC ;get location
 K APCLLOC
 S DIR(0)="S^O:One Location;T:Taxonomy of or Selected Set of Locations;A:All Locations"
 S DIR("A")="Include visits from which set of locations",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) BD
 I Y="A" K APCLLOC G CLINIC
 I Y="O" D O^APCLCP1 G:$D(APCLQ) LOC
 I Y="T" D T^APCLCP1 G:$D(APCLQ) LOC
CLINIC ;
 K APCLCLN
 S DIR(0)="S^O:One Clinic;T:Taxonomy of or Selected Set of Clinics;A:All Clinics"
 S DIR("A")="Include visits from which set of clinics",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) LOC
 I Y="A" K APCLCLN G ZIS
 I Y="O" D OC^APCLCP1 G:$D(APCLQ) CLINIC
 I Y="T" D TC^APCLCP1 G:$D(APCLQ) CLINIC
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CLINIC
 S XBRP="^APCLCP6P",XBRC="^APCLCP61",XBRX="XIT^APCLCP6",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 I '$D(ZTQUEUED) S IOP="HOME" D ^%ZIS U IO(0)
 K APCL80S,APCLBDD,APCLBT,APCLDT,APCLED,APCLEDD,APCLLENG,APCLLOC,APCLPG,APCLQUIT,APCL1,APCL2,APCLAP,APCLDISC,APCLODAT,APCLSD,APCLSKIP,APCLVACT,APCLVDFN,APCLVLOC,APCLVREC,APCLVTM,APCLVTT,APCLX,APCLY,APCLPRIM,APCLSITE,APCLBD
 K APCLACTG,APCLJOB
 K X,X1,X2,IO("Q"),%,Y,DIRUT,POP,ZTSK,ZTQUEUED,T,S,M,TS,H,DIR,DUOUT,DTOUT,DUOUT,DLOUT,APCLVAL,APCLVALP,APCLNSP,APCLSORT,APCLSORV,APCLAP,APCLSU
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"Number of Individuals Seen by ",APCLSORT," for staff members in the discipline",!,"group that you select.",!
 W !,"This report displays, by location of encounter, the number of individuals",!,"seen by each provider with a discipline in the discipline group that you select."
 W !
 Q
 ;
 ;
O ;EP one location
 K APCLQ
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOC(+Y)=""
 Q
T ;EP taxonomy
 K APCLQ
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Which TAXONOMY: ",DIC("S")="I $P(^(0),U,15)=9999999.06" D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X=""  S APCLLOC(X)=""
 Q
OC ;EP one location
 K APCLQ
 S DIC="^DIC(40.7,",DIC(0)="AEMQ",DIC("A")="Which CLINIC: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLCLN(+Y)=""
 Q
TC ;EP taxonomy
 K APCLQ
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Which TAXONOMY: ",DIC("S")="I $P(^(0),U,15)=40.7" D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X=""  S APCLCLN(X)=""
 Q

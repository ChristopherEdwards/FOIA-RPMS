APCLCP1 ; IHS/CMI/LAB - DISC tally activity time ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLSITE=DUZ(2)
 I APCLSORV="APCLVLOC" S APCLNSP="APCLCP1",APCLSORT="LOCATION OF ENCOUNTER"
 I APCLSORV="APCLCODE" S APCLNSP="APCLCP2",APCLSORT="PRIMARY DX"
 D INFORM
 ;
GETGROUP ;
 W ! S DIC="^APCLACTG(",DIC("A")="Enter the Provider Discipline Group you wish to report on: ",DIC(0)="AEMQ" D ^DIC
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
 S DIR(0)="S^O:One Location;T:Taxonomy of or Selected set of Locations;A:All Locations"
 S DIR("A")="Include visits from which set of locations",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) BD
 I Y="A" K APCLLOC G CLINIC
 I Y="O" D O G:$D(APCLQ) LOC
 I Y="T" D T G:$D(APCLQ) LOC
CLINIC ;
 K APCLCLN
 S DIR(0)="S^O:One Clinic;T:Taxonomy or Selected Set of Clinics;A:All Clinics"
 S DIR("A")="Include visits from which set of clinics",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) LOC
 I Y="A" K APCLCLN G ZIS
 I Y="O" D OC G:$D(APCLQ) CLINIC
 I Y="T" D TC G:$D(APCLQ) CLINIC
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CLINIC
 S XBRP="^APCLCP1P",XBRC="^APCLCP11",XBRX="XIT^APCLCP1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
 ;
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCL80S,APCLBDD,APCLBT,APCLDT,APCLED,APCLEDD,APCLLENG,APCLLOC,APCLPG,APCLQUIT,APCL1,APCL2,APCLAP,APCLDISC,APCLODAT,APCLSD,APCLSKIP,APCLVACT,APCLVDFN,APCLVLOC,APCLVREC,APCLVTM,APCLVTT,APCLX,APCLY,APCLPRIM,APCLSITE,APCLBD
 K APCLACTG,APCLPIEC,APCLGLOB,APCLRRTN,APCLJOB
 K X,Z,X1,X2,IO("Q"),%,Y,DIRUT,POP,ZTSK,ZTQUEUED,T,S,M,TS,H,DIR,DUOUT,DTOUT,DUOUT,DLOUT,APCLNSP,APCLSORT,APCLZ,APCLSORV,APCLVAL,APCLSUB
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"Time and Services Report by Provider a Group of Provider Disciplines",!,"that you select.",!
 W !,"This report displays by ",APCLSORT,", the number of patient",!,"contacts and the total activity and travel time for each provider",!,"with a discipline in the provider discipline group that you select."
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
 K APCLLOC
 S X="ENCOUNTER LOCATION",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLQ=1 Q
 D PEP^AMQQGTX0(+Y,"APCLLOC(")
 I '$D(APCLLOC) S APCLQ=1 Q
 I $D(APCLLOC("*")) K APCLLOC W !!,$C(7),$C(7),"ALL locations is NOT an option with this choice",! G T
 S X="" F  S X=$O(APCLLOC(X)) Q:X=""  S APCLLOC(X)=""
 Q
 ;S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Which TAXONOMY: ",DIC("S")="I $P(^(0),U,15)=9999999.06" D ^DIC K DIC
 ;I Y=-1 S APCLQ="" Q
 ;S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X=""  S APCLLOC(X)=""
 Q
OC ;EP one location
 K APCLQ
 S DIC="^DIC(40.7,",DIC(0)="AEMQ",DIC("A")="Which CLINIC: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLCLN(+Y)=""
 Q
TC ;EP taxonomy
 K APCLQ
 K APCLCLN
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLQ=1 Q
 D PEP^AMQQGTX0(+Y,"APCLCLN(")
 I '$D(APCLCLN) S APCLQ=1 Q
 I $D(APCLCLN("*")) K APCLCLN W !!,$C(7),$C(7),"ALL CLINICs is NOT an option with this choice",! G TC
 S X="" F  S X=$O(APCLCLN(X)) Q:X=""  S APCLCLN(X)=""
 Q
 ;S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Which TAXONOMY: ",DIC("S")="I $P(^(0),U,15)=40.7" D ^DIC K DIC
 ;I Y=-1 S APCLQ="" Q
 ;S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X=""  S APCLCLN(X)=""
 Q

APCLCP8 ; IHS/CMI/LAB - GIS/TUCSON PCC REPORT WITH AGE BUCKETS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This routine will print the PCC Report that uses age buckets
 ;to tabulate sex,tribe or current community by age.
 ;
 ;Calls APCLBIN1
 ;Called from option APCL P BIN AGE BUCKETS
 ;
START ;
 W:$D(IOF) @IOF
 W !,"This report will present, for all visits on whichstaff members of",!,"discipline group that you select was a provider, time and patient services",!,"by age and sex.",!
 S Y=DT D DD^%DT S APCLDT=Y
GETGROUP ;
 S DIC="^APCLACTG(",DIC("A")="Enter the Provider Discipline Group you wish to report on: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 W !,"Bye ... " G XIT
 S APCLACTG=+Y
 W !!,"You have selected the ",$P(Y,U,2)," discipline group.",!
 S DIC="^APCLACTG(",DA=+Y D EN^DIQ K DIC,DA
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="DA^:DT:EP",DIR("A")="Enter beginning Visit Date for Search:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETGROUP
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
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
 I Y="A" K APCLCLN G BIN
 I Y="O" D OC^APCLCP1 G:$D(APCLQ) CLINIC
 I Y="T" D TC^APCLCP1 G:$D(APCLQ) CLINIC
 ;
BIN S APCLBIN="0-0;1-4;5-14;15-19;20-24;25-44;45-64;65-125"
 W !!,"The Age Groups to be used are currently defined as:",! D LIST
 S DIR(0)="YO",DIR("A")="Do you wish to modify these age groups",DIR("B")="No" D ^DIR K DIR
 I $D(DIRUT) G GETDATES
 I Y=0 G ZIS
RUN ;
 K APCLQUIT S APCLY="",APCLA=-1 W ! F  D AGE Q:APCLX=""  I $D(APCLQUIT) G BIN
 D CLOSE I $D(APCLQUIT) G BIN
 D LIST
 G ZIS
 ;
AGE ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the starting age of the "_$S(APCLY="":"first",1:"next")_" age group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S APCLQUIT="" Q
 S APCLX=Y
 I Y="" Q
 I APCLX?1.3N,APCLX>APCLA D SET Q
 W $C(7) W !,"Make sure the age is higher the beginning age of the previous group.",! G RUN
 ;
SET S APCLA=APCLX
 I APCLY="" S APCLY=APCLX Q
 S APCLY=APCLY_"-"_(APCLX-1)_";"_APCLX
 Q
 ;
CLOSE I APCLY="" Q
GC ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the highest age for the last group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S APCLQUIT="" Q
 S APCLX=Y I Y="" S APCLX=199
 I APCLX?1.3N,APCLX'<APCLA S APCLY=APCLY_"-"_APCLX,APCLBIN=APCLY Q
 W "  ??",$C(7) G CLOSE
 Q
 ;
 ;
LIST ;
 S %=APCLBIN
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,":")," - ",$P(X,":",2)
 W !
 Q
 ;
SETBIN ;
 S APCLBIN="0:0;1:4;5:14;15:19;20:24;25:44;45:64;65:125"
 Q
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G BIN
 S XBRP="^APCLCP8P",XBRC="^APCLCP81",XBRX="XIT^APCLCP8",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
 ;
XIT ;
 K APCL80S,APCLBDD,APCLBT,APCLDT,APCLED,APCLEDD,APCLLENG,APCLLOC,APCLPG,APCLQUIT,APCL1,APCL2,APCLAP,APCLDISC,APCLODAT,APCLSD,APCLSKIP,APCLVACT,APCLVDFN,APCLVLOC,APCLVREC,APCLVTM,APCLVTT,APCLX,APCLY,APCLPRIM,APCLSITE,APCLBD
 K APCLA,APCLAGE,APCLBIN,APCLCHN,APCLDOB,APCLDOBS,APLCFOUN,APCLJOB,APCLNN,APCLSEX,APCLZ,APCLBT,APCLFOUN,APCLACTG
 K X,X1,X2,IO("Q"),%,Y,DIRUT,POP,ZTSK,ZTQUEUED,T,S,M,TS,H,DIR,DUOUT,DTOUT,DUOUT,DLOUT
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

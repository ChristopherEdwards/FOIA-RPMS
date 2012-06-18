APCLCZP ; IHS/CMI/LAB - All visit report driver ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCLSITE Q
 S APCLRPT="C"
 I '$D(APCLRPT) W !,$C(7),$C(7),"REPORT TYPE MISSING!!  NOTIFY PROGRAMMER",! Q
 D GETINFO^APCLAP0 G:$D(APCLQUIT) XIT
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
CHECK ;
 I APCLRPT'="P"&(APCLRPT'="DIS") G GETDATES
 S DIR(0)="SO^P:Primary Provider Only;A:All Providers (Primary and Secondary)",DIR("A")="Report should include"
 S DIR("?")="If you wish to count only the primary provider of service enter a 'P'.  To include ALL providers enter an 'A'." D ^DIR K DIR
 G:$D(DIRUT) XIT
 I Y="A" S APCLRPT=$S(APCLRPT="DIS":"ALLDISC",1:"ALLP")
 I Y="P" S APCLRPT=$S(APCLRPT="P":"PROV",1:"DISC")
 D GETINFO^APCLAP0
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search" S Y=APCLBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
LOC I APCLRPT="LOS" S APCLLOC="" G ZIS
 S DIR(0)="YO",DIR("A")="Include visits from ALL Locations",DIR("?")="If you wish to include visits from ALL locations answer Yes.  If you wish to tabulate for only one location of encounter enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLLOC="" G ZIS
LOC1 ;enter location
 S DIC("A")="Which Location: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOC
 S APCLLOC=+Y
ZIS ;CALL TO XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LOC
 S XBRP="^APCLCZPP",XBRC="^APCLCZP1",XBRX="XIT^APCLCZP",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCLSITE,APCLRPT,APCLINFO,APCLSORT,APCLPROC,APCLINF,APCLBD,APCLED,APCLSD,APCLDT,APCLLOC,APCLODAT,APCLVDFN,APCLVLOC,APCLVREC,APCLCLIN,APCLSKIP,APCL1,APCL2,APCLAP,APCLDISC,APCLPPOV,APCLX,APCLHIGH,APCLDATE,APCLADIS,APCLJOB,APCLCZP
 K APCLDX,APCLLOW,APCLICD,APCLDA1,APCLDA2,APCLY,APCLTITL,APCL80S,APCLEDD,APCLHD1,APCLHD2,APCLLENG,APCLLOCT,APCLPG,APCLSRT2,APCLTOT,APCLBDD,APCLPROV,APCLSEC,APCLZ,APCLCAT,APCL80S,APCLSITE,APCLQUIT,APCLPRNT,APCLQUIT,APCLBT,APCLBTH
 Q
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"***** VISIT COUNTS BY ",APCLTITL," *****",!
 W !,"This report will generate a count of visits by ",APCLINF,!,"for a date range that you specify.",!
 W "ALL Visits in the database will be included in the tabulation with",!,"the exception of the following:  "
 W !,"VISIT TYPES:  Contract, VA",!,"VISIT SERVICE CATEGORIES:  Chart Review, In-Hospital, Hospitalizations,",!,"Historical Events, and Telephone Calls..",!
 W "Visits MUST have a Primary Provider and Purpose of Visit.",!
 W "The report will be sub-totaled by Location of Encounter.",!
 W !!,"THIS REPORT WILL BE SUB-TOTALED BY ZIP CODE.",!
 Q
 ;
 ;

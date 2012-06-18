APCLRAD ; IHS/CMI/LAB - ADMISSIONS 30 DAYS AFTER A DISCHARGE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
 ;
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date for Report" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Report:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
LOC ; 
 S DIR(0)="S^O:ONE FACILITY ONLY;A:ANY FACILITY",DIR("A")="Include admissions to ",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y="A" S APCLLOC="" G ZIS
LOC1 ;enter location
 S DIC("A")="Which Location: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOC
 S APCLLOC=+Y
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LOC
 S XBRP="^APCLRADP",XBRC="^APCLRAD1",XBRX="XIT^APCLRAD",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCL3D,APCLBD,APCLBT,APCLBTH,APCLDFN,APCLED,APCLFAC,APCLFRST,APCLFVD,APCLIVD,APCLJOB,APCLLOC,APCLP,APCLPG,APCLQUIT,APCLSD,APCLV,APCLVDFN,APCLVREC
 D KILL^AUPNPAT
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,"ADMISSIONS WITHIN n DAYS of A DISCHARGE"
 W !!,"This report will display patients who have had an admission within",!," 30 number of days of a discharge.",!
 W !,"The user will decide whether to include admissions to any facility",!,"or to only one facility.  For example, if a patient was admitted to the local"
 W !,"facility and within 30 days was admitted to a contract facility, and if",!,"you choose to included all facilities in the report, this admission",!,"will be included in the report.",!
 Q
 ;

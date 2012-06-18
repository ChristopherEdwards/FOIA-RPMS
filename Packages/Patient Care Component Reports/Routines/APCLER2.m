APCLER2 ; IHS/CMI/LAB - APC visit counts by selected vars ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
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
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G GETDATES
 S XBRP="^APCLER2P",XBRC="^APCLER21",XBRX="XIT^APCLER2",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCL1,APCL2,APCL1D,APCLAGE,APCLAP,APCLBD,APCLBDD,APCLBT,APCLBTH,APCLCLIN,APCLCLN,APCLDATE,APCLDFN,APCLDISC,APCLDT,APCLED,APCLEDD,APCLERCL,APCLET,APCLFAC,APCLFRST,APCLFVD,APCLHIGH,APCLHRCN,APCLIVD,APCLJOB,APCLLOC,APCLLOCC,APCLNAME
 K APCLODAT,APCLP,APCLPG,APLCPPOV,APCLQUIT,APCLSD,APCLSITE,APCLSKIP,APCLT1,APCLT2,APCLV,APCLVD,APCLVDFN,APCLVLOC,APCLVREC,APCLX,APCLY,APCLZ,APCLVER
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M,DA,D0,DR,DIC,DIE,DIR,DTOUT,DUOUT,H,M,S
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,"This report will produce a list of admissions from the ER.  This report",!,"searches for visits to the ER in the date range entered by the user, and if"
 W !,"there is also an admission to your facility on that day, the visits are",!,"printed.",!
 W !,"Just a note of caution, some visits listed here may NOT have actually been",!,"admissions directly from the ER.  What are listed are all occurrences of,",!,"an ER visit on the same day as an admission.",!
 Q
 ;

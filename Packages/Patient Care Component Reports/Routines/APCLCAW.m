APCLCAW ; IHS/CMI/LAB -CLINIC VISITS TALLY OF WALKIN&APPT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCLSITE Q
 S APCLSITE=DUZ(2)
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
LOC ;
 S APCLLOC=$$GETLOC^APCLOCCK
 I APCLLOC=-1 G BD
 ;
CLIN ;
 S DIR(0)="YO",DIR("A")="Include visits from ALL Clinics",DIR("?")="If you wish to include visits from ALL of clinics answer Yes.  If you wish to tabulate for a single clinic enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLCLN="A" G ZIS ;IHS/CMI/LAB - mult clinics per california request
CLIN1 ;
 K APCLCLN
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCLN(")
 I '$D(APCLCLN) G CLIN
 I $D(APCLCLN("*")) K APCLCLN S APCLCLN="A"
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CLIN
 S XBRP="^APCLCAWP",XBRC="^APCLCAW1",XBRX="XIT^APCLCAW",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCL80S,APCLAPPT,APCLBD,APCLBDD,APCLCLN,APCLCLNT,APCLDT,APCLED,APCLEDD,APCLGTAP,APCLGTOT,APCLGTUN,APCLGTWI,APCLODAT,APCLPG,APCLPRNT,APCLSD,APCLSITE,APCLSORT,APCLSRT2,APCLSRT3,APCLTOT,APCLUNLT,APCLUNST,APCLAPLT
 K APCLVDFN,APCLVLOC,APCLWILT,APCLWIT,APCLBT,APCLLENG,APCLLOC,APCLLOCT,APCLLTOT,APCLQUIT,APCLJOB
 K X,Y,ZTSK,X1,X2,DIC,DA,DIG,DIH,DIR,DIRUT,DIU,DIV
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"***** TALLY OF APPOINTMENTS AND WALKINS FOR CLINIC VISITS *****"
 W !,"This report will generate a count of visits by clinic",!,"for a date range that you specify.",!
 W "ALL Visits in the database will be included in the tabulation with",!,"the exception of the following:  "
 W !,"VISIT TYPES:  Contract, VA",!,"VISIT SERVICE CATEGORIES:  Chart Review, In-Hospital, Hospitalizations,",!,"Historical Events.",!
 W "Visits MUST have a Primary Provider and Purpose of Visit.",!
 W "The report will be sub-totaled by Location of Encounter.",!
 Q
 ;
 ;

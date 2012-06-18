APCLYV2 ; IHS/CMI/LAB - OUTPATIENT VISITS BY DATE RANGE WITH ICD CODES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This report replaces the general outpatient visit retrieval
 ;
 W:$D(IOF) @IOF W !!?10,"LISTING OF OUTPATIENT VISITS WITH ICD CODES",!!
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
LOC ;
 S DIR(0)="YO",DIR("A")="Include visits from ALL Locations",DIR("?")="If you wish to include visits from ALL locations answer Yes.  If you wish to tabulate for only one location of encounter enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLLOC="" G PROV
LOC1 ;enter location
 S DIC("A")="Which Location: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOC
 S APCLLOC=+Y
PROV ;
 S DIR(0)="YO",DIR("A")="Do you wish include visits to ALL Providers",DIR("?")="If you wish to include visits to ALL providers answer YES. answer Yes.  If you wish to tabulate for visits to ONE provider only enter NO." D ^DIR K DIR
 G:$D(DIRUT) LOC
 I Y=1 S APCLPROV="" G ZIS
 I $P(^DD(9000010.06,.01,0),U,2)[200 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $P(^DD(9000010.06,.01,0),U,2)[6 S DIC="^DIC(6,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D ^DIC K DIC
 I Y=-1!(X="^") G LOC
 S APCLPROV=+Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G PROV
 W $C(7),$C(7),!!,"THIS REPORT MUST BE PRINTED ON 132 COLUMN PAPER!",!
 S XBRC="^APCLYV21",XBRP="^APCLYV22",XBNS="APCL",XBRX="END^APCLYV2"
 D ^XBDBQUE
END K Y,APCLBD,APCLED,ZTSK,ZTQUEUED,%DT,POP,APCLBT,APCLJOB,APCLLOC,APCLSD,APCLPROV,APCLFOUN,APCLDFN
 Q

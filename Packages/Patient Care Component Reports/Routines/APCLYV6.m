APCLYV6 ; IHS/CMI/LAB - VISIT COUNTS BY PROVIDER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This report counts visits by provider for a range of dates
 ;
 W:$D(IOF) @IOF W !!?20,"OUTPATIENT CLINIC VISIT COUNTS BY PROVIDER",!!
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
PRV ;
 S DIR(0)="S^1:Print Visit counts for ONE PROVIDER;2:Print visit counts for ONE PROVIDER CLASS;3:Print visit counts for ALL PROVIDERS",DIR("A")="Select which visits to display",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETDATES
 S APCLS=Y
 I APCLS=3 S APCLPRV=0 G LOC
 I APCLS=1 S DIC=$S($P(^DD(9000010.06,.01,0),U,2)[200:200,1:6),DIC("A")="WHICH PROVIDER: "
 I APCLS'=1 S DIC=7
 S DIC(0)="AEQMZ"
 I DIC=7!(DIC=6) D ^DIC
 I DIC=200 S D="AK.PROVIDER" D MIX^DIC1
 G PRV:Y<0 S APCLPRV=Y
LOC ;
 K APCLLOC
 S DIR(0)="S^O:ONE LOCATION/FACILITY;A:ALL LOCATIONS/FACILITIES",DIR("A")="Include visits to ",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) PRV
 I Y="A" K APCLLOC G SC
O ;
 S DIR(0)="9000010,.06",DIR("A")="Include visits for which Facility" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"No facilty entered." G LOC
 S APCLLOC=+Y
SC ;
 K APCLSCAT
 W !!,"Please select which visit service categories you wish to include,"
 W !,"e.g.  1,4,5,6,7 to include ambulatory, not found, day surgery and "
 W !,"observations.  Please note: events, hospitalizations, in-hospital"
 W !,"visits are automatically EXCLUDED:",!
 W !?5,"1  A-AMBULATORY"
 W !?5,"2  C-CHART REVIEW"
 W !?5,"3  T-TELECOMMUNICATIONS"
 W !?5,"4  N-NOT FOUND"
 W !?5,"5  S-DAY SURGERY"
 W !?5,"6  O-OBSERVATION"
 W !?5,"7  R-NURSING HOME"
 W !
 K DIR S DIR(0)="L^0:7",DIR("A")="Which visit service categories should be included",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LOC
 I Y="" G LOC
 S APCLSCAT=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S X=$S(C=1:"A",C=2:"C",C=3:"T",C=4:"N",C=5:"S",C=6:"O",C=7:"R",1:"") I X]"" S APCLSCAT(X)=""
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SC
 S XBRC="^APCLYV61",XBRP="^APCLYV62",XBNS="APCL",XBRX="END^APCLYV6"
 D ^XBDBQUE
END K ZTSK,Y,APCLBD,APCLED,APCLCL,APCLS,IO("Q"),APCLLOC Q

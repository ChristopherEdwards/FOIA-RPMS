APCDFCT ; IHS/CMI/LAB - COUNT FORMS REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 S APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCDSITE Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER",!! K APCDSITE Q
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Posting Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter ending Posting Date: " S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
 ;
DEC ;
 S DIR(0)="YO",DIR("A")="Report on ALL Operators",DIR("?")="If you wish to include visits entered by ALL Operators answer Yes.  If you wish to tabulate for only one operator enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCDDEC="ALL" G SORT
DEC1 ;enter location
 S DIC("A")="Which Operator: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 DEC
 S APCDDEC=+Y
SORT ;
 S DIR(0)="S^1:CLINIC TYPE;2:SERVICE CATEGORY;3:VISIT TYPE;4:INCLUDE ALL VISITS",DIR("A")="Count number of Forms Processed by",DIR("B")="4" D ^DIR K DIR
 I $D(DIRUT) G DEC
 S APCDPROC=+Y I APCDPROC=4 S APCDSRT="" G ZIS
 S APCDSRT=Y(0)
ZIS ;
 S XBRC="^APCDFCT1",XBRP="^APCDFCTP",XBRX="XIT^APCDFCT",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K DIC,%DT,IO("Q"),X,Y,POP,DIRUT,ZTSK,APCDH,APCDM,APCDS,APCDTS,ZTIO
 K APCD1,APCD2,APCD80S,APCDAP,APCDBD,APCDBDD,APCDBT,APCDDATE,APCDDEC,APCDDT,APCDED,APCDEDD,APCDET,APCDGOT,APCDFCT,APCDVDES,APCDTDES,APCDDESU,APCDX
 K APCDLENG,APCDODAT,APCDPG,APCDPROC,APCDPROV,APCDSD,APCDSITE,APCDSORT,APCDSRT,APCDSUB,APCDTOT,APCDVDFN,APCDVREC,APCDWDAT,APCDY,APCDC,APCDDFN,APCDAVG,APCDDEC
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"This report will generate a count of visits entered by a particular data entry",!,"operator or for ALL data entry operators for a date range that you specify.",!
 W !,"This report is operators who enter Tran Codes via the 2 options for",!,"entering tran codes on outpatient and in hospital visits.",!
 Q
 ;

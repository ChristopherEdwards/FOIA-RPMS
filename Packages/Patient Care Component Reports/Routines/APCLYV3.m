APCLYV3 ; IHS/CMI/LAB - CLINIC VISITS BY DATE RANGE WITH POV ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This report is to be used to list visits by clinic
 ;
 W:$D(IOF) @IOF W !!?20,"LISTING OF CLINIC VISITS WITH ICD CODES",!!
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G END
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date: " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
 ;
CLINIC ;
 S DIR(0)="S^1:Print for ALL clinics;2:Print for ONE clinic;3:Print visits with no clinic code",DIR("A")="     Selection" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 I Y=1 S APCLCL="A" G ICD
 I Y=3 S APCLCL="N" G ICD
 K DIC S DIC=40.7,DIC(0)="AEQMZ",DIC("A")="Which Clinic:  " D ^DIC
 G CLINIC:Y<1 S APCLCL=+Y
ICD ;
 W !!
 S DIR(0)="S^1:Print all Visits;2:Print Visits for a range of POV ICD codes;3:Print Visits for a range of Procedure ICD codes",DIR("A")="     Which visits should be printed" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) CLINIC
 S APCLICD=Y
 I APCLICD=1 S (APCLBICD,APCLEICD)="" G LOC
LKUP K DIC S DIC=$S(APCLICD=2:80,1:80.1) S DIC(0)="AEMQZ"
 S DIC("A")="Enter the beginning ICD code: " D ^DIC G ICD:Y<1
 S APCLBICD=$P(Y(0),"^"),DIC("A")="Enter the ending ICD code: " D ^DIC
 G ICD:Y<1 S APCLEICD=$P(Y(0),"^")
 I APCLEICD<APCLBICD W $C(7),!,"Ending code must be greater than or equal to beginning code" G LKUP
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
 S DIC("A")="Which Provider: ",DIC=$S($P(^DD(9000010.06,.01,0),U,2)[200:"^VA(200,",1:"^DIC(6,"),DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOC
 S APCLPROV=+Y
ZIS  ;
 S XBRC="CALC^APCLYV31",XBRP="^APCLYV32",XBNS="APCL",XBRX="END^APCLYV3"
 D ^XBDBQUE
END K Y,APCLBD,APCLED,APCLCL,APCLICD,APCLBICD,APCLEICD,ZTSK,ZTQUEUED,%DT,APCLLOC,APCLBT,APCLSD,APCLJOB,APCLPROV,APCLFOUN,APCLDFN
 K APCL65,APCLBD,APCLCLS,APCLED,APCLFPV,APCLFVS,APCLIOM,APCLMCR,DA,DFN,%DT,%T,%Y,APCLAGE,G,POP
 K APCLNAME,APCLNAR,APCLPRC,APCLPRV,APCLPS,APCLPTOT,APCLPV,APCLSTR
 K APCLSTOP,APCLVDFN,APCLVDT,APCLVPOV,APCLVPRC,APCLVRV,APCLVTOT,Y
 K DIC,DOB,DR,APCLHRCN,I,LKPRINT,SEX,SFX,APCLSTR,X,APCLCLX,APCLCL,APCLPGRD
 K APCLVGRA,APCLPAGE,APCLICD,APCLBICD,APCLEICD,APCLPV,APCLPRC,APCLFLG
 Q

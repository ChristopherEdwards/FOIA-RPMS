APCLADA ; IHS/CMI/LAB - CLINIC VISITS BY DATE WITH ADA ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This report is to be used to list visits by clinic
 ;
 W:$D(IOF) @IOF W !!?20,"LISTING OF CLINIC VISITS WITH ADA CODES",!!
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
 ;
CLINIC ;
 S DIR(0)="Y",DIR("A")="Print for ALL clinics",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATES
 I Y=1 S APCLCL="A" G LOC
 K DIC S DIC=40.7,DIC(0)="AEQMZ",DIC("A")="Which Clinic:  " D ^DIC
 G CLINIC:Y<1 S APCLCL=+Y
LOC ;
 S DIR(0)="YO",DIR("A")="Include visits from ALL Locations",DIR("?")="If you wish to include visits from ALL locations answer Yes.  If you wish to tabulate for only one location of encounter enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLLOC="" G ZIS
LOC1 ;enter location
 S DIC("A")="Which Location: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 LOC
 S APCLLOC=+Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LOC
 S XBRC="^APCLADA1",XBRP="^APCLADAP",XBNS="APCL",XBRX="END^APCLADA"
 D ^XBDBQUE
END K Y,APCLBD,APCLED,APCLCL,APCLADA,APCLBADA,APCLEADA,ZTSK,ZTQUEUED,%DT,APCLLOC,APCLBT,APCLSD,APCLJOB,APCLFPV,APCLNARR,APCLCLX,APCLNAME,APCLSTR,APCLVDFN,APCLVDT,APCLVGRA,APCLVTOT,APCLPGRD
 K APCLCLX,APCLNAME,APCLSTR,APCLVDFN,APCLVDT,APCLDFN,APCLAGE,APCLBICD,APCLCLS,APCLFPV,APCLFVS,APCLHRCN,APCLNAR,APCLPAGE,APCLPGRP,APCLPOVC,APCLPRV,APCLPS,APCLPTOT,APCLPV,APCLSTOP,APCLVDEN,APCLVDFN,APCLVDT,APCLVGRA,APCLVTOT
 K APCLBD,APCLED,APCLCL,APCLADA,Y,X,APCLLOC,APCLBT,APCLSD,APCLJOB,APCLFPV,APCLNARR
 Q
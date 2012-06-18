APCPDRI ; IHS/TUCSON/LAB - OHPRD-TUCSON/EDE INITIALIZATION FOR PCC TX DRIVERS AUGUST 14, 1992 ; [ 04/16/02 3:11 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,4,6**;APR 03, 1998
 ;IHS/CMI/LAB - patch 4 file 200 conversion check
 ;IHS/CMI/LAB - patch 2 force stat recs
 ;
START ;
 D BASICS ;      Set variables like U,DT,DUZ(2) etc.
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:APCP("QFLG")
 ;
 D:APCPO("RUN")="NEW" ^APCPDRI2 ;  Do new run initialization.
 Q:$D(ZTQUEUED)
 Q:APCP("QFLG")
 D:APCPO("RUN")="NEW" QUEUE
 Q
 ;
BASICS ; BASIC INITS
 D HOME^%ZIS S APCPBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K APCP,APCPS,APCPV,APCPT,APCPE
 S APCP("RUN LOCATION")=$P(^AUTTLOC(DUZ(2),0),U,10),APCP("QFLG")=0
 S APCDOVRR=1 ; Allow VISIT lookup with 0 'dependent entry count'.
 S (APCP("INPT"),APCP("CHA"),APCP("APC"),APCP("ERROR COUNT"),APCP("COUNT"),APCP("STAT"),APCP("DEL NEVER SENT"),APCP("DEMO PAT"),APCP("IN NO PP"))=0
 Q
 ;
CHKSITE ;EP
 ;S APCPS("PROV FILE")=$S($P(^AUTTSITE(1,0),U,22):200,1:6)
 S APCPS("PROV FILE")=$S($P(^DD(9000010.06,.01,0),U,2)[200:200,1:6)
 I '$D(^AUTTSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** RPMS SITE FILE has not been set up! ***" S APCP("QFLG")=1 Q
 I $P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="" W:'$D(ZTQUEUED) !!,"No ASUFAC for facility in RPMS Site file!!" S APCP("QFLG")=1 Q
 I $P($G(^AUTTSITE(1,1)),U,3)="" W:'$D(ZTQUEUED) !!,"Static ASUFAC for this site is not set up!!" S APCP("QFLG")=33 Q
 I '$D(^APCPSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S APCP("QFLG")=1 Q
 I $P(^APCPSITE(1,0),U)'=DUZ(2) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S APCP("QFLG")=2 Q
 I '$P(^APCPSITE(1,0),U,3) W:'$D(ZTQUEUED) !!,"*** No DELAY value in Site file! ***" S APCP("QFLG")=3
 I $P(^APCPSITE(1,0),U,2)="" W:'$D(ZTQUEUED) !!,"***No DEFAULT DEVICE value in Site file! ***" S APCP("QFLG")=4
 I $P(^APCPSITE(1,0),U,7)="Y" S APCPS("APC")=""
 I $P(^APCPSITE(1,0),U,8)="Y" S APCPS("INPT")=""
 I $P(^APCPSITE(1,0),U,9)="Y" S APCPS("CHA")=""
 ;I $P(^APCPSITE(1,0),U,12)="Y" S APCPS("STAT")="" ;IHS/CMI/LAB
 S APCPS("ORYX")=$P(^APCPSITE(1,0),U,13)
 S APCPS("STAT")="" ;IHS/CMI/LAB patch 2
 I $D(APCPS)'=10 W:'$D(ZTQUEUED) !!,"*** Site file does not contain the type of system for sending transactions!! ****" S APCP("QFLG")=5 Q
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I APCPO("RUN")="NEW",$D(DIRUT) S APCP("QFLG")=99 S DA=APCP("RUN LOG"),DIK="^APCPLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I APCPO("RUN")="REDO",$D(DIRUT) S APCP("QFLG")=99 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(APCPO("RUN")="NEW":"DRIVER^APCPDR",1:"EN^APCPREDO")
 S ZTIO="",ZTDTH="",ZTDESC="PCC DATA TRANSMISSION" S ZTSAVE("APCP*")="",ZTSAVE("APCD*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),APCPO("RUN")="NEW" S APCP("QFLG")=99 S DA=APCP("RUN LOG"),DIK="^APCPLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S APCPO("QUEUE")=""
 S DIE="^APCPLOG(",DA=APCP("RUN LOG"),DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q

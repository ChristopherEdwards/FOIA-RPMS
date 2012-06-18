BCHEXDI ; IHS/TUCSON/LAB - INIT FOR CHR EXPORT ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;Initialization for export process.
 ;Set up all necessary variables, check site file, etc.
 ;
START ;
 D BASICS ;      Set variables like U,DT,DUZ(2) etc.
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:BCH("QFLG")
 ;
 D:BCHO("RUN")="NEW" ^BCHEXDI2 ;  Do new run initialization.
 Q:$D(ZTQUEUED)
 Q:BCH("QFLG")
 D:BCHO("RUN")="NEW" QUEUE
 Q
 ;
BASICS ; BASIC INITS
 D HOME^%ZIS S BCHBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K BCH,BCHS,BCHV,BCHT,BCHE
 S BCH("RUN LOCATION")=$P(^AUTTLOC(DUZ(2),0),U,10),BCH("QFLG")=0
 S (BCH("U"),BCH("D"),BCH("ERROR COUNT"),BCH("COUNT"),BCH("VISIT COUNT"))=0
 Q
 ;
CHKSITE ; CHECK SITE FILE
 I '$D(^BCHSITE(DUZ(2),0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S BCH("QFLG")=1 Q
 I '$D(^BCHSITE(DUZ(2))) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S BCH("QFLG")=2 Q
 I $P(^BCHSITE(DUZ(2),0),U,8)="" W:'$D(ZTQUEUED) !!,"*** Site file does not specify EXPORT METHOD" S BCH("QFLG")=3 Q
 I $P(^BCHSITE(DUZ(2),0),U,7)="",$P(^BCHSITE(DUZ(2),0),U,8)="A" W:'$D(ZTQUEUED) !!,"***No DEFAULT DEVICE value in Site file! ***" S BCH("QFLG")=4
 Q
 ;
 ;
 ;
QUEUE ;EP - QUEUE TX GENERATOR
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BCHO("RUN")="NEW",$D(DIRUT) S BCH("QFLG")=99 S DA=BCH("RUN LOG"),DIK="^BCHXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I BCHO("RUN")="REDO",$D(DIRUT) S BCH("QFLG")=99 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(BCHO("RUN")="NEW":"DRIVER^BCHEXD",1:"EN^BCHEXRE")
 S ZTIO="",ZTDTH="",ZTDESC="CHR CHRIS II EXPORT" S ZTSAVE("BCH*")="",ZTSAVE("APCD*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BCHO("RUN")="NEW" S BCH("QFLG")=99 S DA=BCH("RUN LOG"),DIK="^BCHXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q  ;LAB/OHPRD BCH*1.51*2 ADDED BCHO("RUN")="NEW"
 S BCHO("QUEUE")=""
 S DIE="^BCHXLOG(",DA=BCH("RUN LOG"),DR=".15///Q" D CALLDIE^BCHUTIL
 K ZTSK
 Q

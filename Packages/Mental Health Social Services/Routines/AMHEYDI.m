AMHEYDI ; IHS/CMI/LAB - INIT FOR MHSS EXPORT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ;
 D BASICS ;      Set variables like U,DT,DUZ(2) etc.
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:AMH("QFLG")
 ;
 D:AMHO("RUN")="NEW" ^AMHEYDI2 ;  Do new run initialization.
 Q:$D(ZTQUEUED)
 Q:AMH("QFLG")
 D:AMHO("RUN")="NEW" QUEUE
 Q
 ;
BASICS ; BASIC INITS
 D HOME^%ZIS S AMHBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K AMH,AMHS,AMHV,AMHT,AMHE
 S AMH("RUN LOCATION")=$P(^AUTTLOC(DUZ(2),0),U,10),AMH("QFLG")=0
 S (AMH("A"),AMH("M"),AMH("D"),AMH("ERROR COUNT"),AMH("COUNT"),AMHSFC,AMH("ENC"))=0
 Q
 ;
CHKSITE ; CHECK SITE FILE
 I '$D(^AMHSITE(DUZ(2),0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S AMH("QFLG")=1 Q
 I '$D(^AMHSITE(DUZ(2))) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S AMH("QFLG")=2 Q
 Q
 ;
 ;
 ;
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I AMHO("RUN")="NEW",$D(DIRUT) S AMH("QFLG")=99 S DA=AMH("RUN LOG"),DIK="^AMHXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I AMHO("RUN")="REDO",$D(DIRUT) S AMH("QFLG")=99 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(AMHO("RUN")="NEW":"DRIVER^AMHEYD",1:"EN^AMHREDO")
 S ZTIO="",ZTDTH="",ZTDESC="BH DATA TRANSMISSION" S ZTSAVE("AMH*")="",ZTSAVE("APCD*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),AMHO("RUN")="NEW" S AMH("QFLG")=99 S DA=AMH("RUN LOG"),DIK="^AMHXLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S AMHO("QUEUE")=""
 S DIE="^AMHXLOG(",DA=AMH("RUN LOG"),DR=".15///Q" D CALLDIE^AMHLEIN
 K ZTSK
 Q

AUP2POST ; TUCSON/LAB - POST INIT TO AUP2 ;   [ 01/03/95  10:27 AM ]
 ;;93.2;AUP2 - PATCH 2 TO AUPN 93.2;*2*;JAN 03, 1995
 ;
 D ^XBKVAR
 W !!,"This routine will kill and re-index 5 'AQ' (QMAN) cross references.",!
 W "That process may take several hours, you will be given the opportunity",!,"to queue the re-indexing.",!!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT)!('Y) W !!,"YOU MUST RUN THIS ROUTINE (AUP2POST) SOMETIME!!!",!,$C(7),$C(7) G XIT
QUEUE ;
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run in the background",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D TSKMN Q
 I $D(DIRUT) W !,"Okay, you '^'ed out or timed out so I'm quitting.",! D XIT Q
DRIVER ;
 ;
VIMM ;
 K ^AUPNVIMM("AQ")
 W:'$D(ZTQUEUED) !!,"Re-indexing the AQ cross reference on V Immunization.  Hold on...."
 S DIK="^AUPNVIMM(",DIK(1)=".01^AQTOO" D ENALL^DIK
 K DIK,DA,D0
VDXP ;
 I '$D(ZTQUEUED) W !!,"Re-indexing AQ on V DIAGNOSTIC PROCEDURE RESULT",!
 K ^AUPNVDXP("AQ") S AUPNX=0 F  S AUPNX=$O(^AUPNVDXP(AUPNX)) Q:AUPNX'=+AUPNX  I $D(^AUPNVDXP(AUPNX,0)) S DA=AUPNX,X=$P(^AUPNVDXP(AUPNX,0),U,1),AUPNDXQF="S1" D ^AUPNVDXP I '$D(ZTQUEUED),'(AUPNX#100) W "."
VXAM ;re-index AQ on V exam
 I '$D(ZTQUEUED) W !!,"Re-indexing AQ on V EXAM",!
 K ^AUPNVXAM("AQ") S AUPNX=0 F  S AUPNX=$O(^AUPNVXAM(AUPNX)) Q:AUPNX'=+AUPNX  I $D(^AUPNVXAM(AUPNX,0)) S DA=AUPNX,X=$P(^AUPNVXAM(AUPNX,0),U,1) D AQE1^AUPNCIXL I '$D(ZTQUEUED),'(AUPNX#100) W "."
VSK ;re-index aq on v skin test
 I '$D(ZTQUEUED) W !!,"Re-indexing AQ on V SKIN TEST",!
 K ^AUPNVSK("AQ") S AUPNX=0 F  S AUPNX=$O(^AUPNVSK(AUPNX)) Q:AUPNX'=+AUPNX  I $D(^AUPNVSK(AUPNX,0)) S DA=AUPNX,X=$P(^AUPNVSK(AUPNX,0),U,1) D AQS1^AUPNCIXL I '$D(ZTQUEUED),'(AUPNX#100) W "."
VRAD ;
 I '$D(ZTQUEUED) W !!,"Re-indexing AQ on V RADIOLOGY",!
 K ^AUPNVRAD("AQ") S AUPNX=0 F  S AUPNX=$O(^AUPNVRAD(AUPNX)) Q:AUPNX'=+AUPNX  I $D(^AUPNVRAD(AUPNX,0))  S DA=AUPNX,X=$P(^AUPNVRAD(AUPNX,0),U,1) D AQR1^AUPNCIXL I '$D(ZTQUEUED),'(AUPNX#100) W "."
VLAB ;
 I '$D(ZTQUEUED) W !!,"Re-indexing AQ on V LAB",!
 K ^AUPNVLAB("AQ") S AUPNX=0 F  S AUPNX=$O(^AUPNVLAB(AUPNX)) Q:AUPNX'=+AUPNX  I $D(^AUPNVLAB(AUPNX,0))  S DA=AUPNX,X=$P(^AUPNVLAB(AUPNX,0),U,1) D AQ1^AUPNCIXL I '$D(ZTQUEUED),'(AUPNX#100) W "."
 W !!,"ALL DONE"
 D XIT
 Q
TSKMN ;
 S ZTIO="",ZTRTN="DRIVER^AUP2POST",ZTDTH="",ZTDESC="AUPN PATCH 2 -93.2 RE-INDEX" D ^%ZTLOAD D XIT K ZTSK Q
XIT ;
 K AUPNX
 K DIR,DIC,X,Y,DIRUT
 Q

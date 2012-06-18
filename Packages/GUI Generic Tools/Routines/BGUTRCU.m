BGUTRCU ; IHS/OIT/MJL - Clean up routine for the Debug/Trace global: ^BGUTRACE ;
 ;;1.5;BGU;;MAY 26, 2005
 ;
MAIN ;
 D ASKDJ,ASKNRT:'$D(DIRUT) I $D(DIRUT) D KILL Q
 D CLU,KILL
 Q
 ;
ASKDJ ;
 ; Ask for $J
 S U="^",DIR(0)="NO^1:999999",DIR("A")="ENTER $J TO CLEANUP",DIR("?")="Enter numeric characters for the $J you want to cleanup" D ^DIR Q:$D(DIRUT)
 ; ASK HOW MANY ENTRIES TO RETAIN
 S BGUDJ=Y
 Q
 ;
ASKNRT ;
 ; Ask for number of sessions to retain
 S DIR(0)="NO^0:999",DIR("A")="ENTER THE NUMBER OF SESSIONS TO RETAIN",DIR("?")="Enter numeric characters only" D ^DIR I $D(DIRUT) D KILL Q
 S BGUNRT=Y D CLU
 W !,BGUNRT," Sessions Retained",!
 Q
 ;
CLU ;
 S BGUN="",DIK="^BGUTRACE(" F BGUN1=1:1 S BGUN=$O(^BGUTRACE("C",BGUDJ,BGUN),-1) Q:BGUN=""  I BGUN1>BGUNRT S DA=BGUN D ^DIK
 Q
 ;
KILL ;
 K BGUDJ,BGUN,BGUN1,BGUN2,BGUNRT,DA,DIK,DIR,DIRUT,X,Y
 Q
 ;
BJENT ;EP Called by option BGU TRACE CLEANUP
 ; Entry point called from cleanup option.
 W !,"Starting..."
 S U="^" S BGUDJ=0 F BGUQ=0:0 S BGUDJ=$O(^BGUTRACE("C",BGUDJ)) Q:'BGUDJ  D
 .I $D(^BGUSP(1,1,"B",BGUDJ)) S BGUN2="" F BGUQ=0:0 S BGUN2=$O(^BGUSP(1,1,"B",BGUDJ,BGUN2)) Q:'BGUN2  S BGUNRT=$P(^BGUSP(1,1,BGUN2,0),U,2) D CLU
 .I '$D(^BGUSP(1,1,"B",BGUDJ)) S DIK="^BGUTRACE(" S BGUN="" F BGUN1=1:1 S BGUN=$O(^BGUTRACE("C",BGUDJ,BGUN)) Q:BGUN=""  S DA=BGUN D ^DIK
 D KILL
 W !,"Done..",!!
 Q
 ;

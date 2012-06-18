BGUPURGE ; IHS/OIT/MJL - PURGE ROUTINE FOR BGUSEC ;
 ;;1.5;BGU;;MAY 26, 2005
 ;;1.0;BGU
SCPURG ;EP Called by option BGU PURGE SIGNON
 ;Purge BGU sign-on log
 S DIR("?")="Enter Y if you want to purge the BGU sign-on log"
 S DIR(0)="Y",DIR("A")="Purge BGU Sign-on log older than 30 days?",DIR("B")="NO" D ^DIR Q:$D(DIRUT)
 Q:'Y
 S X1=DT,X2=-30 D C^%DTC S BGUDT=X I $O(^BGUSEC(0))'>0 G SCEXIT
 S DIK="^BGUSEC(" F DA=0:0 S DA=$O(^BGUSEC(DA)) Q:(DA'>0)!(DA>BGUDT)  D ^DIK
 W !,"BGU Sign-on log has been purged.",!
SCEXIT K DIK,DA,BGUDT,X1,X2 Q

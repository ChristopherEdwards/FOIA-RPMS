DGVPT1 ;ALB/MRL - DG POST-INIT (OPTION AND ROUTINE CLEAN-UP) ;12 AUG 88@1032
 ;;5.3;Registration;;Aug 13, 1993
OPT ;Delete and Repoint Options
 I $S(('$D(DGPACK)#2):1,DGPACK']"":1,1:0) Q
 W !!,">>> Deleting/repointing '",DGPACK,"' options in OPTION file as necessary.",!
 D VERS^DGVPP:'$D(DGVREL) S DGI=DGPACK F DGJ=0:0 S DGI=$O(^DG(48,DGVREL,"DO","C",DGI)) Q:DGI=""!($E(DGI,1,$L(DGPACK))'=DGPACK)  S DGIFN=+$O(^DG(48,DGVREL,"DO","C",DGI,0)) I $D(^DG(48,DGVREL,"DO",DGIFN,0)) S DGDEL=^(0) D DO1
 K DA,DGDEL,DGI,DGIFN,DGJ,DGM,DGNOPT,DGOPT,DGPACK,DGREP,DGS,DIC,DIK,DINUM,I,X Q
DO1 W !!?5,DGI,!?5 F I=1:1:$L(DGI) W "-"
 S DGOPT=+$O(^DIC(19,"B",$E(DGI,1,30),0)) I $S('DGOPT:1,'$D(^DIC(19,DGOPT,0)):1,1:0) W !?5,"DOES NOT EXIST IN THE 'OPTION' FILE...NOTHING DELETED!" Q
 S DGREP=$P(DGDEL,"^",4) G DO2:'DGREP S DGNOPT=+$O(^DIC(19,"B",$E($P(DGDEL,"^",5),1,30),0))
 I $S(DGNOPT'>0:1,'$D(^DIC(19,DGNOPT,0)):1,1:0) W !?5,"NEW OPTION (",$P(DGDEL,"^",4),") DOESN'T EXIST IN 'OPTION' FILE...NOTHING REPOINTED!" S DGREP=0
DO2 I '$O(^DIC(19,"AD",DGOPT,0)) W !?5,"NOT ATTACHED TO ANY MENUS AS AN ITEM...NOTHING TO REPOINT OR DELETE!" G DO3
 F DGM=0:0 S DGM=$O(^DIC(19,"AD",DGOPT,DGM)) Q:'DGM  F DGS=0:0 S DGS=$O(^DIC(19,"AD",DGOPT,DGM,DGS)) Q:'DGS  D DO4
DO3 S DA(1)=19,DA=DGOPT,DIK="^DIC(19," D ^DIK W !?5,"'",$P(DGDEL,"^",1),"' REMOVED from OPTION file..." Q
DO4 I $D(^DIC(19,DGM,10,DGS,0)),$P(^(0),"^")=DGOPT W !?5,"REMOVED from '",$P(^DIC(19,+DGM,0),"^",1),"' menu..." S DIK="^DIC(19,"_DGM_",10,",DA(2)=19,DA(1)=DGM,DA=DGS D ^DIK K DIK,DA
 Q:'DGREP  W !?10,"'",$P(DGDEL,"^",5),"' " I $D(^DIC(19,"AD",DGNOPT,DGM)) W "already EXISTS as an item on this menu..." Q
 W "ADDED to menu as a NEW ITEM..." K DD,DO S DA(2)=19,DA(1)=DGM,X=DGNOPT,(DA,DINUM)=DGS,DIC="^DIC(19,"_DGM_",10,",DIC(0)="L" D FILE^DICN K DD,DO,DA,DIC Q
 ;
DEL ;Delete Obsolete Routines -- run by site after initialization
 S DGV=$$REL^DGVPP()
 I $O(^DG(48,DGV,"DR",0))="" W !,"No routines listed to remove" G QD
 I '$D(^%ZOSF("DEL")) W !,"^%ZOSF(""DEL"") does not exist" G QD
ASK W !,"This routine will permanently remove the routines listed in the PIMS",!,"release notes.  WARNING:  If any of the listed routines are mapped, they"
 W !,"must first be removed from the mapped set to avoid further complications!!",!
 W !,"Are you sure you want to continue" S %=2 D YN^DICN G QD:%=-1!(%=2) I '% W !?5,"Respond 'Y'es or 'N'o" G ASK
 W !,"Routine deletion starting..." S DGI=0 F DGI1=0:0 S DGI=$O(^DG(48,DGV,"DR",DGI)) Q:'DGI  S X=$P(^(DGI,0),"^") X ^%ZOSF("TEST") I $T W !?5,"...removing ",X X ^%ZOSF("DEL")
 W !,"Routine deletion completed."
QD K DGI,DGI1,DGV,X Q

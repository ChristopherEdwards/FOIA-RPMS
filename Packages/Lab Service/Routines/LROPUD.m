LROPUD ;ALB/MRL;SLC/RWA - UPDATE OPTIONS ; 2/1/89  13:48 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
 W !!,">>> Deleting/repointing 'LAB' options in OPTION file as necessary.",!
 S LRI="LR" F LRJ=0:0 S LRI=$N(^LAB(69.91,1,"DO","C",LRI)) Q:LRI=-1  S LRIFN=$N(^LAB(69.91,1,"DO","C",LRI,0)) I LRIFN,$D(^LAB(69.91,1,"DO",LRIFN,0)) S LRDEL=^(0) D DO1
 K DA,LRDEL,LRI,LRIFN,LRJ,LRM,LRNOPT,LROPT,LRREP,LRS,DIC,DIK,DINUM,I,X Q
DO1 W !!?5,LRI,!?5 F I=1:1:$L(LRI) W "-"
 S LROPT=$N(^DIC(19,"B",$E(LRI,1,30),0)) I $S(LROPT'>0:1,'$D(^DIC(19,LROPT,0)):1,1:0) W !?5,"DOES NOT EXIST IN THE 'OPTION' FILE...NOTHING DELETED!" Q
 S LRREP=$P(LRDEL,"^",3) G DO2:'LRREP S LRNOPT=$N(^DIC(19,"B",$E($P(LRDEL,"^",4),1,30),0))
 I $S(LRNOPT'>0:1,'$D(^DIC(19,LRNOPT,0)):1,1:0) W !?5,"NEW OPTION (",$P(LRDEL,"^",3),") DOESN'T EXIST IN 'OPTION' FILE...NOTHING REPOINTED!" S LRREP=0
DO2 I $N(^DIC(19,"AD",LROPT,0))'>0 W !?5,"NOT ATTACHED TO ANY MENUS AS AN ITEM...NOTHING TO REPOINT OR DELETE!" G DO3
 F LRM=0:0 S LRM=$N(^DIC(19,"AD",LROPT,LRM)) Q:LRM'>0  F LRS=0:0 S LRS=$N(^DIC(19,"AD",LROPT,LRM,LRS)) Q:LRS'>0  D DO4
DO3 S DA(1)=19,DA=LROPT,DIK="^DIC(19," D ^DIK W !?5,"'",$P(LRDEL,"^",1),"' REMOVED from OPTION file..." Q
DO4 W !?5,"REMOVED from '",$P(^DIC(19,+LRM,0),"^",1),"' menu..." S DIK="^DIC(19,"_LRM_",10,",DA(2)=19,DA(1)=LRM,DA=LRS D ^DIK K DIK,DA
 Q:'LRREP  W !?10,"'",$P(LRDEL,"^",4),"' " I $D(^DIC(19,"AD",LRNOPT,LRM)) W "already EXISTS as an item on this menu..." Q
 W "ADDED to menu as a NEW ITEM..." K DD,DO S DA(2)=19,DA(1)=LRM,X=LRNOPT,(DA,DINUM)=LRS,DIC="^DIC(19,"_LRM_",10,",DIC(0)="L" D FILE^DICN K DD,DO,DA,DIC Q
LRIPOS3 ;SLC/RWA/DALISC/JRR - LR POST INIT UPDATE MENU OPTIONS ;2/8/91  07:37 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN ;
 W !!,">>> Deleting/repointing 'LAB' options in OPTION file as necessary.",!
19 S LRI="" F  S LRI=$O(^LAB(69.91,1,"DO","B",LRI)) Q:LRI=""  S LRIFN=$O(^LAB(69.91,1,"DO","B",LRI,0)) I LRIFN,$D(^LAB(69.91,1,"DO",LRIFN,0)) S LRDEL=^(0) D DO1
DIE ;
 K DA,DIK S LRI="",DIK="^DIE(" F  S LRI=$O(^LAB(69.91,1,"EDIT","B",LRI)) Q:LRI=""  D
 .S DA=$O(^DIE("B",$E(LRI,1,30),0)) I DA W !?10,"Removing Edit template ",?30,LRI D ^DIK
DIPT ;
 K DA,DIK S LRI="",DIK="^DIPT(" F  S LRI=$O(^LAB(69.91,1,"PRT","B",LRI)) Q:LRI=""  D
 .S DA=$O(^DIPT("B",$E(LRI,1,30),0)) I DA W !?15,"Removing Print template ",?35,LRI D ^DIK
DIBT ;
 K DA,DIK S LRI="",DIK="^DIBT(" F  S LRI=$O(^LAB(69.91,1,"SORT","B",LRI)) Q:LRI=""  D
 .S DA=$O(^DIBT("B",$E(LRI,1,30),0)) I DA W !?20,"Removing Sort template ",?40,LRI D ^DIK
 W !!,"Options -  Edit,Print and Sort templates removal complete ",!
LA W !!,"Linking LA namespaced options to their appropriate LR parents..."
 F LACNT=1:1 S LAOPT=$P($T(LAOPTION+LACNT),";",3) Q:LAOPT=""  D
 . S LAOPTION=$P(LAOPT,"^"),LROPTION=$P(LAOPT,"^",2)
 . S LROPTN=$O(^DIC(19,"B",LROPTION,0))
 . I 'LROPTN D  QUIT
 . . W !!?5,"Option ",LROPTION," is missing from your option file."
 . . W !?5,"Couldn't attach option called ",LAOPTION,"."
 . S LAOPTN=$O(^DIC(19,"B",LAOPTION,0))
 . I 'LAOPTN D  QUIT
 . . W !!?5,"Option ",LAOPTION," is missing from your option file."
 . . W !?5,"Couldn't attach to option ",LROPTION,"."
 . I $D(^DIC(19,LROPTN,10,"B",LAOPTN)) D  QUIT
 . . W !!?5,"Option ",LAOPTION," is already attached to ",LROPTION,"."
 . K DIC,DA
 . S DA(1)=LROPTN
 . S DIC="^DIC(19,"_DA(1)_",10,"
 . S DIC(0)="L"
 . S X=LAOPTN
 . D FILE^DICN
 . K D0,D1,DIC
 . I +Y<1 D  QUIT
 . . W !!?5,"Couldn't add option ",LAOPTION," to ",LROPTION,"."
 . W !!?5,"Added option ",LAOPTION," to ",LROPTION,"."
 K DA,LRDEL,LRI,LRIFN,LRJ,LRM,LRNOPT,LROPT,LRREP,LRS,DIC,DIK,DINUM,I,X Q
DO1 W !!?5,LRI,!?5 F I=1:1:$L(LRI) W "-"
 S LROPT=$O(^DIC(19,"B",$E(LRI,1,30),0)) I $S(LROPT'>0:1,'$D(^DIC(19,LROPT,0)):1,1:0) W !?5,"DOES NOT EXIST IN THE 'OPTION' FILE...NOTHING DELETED!" Q
 S LRREP=$P(LRDEL,"^",3) G DO2:'LRREP S LRNOPT=$O(^DIC(19,"B",$E($P(LRDEL,"^",4),1,30),0))
 I $S(LRNOPT'>0:1,'$D(^DIC(19,LRNOPT,0)):1,1:0) W !?5,"NEW OPTION (",$P(LRDEL,"^",3),") DOESN'T EXIST IN 'OPTION' FILE...NOTHING REPOINTED!" S LRREP=0
DO2 I $O(^DIC(19,"AD",LROPT,0))'>0 W !?5,"NOT ATTACHED TO ANY MENUS AS AN ITEM...NOTHING TO REPOINT OR DELETE!" G DO3
 S LRM=0 F  S LRM=$O(^DIC(19,"AD",LROPT,LRM)) Q:LRM'>0  S LRS=0 F  S LRS=$O(^DIC(19,"AD",LROPT,LRM,LRS)) Q:LRS'>0  D DO4
DO3 S DA(1)=19,DA=LROPT,DIK="^DIC(19," D ^DIK W !?5,"'",$P(LRDEL,"^",1),"' REMOVED from OPTION file..." Q
DO4 Q:'$D(^DIC(19,+LRM,0))#2  W !?5,"REMOVED from '",$P(^DIC(19,+LRM,0),"^",1),"' menu..." S DIK="^DIC(19,"_LRM_",10,",DA(2)=19,DA(1)=LRM,DA=LRS D ^DIK K DIK,DA
 Q:'LRREP  W !?10,"'",$P(LRDEL,"^",4),"' " I $D(^DIC(19,"AD",LRNOPT,LRM)) W "already EXISTS as an item on this menu..." Q
 W "ADDED to menu as a NEW ITEM..." K DD,DO S DA(2)=19,DA(1)=LRM,X=LRNOPT,(DA,DINUM)=LRS,DIC="^DIC(19,"_LRM_",10,",DIC(0)="L",DLAYGO=19 D FILE^DICN K DD,DO,DA,DIC,DLAYGO Q
LAOPTION ;;
 ;;LA AP FICHE^LRLIAISON
 ;;LA DOWN^LR DO!
 ;;LA INTERFACE^LRSUPERVISOR
 ;;LA MI MENU^LRMI
 ;;LA JOB^LRLIAISON
 ;;LA DOWN^LA MI MENU

AQAZPOST ;IHS/ORDC/LJF - POST INIT; [ 05/05/93  3:15 PM ]
 ;;1.0;QA PATCHES;;29 APR 93
 ;
TEMPLATE ; ** remove old print template from security key file
 S X=$O(^DIPT("B","AQAQSECURITY",0)) G FIND:X=""
 G FIND:$P($G(^DIPT(X,0)),U,4)'=19.1    ;wrong template
 S DA=X,DIK="^DIPT(" D ^DIK W !!,"Removing old print template . . .",!
 ;
FIND ; ** find package entry
 K DIC S DIC=9.4,DIC(0)="",D="C",X="AQAZ" D IX^DIC
 G EXIT:Y<0
 ;
DELETE ; ** delete entry from package file
 S DA=+Y,DIK="^DIC(9.4," D ^DIK
 ;
EXIT ; ** eoj
 W !!,"UPDATE COMPLETE!",!
 K DIC,D,X,Y,DA,DIK Q

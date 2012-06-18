AMQQWH ; IHS/CMI/THL - WOMEN'S HEALTH SETUP ROUTINE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
SETUP ;
 N DA,DIC,DIK,X,Y,Z,%DEVOARG,%DEVTYPE
 W !!!,"SETUP ROUTINE FOR Q-MAN'S WOMEN'S HEALTH ATTRIBUTES",!!!
 I $D(^AMQQ(7,48,0)),^(0)'="WOMEN'S HEALTH" W "INVALID METADICTIONARY ENTRIES DETECTED.  SETUP CANCELLED...",*7 Q
 W "Cleaning out old metadictionary entries..."
 F Z=5,1 S DIK="^AMQQ("_Z_"," F DA=600:0 S DA=$O(^AMQQ(Z,DA)) Q:'DA  Q:DA>699  D ^DIK W "-"
 S DIK="^AMQQ(7,"
 F DA=48:1:51 D ^DIK W "-"
 W !!,"Restoring globals..."
 W !,"When prompted for the name of a file, enter 'AMQQWH.G'",!!
 D ^%GI
 I '$D(^AMQQ(1,675)) W "Globals not fully restored, install aborted!",!! Q
 W !!,"Restoring metadictionary indices..."
 S DIK="^AMQQ(7,"
 F DA=48:1:51 D IX^DIK W "+"
 F Z=1,5 S DIK="^AMQQ("_Z_"," F DA=600:0 S DA=$O(^AMQQ(Z,DA)) Q:'DA  Q:DA>699  D IX^DIK W "+"
 W !!,"All metadictionary entries successfully updated!!!!",!
 W "Q-Man is now linked to the Women's Health Package."
 W !!,"Exiting setup...."
 Q
 ;

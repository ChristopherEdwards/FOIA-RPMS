VALM02P ; IHS/ANMC/LJF - PATCH 1002 PRE-INSTALL; [ 07/27/98  6:25 AM ]
 ;;1.0;LIST MANAGER;;**1002**;JULY 27, 1998
 ;
 ; change version number from 1 to 1.0 so kid patches will
 ; attach to correct version-kids patches require decimal place
 S DA(1)=$O(^DIC(9.4,"C","VALM",0)) Q:'DA(1)
 S DA=$O(^DIC(9.4,DA(1),22,"B",1,0)) Q:'DA
 S DIE="^DIC(9.4,"_DA(1)_",22,"
 S DR=".01///1.0"
 D ^DIE
 Q

PXRMP3I ; SLC/PJH,PKR - POST INSTALL TO DELETE EXPANDED TAXONOMY. ;12/07/2000
 ;;1.5;CLINICAL REMINDERS;**3**;Jun 19, 2000
 ;
 Q
 ;------------------------
POST ;Delete all expanded taxonomies
 N DA,DIK
 S DIK="^PXD(811.3,"
 S DA=0
 F  S DA=$O(^PXD(811.3,DA)) Q:+DA=0  D
 . D ^DIK
 Q

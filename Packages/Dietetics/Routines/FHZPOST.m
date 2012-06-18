FHZPOST ;IHS/ORDC/LJF - POST INIT;  [ 10/18/94  9:35 AM ]
 ;;3.16;DIETETICS;**1**;NOV 01, 1990
 ;
 ;Deletes FHZ entry in package file; used only to install patches
 S DA=$O(^DIC(9.4,"C","FHZ",0)) Q:DA=""
 S DIK="^DIC(9.4," D ^DIK
 K DA,DIK Q

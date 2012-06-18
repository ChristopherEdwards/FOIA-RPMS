AVAPPOST ;IHS/ORDC/LJF - POSTINIT TO DELETE AVAP PACKAGE ENTRY; [ 08/25/95  1:18 PM ]
 ;;93.2;VA SUPPORT FILES;;**6**;JUL 01, 1993
 ;
 ; delete package entry with namespace of AVAP
 ; FELS used as scratch package to send files, templates,etc.
 S DA=$O(^DIC(9.4,"C","AVAP",0)) Q:DA=""
 W !!,"DELETING 'AVAP' PACKAGE ENTRY. . . ",!
 S DIK="^DIC(9.4," D ^DIK
 K DA,DIK Q

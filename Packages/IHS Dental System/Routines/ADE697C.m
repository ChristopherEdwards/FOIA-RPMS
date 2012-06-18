ADE697C ;IHS/HQW/MJL DENTAL POST-INIT  [ 03/24/1999   8:35 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;
COMPILE ;EP - Delete  old compiled statistics and recompile
 ;
 N DA,DIK
 S DA=0,DIK="^ADEKNT(" F  S DA=$O(^ADEKNT(DA)) Q:'+DA  D
 . D ^DIK
 D EN^ADEKNS
 Q

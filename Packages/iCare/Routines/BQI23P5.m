BQI23P5 ;GDIT/HS/ALA-Patch 5 IPC/CRS15 update ; 31 Oct 2014  2:23 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**5**;Apr 18, 2012;Build 17
 ;
PRE ;EP
 Q
 ;
POS ;EP
 ; Remove LDL bundles items
 NEW DA,DIK
 S DA(3)=1,DA(2)=2,DA(1)=22,DIK="^BQI(90508,"_DA(3)_",22,"_DA(2)_",1,"_DA(1)_",2,"
 S DA=0
 F  S DA=$O(^BQI(90508,1,22,2,1,22,2,DA)) Q:'DA  D ^DIK
 ;
 D ^BQIIPC5
 D ^BQIIPCFX
 Q

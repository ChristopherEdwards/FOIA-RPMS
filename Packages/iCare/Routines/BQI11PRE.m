BQI11PRE ;PRXM/HC/ALA-Preinstall program ; 11 Jun 2007  3:06 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ;  Remove existing data fields before installation
 ;
 K ^XTMP("BQICARE")
 S ^XTMP("BQICARE",0)=$D(^BQICARE)
 S ^XTMP("BQICARE","VISIT")=$G(^BQI(90508,1,"VISIT"))
 ;
 NEW DA,DIK
 S DA=0,DIK="^BQI(90506,"
 F  S DA=$O(^BQI(90506,DA)) Q:'DA  D ^DIK
 ;
 S DA=0,DIK="^BQI(90506.1,"
 F  S DA=$O(^BQI(90506.1,DA)) Q:'DA  D ^DIK
 ;
 S DA=0,DIK="^BQI(90506.2,"
 F  S DA=$O(^BQI(90506.2,DA)) Q:'DA  D ^DIK
 ;
 S DA=0,DIK="^BQI(90506.3,"
 F  S DA=$O(^BQI(90506.3,DA)) Q:'DA  D ^DIK
 ;
 S DA=0,DIK="^BQI(90507,"
 F  S DA=$O(^BQI(90507,DA)) Q:'DA  D ^DIK
 ;
 S DA=1,DIK="^BQI(90508," D ^DIK
 Q

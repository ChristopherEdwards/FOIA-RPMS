BKM22PRE ;GDIT/HS/ALA-Version 2.2 Preinstall ; 12 Dec 2013  9:54 AM
 ;;2.2;HIV MANAGEMENT SYSTEM;;Apr 01, 2015;Build 40
 ;
 ;
EN ;EP
 NEW DA,DIK
 S DIK="^BKM(90454,",DA=0
 F  S DA=$O(^BKM(90454,DA)) Q:'DA  D ^DIK
 ;
 ; Delete DD for register subfile which is being resent
 ; this will remove field 2 - ICD Diagnosis
 S DIU=90451.01,DIU(0)="S" D EN^DIU2
 Q

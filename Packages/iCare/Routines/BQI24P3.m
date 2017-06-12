BQI24P3 ;GDHS/HCS/ALA-Version 2.4 Patch 3 ; 15 Dec 2015  8:22 AM
 ;;2.4;ICARE MANAGEMENT SYSTEM;**3**;Apr 01, 2015;Build 5
 ;;
PRE ;EP
 NEW CODE,NM,DA,DIK,IEN
 S DIK="^BQI(90506.1,"
 F CODE="2007_","2008_","2009_","2010_","2011_" D
 . S NM=CODE
 . F  S NM=$O(^BQI(90506.1,"B",NM)) Q:NM=""!($E(NM,1,5)'=CODE)  D
 .. S IEN=$O(^BQI(90506.1,"B",NM,""))
 .. S DA=IEN D ^DIK
 ;
 S DIK="^BQI(90506.8,",DA=0
 F  S DA=$O(^BQI(90506.8,DA)) Q:'DA  D ^DIK
 ;
 S DIK="^BQI(90506.5,",DA=0
 F  S DA=$O(^BQI(90506.5,DA)) Q:'DA  D ^DIK
 Q
 ;
POS ;EP
 ; Check for MU default views
 NEW DZ
 S DZ=0
 F  S DZ=$O(^BQICARE(DZ)) Q:'DZ  D
 . I $$GET1^DIQ(90505,DZ_",",.02,"E")["MU",$$GET1^DIQ(90505,DZ_",",.16,"E")="" S BQIUPD(90505,DZ_",",.02)="@"
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ; Fix Tobacco header
 D ^BQI24PU1
 ; Turn on Immunization Registry
 NEW DA
 S DA=$O(^BQI(90507,"B","IMMUNIZATION",""))
 S BQIUPD(90507,DA_",",.08)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 NEW DA,IENS
 S DA(2)=1,DA(1)=2
 ;Inactivate IPC measures
 S DA=22,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.07)=1
 S DA=32,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.07)=1
 S DA=49,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.07)=1
 ;
 ;Change Health Risk Screening Bundle to Comprehensive Health Screening
 S DA=5,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.04)="Comprehensive Health Screening"
 ;
 ;Fixed column header for cvd: bmi assessed
 S DA=48,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.04)="CVD: BMI Assessed"
 ;
 ;Fixed column header from BP in Control to BP Assessed
 S DA=23,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.04)="BP Assessed"
 ;
 ;Change from MU to CRS
 S DA=53,IENS=$$IENS^DILF(.DA) D
 . S BQIUPD(90508.221,IENS,.01)="2016_2720",BQIUPD(90508.221,IENS,.02)="G"
 . S BQIUPD(90508.221,IENS,.13)="@",BQIUPD(90508.221,IENS,.14)="@"
 S DA=54,IENS=$$IENS^DILF(.DA) D 
 . S BQIUPD(90508.221,IENS,.01)="2016_2721",BQIUPD(90508.221,IENS,.02)="G"
 . S BQIUPD(90508.221,IENS,.13)="@",BQIUPD(90508.221,IENS,.14)="@"
 S DA=55,IENS=$$IENS^DILF(.DA) D
 . S BQIUPD(90508.221,IENS,.01)="2016_2722",BQIUPD(90508.221,IENS,.02)="G"
 . S BQIUPD(90508.221,IENS,.13)="@",BQIUPD(90508.221,IENS,.14)="@"
 ;
 S DA=56,IENS=$$IENS^DILF(.DA),BQIUPD(90508.221,IENS,.13)="@",BQIUPD(90508.221,IENS,.14)="@"
 ;
 NEW DA,IENS
 S DA(3)=1,DA(2)=2,DA(1)=56
 S DA=1,IENS=$$IENS^DILF(.DA),BQIUPD(90508.2212,IENS,.01)="2016_2720"
 S DA=2,IENS=$$IENS^DILF(.DA),BQIUPD(90508.2212,IENS,.01)="2016_2721"
 S DA=3,IENS=$$IENS^DILF(.DA),BQIUPD(90508.2212,IENS,.01)="2016_2722"
 ;
 ; Remove LDL from CVD Measure Bundle
 S DA(1)=51,DA=4,BQIUPD(90508.2212,IENS,.01)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 D ^BQITAXXU
 Q
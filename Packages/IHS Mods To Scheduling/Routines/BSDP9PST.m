BSDP9PST ;cmi/anch/maw - PIMS Patch 1009 Post Init 2/27/2007 10:32:52 AM
 ;;5.3;PIMS;**1009**;FEB 27,2007;
 ;
 ;
 ;
 ;
EN ;EP - Post Init Entry Point
 D ADDMENU
 D CLEANMS4
 D OBS
 Q
 ;
ADDMENU ;-- add menu items
 N X
 S X=$$ADD^XPDMENU("BDG MENU BED CONTROL","DGPW PATIENT WRISTBAND PRINT","PPW","")
 I 'X W !,"Attempt to add DGPW PATIENT WRISTBAND PRINT option failed.." H 3
 Q
 ;
CLEANMS4 ;-- cleanout left over MS4 entries from option BDGPM VISIT UPDATE
 K ^LJF("MS4")
 Q
 ;
OBS ;-- populate SPECIALTY field of FACILITY TREATING SPECIALTY for observations specialties
 ;per help desk call IM29018 observation not calling movement events properly because VA uses SPECIALTY field as does EHR
 N BSDDA,BSDOBS
 S BSDOBS=$O(^DIC(42.4,"B","MEDICAL OBSERVATION",0))
 Q:'BSDOBS
 S BSDDA=0 F  S BSDDA=$O(^DIC(45.7,BSDDA)) Q:'BSDDA  D
 . N BSDTS
 . S BSDTS=$P($G(^DIC(45.7,BSDDA,0)),U)
 . Q:BSDTS'["OBSERVATION"
 . N BSDFDA,BSDIENS,BSDERR
 . S BSDIENS=BSDDA_","
 . S BSDFDA(45.7,BSDIENS,1)=BSDOBS
 . D FILE^DIE("K","BSDFDA","BSDERR(1)")
 Q
 ;

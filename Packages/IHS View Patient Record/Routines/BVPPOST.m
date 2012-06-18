BVPPOST ; IHS/ITSC/LJF - VPR POST INSTALL ROUTINE ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ;
 Q
 ;
EN ;EP; called by KIDS post install entry
 ; KIDS cannot install Allergy health sumamry component pointer
 ;   Name of component too long
 NEW DIE,DA,DR
 S DA(1)=$O(^APCHSCTL("B","VPR REMINDERS",0)) Q:DA(1)=""
 S DA=10,DIE="^APCHSCTL("_DA(1)_",1,",DR="1///ALLERGIES/ADVERSE REACTIONS (D"
 D ^DIE
 Q

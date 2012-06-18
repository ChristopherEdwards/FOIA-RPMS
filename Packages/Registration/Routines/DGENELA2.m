DGENELA2 ;ALB/CJM - Patient Eligibility API ; 13 JUN 1997
 ;;5.3;Registration;**147**;08/13/93
 ;
DELELIG(DFN,DGELG) ;
 ;Description: Deletes eligibilities from the patient file Patient
 ;Eligibilities multiple that are not contained in DGELG() array.
 ;
 ;Input:
 ;  DFN - ien of Patient record
 ;  DGELG() - eligibility array (pass by reference)
 ;Output: none
 ;
 N DIK,DA,CODE
 S DA(1)=DFN
 S DIK="^DPT("_DFN_",""E"","
 S DA=0 F  S DA=$O(^DPT(DFN,"E",DA)) Q:'DA  D
 .S CODE=+$G(^DPT(DFN,"E",DA,0))
 .;
 .;don't delete if it belongs
 .Q:$D(DGELG("ELIG","CODE",CODE))
 .;
 .;don't delete if it's the primary eligibility code
 .Q:(CODE=DGELG("ELIG","CODE"))
 .D ^DIK
 Q
 ;
DELRDIS(DFN) ;
 ;Description: deletes Rated Disability multiple from the patient file
 ;
 ;Input:
 ;  DFN - ien of Patient record
 ;Output: none
 ;
 N DIK,DA
 S DA(1)=DFN
 S DIK="^DPT("_DFN_",.372,"
 S DA=0 F  S DA=$O(^DPT(DFN,.372,DA)) Q:'DA  D ^DIK
 Q

BLRPCCVM ; IHS/ITSC/MKK - UPDATE LAB VA-IHS LINK LOG UPON VISIT MERGE  [ 04/15/2004  1:15 PM ]
 ;;5.2;BLR;**1019**;MAR 25, 2005
 ;
 ; This routine is called by the PCC Visit Merge Utility.
 ; The input variables are:  APCDVMF - Merge from visit ifn
 ;                           APCDVMT - Merge to visit ifn
 ; 
 ; Finds the patient involved, scans for the merged visit among the
 ; the occurrences for this patient, and updates the visit.
 ;
MRG ; PEP >> PRIVATE ENTRY POINT between BLR and PCC
 NEW BLRN,DIE,DA,DR,X,Y
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER MRG^BLRPCCVM")
 ;
 Q:'$G(APCDVMF)  Q:'$G(APCDVMT)   ; Quit if variables non-existent
 ;
 S BLRN=0
 F  S BLRN=$O(^LRO(68.999999901,"AC",APCDVMF,BLRN))  Q:'BLRN  D
 . S DA=BLRN
 . S DIE="^LRO(68.999999901,",DR=".02////"_APCDVMT
 . D ^DIE
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EXIT MRG^BLRPCCVM")
 ;
EXIT Q

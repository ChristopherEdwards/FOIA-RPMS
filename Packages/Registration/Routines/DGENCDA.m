DGENCDA ;ALB/CJM,Zoltan,JAN - Catastrophic Disability API - Retrieve Data;May 24, 1999;Nov 14, 2001
 ;;5.3;Registration;**121,147,232,387**;Aug 13,1993
 ;
GET(DFN,DGCDIS) ;
 ;Description: Get catastrophic disability information for a patient
 ;Input:
 ;  DFN - Patient IEN
 ;Output:     
 ;  DGCDIS - the catastrophic disability array, passed by reference
 ;   subscripts:
 ;   "BY"     Decided By
 ;   "DATE"     Date of Decision
 ;   "FACDET"     Facility Making Determination
 ;   "REVDTE"     Review Date
 ;
 N SUB,ITEM,SITEM,SIEN,IND
 K DGCDIS S DGCDIS=""
 I '$G(DFN) D  Q 0
 . F SUB="VCD","BY","DATE","FACDET","REVDTE","METDET" S DGCDIS(SUB)=""
 ; .39 VETERAN CATASTROPHICALLY DISABLED? field.
 S DGCDIS("VCD")=$P($G(^DPT(DFN,.39)),"^",6)
 ; .391 DECIDED BY field.
 S DGCDIS("BY")=$P($G(^DPT(DFN,.39)),"^",1)
 ; .392 DATE OF DECISION field.
 S DGCDIS("DATE")=$P($G(^DPT(DFN,.39)),"^",2)
 ; .393 FACILITY MAKING DETERMINATION field.
 S DGCDIS("FACDET")=$P($G(^DPT(DFN,.39)),"^",3)
 ; .394 REVIEW DATE field.
 S DGCDIS("REVDTE")=$P($G(^DPT(DFN,.39)),"^",4)
 ; .395 METHOD OF DETERMINATION field.
 S DGCDIS("METDET")=$P($G(^DPT(DFN,.39)),"^",5)
 ; .396 CD STATUS DIAGNOSES field (multiple):
 S SIEN=0
 F ITEM=1:1 S SIEN=$O(^DPT(DFN,.396,SIEN)) Q:'SIEN  D
 . ; .01 CD STATUS DIAGNOSES sub-field.
 . S DGCDIS("DIAG",ITEM)=$P($G(^DPT(DFN,.396,SIEN,0)),"^",1)
 ; .397 CD STATUS PROCEDURES field (multiple):
 S (ITEM,SITEM,SIEN)=0
 F  S ITEM=$O(^DPT(DFN,.397,"B",ITEM)) Q:'ITEM  D
 . S IND=0,SIEN=SIEN+1
 . F  S SITEM=$O(^DPT(DFN,.397,"B",ITEM,SITEM)) Q:'SITEM  D
 . . ; .01 CD STATUS PROCEDURES sub-field.
 . . S DGCDIS("PROC",SIEN)=$P($G(^DPT(DFN,.397,SITEM,0)),"^",1)
 . . ; 1 AFFECTED EXTREMITY sub-field.
 . . S DGCDIS("EXT",SIEN)=$P($G(^DPT(DFN,.397,SITEM,0)),"^",2)
 . . S IND=IND+1,DGCDIS("EXT",SIEN,IND)=$P($G(^DPT(DFN,.397,SITEM,0)),"^",2)
 ; - .398 CD STATUS CONDITIONS field (multiple):
 S SIEN=0
 F ITEM=1:1 S SIEN=$O(^DPT(DFN,.398,SIEN)) Q:'SIEN  D
 . ; .01 CD STATUS CONDITIONS sub-field.
 . S DGCDIS("COND",ITEM)=$P($G(^DPT(DFN,.398,SIEN,0)),"^",1)
 . ; 1 SCORE sub-field.
 . S DGCDIS("SCORE",ITEM)=$P($G(^DPT(DFN,.398,SIEN,0)),"^",2)
 . ; 2 PERMANENT INDICATOR sub-field.
 . S DGCDIS("PERM",ITEM)=$P($G(^DPT(DFN,.398,SIEN,0)),"^",3)
 Q 1
 ;
DISABLED(DFN) ;
 ;Description: Returns whether the patient is catastrophically disabled.
 ;
 ;Input:
 ;  DFN - Patient IEN
 ;Output:
 ;  Function Value - returns 1 if the patient is catastrophically
 ;     disabled, otherwise 0
 ;
 Q $$HASCAT(DFN)
 ;
HASCAT(DFN) ;
 ;Description: returns 1 if the patient is CATASTROPHICALLY DISABLED
 ;
 Q:'$G(DFN) 0
 Q $P($G(^DPT(DFN,.39)),"^",6)="Y"

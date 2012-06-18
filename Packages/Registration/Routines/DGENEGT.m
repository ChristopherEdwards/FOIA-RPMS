DGENEGT ;ALB/KCL - Enrollment Group Threshold API's ; 03-MAY-1999
 ;;5.3;Registration;**232**;Aug 13, 1993
 ;
 ;
LOCK(IEN) ;
 ; Description: Used to lock the ENROLLMENT GROUP THRESHOLD record.
 ;
 ;  Input:
 ;   IEN - internal entry number of record in the ENROLLMENT GROUP TRHESHOLD file
 ;
 ; Output:
 ;   Function Value: Returns 1 if the ENROLLMENT GROUP THRESHOLD record
 ;                   can be locked, otherwise returns 0 on failure
 ;
 I $G(IEN) L +^DGEN(27.16,IEN,0):2
 Q $T
 ;
 ;
UNLOCK(IEN) ;
 ; Description: Used to unlock the ENROLLMENT GROUP THRESHOLD record.
 ;
 ;  Input:
 ;   IEN - internal entry number of record in the ENROLLMENT GROUP TRHESHOLD file
 ;
 ; Output:
 ;   None
 ;
 I $G(IEN) L -^DGEN(27.16,IEN,0)
 Q
 ;
 ;
FINDCUR() ;
 ; Description: Used to find current record in the ENROLLMENT GROUP THRESHOLD file. Currently, an EGT history is not required/maintained. 
 ;
 ;  Input: None
 ;
 ; Output:
 ;   Function Value: If successful, returns internal entry number of
 ;                   record in the ENROLLMENT GROUP THRESHOLD file,
 ;                   otherwise returns 0 on failure
 ;
 Q +$O(^DGEN(27.16,0))
 ;
 ;
GET(EGTIEN,DGEGT) ;
 ; Description: Used to obtain a record in the ENROLLMENT GROUP THRESHOLD file.  The values will be returned in the DGEGT() array.
 ;
 ;  Input:
 ;   EGTIEN - internal entry number of record in the ENROLLMENT GROUP THRESHOLD file
 ;
 ; Output:     
 ;  DGEGT - The ENROLLMENT GROUP THRESHOLD array, passed by reference
 ;
 ;       Subscript     Field
 ;       ---------     ---------------------
 ;       "EFFDATE"     EGT EFFECTIVE DATE
 ;       "PRIORITY"    EGT PRIORITY
 ;       "SUBGRP"      EGT SUBGROUP
 ;       "TYPE"        EGT TYPE
 ;       "FEDDATE"     FEDERAL REGISTER DATE
 ;       "ENTDATE"     DATE ENTERED
 ;       "SOURCE"      SOURCE OF EGT
 ;       "REMARKS"     REMARKS
 ;
 N SUB,NODE
 K DGEGT S DGEGT=""
 ;
 I '$G(EGTIEN) D  Q 0
 .F SUB="EFFDATE","PRIORITY","SUBGRP","TYPE","FEDDATE","ENTDATE","SOURCE","REMARKS" S DGEGT(SUB)=""
 ;
 S NODE=$G(^DGEN(27.16,EGTIEN,0))
 S DGEGT("EFFDATE")=$P(NODE,"^")
 S DGEGT("PRIORITY")=$P(NODE,"^",2)
 S DGEGT("SUBGRP")=$P(NODE,"^",3)
 S DGEGT("TYPE")=$P(NODE,"^",4)
 S DGEGT("FEDDATE")=$P(NODE,"^",5)
 S DGEGT("ENTDATE")=$P(NODE,"^",6)
 S DGEGT("SOURCE")=$P(NODE,"^",7)
 S NODE=$G(^DGEN(27.16,EGTIEN,"R"))
 S DGEGT("REMARKS")=$P(NODE,"^")
 ;
 Q 1
 ;
 ;
STORE(DGEGT,ERROR,CHKFLG) ;
 ; Description: Creates a new entry in the ENROLLMENT GROUP THRESHOLD file.
 ;
 ;  Input:
 ;    DGEGT - the ENROLLMENT GROUP THRESHOLD array, passed by reference
 ;   CHKFLG - a flag, if set to 1 means that field validation checks
 ;            were completed, 0 indicates field validation checks should
 ;            be performed (optional) 
 ;
 ; Output:
 ;  Function Value - Returns internal entry number of record created, or 0 on failure
 ;           ERROR - if not successful, an error message is returned,
 ;                   pass by reference (optional)
 ;
 ;
 S ERROR=""
 I $G(CHKFLG)'=1 Q:'$$VALID(.DGEGT,.ERROR) 0
 ;
 N ADD,DATA
 S DATA(.01)=DGEGT("EFFDATE")
 S DATA(.02)=DGEGT("PRIORITY")
 S DATA(.03)=DGEGT("SUBGRP")
 S DATA(.04)=DGEGT("TYPE")
 S DATA(.05)=DGEGT("FEDDATE")
 S DATA(.06)=DGEGT("ENTDATE")
 S DATA(.07)=DGEGT("SOURCE")
 S DATA(25)=DGEGT("REMARKS")
 S ADD=$$ADD^DGENDBS(27.16,,.DATA,.ERROR)
 ;
 Q +ADD
 ;
 ;
UPDATE(EGTIEN,DGEGT,ERROR) ;
 ; Description: Updates an Enrollment Group Threshold record in the
 ; ENROLLMENT GROUP THRESHOLD file.  This function locks the Enrollment
 ; Group Threshold record and releases the lock when the update is
 ; complete. 
 ;
 ;  Input:
 ;   EGTIEN - internal entry number of record in the ENROLLMENT GROUP THRESHOLD file
 ;    DGEGT - the ENROLLMENT GROUP THRESHOLD array, passed by reference
 ;
 ; Output:
 ;  Function Value - Returns 1 if successful, otherwise 0
 ;           ERROR - if not successful, an error message is returned,
 ;                   pass by reference
 ;
 N SUCCESS,DATA
 S SUCCESS=1
 S ERROR=""
 ;
 D  ; drops out of do block if invalid condition is found
 .I $G(EGTIEN),$D(^DGEN(27.16,EGTIEN,0))
 .E  S SUCCESS=0,ERROR="ENROLLMENT GROUP THRESHOLD RECORD NOT FOUND" Q
 .I '$$LOCK(EGTIEN) S SUCCESS=0,ERROR="ENROLLMENT GROUP THRESHOLD RECORD IS LOCKED, CAN'T BE EDITED" Q
 .;
 .S DATA(.01)=DGEGT("EFFDATE")
 .S DATA(.02)=DGEGT("PRIORITY")
 .S DATA(.03)=DGEGT("SUBGRP")
 .S DATA(.04)=DGEGT("TYPE")
 .S DATA(.05)=DGEGT("FEDDATE")
 .S DATA(.06)=DGEGT("ENTDATE")
 .S DATA(.07)=DGEGT("SOURCE")
 .S DATA(25)=DGEGT("REMARKS")
 .;
 .I '$$UPD^DGENDBS(27.16,EGTIEN,.DATA) S ERROR="FILEMAN UNABLE TO PERFORM UPDATE",SUCCESS=0 Q
 ;
 D UNLOCK(EGTIEN)
 ;
 Q SUCCESS
 ;
 ;
DELETE(EGTIEN) ; Description: This function will delete a record in the ENROLLMENT GROUP THRESHOLD file.
 ;
 ;  Input:
 ;   EGTIEN - as internal entry number of record to delete 
 ;
 ; Outpu:
 ;  Function Value - Returns 1 if successful, otherwise 0
 ;
 Q:'$G(EGTIEN) 0
 N DIK,DA
 S DIK="^DGEN(27.16,"
 S DA=EGTIEN
 D ^DIK
 Q 1
 ;
 ;
VALID(DGEGT,ERROR) ;
 ; Description: Performs validation checks on ENROLLMENT GROUP THRESHOLD record contained in the DGEGT array.
 ;
 ;  Input:
 ;   DGEGT - the ENROLLMENT GROUP THRESHOLD array, passed by reference
 ;
 ; Output:
 ;   Function Value - Returns 1 if validation checks passed, 0 otherwise
 ;            ERROR - if validation checks fail, an error message is
 ;                    returned, pass by reference
 ;
 N VALID,EXTERNAL,RESULT
 S VALID=1
 S ERROR=""
 ;
 D  ; drops out of DO block if an invalid condition found
 .;
 .; check for required fields
 .I $G(DGEGT("EFFDATE"))="" S VALID=0,ERROR="REQUIRED FIELD 'EGT EFFECTIVE DATE' MISSING" Q
 .I $G(DGEGT("PRIORITY"))="" S VALID=0,ERROR="REQUIRED FIELD 'EGT PRIORITY' MISSING" Q
 .I $G(DGEGT("TYPE"))="" S VALID=0,ERROR="REQUIRED FIELD 'EGT TYPE' MISSING" Q
 .I $G(DGEGT("ENTDATE"))="" S VALID=0,ERROR="REQUIRED FIELD 'DATE ENTERED' MISSING" Q
 .I $G(DGEGT("SOURCE"))="" S VALID=0,ERROR="REQUIRED FIELD 'SOURCE OF EGT' MISSING" Q
 .;
 .; check if field values are valid
 .I '$$TESTVAL("EFFDATE",DGEGT("EFFDATE")) S VALID=0,ERROR="'EGT EFFECTIVE DATE' NOT VALID" Q
 .I '$$TESTVAL("PRIORITY",DGEGT("PRIORITY")) S VALID=0,ERROR="'EGT PRIORITY' NOT VALID" Q
 .I '$$TESTVAL("SUBGRP",DGEGT("SUBGRP")) S VALID=0,ERROR="'EGT SUBGRP' NOT VALID" Q
 .I '$$TESTVAL("TYPE",DGEGT("TYPE")) S VALID=0,ERROR="'EGT TYPE' NOT VALID" Q
 .I '$$TESTVAL("FEDDATE",DGEGT("FEDDATE")) S VALID=0,ERROR="'FEDERAL REGISTER DATE' NOT VALID" Q
 .I '$$TESTVAL("ENTDATE",DGEGT("ENTDATE")) S VALID=0,ERROR="'DATE ENTERED' NOT VALID" Q
 .I '$$TESTVAL("SOURCE",DGEGT("SOURCE")) S VALID=0,ERROR="'SOURCE OF EGT' NOT VALID" Q
 .I ($G(DGEGT("REMARKS"))'="")&($L($G(DGEGT("REMARKS")))<3)!($L($G(DGEGT("REMARKS")))>80) S VALID=0,ERROR="'REMARKS' NOT VALID" Q
 ;
 Q VALID
 ;
 ;
TESTVAL(SUB,VAL) ; Description: Used to determine if a field value is valid.
 ;
 ;  Input:
 ;     SUB - as the field subscript
 ;     VAL - as the field value
 ;
 ; Output:
 ;  Function value: Returns 1 if the field value (VAL) is valid for
 ;                  the subscript (SUB), returns 0 otherwise.
 ;
 N DISPLAY,FIELD,RESULT,VALID
 ;
 S VALID=1
 ;
 I (VAL'="") D
 .S FIELD=$$FIELD(SUB)
 .; if there is no external value then not valid
 .S DISPLAY=$$EXTERNAL^DILFD(27.16,FIELD,"F",VAL)
 .I (DISPLAY="") S VALID=0 Q
 .I $$GET1^DID(27.16,FIELD,"","TYPE")'="POINTER" D
 ..D CHK^DIE(27.16,FIELD,,VAL,.RESULT) I RESULT="^" S VALID=0 Q
 ;
 Q VALID
 ;
 ;
FIELD(SUB) ; Description: Used to determine the field number for a given subscript in the EGT array.
 ;
 ;  Input:
 ;     SUB - as the field subscript
 ;
 ; Output:
 ;  Function value: Returns the field number for the given subscript,
 ;                  otherwise null is returned.
 ;
 ;
 N FLD
 S FLD=""
 ;
 D  ; drops out of DO block once SUB is determined
 .I SUB="EFFDATE" S FLD=.01 Q
 .I SUB="PRIORITY" S FLD=.02 Q
 .I SUB="SUBGRP" S FLD=.03 Q
 .I SUB="TYPE" S FLD=.04 Q
 .I SUB="FEDDATE" S FLD=.05 Q
 .I SUB="ENTDATE" S FLD=.06 Q
 .I SUB="SOURCE" S FLD=.07 Q
 .I SUB="REMARKS" S FLD=25 Q
 ;
 Q FLD

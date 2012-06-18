DGPFAA2 ;ALB/KCL - PRF ASSIGNMENT API'S CONTINUED ; 4/24/03 3:55pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 ;- no direct entry
 QUIT
 ;
ADDOK(DGDFN,DGFLG,DGREASON) ;This function will be used to determine if a flag may be added/assigned to a patient.
 ;
 ;  Input:
 ;   DGDFN - (required) IEN of patient in PATIENT (#2) file
 ;   DGFLG - (required) IEN of patient record flag in PRF NATIONAL
 ;           FLAG (#26.15) file or PRF LOCAL FLAG (#26.11) file.
 ;           [ex: "1;DGPF(26.15,"]
 ;
 ; Output:
 ;  Function Value - returns 1 on success (YES), 0 on failure (NO)
 ;        DGREASON - undefined on success, reason why flag can not
 ;                   be assigned to patient on failure
 ;
 N RESULT   ;function result
 N DGFARRY  ;contains flag array
 K DGFARRY
 ;
 S RESULT=0
 ;
 D  ;-drops out of block on failure
 . ;
 . ;-- quit if DFN invalid
 . I '(+$G(DGDFN)>0),'$D(^DPT(DGDFN)) S DGREASON="Patient is not valid" Q
 . ;
 . ;-- quit if flag ien invalid
 . I '$$TESTVAL^DGPFUT(26.13,.02,DGFLG) S DGREASON="Record flag is not valid" Q
 . ;
 . ;-- quit if flag already assigned to patient
 . I $$FNDASGN^DGPFAA(DGDFN,DGFLG) S DGREASON="Record flag is already assigned to patient" Q
 . ;
 . ;-- quit if flag STATUS is INACTIVE
 . I $$GETFLAG^DGPFUT1(DGFLG,.DGFARRY)
 . I '+$G(DGFARRY("STAT")) S DGREASON="Status of record flag assignment is 'Inactive'" Q
 . ;
 . ;-- success
 . S RESULT=1
 ;
 Q RESULT
 ;
 ;
EDTOK(DGPFA,DGORIG,DGREASON) ;This function will be used to determine if an flag assignment may be edited.
 ;
 ;  Input:
 ;    DGPFA - (required) array containing the flag assignment values
 ;   DGORIG - (optional) originating site [default = +$$SITE^VASITE()] 
 ;
 ; Output:
 ;  Function Value - returns 1 on success (YES), 0 on failure (NO)
 ;        DGREASON - undefined on success, reason why assignment
 ;                   can not be edited on failure
 ;
 N RESULT   ;function result
 N DGFARRY  ;contains flag array
 K DGFARRY
 ;
 S RESULT=0
 ;
 D  ;-drops out of block on failure
 . ;
 . ;-- quit if current site is not the owner site
 . I +$G(DGORIG)'>0 S DGORIG=+$$SITE^VASITE()
 . I +$G(DGPFA("OWNER"))'=DGORIG S DGREASON="Not the owner site" Q
 . ;
 . ;-- quit if flag STATUS is INACTIVE
 . I $$GETFLAG^DGPFUT1($P($G(DGPFA("FLAG")),U),.DGFARRY)
 . I '+$G(DGFARRY("STAT")) S DGREASON="Record flag status is 'Inactive'" Q
 . ;
 . ;-- success
 . S RESULT=1
 ;
 Q RESULT
 ;
ACTIONOK(DGPFA,DGACT) ;verify ACTION is appropriate for current STATUS
 ;
 ;  Input:
 ;    DGPFA - (required) assignment array data from current record
 ;    DGACT - Assignment edit action in internal format
 ;            [1:NEW ASSIGNMENT,2:CONTINUE,3:INACTIVATE,4:REACTIVATE]
 ;
 ;  Output:
 ;   Function value - 1 on success, 0 on failure
 ;
 N DGRSLT
 N DGSTAT
 ;
 S DGACT=+$G(DGACT)
 S DGSTAT=$P($G(DGPFA("STATUS")),U,1)
 S DGRSLT=0
 ;
 I $$TESTVAL^DGPFUT(26.14,.03,DGACT),DGSTAT?1N D
 . ;
 . ;Must not CONTINUE inactive assignments
 . I DGACT=2,DGSTAT=0 Q
 . ;
 . ;Must not INACTIVATE inactive assignments
 . I DGACT=3,DGSTAT=0 Q
 . ;
 . ;Must not REACTIVATE active assignments
 . I DGACT=4,DGSTAT=1 Q
 . ;
 . ;success
 . S DGRSLT=1
 ;
 Q DGRSLT
 ;
CHGOWN(DGPFA,DGORIG,DGREASON) ;Is site allowed to change ownership of a record flag assignment?
 ;
 ;  Input:
 ;    DGPFA - (required) array containing the flag assignment values
 ;   DGORIG - (optional) originating site [default = +$$SITE^VASITE()] 
 ;
 ; Output:
 ;  Function Value - returns 1 on success (YES), 0 on failure (NO)
 ;        DGREASON - undefined on success, reason why assignment
 ;                   ownership can not be edited on failure
 ;
 N DGRSLT   ;function result
 ;
 S:(+$G(DGORIG)'>0) DGORIG=(+$$SITE^VASITE())
 S DGRSLT=0
 ;
 D  ;drops out of block on failure
 . ;
 . ;ORIGINATING SITE must be OWNER and flag must be ACTIVE
 . Q:('$$EDTOK(.DGPFA,DGORIG,.DGREASON))
 . ;
 . ;can't CHANGE OWNERSHIP for an assignment to a LOCAL flag
 . I $P(DGPFA("FLAG"),U)["26.11" D  Q
 . .S DGREASON="Can't change ownership of assignments to Category II (Local) flags"
 . . Q
 . ;
 . ;can't CHANGE OWNERSHIP for an INACTIVE assignment
 . I '+$G(DGPFA("STATUS")) D  Q
 . . S DGREASON="Record flag assignment status is 'Inactive'"
 . . Q
 . ;
 . ;success
 . S DGRSLT=1
 ;
 Q DGRSLT
 ;
HL7EDTOK(DGDFN,DGFLG,DGORIG,DGACT) ;Is site allowed to edit assignment?
 ; This function acts as wrapper for $$EDTOK and $$ACTIONOK for edits
 ; that originate from PRF HL7 message processing.
 ;
 ;  Input:
 ;    DGDFN - IEN of patient in PATIENT (#2) file
 ;    DGFLG - IEN of patient record flag in PRF NATIONAL FLAG (#26.15)
 ;            file or PRF LOCAL FLAG (#26.11) file. [ex: "1;DGPF(26.15,"]
 ;   DGORIG - IEN of originating site in INSTITUTION (#4) file
 ;    DGACT - Assignment edit action in internal format
 ;            [1:NEW ASSIGNMENT,2:CONTINUE,3:INACTIVATE,4:REACTIVATE]
 ;
 ;  Output:
 ;   Function value - 1 if authorized, 0 if not authorized
 ;
 N DGIEN   ;pointer to PRF ASSIGNMENT (#26.13) file
 N DGPFA   ;assignment data array
 N DGRSLT  ;function value
 ;
 S DGACT=+$G(DGACT)
 S DGDFN=+$G(DGDFN)
 S DGFLG=$G(DGFLG)
 S DGORIG=+$G(DGORIG)
 S DGRSLT=0
 ;
 I DGACT>0,DGDFN>0,DGFLG]"",DGORIG>0 D
 . ;
 . ;retrieve existing assignment data
 . S DGIEN=$$FNDASGN^DGPFAA(DGDFN,DGFLG)
 . Q:('DGIEN)
 . Q:('$$GETASGN^DGPFAA(DGIEN,.DGPFA))
 . ;
 . ;ORIGINATING SITE must be OWNER and flag must be ACTIVE
 . Q:('$$EDTOK(.DGPFA,DGORIG))
 . ;
 . ;ACTION must be valid for current assignment STATUS
 . Q:('$$ACTIONOK(.DGPFA,DGACT))
 . ;
 . ;success
 . S DGRSLT=1
 ;
 Q DGRSLT
 ;
STOHL7(DGPFA,DGPFAH,DGERR) ;store a valid assignment from HL7 message
 ; This function files an assignment if the originating site is 
 ; authorized to update an existing record and if the action is valid for
 ; the status of an existing record. 
 ;
 ;  Input:
 ;    DGPFA - (required) array of assignment values to be filed (see
 ;            $$GETASGN^DGPFAA for valid array structure)
 ;   DGPFAH - (required) array of assignment history values to be filed
 ;            (see $$STOHIST^DGPFAAH for valid array structure)
 ;
 ;  Output:
 ;   Function Value - Returns 1 on sucess, 0 on failure
 ;          DGERR - Undefined on success, error code on failure
 ;
 N DGDFN
 N DGFLG
 N DGORIG
 N DGACT
 N DGSTOERR
 N DGRSLT
 ;
 S DGDFN=+$G(DGPFA("DFN"))
 S DGFLG=$G(DGPFA("FLAG"))
 S DGORIG=+$G(DGPFA("ORIGSITE"))
 S DGACT=+$G(DGPFAH("ACTION"))
 ;
 S DGRSLT=0
 I DGDFN,DGFLG,DGORIG]"",DGACT D
 . ;
 . ;new assignment action
 . I DGACT=1,'$$ADDOK(DGDFN,DGFLG) D  Q
 . . S DGERR="UU"      ;unauthorized update
 . ;
 . ;all other actions
 . I DGACT'=1,'$$HL7EDTOK(DGDFN,DGFLG,DGORIG,DGACT) D  Q
 . . S DGERR="UU"      ;unauthorized update
 . ;
 . ;file the assignment and history
 . I '$$STOALL^DGPFAA(.DGPFA,.DGPFAH,.DGSTOERR)!($D(DGSTOERR)) D  Q
 . . S DGERR="FE"      ;filer error
 . S DGRSLT=1
 Q DGRSLT
 ;
ROLLBACK(DGAIEN,DGPFOA) ;Roll back an assignment record
 ;
 ;  Input:
 ;    DGAIEN - IEN of assignment to roll back in the PRF ASSIGNMENT
 ;             (#26.13) file
 ;    DGPFOA - Assignment data array prior to record modification
 ;
 ;  Output:
 ;    Function value - 1 on successful rollback, 0 on failure
 ;
 N DGIENS
 N DGFDA
 N DGERR
 N DGRSLT   ;function result
 ;
 S DGRSLT=0
 I +$G(DGAIEN),$D(^DGPF(26.13,DGAIEN)),$D(DGPFOA) D
 . S DGIENS=DGAIEN_","
 . I $G(DGPFOA("DFN"))="@" D
 . . S DGFDA(26.13,DGIENS,.01)=DGPFOA("DFN")
 . . D FILE^DIE("","DGFDA","DGERR")
 . . I '$D(DGERR) S DGRSLT=1
 . E  D
 . . I $$STOASGN^DGPFAA(.DGPFOA,.DGERR),'$D(DGERR) S DGRSLT=1
 Q DGRSLT

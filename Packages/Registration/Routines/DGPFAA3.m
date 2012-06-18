DGPFAA3 ;ALB/RPM - PRF ASSIGNMENT API'S CONTINUED ; 3/28/03
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 Q  ;no direct entry
 ;
NOTIFYDT(DGFLG,DGRDT) ;calculate the notificaton date
 ;
 ;  Input:
 ;    DGFLG - (required) pointer to PRF LOCAL FLAG (#26.11) file or 
 ;            PRF NATIONAL FLAG (#26.15) file
 ;    DGRDT - (required) review date in FM format
 ;
 ;  Output:
 ;   Function Value - notification date in FM format on success, 0 on
 ;                    failure.
 ;
 N DGFLGA   ;flag file data array
 N DGNDT    ;function value
 ;
 S DGNDT=0
 I $G(DGFLG)]"",+$G(DGRDT)>0 D
 . ;
 . ;Retrieve the flag data array
 . Q:'$$GETFLAG^DGPFUT1(DGFLG,.DGFLGA)
 . ;
 . ;must have a review frequency
 . Q:(+$G(DGFLGA("REVFREQ"))=0)
 . ;
 . ;determine notification date
 . S DGFLGA("NOTIDAYS")=$G(DGFLGA("NOTIDAYS"),0)
 . S DGRDT=+$$FMTH^XLFDT(DGRDT)
 . S DGNDT=+$$HTFM^XLFDT(DGRDT-DGFLGA("NOTIDAYS"))
 ;
 Q DGNDT
 ;
GETRDT(DGFLG,DGADT) ;calculate the review date
 ;
 ;  Input:
 ;    DGFLG - (required) pointer to PRF LOCAL FLAG (#26.11) file or 
 ;            PRF NATIONAL FLAG (#26.15) file
 ;    DGADT - (required) assignment date in FM format
 ;
 ;  Output:
 ;   Function Value - review date in FM format on success, 0 on failure
 ;
 N DGFLGA   ;flag file data array
 N DGRDT  ;function value
 ;
 S DGRDT=0
 I $G(DGFLG)]"",+$G(DGADT)>0 D
 . ;
 . ;Retrieve the flag data array
 . Q:'$$GETFLAG^DGPFUT1(DGFLG,.DGFLGA)
 . ;
 . ;must have a review frequency
 . Q:(+$G(DGFLGA("REVFREQ"))=0)
 . ;
 . ;determine review date
 . S DGADT=+$$FMTH^XLFDT(DGADT)
 . S DGRDT=+$$HTFM^XLFDT(DGADT+DGFLGA("REVFREQ"))
 ;
 Q DGRDT
 ;
LOCK(DGAIEN) ;Lock assignment record.
 ;
 ; This function is used to prevent another process from editing a
 ; patient's record flag assignment.
 ;
 ;  Input:
 ;   DGAIEN - IEN of record in the PRF ASSIGNMENT (#26.13) file
 ;
 ; Output:
 ;  Function Value - Returns 1 if the lock was successful, 0 otherwise
 ;
 I $G(DGAIEN) L +^DGPF(26.13,DGAIEN):10
 ;
 Q $T
 ;
UNLOCK(DGAIEN) ;Unlock assignment record.
 ;
 ; This procedure is used to release the lock created by $$LOCK.
 ;
 ;  Input:
 ;   DGAIEN - IEN of record in the PRF ASSIGNMENT (#26.13) file
 ;
 ; Output: None
 ;
 I $G(DGAIEN) L -^DGPF(26.13,DGAIEN)
 ;
 Q

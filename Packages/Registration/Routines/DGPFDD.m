DGPFDD ;ALB/RPM - PRF DATA DICTIONARY UTILITIES ; 02/04/03
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 Q  ;No direct entry
 ;
INACT(DGIEN,DGSTAT,DGFILE,DGUSER) ;Inactivate flag trigger
 ; This procedure is used as a trigger that is fired when the
 ; STATUS (#.02) field of a record in either the PRF LOCAL FLAG (#26.11)
 ; file or PRF NATIONAL FLAG (#26.15) file is changed from Active to
 ; Inactive.  The trigger will inactivate all Patient Record
 ; Flag assignments associated with the inactivated Flag.
 ;
 ; Input:
 ;   DGIEN  - IEN of entry in PRF LOCAL FLAG file or PRF NATIONAL 
 ;            FLAG file
 ;   DGSTAT - Flag Status
 ;   DGFILE - PRF LOCAL FLAG file number (26.11) or PRF NATIONAL
 ;            FLAG file number (26.15)
 ;   DGUSER - IEN of user in NEW PERSON file
 ;
 ; Output:  none
 ;
 N DGAIEN  ;assignment record IEN
 N DGSUB   ;variable ptr index subscript
 ;
 Q:('$G(DGIEN))
 Q:($G(DGSTAT)'=0)
 Q:(($G(DGFILE)'=26.11)&($G(DGFILE)'=26.15))
 Q:('$G(DGUSER))
 ;
 S DGSUB=DGIEN_";DGPF("_DGFILE_","
 S DGAIEN=0
 F  S DGAIEN=$O(^DGPF(26.13,"ASTAT",1,DGSUB,DGAIEN)) Q:'DGAIEN  D
 . N DGPFA     ;assignment data array
 . N DGPFAH    ;assignment history data array
 . I $$GETASGN^DGPFAA(DGAIEN,.DGPFA) D
 . . Q:($P($G(DGPFA("STATUS")),U,1)=0)
 . . S DGPFA("STATUS")=0
 . . S DGPFA("REVIEWDT")=""
 . . S DGPFAH("ACTION")=3
 . . S DGPFAH("ASSIGNDT")=$$NOW^XLFDT()
 . . S DGPFAH("ENTERBY")=DGUSER
 . . S DGPFAH("APPRVBY")=DGUSER
 . . S DGPFAH("COMMENT",1,0)="Assignment Inactivated automatically due to Flag Inactivation."
 . . I $$STOALL^DGPFAA(.DGPFA,.DGPFAH)
 Q
 ;
PIHELP ;Executable help for PRINCIPAL INVESTIGATOR(S) (#.01) sub-field of
 ;PRINCIPLE INVESTIGATOR(S) (#2) multiple field of PRF LOCAL FLAG
 ;(#26.11) file.
 ;
 ;This sub-routine displays individuals selected as a principal
 ;investigator for a research type patient record flag.
 ;
 ;  Input:
 ;    DGLKUP - (required) array of principal investigators subscripted
 ;             by the pointer to the NEW PERSON (#200) file and the
 ;             pointer to the PRF LOCAL FLAG (#26.11) file.
 ;             Example:  DGLKUP(11744,6)=""
 ;
 ;  Output:
 ;    none
 ;
 Q:'$D(DGLKUP)
 ;
 N DGCNT
 N DGIEN
 N DGNAMES
 ;
 S DGIEN=0,DGCNT=0
 F  S DGIEN=$O(DGLKUP(DGIEN)) Q:'DGIEN  D
 . S DGCNT=DGCNT+1
 . S DGNAMES(DGCNT)=$$EXTERNAL^DILFD(26.112,.01,"F",DGIEN)
 S DGNAMES(DGCNT+1)=""  ;add a blank line
 D EN^DDIOL(.DGNAMES)
 Q
 ;
COS(DGAPRV) ;transform POSTMASTER to CHIEF OF STAFF
 ;This output transform converts the internal field value of .5
 ;(POSTMASTER) to CHIEF OF STAFF.
 ;
 ;  Supported DBIA #10060 - This supported DBIA permits FileMan reads
 ;                          on all fields of the NEW PERSON (#200) file.
 ;
 ;  Input:
 ;    DGAPRV - internal value of PRF ASSIGNMENT HISTORY (#26.14) file
 ;             APPROVED BY (#.05) field
 ;
 ;  Output:
 ;   Function Value - Returns "CHIEF OF STAFF" when input value is .5 or
 ;                    external value from NAME (.01) field of the NEW
 ;                    PERSON (#200) file on success.
 ;                    Returns null ("") on failure.
 ;
 N DGERR
 ;
 Q:(+$G(DGAPRV)'>0) ""
 ;
 Q $S(DGAPRV=.5:"CHIEF OF STAFF",1:$$GET1^DIQ(200,DGAPRV_",",.01,"","","DGERR"))

DGPFUT2 ;ALB/KCL - PRF UTILITIES CONTINUED ; 8/15/03 1:43pm
 ;;5.3;Registration;**425,1007,1008**;Aug 13, 1993
 ;
 ; This routine contains generic calls for use throughout DGPF*.
 ;
 ;- no direct entry
 QUIT
 ;
 ;
GETPAT(DGDFN,DGPAT) ;EP-retrieve patient identifying information
 ; Used to obtain identifying information for a patient
 ; in the PATIENT (#2) file and place it in an array format.
 ;
 ; NOTE: Direct global reference of patient's zero node in the
 ;       PATIENT (#2) file is supported by DBIA #10035
 ;
 ;  Input:
 ;   DGDFN - (required) ien of patient in PATIENT (#2) file
 ;
 ; Output:
 ;  Function Value - returns 1 on success, 0 on failure
 ;   DGPAT - output array containing the patient identifying information,
 ;           on success, pass by reference.
 ;             Array subscripts are:
 ;             "DFN"  - ien PATIENT (#2) file
 ;             "NAME" - patient name
 ;             "SSN"  - patient Social Security Number
 ;             "DOB"  - patient date of birth (FM format)
 ;             "SEX"  - patient sex
 ;
 N DGNODE
 N RESULT
 ;
 S RESULT=0
 ;
 I $G(DGDFN)>0,$D(^DPT(DGDFN,0)) D
 . ;-- obtain zero node of patient record (supported by DBIA #10035)
 . S DGNODE=$G(^DPT(DGDFN,0))
 . ;
 . S DGPAT("DFN")=DGDFN
 . S DGPAT("NAME")=$P(DGNODE,"^")
 . S DGPAT("SEX")=$P(DGNODE,"^",2)
 . S DGPAT("DOB")=$P(DGNODE,"^",3)
 . S DGPAT("SSN")=$P(DGNODE,"^",9)
 . ;
 . ;IHS/OIT/LJF 12/22/2006 PATCH 1007 set SSN to chart # with dashes
 . S DGPAT("SSN")=$$HRCND^BDGF2($$HRCN^BDGF2(DGDFN,+$G(DUZ(2))))
 . ;
 . S RESULT=1  ;success
 ;
 Q RESULT
 ;
GETDFN(DGICN,DGDOB,DGSSN) ;Convert ICN to DFN after verifying DOB and SSN
 ;
 ;  Supported DBIA #2701:  The supported DBIA is used to retrieve the
 ;                         pointer (DFN) to the PATIENT (#2) file for a
 ;                         given ICN.
 ;
 ;  Input:
 ;    DGICN - Integrated Control Number with or without checksum
 ;    DGDOB - Date of Birth in FileMan format
 ;    DGSSN - Social Security Number with no delimiters
 ;
 ;  Output:
 ;   Function Value - DFN on success, 0 on failure
 ;
 N DGDFN   ;pointer to patient
 N DGDPT   ;patient data array
 N DGRSLT  ;function value
 ;
 S DGRSLT=0
 S DGICN=+$G(DGICN)
 S DGDOB=+$G(DGDOB)
 S DGSSN=+$G(DGSSN)
 I DGICN,DGDOB,DGSSN D  ;drops out of block on first failure
 . S DGDFN=+$$GETDFN^MPIF001(DGICN)
 . Q:(DGDFN'>0)
 . Q:('$$GETPAT^DGPFUT2(DGDFN,.DGDPT))
 . Q:(DGDOB'=+DGDPT("DOB"))
 . Q:(DGSSN'=+DGDPT("SSN"))
 . S DGRSLT=DGDFN
 Q DGRSLT
 ;
SORT(DGPFAPI) ;sort active record flags by category then name
 ; This procedure takes the initial active flag assignment list for a
 ; patient and sorts it by category then by name.
 ;
 ;  Input:
 ;    DGPFAPI - active flag data array list
 ;
 ;  Output:
 ;    DGPFAPI - sorted active flag data array list
 ;
 N DGCAT   ;category
 N DGINDX  ;index array
 N DGNAME  ;flag name
 N DGSORT  ;sorted data array
 N DGX     ;generic counter
 ;
 ;build index
 S DGX=0
 F  S DGX=$O(DGPFAPI(DGX)) Q:'DGX  D
 . S DGCAT=$S($P(DGPFAPI(DGX,"FLAG"),U)[26.11:2,1:1)
 . S DGINDX(DGCAT,$P(DGPFAPI(DGX,"FLAG"),U,2))=DGX
 ;
 ;build sorted data array
 S DGCAT=0,DGX=0
 F  S DGCAT=$O(DGINDX(DGCAT)) Q:'DGCAT  D
 . S DGNAME=""
 . F  S DGNAME=$O(DGINDX(DGCAT,DGNAME)) Q:DGNAME=""  D
 . . S DGX=DGX+1
 . . M DGSORT(DGX)=DGPFAPI(DGINDX(DGCAT,DGNAME))
 ;
 ;remove input array and replace with sorted array
 K DGPFAPI
 M DGPFAPI=DGSORT
 Q
 ;
ACTDT ; update PRF Software Activation Date field in (#26.18)
 ; This utility should only be run at the Alpha and Beta test sites
 ; of the Patient Record Flags Project, Patch DG*5.3*425.
 ; If necessary, this entry point will change the date that the
 ; Patient Record Flags (PRF) System became active.
 ; The (#1) PRF SOFTWARE ACTIVATION DATE field of the (#26.18) PRF
 ; PARAMETERS file, will be changed to:  SEP 25, 2003
 ;
 ;  Input:  none
 ;
 ; Output:  User message on successful or failure of file update
 ;
 N DGACTDT   ; Nationally Released Software Activation Date value
 N DGIENS    ; IEN - internal entry # OF (#26.18) FILE
 N DGFLD     ; PRF Software Activation Date field #
 N DGFDA     ; FDA data array for filer
 N DGERR     ; error message array returned from filer
 N DGERRMSG  ; error message for display
 N DGPARM    ; current internal/external values of field
 ;
 S DGACTDT="SEP 25, 2003"
 S DGIENS="1,"
 S DGFLD=1
 ;
 ; display user message
 W !!,"Updating the PRF SOFTWARE ACTIVATION DATE (#1) field in the PRF PARAMETERS FILE (#26.18) to the value of SEP 25, 2003..."
 ;
 ; checks for necessary programmer variables
 I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^") D
 . S DGERRMSG="Your programming variables are not set up properly."
 ;
 ; check if activation is not less than the current date
 I '$D(DGERRMSG),DT<3030925 D
 . S DGERRMSG="This file/field update can't be run before the date of SEP 25, 2003 is reached."
 ;
 ; get current activation date from PRF PARAMETERS (#26.18) file
 I '$D(DGERRMSG) D
 . D GETS^DIQ(26.18,"1,",1,"IE","DGPARM","DGERR")
 . ;
 . ; check for errors and inform the user
 . I $D(DGERR) D  Q
 . . S DGERRMSG=$G(DGERR("DIERR",1,"TEXT",1))
 . ;
 . ; check to make sure field is not set already
 . I $G(DGPARM(26.18,"1,",1,"I"))=3030925 D
 . . S DGERRMSG="The date value is already set to SEP 25, 2003."
 ;
 ; now start the (#26.18) filing process
 I '$D(DGERRMSG) D
 . ;
 . ; DELETE activation date before filing since field is uneditable
 . S DGFDA(26.18,DGIENS,1)="@"
 . D FILE^DIE("","DGFDA","DGERR")
 . ;
 . ; check for errors and inform the user
 . I $D(DGERR) D  Q
 . . S DGERRMSG=$G(DGERR("DIERR",1,"TEXT",1))
 . ;
 . ; setup and file the new activation date value (external)
 . S DGFDA(26.18,DGIENS,1)=DGACTDT
 . D FILE^DIE("SE","DGFDA","DGERR")
 . ;
 . ; check for success or errors and inform the user of update status
 . I $D(DGERR) D  Q
 . . S DGERRMSG=$G(DGERR("DIERR",1,"TEXT",1))
 ;
 ; display successful/failure file update - updated field and value
 W !!,$C(7)
 I $D(DGERRMSG) D
 . W "Field could not be updated...",DGERRMSG
 E  D
 . W "Field was successfully changed from ",$G(DGPARM(26.18,"1,",1,"E"))," to ",$G(DGFDA(26.18,DGIENS,DGFLD)),"."
 ;
 Q

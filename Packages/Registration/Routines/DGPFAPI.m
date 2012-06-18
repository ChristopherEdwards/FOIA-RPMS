DGPFAPI ;ALB/RBS - PRF EXTERNAL USER INTERFACE API'S ; 9/2/03 10:30am
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 ; This routine contains API entry points that are used by packages
 ; and modules that are external to the Patient Record Flags module.
 ;
 Q  ;no direct entry
 ;
GETACT(DGDFN,DGPRF) ;Retrieve all ACTIVE Patient record flag assignments
 ; The purpose of this API is to facilitate the retrieval of specific
 ; data that can be used for the displaying of or the reporting of
 ; only ACTIVE Patient Record Flag (PRF) Assignment information for
 ; a patient.
 ;
 ; Usage of this API, DBIA #3860, is by Controlled Subscription.
 ;
 ;  Input:
 ;   DGDFN - IEN of patient in the PATIENT (#2) file
 ;   DGPRF - Closed Root array of return values
 ;           [Optional-default DGPFAPI]
 ;
 ;  Output:
 ;   Function result - "0"  = No Active record flags for the patient
 ;                   - "nn" = Total number of flags returned in array
 ;     DGPRF() - Array, passed by closed root reference
 ;             - Multiple subscripted array of Active flag information
 ;               If the function call is successful, this array will
 ;               contain each of the Active flag records.
 ;             - Subscript field value = internal value^external value
 ;               2 piece string caret(^) delimited
 ;   DGPFAPI() - Default array name if no name passed
 ;
 ; Subscript   Field Name                Field #/File #
 ; ---------   ----------                --------------
 ; "APPRVBY"   Approved By               (.05)/(#26.14)
 ;    The field value contains the pointer to the NEW PERSON
 ;    FILE (#200) of the person approving the assignment of a
 ;    patient record flag to a patient.
 ;    The field values will be one of the following two explanations:
 ;     1. If calling site IS the Originating Site...
 ;        PIECE 1 = IEN pointer to NEW PERSON FILE (#200)
 ;        PIECE 2 = Name of Person
 ;     2. If calling site is NOT the Originating Site...
 ;        PIECE 1 = .5
 ;        PIECE 2 = "CHIEF OF STAFF"
 ;        (Note: The .5 (POSTMASTER) internal field value triggers an
 ;               output transform that converts the external value
 ;               of "POSTMASTER" to "CHIEF OF STAFF".
 ; "ASSIGNDT"  Assign Date/Time          (.02)/(#26.14)
 ;    The field value contains a FileMan internal^external Date and
 ;    Time of the initial assignment of the Patient Record Flag.
 ;
 ; "REVIEWDT"  Review Date               (.06)/(#26.13)
 ;    The field value contains a FileMan internal^external date that
 ;    the flag assignment is due for review to determine continuing
 ;    appropriateness.
 ;
 ; "FLAG"      Flag Name                 (.02)/(#26.13)
 ;    The field value contains the Patient Record Flag name that is
 ;    assigned to the patient as a variable pointer.
 ;     PIECE 1 = IEN variable pointer to (#26.11) or (#26.15) file
 ;     PIECE 2 = Name of Flag
 ;
 ; "FLAGTYPE"   Type of Flag             (.03)/(#26.11 or #26.15)
 ;    The field value contains the Record Flag Type usage
 ;    classification. (i.e. BEHAVIORAL,RESEARCH,CLINICAL,OTHER)
 ;     PIECE 1 = IEN of the flag Type (pointer to (#26.16) file)
 ;     PIECE 2 = Name of flag Type
 ;
 ; "CATEGORY"  National or Local Flag    (#26.15) or (#26.11)
 ;    The field value contains the type of category the flag
 ;    represents.
 ;    I (NATIONAL) = (#26.15) PRF NATIONAL
 ;    II (LOCAL)   = (#26.11) PRF LOCAL
 ;     PIECE 1 = I (NATIONAL) or II (LOCAL)
 ;     PIECE 2 = (same value as PIECE 1)
 ;
 ; "OWNER"     Owner Site                (.04)/(#26.13)
 ;    The field value contains the Site that owns the patient's
 ;    Record Flag Assignment.  Only the Owner Site may edit a patients
 ;    flag assignment.
 ;     PIECE 1 = IEN of the site (pointer to INSTITUTION FILE (#4))
 ;     PIECE 2 = Name of Institution
 ;
 ; "ORIGSITE"  Originating Site          (.05)/(#26.13)
 ;    The field value contains the Site that first entered the Patient
 ;    Record Flag on this patient.
 ;     PIECE 1 = IEN of the site (pointer to INSTITUTION FILE (#4))
 ;     PIECE 2 = Name of Institution
 ;
 ; "NARR"      Assignment Narrative      (1)/(#26.13)
 ;             (word-processing, multiple nodes)
 ;    The field value contains the reason narrative for this patients
 ;    assignment of a Patient Record Flag.
 ;    The format is in a word-processing value that may contain
 ;    multiple nodes of text.  Each node of text will be less
 ;    than 80 characters in length.
 ;    The format is as follows:
 ;     TARGET_ROOT(nn,"NARR",line#,0)=text
 ;      where:
 ;          nn = a unique number for each Flag
 ;       line# = a unique number starting at 1 for each wp line
 ;               of narrative text
 ;           0 = standard subscript format for the nodes of a
 ;               FileMan Word Processing field
 ;
 N DGPFTCNT  ;return results, "0"=no flags, "nn"=number of flags
 N DGPFIENS  ;array of all active flag assignment IEN's
 N DGPFIEN   ;ien of record flag assignment in (#26.13) file
 N DGPFA     ;flag assignment array
 N DGPFAH    ;flag assignment history array
 N DGPFLAG   ;flag record array
 N DGCAT     ;flag category
 ;
 Q:'$G(DGDFN) 0                            ;Quit, null parameter
 Q:'$$GETALL^DGPFAA(DGDFN,.DGPFIENS,1) 0   ;Quit, no Active assign's
 ;
 S DGPRF=$G(DGPRF)
 I DGPRF']"" S DGPRF="DGPFAPI"             ;setup default array name
 S (DGPFIEN,DGCAT)="",DGPFTCNT=0
 ;
 ; loop all returned Active Record Flag Assignment ien's
 F  S DGPFIEN=$O(DGPFIENS(DGPFIEN)) Q:DGPFIEN=""  D
 . K DGPFA,DGPFAH,DGPFLAG
 . ;
 . ; retrieve single assignment record fields
 . Q:'$$GETASGN^DGPFAA(DGPFIEN,.DGPFA)
 . ;
 . ; no patient DFN match
 . I DGDFN'=$P(DGPFA("DFN"),U) Q
 . ;
 . ; get initial assignment history
 . Q:'$$GETHIST^DGPFAAH($$GETFIRST^DGPFAAH(DGPFIEN),.DGPFAH)
 . ;
 . ; get record flag record
 . Q:'$$GETFLAG^DGPFUT1($P($G(DGPFA("FLAG")),U),.DGPFLAG)
 . ;
 . S DGPFTCNT=DGPFTCNT+1
 . ;
 . ; approved by user
 . S @DGPRF@(DGPFTCNT,"APPRVBY")=$G(DGPFAH("APPRVBY"))
 . ;
 . ; initial assignment date/time
 . S @DGPRF@(DGPFTCNT,"ASSIGNDT")=$G(DGPFAH("ASSIGNDT"))
 . ;
 . ; next review due date
 . S @DGPRF@(DGPFTCNT,"REVIEWDT")=$G(DGPFA("REVIEWDT"))
 . ;
 . ; record flag name
 . S @DGPRF@(DGPFTCNT,"FLAG")=$G(DGPFA("FLAG"))
 . ;
 . ; record flag type
 . S @DGPRF@(DGPFTCNT,"FLAGTYPE")=$G(DGPFLAG("TYPE"))
 . ;
 . ; category of flag - I (NATIONAL) or II (LOCAL)
 . S DGCAT=$S($G(DGPFA("FLAG"))["26.15":"I (NATIONAL)",1:"II (LOCAL)")
 . S @DGPRF@(DGPFTCNT,"CATEGORY")=DGCAT_U_DGCAT
 . ;
 . ; owner site
 . S @DGPRF@(DGPFTCNT,"OWNER")=$G(DGPFA("OWNER"))
 . ;
 . ; originating site
 . S @DGPRF@(DGPFTCNT,"ORIGSITE")=$G(DGPFA("ORIGSITE"))
 . ;
 . ; narrative
 . I '$D(DGPFA("NARR",1,0)) D  Q  ;should never happen - but -
 . . S @DGPRF@(DGPFTCNT,"NARR",1,0)="No Narrative Text"
 . ;
 . M @DGPRF@(DGPFTCNT,"NARR")=DGPFA("NARR")
 ;
 ; Re-Sort Active flags by category & alpha flag name
 I +$G(DGPFTCNT)>1 D SORT^DGPFUT2(.@DGPRF)
 ;
 Q DGPFTCNT
 ;
PRFQRY(DGDFN) ;query the CMOR for all patient record flag assignments
 ; This function queries a given patient's Coordinated Master of Record
 ; (CMOR) site to retrieve all patient record flag assignments for the
 ; patient.  The function will only succeed when the QRY HL7 interface
 ; is enabled, the patient has a national Integrated Control Number
 ; (ICN), the patient's CMOR is not the local site and the HL7 query
 ; receives an ACK from the CMOR site.
 ;
 ;  Input:
 ;    DGDFN - pointer to patient in PATIENT (#2) file
 ;
 ;  Output:
 ;   Function value - 1 on success, 0 on failure
 ;
 N DGRSLT
 N DGQRY
 ;
 S DGRSLT=0
 ;
 S DGQRY=+$$QRYON^DGPFPARM()
 I DGQRY D
 . S DGRSLT=$$SNDQRY^DGPFHLS(DGDFN,DGQRY)
 ;
 Q DGRSLT
 ;
DISPPRF(DGDFN) ;display active patient record flag assignments
 ; This procedure performs a lookup for active patient record flag
 ; assignments for a given patient and formats the assignment data for
 ; roll-and-scroll display.
 ;
 ;  Input:
 ;    DGDFN - pointer to patient in PATIENT (#2) file
 ;
 ;  Output:
 ;    none
 ;
 Q:'$D(XQY0)
 Q:$P(XQY0,U)="DGPF RECORD FLAG ASSIGNMENT"
 ;
 ;protect Kernel IO variables
 N IOBM,IOBOFF,IOBON,IOEDEOP,IOINHI,IOINORM,IORC,IORVOFF,IORVON
 N IOSC,IOSGRO,IOSTBM,IOTM,IOUOFF,IOUON
 ;
 ;protect ListMan variables
 N VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCC,VALMCNT,VALMCOFF,VALMCON
 N VALMDDF,VALMDN,VALMEVL,VALMHDR,VALMIOXY,VALMKEY,VALMLFT,VALMLST
 N VALMMENU,VALMPGE,VALMSGR,VALMUP,VALMWD
 ;
 ;protect Unwinder variables
 N ORU,ORUDA,ORUER,ORUFD,ORUFG,ORUSB,ORUSQ,ORUSV,ORUT,ORUW,ORUX
 N XQORM
 ;
 ; protect original Listman VALM DATA global
 K ^TMP($J,"DGPFVALM DATA")
 M ^TMP($J,"DGPFVALM DATA")=^TMP("VALM DATA",$J)
 ;
 D DISPPRF^DGPFUT1(DGDFN)
 ;
 ; restore original Listman VALM DATA global
 M ^TMP("VALM DATA",$J)=^TMP($J,"DGPFVALM DATA")
 ;
 K ^TMP($J,"DGPFVALM DATA")
 Q

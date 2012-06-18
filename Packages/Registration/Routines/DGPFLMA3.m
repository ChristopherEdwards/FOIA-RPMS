DGPFLMA3 ;ALB/KCL - PRF ASSIGNMENT LM PROTOCOL ACTIONS CONT. ; 4/24/03
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 ;no direct entry
 QUIT
 ;
EF ;Entry point for DGPF EDIT FLAG ASSIGNMENT action protocol.
 ;
 ;  Input: None
 ;
 ; Output:
 ;   VALMBCK - 'R' = refresh screen
 ;
 N DIC,DGWPROOT,DIWETXT,DIWESUB,DWLW,DWPK  ;input vars for EN^DIWE call
 N DGAROOT   ;assignment narrative word processing root
 N DGCROOT   ;assignment history comment word processing root
 N DGABORT   ;abort flag for entering assignment narrative
 N DGOK      ;ok flag for entering assignment narrative
 N DGCODE    ;action code
 N DGDFN     ;pointer to patient in PATIENT (#2) file
 N DGIEN     ;assignment ien
 N DGPFA     ;assignment array
 N DGPFAH    ;assignment history array
 N DGRDAT    ;review date
 N DGRESULT  ;result of STOALL api call
 N DGREASON  ;reason if unable to edit assignment
 N DGPFERR   ;if error returned from STOALL api call
 N SEL       ;user selection (list item)
 N VALMY     ;output of EN^VALM2 call, array of user selected entries
 ;
 ;set screen to full scroll region
 D FULL^VALM1
 ;
 ;security key check
 I '$D(^XUSEC("DGPF RECORD FLAG ASSIGNMENT",DUZ)) D  Q
 . W !!?2,">>> '"_$P($G(XQORNOD(0)),U,3)_"' action not allowed at this point.",*7
 . W !?6,"You do not have the appropriate Security Key."
 . D PAUSE^VALM1
 . S VALMBCK="R"
 ;
 ;is action selection allowed?
 I '$D(@VALMAR@("IDX")) D  Q
 . W !!?2,">>> '"_$P($G(XQORNOD(0)),U,3)_"' action not allowed at this point.",*7
 . I '$G(DGDFN) W !?6,"A patient has not been selected."
 . E  W !?6,"There are no record flag assignments for this patient."
 . D PAUSE^VALM1
 . S VALMBCK="R"
 ;
 ;allow user to select a SINGLE flag assignment for editing
 S (DGIEN,DGSELECT,VALMBCK)=""
 D EN^VALM2($G(XQORNOD(0)),"S")
 ;
 ;process user selection
 S SEL=$O(VALMY(""))
 I SEL,$D(@VALMAR@("IDX",SEL,SEL)) D
 . S DGIEN=$P($G(@VALMAR@("IDX",SEL,SEL)),U)
 . S DGDFN=$P($G(@VALMAR@("IDX",SEL,SEL)),U,2)
 . ;
 . ;-attempt to obtain lock on assignment record
 . I '$$LOCK^DGPFAA3(DGIEN) D  Q
 . . W !!,"Record flag assignment currently in use, can not be edited!"
 . . D PAUSE^VALM1
 . ;
 . ;-init word processing arrays 
 . S DGAROOT=$NA(^TMP($J,"DGPFNARR"))
 . S DGCROOT=$NA(^TMP($J,"DGPFCMNT"))
 . K @DGAROOT,@DGCROOT
 . ;
 . ;-get PRF assignment into DGPFA array
 . I '$$GETASGN^DGPFAA(DGIEN,.DGPFA) D  Q
 . . W !!,"Unable to retrieve the record flag assignment selected."
 . . D PAUSE^VALM1
 . ;
 . ;-is editing of assignment allowed?, quit if not allowed
 . K DGREASON
 . I '$$EDTOK^DGPFAA2(.DGPFA,"",.DGREASON) D  Q
 . . W !!,"Assignment can not be edited..."_$$LOW^XLFSTR($G(DGREASON))
 . . D PAUSE^VALM1
 . ;
 . ;-if assigment is active, set available action codes to 'Continue'
 . ;   and 'Inactivate', else set action code to 'Reactivate'
 . I +DGPFA("STATUS")=1 S DGCODE="S^C:Continue Assignment;I:Inactivate Assignment"
 . E  S DGCODE="S^R:Reactivate Assignment"
 . ;
 . ;-prompt user for assignment action, quit if no action selected
 . S DGPFAH("ACTION")=$$ANSWER^DGPFUT("Select an assignment action","",DGCODE)
 . Q:(DGPFAH("ACTION")=-1)
 . S DGPFAH("ACTION")=$S(DGPFAH("ACTION")="C":2,DGPFAH("ACTION")="I":3,DGPFAH("ACTION")="R":4)
 . ;
 . ;-if assignment action is 'Inactivate', set status to 'Inactive'
 . S DGPFA("STATUS")=$S(DGPFAH("ACTION")=3:0,1:1)
 . ;
 . ;-if action is not 'Inactivate', then prompt user to edit the narr
 . I (DGPFAH("ACTION")'=3),(($$ANSWER^DGPFUT("Would you like to edit the assignment narrative","YES","Y")>0)) D
 . . ;--allow user to edit the assignment narrative (required)
 . . S (DGABORT,DGOK)=0
 . . F  D  Q:(DGOK!DGABORT)
 . . . S DGROOT=$$GET1^DIQ(26.13,DGIEN,"1","Z",DGAROOT)
 . . . S DIC=$$OREF^DILF(DGAROOT)
 . . . S DIWETXT="Patient Record Flag - Assignment Narrative Text"
 . . . S DIWESUB="Assignment Narrative Text"
 . . . S DWLW=75 ;max # of chars allowed to be stored on WP global node
 . . . S DWPK=1  ;if line editor, don't join lines
 . . . D EN^DIWE
 . . . I $$CKWP^DGPFUT(DGAROOT) S DGOK=1 Q
 . . . W !,"Assignment Narrative Text is required!",*7
 . . . I '$$CONTINUE^DGPFUT() S DGABORT=1
 . . ;
 . ;-quit if required assignment narrative not entered
 . Q:$G(DGABORT)
 . ;
 . ;-if narrative edited, place new narrative into DGPFA array
 . I $G(DGOK) D
 . . K DGPFA("NARR")  ;remove old narrative text
 . . M DGPFA("NARR")=@DGAROOT K @DGAROOT
 . ;
 . ;-prompt user for 'Approved By' person, quit if not selected
 . S DGPFAH("APPRVBY")=$$ANSWER^DGPFUT("Approved By","","P^200:EMZ")
 . Q:(DGPFAH("APPRVBY")'>0)
 . ;
 . ;-have user enter the edit reason/history comments (required)
 . S (DGABORT,DGOK)=0
 . F  D  Q:(DGOK!DGABORT)
 . . W !!,"Enter the reason for editing this assignment:"  ;needed for line editor
 . . S DIC=$$OREF^DILF(DGCROOT)
 . . S DIWETXT="Patient Record Flag - Edit Reason Text"
 . . S DIWESUB="Edit Reason Text"
 . . S DWLW=75 ;max # of chars allowed to be stored on WP global node
 . . S DWPK=1  ;if line editor, don't join lines
 . . D EN^DIWE
 . . I $$CKWP^DGPFUT(DGCROOT) S DGOK=1 Q
 . . W !,"Edit Reason is required!",*7
 . . I '$$CONTINUE^DGPFUT() S DGABORT=1
 . ;
 . ;-quit if required edit reason/history comments not entered
 . Q:$G(DGABORT)
 . ;
 . ;-place comments into history array
 . M DGPFAH("COMMENT")=@DGCROOT K @DGCROOT
 . ;
 . ;-setup remaining assignment history nodes for filing
 . S DGPFAH("ASSIGNDT")=$$NOW^XLFDT()  ;current date/time
 . S DGPFAH("ENTERBY")=DUZ             ;current user
 . ;
 . ;-calculate the review date when Status is ACTIVE, otherwise null
 . S DGRDAT=$S(DGPFA("STATUS")=1:$$GETRDT^DGPFAA3($P(DGPFA("FLAG"),U),DGPFAH("ASSIGNDT")),1:0)
 . S DGPFA("REVIEWDT")=$S(DGRDAT>0:DGRDAT,1:"")
 . ;
 . Q:$$ANSWER^DGPFUT("Would you like to file the assignment changes","YES","Y")'>0
 . ;
 . ;-file the assignment and history using STOALL api
 . W !,"Updating the patient's record flag assignment..."
 . S DGRESULT=$$STOALL^DGPFAA(.DGPFA,.DGPFAH,.DGPFERR)
 . W !,"   >>> Assignment was "_$S(+$G(DGRESULT):"filed successfully.",1:"not filed successfully.")
 . ;
 . ;-- send HL7 message if editing assignment to a NATIONAL flag
 . I $G(DGRESULT),DGPFA("FLAG")["26.15",$$SNDORU^DGPFHLS(+DGRESULT) D
 . . W !,"   >>> HL7 message sent...updating patient's sites of record."
 . ;
 . D PAUSE^VALM1
 . ;
 . ;-re-build list of flag assignments for patient
 . D BLDLIST^DGPFLMU(DGDFN)
 . ;
 . ;-release lock after edit
 . D UNLOCK^DGPFAA3(DGIEN)
 ;
 ;return to LM (refresh screen)
 S VALMBCK="R"
 ;
 Q

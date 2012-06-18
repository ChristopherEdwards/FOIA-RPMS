DGPFLMA2 ;ALB/KCL - PRF ASSIGNMENT LM PROTOCOL ACTIONS CONT. ; 4/24/03 4:35pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 ;no direct entry
 QUIT
 ;
AF ;Entry point for DGPF ASSIGN FLAG action protocol.
 ;
 ;  Input:
 ;     DGDFN - pointer to patient in PATIENT (#2) file
 ;
 ; Output:
 ;   VALMBCK - 'R' = refresh screen
 ;
 N DIC,DGWPROOT,DIWETXT,DIWESUB,DWLW,DWPK  ;input vars for EN^DIWE call
 N DGABORT   ;abort flag for entering assignment narrative
 N DGOK      ;ok flag for entering assignment narrative
 N DGPFA     ;assignment array
 N DGPFAH    ;assignment history array
 N DGRDAT    ;results of review date calculation
 N DGRESULT  ;result of STOALL api call
 N DGREASON  ;reason if unable to add new assignment
 N DGPFERR   ;if error returned from STOALL api call
 ;
 ;set screen to full scrolling region
 D FULL^VALM1
 ;
 D  ;drop out of do block on failure
 . ;
 . ;-security key check
 . I '$D(^XUSEC("DGPF RECORD FLAG ASSIGNMENT",DUZ)) D  Q
 . . W !!?2,">>> '"_$P($G(XQORNOD(0)),U,3)_"' action not allowed at this point.",*7
 . . W !?6,"You do not have the appropriate Security Key."
 . . D PAUSE^VALM1
 . ;
 . ;-is action selection allowed?
 . I '$G(DGDFN) D  Q
 . . W !!?2,">>> '"_$P($G(XQORNOD(0)),U,3)_"' action not allowed at this point.",*7
 . . W !?6,"A patient has not been selected."
 . . D PAUSE^VALM1
 . ;
 . ;-init assignment and history arrays
 . K DGPFA,DGPFAH
 . ;
 . ;-get patient DFN into assignment array
 . S DGPFA("DFN")=$G(DGDFN)
 . Q:'DGPFA("DFN")
 . ;
 . ;-select flag for assignment, quit if not selected
 . S DGPFA("FLAG")=$$ANSWER^DGPFUT("Select a flag for this assignment","","26.13,.02")
 . Q:(DGPFA("FLAG")'>0)
 . ;
 . ;-check if ok to add new assignment
 . K DGREASON
 . I '$$ADDOK^DGPFAA2(DGPFA("DFN"),$P(DGPFA("FLAG"),U),.DGREASON) D  Q
 . . W !!,"Unable to add new assignment..."_$$LOW^XLFSTR($G(DGREASON))
 . . D PAUSE^VALM1
 . ;
 . ;-if local flag assignment, owner site = current site
 . ;-else if nat'l flag assignment, prompt for owner site
 . I DGPFA("FLAG")["26.11" S DGPFA("OWNER")=$P($$SITE^VASITE,U)
 . E  S DGPFA("OWNER")=$$ANSWER^DGPFUT("Enter Owner Site",$P($$SITE^VASITE,U,2),"P^4:EMZ")
 . Q:(DGPFA("OWNER")'>0)
 . ;
 . ;-prompt user for approved by person, quit if not selected
 . S DGPFAH("APPRVBY")=$$ANSWER^DGPFUT("Approved By","","P^200:EMZ")
 . Q:(DGPFAH("APPRVBY")'>0)
 . ;
 . ;-have user enter assignment narrative text (required)
 . S (DGABORT,DGOK)=0
 . S DGWPROOT=$NA(^TMP($J,"DGPFNARR"))
 . K @DGWPROOT
 . F  D  Q:(DGOK!DGABORT)
 . . W !!,"Enter Narrative Text for this record flag assignment:" ;needed for line editor
 . . S DIC=$$OREF^DILF(DGWPROOT)
 . . S DIWETXT="Patient Record Flag - Assignment Narrative Text"
 . . S DIWESUB="Assignment Narrative Text"
 . . S DWLW=75 ;max # of chars allowed to be stored on WP global node
 . . S DWPK=1  ;if line editor, don't join lines
 . . D EN^DIWE
 . . I $$CKWP^DGPFUT(DGWPROOT) S DGOK=1 Q
 . . W !,"Assignment Narrative Text is required!",*7
 . . I '$$CONTINUE^DGPFUT() S DGABORT=1
 . . ;
 . ;-quit if required assignment narrative not entered
 . Q:$G(DGABORT)
 . ;
 . ;-place assignment narrative text into assignment array
 . M DGPFA("NARR")=@DGWPROOT K @DGWPROOT
 . ;
 . ;-setup remaining assignment and history array nodes for filing
 . S DGPFA("STATUS")=1  ;active
 . S DGPFA("ORIGSITE")=$P($$SITE^VASITE(),U)  ;current site
 . S DGPFAH("ASSIGNDT")=$$NOW^XLFDT()  ;current date/time
 . S DGPFAH("ACTION")=1  ;new assignment
 . S DGPFAH("ENTERBY")=DUZ  ;current user
 . S DGPFAH("COMMENT",1,0)="New record flag assignment."
 . ;
 . ;calculate the Review date, null if no date
 . S DGRDAT=$$GETRDT^DGPFAA3($P(DGPFA("FLAG"),U),DGPFAH("ASSIGNDT"))
 . S DGPFA("REVIEWDT")=$S(DGRDAT>0:DGRDAT,1:"")
 . ;
 . Q:$$ANSWER^DGPFUT("Would you like to file this new record flag assignment","YES","Y")'>0
 . ;
 . ;-file the assignment and history using STOALL api
 . W !,"Filing the patient's new record flag assignment..."
 . S DGRESULT=$$STOALL^DGPFAA(.DGPFA,.DGPFAH,.DGPFERR)
 . W !,"   >>> Assignment was "_$S(+$G(DGRESULT):"filed successfully.",1:"not filed successfully.")
 . ;
 . ;-- send HL7 message if adding an assignment to a NATIONAL flag
 . I $G(DGRESULT),DGPFA("FLAG")["26.15",$$SNDORU^DGPFHLS(+DGRESULT) D
 . . W !,"   >>> HL7 message sent...updating patient's sites of record."
 . ;
 . D PAUSE^VALM1
 . ;
 . ;-re-build list of flag assignments for patient
 . D BLDLIST^DGPFLMU(DGDFN)
 ;
 ;return to LM (refresh screen)
 S VALMBCK="R"
 ;
 Q

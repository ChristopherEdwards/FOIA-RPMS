DGPFLMA4 ;ALB/KCL - PRF ASSIGNMENT LM PROTOCOL ACTIONS CONT. ; 4/24/03 4:43pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 ;no direct entry
 QUIT
 ;
 ;
CO ;Entry point for DGPF CHANGE ASSIGNMENT OWNERSHIP action protocol.
 ;
 ;  Input: None
 ;
 ; Output:
 ;   VALMBCK - 'R' = refresh screen
 ;
 N DIC,DGWPROOT,DIWETXT,DIWESUB,DWLW,DDWC,DWPK  ;input vars for EN^DIWE 
 N DGCROOT  ;assignment history comment word processing root
 N DGABORT  ;abort flag for entering assignment narrative
 N DGOK     ;ok flag for entering assignment narrative
 N DGIEN    ;assignment ien
 N DGPFA    ;assignment array
 N DGPFAH   ;assignment history array
 N DGRESULT ;result of STOALL api call
 N DGREASON ;reason if unable to edit assignment
 N DGPFERR  ;if error returned from STOALL api call
 N SEL      ;user selection (list item)
 N VALMY    ;output of EN^VALM2 call, array of user selected entries
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
 ;allow user to select a SINGLE flag assignment for ownership change
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
 . . W !!,"Record flag assignment currently in use, can not be edited!",*7
 . . D PAUSE^VALM1
 . ;
 . ;-get assignment into DGPFA array
 . I '$$GETASGN^DGPFAA(DGIEN,.DGPFA) D  Q
 . . W !!,"Unable to retrieve the record flag assignment selected.",*7
 . . D PAUSE^VALM1
 . ;
 . ;-can site change ownership of the assignment?
 . I '$$CHGOWN^DGPFAA2(.DGPFA,,.DGREASON) D  Q
 . . W !!,"Changing the ownership of this record flag assignment not allowed.",*7
 . . W !,"  >>> "_$G(DGREASON)_"."
 . . D PAUSE^VALM1
 . ;
 . ;-prompt for new OWNER SITE of the assignment
 . S DGPFA("OWNER")=$$ANSWER^DGPFUT("Select new owner site for this record flag assignment","","P^4:EMZ")
 . I DGPFA("OWNER")=+$$SITE^VASITE D
 . . W !!,"Ownership of this record flag assignment has not been changed!",*7
 . . S DGPFA("OWNER")=0
 . . D PAUSE^VALM1
 . Q:(DGPFA("OWNER")'>0)
 . ;
 . ;-prompt for APPROVED BY person
 . S DGPFAH("APPRVBY")=$$ANSWER^DGPFUT("Approved By","","P^200:EMZ")
 . Q:(DGPFAH("APPRVBY")'>0)
 . ;
 . ;-allow user to enter HISTORY COMMENTS (edit reason)
 . S DGCROOT=$NA(^TMP($J,"DGPFCMNT"))  ;init WP array for hist comments
 . K @DGCROOT
 . S (DGABORT,DGOK)=0
 . F  D  Q:(DGOK!DGABORT)
 . . W !!,"Enter the reason for editing this assignment:"  ;needed for line editor
 . . S @DGCROOT@(1,0)="Change of flag assignment ownership.  "
 . . S DIC=$$OREF^DILF(DGCROOT)
 . . S DIWETXT="Enter the reason for record flag assignment ownership change:"
 . . ;S DIWETXT="Enter Record Flag Assignment - Edit Reason Text"
 . . S DIWESUB="Change of Ownership Reason"
 . . S DWLW=75   ;max # of chars allowed to be stored on WP global node
 . . S DWPK=1    ;if line editor, don't join lines
 . . S DDWC="E"  ;initially place cursor at end of line 1
 . . D EN^DIWE
 . . I $$CKWP^DGPFUT(DGCROOT) S DGOK=1 Q
 . . W !,"The reason for editing this record flag assignment is required!",*7
 . . I '$$CONTINUE^DGPFUT() S DGABORT=1
 . ;
 . ;-quit if required HISTORY COMMENTS not entered
 . Q:$G(DGABORT)
 . ;
 . ;-place HISTORY COMMENTS into history array
 . M DGPFAH("COMMENT")=@DGCROOT K @DGCROOT
 . ;
 . ;-setup remaining assignment history array nodes for filing
 . S DGPFAH("ACTION")=2                ;continue
 . S DGPFAH("ASSIGNDT")=$$NOW^XLFDT()  ;current date/time
 . S DGPFAH("ENTERBY")=DUZ             ;current user
 . ;
 . ;-relinquishing ownership should remove existing review date
 . S DGPFA("REVIEWDT")=""
 . ;
 . ;-ask user if ok to file ownership change 
 . Q:$$ANSWER^DGPFUT("Would you like to file the assignment ownership change","YES","Y")'>0
 . ;
 . ;-file the assignment and history using STOALL api
 . W !!,"Updating the ownership of this patient's record flag assignment..."
 . S DGRESULT=$$STOALL^DGPFAA(.DGPFA,.DGPFAH,.DGPFERR)
 . W !,"   >>> Update was "_$S(+$G(DGRESULT):"successful",1:"not successful")_"."
 . ;
 . ;-- send HL7 ORU msg if editing assignment to a Cat I (NATIONAL) flag
 . I +$G(DGRESULT),$$SNDORU^DGPFHLS(+DGRESULT) D
 . . W !,"   >>> HL7 message sent...updating patient's sites of record."
 . ;
 . D PAUSE^VALM1
 . ;
 . ;-rebuild list of flag assignments for patient
 . D BLDLIST^DGPFLMU(DGDFN)
 . ;
 . ;-release lock after CO edit
 . D UNLOCK^DGPFAA3(DGIEN)
 ;
 ;return to LM (refresh screen)
 S VALMBCK="R"
 ;
 Q

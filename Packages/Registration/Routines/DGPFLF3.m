DGPFLF3 ;ALB/RBS - PRF FLAG MANAGEMENT LM PROTOCOL ACTIONS CONT. ; 7/31/03 3:03pm
 ;;5.3;Registration;**425**;Aug 13, 1993 
 ;
 ;no direct entry
 QUIT
 ;
 ;
AF ;Entry point for DGPF ADD FLAG action protocol.
 ;
 ;  Input: DGCAT - flag category (1=National, 2=Local)
 ;
 ; Output: New File entry in PRF LOCAL FLAG FILE (#26.11)
 ;         New File entry in PRF LOCAL FLAG HISTORY FILE (#26.12)
 ;         Set variable VALMBCK to 'R' = refresh screen
 ;
 N DIC,DGWPROOT,DIWETXT,DIWESUB,DWLW,DWPK ;input vars for EN^DIWE call
 N DGASK    ;return value from call to ^DIR - $$ANSWER^DGPFUT call
 N DGCKWP   ;check if word-processing is OK
 N DGPFLF   ;array containing flag record field values
 N DGPFLH   ;array containing flag history record field values
 N DGABORT  ;abort flag
 N DGRESULT ;result of $$STOALL^DGPFALF1 api call
 N DGRDAY   ;review frequency var
 N DGNDAY   ;notification days var
 N DGERR    ;if error returned from $$STOALL^DGPFALF1 api call
 N DGOK     ;ok flag to enter record flag entry & flag description
 N DGMSG    ;user message
 N DGCNT,DGLINE,DGQ  ;counters and quit flag
 ;
 S DGOK=1,(DGCNT,DGLINE,DGQ,DGABORT)=0
 S DGMSG="W !?2,"">>> '""_$P($G(XQORNOD(0)),U,3)_""' action not allowed for Category II (Local) Flags."",*7"
 ;
 ;set screen to full scrolling region
 D FULL^VALM1
 W !
 ;check of Category var - Only Local Flags can be created
 I DGCAT=1 D
 . W !?2,">>> '",$P($G(XQORNOD(0)),U,3),"' action not allowed for Category I (National) Flags.",*7
 . W !?7,"Only Category II (Local) Flags may be created at the local site.",*7
 . S DGOK=0
 . D PAUSE^VALM1
 ;
 ;check of security key
 I DGOK,'$D(^XUSEC("DGPF LOCAL FLAG EDIT",DUZ)) D
 . X DGMSG
 . W !?7,"You do not have the appropriate Security Key.",*7
 . S DGOK=0
 . D PAUSE^VALM1
 ;
 ;user prompts
 D:DGOK
 . ;-- init flag record and history arrays
 . ;   The DGPFLF array will contain 2 "^" pieces (internal^external)
 . ;   for a final full screen display before filing.
 . K DGPFLF,DGPFLH
 . ;
 . ;-- prompt for flag name, quit if one not entered
 . S DGASK=$$ANSWER^DGPFUT("Enter the Record Flag Name","","26.11,.01^^I $D(^DGPF(26.11,""B"",X)) K X W "" *** Flag name already on file""")
 . I DGASK=-1!(DGASK=0) S DGABORT=1 Q
 . S DGPFLF("FLAG")=DGASK_U_DGASK
 . ;
 . ;-- prompt for status of the flag, quit if one not entered
 . S DGASK=$$ANSWER^DGPFUT("Enter the Status of the Flag","ACTIVE","26.11,.02")
 . I DGASK<0 S DGABORT=1 Q
 . S DGPFLF("STAT")=DGASK_U_$$EXTERNAL^DILFD(26.11,.02,"F",DGASK)
 . ;
 . ;-- prompt for flag type, quit if one not entered
 . S DGASK=$$ANSWER^DGPFUT("Enter the Type of the Flag","","26.11,.03")
 . I DGASK'>0 S DGABORT=1 Q
 . S DGPFLF("TYPE")=DGASK_U_$$EXTERNAL^DILFD(26.11,.03,"F",DGASK)
 . ;
 . ;-- prompt for principal investigator(s) name for RESEARCH flag type 
 . I +DGPFLF("TYPE")=2,'$$PRININV^DGPFLF6(0,.DGPFLF) D  Q:DGABORT
 . . I $$ANSWER^DGPFUT("Enter RETURN to continue or '^' to exit","","E")=-1 S DGABORT=1
 . ;
 . ;-- prompt for review frequency, quit if user aborts
 . S DGASK=$$ANSWER^DGPFUT("Enter the Review Frequency Days","","26.11,.04^^K:$L(X)>4!(X[""."") X")
 . I DGASK<0 S DGABORT=1 Q
 . S DGPFLF("REVFREQ")=DGASK_U_DGASK
 . S DGRDAY=DGASK
 . I DGASK=0 D
 . . ;-- if review frequency=0, don't ask notification/review group
 . . ;   reset both fields
 . . S DGPFLF("NOTIDAYS")=0_U_0
 . . S DGPFLF("REVGRP")=""_U_""
 . . ;
 . E  D  Q:DGABORT    ;continue to prompt user and check abort logic
 . . ;
 . . ;-- prompt for notification days
 . . S DGASK=$$ANSWER^DGPFUT("Enter the Notification Days","","26.11,.05^^K:$L(X)>4!(X[""."")!(X>DGRDAY) X")
 . . I DGASK<0 S DGABORT=1 Q
 . . S DGPFLF("NOTIDAYS")=DGASK_U_DGASK
 . . ;
 . . S DGQ=0
 . . F  D  Q:(DGQ!DGABORT)
 . . . ;-- prompt for review mail group name, optional entry
 . . . S DGASK=$$ANSWER^DGPFUT("Enter the Review Mail Group","","26.11,.06")
 . . . I DGASK<0 S DGABORT=1 Q
 . . . I DGASK'>0 D  Q
 . . . . W !,"   >>> You've entered the Review Frequency and Notification Days,"
 . . . . W !,"       now enter a Review Mail Group or abort this process.",*7
 . . . . I '$$CONTINUE^DGPFUT() S DGABORT=1
 . . . ;
 . . . S DGPFLF("REVGRP")=DGASK_U_$$EXTERNAL^DILFD(26.11,.06,"F",DGASK)
 . . . S DGQ=1  ;set entry, quit
 . ;
 . ;-- have user enter flag description text (required)
 . S DGCKWP=0
 . S DGWPROOT=$NA(^TMP($J,"DGPFDESC"))
 . K @DGWPROOT
 . F  D  Q:(DGCKWP!DGABORT)
 . . W !,"Enter the description for this new record flag:"  ;needed for line editor
 . . S DIC=$$OREF^DILF(DGWPROOT)
 . . S DIWETXT="Patient Record Flag - Flag Description Text"
 . . S DIWESUB="Flag Description Text"
 . . S DWLW=75 ;max # of chars allowed to be stored on WP global node
 . . S DWPK=1  ;if line editor, don't join line
 . . D EN^DIWE
 . . I $$CKWP^DGPFUT(DGWPROOT) S DGCKWP=1 Q
 . . W !,"Flag Description Text is required!",!,*7
 . . I '$$CONTINUE^DGPFUT() S DGABORT=1
 . ;
 . ;-- quit if required flag description not entered
 . Q:DGABORT
 . ;
 . ;-- place flag description text into assignment array
 . M DGPFLF("DESC")=@DGWPROOT K @DGWPROOT
 . ;
 . ;-- re-display user's answers on full screen
 . S (DGLINE,DGCNT)=0
 . S DGPFLF("PTR")="26.11"
 . K ^TMP("DGPFDISP",$J)
 . ;
 . D FLAGDET^DGPFLFD1("DGPFDISP",.DGPFLF,.DGLINE,.DGCNT)
 . ;
 . W:$E(IOST,1,2)="C-" @IOF
 . S (DGCNT,DGQ)=0
 . F  S DGCNT=$O(^TMP("DGPFDISP",$J,DGCNT)) Q:DGCNT=""  D  Q:DGQ
 . . I $Y+3>IOSL W *7,!,"<...There is more Description to display but we need to file this now...>" S DGQ=1 Q
 . . W:^TMP("DGPFDISP",$J,DGCNT,0)]"" !,^TMP("DGPFDISP",$J,DGCNT,0)
 . ;
 . K DGPFLF("PTR")        ;clean up
 . K ^TMP("DGPFDISP",$J)  ;clean up
 . ;
 . W !,*7
 . I $$ANSWER^DGPFUT("Would you like to file this new local record flag","YES","Y")'>0 S DGABORT=1 Q
 . ;
 . W !,"Filing the new local record flag..."
 . ;
 . ;-- setup remaining flag history array nodes for filing
 . ;   note, the DGPFLH("FLAG") will be setup in $$STOALL^DGPFALF1
 . S DGPFLH("ENTERDT")=$$NOW^XLFDT()   ;current date/time
 . S DGPFLH("ENTERBY")=DUZ             ;current user
 . S DGPFLH("REASON",1,0)="New Local Patient Record Flag entered."
 . ;
 . ;-- file both the (#26.11) & (#26.12) entries
 . S DGRESULT=$$STOALL^DGPFALF1(.DGPFLF,.DGPFLH,.DGERR)
 . ;
 . W !!,"   >>> Local record flag was "_$S(+DGRESULT:"filed successfully.",1:"not filed successfully."),*7
 . ;
 . D PAUSE^VALM1
 ;
 I DGABORT D
 . W !,"   >>> The '"_$P($G(XQORNOD(0)),U,3)_"' action is aborting, nothing has been filed.",*7
 . I $$ANSWER^DGPFUT("Enter RETURN to continue","","E")  ;pause
 ;
 ;re-build list of local record flags
 D BLD^DGPFLF
 ;
 ;return to LM (refresh screen)
 S VALMBCK="R"
 Q
 ;

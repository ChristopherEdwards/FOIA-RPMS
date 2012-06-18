BDGSPT3 ; IHS/OIT/LJF - DISPLAY USER'S REESTRICTION TO A SPECIFIC PATIENT
 ;;5.3;PIMS;**1008,1009**;MAY 28, 2004
 ;IHS/OIT/LJF 08/23/2007 ROUTINE ADDED with Patch 1008
 ;
EN ;EP; -- main entry point for BDG SECURITY VIEW RESTRICTIONS
 ; assumes DFN and BDGSUR already set
 ; called by ^BDGSPT2 for view action
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SECURITY VIEW RESTRICTIONS")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 NEW X
 S X=$$GET1^DIQ(200,+$G(BDGUSR),.01)
 S VALMHDR(1)=$$PAD("User:",12)_X_$$SP(7)_$$GET1^DIQ(200,+$G(BDGUSR),8)
 S VALMHDR(2)=$$SP(12)_"Last Signed on "_$$GET1^DIQ(200,+$G(BDGUSR),202)
 S VALMHDR(3)=""
 S VALMHDR(4)=$$PAD("Patient:",12)_$$GET1^DIQ(2,DFN,.01)_"  ("_$$STATUS^BDGSPT2(BDGUSR,DFN,2)_")"
 Q
 ;
INIT ;EP; -- init variables and list array
 S VALMCNT=0 K ^TMP("BDGSPT3",$J)
 ;
 NEW DTSTAMP,LINE,IENS,LIFT,USER,RESUME
 ; display when patient record was first restricted
 S LINE=" "_$$GET1^DIQ(9009018.11,DFN_","_BDGUSR,.02)
 S LINE=$$PAD(LINE,66)_$$GET1^DIQ(9009018.11,DFN_","_BDGUSR,.03)    ;user who added it
 D SET(LINE,.VALMCNT)
 ;
 ; find all activity on this record & add to display array
 S DTSTAMP=0 F  S DTSTAMP=$O(^BDGSPT(BDGUSR,1,DFN,1,DTSTAMP)) Q:'DTSTAMP  D
 . S IENS=DTSTAMP_","_DFN_","_BDGUSR
 . S LIFT=$$GET1^DIQ(9009018.111,IENS,.03)    ;date restriction lifted
 . S USER=$$GET1^DIQ(9009018.111,IENS,.02)    ;user
 . S USER2=$$GET1^DIQ(9009018.111,IENS,.08)   ;user who last edited
 . S LINE=$$PAD($$SP(24)_LIFT,47)
 . S LINE=$$PAD(LINE,66)_$S(USER2]"":USER2,1:USER)
 . D SET(LINE,.VALMCNT)
 . ;
 . S RESUME=$$GET1^DIQ(9009018.111,IENS,.04)   ;date restriction resumes
 . I RESUME]"" D
 . . S USER=$$GET1^DIQ(9009018.111,IENS,.06)   ;user
 . . S LINE=$$SP(47)_RESUME
 . . S LINE=$$PAD(LINE,66)_USER
 . . D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGSPT3",$J)) S VALMCNT=1,^TMP("BDGSPT3",$J,1,0)=$$SP(15)_"NO INFORMATION FOUND"
 Q
 ;
SET(LINE,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGSPT3",$J,NUM,0)=LINE
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BDGSPT3",$J)
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)

BDGSECL ; IHS/ANMC/LJF - LIST SENSITIVE PATIENTS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SECURITY LIST
 NEW VALMCNT
 D TERM^VALM0
 D EN^VALM("BDG SECURITY LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X="Patients stored in DG SECURITY LOG file as of "_$$FMTE^XLFDT(DT)
 S VALMHDR(1)=$$SP(10)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW DGN,NAME,STATUS,DATA,LINE,DGNUM
 K ^TMP("BDGSECL",$J),^TMP("BDGSECL1",$J)
 S VALMCNT=0
 ;
 ; find all entries and sort by status and then by name
 S (DGN,DGNUM)=0
 F  S DGN=$O(^DGSL(38.1,DGN)) Q:'DGN  D
 . S NAME=$$GET1^DIQ(38.1,DGN,.01),STATUS=$$GET1^DIQ(38.1,DGN,2)
 . Q:STATUS'="SENSITIVE"
 . ; assigned by (initials)
 . S X=$$GET1^DIQ(200,+$$GET1^DIQ(38.1,DGN,3,"I"),1)
 . ; date assigned status
 . S Y=$$FMTE^XLFDT($$GET1^DIQ(38.1,DGN,4,"I"))
 . S ^TMP("BDGSECL1",$J,NAME,DGN)=X_U_Y
 ;
 ; if file is empty, set message and quit
 I '$D(^TMP("BDGSECL1",$J)) D SET("No PATIENTS currently or previously defined as SENSITIVE",0,.VALMCNT,0) Q
 ;
 ; otherwise, set display lines per sorts
 S NAME=0 F  S NAME=$O(^TMP("BDGSECL1",$J,NAME)) Q:NAME=""  D
 . S DGN=0 F  S DGN=$O(^TMP("BDGSECL1",$J,NAME,DGN)) Q:'DGN  D
 .. S DATA=^TMP("BDGSECL1",$J,NAME,DGN)
 .. ; create display line
 .. S DGNUM=DGNUM+1                        ;entry # on display screen
 .. S LINE=$J(DGNUM,3)_". "_$E(NAME,1,20)                ;#. pat name
 .. S LINE=$$PAD(LINE,28)_$P(DATA,U,2)                   ;date
 .. S LINE=$$PAD(LINE,50)_$P(DATA,U)                     ;assigned by 
 .. D SET(LINE,DGN,.VALMCNT,.DGNUM)   ;add display line to list global
 ;
 K ^TMP("BDGSECL1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K VALMCNT,^TMP("BDGSECL",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
DISPLAY ;EP; -- called by protocol to display access records for patient
 D FULL^VALM1
 I '$D(^XUSEC("DG SECURITY OFFICER",DUZ)) W !!?3,*7,"You do not have the appropriate access privileges to display user access." D PAUSE^BDGF,RESET2 Q
 NEW BDGI
 S BDGI=$$GETITEM^BDGFL("BDGSECL","OS")       ;choose entry to display
 I 'BDGI D RESET2 Q                           ;or go back
 S DFN=$$GET1^DIQ(38.1,+BDGI,.01,"I")         ;set variable for call
 D DTRNG^DGSEC2 I DGPOP D Q^DGSEC2,RESET2 Q  ;ask date range
 D ASKUSR^DGSEC2,RESET2                      ;rest of code for report
 Q
 ;
EDIT ;EP; -- called by protocol to edit sensitivity level
 D FULL^VALM1
 I '$D(^XUSEC("DG SENSITIVITY",DUZ)) W !!?3,$C(7),"You do not have the appropriate access privileges to assign security." D PAUSE^BDGF,RESET2 Q
 NEW BDGI
 S BDGI=$$GETITEM^BDGFL("BDGSECL","OS")       ;choose entry to edit
 I 'BDGI D RESET2 Q                           ;or go back
 S DA=+BDGI,BDGSECL=1  ;calling rtn needs DA set, BDGSECL helps exit
 D IHS^DGSEC1,RESET                 ;call 1^DGSEC1 after patient lookup
 Q
 ;
SET(DATA,IEN,LINE,NUM) ; -- create ^tmp global for list template
 S LINE=LINE+1
 S ^TMP("BDGSECL",$J,LINE,0)=DATA
 S ^TMP("BDGSECL",$J,"IDX",LINE,NUM)=IEN
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
RESET ; -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR
 Q
 ;
RESET2 ; -- return to list manager; don't update list
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 Q

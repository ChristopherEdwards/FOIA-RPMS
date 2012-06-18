BDGSYS1 ; IHS/ANMC/LJF - HOSPITAL SERVICE SETUP ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SYS SERVICE SETUP
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SYS SERVICE SETUP")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X=$$GET1^DIQ(40.8,BDGDIV,.01)
 S VALMHDR(1)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 D MSG^BDGF("Please wait while I compile this list...",1,0)
 NEW NAME,IEN,COUNT,LINE,Y
 S VALMCNT=0
 K ^TMP("BDGSYS1",$J)
 S NAME=0
 F  S NAME=$O(^DIC(49,"B",NAME)) Q:NAME=""  D
 . S IEN=0
 . F  S IEN=$O(^DIC(49,"B",NAME,IEN)) Q:'IEN  D
 .. S COUNT=$G(COUNT)+1
 .. S LINE=$J(COUNT,2)_". "_$$GET1^DIQ(49,IEN,.01)      ;service name
 .. S LINE=$$PAD(LINE,32)_$$GET1^DIQ(49,IEN,1)         ;abbreviation
 .. S LINE=$$PAD(LINE,40)_$$GET1^DIQ(49,IEN,1.5)       ;mail symbol
 .. ;
 .. ; check if closed
 .. S X=$O(^DIC(49,IEN,3,""),-1) I X,(X'>DT) D
 ... I $P($G(^DIC(49,IEN,3,X,0)),U,2)="" S LINE=$$PAD(LINE,55)_"Closed on "_$$FMTE^XLFDT(X)
 .. ;
 .. ; else display type (clinical vs. administrative)
 .. I $L(LINE)<55 S LINE=$$PAD(LINE,55)_$$GET1^DIQ(49,IEN,1.7)
 .. ;
 .. D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 I '$D(^TMP("BDGSYS1",$J)) D
 . D SET("*** NO ENTRIES FOUND ***",0,0,.VALMCNT)
 Q
 ;
SET(DATA,NUM,N,LINE) ; put display line into array
 S LINE=LINE+1
 S ^TMP("BDGSYS1",$J,LINE,0)=DATA
 S ^TMP("BDGSYS1",$J,"IDX",LINE,NUM)=N
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSYS1",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
RESET ; -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR
 Q
 ;
EDIT ;EP; called by Edit Entry protocol
 NEW X,Y,Z,BDGN,DDSFILE,DA,DR
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGSYS1",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGSYS1",$J,"IDX",Y,0))
 .. Q:^TMP("BDGSYS1",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGSYS1",$J,"IDX",Y,Z)
 ;
 I 'BDGN D RESET Q
 S DDSFILE=49,DA=BDGN,DR="[BDG 49 SETUP]" D ^DDS
 D RESET
 Q
 ;
ADD ;EP; called by Add Entry protocol
 NEW DIC,DLAYGO,Y,DDSFILE,DA,DR
 D FULL^VALM1
 S (DIC,DLAYGO)=49,DIC(0)="AEMQZL" D ^DIC I Y<1 D RESET Q
 S DDSFILE=49,DA=+Y,DR="[BDG 49 SETUP]" D ^DDS
 D RESET
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)

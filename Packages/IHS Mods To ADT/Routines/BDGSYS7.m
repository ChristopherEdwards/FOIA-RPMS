BDGSYS7 ; IHS/ANMC/LJF - TRANSFER FACILITY SETUP ;  [ 07/31/2003  1:14 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SYS TRANSFER FAC
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SYS TRANSFER FAC")
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
 NEW NAME,IEN,COUNT,LINE,Y
 S VALMCNT=0
 K ^TMP("BDGSYS7",$J)
 S NAME=0
 F  S NAME=$O(^AUTTTFAC("B",NAME)) Q:NAME=""  D
 . S IEN=0
 . F  S IEN=$O(^AUTTTFAC("B",NAME,IEN)) Q:'IEN  D
 .. S COUNT=$G(COUNT)+1
 .. S LINE=$J(COUNT,2)_". "_$$GET1^DIQ(9999999.91,IEN,.01)  ;serv name
 .. S LINE=$$PAD(LINE,40)_$$GET1^DIQ(9999999.91,IEN,.02)   ;inactive dt
 .. S LINE=$$PAD(LINE,59)_$$GET1^DIQ(9999999.91,IEN,.03)   ;IHS link
 .. D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 I '$D(^TMP("BDGSYS7",$J)) D
 . D SET("*** NO ENTRIES FOUND ***",0,0,.VALMCNT)
 Q
 ;
SET(DATA,NUM,N,LINE) ; put display line into array
 S LINE=LINE+1
 S ^TMP("BDGSYS7",$J,LINE,0)=DATA
 S ^TMP("BDGSYS7",$J,"IDX",LINE,NUM)=N
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSYS7",$J)
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
 . S Y=0 F  S Y=$O(^TMP("BDGSYS7",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGSYS7",$J,"IDX",Y,0))
 .. Q:^TMP("BDGSYS7",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGSYS7",$J,"IDX",Y,Z)
 ;
 I 'BDGN D RESET Q
 S DIE=9999999.91,DR=".01:.03",DA=BDGN D ^DIE
 D RESET
 Q
 ;
ADD ;EP; called by Add Entry protocol
 NEW DIC,DLAYGO,Y,DDSFILE,DA,DR
 D FULL^VALM1
 S (DIC,DLAYGO)=9999999.91,DIC(0)="AEMQZL" D ^DIC I Y<1 D RESET Q
 ;IHS/ITSC/WAR 7/31/03 BDGN is undefined coming from protocal ien 1519
 I '$DATA(BDGN) S BDGN=+Y    ;Need to look at this more in the future
 S DIE=9999999.91,DR=".01:.03",DA=BDGN D ^DIE
 D RESET
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)

BDGSYS4 ; IHS/ANMC/LJF - ROOM-BED SETUP ;  
 ;;5.3;PIMS;**1007,1009**;FEB 27, 2007
 ;
 ;cmi/anch/maw added INITW to show ward on pick list PATCH 1007 item 1007.44
 ;
EN ; -- main entry point for BDG SYS ROOM SETUP
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SYS ROOM SETUP")
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
 D INITW Q  ;cmi/anch/maw 2/22/2007 added for sort by ward
 ;cmi/anch/maw 2/22/2007 below is orig code, replaced with INITW PATCH 1007 item 1007.44
 D MSG^BDGF("Please wait while I compile the list...",1,0)
 NEW IEN,NAME,COUNT,LINE,INA
 S VALMCNT=0
 K ^TMP("BDGSYS4",$J),^TMP("BDGSYS41",$J)
 ;
 ; sort rooms by active/inactive then name
 S NAME=0 F  S NAME=$O(^DG(405.4,"B",NAME)) Q:NAME=""  D
 . S IEN=0 F  S IEN=$O(^DG(405.4,"B",NAME,IEN)) Q:'IEN  D
 .. S ^TMP("BDGSYS41",$J,$$GET1^DIQ(405.4,IEN,.2),NAME,IEN)=""
 ;
 ; take sorted list and put into display array
 ;    sorted by active/inactive then name
 S INA="" F  S INA=$O(^TMP("BDGSYS41",$J,INA)) Q:INA=""  D
 . ;
 . I INA=1 D SET("",+$G(COUNT),0,.VALMCNT)  ;skip line before inactives
 . ;
 . S NAME=0 F  S NAME=$O(^TMP("BDGSYS41",$J,INA,NAME)) Q:NAME=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGSYS41",$J,INA,NAME,IEN)) Q:'IEN  D
 ... ;
 ... S COUNT=$G(COUNT)+1
 ... S LINE=$J(COUNT,2)_". "_NAME                         ;rooomname
 ... S LINE=$$PAD(LINE,20)_$$GET1^DIQ(405.4,IEN,.02)      ;description
 ... S LINE=$$PAD(LINE,55)_$$GET1^DIQ(405.4,IEN,9999999.01)  ;phone
 ... ;
 ... I $$GET1^DIQ(405.4,IEN,.2)=1 S LINE=$$PAD(LINE,68)_"*INACTIVE*"
 ... D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 I '$D(^TMP("BDGSYS4",$J)) D
 . D SET("*** NO ENTRIES FOUND ***",0,0,.VALMCNT)
 Q
 ;
INITW ; -- init variables and list array
 ;cmi/anch/maw 2/22/2007 modified code to show ward on list PATCH 1007 item 1007.44
 D MSG^BDGF("Please wait while I compile the list...",1,0)
 NEW IEN,NAME,COUNT,LINE,INA,OEN
 S VALMCNT=0
 K ^TMP("BDGSYS4",$J),^TMP("BDGSYS41",$J)
 ;
 ; sort rooms by active/inactive then name
 S WD=0 F  S WD=$O(^DG(405.4,"W",WD)) Q:'WD  D
 . S NAME=0 F  S NAME=$O(^DG(405.4,"W",WD,NAME)) Q:NAME=""  D
 .. S IEN=0 F  S IEN=$O(^DG(405.4,"W",WD,NAME,IEN)) Q:'IEN  D
 ... ;S ^TMP("BDGSYS41",$J,$$GET1^DIQ(405.4,IEN,.2),WD,NAME,IEN)=""  ;cmi/maw 8/19/2008 orig line patch 1009
 ... S ^TMP("BDGSYS41",$J,$$GET1^DIQ(405.4,NAME,.2),WD,NAME,IEN)=""  ;cmi/maw 8/19/2008 patch 1009 mod line per mitch wright
 ;
 ; take sorted list and put into display array
 ;    sorted by active/inactive then name
 S INA="" F  S INA=$O(^TMP("BDGSYS41",$J,INA)) Q:INA=""  D
 . ;
 . I INA=1 D SET("",+$G(COUNT),0,.VALMCNT)  ;skip line before inactives
 . ;
 . S NAME=0 F  S NAME=$O(^TMP("BDGSYS41",$J,INA,NAME)) Q:NAME=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGSYS41",$J,INA,NAME,IEN)) Q:'IEN  D
 ... S OEN=0 F  S OEN=$O(^TMP("BDGSYS41",$J,INA,NAME,IEN,OEN)) Q:'OEN  D
 .... ;
 .... S COUNT=$G(COUNT)+1
 .... S LINE=$J(COUNT,2)_". "_$P(^DG(405.4,IEN,0),U)_" ("_$$GET1^DIQ(42,NAME,.01)_")"    ;rooomname/ward
 .... S LINE=$$PAD(LINE,20)_$$GET1^DIQ(405.4,IEN,.02)      ;description cmi/maw 8/19/2008 patch 1009 reported mitch wright
 .... ;S LINE=$$PAD(LINE,20)_$$GET1^DIQ(405.4,OEN,.02)      ;description orig line
 .... S LINE=$$PAD(LINE,55)_$$GET1^DIQ(405.4,IEN,9999999.01)  ;phone  cmi/maw 8/19/2008 patch 1009 reported mitch wright
 .... ;S LINE=$$PAD(LINE,55)_$$GET1^DIQ(405.4,OEN,9999999.01)  ;phone orig line
 .... ;
 .... I $$GET1^DIQ(405.4,IEN,.2)=1 S LINE=$$PAD(LINE,68)_"*INACTIVE*"
 .... D SET(LINE,COUNT,IEN,.VALMCNT)
 ;
 I '$D(^TMP("BDGSYS4",$J)) D
 . D SET("*** NO ENTRIES FOUND ***",0,0,.VALMCNT)
 Q
 ;
SET(DATA,NUM,N,LINE) ; put display line into array
 S LINE=LINE+1
 S ^TMP("BDGSYS4",$J,LINE,0)=DATA
 S ^TMP("BDGSYS4",$J,"IDX",LINE,NUM)=N
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSYS4",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
RESET ; -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D HDR,INIT
 Q
 ;
ADD ;EP; called by Add Entry protocol
 NEW DIC,DLAYGO,Y,DDSFILE,DA,DR,DGNEW
 D FULL^VALM1
 S (DIC,DLAYGO)=405.4,DIC(0)="AEMQZL" D ^DIC K DIC I Y<1 D RESET Q
 S DDSFILE=405.4,DA=+Y,DR="[BDG 405.4 SETUP]",DGNEW=1 D ^DDS
 D RESET
 Q
 ;
EDIT ;EP; called by Edit Entry protocol
 NEW X,Y,Z,BDGN,DDSFILE,DA,DR,DGNEW
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . ;7/18/02 WAR - REMd next line and changed code per LJF15
 . ;S Y=0 F  S Y=$O(^TMP("BDGSYS4",$J,"IDX",Y)) Q:Y=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGSYS4",$J,"IDX",Y)) Q:Y=""  Q:$G(BDGN)  D
 .. S Z=$O(^TMP("BDGSYS4",$J,"IDX",Y,0))
 .. Q:^TMP("BDGSYS4",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGSYS4",$J,"IDX",Y,Z)
 ;
 I 'BDGN D RESET Q
 S DDSFILE=405.4,DA=BDGN,DR="[BDG 405.4 SETUP]",DGNEW=1 D ^DDS
 D RESET
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)

BSDSYS1 ; IHS/ANMC/LJF - SCHED EVENT DRIVER VIEW ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BSD SYS EVENT DRIVER
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSD SYS EVENT DRIVER")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 NEW BSDN,ITEM,SEQ,LINE,X
 S VALMCNT=0
 K ^TMP("BSDSYS1",$J)
 ;
 S BSDN=$O(^ORD(101,"B","BSDAM APPOINTMENT EVENTS",0))
 I 'BSDN D SET("** SCHEDULING EVENT DRIVER NOT FOUND!!! **",.VALMCNT) Q
 S X="BSDAM APPOINTMENT EVENTS Protocol - Scheduling Event Driver Menu"
 D SET($$SP(79-$L(X)\2)_X,.VALMCNT),SET("",.VALMCNT)
 ;
 ; put event driver items into sequence order
 S ITEM=0 F  S ITEM=$O(^ORD(101,BSDN,10,ITEM)) Q:'ITEM  D
 . S SEQ=+$$GET1^DIQ(101.01,ITEM_","_BSDN,3) I SEQ=0 S SEQ="??"
 . S ^TMP("BSDSYS11",$J,SEQ,ITEM)=""
 ;
 ; create display lines from sorted list
 S SEQ=0 F  S SEQ=$O(^TMP("BSDSYS11",$J,SEQ)) Q:SEQ=""  D
 . S ITEM=0 F  S ITEM=$O(^TMP("BSDSYS11",$J,SEQ,ITEM)) Q:'ITEM  D
 .. ;
 .. S LINE=$$PAD($J(SEQ,7),10)                               ;sequence
 .. S LINE=LINE_$$GET1^DIQ(101.01,ITEM_","_BSDN,.01)         ;item
 .. S X=$$GET1^DIQ(101.01,ITEM_","_BSDN,.01,"I")             ;item ien
 .. I X S LINE=$$PAD(LINE,40)_$$GET1^DIQ(101,X,1)            ;item text
 .. D SET(LINE,.VALMCNT)
 ;
 ; include event driver description as documentation
 D SET("",.VALMCNT),SET("Documentation:",.VALMCNT)
 S X=0 F  S X=$O(^ORD(101,BSDN,1,X)) Q:'X  D
 . D SET($G(^ORD(101,BSDN,1,X,0)),.VALMCNT)
 ;
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BSDSYS1",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSYS1",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)

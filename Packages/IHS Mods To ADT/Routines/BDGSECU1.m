BDGSECU1 ; IHS/ANMC/LJF - LIST HOLDERS OF SENSITIVE KEYS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SECURITY KEYS
 NEW VALMCNT
 D TERM^VALM0
 D EN^VALM("BDG SECURITY KEYS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X S X="Listing of Users with keys important to this module"
 S VALMHDR(1)=$$SP(10)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW DGKEY,USER,X,LINE
 S VALMCNT=0 K ^TMP("BDGSECU",$J)
 ;
 ; loop by keys in this module
 F DGKEY="DG SECURITY OFFICER","DG SENSITIVITY","DG RECORD ACCESS" D
 . I DGKEY'["OFFICER" D SET("",.VALMCNT)   ;add blank line between keys
 . S X=$$PAD(DGKEY,25)_"("_$$DESCR(DGKEY)_")"    ;subheading for key
 . D SET(X,.VALMCNT)                       ;put into display global
 . ;
 . ; find each user holding that key
 . S USER=0 F  S USER=$O(^XUSEC(DGKEY,USER)) Q:'USER  D
 .. S LINE=$$SP(5)_$$GET1^DIQ(200,USER,.01)        ;user's name
 .. S LINE=$$PAD(LINE,35)_$$GET1^DIQ(200,USER,29)  ;service/section
 .. D SET(LINE,.VALMCNT)
 ;
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SET(LINE,COUNT) ; -- sets line into display global
 S COUNT=COUNT+1
 S ^TMP("BDGSECU",$J,COUNT,0)=LINE
 Q
 ;
DESCR(KEY) ; -- returns description of security key
 NEW X
 S X=$O(^DIC(19.1,"B",KEY,0)) I 'X Q "??"
 Q $E($$GET1^DIQ(19.1,X,.02),1,40)
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)

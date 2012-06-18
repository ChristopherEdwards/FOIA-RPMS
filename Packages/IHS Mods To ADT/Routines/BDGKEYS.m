BDGKEYS ; IHS/ANMC/LJF - LIST HOLDERS OF ADT KEYS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG ADT KEYS
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG ADT KEYS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X S X="Listing of security keys used by this module"
 S VALMHDR(1)=$$SP(10)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW DGKEY,USER,X,LINE,FIRST,N
 S VALMCNT=0 K ^TMP("BDGKEYS",$J)
 ;
 ; loop by keys in this module
 S DGKEY="DGZ",FIRST=1
 F  S DGKEY=$O(^DIC(19.1,"B",DGKEY)) Q:$E(DGKEY,1,3)'="DGZ"  D
 . D:'FIRST SET("",.VALMCNT) S FIRST=0   ;add blank line between keys
 . S X=$$PAD(DGKEY,25)_"("_$$DESCR(DGKEY)_")"    ;subheading for key
 . D SET(X,.VALMCNT)                       ;put into display global
 . ;
 . ; now display full description
 . S X=$O(^DIC(19.1,"B",DGKEY,0)) I 'X Q "??"
 . S N=0 F  S N=$O(^DIC(19.1,X,1,N)) Q:'N  D
 .. D SET($$SP(5)_$G(^DIC(19.1,X,1,N,0)),.VALMCNT)
 ;
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGKEYS",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SET(LINE,COUNT) ; -- sets line into display global
 S COUNT=COUNT+1
 S ^TMP("BDGKEYS",$J,COUNT,0)=LINE
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

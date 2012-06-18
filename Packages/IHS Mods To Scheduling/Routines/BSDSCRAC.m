BSDSCRAC ; IHS/ANMC/LJF - PROVIDER DEMOGRAPHICS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC PRV DEMOGRAPHICS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCRAC",$J),^TMP("BSDSCRAC1",$J)
 D GUIR^XBLM("IHS^SCRPRAC","^TMP(""BSDSCRAC1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCRAC1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCRAC",$J,X,0)=^TMP("BSDSCRAC1",$J,X)
 K ^TMP("BSDSCRAC1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCRAC",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

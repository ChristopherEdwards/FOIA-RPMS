BSDSCV1 ; IHS/ANMC/LJF - PCMM INCONSISTENCIES ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC INCONSISTENCIES")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCV1",$J),^TMP("BSDSCV11",$J)
 D GUIR^XBLM("IHS^SCRPV1","^TMP(""BSDSCV11"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCV11",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCV1",$J,X,0)=^TMP("BSDSCV11",$J,X)
 K ^TMP("BSDSCV11",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCV1",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

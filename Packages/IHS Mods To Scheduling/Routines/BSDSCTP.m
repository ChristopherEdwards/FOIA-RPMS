BSDSCTP ; IHS/ANMC/LJF - TEAM PATIENT LIST ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC TEAM PATIENT LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCTP",$J),^TMP("BSDSCTP1",$J)
 D GUIR^XBLM("IHS^SCRPTP","^TMP(""BSDSCTP1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCTP1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCTP",$J,X,0)=^TMP("BSDSCTP1",$J,X)
 K ^TMP("BSDSCTP1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCTP",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

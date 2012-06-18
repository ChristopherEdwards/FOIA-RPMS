BSDSCTM ; IHS/ANMC/LJF - TEAM MEMBER LIST ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC TEAM MEMBER LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCTM",$J),^TMP("BSDSCTM1",$J)
 D GUIR^XBLM("IHS^SCRPTM","^TMP(""BSDSCTM1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCTM1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCTM",$J,X,0)=^TMP("BSDSCTM1",$J,X)
 K ^TMP("BSDSCTM1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCTM",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

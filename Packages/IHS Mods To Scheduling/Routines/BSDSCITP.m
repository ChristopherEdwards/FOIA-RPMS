BSDSCITP ; IHS/ANMC/LJF - TEAM PROFILE LIST TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BSDSC TEAM PROFILE
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC TEAM PROFILE")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCITP",$J),^TMP("BSDSCITP1",$J)
 D GUIR^XBLM("IHS^SCRPITP","^TMP(""BSDSCITP1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCITP1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCITP",$J,X,0)=^TMP("BSDSCITP1",$J,X)
 K ^TMP("BSDSCITP1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCITP",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

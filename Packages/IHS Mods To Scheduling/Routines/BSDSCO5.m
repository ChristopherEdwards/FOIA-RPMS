BSDSCO5 ; IHS/ANMC/LJF - PT HIST ASSIGN LIST TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BSDSC HIST PT DETAILS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC HIST PT DETAILS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCO5",$J),^TMP("BSDSCO51",$J)
 D GUIR^XBLM("IHS^SCRPO5","^TMP(""BSDSCO51"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCO51",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCO5",$J,X,0)=^TMP("BSDSCO51",$J,X)
 K ^TMP("BSDSCO51",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCO5",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

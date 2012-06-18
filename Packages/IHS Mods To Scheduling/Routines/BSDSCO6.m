BSDSCO6 ; IHS/ANMC/LJF - TEAM HIST ASSIGN LIST TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC HIST TEAM ASSIGN")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCO6",$J),^TMP("BSDSCO61",$J)
 D GUIR^XBLM("IHS^SCRPO6","^TMP(""BSDSCO61"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCO61",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCO6",$J,X,0)=^TMP("BSDSCO61",$J,X)
 K ^TMP("BSDSCO61",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D END^SCRPW50 K ^TMP("BSDSCO6",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

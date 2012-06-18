BSDSCO3 ; IHS/ANMC/LJF - PRV HIST ASSIGN LIST TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC HIST PRV ASSIGN")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCO3",$J),^TMP("BSDSCO31",$J)
 D GUIR^XBLM("IHS^SCRPO3","^TMP(""BSDSCO31"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCO31",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCO3",$J,X,0)=^TMP("BSDSCO31",$J,X)
 K ^TMP("BSDSCO31",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D END^SCRPW50 K ^TMP("BSDSCO3",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

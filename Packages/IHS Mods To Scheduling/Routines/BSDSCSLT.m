BSDSCSLT ; IHS/ANMC/LJF - TEAM SUMMARY LIST ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC TEAM SUMMARY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCSLT",$J),^TMP("BSDSCSLT1",$J)
 D GUIR^XBLM("IHS^SCRPSLT","^TMP(""BSDSCSLT1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCSLT1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCSLT",$J,X,0)=^TMP("BSDSCSLT1",$J,X)
 K ^TMP("BSDSCSLT1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCSLT",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

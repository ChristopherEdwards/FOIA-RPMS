BSDNOS ; IHS/ANMC/LJF - NOSHOW REPORT ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM NOSHOW REPORT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDNOS",$J),^TMP("BSDNOS1",$J)
 D GUIR^XBLM("IHS^SDNOS0","^TMP(""BSDNOS1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDNOS1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDNOS",$J,X,0)=^TMP("BSDNOS1",$J,X)
 K ^TMP("BSDNOS1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDNOS",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

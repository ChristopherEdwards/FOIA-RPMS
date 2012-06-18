BSDSCTA ; IHS/ANMC/LJF - PAT LIST FOR TEAM ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC PT LIST FOR TEAM")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCTA",$J),^TMP("BSDSCTA1",$J)
 D GUIR^XBLM("IHS^SCRPTA","^TMP(""BSDSCTA1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCTA1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCTA",$J,X,0)=^TMP("BSDSCTA1",$J,X)
 K ^TMP("BSDSCTA1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCTA",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

BDGBEDA ; IHS/ANMC/LJF - BED AVAILABILITY BROWSE MODE ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG BED AVAIL
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG BED AVAIL")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BDGBEDA",$J),^TMP("BDGBEDA1",$J)
 D GUIR^XBLM("PR^DGPMRBA1","^TMP(""BDGBEDA1"",$J,")
 S X=0 F  S X=$O(^TMP("BDGBEDA1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BDGBEDA",$J,X,0)=^TMP("BDGBEDA1",$J,X)
 ;
 I '$D(^TMP("BDGBEDA",$J)) S VALMCNT=1,^TMP("BDGBEDA",$J,1,0)="No data found"
 K ^TMP("BDGBEDA1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGBEDA",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

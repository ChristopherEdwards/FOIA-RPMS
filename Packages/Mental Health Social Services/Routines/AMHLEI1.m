AMHLEI1 ; IHS/CMI/LAB - Visit display 18-MAY-1995 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
EN(DFN) ;EP -- main entry point for AMH VISIT DISPLAY
 K ^TMP("AMHLEI1",$J)
 Q:'$G(DFN)
 D DISP^AMHLEI2(DFN)
 D EN^VALM("AMH INTAKE DOCUMENT DISPLAY")
 K ^TMP("AMHLEI1",$J),AMHBROW
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHLEI1",$J,""),-1)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;

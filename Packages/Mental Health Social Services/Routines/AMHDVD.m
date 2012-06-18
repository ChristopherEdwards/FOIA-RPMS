AMHDVD ; IHS/CMI/LAB - Visit display 18-MAY-1995 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
EN ;EP -- main entry point for AMH VISIT DISPLAY
 K ^TMP("AMHVDSG",$J)
 Q:'$G(AMHR)
 D EP^AMHVDSG(AMHR)
 D EN^VALM("AMH RECORD DISPLAY")
 K ^TMP("AMHVDSG",$J),AMHBROW
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
EN1 ;EP - called from input templates
 D EN^XBNEW("EN^AMHVD","AMHR")
 K Y
 Q
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHVDSG",$J,""),-1)
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

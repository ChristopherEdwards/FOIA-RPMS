AMHPCVD ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 18-MAY-1995 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
EN ; -- main entry point for AMH VISIT DISPLAY
 K ^TMP("AMHPVDSG",$J)
 Q:'$G(AMHVSIT)
 D EP^AMHPVDSG(AMHVSIT)
 D EN^VALM("AMH VISIT DISPLAY")
 K ^TMP("AMHPVDSG",$J),AMHBROW
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
EN1 ;EP - called from input templates
 D EN^XBNEW("EN^AMHPCVD","AMHVSIT")
 K Y
 Q
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHPVDSG",$J,""),-1)
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

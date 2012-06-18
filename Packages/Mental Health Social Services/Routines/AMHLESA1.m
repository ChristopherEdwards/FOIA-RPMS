AMHLESA1 ; IHS/CMI/LAB - Visit display 18-MAY-1995 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
EN(AMHR) ;EP -- main entry point for AMH VISIT DISPLAY
 K ^TMP("AMHLESA1",$J)
 Q:'$G(AMHR)
 D DISP^AMHLESA2(AMHR)
 D EN^VALM("AMH SAN DOCUMENT DISPLAY")
 K ^TMP("AMHLESA1",$J),AMHBROW
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("AMHLESA1",$J,""),-1)
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

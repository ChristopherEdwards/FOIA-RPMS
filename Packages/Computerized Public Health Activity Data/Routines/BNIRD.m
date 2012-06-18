BNIRD ; IHS/CMI/LAB - bni record display ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;; ;
EN ;PEP -- main entry point for BNI RECORD DISPLAY
 K ^TMP("BNIVDSG",$J)
 Q:'$G(BNIREC)
 D EN^BNIRDSG(BNIREC)
 NEW VALMCNT
 D TERM^VALM0
 D CLEAR^VALM1
 D EN^VALM("BNI RECORD DISPLAY")
 K ^TMP("BNIVDSG",$J),BNIBROW
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
EN1 ;EP - called from input templates
 D EN^XBNEW("EN^BNIRD","BNIREC")
 K Y
 Q
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("BNIVDSG",$J,""),-1)
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

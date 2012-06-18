BDMVAGL ; cmi/anch/maw - VIEW PATIENT REGISTRATION ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;;AUG 11, 2006
 ;; ;
 ;
 D FULL^VALM1
 NEW DIR S DIR(0)="NO^1:2",DIR("B")=1,DIR("A")="Select One"
 S DIR("A",1)=""
 S DIR("A",2)="  1. VIEW Registration Data"
 S DIR("A",3)="  2. UPDATE Registration Data"
 D ^DIR Q:Y<1  I Y=2 D  Q
 . I '$$PKGCK^BDMVU("ASDREG","SCHEDULING VERSION 5.0") Q
 . D CLEAR^VALM1,^ASDREG Q
 ;
EN ; -- main entry point for BDMV AG VIEW
 NEW VALMCNT
 D EN^VALM("BDMV AG VIEW")
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 D GUIR^XBLM("^BDMVAG1","^TMP(""BDMVAG"",$J,")
 S X=0 F  S X=$O(^TMP("BDMVAG",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BDMVAG",$J,X,0)=^TMP("BDMVAG",$J,X)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDMVAG",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

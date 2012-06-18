AMHVAGL ; IHS/CMI/LAB - VIEW PATIENT REGISTRATION ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
 ;
 D FULL^VALM1
 NEW DIR S DIR(0)="NO^1:2",DIR("B")=1,DIR("A")="Select One"
 S DIR("A",1)=""
 S DIR("A",2)="  1. VIEW Registration Data"
 S DIR("A",3)="  2. UPDATE Registration Data"
 D ^DIR Q:Y<1  I Y=2 D  Q
 . I '$$PKGCK^AMHVU("ASDREG","SCHEDULING VERSION 5.0") Q
 . D CLEAR^VALM1,^ASDREG Q
 ;
EN ; -- main entry point for AMHV AG VIEW
 NEW VALMCNT
 D EN^VALM("AMHV AG VIEW")
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 D GUIR^XBLM("^AMHVAG1","^TMP(""AMHVAG"",$J,")
 S X=0 F  S X=$O(^TMP("AMHVAG",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("AMHVAG",$J,X,0)=^TMP("AMHVAG",$J,X)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("AMHVAG",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;

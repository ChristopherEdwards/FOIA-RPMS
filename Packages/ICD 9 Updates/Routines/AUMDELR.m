AUMDELR ; IHS/ASDST/GTH - AN AUM UTILITY FOR AUM ; [ 10/31/2001   3:40 PM ]
 ;;02.1;TABLE MAINTENANCE;**1**;SEP 28,2001
 ;
DEL(AUMN,AUMA) ;EP - Delete routines in namespace "AUMN", if AUMA=0. If AUMA=1, single routine.
 ; It's up to the calling routine to make sure it's not deleted, if
 ; the calling routine is the current routine.
 KILL ^TMP("AUMDELR",$J)
 I $G(AUMA)=1 S ^TMP("AUMDELR",$J,AUMN)=""
 E  Q:'$$RSEL^ZIBRSEL(AUMN_"*","^TMP(""AUMDELR"","_$J_",")
 ;
 NEW X
 ;
 S X=""
 F  S X=$O(^TMP("AUMDELR",$J,X)) Q:X=""  X ^%ZOSF("DEL")  I $G(XPDA) D BMES^XPDUTL(X_$E("...........",1,11-$L(X))_"<poof'd>")
 KILL ^TMP("AUMDELR",$J)
 Q
 ;

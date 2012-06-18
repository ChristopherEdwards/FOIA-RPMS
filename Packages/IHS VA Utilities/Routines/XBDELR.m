XBDELR ; IHS/ASDST/GTH - AN XB UTILITY ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; IHS/SET/GTH XB*3*9 10/29/2002
 ;
 ; Delete routines in namespace "XBN", if XBA=0.
 ;        If XBA=1, single routine.
 ;
 ; It's up to the calling routine to make sure it's not deleted, if
 ; the calling routine is the current routine.
 ;
 ; E.g.:  D DEL^XBDELR("MYROUTIN",1) Del 1 routine named "MYROUTIN".
 ;        D DEL^XBDELR("NS")         Del all routines in "NS" namespace.
 ;
 ;
DEL(XBN,XBA) ;PEP - Delete routine(s).
 I $G(XBA)=1 S ^TMP("XBDELR",$J,XBN)=""
 E  Q:'$$RSEL^ZIBRSEL(XBN_"*","^TMP(""XBDELR"","_$J_",")
 ;
 NEW X
 ;
 S X=""
 F  S X=$O(^TMP("XBDELR",$J,X)) Q:X=""  X ^%ZOSF("DEL")  I '$D(ZTQUEUED) D BMES^XPDUTL(X_$E("...........",1,11-$L(X))_"<poof'd>")
 KILL ^TMP("XBDELR",$J)
 Q
 ;

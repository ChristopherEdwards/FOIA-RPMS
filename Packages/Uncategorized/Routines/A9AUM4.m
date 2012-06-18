A9AUM4 ; IHS/RPMSDBA/GTH - STANDARD TABLE UPDATES, EDUCATION TOPICS 2001, RPI ; [ 05/24/2001  10:55 AM ]
 ;;01.1;TABLE MAINTENANCE;**4**;DEC 6,2000
 ;
 D START^AUM1104
DEL ;EP - Delete routines.
 Q:'$L($G(^%ZOSF("DEL")))
 NEW X
 I $$RSEL^ZIBRSEL("AUM1104*") D D
 I $$RSEL^ZIBRSEL("A9AUM*")
 KILL ^TMP("ZIBRSEL",$J,"A9AUM4") ; Don't delete the current routine.
 D D
 Q
 ;
D ;
 S X=""
 F  S X=$O(^TMP("ZIBRSEL",$J,X)) Q:X=""  X ^%ZOSF("DEL") I '$D(ZTQUEUED) W !,X,$E("...........",1,11-$L(X)),"<poof'd>"
 KILL ^TMP("ZIBRSEL",$J)
 Q
 ;

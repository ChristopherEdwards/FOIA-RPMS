INH4CONV ;DGH; 24 Apr 95 11:43
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN1 ;This makes necessary changes to interface globals for ver 4.4
 ;1) Converts existing "AH" x-ref of ^INLHFTSK to new format
 ;2) Transfers entries from server queues to primary interface queues
 ;
 N T,PRIO,INTSK,TT,D,H,X,Y,Z
FORMAT ;Convert format queue, ^INLHFTSK.
 ;Old format -- ^INLHFTSK("AH",Time to process,INTSK)
 ;New format -- ^INLHFTSK("AH",Priority,Time,INTSK) and .06 field
 ;is FORMAT PRIORITY
 G:'$D(^INLHFTSK("AH")) SERVER
 S T="" F  S T=$O(^INLHFTSK("AH",T)) Q:'T  D
 .S INTSK="" F  S INTSK=$O(^INLHFTSK("AH",T,INTSK)) Q:'INTSK  D
 ..;Look up FORMAT PRIORITY from Tran Type file,
 ..S TT=$P($G(^INLHFTSK(INTSK,0)),U)
 ..S PRIO=$S('TT:0,1:+$P($G(^INRHT(TT,0)),U,14))
 ..S ^INLHFTSK("AH",PRIO,T,INTSK)=""
 ..K ^INLHFTSK("AH",T,INTSK)
 ;
SERVER ;Transfer entries, if any, from format controller,
 ;^INLHFTSK("SRVR",time to process,INTSK)
 G:'$D(^INLHFTSK("SRVR")) OUTPUT
 S H="" F  S H=$O(^INLHFTSK("SRVR",H)) Q:'$L(H)  D
 .S INTSK="" F  S INTSK=$O(^INLHFTSK("SRVR",H,INTSK)) Q:'INTSK  D
 ..S TT=$P($G(^INLHFTSK(INTSK,0)),U)
 ..S PRIO=$S('TT:0,1:+$P($G(^INRHT(TT,0)),U,14))
 ..S ^INLHFTSK("AH",PRIO,T,INTSK)=""
 K ^INLHFTSK("SRVR")
 ;
OUTPUT ;Transfer entries, if any, from output controller, ^INLHSCH("SRVR"
 G:'$D(^INLHSCH("SRVR")) EXIT
 S X="" F  S X=$O(^INLHSCH("SRVR",X)) Q:X=""  D
 . S Y="" F  S Y=$O(^INLHSCH("SRVR",X,Y)) Q:'Y  D
 .. S Z="" F  S Z=$O(^INLHSCH("SRVR",X,Y,Z)) Q:'Z  D
 ... S ^INLHSCH(X,Y,Z)="",D=$P($G(^INTHU(Z,0)),U,2)
 ... K ^INLHSCH("SRVR",X,Y,Z)
 ;
EXIT Q

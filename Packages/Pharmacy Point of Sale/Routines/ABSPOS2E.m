ABSPOS2E ; IHS/FCS/DRS - print queues ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
QUEUES() ;EP - option ABSP SUP QUEUES
 ; Note:  these don't LOCK anything, so you could get anomalous-looking
 ; results because of timing.
 W ! N ROOT,STATUS,SET,WHICH,X
 I '$D(IOM) N IOM S IOM=80
 S ROOT="^ABSPT" ;  because we hate typing all that
QUE1 F STATUS=0:1:98 D
 .I '$D(@ROOT@("AD",STATUS)) Q
 .W $$QCOUNT(STATUS)," in Q"
 .W STATUS," ",$$STATI^ABSPOSU(STATUS)
 .N X S X=""
 .F  S X=$O(@ROOT@("AD",STATUS,X)) Q:X=""  Q:$X+$L(X)+1'<IOM  D
 ..W " ",X
 .W !
 S SET="" F  S SET=$O(^ABSPECX("POS",SET)) Q:SET=""  D
 .F WHICH="C","R" D
 ..Q:'$D(^ABSPECX("POS",SET,WHICH))
 ..W $$PQCOUNT(SET,WHICH)," packets in Set ",SET," "
 ..W $S(WHICH="C":"waiting to transmit",1:"received but unprocessed")
 ..S X="" F  S X=$O(^ABSPECX("POS",SET,WHICH,X)) Q:X=""  Q:$X+$L(X)+1'<IOM  W " ",X
 ..W !
QUE50 S X=$$CONTINUE^ABSPOSUD("C")
 I "Cc"[X G QUE1
 I "Qq^"[X G QUE99
 G QUE50
QUE99 ;
 Q:$Q X  Q
QCOUNT(N)          N I,X S X="" F I=0:1 S X=$O(@ROOT@("AD",N,X)) Q:X=""
 Q I
PQCOUNT(N,W)         N I,X S X="" F I=0:1 S X=$O(^ABSPECX("POS",N,W,X)) Q:X=""
 Q I

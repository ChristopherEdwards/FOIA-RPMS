ABME5L11 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Header Segments
 ;
START ;START HERE
 S ABMLOOP="Header"
 D ^ABME5SE
 D WR^ABMUTL8("SE")
 I (ABMER("CNT")=ABMER("LAST")) D  ;only do last time thru
 .D ^ABME5GE
 .D WR^ABMUTL8("GE")
 .D ^ABME5IEA
 .D WR^ABMUTL8("IEA")
 Q

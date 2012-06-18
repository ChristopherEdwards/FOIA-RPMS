ABME8L11 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;Header Segments
 ;
START ;START HERE
 D ^ABME8SE
 D WR^ABMUTL8("SE")
 ;start old code abm*2.6*8
 ;D ^ABME8GE
 ;D WR^ABMUTL8("GE")
 ;D ^ABME8IEA
 ;D WR^ABMUTL8("IEA")
 ;end old code start new code
 I (ABMER("CNT")=ABMER("LAST")) D  ;only do last time thru
 .D ^ABME8GE
 .D WR^ABMUTL8("GE")
 .D ^ABME8IEA
 .D WR^ABMUTL8("IEA")
 ;end new code
 Q

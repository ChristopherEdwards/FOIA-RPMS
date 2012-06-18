AUMPRE7 ;IHS/ASDST/DMJ - AUM PRE INSTALL [ 09/27/2006  3:06 PM ]
 ;;7.1;AUM - SCB UPDATE;**1,3**;MAY 9, 2005
 ;
CLR ;clear out old codes
 S I=0
CLR2 ;I already set
 F  S I=$O(^AUMDATA(I)) Q:'I  D
 .K ^AUMDATA(I)
 F I=3,4 D
 .S $P(^AUMDATA(0),"^",I)=0
 Q

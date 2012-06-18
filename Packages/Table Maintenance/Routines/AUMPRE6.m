AUMPRE6 ;IHS/ASDST/DMJ - AUM PRE INSTALL [ 04/10/2006  10:43 AM ]
 ;;6.1;AUM - SCB UPDATE;**6**;MAY 9, 2005
 ;
CLR ;clear out old codes
 S I=0
CLR2 ;I already set
 F  S I=$O(^AUMDATA(I)) Q:'I  D
 .K ^AUMDATA(I)
 F I=3,4 D
 .S $P(^AUMDATA(0),"^",I)=0
 Q

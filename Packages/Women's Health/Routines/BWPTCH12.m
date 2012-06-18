BWPTCH12 ;IHS/CMI/LAB - BW PATCH 12 ;24-Mar-2011 19:55;PLS
 ;;2.0;WOMEN'S HEALTH;**12**;MAY 16, 1996
 ;
 ;
PRE ;
 N DA,DIK,DIU
 S DA=$O(^BWFMT("B","CDC60",0))
 I DA D
 .S DIK="^BWFMT("
 .D ^DIK
 Q
POST ;
 N L,IEN
 F L="BI-RADS 0-Add Imag Eval Needed:6:6","BI-RADS 0-Prev Films Req:6:13" D
 .S IEN=$O(^BWDIAG("B",$P(L,":"),0))
 .Q:'IEN
 .S $P(^BWDIAG(IEN,0),U,2)=$P(L,":",2)
 .S $P(^BWDIAG(IEN,0),U,25)=$P(L,":",3)
 Q

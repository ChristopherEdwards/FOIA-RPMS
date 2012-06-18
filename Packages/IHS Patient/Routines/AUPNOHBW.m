AUPNOHBW ; IHS/CMI/LAB - CONVERT OFFSPRING HISTORY BIRTH WEIGHT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
WT ; (OFFSPRING HISTORY BIRTH WEIGHT)
 D WTC
 Q:'$D(X)
 K:+X'=X!(X>15.9375)!(X<2)!(X?.E1"."5N.N) X
 Q:'$D(X)
 K:X-(X\1)#.0625 X
 Q
WTC Q:+X=X!(X'[" ")
 Q:'(X?1.2N1" "1.2N!(X?1.2N1" "1.2N1"/"1.2N))
 I X'["/" Q:+$P(X," ",2)>16  S X=+X+(+$P(X," ",2)/16) Q
 Q:+$P($P(X," ",2),"/",1)'<+$P($P(X," ",2),"/",2)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q

AZHNDUMB ; [8/17/98 1:24pm]
 S Z=0
 ;F  S Z=$O(^ASUMX("F",Z)) Q:Z'?1N.N  D
 F Z=1,3 D
 .W !,"ACCOUNT: ",Z,!
 .S (X,Y,C)=0
 .F  S X=$O(^ASUMX("F",Z,X)) Q:X']""  D
 ..I $G(^ASUMS(40002,1,X,0))]"" D
 ...W !?4,$E(X,3,8) S C=C+1
 ...W ?12,$J($FN($P(^ASUMS(40002,1,X,0),U,16),",",2),12) S Y=Y+$P(^(0),U,16)
 .W !!,"TOTAL: ",$J(C,5),?12,$J($FN(Y,",",2),12)
 Q

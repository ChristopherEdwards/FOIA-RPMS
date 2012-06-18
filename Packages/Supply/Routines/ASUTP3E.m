ASUTP3E ; GENERATED FROM 'ASUOTP3E' PRINT TEMPLATE (#2373) ; 09/07/00 ; (FILE 9002031, MARGIN=132)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2373,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S I(1)=1,J(1)=9002031.02 F D1=0:0 Q:$O(^ASUMS(D0,1,D1))'>0  X:$D(DSC(9002031.02)) DSC(9002031.02) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 D T Q:'DN  D N W ?0 S DIP(1)=$S($D(^ASUMS(D0,1,D1,0)):^(0),1:"") S X=$S('$D(^ASUMX(+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)),X=$E(X,1,5)_"."_$E(X,6,6) K DIP K:DN Y W X
 W ?11 D ^ASURO3UT K DIP K:DN Y
 D N:$X>9 Q:'DN  W ?9 X DXS(1,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>40 Q:'DN  W ?40 X DXS(2,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,4) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>124 Q:'DN  W ?124 X DXS(3,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$S('$D(^ASUL(9,+$P(DIP(101),U,6),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W $E(X,1,3)
 D N:$X>127 Q:'DN  W ?127 X DXS(4,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,7) S:$L(X)>0 X=$E(X,1,2)_"."_$E(X,3,4) S X=X S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W $E(X,1,5)
 D N:$X>9 Q:'DN  W ?9 X DXS(5,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,3) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>43 Q:'DN  W ?43 S DIP(1)=$S($D(^ASUMS(D0,0)):^(0),1:"") S X=$S('$D(^ASUL(2,+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W $E(X,1,3)
 S X=$G(^ASUMS(D0,1,D1,2)) D N:$X>46 Q:'DN  W ?46,$E($P(X,U,1),1,3)
 D N:$X>49 Q:'DN  W ?49 X DXS(6,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,9) S:$L(X)>0 X=$E(X,1,2)_"-"_$E(X,3,4) S X=X S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 S X=$G(^ASUMS(D0,1,D1,2)) D N:$X>55 Q:'DN  W ?55,$J($P(X,U,5),2)
 D N:$X>57 Q:'DN  W ?57 X DXS(7,9) K DIP K:DN Y W $J(X,8)
 S X=$G(^ASUMS(D0,1,D1,0)) D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,7) W:Y]"" $J(Y,5,0)
 D N:$X>72 Q:'DN  W ?72 S DIP(1)=$S($D(^ASUMS(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,15),X=$FN(X,",",2) K DIP K:DN Y W $J(X,8)
 S X=$G(^ASUMS(D0,1,D1,0)) D N:$X>84 Q:'DN  W ?84,$E($P(X,U,14),1,15)
 D N:$X>99 Q:'DN  W ?99,$E($P(X,U,4),1,2)
 D N:$X>103 Q:'DN  W ?103 X DXS(8,9) K DIP K:DN Y W X
 D N:$X>120 Q:'DN  W ?120 S DIP(1)=$S($D(^ASUMS(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,5),X=$S(X="":"",1:$E(X)_"."_$E(X,2)) K DIP K:DN Y W X
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?11,"D"
 W !,?11,"^ASURO3UT"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!

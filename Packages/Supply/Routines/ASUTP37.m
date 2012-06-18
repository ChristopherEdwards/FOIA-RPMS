ASUTP37 ; GENERATED FROM 'ASUOTP37' PRINT TEMPLATE (#2374) ; 09/07/00 ; (FILE 9002031, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2374,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S I(1)=1,J(1)=9002031.02 F D1=0:0 Q:$O(^ASUMS(D0,1,D1))'>0  X:$D(DSC(9002031.02)) DSC(9002031.02) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ASUMS(D0,1,D1,2)) D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3,$E($P(X,U,1),1,1)
 D N:$X>5 Q:'DN  W ?5 S DIP(1)=$S($D(^ASUMS(D0,1,D1,0)):^(0),1:"") S X=$S('$D(^ASUMX(+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)),X=$E(X,1,5)_"."_$E(X,6,6) K DIP K:DN Y W X
 D N:$X>13 Q:'DN  W ?13 X DXS(1,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>46 Q:'DN  W ?46 X DXS(2,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,4) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>13 Q:'DN  W ?13 X DXS(3,9.2) S DIP(101)=$S($D(^ASUMX(D0,0)):^(0),1:"") S X=$P(DIP(101),U,3) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?5,"ASUFIDXT(INDEX)"
 W !,?13,"INDEX:DESCRIPTION2"
 W !,"--------------------------------------------------------------------------------",!!

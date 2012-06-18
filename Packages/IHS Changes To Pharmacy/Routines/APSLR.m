APSLR ; GENERATED FROM 'APS PREPACK LOG LOCATION LIST' PRINT TEMPLATE (#2821) ; 02/14/03 ; (FILE 9009031, MARGIN=132)
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2821,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^APSPP(31,D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) D DT
 D N:$X>16 Q:'DN  W ?16,$E($P(X,U,1),1,12)
 D N:$X>32 Q:'DN  W ?32 X DXS(1,9) K DIP K:DN Y
 S X=$G(^APSPP(31,D0,0)) D N:$X>71 Q:'DN  W ?71,$E($P(X,U,8),1,13)
 S I(1)=15,J(1)=9009031.15 F D1=0:0 Q:$O(^APSPP(31,D0,15,D1))'>0  X:$D(DSC(9009031.15)) DSC(9009031.15) S D1=$O(^(D1)) Q:D1'>0  D:$X>86 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^APSPP(31,D0,15,D1,0)) D N:$X>88 Q:'DN  W ?88 S Y=$P(X,U,2),C=1 D A:Y]"" W $E(Y,1,20)
 Q
A1R ;
 S X=$G(^APSPP(31,D0,0)) D N:$X>112 Q:'DN  W ?112 S Y=$P(X,U,11),C=2 D A:Y]"" W:Y]"" $J(Y,20,2)
 K Y
 Q
HEAD ;
 W !,?32,""
 W !,?32,""
 W !,?32,""
 W !,?32,""
 W !,?32,""
 W !,?32,""
 W !,?32,""
 W !,?32,"",?132,""
 W !,?32,"",?132,""
 W !,?32,"",?132,""
 W !,?32,"",?132,""
 W !,?16,"",?32,"",?132,""
 W !,?16,"",?32,"",?132,""
 W !,?16,"",?32,"",?88,"",?132,""
 W !,?0,"DATE FILLED",?17,"CN#",?33,"DRUG",?71,"# PER PREPACK",?89,"# OF PREPACKS",?128,"COST"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!

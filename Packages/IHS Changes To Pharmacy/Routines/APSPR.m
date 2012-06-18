APSPR ; GENERATED FROM 'APS PREPACK LOG PREPACK LIST' PRINT TEMPLATE (#2820) ; 02/14/03 ; (FILE 9009031, MARGIN=132)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2820,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^APSPP(31,D0,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) D DT
 D N:$X>17 Q:'DN  W ?17,$E($P(X,U,1),1,10)
 D N:$X>31 Q:'DN  W ?31 X DXS(1,9) K DIP K:DN Y
 S X=$G(^APSPP(31,D0,0)) D N:$X>65 Q:'DN  W ?65,$E($P(X,U,8),1,13)
 D N:$X>82 Q:'DN  W ?82 S Y=$P(X,U,9),C=1 D A:Y]"" W $E(Y,1,10)
 D N:$X>96 Q:'DN  W ?96 S Y=$P(X,U,14) S Y=$S(Y="":Y,$D(^DIC(3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,20)
 D N:$X>120 Q:'DN  W ?120 S Y=$P(X,U,11),C=2 D A:Y]"" W:Y]"" $J(Y,12,2)
 D N:$X>0 Q:'DN  W ?0 W "MANUFACT: "
 D N:$X>10 Q:'DN  W ?10 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^APSPP(31.3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,45)
 D N:$X>65 Q:'DN  W ?65 W "LOT #:"
 D N:$X>74 Q:'DN  W ?74,$E($P(X,U,5),1,15)
 D N:$X>96 Q:'DN  W ?96 W "EXPIRES: "
 D N:$X>107 Q:'DN  W ?107 S Y=$P(X,U,6) D DT
 K Y
 Q
HEAD ;
 W !,?31,""
 W !,?31,""
 W !,?31,""
 W !,?31,""
 W !,?31,""
 W !,?31,""
 W !,?31,""
 W !,?31,""
 W !,?31,"",?96,""
 W !,?31,"",?96,"",?132,""
 W !,?17,"",?31,"",?96,"",?132,""
 W !,?17,"",?31,"",?96,"",?132,""
 W !,?0,"DATE FILLED",?18,"CN#",?32,"DRUG",?65,"# PER PREPACK",?82,"# PREPACKS",?97,"PHARMACIST",?128,"COST"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!

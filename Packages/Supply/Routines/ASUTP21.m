ASUTP21 ; GENERATED FROM 'ASULTP21' PRINT TEMPLATE (#2344) ; 09/07/00 ; (FILE 9002039.21, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2344,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^ASUL(21,D0,0)) W ?0 S Y=$P(X,U,1),C=1 D D S Y=$S(Y="":Y,$D(^ASUL(18,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,15)
 S I(1)=1,J(1)=9002039.211 F D1=0:0 Q:$O(^ASUL(21,D0,1,D1))'>0  X:$D(DSC(9002039.211)) DSC(9002039.211) S D1=$O(^(D1)) Q:D1'>0  D:$X>17 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ASUL(21,D0,1,D1,0)) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,1),C=2 D D S Y=$S(Y="":Y,$D(^ASUL(17,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 S I(2)=1,J(2)=9002039.2111 F D2=0:0 Q:$O(^ASUL(21,D0,1,D1,1,D2))'>0  X:$D(DSC(9002039.2111)) DSC(9002039.2111) S D2=$O(^(D2)) Q:D2'>0  D:$X>36 T Q:'DN  D A2
 G A2R
A2 ;
 D N:$X>9 Q:'DN  W ?9 X DXS(1,9) K DIP K:DN Y W $E(X,1,1)
 S X=$G(^ASUL(21,D0,1,D1,1,D2,0)) W ?12 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ASUL(9,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,10)
 W ?24 S Y=$P(X,U,2),C=3 D A:Y]"" W:Y]"" $J(Y,9,0)
 W ?35 S Y=$P(X,U,3),C=4 D A:Y]"" W $J(Y,9)
 W ?47 S Y=$P(X,U,4),C=5 D A:Y]"" W:Y]"" $J(Y,9,0)
 Q
A2R ;
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?0,"SUB STATION"
 W !,?0,"NAME"
 W !,?4,"SUB-SUB ACTIVITY"
 W !,?9,"A",?27,"ANNUAL"
 W !,?9,"C",?29,"BASE",?38,"BUDGET",?47,"ALLOTMENT"
 W !,?9,"C",?12,"ACCOUNT",?27,"BUDGET",?35,"ADJUSTMENT",?49,"TO DATE"
 W !,"--------------------------------------------------------------------------------",!!

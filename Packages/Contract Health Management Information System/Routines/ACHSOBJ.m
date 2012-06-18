ACHSOBJ ; IHS/ITSC/PMF - GENERATED FROM 'ACHSRALLP' PRINT TEMPLATE (#5198) 11/26/97 (FILE 9002063, MARGIN=80) ; [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 G BEGIN
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(5198,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^ACHS(3,D0,0)) W ?0 S Y=$P(X,U,1),C=1 D D S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,10)
 S I(1)=1,J(1)=9002063.02 F D1=0:0 Q:$O(^ACHS(3,D0,1,D1))'>0  X:$D(DSC(9002063.02)) DSC(9002063.02) S D1=$O(^(D1)) Q:D1'>0  D:$X>12 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACHS(3,D0,1,D1,0)) W ?12 S Y=$P(X,U,1),C=2 D D W $E(Y,1,4)
 W ?18 S Y=$P(X,U,2),C=3 D D W $E(Y,1,12)
 W ?32 S Y=$P(X,U,3),C=4 D D W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 S I(2)="""CC""",J(2)=9002063.03 F D2=0:0 Q:$O(^ACHS(3,D0,1,D1,"CC",D2))'>0  X:$D(DSC(9002063.03)) DSC(9002063.03) S D2=$O(^(D2)) Q:D2'>0  D:$X>46 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^ACHS(3,D0,1,D1,"CC",D2,0)) W ?46 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACHS(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,3)
 W ?54,$E($P(X,U,2),1,6)
 W ?63,$E($P(X,U,3),1,6)
 W ?72,$E($P(X,U,4),1,6)
 Q
A2R ;
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?54,"DCR",?63,"DCR",?72,"DCR"
 W !,?32,"PAYMENT",?46,"COST",?54,"ACCOUNT",?63,"ACCOUNT",?72,"ACCOUNT"
 W !,?0,"FACILITY",?12,"CODE",?18,"DESCRIPTION",?32,"DESTINATION",?46,"CENTER",?54,"NUMBER",?63,"# 2",?72,"# 3"
 W !,"--------------------------------------------------------------------------------",!!

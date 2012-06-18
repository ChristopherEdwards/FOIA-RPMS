ACHSCPT ; IHS/ITSC/PMF - GENERATED FROM 'ACHSRPTCPTREVP' PRINT TEMPLATE (#2009) 09/18/97 (FILE 9002080, MARGIN=80) ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2009,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S I(1)="""D""",J(1)=9002080.01 F D1=0:0 Q:$O(^ACHSF(D0,"D",D1))'>0  X:$D(DSC(9002080.01)) DSC(9002080.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACHSF(D0,"D",D1,0)) W ?0 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 S I(2)=11,J(2)=9002080.197 F D2=0:0 Q:$O(^ACHSF(D0,"D",D1,11,D2))'>0  X:$D(DSC(9002080.197)) DSC(9002080.197) S D2=$O(^(D2)) Q:D2'>0  D:$X>5 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^ACHSF(D0,"D",D1,11,D2,0)) D N:$X>6 Q:'DN  W ?6 S Y=$P(X,U,1) S C=$P($G(^DD(9002080.197,.01,0)),U,2) D Y^DIQ:Y S C="," W $E(Y,1,5)
 D N:$X>13 Q:'DN  W ?13 S Y=$P(X,U,2) D DT
 D N:$X>25 Q:'DN  W ?25 S Y=$P(X,U,3) D DT
 D N:$X>37 Q:'DN  W ?37 S Y=$P(X,U,4),C=1 D S:Y]"" W:Y]"" $J(Y,4,0)
 W ?44 S Y=$P(X,U,5),C=2 D S:Y]"" W:Y]"" $J(Y,8,2)
 W ?54 S Y=$P(X,U,6),C=3 D S:Y]"" W:Y]"" $J(Y,8,2)
 D N:$X>65 Q:'DN  W ?65,$E($P(X,U,7),1,4)
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,8) W:Y]"" $J(Y,2,0)
 D N:$X>75 Q:'DN  W ?75,$J($P(X,U,9),5)
 Q
A2R ;
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?6,"CPT/REV/ADA"
 W !,?0,"TOS",?6,"CODE"
 W !,?45,"CHARGES",?55,"CHARGES"
 W !,?13,"DOS FROM",?25,"DOS TO",?37,"UNITS",?46,"BILLED",?54,"ALLOWABLE",?65,"MSG",?71,"TH",?76,"SURF"
 W !,"--------------------------------------------------------------------------------",!!

ACHSOCM ; IHS/ITSC/PMF - GENERATED FROM 'ACHSRPTOPTCOMMP' PRINT TEMPLATE (#5201) 11/26/97 (FILE 9002080, MARGIN=80) ; [ 10/16/2001   8:16 AM ]
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(5201,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S I(1)="""D""",J(1)=9002080.01 F D1=0:0 Q:$O(^ACHSF(D0,"D",D1))'>0  X:$D(DSC(9002080.01)) DSC(9002080.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACHSF(D0,"D",D1,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,13),1,10)
 W ?12 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 W ?17 S Y=$P(X,U,2) D DT
 W ?31 S Y=$P(X,U,1) S Y(0)=Y S:Y>0&($D(D0))&($D(D1)) Y=$P(^ACHSF(D0,"D",D1,0),U,14)_"-"_$P(^AUTTAREA($P(^AUTTLOC(D0,0),U,4),0),U,3)_$E($P(^AUTTLOC(D0,0),U,17),2,3)_"-"_Y W $E(Y,1,12)
 S X=$G(^ACHSF(D0,"D",D1,0)) W ?45 S Y=$P(X,U,9),C=1 D P:Y]"" W:Y]"" $J(Y,10,2)
 S X=$G(^ACHSF(D0,"D",D1,"PA")) W ?57 S Y=$P(X,U,2),C=2 D P:Y]"" W:Y]"" $J(Y,10,2)
 W ?69 S Y=$P(X,U,1),C=3 D P:Y]"" W:Y]"" $J(Y,10,2)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?0,"COMMENT",?12,"TOS",?17,"ORDER DATE",?31,"ORDER NUMBER",?45,"AMT OBLIG.",?57,"AMT ADJUST",?71,"AMT PAID"
 W !,"--------------------------------------------------------------------------------",!!

ACHSHLG ; IHS/ITSC/PMF - GENERATED FROM 'ACHSRPTHOSPLOGP' PRINT TEMPLATE (#5204) 11/26/97 (FILE 9002080, MARGIN=132) ; [ 10/16/2001   8:16 AM ]
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(5204,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S I(1)="""D""",J(1)=9002080.01 F D1=0:0 Q:$O(^ACHSF(D0,"D",D1))'>0  X:$D(DSC(9002080.01)) DSC(9002080.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACHSF(D0,"D",D1,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,22) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,22)
 D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,26)
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^ACHSF(D0,"D",D1,0)):^(0),1:"") S X=$P(DIP(1),U,2) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,11)
 D N:$X>64 Q:'DN  W ?64 S DIP(1)=$S($D(^ACHSF(D0,"D",D1,3)):^(3),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,11)
 S X=$G(^ACHSF(D0,"D",D1,1)) D N:$X>77 Q:'DN  W ?77 S Y=$P(X,U,1),C=1 D P:Y]"" W:Y]"" $J(Y,3,0)
 S X=$G(^ACHSF(D0,"D",D1,0)) D N:$X>86 Q:'DN  W ?86,$E($P(X,U,13),1,10)
 D N:$X>97 Q:'DN  W ?97 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S Y(0)=Y S:Y>0&($D(D0))&($D(D1)) Y=$P(^ACHSF(D0,"D",D1,0),U,14)_"-"_$P(^AUTTAREA($P(^AUTTLOC(D0,0),U,4),0),U,3)_$E($P(^AUTTLOC(D0,0),U,17),2,3)_"-"_Y W $E(Y,1,11)
 S X=$G(^ACHSF(D0,"D",D1,1)) D N:$X>24 Q:'DN  W ?24,$E($P(X,U,2),1,30)
 S X=$G(^ACHSF(D0,"D",D1,0)) D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>106 Q:'DN  W ?106 S Y=$P(X,U,9),C=2 D A:Y]"" W:Y]"" $J(Y,12,2)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?0,"PATIENT NAME",?24,"PROVIDER OF SERVICE",?51,"ISSUE DATE",?64,"DOS",?77,"DAYS",?86,"COMMENT",?97,"STATUS"
 W !,?0,"PDO",?24,"DESCRIPTION OF SERVICE",?66,"TYPE",?112,"AMOUNT"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!

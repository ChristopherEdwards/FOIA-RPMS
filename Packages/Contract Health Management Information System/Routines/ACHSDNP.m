ACHSDNP ; GENERATED FROM 'ACHSPDENP' PRINT TEMPLATE (#1058) ; 12/12/01 ; (FILE 9002071, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1058,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^ACHSDEN(D0,0)) W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACHSDENR(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 S I(1)="""D""",J(1)=9002071.01 F D1=0:0 Q:$O(^ACHSDEN(D0,"D",D1))'>0  X:$D(DSC(9002071.01)) DSC(9002071.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>32 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACHSDEN(D0,"D",D1,100)) W ?32,$E($P(X,U,3),1,30)
 W ?64 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D T Q:'DN  W ?4 S Y=$P(X,U,8),C=1 D A:Y]"" W:Y]"" $J(Y,11,2)
 W ?17 S Y=$P(X,U,9),C=2 D A:Y]"" W:Y]"" $J(Y,11,2)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !
 W !,?64,"TYPE OF"
 W !,?0,"DENIAL FACILITY",?32,"PRIMARY PROVIDER (NOT ON-FILE)",?64,"SERVICE"
 W !,?22,"ACTUAL"
 W !,?4,"EST. CHARGE",?21,"CHARGES"
 W !,?9,"(PRIM.",?22,"(PRIM."
 W !,?9,"PROV.)",?22,"PROV.)"
 W !,"--------------------------------------------------------------------------------",!!

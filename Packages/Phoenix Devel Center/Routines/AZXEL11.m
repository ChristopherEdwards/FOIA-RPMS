AZXEL11 ; GENERATED FROM 'AZXELEE6' PRINT TEMPLATE (#632) ; 12/03/91 ; (FILE 1991003, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 S X=$S($D(^AZXELEE1(1991003,D0,0)):^(0),1:"") W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^PSDRUG(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 S I(1)=1,J(1)=1991003.01 F D1=0:0 Q:$N(^AZXELEE1(1991003,D0,1,D1))'>0  X:$D(DSC(1991003.01)) DSC(1991003.01) S D1=$N(^(D1)) Q:D1'>0  D:$X>42 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$S($D(^AZXELEE1(1991003,D0,1,D1,0)):^(0),1:"") W ?42 S Y=$P(X,U,1) D DT
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?42,"EXPIRATION"
 W !,?0,"NAME OF DRUG",?42,"DATE"
 W !,"--------------------------------------------------------------------------------",!!

AZXPSPL ; GENERATED FROM 'AZXPSOLLIST' PRINT TEMPLATE (#411)  [ 05/21/90  11:42 AM ]
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
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 W ?0 S Y=D0 D DT
 S X=$S($D(^XUSEC(0,D0,0)):^(0),1:"") W ?20 S Y=$P(X,U,4) D DT
 W ?40 X ^DD(3.081,98,9.2) S Y(3.081,98,101)=$S($D(^%ZIS(1,D0,1)):^(1),1:"") S X=$P(Y(3.081,98,101),U,1) S D0=Y(3.081,98,2) W $E(X,1,25) K Y(3.081,98)
 W ?67 S X1=$P(^XUSEC(0,D0,0),U,4),X="" Q:X1<2000000  S X=D0,Y=$E(X1_"000",9,10)-$E(X_"000",9,10)*60+$E(X1_"00000",11,12)-$E(X_"00000",11,12),X2=X,X=$P(X,".",1)'=$P(X1,".",1) D ^%DTC:X S X=X*1440+Y W $E(X,1,8) K Y(3.081,99) S Y=X,C=1 D A:Y'?."*"
 K Y
 Q
HEAD ;
 W !,?67,"ELAPSED"
 W !,?67,"TIME"
 W !,?0,"SIGNON TIME",?20,"SIGNOFF TIME",?40,"LOCATION",?67,"(MINUTES)"
 W !,"--------------------------------------------------------------------------------",!!

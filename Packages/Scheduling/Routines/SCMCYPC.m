SCMCYPC ; GENERATED FROM 'SCMC DIRECT PC FTEE' PRINT TEMPLATE (#3589) ; 10/29/04 ; (FILE 404.52, MARGIN=132)
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
 S I(0)="^SCTM(404.52,",J(0)=404.52
 S X=$G(^SCTM(404.52,D0,0)) W ?0 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 S I(100)="^SCTM(404.57,",J(100)=404.57 S I(0,0)=D0 S DIP(1)=$S($D(^SCTM(404.52,D0,0)):^(0),1:"") S X=$P(DIP(1),U,1),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S X=$G(^SCTM(404.57,D0,0)) W ?32 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^SCTM(404.51,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 W ?59,$E($P(X,U,1),1,25)
 W ?86 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^SC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S X=$G(^SCTM(404.52,D0,0)) W ?113 S Y=$P(X,U,9),C=1 D A:Y]"" W $E(Y,1,4)
 K Y
 Q
HEAD ;
 W !,?113,"Direct"
 W !,?113,"PC"
 W !,?0,"PRACTITIONER",?32,"TEAM",?59,"POSITION",?86,"CLINIC",?113,"FTEE"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!

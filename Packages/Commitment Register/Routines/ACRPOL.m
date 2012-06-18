ACRPOL ; GENERATED FROM 'ACR PURCHASE ORDER LOG' PRINT TEMPLATE (#3955) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3955,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 S X=$G(^ACRDOC(D0,0)) W:$X>8 ! D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) S:Y]"" N(1)=N(1)+1 W $E(Y,1,13)
 X DXS(1,9) K DIP K:DN Y W X
 S X=$G(^ACRDOC(D0,0)) W ?15,$E($P(X,U,1),1,17)
 W ?34 S DIP(1)=$S($D(^ACRDOC(D0,"PO")):^("PO"),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 S X=$G(^ACRDOC(D0,"PO")) W ?44 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 W ?66 D SSTOT^ACRFPOL K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,?66,"D"
 W !,?0,"PO NUMBER",?15,"REQ NUMBER",?34,"DATE",?44,"CONTRACTOR",?66,"SSTOT^ACRFPOL"
 W !,"--------------------------------------------------------------------------------",!!

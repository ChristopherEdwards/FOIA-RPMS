LR63IPRE ;DALISC/FHS - LR63 PRE INITS
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LR63 1ST TIME INSTALL;;Sep 27, 1994
EN1 ;
 I $S('$D(DUZ):1,'$D(^VA(200,+DUZ)):1,'$D(IO):1,1:0) G DUZ
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) G DUZ0
 S LRSITE=+$P($G(^XMB(1,1,"XUS")),U,17) I 'LRSITE K DIQF W !!?10,"Your Site is not defined in the 17th. Piece of ^XMB(1,1,XUS) global " Q
EN ;
 W !!?5,"This init will over write your DATA NAMES (#63) "
 W !,"Are you sure this is what you want" S %=2 D YN^DICN
 K:%'=1 DIFQ
 Q
DUZ W !!?10,"Please log in using access and verify codes",!!,$C(7) K DIFQ Q
DUZ0 W !!?10,"You do not have programmer access in your fileman access code",!!,$C(7) K DIFQ Q

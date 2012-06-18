ACRPTS ; GENERATED FROM 'ACR TRAINING SUMMARY' PRINT TEMPLATE (#3940) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
 G BEGIN
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
 S I(0)="^ACRDOC(",J(0)=9002196
 S X=$G(^ACRDOC(D0,0)) W ?0,$E($P(X,U,1),1,12)
 S X=$G(^ACRDOC(D0,"TRNG")) D N:$X>13 Q:'DN  W ?13 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRAU(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>34 Q:'DN  W ?34,$E($P(X,U,18),1,24)
 D N:$X>59 Q:'DN  W ?59 S DIP(1)=$S($D(^ACRDOC(D0,"TRNG")):^("TRNG"),1:"") S X=$P(DIP(1),U,11) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 D N:$X>68 Q:'DN  W ?68 S DIP(1)=$S($D(^ACRDOC(D0,"TRNG")):^("TRNG"),1:"") S X=$P(DIP(1),U,12) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 D N:$X>77 Q:'DN  W ?77 S DIP(1)=$S($D(^ACRDOC(D0,"TRNG")):^("TRNG"),1:"") S X=$P(DIP(1),U,9)+$P(DIP(1),U,10) K DIP K:DN Y W $E(X,1,3)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

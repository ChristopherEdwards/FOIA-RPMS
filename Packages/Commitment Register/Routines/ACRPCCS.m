ACRPCCS ; GENERATED FROM 'ACR CREDIT CARD SUMMARY' PRINT TEMPLATE (#3952) ; 09/29/09 ; (FILE 9002193, MARGIN=132)
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
 S I(0)="^ACRSS(",J(0)=9002193
 S X=$G(^ACRSS(D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,14)
 S X=$G(^ACRSS(D0,"DESC")) W ?16,$E($P(X,U,1),1,30)
 S X=$G(^ACRSS(D0,0)) W ?48 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^ACRCAN(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^AUTTCAN(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,7)
 W ?57 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^AUTTOBJC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 W ?63 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,1),DIP(2)=X S X=6,X=$J(DIP(2),X) K DIP K:DN Y W $E(X,1,6)
 S X=$G(^ACRSS(D0,"DT")) W ?71 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRUI(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 W "  "
 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,3),X2="2$" D COMMA^%DTC S X=X_$E("00",1,2-$L($P(X,".",2))) K X2 K DIP K:DN Y W $E(X,1,14)
 W "  "
 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,4),X2="2$" D COMMA^%DTC S X=X_$E("00",1,2-$L($P(X,".",2))) K X2 K DIP K:DN Y W $E(X,1,14)
 W "  "
 W:$P($G(^ACRSS(D0,"DT")),U,11)="" "        " K DIP K:DN Y
 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,11) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,10)
 W "  "
 S DIP(1)=$S($D(^ACRSS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,21),X2="2$" D COMMA^%DTC S X=X_$E("00",1,2-$L($P(X,".",2))) K X2 K DIP K:DN Y W $E(X,1,14)
 S X=$G(^ACRSS(D0,"DESC")) D N:$X>16 Q:'DN  W ?16,$E($P(X,U,2),1,30)
 D N:$X>16 Q:'DN  W ?16,$E($P(X,U,3),1,30)
 D N:$X>16 Q:'DN  W ?16,$E($P(X,U,4),1,30)
 D N:$X>16 Q:'DN  W ?16,$E($P(X,U,5),1,30)
 K Y
 Q
HEAD ;
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!

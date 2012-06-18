ACRPRCA ; GENERATED FROM 'ACR REQUEST CONTROLLER AUDIT' PRINT TEMPLATE (#3958) ; 09/30/09 ; (FILE 9002190, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3958,"DXS")
 S I(0)="^ACRAPVS(",J(0)=9002190
 S X=$G(^ACRAPVS(D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,15)
 S X=$G(^ACRAPVS(D0,"DT")) W ?17 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 W ?26 S Y=$P(X,U,6) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 W ?48 S DIP(1)=$S($D(^ACRAPVS(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,4) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 S X=$G(^ACRAPVS(D0,0)) W ?58 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^ACRAPVT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

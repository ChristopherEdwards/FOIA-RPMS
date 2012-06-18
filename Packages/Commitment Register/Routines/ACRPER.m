ACRPER ; GENERATED FROM 'ACR ARMS USER ADDRESS' PRINT TEMPLATE (#3947) ; 09/30/09 ; (FILE 9002185.3, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3947,"DXS")
 S I(0)="^ACRAU(",J(0)=9002185.3
 D N:$X>4 Q:'DN  W ?4 W "NAME:"
 S X=$G(^ACRAU(D0,0)) W ?11 S Y=$P(X,U,1) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>54 Q:'DN  W ?54 W "SSN:"
 W ?60 X DXS(1,9.2) S X=$P(DIP(101),U,9) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^ACRAU(D0,1)):^(1),1:"") S X=$P(DIP(1),U,3),X=X K DIP K:DN Y W X
 W "-"
 S X=$G(^ACRAU(D0,1)) S Y=$P(X,U,4) W:Y]"" $J(Y,3,0)
 D N:$X>11 Q:'DN  W ?11 X DXS(2,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 X DXS(3,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 X DXS(4,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(5,9) K DIP K:DN Y W X
 W "  "
 X DXS(6,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W X
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

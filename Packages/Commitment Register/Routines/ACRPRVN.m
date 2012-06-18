ACRPRVN ; GENERATED FROM 'ACR VENDOR DISPLAY' PRINT TEMPLATE (#3894) ; 09/29/09 ; (FILE 9999999.11, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3894,"DXS")
 S I(0)="^AUTTVNDR(",J(0)=9999999.11
 S X=$G(^AUTTVNDR(D0,0)) D N:$X>4 Q:'DN  W ?4,$E($P(X,U,1),1,30)
 D N:$X>44 Q:'DN  W ?44 W "EIN:"
 S X=$G(^AUTTVNDR(D0,11)) W ?50,$E($P(X,U,13),1,12)
 S X=$G(^AUTTVNDR(D0,13)) D N:$X>4 Q:'DN  W ?4,$E($P(X,U,1),1,30)
 D N:$X>4 Q:'DN  W ?4,$E($P(X,U,10),1,30)
 D N:$X>4 Q:'DN  W ?4,$E($P(X,U,2),1,20)
 W ", "
 W ?26 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 S X=$G(^AUTTVNDR(D0,13)) W ?37,$E($P(X,U,4),1,10)
 D N:$X>4 Q:'DN  W ?4 W "ATTN:"
 W ?11,$E($P(X,U,5),1,20)
 D N:$X>4 Q:'DN  W ?4 W "PHONE:"
 S X=$G(^AUTTVNDR(D0,11)) W ?12,$E($P(X,U,9),1,15)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

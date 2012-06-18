ACRPCCV ; GENERATED FROM 'ACR CREDIT CARD VENDOR' PRINT TEMPLATE (#3954) ; 09/30/09 ; (FILE 9999999.11, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3954,"DXS")
 S I(0)="^AUTTVNDR(",J(0)=9999999.11
 D N:$X>0 Q:'DN  W ?0 W "VENDOR:"
 S X=$G(^AUTTVNDR(D0,0)) W ?9,$E($P(X,U,1),1,30)
 D N:$X>49 Q:'DN  W ?49 W "EIN.:"
 S X=$G(^AUTTVNDR(D0,11)) W ?56,$E($P(X,U,13),1,12)
 D N:$X>9 Q:'DN  W ?9 W "ATTENTION:"
 S X=$G(^AUTTVNDR(D0,13)) W ?21,$E($P(X,U,5),1,20)
 D N:$X>49 Q:'DN  W ?49 W "DUNS:"
 S X=$G(^AUTTVNDR(D0,0)) W ?56,$E($P(X,U,7),1,13)
 S X=$G(^AUTTVNDR(D0,13)) D N:$X>9 Q:'DN  W ?9,$E($P(X,U,1),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,10),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,2),1,20)
 W ", "
 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W "  "
 W ?0,$E($P(X,U,4),1,10)
 D N:$X>9 Q:'DN  W ?9 W "PHONE: "
 S X=$G(^AUTTVNDR(D0,11)) W ?0,$E($P(X,U,9),1,15)
 D N:$X>40 Q:'DN  W ?40 W "FAX: "
 W ?0,$E($P(X,U,14),1,12)
 D N:$X>9 Q:'DN  W ?9 W "TYPE OF BUSINESS:"
 W ?28 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

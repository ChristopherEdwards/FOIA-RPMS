ACRPTOH ; GENERATED FROM 'ACR TRAVEL ORDER HEAD' PRINT TEMPLATE (#3889) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3889,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 D N:$X>0 Q:'DN  W ?0 W "|"
 D N:$X>14 Q:'DN  W ?14 W "DHHS/INDIAN HEALTH SERVICE - OFFICIAL TRAVEL ORDER"
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|"
 S X=$G(^ACRDOC(D0,"TO")) W ?3 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 W ?14 W "TRAVEL ORDER #:"
 S X=$G(^ACRDOC(D0,0)) W ?31,$E($P(X,U,1),1,17)
 W ?50 W "APPROPRIATION #:"
 W ?68 X DXS(1,9.2) S X=$P($G(^AUTTPRO(+$P(DIP(101),U,4),0)),U) S D0=I(0,0) K DIP K:DN Y W $E(X,1,10)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|"
 D N:$X>12 Q:'DN  W ?12 W "DHHS #:  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|------------------------------------------------------------------------------|"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

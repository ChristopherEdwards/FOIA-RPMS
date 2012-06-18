ACRPTOS1 ; GENERATED FROM 'ACR TRAVEL ORDER SUMMARY' PRINT TEMPLATE (#3962) ; 09/29/09 ; (continued)
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
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|EXCESS BAGAGE...:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?20 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|TEMPORARY STORAGE.:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|REGISTRATION FEE:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?20 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|HOUSE HUNT TRIP...:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|TRAVEL ADVANCE..:"
 S X=$G(^ACRDOC(D0,"TO")) W ?20 S Y=$P(X,U,19) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|MISC EXP ALLOWANCE:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|ATM ALLOWED.....:"
 S X=$G(^ACRDOC(D0,"TO")) W ?20 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|OTHER.............:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?62 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|------------------------------------------------------------------------------|"
 D ^ACRFPSS K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

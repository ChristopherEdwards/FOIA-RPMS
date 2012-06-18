ACR130 ; GENERATED FROM 'ACR TRAVEL ORDER DISPLAY' PRINT TEMPLATE (#3853) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3853,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 K ACRX K DIP K:DN Y
 W ?11 X DXS(1,9) K DIP K:DN Y
 W ?22 X DXS(2,9) K DIP K:DN Y
 W ?33 X DXS(3,9) K DIP K:DN Y
 W ?44 X DXS(4,9) K DIP K:DN Y
 W ?55 X DXS(5,9) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "[1 ]*ORIG/AMEND:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[16] OTHER.....:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?58 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[2 ] ORDR AMEND:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,20) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>40 Q:'DN  W ?40 W "[17] SPECIFY...:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?58,$E($P(X,U,7),1,15)
 D N:$X>0 Q:'DN  W ?0 W "[3 ]*TRAVELER..:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,9) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[18] PCS TRANS.:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "     POSITION..:"
 W ?18 I $D(ACREMPDA),ACREMPDA W $E($P($G(^VA(200,ACREMPDA,20)),U,3),1,20) K DIP K:DN Y
 D N:$X>40 Q:'DN  W ?40 W "[19] TEMP QTRS.:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "     RANK......:"
 W ?18 I $D(ACREMP),ACREMP]"" W $P(ACREMP,U,3)_"-"_$P(ACREMP,U,4) K DIP K:DN Y
 D N:$X>40 Q:'DN  W ?40 W "[20] RESID TRNS:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[4 ]*ORGANIZATN:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,12) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[21] TEMP STOR.:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[5 ]*STATION...:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "[22] HOUSE HUNT:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[6 ]*DEPARTURE.:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,14) D DT
 D N:$X>40 Q:'DN  W ?40 W "[23] MISCELANOS:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[7 ] RETURN....:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,15) D DT
 D N:$X>40 Q:'DN  W ?40 W "[24] 355 SIGNED:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?58 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[8 ] POV.......:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?18 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[25]*TRAVELER..:"
 W ?58 I $D(ACRX(18,1)),ACRX(18,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TO")) S Y=$P(X,U,18) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[9 ] MILE RATE.:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?18 S Y=$P(X,U,10) W:Y]"" $J(Y,6,3)
 D N:$X>40 Q:'DN  W ?40 W "[26]*RECMD'D BY:"
 W ?58 I $D(ACRX(16,1)),ACRX(16,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TO")) S Y=$P(X,U,16) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[10] GSA VEHICL:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?18 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[27] TITLE.....:"
 S X=$G(^ACRDOC(D0,"TO")) W ?58,$E($P(X,U,17),1,20)
 D N:$X>0 Q:'DN  W ?0 W "[11] AUTO RENT.:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?18 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[28]*AUTHRZD BY:"
 W ?58 I $D(ACRX(2,1)),ACRX(2,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"TOAU")) S Y=$P(X,U,2) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[12] EXC BAGAGE:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?18 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(19,Y)):DXS(19,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[29] TITLE.....:"
 S X=$G(^ACRDOC(D0,"TOAU")) W ?58,$E($P(X,U,1),1,20)
 D N:$X>0 Q:'DN  W ?0 W "[13] REGIS FEE.:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?18 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(20,Y)):DXS(20,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[30] ATM ATHZD.:"
 S X=$G(^ACRDOC(D0,"TO")) W ?58 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(21,Y)):DXS(21,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "[14] PD RATE...:"
 W ?18 X DXS(6,9) K DIP K:DN Y W X
 D N:$X>40 Q:'DN  W ?40 W "[31]*FUNDS AVAL:"
 W ?58 I $D(ACRX(1,1)),ACRX(1,1)'="" W "#" K DIP K:DN Y
 S X=$G(^ACRDOC(D0,"FA")) S Y=$P(X,U,2) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "[15] TRAVEL ADV:"
 S X=$G(^ACRDOC(D0,"TO")) W ?18 S Y=$P(X,U,19) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "[32]*IDENTIFIER:"
 S X=$G(^ACRDOC(D0,0)) W ?58,$E($P(X,U,14),1,16)
 D N:$X>40 Q:'DN  W ?40 W "[33] COST COMP.:"
 S X=$G(^ACRDOC(D0,"TOAU")) W ?58 S Y=$P(X,U,6) W:Y]"" $J(Y,8,2)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

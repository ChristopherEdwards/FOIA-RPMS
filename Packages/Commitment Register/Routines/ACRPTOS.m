ACRPTOS ; GENERATED FROM 'ACR TRAVEL ORDER SUMMARY' PRINT TEMPLATE (#3962) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3962,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 X DXS(1,9) K DIP K:DN Y
 S ACRDATE=$P(^ACROBL(D0,0),U,6) K DIP K:DN Y
 I $E($G(IOST),1,2)="C-" W "ARMS REF: ",$P(^ACRDOC(D0,0),U,6),"/",D0 K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "________________________________________________________________________________"
 D N:$X>0 Q:'DN  W ?0 W "| DHHS/INDIAN HEALTH SERVICE - OFFICIAL TRAVEL ORDER"
 W ?$X+6,"(PREPARED: ",$E(ACRDATE,4,5),"-",$E(ACRDATE,6,7),"-",$E(ACRDATE,2,3),")" K DIP K:DN Y
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|"
 S X=$G(^ACRDOC(D0,"TO")) W ?3 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 W ?14 W "TRAVEL ORDER #:"
 S X=$G(^ACRDOC(D0,0)) W ?31,$E($P(X,U,1),1,17)
 D N:$X>49 Q:'DN  W ?49 W "APPROPRIATION #:"
 W ?67 X DXS(2,9.2) S X=$P($G(^AUTTPRO(+$P(DIP(101),U,4),0)),U) S D0=I(0,0) K DIP K:DN Y W $E(X,1,10)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|"
 D N:$X>7 Q:'DN  W ?7 W "DHHS ORDER #: "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|------------------------------------------------------------------------------|"
 D N:$X>0 Q:'DN  W ?0 W "|TRAVELER........:"
 S X=$G(^ACRDOC(D0,"TO")) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,9) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>51 Q:'DN  W ?51 W "|SSN.....:"
 W ?63 W $$PSSN^ACRFUTL(ACREMPDA,$G(DUZ),$G(IOST),$G(ACRSSNOK)) K DIP K:DN Y
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|POSITION........:"
 D N:$X>19 Q:'DN  W ?19 I $D(ACREMPDA) W $P($G(^VA(200,ACREMPDA,20)),U,3) K DIP K:DN Y
 D N:$X>51 Q:'DN  W ?51 W "|PAY PLAN:"
 W ?63 I $D(ACREMP),$P(ACREMP,U,3)]"" W $P(ACREMP,U,3),"-",$P(ACREMP,U,4) K DIP K:DN Y
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|BUREAU/DIVISION.:"
 S X=$G(^ACRDOC(D0,"TO")) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,12) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>51 Q:'DN  W ?51 W "|DEPART..:"
 W ?63 S Y=$P(X,U,14) D DT
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|OFFICIAL STATION:"
 D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>51 Q:'DN  W ?51 W "|RETURN..:"
 W ?63 S Y=$P(X,U,15) D DT
 D N:$X>79 Q:'DN  W ?79 W "|"
 D PAUSE^ACRFWARN K DIP K:DN Y
 D ITIN^ACRFSS43 K DIP K:DN Y
 S ACRY="COMMENTS" D NOTES^ACRFSSD1 K DIP K:DN Y
 S ACRY="PURPOSE OF TRAVEL" D JUST^ACRFSSD1 K DIP K:DN Y
 I $D(^ACRTV("C",D0)) D ^ACRFSSRC K DIP K:DN Y
 D PAUSE^ACRFWARN K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "|------- SPECIAL AUTHORIZATIONS --------"
 D N:$X>40 Q:'DN  W ?40 W "---------- CHANGE OF STATION ----------"
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|TRAVEL BY POV...:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?20 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|TRANS DEPENDENTS..:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|MILEAGE RATE....:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?20 S Y=$P(X,U,10) W:Y]"" $J(Y,6,3)
 D N:$X>40 Q:'DN  W ?40 W "|TRANS H/H GOODS...:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|GSA AUTO........:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?20 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|TEMPORARY QUARTERS:"
 S X=$G(^ACRDOC(D0,"TOPCS")) W ?62 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>79 Q:'DN  W ?79 W "|"
 D N:$X>0 Q:'DN  W ?0 W "|AUTO RENTAL.....:"
 S X=$G(^ACRDOC(D0,"TOSA")) W ?20 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "|RESIDENCE TRANS...:"
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

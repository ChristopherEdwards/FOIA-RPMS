ACRPHOT ; GENERATED FROM 'ACR HOTEL' PRINT TEMPLATE (#3895) ; 09/29/09 ; (FILE 9002193.1, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3895,"DXS")
 S I(0)="^ACRHOTEL(",J(0)=9002193.1
 D N:$X>4 Q:'DN  W ?4 W "HOTEL...........:"
 S X=$G(^ACRHOTEL(D0,0)) W ?23,$E($P(X,U,1),1,30)
 D N:$X>54 Q:'DN  W ?54 W "MEETS FIRE CODE:"
 W ?72 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>4 Q:'DN  W ?4 W "STREET..........:"
 S X=$G(^ACRHOTEL(D0,"DT")) W ?23,$E($P(X,U,1),1,30)
 D N:$X>4 Q:'DN  W ?4 W "CITY............:"
 W ?23 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "STATE...........:"
 W ?23 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "TOLL FREE NUMBER:"
 W ?23,$E($P(X,U,5),1,12)
 D N:$X>4 Q:'DN  W ?4 W "PHONE NUMBER....:"
 W ?23,$E($P(X,U,4),1,12)
 D N:$X>4 Q:'DN  W ?4 W "FAX NUMBER......:"
 W ?23,$E($P(X,U,6),1,12)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

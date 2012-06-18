ACRPTVI ; GENERATED FROM 'ACR TRAVEL VOUCHER ITINERARY' PRINT TEMPLATE (#3866) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3866,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 D N:$X>0 Q:'DN  W ?0 W "----------------------------  AIRLINE INFORMATION  -----------------------------"
 D N:$X>0 Q:'DN  W ?0 W "--CARRIER--"
 D N:$X>13 Q:'DN  W ?13 W "FLIGHT"
 D N:$X>20 Q:'DN  W ?20 W "---DATE----"
 D N:$X>33 Q:'DN  W ?33 W "TIME"
 D N:$X>41 Q:'DN  W ?41 W "-------CITY-------"
 D N:$X>61 Q:'DN  W ?61 W "AGENT'S VALUATION"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002193.7)) X DSC(9002193.7) E  Q
 W:$X>80 ! S I(100)="^ACRAL(",J(100)=9002193.7
 S X=$G(^ACRAL(D0,"DT")) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRACOMP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,11)
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,3),1,4)
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,4) D DT
 D N:$X>41 Q:'DN  W ?41 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 D N:$X>61 Q:'DN  W ?61 S DIP(101)=$S($D(^ACRAL(D0,"DT")):^("DT"),1:"") S X=$P(DIP(101),U,9),DIP(102)=X S X=10,X=$J(DIP(102),X) K DIP K:DN Y W X
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

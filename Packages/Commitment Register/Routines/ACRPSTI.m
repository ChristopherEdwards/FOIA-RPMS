ACRPSTI ; GENERATED FROM 'ACR SEPARATE TRAVEL ITINERARY' PRINT TEMPLATE (#3901) ; 09/30/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3901,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 S ACRDOCDA=D0,ACRREFX=130 K DIP K:DN Y
 W ?11 D SETDOC^ACRFEA1 K DIP K:DN Y
 D DISPLAY^ACRFSS42 K DIP K:DN Y
 D T Q:'DN  D N D N:$X>19 Q:'DN  W ?19 W "TRAVEL ITINERARY"
 D T Q:'DN  D N W ?0 W "TRAVEL ORDER NO.:"
 S X=$G(^ACRDOC(D0,0)) W ?19,$E($P(X,U,1),1,17)
 D N:$X>39 Q:'DN  W ?39 W "TRAVELER:"
 S X=$G(^ACRDOC(D0,"TO")) W ?50 S Y=$P(X,U,9) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "DHHS #:  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D T Q:'DN  D N W ?0 W "AIRLINE INFORMATION"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>2 Q:'DN  W ?2 W "CARRIER"
 D N:$X>14 Q:'DN  W ?14 W "NO."
 D N:$X>23 Q:'DN  W ?23 W "DATE"
 D N:$X>33 Q:'DN  W ?33 W "TIME"
 D N:$X>48 Q:'DN  W ?48 W "CITY"
 D N:$X>61 Q:'DN  W ?61 W "SEAT"
 D N:$X>0 Q:'DN  W ?0 W "==========="
 D N:$X>13 Q:'DN  W ?13 W "====="
 D N:$X>20 Q:'DN  W ?20 W "==========="
 D N:$X>33 Q:'DN  W ?33 W "====="
 D N:$X>41 Q:'DN  W ?41 W "=================="
 D N:$X>61 Q:'DN  W ?61 W "===="
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$G(D0) X DXS(1,9.3) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002193.7)) X DSC(9002193.7) E  Q
 W:$X>67 ! S I(100)="^ACRAL(",J(100)=9002193.7
 S X=$G(^ACRAL(D0,"DT")) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRACOMP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,11)
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,3),1,4)
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,4) D DT
 D N:$X>41 Q:'DN  W ?41 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 D N:$X>61 Q:'DN  W ?61,$E($P(X,U,8),1,4)
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,6) D DT
 D N:$X>41 Q:'DN  W ?41 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 W ?61 I IOSL-4<$Y W ! D PAUSE^ACRFWARN W @IOF K DIP K:DN Y
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "LODGING AND CAR RENTAL INFORMATION"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>3 Q:'DN  W ?3 W "DATE"
 D N:$X>14 Q:'DN  W ?14 W "HOTEL/CAR RENTAL"
 D N:$X>36 Q:'DN  W ?36 W "PHONE"
 D N:$X>48 Q:'DN  W ?48 W "CONFIRMATION"
 D N:$X>64 Q:'DN  W ?64 W "GUARANTEED"
 D N:$X>0 Q:'DN  W ?0 W "==========="
 D N:$X>13 Q:'DN  W ?13 W "=================="
 D N:$X>33 Q:'DN  W ?33 W "============"
 D N:$X>47 Q:'DN  W ?47 W "==============="
 D N:$X>64 Q:'DN  W ?64 W "================"
 S DIXX(1)="B1",I(0,0)=D0 S I(0,0)=$G(D0) X DXS(2,9.3) S X="" S D0=I(0,0)
 G B1R
B1 ;
 I $D(DSC(9002193.5)) X DSC(9002193.5) E  Q
 W:$X>82 ! S I(100)="^ACRTV(",J(100)=9002193.5
 S X=$G(^ACRTV(D0,"DT")) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) D DT
 D N:$X>13 Q:'DN  W ?13 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^ACRHOTEL(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 D N:$X>33 Q:'DN  W ?33 X DXS(3,9.2) S X=$P(DIP(201),U,4) S D0=I(100,0) K DIP K:DN Y W X
 S X=$G(^ACRTV(D0,"DT")) D N:$X>47 Q:'DN  W ?47,$E($P(X,U,12),1,15)
 D N:$X>64 Q:'DN  W ?64 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>13 Q:'DN  W ?13 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^ACRRCOMP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 D N:$X>33 Q:'DN  W ?33 X DXS(4,9.2) S X=$P(DIP(201),U,2) S D0=I(100,0) K DIP K:DN Y W X
 S X=$G(^ACRTV(D0,"DT")) D N:$X>47 Q:'DN  W ?47,$E($P(X,U,14),1,15)
 W ?64 I IOSL-4<$Y W ! D PAUSE^ACRFWARN W @IOF K DIP K:DN Y
 Q
B1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  W ?2 I IOSL-4<$Y D PAUSE^ACRFWARN K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

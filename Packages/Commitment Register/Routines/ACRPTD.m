ACRPTD ; GENERATED FROM 'ACR TRAVEL DAY' PRINT TEMPLATE (#3876) ; 09/29/09 ; (FILE 9002193.5, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3876,"DXS")
 S I(0)="^ACRTV(",J(0)=9002193.5
 W ?0 X DXS(1,9) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "TRAVEL DAY..:"
 S X=$G(^ACRTV(D0,0)) W ?15 S Y=$P(X,U,1) W:Y]"" $J(Y,4,0)
 D N:$X>40 Q:'DN  W ?40 W "DATE........:"
 S X=$G(^ACRTV(D0,"DT")) W ?55 S Y=$P(X,U,1) D DT
 D N:$X>0 Q:'DN  W ?0 W "DEPART......:"
 W ?15 S Y=$P(X,U,2) S Y(0)=Y I $G(Y)>1 X ^DD("DD") S Y=$P(Y,"@",2) S:+Y<12 Y=+Y_":"_$P(Y,":",2)_" AM" S:Y'["AM" Y=+Y-$S(+Y'=12:12,1:0)_":"_$P(Y,":",2)_" PM" W $E(Y,1,30)
 D N:$X>40 Q:'DN  W ?40 W "ARRIVE......:"
 S X=$G(^ACRTV(D0,"DT")) W ?55 S Y=$P(X,U,3) S Y(0)=Y I $G(Y)>1 X ^DD("DD") S Y=$P(Y,"@",2) S:+Y<12 Y=+Y_":"_$P(Y,":",2)_" AM" S:Y'["AM" Y=+Y-$S(+Y'=12:12,1:0)_":"_$P(Y,":",2)_" PM" W $E(Y,1,10)
 D N:$X>0 Q:'DN  W ?0 W "DEPART FROM.:"
 S X=$G(^ACRTV(D0,"DT")) W ?15 S Y=$P(X,U,18) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "ARRIVE AT...:"
 W ?55 S Y=$P(X,U,19) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DAILY DETAIL:"
 S X=$G(^ACRTV(D0,"DESC")) W ?15,$E($P(X,U,1),1,55)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,2),1,55)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,3),1,55)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,4),1,55)
 D N:$X>0 Q:'DN  W ?0 W "DUTY STATION:"
 S X=$G(^ACRTV(D0,"DT")) W ?15 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>40 Q:'DN  W ?40 W "PERDIEM/LDG.:"
 W ?55 S DIP(1)=$S($D(^ACRTV(D0,"DT")):^("DT"),1:"") S X=$P(DIP(1),U,5)_"/"_$P(DIP(1),U,6) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "MILES.......:"
 S X=$G(^ACRTV(D0,"DT")) W ?15 S Y=$P(X,U,7) W:Y]"" $J(Y,4,0)
 D N:$X>40 Q:'DN  W ?40 W "TAXI/SHUTTLE:"
 W ?55 S Y=$P(X,U,8) W:Y]"" $J(Y,6,2)
 S X=$G(^ACRTV(D0,1)) D N:$X>40 Q:'DN  W ?40,$E($P(X,U,4),1,40)
 D N:$X>0 Q:'DN  W ?0 W "PERS. PHONE.:"
 S X=$G(^ACRTV(D0,"DT")) W ?15 S Y=$P(X,U,9) W:Y]"" $J(Y,6,2)
 D N:$X>40 Q:'DN  W ?40 W "OTHER EXPENS:"
 W ?55 S Y=$P(X,U,10) W:Y]"" $J(Y,8,2)
 D N:$X>0 Q:'DN  W ?0 W "EXPLANATION.:"
 W ?15,$E($P(X,U,17),1,50)
 S X=$G(^ACRTV(D0,1)) D N:$X>15 Q:'DN  W ?15,$E($P(X,U,1),1,50)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,2),1,50)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,3),1,50)
 D N:$X>0 Q:'DN  W ?0 W "HOTEL.......:"
 S X=$G(^ACRTV(D0,"DT")) W ?15 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^ACRHOTEL(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>40 Q:'DN  W ?40 W "CAR RENTAL..:"
 W ?55 S Y=$P(X,U,13) S Y=$S(Y="":Y,$D(^ACRRCOMP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>0 Q:'DN  W ?0 W "CONFIRMATN #:"
 W ?15,$E($P(X,U,12),1,15)
 D N:$X>40 Q:'DN  W ?40 W "CONFIRMATN #:"
 W ?55,$E($P(X,U,14),1,15)
 D N:$X>0 Q:'DN  W ?0 W "GUARANTEED..:"
 W ?15 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "CAR EXPENSE.:"
 W ?55 S Y=$P(X,U,15) W:Y]"" $J(Y,7,2)
 D N:$X>0 Q:'DN  W ?0 W "CAR RENTAL JUSTIFICATION:"
 S X=$G(^ACRTV(D0,"RCJ")) D N:$X>15 Q:'DN  W ?15,$E($P(X,U,1),1,45)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,2),1,45)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,3),1,45)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,4),1,45)
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,5),1,45)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

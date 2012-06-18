ACRALS ; GENERATED FROM 'ACR AIRLINE SCHEDULE' PRINT TEMPLATE (#3861) ; 09/29/09 ; (FILE 9002193.7, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3861,"DXS")
 S I(0)="^ACRAL(",J(0)=9002193.7
 S X=$G(^ACRAL(D0,"DT")) W ?0 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRACOMP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,11)
 W ?13,$E($P(X,U,3),1,4)
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,4) D DT
 D N:$X>41 Q:'DN  W ?41 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 D N:$X>61 Q:'DN  W ?61,$E($P(X,U,8),1,4)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,6) D DT
 D N:$X>41 Q:'DN  W ?41 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^ACRPD(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 K Y
 Q
HEAD ;
 W !,?0,"AIRLINE",?13,"FLIGHT",?61,"SEAT"
 W !,?0,"COMPANY",?13,"NUMBER",?20,"DEPARTURE TIME",?41,"DEPART FROM",?61,"ASSIGNMENT"
 W !,?0,"CONTRACT FARE",?20,"ARRIVAL TIME",?41,"ARRIVE IN"
 W !,"--------------------------------------------------------------------------------",!!

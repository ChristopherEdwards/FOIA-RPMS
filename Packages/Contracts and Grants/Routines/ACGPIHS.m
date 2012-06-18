ACGPIHS ; GENERATED FROM 'ACG IHS DATA' PRINT TEMPLATE (#4005) ; 10/01/09 ; (FILE 9002330, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(4005,"DXS")
 S I(0)="^ACGS(",J(0)=9002330
 D N:$X>0 Q:'DN  W ?0 W "1  CONTR LOC..: "
 S X=$G(^ACGS(D0,"IHS")) W ?0,$E($P(X,U,1),1,20)
 D N:$X>39 Q:'DN  W ?39 W "2  PLACE PERF.: "
 W ?0,$E($P(X,U,2),1,20)
 D N:$X>0 Q:'DN  W ?0 W "3  ENTITY CODE: "
 W ?0,$E($P(X,U,3),1,4)
 D N:$X>39 Q:'DN  W ?39 W "4  FISCAL YEAR: "
 W ?0,$E($P(X,U,4),1,2)
 D N:$X>0 Q:'DN  W ?0 W "5  TARGET POP.: "
 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "6  LABOR STDS.: "
 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "7  TOTAL VALUE: "
 S Y=$P(X,U,7) W:Y]"" $J(Y,9,0)
 D N:$X>39 Q:'DN  W ?39 W "8  LAB SURPLUS: "
 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "9  PROP FURN'D: "
 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "10 PRIVACY ACT: "
 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "11 MINORTY BUS: "
 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "12 MINORTY N-P: "
 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "13 S-B STATUS.: "
 S Y=$P(X,U,13) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "14 BOA........: "
 S Y=$P(X,U,14) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "15 MED SERVICE: "
 S Y=$P(X,U,15) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "16 CS INITIALS: "
 W ?0,$E($P(X,U,16),1,3)
 D N:$X>0 Q:'DN  W ?0 W "17 GSA MT POOL: "
 S Y=$P(X,U,17) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "18 NO VEHICLES: "
 S Y=$P(X,U,18) W:Y]"" $J(Y,3,0)
 D N:$X>0 Q:'DN  W ?0 W "19 $$ GSA VEH.: "
 S Y=$P(X,U,19) W:Y]"" $J(Y,13,2)
 D N:$X>39 Q:'DN  W ?39 W "20 INDIAN OWND: "
 S Y=$P(X,U,20) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "21 8(A) PROGRM: "
 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "22 STATUS CODE: "
 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

ABPVDIN ;DISPLAY INSURER EDIT SCREEN; [ 06/04/91  1:12 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 D T Q:'DN  D N W ?0 W "<------------INSURER DATA-------------> <-----------BILLING ADDRESS---------->"
 D T Q:'DN  D N W ?0 W " 1.    NAME:"
 S X=$S($D(^AUTNINS(D0,0)):^(0),1:"") D N:$X>13 Q:'DN  W ?13,$E($P(X,U,1),1,26)
 D N:$X>41 Q:'DN  W ?41 W "8. OFFICE:"
 S X=$S($D(^AUTNINS(D0,1)):^(1),1:"") D N:$X>52 Q:'DN  W ?52,$E($P(X,U,1),1,27)
 D N:$X>0 Q:'DN  W ?0 W " 2.  STREET:"
 S X=$S($D(^AUTNINS(D0,0)):^(0),1:"") D N:$X>13 Q:'DN  W ?13,$E($P(X,U,2),1,26)
 D N:$X>41 Q:'DN  W ?41 W "9. STREET:"
 S X=$S($D(^AUTNINS(D0,1)):^(1),1:"") D N:$X>52 Q:'DN  W ?52,$E($P(X,U,2),1,27)
 D N:$X>0 Q:'DN  W ?0 W " 3.    CITY:"
 S X=$S($D(^AUTNINS(D0,0)):^(0),1:"") D N:$X>13 Q:'DN  W ?13,$E($P(X,U,3),1,15)
 D N:$X>40 Q:'DN  W ?40 W "10.   CITY:"
 S X=$S($D(^AUTNINS(D0,1)):^(1),1:"") D N:$X>52 Q:'DN  W ?52,$E($P(X,U,3),1,15)
 D N:$X>0 Q:'DN  W ?0 W " 4.   STATE:"
 S X=$S($D(^AUTNINS(D0,0)):^(0),1:"") D N:$X>13 Q:'DN  W ?13 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,26)
 D N:$X>40 Q:'DN  W ?40 W "11.  STATE:"
 S X=$S($D(^AUTNINS(D0,1)):^(1),1:"") D N:$X>52 Q:'DN  W ?52 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,27)
 D N:$X>0 Q:'DN  W ?0 W " 5.     ZIP:"
 S X=$S($D(^AUTNINS(D0,0)):^(0),1:"") D N:$X>13 Q:'DN  W ?13,$E($P(X,U,5),1,10)
 D N:$X>40 Q:'DN  W ?40 W "12.    ZIP:"
 S X=$S($D(^AUTNINS(D0,1)):^(1),1:"") D N:$X>52 Q:'DN  W ?52,$E($P(X,U,5),1,10)
 D N:$X>0 Q:'DN  W ?0 W " 6.   PHONE:"
 S X=$S($D(^AUTNINS(D0,0)):^(0),1:"") D N:$X>13 Q:'DN  W ?13,$E($P(X,U,6),1,13)
 D N:$X>0 Q:'DN  W ?0 W " 7. CONTACT:"
 D N:$X>13 Q:'DN  W ?13,$E($P(X,U,9),1,26)
 D N:$X>0 Q:'DN  W ?0 W "------------------------------------------------------------------------------"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!

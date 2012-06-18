ACHSCAN ; IHS/ITSC/PMF - GENERATED FROM 'ACHSCANP' PRINT TEMPLATE (#2006) 09/18/97 (FILE 9002062, MARGIN=80) ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 G BEGIN
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
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
 S X=$G(^ACHS(2,D0,0))
 W ?0 S Y=$P(X,U,3),C=1 D D S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P($G(^AUTTLOC(Y,0)),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P($G(^DIC(4,Y,0)),U),1:Y) W $E(Y,1,30)
 W ?32 S Y=$P(X,U,1),C=2 D D W $E(Y,1,7)
 W ?41 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACHS(1,Y,0))#2:$P($G(^ACHS(1,Y,0)),U),1:Y) W $J(Y,3)
 K Y
 Q
HEAD ;
 W !,?32,"CAN",?41,"COST"
 W !,?0,"FACILITY",?32,"NUMBER",?41,"CENTER"
 W !,"--------------------------------------------------------------------------------",!!

ABMDTDC ; IHS/ASDST/DMJ - COMPILED PRINT TEMPLATE ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^TMP($J,1))#2,^(1)?1U1P1E.E X ^(1)
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 S X=$S($D(^ABMDCODE(D0,0)):^(0),1:"") W ?0,$E($P(X,U,1),1,3)
 W ?6,$E($P(X,U,3),1,70)
 K Y
 Q
HEAD ;
 W !,?0,"CODE",?6,"DESCRIPTION"
 W !,"--------------------------------------------------------------------------------",!!

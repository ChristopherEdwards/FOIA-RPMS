AMQQBAN ; IHS/CMI/THL - BANNER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
W1 W:$D(IOF) @IOF
L3 W !!,?26,"Indian Health Service - RPMS",!,?28,"Q-MAN SITE MANAGER'S MENU",!
 S Y=""
 S Y=$O(^DIC(9.4,"C","BJPC",Y))
 S VERSION=^DIC(9.4,Y,"VERSION")
 W ?34,"Release ",VERSION
SITE ; ENTRY POINT.
 I '$D(DUZ(2)) D SET^AUSITE G L4:'$D(DUZ(2))
 W !?80-$L($P(^DIC(4,DUZ(2),0),"^"))\2,$P(^(0),"^")
L4 W !
 K I,VERSION
 Q

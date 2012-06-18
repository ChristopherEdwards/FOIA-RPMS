APCCBAN ; IHS/CMI/LAB - PCC BANNER ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
W1 W:$D(IOF) @IOF
L3 W !!,?26,"Indian Health Service - RPMS",!,?26,"Patient Care Component (PCC)",!
 S Y="",Y=$O(^DIC(9.4,"C","APCC",Y)),VERSION=^DIC(9.4,Y,"VERSION"),Y=$P(^DIC(9.4,Y,22,VERSION,0),"^",2) X ^DD("DD") S APCCVDT=Y
 W ?28,"Release ",VERSION,"  ",APCCVDT
SITE ; ENTRY POINT.
 I '$D(DUZ(2)) D SET^AUSITE G L4:'$D(DUZ(2))
 W !?80-$L($P(^DIC(4,DUZ(2),0),"^"))\2,$P(^(0),"^")
L4 W ! K APCC,I,APCCVDT,VERSION

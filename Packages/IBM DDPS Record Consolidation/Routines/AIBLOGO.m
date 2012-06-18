AIBLOGO ;DDPS/DFM ;LOGO/VERSION DISPLAY FOR CONSOLIDATION PACKAGE [ 01/27/89  9:19 AM ]
VERSION ;;1.3
 ;1.3; PICK UP VERSION FROM PACKAGE FILE
 S AIB="",AIB=$O(^DIC("9.4","C","AIB",AIB)),AIB("V")=^DIC("9.4",AIB,"VERSION")
 ;
 D ^%AUCLS
 W ?24,"*****************************",!
 W ?24,"**     DDPS IBM RECORD     **",!
 W ?24,"**      CONSOLIDATION      **",!
 W ?24,"**      VERSION "_AIB("V")_"        **",!
 W ?24,"*****************************",!
 K AIB
 Q:'$D(DUZ(2))  W !,?80-$L($P(^DIC(4,DUZ(2),0),"^",1))\2,$P(^DIC(4,DUZ(2),0),"^",1)
 Q

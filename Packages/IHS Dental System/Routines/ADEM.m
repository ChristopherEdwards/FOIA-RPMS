ADEM ; IHS/HQT/MJL  - HEADER ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 D ^ADECLS
 I $D(^DIC(9.4,"B","IHS DENTAL")) D
 . S ADE=$O(^DIC(9.4,"B","IHS DENTAL",0))
 . I $D(^DIC(9.4,ADE,"VERSION")) S ADE("V")=$P(^DIC(9.4,ADE,"VERSION"),"^")
 . E  S ADE("V")="5.4T6"
 S:'$D(ADE("V")) ADE("V")="5.4T6"
 W ?21,"    *****************************",!
 W ?21,"  *****                       *****",!
 W ?21," *****  INDIAN HEALTH SERVICE  *****",!
 W ?21,"  *****   DENTAL DATA SYSTEM  *****",!
 W ?21,"   *****   VERSION ",$J(ADE("V"),7),"  *****",!
 W ?21,"     *****                 *****",!
 W ?21,"       ***********************",!
 W ?21,"         ********* *********",!
 W ?21,"           ******   ******",!
 W ?21,"             ***     ***",!
SITE I $D(DUZ(2)),DUZ(2)>0 S ADE("SITE")=$P(^DIC(4,DUZ(2),0),"^",1) W !,?80-$L(ADE("SITE"))\2,ADE("SITE") G END
NOSITE W !!,"DIVISION NOT SET IN 'USER' FILE. CONTACT SITE MANAGER TO SET",!,"DIVISION BEFORE GOING FURTHER." S XQUIT=1
 ;
END K ADE
 Q

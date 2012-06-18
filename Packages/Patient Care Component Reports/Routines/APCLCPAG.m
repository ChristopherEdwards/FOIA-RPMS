APCLCPAG ; IHS/CMI/LAB - create new activity group ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 W !,"Creating/Editing a Discipline Group for the Activity Reports",!!
 S DIC="^APCLACTG(",DIC(0)="AEMQL",DIC("DR")=1101,DIC("S")="I '$P(^APCLACTG(+Y,0),U,5)" D ^DIC K DIC
 I Y=-1 W !,"BYE!! "
 Q

ADEHELP ; IHS/HQT/MJL  - ADA CODE INFORMATION ;10:38 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 N DIC,Y,DA,DR
 ;W !!,"Enter an ADA code if you want more information about the use of a specific code."
 W !!!
START S DIC="^AUTTADA(",DIC(0)="AEMQ",DIC("A")="For help about a specific ADA Code, enter the 4-digit code number:  " D ^DIC
 I Y<0 G XIT
 I '$D(^AUTTADA(+Y,11,0)) W !,"Additional information is not available for this ADA code." G START
DIQ S DA=+Y,DIC="^AUTTADA(",DR=11 D EN^DIQ
 W !!
 G START
XIT ;
 K DIC,DR,DA,Y
 Q

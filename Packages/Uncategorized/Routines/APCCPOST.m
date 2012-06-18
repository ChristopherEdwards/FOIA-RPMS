APCCPOST ;IHS/OHPRD/LAB;update PCC Master Control file;
 ;;4;PCC MENUS/MASTER CONTROL;;JUL 10, 1990
 D ^AUKVAR
 S DUZ(0)="@"
 W !!,"You will now be asked to update the PCC MASTER CONTROL file.",!,"You will need to enter your site name, whether your PCC Link will be Date",!,"only or Date/Time.  For each package on your machine that passes "
 W !,"data to PCC you must enter the package name, whether or not the link should",!,"be active, and the type of PCC visit to create.",!
 S DIC(0)="AEMQL",DIC="^APCCCTRL(" D ^DIC I Y=-1 W !!,"ERROR!! " G XIT
 S DA=+Y
 S DIE="^APCCCTRL(",DR="[APCC INPUT MASTER CONTROL]" D ^DIE
XIT ;
 K DIC,DIE,DA,Y,X,%,%Y,%X,C,D,D0,D1,DI,DQ,DR
 Q

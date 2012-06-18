AGSSKPKG ; IHS/ASDS/EFG - REMOVE PARTIAL INIT FROM PACKAGE FILE ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
S ;
 S X="AGSS",DIC="^DIC(9.4,",DIC(0)="EMQZ" D ^DIC I Y'>0 W !,"PACKAGE NOT FOUND ",!,*7 G EXIT
 W !,"Removing ",Y(0,0)," from the package file.",!
 S DA=+Y,DIK="^DIC(9.4," D ^DIK
 W !,"Package deleted !,"
EXIT Q

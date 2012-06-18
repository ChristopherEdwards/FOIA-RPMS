ADGCEN ; IHS/ADC/PDW/ENM - CENSUS AID-LIST BY WARD ONLY ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;This rtn lists census data for all wards
 ;to aid the admitting supervisor in finding errors
 ;
 W @IOF W !!?30,"LIST CENSUS DATA BY WARD",!!!!
 W ?10,"This program will list the CENSUS CHANGES for a selected ward"
 W !?20," for the date range you specify.",!!
 ;
WARD K DIR S DIR(0)="PO^9009011:EQMZ" D ^DIR
 G END:$D(DIRUT),WARD:Y=-1 S DGWD=+Y
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 ;
 S %ZIS="Q" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGCEN0
QUE K IO("Q") S ZTRTN="^ADGCEN0",ZTDESC="CENSUS AID"
 F DGI="DGBDT","DGEDT","DGWD" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K DGBDT,DGEDT,DGWD,DIR,DGI D HOME^%ZIS Q

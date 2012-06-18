ADGCEN3 ; IHS/ADC/PDW/ENM - CENSUS AID-PATIENT LISTS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;This rtn lists patient admissions, transfers, and discharges
 ;for the day specified to check against manual lists
 ;
 W @IOF W !!?30,"WARD CENSUS LISTING",!!
WARD ;select all wards or just one
 K DIR S DIR("A")="Print ALL Wards",DIR(0)="YO",DIR("B")="NO"
 D ^DIR G END:$D(DIRUT)
 I Y=1 S DGWD="A" G BDATE  ;yes-all wards
 ;if no-which ward
WD1 K DIR S DIR(0)="PO^42:EQMZ" D ^DIR G WARD:$D(DIRUT),WD1:Y=-1
 I $D(^DIC(42,+Y,"I")),$P(^("I"),U)="I" W *7,?40,"** INACTIVE WARD **" G WARD
 S DGWD=+Y
 ;
BDATE D NOW^%DTC S DGNOW=%
 S %DT="AEQRP",%DT("A")="Select beginning date and time: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
 I DGBDT>DGNOW W !!?10,"Date/Time CANNOT be in the future!",!! G BDATE
EDATE S %DT="AEQRP",%DT("A")="Select ending date and time: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 I DGEDT'>DGBDT W !!?10,"Ending date/time must be AFTER beginning date/time!",!! G BDATE
 I DGEDT>DGNOW W !!?10,"Date/Time CANNOT be in the future!",!! G EDATE
 ;
 S %ZIS="Q" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGCEN30
QUE K IO("Q") S ZTRTN="^ADGCEN30",ZTDESC="CENSUS AID 3"
 F DGI="DGBDT","DGEDT","DGWD" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT,DGWD,DGNOW,DIR,DGI D HOME^%ZIS Q

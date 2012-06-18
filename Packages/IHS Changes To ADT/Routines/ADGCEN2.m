ADGCEN2 ; IHS/ADC/PDW/ENM - CENSUS AID-LIST BY SERVICE ONLY ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;This rtn lists census data for a selected treating specialty
 ;to aid the admitting supervisor in finding errors
 ;
 W @IOF W !!?30,"LIST CENSUS DATA BY SERVICE",!!
 ;
SRV K DIR S DIR(0)="PO^9009011.5:EQMZ" D ^DIR
 G END:$D(DIRUT),SRV:Y=-1 S DGSRV=+Y
 ;
AGE K DIR S DIR("A")="Adult or Pediatric Census"
 S DIR(0)="SO^A:ADULT;P:PEDIATRIC"
 S DIR("?",1)="This report displays either adult census figures"
 S DIR("?",2)="or pediatric ones.",DIR("?")="Please choose one; A or P."
 D ^DIR G SRV:$D(DIRUT),AGE:Y=-1
 S DGAGE=$S(Y="A":0,1:1) ;0node=adult; 1node=peds
 ;
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 ;
 S %ZIS="Q" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGCEN20
QUE K IO("Q") S ZTRTN="^ADGCEN20",ZTDESC="CENSUS AID 2"
 F DGI="DGBDT","DGEDT","DGSRV","DGAGE" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT,DGSRV,DGAGE,DIR,DGI D HOME^%ZIS Q

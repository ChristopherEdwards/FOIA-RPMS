ADGCEN1 ; IHS/ADC/PDW/ENM - CENSUS AID-LIST BY WARD & TX ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;This rtn lists census data for a selected ward and treating
 ;specialty to aid the admitting supervisor in finding errors
 ;
 W @IOF W !!?20,"LIST CENSUS DATA BY WARD AND SERVICE",!!
WARD K DIR S DIR(0)="PO^9009011:EQMZ" D ^DIR
 G END:$D(DIRUT),WARD:Y=-1 S DGWD=+Y
 ;
SRV K DIR S DIR(0)="PO^45.7:EQMZ" D ^DIR
 G END:$D(DIRUT),SRV:Y=-1 S DGSRV=+Y
AGE K DIR S DIR("A")="Adult or Pediatric Census"
 S DIR("?",1)="This report displays either adult census figures"
 S DIR("?",2)="or pediatric ones.",DIR("?")="Please choose one; A or P."
 S DIR(0)="S^A:ADULT;P:PEDIATRIC" D ^DIR G SRV:$D(DIRUT),SRV:Y=-1
 S DGAGE=$S(Y="A":0,1:1)  ;0node-adult; 1node=peds
 ;
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 ;
 S %ZIS="Q" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGCEN10
QUE K IO("Q") S ZTRTN="^ADGCEN10",ZTDESC="CENSUS AID 1"
 F DGI="DGBDT","DGEDT","DGWD","DGSRV","DGAGE" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT,DGWD,DGSRV,DGAGE,DIR,DGI D HOME^%ZIS Q

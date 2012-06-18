ADGFTRQ ; IHS/ADC/PDW/ENM - QUEUE LIST OF FACILITY TRANSFERS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF W !!!?20,"PRINT LIST OF TRANSFERS TO/FROM OTHER FACILITIES",!!
 ;
 ;***> select date range
DATE S %DT="AEQ",%DT("A")="Beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
DATE2 S %DT("A")="Ending date: ",X="" D ^%DT G DATE:Y=-1 S DGEDT=Y
 I DGEDT<DGBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I DGEDT'<DT S X1=DT,X2=-1 D C^%DTC S DGEDT=X
 ;
 ; -- select type of report
TYPE W ! K DIR S DIR("A",1)="Select Type Of Report:",DIR("A",2)=" "
 S DIR("A",3)="     1.  LISTING only"
 S DIR("A",4)="     2.  STATISTICS only"
 S DIR("A",5)="     3.  BOTH Listing and Stats"
SELECT S DIR("A")="Select One",DIR(0)="N0^1:3" D ^DIR
 G END:$D(DIRUT),TYPE:Y=-1 S DGTYP=Y
 ;
 ; -- select print device
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGFTRC
QUE K IO("Q") S ZTRTN="^ADGFTRC" S ZTDESC="TRANSFER REPORT"
 F DGI="DGBDT","DGEDT","DGTYP" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,DGBDT,DGEDT,DGTYP,DIR D HOME^%ZIS Q

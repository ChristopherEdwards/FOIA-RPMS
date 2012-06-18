ADGDODQ ; IHS/ADC/PDW/ENM - QUEUE LIST OF INPATIENT DEATHS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF W !!!?20,"PRINT LIST OF INPATIENT DEATHS",!!
 ;
 ;***> select date range
DATE S %DT="AEQ",%DT("A")="Beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
DATE2 S %DT("A")="Ending date: ",X="" D ^%DT G DATE:Y=-1 S DGEDT=Y
 I DGEDT<DGBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I DGEDT'<DT S X1=DT,X2=-1 D C^%DTC S DGEDT=X
 ;
 ;***> select type of report
TYPE K DIR S DIR("A")="Select Sorting Order for Report"
 S DIR(0)="SO^1:By DATE;2:By Discharge SERVICE;3:By Patient NAME"
 D ^DIR G END:$D(DIRUT),TYPE:Y=-1 S DGTYP=Y
 ;
 ;***> select print device
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGDODC
QUE K IO("Q") S ZTRTN="^ADGDODC" S ZTDESC="DEATHS LISTING"
 F DGI="DGBDT","DGEDT","DGTYP" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,DGBDT,DGEDT,DGTYP D HOME^%ZIS Q

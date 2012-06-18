ADGLDCQ ; IHS/ADC/PDW/ENM - QUEUE LIST OF DISCHARGES ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF W !!!?20,"PRINT LIST OF DISCHARGES",!!
 ;
 ;***> select date range
DATE S %DT="AEQ",%DT("A")="Beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
DATE2 S %DT="AEQ",%DT("A")="Ending date: ",X="" D ^%DT G DATE:Y=-1 S DGEDT=Y
 I DGEDT<DGBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I DGEDT'<DT S X1=DT,X2=-1 D C^%DTC S DGEDT=X
 ;
 ;***> select type of report
TYPE K DIR S DIR("A",1)="Select Sorting Order for Report:"
 S DIR("A",2)="     1.  By DATE",DIR("A",3)="     2.  By WARD"
 S DIR("A",4)="     3.  By SERVICE"
SELECT S DIR("A")="Select (1, 2, or 3):  ",DIR(0)="NAO^1:3" D ^DIR
 G END:$D(DTOUT),DATE2:X="",END:$D(DUOUT),TYPE:Y=-1 S DGTYP=Y
 G DEV:DGTYP=1
 ;
ALL ;***> choose one or all wards or services
 K DIR S DIR(0)="Y"
 S DIR("A")=$S(DGTYP=2:"Print for All Wards",1:"Print for All Services")
 S DIR("B")="NO" D ^DIR I Y=1 S DGSRT="A" G DEV  ;all wards or serv
 I $D(DIRUT) G END  ;check for timeout,"^", or null
 ;
ONE ;***> choose which ward or service to print
 K DIR S DIR(0)=$S(DGTYP=2:"PO^42:EMQZ",1:"PO^45.7:EMQZ") D ^DIR
 G END:$D(DTOUT),ALL:X="",END:$D(DUOUT),ONE:Y=-1
 I DGTYP=2 I $D(^DIC(42,+Y,"I")),$P(^("I"),U)="I" W *7,?40,"** INACTIVE WARD **" G ONE
 I DGTYP=3 I $P(^DIC(45.7,+Y,9999999),U,3)'="Y" W *7,!?35,"** NOT AN ADMITTING SERVICE! **" G ONE
 S DGSRT=Y
 ;
 ;***> select print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^ADGLDCC
QUE K IO("Q") S ZTRTN="^ADGLDCC" S ZTDESC="ADMITS LISTING"
 F DGI="DGBDT","DGEDT","DGTYP","DGSRT" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,DGBDT,DGEDT,DGTYP,DGSRT,DIR,DGI D HOME^%ZIS Q

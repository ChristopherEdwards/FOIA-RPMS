AQAQMCQ ;IHS/ANMC/LJF - QUEUE MISSING CREDENTIALS REPORT; [ 05/27/92  11:24 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 W @IOF,!!!?20,"PRINT MISSING CREDENTIALS REPORT",!!
 ;
 ;***> select type of report
TYPE K DIR S DIR("A",1)="Select Sorting Order for Report:"
 S DIR("A",2)="     1.  ALPHABETICALLY (By Provider Name)"
 S DIR("A",3)="     2.  By PROVIDER CLASS"
 S DIR("A",4)="     3.  By STAFF CATEGORY"
SELECT S DIR("A")="Select (1, 2, or 3):  ",DIR(0)="NAO^1:3" D ^DIR
 G END:$D(DTOUT),END:X="",END:$D(DUOUT),TYPE:Y=-1 S AQAQTYP=Y
 I AQAQTYP=1 S AQAQSRT="" G DEV
 ;
ALL ;***> choose one or all classes or categories
 K DIR S DIR(0)="Y"
 S DIR("A")=$S(AQAQTYP=2:"Print for All Classes",1:"Print for All Categories")
 S DIR("B")="NO" D ^DIR I Y=1 S AQAQSRT="ALL" G DEV  ;all wards or serv
 I $D(DIRUT) G END  ;check for timeout,"^", or null
 ;
ONE ;***> choose which class or category to print
 I AQAQTYP=2 D  G END:'$D(AQAQSRT) G DEV
 .K DIR,AQAQSRT S DIR(0)="PO^7:EMQZ" D ^DIR
 .Q:$D(DTOUT)  Q:X=""  Q:$D(DUOUT)  Q:Y=-1
 .I $D(^DIC(42,+Y,"I")),$P(^("I"),U)="I" W ?40,"** INACTIVE WARD **" Q
 .S AQAQSRT=Y
 E  D  G END:'$D(AQAQSRT)
 .K DIR,AQAQSRT S DIR(0)="9002165,.02" D ^DIR
 .Q:$D(DTOUT)  Q:X=""  Q:$D(DUOUT)  Q:Y=-1
 .S AQAQSRT=Y
 ;
 ;***> select print device
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G ^AQAQMCC
QUE K IO("Q") S ZTRTN="^AQAQMCC" S ZTDESC="MISSING CREDENTIALS"
 F AQAQI="AQAQTYP","AQAQSRT" S ZTSAVE(AQAQI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,AQAQTYP,AQAQSRT,DIR,AQAQI D HOME^%ZIS Q

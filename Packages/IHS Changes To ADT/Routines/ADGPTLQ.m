ADGPTLQ ; IHS/ADC/PDW/ENM - QUEUE PATIENT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
SELECT W @IOF,!!!!,"Print Patient List: ",!
 K DIR S DIR("A",1)="     1. By Ward with diagnosis "
 S DIR("A",2)="     2. By Ward with service "
 S DIR("A",3)="     3. Alphabetically by Patient Name "
 S DIR("A",4)="     4. As a Ward Worksheet"
 S DIR("A",5)=" "
SELECT1 S DIR("A")="Choose One",DIR(0)="NO^1:4" D ^DIR
 G END:$D(DIRUT),SELECT:Y=-1 S DGO=Y
 ;
 I DGO=3 S DGWST="A" G DEV  ;alphabetical list
 ;
WARD K DIR S DIR("A")="Print ALL Wards",DIR(0)="Y",DIR("B")="NO"
 D ^DIR G SELECT:$D(DTOUT),SELECT:$D(DUOUT)
 I Y=1 S DGWST="A" G DEV
 K DIR S DIR(0)="PO^42:EQMZ" D ^DIR G WARD:$D(DIRUT),WARD:Y=-1
 I $D(^DIC(42,+Y,"I")),$P(^("I"),U)="I" W *7,?40,"** INACTIVE WARD **" G WARD
 S DGWST=+Y
 ;
DEV S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) G ^ADGPTLC
QUE K IO("Q") S ZTRTN="^ADGPTLC",ZTDESC="PRINT PATIENT LIST"
 S ZTSAVE("DGO")="",ZTSAVE("DGWST")=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,DIR,DGWST,DGO D HOME^%ZIS Q

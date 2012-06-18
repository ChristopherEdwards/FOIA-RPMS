ADGSTAW ; IHS/ADC/PDW/ENM - INPATIENT STATISTICS BY WARD ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!!?18,"INPATIENT STATISTICS BY WARD",!!
A ; -- driver
 D BD I Y=-1 D Q Q
 D ED I Y=-1 D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
EN ;EP; -- queued entry point
 D D,^ADGSTAW1,Q Q
 ;
BD ; -- beginning date
 S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT S DGBD=Y Q
 ;
ED ; -- ending date
 S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT S DGED=Y
 I Y<DGBD D  G BD
 . W !!,*7,"Ending date cannot be earlier than beginning date!"
 . W !,"Let's start over . . ",!
 Q
 ;
ZIS ; -- select device
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE K IO("Q") S ZTRTN="EN^ADGSTAW",ZTDESC="INPATIENT STATS BY WARD"
 S ZTSAVE("DGBD")="",ZTSAVE("DGED")="" D ^%ZTLOAD D ^%ZISC K ZTSK Q
 ;
Q ; -- cleanup
 K X,Y,D,N,W,P,DGBD,DGED D HOME^%ZIS Q
 ;
D ; -- driver
 D I,L Q
 ;
I ; -- init
 S W=0 F  S W=$O(^ADGWD(W)) Q:'W  S:$$AW DGWD(W)=0
 Q
 ;
L ; -- loop adt census-ward file   (W)ard/(D)ate
 S W=0 F  S W=$O(^ADGWD(W)) Q:'W  D
 . Q:'$$AW  S D=DGBD-.001 F  S D=$O(^ADGWD(W,1,D)) Q:D>DGED  Q:'D  D 1
 Q
 ;
1 ; -- total fields
 S N=$G(^ADGWD(W,1,D,0)) Q:'N
 F P=2:1:9,12:1:19 S $P(DGWD(W),U,P)=$P(DGWD(W),U,P)+$P(N,U,P)
 Q
 ;
AW() ; -- admitting ward
 Q $S($D(^DIC(42,"AGL",1,W)):1,1:0)

ADGPCU ; IHS/ADC/PDW/ENM - PCU ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!!?18,"PCU STATS",!!
A ; -- driver
 D BD I Y=-1 D Q Q
 D ED I Y=-1 D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D D,Q Q
 ;
BD ; -- beginning date
 S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT S DGBD=Y Q
 ;
ED ; -- ending date
 S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT S DGED=Y Q
 ;
ZIS ; -- select device
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE K IO("Q") S ZTRTN="D^ADGPCU",ZTDESC="PCU STATS"
 S ZTSAVE("DGBD")="",ZTSAVE("DGED")="" D ^%ZTLOAD D ^%ZISC K ZTSK Q
 ;
Q K DGBD,DGED,X,Y D HOME^%ZIS Q
 ;
D ; -- queued entry point
 D L,Q Q
 ;
L ; -- loop
 N ICU,PCU,D,C,N,I
 S C=0,D=DGBD F  S D=$O(^DGPM("B",D)) Q:'D  Q:D>DGED  D
 . S I=0 F  S I=$O(^DGPM("B",D,I)) Q:'I  D
 .. S N=$G(^DGPM(+I,0)) Q:'N
 .. W:$P(N,U,6)=5 !,N
 .. I $P(N,U,6)=5,$P($G(^DGPM(+$O(^DGPM("APHY",I,0)),0)),U,9)=9 D  Q
 ... S PCU(+$P(N,U,2))=$G(PCU(+$P(N,U,2)))+1
 .. I $P(N,U,6)=6,$P($G(^DGPM(+$O(^DGPM("APHY",I,0)),0)),U,9)=9 D  Q
 ... S ICU(+$P(N,U,2))=$G(ICU(+$P(N,U,2)))+1
 .. I $P(N,U,6)=5,'$O(^DGPM("APHY",I,0)),$$T D  Q
 ... S PCU(+$P(N,U,2))=$G(PCU(+$P(N,U,2)))+1
 .. I $P(N,U,6)=6,'$O(^DGPM("APHY",I,0)),$$T D  Q
 ... S ICU(+$P(N,U,2))=$G(ICU(+$P(N,U,2)))+1
 Q
 ;
T() ; 
 N ID,T S ID=9999999.9999999-D
 S ID=$O(^DGPM("ATS",+$P(N,U,3),+$P(N,U,14),ID)) Q:'ID 0
 S T=$O(^DGPM("ATS",+$P(N,U,3),+$P(N,U,14),ID,0)) Q $S(T=9:T,1:0)

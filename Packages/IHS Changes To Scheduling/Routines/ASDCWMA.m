ASDCWMA ; IHS/ADC/PDW/ENM - CLERK WHO MADE APPT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
A ; -- driver
 D CL I Y=-1 D Q Q
 D BD I Y=-1 D Q Q
 D ED I Y=-1 D Q Q
 D ZIS I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D START Q
 ;
CL ; -- select clinic
 D ASK2^SDDIV Q:Y<0  S VAUTNI=1 D CLINIC^VAUTOMA Q
 ;
BD ; -- beginning date
 S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT S SDBD=Y Q
 ;
ED ; -- ending date
 S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT S SDED=Y Q
 ;
ZIS ; -- select device
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ; -- queued
 K IO("Q") S ZTRTN="START^ASDCWMA",ZTDESC="CLERK WHO MADE APPT LIST"
 S ZTSAVE("SDBD")="",ZTSAVE("SDED")="",ZTSAVE("VAUT*")="",ZTSAVE("DIV")=""
 D ^%ZTLOAD D HOME^%ZIS K ZTSK Q
 ;
Q K X,Y,SDBD,SDED,VAUTC,VAUTD,POP,SDQUIT,N,P,D,SC,SD,ASDQT
 D ^%ZISC Q
 ;
START ;EP
 S ASDQT=0 U IO
 I VAUTC D ALL Q
 S SD=""
 F  S SD=$O(VAUTC(SD)) Q:SD=""  S SC=VAUTC(SD) Q:'SC  D 1 Q:ASDQT
 D Q Q
 ;
ALL ; -- all clinics
 S SC=0 F  S SC=$O(^SC(SC)) Q:'SC  D  Q:ASDQT
 . I $O(VAUTD(0)) Q:'$D(VAUTD(+$P(^SC(SC,0),U,15)))
 . Q:'$$ACTV^ASDUT(SC)  D 1
 Q
 ;
1 ; -- loop clinics
 D HD(0)
 S D=SDBD-.001
 F  S D=$O(^SC(+SC,"S",D)) Q:'D  Q:D>(SDED+.9)  D  Q:ASDQT
 . S P=0 F  S P=$O(^SC(+SC,"S",D,1,P)) Q:'P  D  Q:ASDQT
 .. S N=^SC(+SC,"S",D,1,P,0) I $Y>(IOSL-7) D HD(1) Q:ASDQT
 .. W !,$$D(D),?20,$$HRC^ASDUT(+N),?30,$$AGE(+N)
 .. W ?40,$$CLK($P(N,U,6)),?65,$$D($P(N,U,7))
 I IOST["C-",'ASDQT S DIR(0)="E" D ^DIR S:'Y ASDQT=1
 Q
 ;
HD(X) ; -- heading
 I IOST["C-",X S DIR(0)="E" D ^DIR S:'Y ASDQT=1 Q:'Y
 W @IOF,!!,?35,$P(^SC(+SC,0),U),!!,"DATE/TIME",?20,"HRCN"
 W ?30,"AGE",?40,"CLERK WHO MADE APPT",?65,"DATE APPT MADE",!!
 Q
 ;
D(Y) ; -- date
 NEW N,P,D
 X ^DD("DD") Q Y
 ;
AGE(X) ; -- age
 NEW N,D,P
 Q $$VAL^XBDIQ1(9000001,X,1102.98)
 ;
CLK(X) ; -- clerk who made appt
 NEW N,D,P
 Q $E($P(^VA(200,X,0),U),1,20)

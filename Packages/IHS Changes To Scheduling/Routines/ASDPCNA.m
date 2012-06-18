ASDPCNA ; IHS/ADC/PDW/ENM - # DAYS TIL NEXT APPT ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 NEW SDAY,PC,X,J,SC,Y,Z,POP
A ; -- driver
 D DEV Q:POP  I $D(IO("Q")) D QUE,Q Q
EN D HD,SC,Q Q
 ;
SC ; -- loop principle clinic x-ref
 U IO S POP=0
 S PC=0 F  S PC=$O(^SC("AIHSPC",PC)) Q:'PC  D PC D  Q:POP
 . S SC=0 F  S SC=$O(^SC("AIHSPC",PC,SC)) Q:'SC  D:$$CK DAY Q:POP
 Q:POP  W !,"*No Principal Clinic"
 S SC=0 F  S SC=$O(^SC(SC)) Q:'SC  D  Q:POP
 . Q:'$$NPC  Q:'$$CK  D DAY
 Q
 ;
DAY ; -- loop visit days / clinic and print next appt
 S SDAY=$$SD F  S SDAY=$O(^SC(SC,"ST",SDAY)) Q:'SDAY  Q:$$NA
 I 'SDAY W ?26,$E($P(^SC(SC,0),U),1,30),?57,"none",! D  Q
 . I $Y>(IOSL-6) D:IOST["C-"  Q:POP  D HD Q
 .. NEW DIR S DIR(0)="E" D ^DIR S:'Y POP=1
 S X=$O(^SC(SC,"ST",SDAY,0)) Q:'X
 S Y=$$FMTE^XLFDT(SDAY)
 W ?26,$E($P(^SC(SC,0),U),1,30),?57,Y,?71,$J($$D(SDAY),2)," days",!
 I $Y>(IOSL-6) D:IOST["C-"  Q:POP  D HD
 . NEW DIR S DIR(0)="E" D ^DIR S:'Y POP=1
 Q
 ;
PC ; -- principle clinic
 W !,$E($P(^SC(PC,0),U),1,25) Q
 ;
DEV ; -- device selection
 S %ZIS="PQ" D ^%ZIS K %ZIS Q
 ;
HD ; -- heading
 W @IOF,!!,?2,"Next Available Appointment by Principle Clinic"
 N %,%H,%I,X D NOW^%DTC W ?60,%I(1),"/",%I(2),"/",$E(%I(3),2,3)
 W " ",$E($P(%,".",2),1,2),":",$E($P(%,".",2),3,4),!!
 I $G(PC),$O(^SC("AIHSPC",PC,SC)) W !,$E($P(^SC(PC,0),U),1,16)," ..cont."
 Q
 ;
Q ; -- cleanup
 I IOST["C-",'$G(POP) D PRTOPT^ASDVAR
 D ^%ZISC,HOME^%ZIS Q
 ;
QUE ; -- queued output
 S ZTRTN="EN^ASDPCNA",ZTDESC="Principle Clinic Next Appointment"
 D ^%ZTLOAD Q
 ;
CK() ; -- active clinic? (yes=true)
 NEW X
 S X=$G(^SC(SC,"I")) Q:'$D(^SC(SC,"ST")) 0 Q:'$O(^("ST",DT)) 0
 Q $S($P(^SC(SC,0),U,3)'="C":0,'X:1,(DT>(X-1))&('$P(X,U,2)):0,1:1)
 ;
NA() ; -- next appointment
 NEW X,Y,Z,J
 S Y=$O(^SC(SC,"ST",SDAY,0)) Q:'Y 0
 S X="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz"
 S Z=$E(^SC(SC,"ST",SDAY,Y),6,$L(^SC(SC,"ST",SDAY,Y)))
 F J=1:1:$L(Z) I $E(X,$F(X,"0"),$L(X))[$E(Z,J) S J=999
 Q $S(J=999:1,1:0)
 ;
NPC() ; -- principle clinic (none=false)
 Q $S($P($G(^SC(SC,"SL")),U,5):0,1:1)
 ;
D(X1,X2,X)         ; -- number of days
 S X2=DT D ^%DTC Q X
 ;
SD(X1,X2,X)         ; -- start day
 S X1=DT,X2=-1 D C^%DTC Q X

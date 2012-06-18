ADGSTAW1 ; IHS/ADC/PDW/ENM - INPATIENT STATS BY WARD (cont.) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- main
 D H,W,T,N,K,PRTOPT^ADGVAR,Q Q
 ;
W ; -- loop ward counts for a period
 S (T,W)=0 F  S W=$O(DGWD(W)) Q:'W  D
 . Q:'$$AW  D 1,L
 Q
 ;
1 ; -- total ward counts (newborn 12-19; below + 10)
 ;  (2 rem, 3 adm, 4 dis, 5 txi, 6 txo, 7 dth, 8 1day, 9 los)
 F P=2:1:9,12:1:19 S $P(T,U,P)=$P(T,U,P)+$P(DGWD(W),U,P)
 Q
 ;
L ; -- line
 D:$Y>(IOSL-6) P(1)
 W !!,$E($P(^DIC(42,W,0),U),1,10)
 W ?16,$J($P(DGWD(W),U,3),3),?22,$J($P(DGWD(W),U,5),3)
 W ?28,$J($P(DGWD(W),U,6),3),?34,$J($P(DGWD(W),U,4),3)
 W ?40,$J($P(DGWD(W),U,7),3),?46,$J($P(DGWD(W),U,8),3)
 W ?52,$J($$TISD(DGWD(W)),4),?60,$J($$ADIC(DGWD(W)),5,2)
 W ?69,$J($P(DGWD(W),U,9),3),?74,$J($$ALOS(DGWD(W)),5,2) Q
 ;
T ; -- totals
 D:$Y>(IOSL-6) P(1)
 W !,$$LN("-"),!!,"TOTAL:",?16,$J($P(T,U,3),3)
 W ?22,$J($P(T,U,5),3),?28,$J($P(T,U,6),3),?34,$J($P(T,U,4),3)
 W ?40,$J($P(T,U,7),3),?46,$J($P(T,U,8),3),?52,$J($$TISD(T),4)
 W ?59,$J($$ADIC(T),5,2),?68,$J($P(T,U,9),3)
 W ?74,$J($$ALOS(T),5,2) Q
 ;
N ; -- newborn
 D:$Y>(IOSL-6) P(1)
 W !,$$LN("-"),!!,"NEWBORN",?16,$J($P(T,U,13),3)
 W ?22,$J($P(T,U,15),3),?28,$J($P(T,U,16),3),?34,$J($P(T,U,14),3)
 W ?40,$J($P(T,U,17),3),?46,$J($P(T,U,18),3)
 W ?52,$J($$TISD($P(T,U,11,19)),4),?60,$J($$ADIC($P(T,U,11,19)),5,2)
 W ?69,$J($P(T,U,19),3),?74,$J($$ALOS($P(T,U,11,19)),5,2) Q
 ;
Q ; -- cleanup
 K DGWD,T,DGBD,DGED W @IOF D ^%ZISC Q
 ;
H ; -- heading
 U IO W:IOST["C-" @IOF W $$UI,?80-$L($$FAC)\2,$$FAC,! D ^%T
 W ?24,"INPATIENT STATISTICS BY WARD",!,$$DT(DT),?25,"from "
 W $$DT(DGBD)," to ",$$DT(DGED),!!,"WARD",?16,"ADM",?22,"TXI"
 W ?28,"TXO",?34,"DIS",?40,"DTH",?46,"1DAY",?52,"TISD",?61,"ADIC"
 W ?68,"TLOS",?75,"ALOS",!,$$LN("=") Q
 ;
P(Z) ; -- page
 Q:IOST'["C-"  W ! N X,Y K DIR S DIR(0)="E" D ^DIR W @IOF D H:Z Q
 ;
K ; -- key
 W !!,"TXI = transfers in, TXO = transfers out"
 W !,"TISD = total inpatient service days"
 W !,"ADIC = average daily inpatient census (adpl)"
 W !,"TLOS = total length of stay (discharge days)"
 W !,"ALOS = average length of stay (average stay)" Q
 ;
FAC() ; -- facility name
 Q $P(^DIC(4,DUZ(2),0),U)
 ;
UI() ; -- user's initials
 Q $P(^VA(200,DUZ,0),U,2)
 ;
LS(X) ; -- losses (dis+txo+dth)
 Q $P(X,U,4)+$P(X,U,6)+$P(X,U,7)
 ;
AW() ; -- admitting ward
 Q $S($D(^DIC(42,"AGL",1,+W)):1,1:0)
 ;
DT(X) ; -- date format
 Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 ;
TISD(X) ; -- total inpatient service days
 Q $P(X,U,2)+$P(X,U,8)
 ;
ADIC(X) ; -- average daily inpatient census (tisd / total # of days)
 Q $$TISD(X)/$$ND(DGED,DGBD)
 ;
ALOS(X) ; -- average length of stay (los / losses)
 Q $P(X,U,9)/$S($$LS(X):$$LS(X),1:1)
 ;
LN(X,Y) ; -- line
 S Y="",$P(Y,X,IOM)="" Q Y
 ;
ND(X1,X2,X) ; -- number of days
 D ^%DTC Q X+1
 ;

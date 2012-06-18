ADGPCAC6 ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY-PROBLEMS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D L6 Q
 ;
L6 ; -- loop problems
 N IFN,N,X,X1
 Q:'$D(^AUPNPROB("AC",DFN))
 W @IOF," (6) ACTIVE Problems"
 S IFN=0 F  S IFN=$O(^AUPNPROB("AC",DFN,IFN)) Q:'IFN  D 6 Q:$D(DIRUT)
 Q:$D(DIRUT)  D Q Q
 ;
6 ; -- display active problems
 Q:'$D(^AUPNPROB(IFN,0))  S N=^(0)  Q:$P(N,U,12)'="A"
 W !?13,"Problem #: ",$$PRB
 W ?45,"Date: ",$$DT,!?13,"Narrative: ",$$NAR
 ; -- notes
 Q:'$O(^AUPNPROB(IFN,11,0))  W !?17,"Notes: "
 S X=0 F  S X=$O(^AUPNPROB(IFN,11,X)) Q:'X  D
 . S X1=0 F  S X1=$O(^AUPNPROB(IFN,11,X,11,X1)) Q:'X1  D
 .. W ?28,$P(^AUPNPROB(IFN,11,X,11,X1,0),U,3),!
PG ; -- form feed?
 W ! Q:($Y+4)'>IOSL  K DIR S DIR(0)="E" D ^DIR K DIR W @IOF Q
 ;
Q ; -- cleanup
 K DIR W ! S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
PRB() ; -- problem number
 Q $P($G(^AUTTLOC(+$P(N,U,6),0)),U,7)_$P(N,U,7)
 ;
DT() ; -- date
 N X S X=$P(N,U,3) Q:'X ""  Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 ;
NAR() ; -- narrative
 Q $P($G(^AUTNPOV(+$P(N,U,5),0)),U)

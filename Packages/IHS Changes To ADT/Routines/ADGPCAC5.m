ADGPCAC5 ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY-IMMUNIZATION ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D L5 Q:$D(DIRUT)
 D ^ADGPCAC6 Q
 ;
L5 ; -- loop v immunization
 N IFN,N
 Q:'$D(^AUPNVIMM("AD",DGVI))
 W @IOF," (5) Immunization"
 S IFN=0 F  S IFN=$O(^AUPNVIMM("AD",DGVI,IFN)) Q:'IFN  D 5 Q:$D(DIRUT)
 Q:$D(DIRUT)  D Q Q
 ;
5 ; -- display immunization info
 Q:'$D(^AUPNVIMM(IFN,0))  S N=^(0)
 W !!?9,"Immunization: ",$$IMM,!?15,"Series: ",$$SER
 W:$P(N,U,4)'="" ?43,"Max # in Series: ",$$MAX
 W !?18,"Lot: ",$P(N,U,5)
 ; -- form feed?
 W ! Q:($Y+4)'>IOSL  S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
Q ; -- cleanup
 K DIR W ! S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
IMM() ; -- immunization
 Q $P($G(^AUTTIMM(+N,0)),U)_"  "_$E($P($G(^AUTTIMM(+N,0)),U,3),1,3)
 ;
SER() ; -- series
 N Y S Y=$P(N,U,4) S C=$P(^DD(9000010.11,.04,0),U,2) D Y^DIQ Q Y
 ;
MAX() ; -- max # in series
 Q $P($G(^AUTTIMM(+N,0)),U,5)

ADGPCAC4 ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY-PROVIDER ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D L4 Q:$D(DIRUT)
 D ^ADGPCAC5 Q
 ;
L4 ; -- loop v provider
 N IFN,N
 Q:'$D(^AUPNVPRV("AD",DGVI))
 W @IOF," (4) Provider"
 S IFN=0 F  S IFN=$O(^AUPNVPRV("AD",DGVI,IFN)) Q:'IFN  D 4 Q:$D(DIRUT)
 Q:$D(DIRUT)  D Q Q
 ;
4 ; -- display provider info
 Q:'$D(^AUPNVPRV(IFN,0))  S N=^(0)
 W !!?14,"Provider: ",$$PRV,!?5,"Primary/Secondary: ",$$PRI
 W ?38,"Operating/Attending: ",$$OPA
 ; -- form feed?
 W ! Q:($Y+4)'>IOSL  K DIR S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
Q ; -- cleanup
 K DIR W ! S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
PRV() ; -- provider
 I $P(^DD(9000010.06,.01,0),U,2)["200" Q $P($G(^VA(200,+N,0)),U)
 Q $P($G(^DIC(16,+N,0)),U)
 ;
PRI() ; -- primary/secondary
 N Y S Y=$P(N,U,4) S C=$P(^DD(9000010.06,.04,0),U,2) D Y^DIQ Q Y
 ;
OPA() ; -- operating/attending
 N Y S Y=$P(N,U,5) S C=$P(^DD(9000010.06,.05,0),U,2) D Y^DIQ Q Y

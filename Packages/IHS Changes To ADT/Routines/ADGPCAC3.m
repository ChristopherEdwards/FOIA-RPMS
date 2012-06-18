ADGPCAC3 ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY-PROCEDURE ; [ 03/25/1999  11:48 AM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1008**;MAR 25, 1999
 ;
 ;cmi/anch/maw 12/7/2007 patch 1008 added code set versioning DX,PRC
 ;
A ; -- driver
 D L3 Q:$D(DIRUT)
 D ^ADGPCAC4 Q
 ;
L3 ; -- loop v procedure
 N IFN,N
 Q:'$D(^AUPNVPRC("AD",DGVI))
 W @IOF," (3) Procedure"
 S IFN=0 F  S IFN=$O(^AUPNVPRC("AD",DGVI,IFN)) Q:'IFN  D 3 Q:$D(DIRUT)
 Q:$D(DIRUT)  D Q Q
 ;
3 ; -- display procedure/operation info
 Q:'$D(^AUPNVPRC(IFN,0))  S N=^(0)
 W !!?12,"Procedure: ",$$PRC,!?12,"Narrative: ",$$NAR
 W !?12,"Diagnosis: ",$$DX,?54,"Date: ",$$DT
 W !?6,"Principle Proc.? ",$$PP,?49,"Infection? ",$$INF
 W !?3,"Operating Provider: ",$$OPP
 I $P(N,U,14) W !?4,"Anesthesia Admin?: YES",?45,"ASA-PS Class: ",$$ASA
 ; -- form feed?
 W ! Q:($Y+4)'>IOSL  K DIR S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
Q ; -- cleanup
 I $Y>4 K DIR W ! S DIR(0)="E" D ^DIR K DIR,X W @IOF
 Q
 ;
PRC() ; -- procedure
 ;Q $P($G(^ICD0(+N,0)),U)_"  "_$E($P($G(^ICD0(+N,0)),U,4),1,44)
 Q $P($$ICDOP^ICDCODE(+N),U,2)_"  "_$E($P($G(^ICD0(+N,0)),U,4),1,44)
 ;
NAR() ; -- narrative
 Q $P($G(^AUTNPOV(+$P(N,U,4),0)),U)
 ;
DX() ; -- diagnosis
 ;Q $P($G(^ICD9(+$P(N,U,5),0)),U,3)
 Q $P($$ICDDX^ICDCODE(+$P(N,U,5)),U,4)
 ;
DT() ; -- date
 N X S X=$P(N,U,6) Q:'X ""  Q $E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)
 ;
PP() ; -- principle proc
 N Y S Y=$P(N,U,7) S C=$P(^DD(9000010.08,.07,0),U,2) D Y^DIQ Q Y
 ;
INF() ; -- infection
 N Y S Y=$P(N,U,8) S C=$P(^DD(9000010.08,.08,0),U,2) D Y^DIQ Q Y
 ;
OPP() ; -- operating provider
 N Y S Y=$P(N,U,11) S C=$P(^DD(9000010.08,.11,0),U,2) D Y^DIQ Q Y
 ;
ASA() ; -- ASA-PS class
 N Y S Y=$P(N,U,15) S C=$P(^DD(9000010.08,.15,0),U,2) D Y^DIQ Q Y

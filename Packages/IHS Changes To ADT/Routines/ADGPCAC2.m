ADGPCAC2 ; IHS/ADC/PDW/ENM - ADT/PCC DATE ENTRY-POV ; [ 03/25/1999  11:48 AM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1008**;MAR 25, 1999
 ;
 ;cmi/anch/maw 12/7/2007 patch 1008 add code set versioning 2,POV
 ;
A ; -- driver
 D L2 Q:$D(DIRUT)
 D ^ADGPCAC3 Q
 ;
L2 ; -- loop v pov
 N IFN,N
 Q:'$D(^AUPNVPOV("AD",DGVI))
 W @IOF," (2) POV "
 S IFN=0  F  S IFN=$O(^AUPNVPOV("AD",DGVI,IFN)) Q:'IFN  D 2 Q:$D(DIRUT)
 Q:$D(DIRUT)  D Q Q
 ;
2 ; -- display purpose of visit info
 Q:'$D(^AUPNVPOV(IFN,0))  S N=$G(^(0))
 W !!?6,"POV (Diagnosis): ",$$POV
 W !?12,"Narrative: ",$$NAR,!?13,"Modifier: ",$$MOD
 W ?47,"Cause of DX: ",$$CDX,!?4,"Primary/Secondary: ",$$PRI
 N X S X=$P(N,U,9) Q:'X
 ;W !?6,"Cause of Injury: ",$P(^ICD9(X,0),U,3)
 W !?6,"Cause of Injury: ",$P($$ICDDX^ICDCODE(X),U,4)
 W !?4,"Place of Accident: ",$$PLC
 W ?44,"Date of Injury: ",$$IDT
 NEW X I $P(N,U,17)]"" W !?4,"Date of Onset: ",$$ONDT
 ; -- form feed?
 W ! Q:($Y+4)'>IOSL  S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
Q ; -- cleanup
 K DIR W ! S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
POV() ; -- POV (Diagnosis)
 ;Q $P($G(^ICD9(+N,0)),U)_"  "_$E($P($G(^ICD9(+N,0)),U,3),1,44)
 Q $P($$ICDDX^ICDCODE(+N),U,2)_"  "_$E($P($$ICDDX^ICDCODE(+N),U,4),1,44)
 ;
NAR() ; -- provider narrative
 Q $P($G(^AUTNPOV(+$P(N,U,4),0)),U)
 ;
MOD() ; -- modifier
 N Y,C S Y=$P(N,U,6) S C=$P(^DD(9000010.07,.06,0),U,2) D Y^DIQ Q Y
 ;
CDX() ; -- cause of dx
 N Y,C S Y=$P(N,U,7) S C=$P(^DD(9000010.07,.07,0),U,2) D Y^DIQ Q Y
 ;
PRI() ; -- primary/secondary
 N Y,C S Y=$P(N,U,12) S C=$P(^DD(9000010.07,.12,0),U,2) D Y^DIQ Q Y
 ;
PLC() ; -- place of accident
 N Y,C S Y=$P(N,U,11) S C=$P(^DD(9000010.07,.11,0),U,2) D Y^DIQ Q Y
 ;
IDT() ; -- date of injury
 N X S X=$P(N,U,13) Q:'X ""  Q $E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)
 ;
ONDT() ; -- date of onset
 N Y S Y=$P(N,U,17) D DD^%DT Q Y

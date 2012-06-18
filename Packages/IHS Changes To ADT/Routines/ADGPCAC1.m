ADGPCAC1 ; IHS/ADC/PDW/ENM - ADT/PCC DATA ENTRY ; [ 03/25/1999  11:48 AM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1008**;MAR 25, 1999
 ;
 ;cmi/anch/maw 12/7/2007 patch 1008 add code set versioning ADX
 ;
A ; -- main
 D 1,Q Q:$D(DIRUT)
 D ^ADGPCAC2 Q
 ;
1 ; -- admission
 N IFN,N,DN0,VN0
 S IFN=$O(^AUPNVINP("AD",DGVI,0)),N=$G(^AUPNVINP(IFN,0))
 S DN0=^DPT(DFN,0) S VN0=^AUPNVSIT(DGVI,0),APCDDATE=+VN0
 W @IOF,!," NAME: ",$E($P(DN0,U),1,25)
 W ?35,"HRCN: ",$$HRCN^ADGF,?58,"SSN: ",$P(DN0,U,9)
 W !?36,"DOB: ",$$DOB,?52,"COMMUNITY: ",$$COM
 ; -- section 1 data
 W !!," (1)   Admission Date: ",$$ADT,!?7,"Discharge Date: ",$$DDT
 W !?4,"Admitting Service: ",$$ATS,?45,"Disch Service: ",$$DTS
 W !?7,"Admission Type: ",$$ATY,?44,"Discharge Type: ",$$DTY
 W !?6,"No. of Consults: ",$P(N,U,8),?27,"Adm Dx: ",$$ADX
 W:+$P(N,U,9) ?44,"Transferred To: ",$$TFC
 Q
 ;
Q ; -- cleanup
 K DIR W ! S DIR(0)="E" D ^DIR K DIR,X W @IOF Q
 ;
DOB() ; -- date of birth
 N X S X=$P(DN0,U,3) Q:'X ""  Q $E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)
 ;
COM() ; -- community
 Q $E($P($G(^AUPNPAT(+DFN,11)),U,18),1,15)
 ;
ADT() ; -- admission date
 N Y S Y=+VN0 X ^DD("DD") Q Y
 ;
DDT() ; -- discharge date
 N Y S Y=+N X ^DD("DD") Q Y
 ;
ATS() ; -- admitting service
 Q $P($G(^DIC(45.7,+$P(N,U,4),0)),U)
 ;
DTS() ; -- discharge service
 Q $P($G(^DIC(45.7,+$P(N,U,5),0)),U)
 ;
TFC() ; -- transfer facility
 N Y,C S Y=$P(N,U,9),C=$P(^DD(9000010.02,.09,0),U,2) D Y^DIQ Q Y
 ;
ADX() ; -- admitting dx
 ;Q $P($G(^ICD9(+$P(N,U,12),0)),U)_"  "_$P($G(^(0)),U,3)
 Q $P($$ICDDX^ICDCODE(+$P(N,U,12)),U,2)_"  "_$P($$ICDDX^ICDCODE(+$P(N,U,12)),U,4)
 ;
ATY() ; -- admitting type
 N Y,C S Y=$P(N,U,7),C=$P(^DD(9000010.02,.07,0),U,2) D Y^DIQ Q Y
 ;
DTY() ; -- discharge type
 N Y,C S Y=$P(N,U,6),C=$P(^DD(9000010.02,.06,0),U,2) D Y^DIQ Q Y

DGRP5 ;ALB/MRL - REGISTRATION SCREEN 5/INSURANCE INFORMATION ;06 JUN 88@2300
 ;;5.3;Registration;**190,366**;Aug 13, 1993
 S DGRPW=1,DGRPS=5 D H^DGRPU S Z=1 D WW^DGRPV W " Covered by Health Insurance: " S Z=$S($D(^DPT(DFN,.31)):$P(^(.31),"^",11),1:""),Z=$S(Z="Y":"YES",Z="N":"NO",Z="U":"UNKNOWN",1:"NOT ANSWERED"),Z1=15 D WW1^DGRPV
 ; *REMOVEW !!?3 S Z=" Insurance",Z1=27 D WW1^DGRPV S Z="Policy #",Z1=22 D WW1^DGRPV S Z="Group #",Z1=19 D WW1^DGRPV W "Holder",!?4,"---------",?30,"--------",?52,"-------",?71,"-------"
 ; *REMOVES I1="" F I=0:0 S I=$O(^DPT(DFN,.312,I)) Q:'I  S DGRPX=^(I,0) I $P(DGRPX,"^",4)']""!(+$P(DGRPX,"^",4)'<DT) S I1=1 
 W ! D DISP^IBCNSP2
 ;*REMOVEW:'I1 !?4,"NO ACTIVE (UNEXPIRED) INSURANCE ON FILE FOR THIS APPLICANT"
 W ! S DGRPX=$G(^DPT(DFN,.38)),Z=2 D WW^DGRPV W " Eligible for MEDICAID: ",$S(+DGRPX:"YES",$P(DGRPX,"^",1)=0:"NO",1:DGRPU)
 S Y=$P(DGRPX,"^",2) I Y X ^DD("DD") W "   [last updated ",Y,"]"
 ;; *** Added for Medicaid information
 W ! S Z=3 D WW^DGRPV W " Medicaid Number: ",$P(DGRPX,U,3) ;previous $S($P(DGRPX,U,3)>0:$P(DGRPX,U,3),1:"")
 G ^DGRPP
IN S J="*" F J(1)=9:1:14 I $P(DGRPX,"^",J(1))]"" S J=" "
 S:J="*" DGRPAG="" W !?3,J,$S($D(^DIC(36,+$P(DGRPX,"^",1),0)):$E($P(^(0),"^",1),1,25),1:DGRPU),?30,$S($P(DGRPX,"^",2)]"":$P(DGRPX,"^",2),1:DGRPU),?52,$S($P(DGRPX,"^",3)]"":$P(DGRPX,"^",3),1:DGRPU)
 W ?71,$S($P(DGRPX,"^",6)="v":"APPLICANT",$P(DGRPX,"^",6)="s":"SPOUSE",$P(DGRPX,"^",6)="o":"OTHER",1:"UNKNOWN") K J,X Q
 Q

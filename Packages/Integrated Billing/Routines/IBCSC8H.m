IBCSC8H	;ALB/ARH - MCCR SCREEN 8 (BILL SPECIFIC INFO) HCFA 1500 ; 4/21/92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;HCFA 1500 screen 8
	;
	;MAP TO DGCRSC8H
	;
EN	D ^IBCSCU S IBSR=8,IBSR1="H",IBV1="000" S:IBV IBV1="111" F I="U","U1","UF2",0 S IB(I)=$G(^DGCR(399,IBIFN,I))
	D H^IBCSCU
	S Z=1,IBW=1 X IBWW W " Unable To Work From: " S Y=$P(IB("U"),U,16) X ^DD("DD") W $S(Y'="":Y,1:IBUN)
	W !?4,"Unable To Work To  : " S Y=$P(IB("U"),U,17) X ^DD("DD") W $S(Y'="":Y,1:IBUN)
	S Z=2,IBW=1 X IBWW W " Block 31           : ",$S($P(IB("UF2"),U,1)]"":$P(IB("UF2"),U,1),1:IBUN)
	S Z=3,IBW=1 X IBWW W " Tx Auth. Code      : ",$S($P(IB("U"),U,13)]"":$P(IB("U"),U,13),1:IBUN)
	G ^IBCSCP
Q	Q
	;IBCSC8H

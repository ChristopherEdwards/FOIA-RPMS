IBCSC82	;ALB/MJB - MCCR SCREEN 8 (UB-92 BILL SPECIFIC INFO)  ;27 MAY 88 10:20
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
EN	S IBCUBFT=$$FT^IBCU3(IBIFN) I IBCUBFT=2 K IBCUBFT G ^IBCSC8H ;hcfa 1500
	;
	D ^IBCSCU S IBSR=8,IBSR1=2,IBV1="00000" S:IBV IBV1="11111" F I="U","U1",0,"UF3","UF31","U2" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	D H^IBCSCU
	S Z=1,IBW=1 X IBWW W " Bill Remark     : ",$S($P(IB("U1"),U,8)]"":$P(IB("U1"),U,8),1:IBUN)
	W !,?3," Tx Auth. Code   : ",$S($P(IB("U"),U,13)]"":$P(IB("U"),U,13),1:IBUN)
	W !,?3," Admitting Dx    : " S IBX=$P(IB("U2"),U,1),IBX=$G(^ICD9(+IBX,0)) W $S(IBX'="":$P(IBX,U,1)_" - "_$P(IBX,U,3),1:IBUN)
	S Z=2,IBW=1 X IBWW W " Attending Phy.  : ",$S($P(IB("U1"),U,13)]"":$P(IB("U1"),U,13),1:IBUN)
	W !,?3," Other Physician : ",$S($P(IB("U1"),U,14)]"":$P(IB("U1"),U,14),1:IBUN)
	S Z=3,IBW=1 X IBWW W " Form Locator 2  : ",$S($P(IB("UF3"),U,1)]"":$P(IB("UF3"),U,1),1:IBUN)
	W !,?3," Form Locator 11 : ",$S($P(IB("UF3"),U,2)]"":$P(IB("UF3"),U,2),1:IBUN)
	S Z=4,IBW=1 X IBWW W " Form Locator 31 : ",$S($P(IB("UF3"),U,3)]"":$P(IB("UF3"),U,3),1:IBUN)
	S IBX=0 I $P(IB("UF3"),U,4)'="" W !,?3," Form Locator 37A: ",$P(IB("UF3"),U,4) S IBX=1
	I $P(IB("UF3"),U,5)'="" W !,?3," Form Locator 37B: ",$P(IB("UF3"),U,5) S IBX=1
	I $P(IB("UF3"),U,6)'="" W !,?3," Form Locator 37C: ",$P(IB("UF3"),U,6) S IBX=1
	I 'IBX W !,?3," Form Locator 37 : ",IBUN
	S Z=5,IBW=1 X IBWW W " Form Locator 56 : ",$S($P(IB("UF3"),U,7)]"":$P(IB("UF3"),U,7),1:IBUN)
	W !,?3," Form Locator 57 : ",$S($P(IB("UF31"),U,1)]"":$P(IB("UF31"),U,1),1:IBUN)
	W !,?3," Form Locator 78 : ",$S($P(IB("UF31"),U,2)]"":$P(IB("UF31"),U,2),1:IBUN)
	G ^IBCSCP
Q	Q
	;IBCSC8

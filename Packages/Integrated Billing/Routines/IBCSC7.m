IBCSC7	;ALB/MJB - MCCR SCREEN 7 (INPT. BILLING INFO)  ;27 MAY 88 10:19
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC7
	;
	I $P(^DGCR(399,IBIFN,0),"^",5)'>2 G ^IBCSC8
	I $D(DGRVRCAL) D ^IBCU6 K DGRVRCAL
EN	D ^IBCSCU S IBSR=7,IBSR1="",IBV1="00000" S:IBV IBV1="11111" F I="U","U1",0,"U2" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	D H^IBCSCU
	D 4^IBCVA1,5^IBCVA1
	S IBBT=$P(IB(0),U,4)_$P(IB(0),U,5)_$P(IB(0),U,6)
	S Z=1,IBW=1 X IBWW W " Bill Type   : ",$S('$D(IBBT):IBU,IBBT="":IBU,1:IBBT)
	W ?46,"Timeframe: ",$S($D(IBTF):IBTF,1:"") K IBTF
	;W !?4,"Provider # : ",$S(IB("U2")="":IBU,$P(IB("U2"),U,2)'="":$P(IB("U2"),U,2),1:IBU)
	W !?4,"Covered Days: ",$S(IB("U2")="":IBU,$P(IB("U2"),U,2)'="":$P(IB("U2"),U,2),1:IBU)
	W ?30,"Non-Covered Days: ",$S(IB("U2")="":IBU,$P(IB("U2"),U,3)'="":$P(IB("U2"),U,3),1:IBU)
ROI	S Z=2,IBW=1 X IBWW
	W " Sensitive?  : ",$S(IB("U")="":IBU,$P(IB("U"),U,5)="":IBU,$P(IB("U"),U,5)=1:"YES",1:"NO")
	W ?45,"Assignment: ",$S(IB("U")="":IBU,$P(IB("U"),U,6)="":IBU,$P(IB("U"),U,6)["n":"NO",$P(IB("U"),U,6)["N":"NO",$P(IB("U"),U,6)=0:"NO",1:"YES")
	I $P(IB("U"),U,5)=1 W !?4,"R.O.I. Form : ",$S($P(IB("U"),U,7)=1:"COMPLETED",$P(IB("U"),U,7)=0:"NOT COMPLETED",1:"STATUS UNKNOWN")
	S IBOA="01^02^03^04^05^06^" F I=1:1:5 Q:'$D(IBOCN(I))  I IBOA[IBOCN(I)_"^" S IBOX=1
	W:$D(IBOX) !,?4,"Pow of Atty : ",$S($P(IB("U"),U,3)=1:"COMPLETED",$P(IB("U"),U,3)=0:"NOT COMPLETED",1:"STATUS UNKNOWN")
	;
	S Z=3,IBW=1 X IBWW D FROMTO^IBCSC6
	;
OP	S Z=4,IBW=1 X IBWW W " OP Visits   : " F I=0:0 S I=$O(^DGCR(399,IBIFN,"OP",I)) Q:'I  S Y=I X ^DD("DD") W:$X>67 !?18 W Y_", "
	I '$O(^DGCR(399,IBIFN,"OP",0)) W IBU
	;
	G REV^IBCSC6
	;
	;IBCSC7

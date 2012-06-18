IBCSC5	;ALB/MJB - MCCR SCREEN 5 (OPT. EOC)  ;27 MAY 88 10:15
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC5
	;
EN	I $P(^DGCR(399,IBIFN,0),"^",5)'>2 G ^IBCSC4
	I $D(IBASKCOD) K IBASKCOD D CODMUL^IBCU7
	I $D(DGRVRCAL) D ^IBCU6 K DGRVRCAL
	L ^DGCR(399,IBIFN):1
	D ^IBCSCU S IBSR=5,IBSR1="",IBV1="100000000" F I="U",0 S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"") S:IBV IBV1="111111111"
	D H^IBCSCU
	S IBPTF=$P(IB(0),U,8),IBBT=$P(IB(0),"^",4)_$P(IB(0),"^",5)_$P(IB(0),"^",6)
	D EN4^IBCVA1
	S Z=1,IBW=1 X IBWW W " Event Date : " S Y=$P(IB(0),U,3) D DT^DIQ
	;S Z=2,IBW=1 X IBWW W " Prin. Diag.: ",$S('$D(^DGCR(399,IBIFN,"C")):IBU,$P(^DGCR(399,IBIFN,"C"),U,10)'="":$P(^DGCR(399,IBIFN,"C"),U,10),1:IBU)
	N IBPOARR D SET^IBCSC4D(IBIFN,"",.IBPOARR)
	S Z=2,IBW=1 X IBWW W " Prin. Diag.: " S Y=$$DX^IBCSC4(0) W $S(Y'="":$P(Y,U,4)_" - "_$P(Y,U,2),$P(IB(0),U,19)=2:IBU,1:IBUN)
	F I=1:1:4 S Y=$$DX^IBCSC4(+Y) Q:Y=""  W !?4,"Other Diag.: ",$P(Y,U,4)_" - "_$P(Y,U,2)
	I +Y S Y=$$DX^IBCSC4(+Y) I +Y W !?4,"***There are more diagnoses associated with this bill.***"
	;S Z=2,IBW=1 X IBWW W " Prin. Diag.: ",$S($D(^ICD9(+$P(IB("C"),U,14),0)):$P(^(0),U,3)_" - "_$P(^(0),U,1),$P(IB(0),U,19)=2:IBU,1:IBUN)
	;F I=15:1:18 I $P(IB("C"),U,I)]"" W !?4,"Other Diag.: ",$S($D(^ICD9($P(IB("C"),U,I),0)):$P(^(0),U,3)_" - "_$P(^(0),U,1),1:IBU)
OP	S Z=3,IBW=1 X IBWW W " OP Visits  : " F I=0:0 S I=$O(^DGCR(399,IBIFN,"OP",I)) Q:'I  S Y=I X ^DD("DD") W:$X>67 !?17 W Y_", "
	S:$D(^DGCR(399,"OP")) DGOPV=1 I '$O(^DGCR(399,IBIFN,"OP",0)) W IBU
	S Z=4,IBW=1 X IBWW W " Cod. Method: ",$S($P(IB(0),U,9)="":IBUN,$P(IB(0),U,9)=9:"ICD-9-CM",$P(IB(0),U,9)=4:"CPT-4",1:"HCPCS")
	D WRT:$D(IBPROC)
	;I $D(IBCPT),$P(IB(0),U,9)=4 F I=1:1:3 I $D(IBCPT(I)) W !?4,"CPT Code   : ",$P(^ICPT(IBCPT(I),0),U,2)," - ",$P(^(0),U),?55,"Date: " S Y=$P(^DGCR(399,IBIFN,"C"),U,I+10) D DT^DIQ
	;I $D(IBICD),$P(IB(0),U,9)=9 F I=4:1:6 I $D(IBICD(I)) W !?4,"ICD Code   : ",$E($P(^ICD0(IBICD(I),0),U,4),1,20)," - ",$P(^(0),"^"),?55,"Date: " S Y=$P(^DGCR(399,IBIFN,"C"),U,I+7) D DT^DIQ G:'$D(IBICD(I+1)) OCC
	;I $D(IBHC),$P(IB(0),U,9)=5 F I=7:1:9 I $D(IBHC(I)) W !?4,"HCFA Code  : ",$P(^ICPT(IBHC(I),0),U,2)," - ",IBHCN(I),?55,"Date: " S Y=$P(^DGCR(399,IBIFN,"C"),U,I+4) D DT^DIQ G:'$D(IBHC(I+1)) OCC
	S Z=5,IBW=1 X IBWW W " Rx. Refills: " S Y=$$RX I 'Y W IBUN
OCC	G OCC^IBCSC4
	W !?4,"Opt. Code  : ",IBUN
	G OCC^IBCSC4
	Q
MORE	W !?4,*7,"***There are more procedures associated with this bill.***" S I=0 Q
WRT	;  -write out procedures codes on screen
	S J=0 F I=1:1 S J=$O(IBPROC(J)) Q:'J  S X=$G(@(U_$P($P(IBPROC(J),"^"),";",2)_+IBPROC(J)_",0)")) D  I I>9 D MORE Q
	.W:IBPROC(J)["ICD" !?4,"ICD Code   : ",$E($P(X,"^",4),1,28)_" - "_$P(X,"^")
	.W:IBPROC(J)["CPT" !?4,"CPT Code   : ",$P(X,"^",2)_" - "_$P(X,"^")
	.I $P(IB(0),U,19)=2 S Y=+$P(IBPROC(J),U,11) S:+Y Y=+$G(^IBA(362.3,+Y,0)) W ?58,$P($G(^ICD9(Y,0)),U,1) S Y=$P(IBPROC(J),U,2) D D^DIQ W ?67,Y Q
	.S Y=$P(IBPROC(J),"^",2) D D^DIQ W ?58,"Date: ",Y
	Q
PD()	;prints prosthetic device in external form, retuns 0 if there are nonE
	N IBX,IBY,IBZ,IBN,X S X=0 S IBX=0 F  S IBX=$O(^IBA(362.5,"AIFN"_IBIFN,IBX)) Q:'IBX  D  Q:X>5
	. S IBY=0 F  S IBY=$O(^IBA(362.5,"AIFN"_IBIFN,IBX,IBY)) Q:'IBY  S IBZ=$G(^IBA(362.5,IBY,0)) I IBZ'="" D  Q:X>5
	.. S X=X+1 I X>5 W !,?17,"*** There are more Pros. Items associated with this bill.***" Q
	.. ;S IBN=$G(^RMPR(661,+$P(IBZ,U,3),0)) W:X'=1 ! W ?17,$E($$PIN^IBCSC5B(+IBN),1,35)," - ",$P(IBN,U,1),?65,$$FMTE^XLFDT(+IBZ)
	.. S IBN=$$PIN^IBCSC5B(+$P(IBZ,U,3)) W:X'=1 ! W ?17,$E($P(IBN,U,2),1,35)," - ",$P(IBN,U,1),?65,$$FMTE^XLFDT(+IBZ)
	Q X
	;
RX()	;prints RX REFILLS in external form, returns 0 if there are nonE
	N IBX,IBY,IBZ,IBN,X S X=0 S IBX=0 F  S IBX=$O(^IBA(362.4,"AIFN"_IBIFN,IBX)) Q:'IBX  D  Q:X>5
	. S IBY=0 F  S IBY=$O(^IBA(362.4,"AIFN"_IBIFN,IBX,IBY)) Q:'IBY  S IBZ=$G(^IBA(362.4,IBY,0)) I IBZ'="" D  Q:X>5
	.. S X=X+1 I X>5 W !,?17,"*** There are more RX. Refills associated with this bill.***" Q
	.. S IBN=$G(^PSDRUG(+$P(IBZ,U,4),0)) W:X'=1 ! W ?17,$P(IBN,U,1),?65,$$FMTE^XLFDT(+$P(IBZ,U,3))
	Q X
	;
	;IBCSC5

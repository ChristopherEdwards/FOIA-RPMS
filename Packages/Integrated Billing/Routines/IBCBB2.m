IBCBB2	;ALB/ARH - CONTINUATION OF EDIT CHECKS ROUTINE (HCFA 1500); 04/14/92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRBB2
	;
	N IBI,IBJ,IBN,IBY,IBDX,IBDXL,IBCPT,IBCPTL I '$D(IBER) S IBER=""
	;
	;HCFA 1500: visit CPT must be defined and associated with a revenue code
	;I '$D(^DGCR(399,IBIFN,"CP","AVP"))!'$D(^DGCR(399,IBIFN,"RC","AVC")) S IBER=IBER_"IB070;"
	;
	;HCFA 1500: ICD-9 diagnosis, at least 1 required
	;S IBDX=$G(^DGCR(399,IBIFN,"C")) F I=14:1:17 I $P(IBDX,"^",I)'="" S IBDXL($P(IBDX,"^",I))=""
	;I '$D(IBDXL) S IBER=IBER_"IB071;"
	;
	;
	;HCFA 1500: ICD-9 diagnosis, at least 1 required
	D SET^IBCSC4D(IBIFN,.IBDX) I '$P(IBDX,U,2) S IBER=IBER_"IB071;"
	;
	;HCFA 1500: each CPT procedure must be associated with a dx,
	S (IBN,IBI,IBY)=0 F  S IBI=$O(^DGCR(399,IBIFN,"CP",IBI)) Q:IBI'?1N.N  S IBCPT=^(IBI,0) D  I +IBY S IBN=1
	. Q:$P(IBCPT,"^",1)'["ICPT("
	. S IBY=1 F IBJ=11:1:14 I +$P(IBCPT,"^",IBJ) S IBCPTL(+$P(IBCPT,"^",IBJ))="",IBY=0
	I +IBN S IBER=IBER_"IB072;"
	;
	;HCFA 1500: the dx's associated with procedures must be defined diagnosis for the bill
	S IBI=0 F  S IBI=$O(IBDX(IBI))  Q:'IBI  S IBDXL(IBDX(IBI))=""
	S (IBN,IBI)=0 F  S IBI=$O(IBCPTL(IBI)) Q:'IBI  I '$D(IBDXL(IBI)) S IBN=1
	I +IBN S IBER=IBER_"IB073;"
	;
	Q

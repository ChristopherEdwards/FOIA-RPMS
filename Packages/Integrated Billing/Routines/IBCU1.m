IBCU1	;ALB/MRL - BILLING UTILITY ROUTINE (CONTINUED)  ;01 JUN 88 12:00
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU1
	;
	;procedure doesn't appear to be used (6/4/93), if it is used, what for??
	;where would multiple provider numbers comde from?  ARH
	;BCH    ;Blue Cross/Shield Help
	W ! S IB01=$P($G(^IBE(350.9,1,1)),"^",6)
	I IB01]"" W "CHOOSE FROM",!!?4,"1 - ",$P(IB01,"^",6) F IB00=2,3 I $P(IB01,"^",$S(IB00=2:14,1:15))]"" W !?4,IB00," - ",$P(IB01,"^",$S(IB00=2:14,1:15))
	W:IB01']"" "NO BLUE CROSS/SHIELD PROVIDER NUMBERS IDENTIFIED TO SELECT FROM!" W ! W:IB01]"" !,"OR " W "ENTER BLUE CROSS/SHIELD PROVIDER # (BETWEEN 3-13 CHARACTERS)",! K IB00,IB01 Q
	;
RCD	;Revenue Code Display
	Q:'$D(^DGCR(399,IBIFN,"RC"))
	W @IOF,!,"Revenue Code Listing"
	S DGIFN=0 F IBI=0:0 S DGIFN=$O(^DGCR(399,IBIFN,"RC",DGIFN)) Q:'DGIFN  I $D(^DGCR(399,IBIFN,"RC",DGIFN,0)) S Z=^(0) D DISRC
	I $D(DIC(0)) S DIC(0)=DIC(0)_"N"
	Q
DISRC	W !?4,DGIFN,?8,$P(^DGCR(399.2,+Z,0),"^"),"-",$E($P(^DGCR(399.2,+Z,0),"^",2),1,20),?35,"Units = ",$P(Z,"^",3),?46 S X=$P(Z,"^",2),X2="2$" D COMMA^%DTC W X I $P(Z,"^",5),$D(^DGCR(399.1,$P(Z,"^",5),0)) W ?59,$E($P(^(0),"^"),1,20)
	Q
	;
ORDNXT(IFN)	;CALLED BY TRIGGER ON (362.3,.02) THAT SETS DX PRINT ORDER (362.3,.03),
	;returns the highest print order used on the bill plus 3, returns 3 if no existing print order
	;used for the default print order so that dx's can be printed in order of entry without any input by the user,
	;3 is added to allow spaces for additions, changes, moves
	N X,Y S X="" I $D(^DGCR(399,+$G(IFN),0)) S X=3,Y=0 F  S Y=$O(^IBA(362.3,"AO",+IFN,Y)) Q:'Y  S X=Y+3
	Q X
	;
ORDDUP(ORD,DIFN)	;returns true if print order ORD is already defined for a bill (not same entry)
	N IBX,IBY S IBY=0
	I +$G(ORD) S IBX=$G(^IBA(362.3,+$G(DIFN),0)) I +IBX,+$P(IBX,U,3)'=ORD,$D(^IBA(362.3,"AO",+$P(IBX,U,2),+ORD)) S IBY=1
	Q IBY
	;
DXDUP(DX,DIFN,IFN)	;returns true if DX is already defined for a bill (not same entry)
	;either DIFN or IFN can be passed, both are not needed, DIFN is needed during edit so can reenter the same dx
	N IBX,IBY S IBY=0 I +$G(DX),'$G(IFN) S IBX=$G(^IBA(362.3,+$G(DIFN),0)),IFN=+$P(IBX,U,2)
	I +$G(DX),$D(^IBA(362.3,"AIFN"_+IFN,+DX)),$O(^IBA(362.3,"AIFN"_+IFN,+DX,0))'=+$G(DIFN) S IBY=1
	Q IBY
	;
DXBSTAT(DIFN,IFN)	;returns a diagnosis' bill status (either DIFN or IFN can be passed, both are not needed)
	N IBX,IBY I '$G(IFN) S IBX=$G(^IBA(362.3,+$G(DIFN),0)),IFN=+$P(IBX,U,2)
	S IBY=+$P($G(^DGCR(399,+IFN,0)),U,13)
	Q IBY

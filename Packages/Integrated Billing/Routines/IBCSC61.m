IBCSC61	;ALB/MJB - MCCR SCREEN UTILITY  ;20 JUN 88 10:58
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO IBCSC61
	;
REV	I I>1 W !?4,"Rev. Code",?16,": "
	S DGRCD=$S($D(^DGCR(399.2,+IBREVC(I),0)):^(0),1:""),DGRCD=$P(DGRCD,"^",1)_"-"_$E($P(DGRCD,"^",2),1,17)
	I $P(IBREVC(I),"^",6) S DGRCD=DGRCD_" ("_$P($G(^ICPT(+$P(IBREVC(I),"^",6),0)),"^")_")"
	S X=$S($P(IBREVC(I),"^",4)]"":$P(IBREVC(I),"^",4),1:IBU) I X'=IBU S X2="2$" D COMMA^%DTC
	W DGRCD,?40,"Charges: ",X I $P(IBREVC(I),"^",5)]"",$D(^DGCR(399.1,$P(IBREVC(I),"^",5),0)) W ?62,$E($P(^DGCR(399.1,$P(IBREVC(I),"^",5),0),"^"),1,16)
	Q
	;
CHARGE	S IBCH=0 F I=1:1 Q:'$D(IBREVC(I))  S IBCH=IBCH+($P(IBREVC(I),U,4))
	I IB("U1")]"" S X=$P(IB("U1"),"^",1),X1=$P(IB("U1"),"^",2),IBCH=X-X1
	Q
	;
OFFSET	S IBOFFC="" W !?4,"OFFSET",?16,": " S X=$S(IB("U1")']"":0,1:+$P(IB("U1"),U,2)),X2="2$" S:X IBOFFC=$P(IB("U1"),U,3) D COMMA^%DTC
	W X,"  [",$S($L(IBOFFC):IBOFFC,'$P(X,"$",2):"NO OFFSET RECORDED",1:"OFFSET DESCRIPTION UNSPECIFIED"),"]"
	D CHARGE W !?4,"BILL TOTAL",?16,": " S X=$S('$D(IBCH):0,1:+IBCH),X2="2$" D COMMA^%DTC W X
	K IBOFFC
	Q
	;IBCSC61

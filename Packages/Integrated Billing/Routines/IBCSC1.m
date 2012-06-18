IBCSC1	;ALB/MJB - MCCR SCREEN 1 (DEMOGRAPHICS) ;27 MAY 88 10:13
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC1
	;
BEN	S IBSR=1,IBSR1="",IBV1=$S($D(^XUSEC("DG ELIGIBILITY",DUZ)):"0000000",1:1011000)
	S:IBV IBV1="1111111"
	S IB(0)=$S($D(^DGCR(399,IBIFN,0)):^(0),1:"")
	D:'$D(IBWW) ^IBCSCU D ALL^IBCVA0,H^IBCSCU
	;
1	S Z=1,IBW=1 X IBWW W " DOB    : ",$P(VADM(3),"^",2)
	;
2	S (I1,Z1)="",Z=2,IBW=1 X IBWW W " Alias  : " F I=0:0 S I=$O(^DPT(DFN,.01,I)) Q:I=""  S I1=1 W:$X>40 !?13 S Z1=36,Z=$E($P(^(I,0),"^",1),1,29) W Z,"/"
	W:'I1 "NO ALIAS ON FILE"
	;
3	S Z=3,IBW=1 X IBWW W " Sex    : ",$S($P(VADM(5),U,2)]"":$P(VADM(5),U,2),1:IBU),?48,"Marital: ",$S($D(^DIC(11,+$P(^DPT(DFN,0),U,5),0)):$E($P(^(0),U,1),1,28),1:IBU)
	;
4	S Z=4,IBW=1 X IBWW W " Veteran: ",$S('$D(VAEL(4)):IBU,+VAEL(4):"YES",1:"NO"),?44,"Eligibility: ",$S((VAEL(1)]""):$E($P(^DIC(8,(+VAEL(1)),0),"^",6),1,22),1:IBU)
	F I=.11,.121 S IB(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
	K IBA S IBAD=.11,(IBA1,IBA2)=1 D A^IBCSCU I $P(IB(.121),"^",9)="Y" S IBAD=.121,IBA1=1,IBA2=2 D A^IBCSCU
	;
5	W ! S Z=5,IBW=1 X IBWW W " Address: ",$S($D(IBA(1)):IBA(1),1:"NONE ON FILE"),?46,"Temporary: ",$S($D(IBA(2)):IBA(2),1:"NO TEMPORARY ADDRESS")
	S I=2 F I1=0:0 S I=$O(IBA(I)) Q:I=""  W:I#2!($X>50) !?13 W:'(I#2) ?57 W IBA(I)
	;
6	W ! S Z=6,IBW=1 X IBWW W " Pt Short ",!,"    Address: ",$S('$D(^DGCR(399,IBIFN,"M")):IBU,$P(^("M"),U,10)]"":$P(^("M"),U,10),1:IBU)
	;
7	W ! S Z=7,IBW=1 X IBWW W " SC Care: " S X=$P(IB(0),"^",18) W $S(X="":"UNSPECIFIED",X:"YES",1:"NO") I X W "  (Enter '7' to list disabilites)"
	G ^IBCSCP
	Q
	;IBCSC1

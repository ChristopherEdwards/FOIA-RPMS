IBCC	;ALB/MJB - CANCEL UB-82 THIRD PARTY BILL  ;14 JUN 88  10:12
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRC
	;
	;I '$D(IBCAN) W !!,?3,"***** BILLS MAY ONLY BE CANCELLED THROUGH 'CANCEL BILL' OPTION!! *****",!,?5,"***** PLEASE SEE YOUR SUPERVISOR IF YOU REQUIRE ASSISTANCE!! *****" Q
	I '$D(IBCAN) S IBCAN=1
ASK	;
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCC" D T1^%ZOSV ;stop rt clock
	;S XRTL=$ZU(0),XRTN="IBCC-1" D T0^%ZOSV ;start rt clock
	;
	D Q S DIC="^DGCR(399,",DIC(0)="AEMQZ",DIC("A")="Enter BILL NUMBER or Patient NAME: " W !! D ^DIC I Y<1 S IBQUIT=1 G Q1
NOPTF	S IBIFN=+Y I IBCAN>1 D NOPTF^IBCB2 I 'IBAC1 D NOPTF1^IBCB2 G ASK
	F I=0,"S","U1" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	I IBCAN=2,IB("S")]"",+$P(IB("S"),U,16),$P(IB("S"),U,17)]"" W !!,"This bill was cancelled on " S Y=$P(IB("S"),U,17) X ^DD("DD") W Y," by ",$S($P(IB("S"),U,18)']"":IBU,$D(^VA(200,$P(IB("S"),U,18),0)):$P(^(0),U,1),1:IBU),"." G 1
	S IBSTAT=$P(IB(0),"^",13)
CHK	W !!,"ARE YOU SURE YOU WANT TO CANCEL THIS BILL" S %=2 D YN^DICN G:%=0 HELP I %'=1 S IBCCCC=0 G NO
	S IBCCCC=0 W !!,"LAST CHANCE TO CHANGE YOUR MIND..." S DIE("NO^")="",DIE="^DGCR(399,",DA=IBIFN,DR="16;S:'X Y=0;19;S IBCCCC=1;" D ^DIE K DIE,DR
NO	I 'IBCCCC W !!,"<NO ACTION TAKEN>",*7 G ASK:IBCAN<2,Q
	W !!,"...Bill has been cancelled..." D BULL^IBCBULL,BSTAT^IBCDC(IBIFN)
	F I="S","U1" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	S PRCASV("ARREC")=IBIFN,PRCASV("AMT")=$S(IB("U1")']"":0,$P(IB("U1"),"^",1)]"":$P(IB("U1"),"^",1),1:0),PRCASV("DATE")=$P(IB("S"),"^",17),PRCASV("BY")=$P(IB("S"),"^",18)
	S PRCASV("COMMENT")=$S('$D(^IBE(350.9,1,2)):"BILL CANCELLED IN MAS",$P(^IBE(350.9,1,2),"^",7)]"":$P(^(2),"^",7),1:"BILL CANCELLED IN MAS")
	;
	; Cancel the Accounts Receivable record if the A/R status is equal to
	;   104  -  NEW BILL
	;   201  -  BILL INCOMPLETE
	;   220  -  RETURNED FROM AR (NEW)
	; Otherwise, the A/R record should be amended.
	D @($S(("^104^201^220^")[("^"_+$$STA^PRCAFN(IBIFN)_"^"):"CANCEL",1:"AMEND")_"^PRCASVC1") G ASK:IBCAN<2,Q
	;
HELP	W !,?3,"Answer 'YES' or 'Y' if you wish to cancel this bill.",!,?3,"Answer 'NO' or 'N' if you want to abort." G CHK
	Q
1	I $P(IB(0),U,13)=1 W !,"This record was re-opened on " S Y=$P(IB(0),U,14) X ^DD("DD") W Y,"." G CHK
	G ASK
Q1	K:IBCAN=1 IBQUIT K IBCAN
Q	K %,IBEPAR,IBSTAT,IBARST,IBAC1,IB,DFN,IBX,IBZ,DIC,DIE,DR,PRCASV,PRCASVC,X,Y,IBCCCC
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCC" D T1^%ZOSV ;stop rt clock
	Q
	;IBCC

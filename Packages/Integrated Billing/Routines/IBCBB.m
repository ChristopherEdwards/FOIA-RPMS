IBCBB	;ALB/AAS - EDIT CHECK ROUTINE TO BE INVOKED BEFORE ALL BILL APPROVAL ACTIONS ; 2-NOV-89
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRBB
	;
	;IBNDn = IBND(n) = ^ib(399,n)
	;RETURNS:
	;IBER=fields with errors seperated by semi-colons
	;PRCASV("OKAY")=1 if iber="" and $D(prcasv("array")) compete
	;
GVAR	;set up variablesfor mccr
	Q:'$D(IBIFN)  F I=0,"M","U","U1","S" S @("IBND"_I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	S IBBNO=$P(IBND0,"^"),DFN=$P(IBND0,"^",2),IBEVDT=$P(IBND0,"^",3)
	S IBLOC=$P(IBND0,"^",4),IBCL=$P(IBND0,"^",5),IBTF=$P(IBND0,"^",6)
	S IBAT=$P(IBND0,"^",7),IBWHO=$P(IBND0,"^",11),IBST=$P(IBND0,"^",13),IBFT=$P(IBND0,"^",19)
	S IBFDT=$P(IBNDU,"^",1),IBTDT=$P(IBNDU,"^",2)
	S IBTC=$P(IBNDU1,"^",1),IBFY=$P(IBNDU1,"^",9),IBFYC=$P(IBNDU1,"^",10)
	S IBEU=$P(IBNDS,"^",2),IBRU=$P(IBNDS,"^",5),IBAU=$P(IBNDS,"^",8)
	Q
	;
EN	;Entry to check for errors
	S IBER="" D GVAR Q:'$D(IBND0)
	;
	;Bill number in correct format
	;I IBBNO'?6N&(IBBNO'?5N1U) S IBER="IB044;"
	;
	;patient in patient file
	I DFN="" S IBER=IBER_"IB057;"
	I DFN]"",'$D(^DPT(DFN)) S IBER=IBER_"IB057;"
	;
	;Event date in correct format
	I IBEVDT="" S IBER=IBER_"IB049;"
	I IBEVDT]"",IBEVDT'?7N&(IBEVDT'?7N1".".N) S IBER=IBER_"IB049;"
	;
	;location of care
	I IBLOC=""!($L(IBLOC)>1)!("127"'[IBLOC) S IBER=IBER_"IB055;"
	;
	;Bill classification
	I IBCL=""!($L(IBCL)>1)!("1234"'[IBCL) S IBER=IBER_"IB043;"
	;
	;Timeframe of Bill
	I IBTF=""!($L(IBTF)>1)!("01234567"'[IBTF) S IBER=IBER_"IB063;"
	;May want to check timeframe versus other bills for this episode (later)
	;
	;Rate Type
	I IBAT="" S IBER=IBER_"IB059;"
	I IBAT]"",'$D(^DGCR(399.3,IBAT,0)) S IBER=IBER_"IB059;"
	I IBAT]"",$D(^DGCR(399.3,IBAT,0)),'$P(^(0),"^",6) S IBER=IBER_"IB059;",IBAT=""
	;I IBAT]"",$D(^DGCR(399.3,IBAT,0)) S IBARTP=$P(^PRCA(430.2,$P(^DGCR(399.3,IBAT,0),"^",6),0),"^",6)
	I IBAT]"",$P($G(^DGCR(399.3,IBAT,0)),"^",6) S IBARTP=$P($$CATN^PRCAFN($P(^DGCR(399.3,IBAT,0),"^",6)),"^",3)
	;Check that AR catagory expects same debtor as defined in who's respon.
	I $D(IBARTP),IBWHO="i"&(IBARTP'="T")!(IBWHO="p"&("PC"'[IBARTP))!(IBWHO="o"&(IBARTP'="N")) S IBER=IBER_"IB058;"
	;
	;Who's Responsible
	I IBWHO=""!($L(IBWHO)>1)!("iop"'[IBWHO) S IBER=IBER_"IB065;"
	I IBWHO="i",'+IBNDM S IBER=IBER_"IB054;"
	I IBWHO="o",'+$P(IBNDM,"^",11) S IBER=IBER_"IB053;"
	;
	G ^IBCBB1

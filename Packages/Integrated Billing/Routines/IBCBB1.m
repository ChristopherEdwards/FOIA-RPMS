IBCBB1	;ALB/AAS - CONTINUATION OF EDIT CHECK ROUTINE ; 2-NOV-89
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRBB1
	;
%	;Bill Status
	I IBST=""!($L(IBST)>1)!("012347"'[IBST) S IBER=IBER_"IB045;"
	I IBST=0 S IBER="IB045;"
	;
	;Statement Covers From
	I IBFDT="" S IBER=IBER_"IB061;"
	I IBFDT]"",IBFDT'?7N&(IBFDT'?7N1".".N) S IBER=IBER_"IB061;"
	S IBFFY=$S($E(IBFDT,4,5)<10:$E(IBFDT,2,3),1:$E(IBFDT,2,3)+1)
	;
	;Statement Covers To
	I IBTDT="" S IBER=IBER_"IB062;"
	I IBTDT]"",IBTDT'?7N&(IBTDT'?7N1".".N) S IBER=IBER_"IB062;"
	S IBTFY=$S($E(IBTDT,4,5)<10:$E(IBTDT,2,3),1:$E(IBTDT,2,3)+1)
	;
	;Statement crosses fiscal years
	I IBTFY'=IBFFY S IBER=IBER_"IB047;"
	;
	;Statement crosses calendar years
	I $E(IBTDT,1,3)'=$E(IBFDT,1,3) S IBER=IBER_"IB046;"
	;
	;Total Charges
	I +IBTC'>0!(+IBTC'=IBTC) S IBER=IBER_"IB064;"
	;
	;Fiscal Year 1
	I IBFY=""!($L(IBFY)'=2)!(IBFY<80)!(IBFY>($S($E(DT,4,5)<10:$E(DT,2,3),1:$E(DT,2,3)+1))) S IBER=IBER_"IB050;"
	;
	;FY 1 Charges
	I +IBFYC'>0!(+IBFYC'=IBFYC) S IBER=IBER_"IB051;"
	;
	;FY 1 Charges minus offset greater than 0
	I +IBFYC-$P(IBNDU1,"^",2)'>0 S IBER=IBER_"IB052;"
	;
	;Check provider link for current user, enterer, reviewer and Authorizor
	I '$D(^VA(200,DUZ,0)) S IBER=IBER_"IB048;"
	I IBEU]"",'$D(^VA(200,IBEU,0)) S IBER=IBER_"IB048;"
	I IBRU]"",'$D(^VA(200,IBRU,0)) S IBER=IBER_"IB060;"
	I IBAU]"",'$D(^VA(200,IBAU,0)) S IBER=IBER_"IB041;"
	;
	;Bill exists and not already new bill
	;I $S('$D(^PRCA(430,IBIFN,0)):1,$P($P(^PRCA(430,IBIFN,0),"^"),"-",2)'=IBBNO:1,1:0) S IBER=IBER_"IB056;"
	;I $P($$BN^PRCAFN(IBIFN),"-",2)'=IBBNO S IBER=IBER_"IB056;"
	;I IBER="",$P(^PRCA(430,IBIFN,0),"^",8)=$O(^PRCA(430.3,"AC",104,"")) S IBER=IBER_"IB040;"
	I IBER="",+$$STA^PRCAFN(IBIFN)=104 S IBER=IBER_"IB040;"
	;
	;asc on bill and more than one visit, ub's only
	I IBFT'=2,IBWHO="i",$D(^DGCR(399,"ASC2",IBIFN)),$O(^($O(^DGCR(399,IBIFN,"OP",0)))) S IBER=IBER_"IB042;"
	;
	;edit checks for HCFA 1500 forms
	I IBFT=2 D ^IBCBB2
	;
	;Other things that could be added:  Revenue Code - calculating charges
	;           Diagnosis Coding, if Cat C - check for other co-payments
	;
	D ARRAY:IBER=""
	;
END	;Don't kill IBifn, IBer, dfn
	K IBBNO,IBEVDT,IBLOC,IBCL,IBTF,IBAT,IBWHO,IBST,IBFDT,IBTDT,IBTC,IBFY,IBFY1,IBAU,IBRU,IBEU,IBARTP,IBFYC,IBNDS,IBND0,IBNDU,IBNDM,IBNDU1,IBFFY,IBTFY,IBFT
	I $D(IBER),IBER="" W !,"No Errors found"
	Q
	;
ARRAY	;Build PRCASV(array)
	K PRCASV
	S X=IBIFN D ^IBCAMS S:Y>0 PRCASV("AMIS")=Y
	S PRCASV("BDT")=DT,PRCASV("ARREC")=IBIFN
	S PRCASV("APR")=DUZ
	S PRCASV("PAT")=DFN,PRCASV("CAT")=$P(^DGCR(399.3,IBAT,0),"^",6)
	I IBWHO="i" S PRCASV("DEBTOR")=+IBNDM_";DIC(36,"
	S PRCASV("DEBTOR")=$S(IBWHO="p":DFN_";DPT(",IBWHO="o":$P(IBNDM,"^",11)_";DIC(4,",IBWHO="i":PRCASV("DEBTOR"),1:"")
	S PRCASV("CARE")=IBLOC_IBCL
	S PRCASV("FY")=$P(IBNDU1,U,9)_U_$S($P(IBNDU1,U,2)]"":($P(IBNDU1,U,10)-$P(IBNDU1,U,2)),1:$P(IBNDU1,U,10))_$S($P(IBNDU1,U,11)]"":U_$P(IBNDU1,U,11)_U_$P(IBNDU1,U,12),1:"")
PLUS	I IBWHO="i",$P(IBNDM,"^",2),$D(^DIC(36,$P(IBNDM,"^",2),0)) S PRCASV("2NDINS")=$P(IBNDM,"^",2)
	I IBWHO="i",$P(IBNDM,"^",3),$D(^DIC(36,$P(IBNDM,"^",3),0)) S PRCASV("3RDINS")=$P(IBNDM,"^",3)
	Q:'$D(^DGCR(399,IBIFN,"I1"))  S IBNDI1=^("I1")
	S:$P(IBNDI1,"^",3)]"" PRCASV("GPNO")=$P(IBNDI1,"^",3)
	S:$P(IBNDI1,"^",15)]"" PRCASV("GPNM")=$P(IBNDI1,"^",15)
	S:$P(IBNDI1,"^",17)]"" PRCASV("INPA")=$P(IBNDI1,"^",17)
	S:$P(IBNDI1,"^",2)]"" PRCASV("IDNO")=$P(IBNDI1,"^",2),PRCASV("INID")=PRCASV("IDNO")
	Q

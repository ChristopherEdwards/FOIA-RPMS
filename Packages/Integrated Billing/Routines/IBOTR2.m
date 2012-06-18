IBOTR2	;ALB/CPM - INSURANCE PAYMENT TREND REPORT - COMPILATION ; 5-JUN-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCROTR2
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBOTR-2" D T0^%ZOSV ;start rt clock
	K ^TMP($J) S IBQUIT=0
	S IBDA="" F IBCNT=1:1 S IBDA=$O(^DGCR(399,"AD",IBRT,IBDA)) Q:'IBDA  D COMP I IBCNT#100=0 S IBQUIT=$$STOP^IBOUTL("Trend Report") Q:IBQUIT
	D:'IBQUIT ^IBOTR3 ; Write the output report.
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOTR2" D T1^%ZOSV ;stop rt clock
	I $D(ZTQUEUED) S ZTREQ="@" Q
	K IB,IBAO,IBAP,IBCNT,IBDA,DFN,IBBC,DIC,DA,DR,DIQ,IBDP,IBDBC,IBSCF,IBSCT,IBQUIT
	D ^%ZISC Q
	;
	;
COMP	; Compile Bill-Accounts/Receivable records for report.
	Q:'$D(^DGCR(399,IBDA,0))  S IBD=^(0),IBBN=$P(IBD,"^"),DFN=+$P(IBD,"^",2),IBBC=$P(IBD,"^",5) S:IBBN="" IBBN="NULL"
	Q:IBBRT="O"&("12"[IBBC)  Q:IBBRT="I"&("34"[IBBC)
	S IBDBC=$$CLO^PRCAFN(IBDA) Q:IBARST="O"&(IBDBC>0)!(IBARST="C"&(IBDBC<0))
	S:IBDBC>0 IBBN=IBBN_" *" S:IBDBC'>0 IBDBC=DT
	I $D(IBBRN),IBBRN="S" S IBBRTY=$S("12"[IBBC:"I",1:"O")
	;
	; - perform edits for Insurance company
	S IBD=$P($G(^DGCR(399,IBDA,"M")),"^") Q:IBICF'="@"&(IBD="")
	I $D(IBIC) Q:IBIC="ALL"&(IBD="")  Q:IBIC="NULL"&(IBD]"")
	S IBINS=$P($G(^DIC(36,+IBD,0)),"^")
	I IBINS="" S IBINS="UNKNOWN" G CANC
	I $G(IBIC)="ALL" G CANC
	I IBICF="@"&(IBICL="") G CANC
	Q:IBICF]IBINS!(IBINS]IBICL)
	;
	; - only keep cancelled bills if 'Bill Cancelled?' field is selected
CANC	S IBINS=IBINS_"@@"_IBD
	Q:'$D(^DGCR(399,IBDA,"S"))  S IBD=^("S")
	I $G(IBAF)'=16 Q:$P(IBD,"^",16)  ; Bill has been cancelled
	;
	; - perform Printed/Treatment date edits
	S IBDP=$P(IBD,"^",12)
	I IBDF=1 Q:IBDP<IBBDT!(IBDP>IBEDT)  ; Date printed is out of range
	S IBD=$G(^DGCR(399,IBDA,"U")),IBSCF=$P(IBD,"^"),IBSCT=$P(IBD,"^",2)
	I IBDF=2 Q:IBSCT<IBBDT!(IBSCF>IBEDT)  ; Treatment dates out of range
	I '$D(IBAF) G BUILD
	;
	; - find the selected field value and compare to selection parameters
	K IB S DIC=399,DA=IBDA,DR=IBAF,DIQ="IB" S:IBAFD DIQ(0)="I"
	D EN^DIQ1 K DIQ
	S:IBAFD IB(399,IBDA,IBAF)=IB(399,IBDA,IBAF,"I")
	S IB=$G(IB(399,IBDA,IBAF))
	Q:IBAFF'="@"&(IB="")
	I $D(IBAFZ) Q:IBAFZ="ALL"&(IB="")  Q:IBAFZ="NULL"&(IB]"")
	I IB="" G BUILD
	I $G(IBAFZ)="ALL" G BUILD
	I IBAFF="@",IBAFL="" G BUILD
	I +IBAFF=IBAFF,+IBAFL=IBAFL Q:IB<IBAFF!(IB>IBAFL)
	E  Q:IBAFF]IB!(IB]IBAFL)
	;
	; - retrieve A/R data and build sort global.
BUILD	S IBAO=$$ORI^PRCAFN(IBDA) S:IBAO<0 IBAO=0
	S IBAP=$$TPR^PRCAFN(IBDA) S:IBAP<0 IBAP=0
	S ^TMP($J,"IBOTR",IBBRTY,IBINS,$$NAMAGE(DFN)_"@@"_IBBN)="^"_IBSCF_"^"_IBSCT_"^"_IBDP_"^"_IBDBC_"^"_IBAO_"^"_IBAP
	Q
	;
NAMAGE(DFN)	; Return patient name and age.
	;           Input:  DFN
	;           Output: Pt name (1st 18 chars)_"("_Pt Age_")"
	N DPT0,X,X1,X2
	S DPT0=$G(^DPT(DFN,0)),X2=$P(DPT0,"^",3)
	I 'X2 S X="UNK"
	E  S X1=DT D ^%DTC S X=X\365.25
	Q $E($P(DPT0,"^"),1,18)_" ("_X_")"

IBOHLD1	;ALB/CJM -  REPORT OF CHARGES ON HOLD ;MARCH 3 1992
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
MAIN	;
	N IBQUIT S IBQUIT=0
QUEUED	; entry point if queued
	;***
	;S XRTL=$ZU(0),XRTN="IBOHLD1-2" D T0^%ZOSV ;start rt clock
	K ^TMP($J)
	D:'$G(IBQUIT) DEVICE D:'$G(IBQUIT) CHRGS,REPORT^IBOHLD2
	D EXIT
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOHLD1" D T1^%ZOSV ;stop rt clock
	Q
EXIT	;
	K ^TMP($J)
	I $D(ZTQUEUED) S ZTREQ="@" Q
	D ^%ZISC
	Q
DEVICE	;
	I $D(ZTQUEUED) Q
	W !!,*7,"*** Margin width of this output is 132 ***"
	W !,"*** This output should be queued ***"
	S %ZIS="QM" D ^%ZIS I POP S IBQUIT=1 Q
	I $D(IO("Q")) S ZTRTN="QUEUED^IBOHLD1",ZTIO=ION,ZTDESC="HELD CHARGES REPORT" D ^%ZTLOAD W !,$S($D(ZTSK):"REQUEST QUEUED TASK="_ZTSK,1:"REQUEST CANCELLED") D HOME^%ZIS K ZTSK S IBQUIT=1 Q
	U IO
	Q
	; indexes records that should be included in report
	;
CHRGS	; charges on hold
	N IBN,DFN,IBNAME,IBND
	S DFN=0 F  S DFN=$O(^IB("AH",DFN)) Q:'DFN  D PAT S IBN=0 F  S IBN=$O(^IB("AH",DFN,IBN)) Q:'IBN  D
	.S IBND=$G(^IB(IBN,0)) Q:'IBND
	.S ^TMP($J,"HOLD",IBNAME,DFN,IBN)=""
	.D BILLS
	Q
PAT	; patient name
	N VAERR,VADM D DEM^VADPT I VAERR K VADM
	S IBNAME=$G(VADM(1)) S:IBNAME="" IBNAME=" "
	Q
BILLS	; find bills for charges on hold
	N IBFR,IBT,IBATYPE,IBTO
	S IBATYPE=$S($P($G(^IBE(350.1,+$P(IBND,"^",3),0)),"^")["OPT":"O",1:"I")
	S IBFR=$P(IBND,"^",14),IBTO=$P(IBND,"^",15)
	I IBATYPE="I" D
	.D INP
	E  D OTP
	Q
INP	; inpatient bills
	N IBEV,IBBILL,IBT,X,IBEND,IBOK
	S IBEV=$P(IBND,"^",16) Q:'IBEV  ; parent event
	S IBEV=($P($G(^IB(IBEV,0)),"^",17)\1) Q:'IBEV  ; date of parent event
	S X1=IBEV,X2=1 D C^%DTC S IBEND=X
	S IBT=(IBEV-.0001) F  S IBT=$O(^DGCR(399,"D",IBT)) Q:'IBT!(IBT'<IBEND)  S IBBILL=0 F  S IBBILL=$O(^DGCR(399,"D",IBT,IBBILL)) Q:IBBILL=""  D
	.D INPTCK
	.I IBOK S ^TMP($J,"HOLD",IBNAME,DFN,IBN,IBBILL)=""
	Q
	;
INPTCK	; does bill belong to charge? returns IBOK=0 if no
	N IBBILL0,IBBILLU
	S IBBILL0=$G(^DGCR(399,IBBILL,0)),IBBILLU=$G(^("U"))
	S IBOK=1
CK1	; for same patient?
	I DFN=$P(IBBILL0,"^",2)
	S IBOK=$T
	Q:'IBOK
CK2	; same type- inp or opt?
	N B S B=$S(+$P(IBBILL0,"^",5)<3:"I",1:"O")
	I B=IBATYPE
	S IBOK=$T
	Q:'IBOK
CK3	; overlap in date range?
	N F,T
	S F=+IBBILLU,T=$P(IBBILLU,"^",2)
	I (IBTO<F)!(IBFR>T)
	S IBOK='$T
	Q:'IBOK
CK4	; insurance bill?
	I $P(IBBILL0,"^",11)="i"
	S IBOK=$T
	Q
OTP	; outpatient bills
	N X,IBV,IBBILL,IBOK,IBBILL0
	S IBV=(IBFR\1)-.0001 F  S IBV=$O(^DGCR(399,"AOPV",DFN,IBV)) Q:'IBV!(IBV>IBTO)  S IBBILL=0 D
	.F  S IBBILL=$O(^DGCR(399,"AOPV",DFN,IBV,IBBILL)) Q:('IBBILL)  D
	..Q:$D(^TMP($J,"HOLD",IBNAME,DFN,IBN,IBBILL))
	..S IBBILL0=$G(^DGCR(399,IBBILL,0)) D CK4 Q:'IBOK
	..S ^TMP($J,"HOLD",IBNAME,DFN,IBN,IBBILL)=""
	Q

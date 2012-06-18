IBCD4	;ALB/ARH - AUTOMATED BILLER (ADD NEW BILL - GATHER DX AND PROCEDURES)  ; 9/5/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
IDX(PTF,DT1,DT2)	;find all 501 movement Diagnosis' for PTF record, check for billable bedsection and SC treatement
	;results: IBT = number of billable movements within date range
	;         ^TMP("IBDX",$J)= PTF IFN, ^TMP("IBDX",$J,DX)="",IBMSG(X)=" error message "
	;where DX = file 45, fields 45.02: 5-9
	N IBMDT,IBDA,IBI,IBX,IBY,IBZ K IBMSG,IBT,^TMP("IBDX",$J) I '$D(^DGPT(+$G(PTF),"M")) G IDXE
	;get next movement after begin date: each movement entry contains data for the previous date range
	S (DT1,IBX)=+$G(DT1)\1 I +$P($G(^DGPT(+PTF,0)),U,2)\1'=DT1 D  ;use all moves on admit date
	. S IBX=$O(^DGPT(+PTF,"M","AM",IBX-.00001)) S:(IBX\1)=DT1 IBX=IBX+.0001 S DT1=$S(+IBX:+IBX,1:+DT1) ;skip first move on begin date
	;get next movement after end date, use all moves on end date
	S DT2=$S(+$G(DT2):DT2\1-.00001,1:DT),IBX=$O(^DGPT(+PTF,"M","AM",DT2)),DT2=$S('IBX:DT+.99,(IBX\1)=DT2:DT2+.6,1:IBX)
	S ^TMP("IBDX",$J)=+PTF
	S (IBT,IBBS,IBSC,IBDA)=0,IBCNT=1 F  S IBDA=$O(^DGPT(+PTF,"M",IBDA)) Q:'IBDA  D
	. S IBX=$G(^DGPT(+PTF,"M",IBDA,0)) Q:IBX=""  S IBMDT=+$P(IBX,U,10) S:'IBMDT IBMDT=DT I IBMDT<DT1!(IBMDT>DT2) Q
	. S IBT=IBT+1 I $P(IBX,U,18)=1 S IBSC=IBSC+1,IBMSG(IBCNT)=$$FMTE^XLFDT(IBMDT)_" movement related to an SC condition.",IBCNT=IBCNT+1 Q
	. I $P($G(^DIC(42.4,+$P(IBX,U,2),0)),U,5)="" S IBBS=IBBS+1,IBMSG(IBCNT)=$$FMTE^XLFDT(IBMDT)_" movement is for a non-billable bedsection.",IBCNT=IBCNT+1 Q
	. S IBZ="" F IBI=5:1:9 S IBY=$P(IBX,U,IBI) I +IBY S ^TMP("IBDX",$J,IBY)=""
	I +IBSC S IBMSG(IBCNT)="PTF record indicates "_+IBSC_" of "_IBT_" movements are for Service Connected Care.",IBCNT=IBCNT+1
	I +IBBS S IBMSG(IBCNT)="PTF record indicates "_+IBBS_" of "_IBT_" movements are for a non-billable bedsection.",IBCNT=IBCNT+1
	S IBT=IBT-IBSC-IBBS I 'IBT S IBMSG(IBCNT)="0 movements are billable."
IDXE	Q
	;
IPRC(PTF,DT1,DT2)	;find 401 and 601 procedures for a PTF record
	;results: ^TMP("IBIPRC",$J,PROC DATE)=PROC1^ ... ^PROC5
	;where PROC DATE = (45.01,45.01,.01) and (45,45.05,.01) and PROC = (45,45.01,8-12) and (45,45.05,4-8)
	N IBX,IBY,IBZ,IBI K ^TMP("IBIPRC",$J) I '$D(^DGPT(+$G(PTF),0)) G IPRCE
	S DT1=$S(+$G(DT1):+DT1,1:0),DT2=$S(+$G(DT2):+DT2,1:9999999),^TMP("IBIPRC",$J)=+PTF
	S IBX=0 F  S IBX=$O(^DGPT(+PTF,"S",IBX)) Q:'IBX  S IBY=$G(^DGPT(+PTF,"S",IBX,0)) I +IBY'<DT1,+IBY'>DT2 D
	. S IBZ="" F IBI=8:1:12 I +$P(IBY,U,IBI) S IBZ=IBZ_+$P(IBY,U,IBI)_U
	. I +IBZ S ^TMP("IBIPRC",$J,+IBY)=$G(^TMP("IBIPRC",$J,+IBY))_IBZ
	S IBX=0 F  S IBX=$O(^DGPT(+PTF,"P",IBX)) Q:'IBX  S IBY=$G(^DGPT(+PTF,"P",IBX,0)) I +IBY'<DT1,+IBY'>DT2 D
	. S IBZ="" F IBI=5:1:9 I +$P(IBY,U,IBI) S IBZ=IBZ_+$P(IBY,U,IBI)_U
	. I +IBZ S ^TMP("IBIPRC",$J,+IBY)=$G(^TMP("IBIPRC",$J,+IBY))_IBZ
IPRCE	Q
	;
RXRF(PIFN,RIFN,IBDT)	; returns data on refill on date for rx (RX # ^ DRUG ^ DAYS SUPPLY ^ REFILL DATE ^ QTY ^ NDC #)
	N X,Y,PLN S X="",PLN=$G(^PSRX(+$G(PIFN),0)) I PLN'="" D
	. S RIFN=$G(RIFN) S:'RIFN RIFN=$O(^PSRX(+$G(PIFN),1,"B",+$G(IBDT),0)) S RLN=$G(^PSRX(+$G(PIFN),1,+RIFN,0)) Q:RLN=""
	. S X=$P(PLN,U,1)_"^"_$P(PLN,U,6)_"^"_$P(PLN,U,8)_"^"_$P(RLN,U,1)_"^"_$P(RLN,U,4)_"^"_$P($G(^PSDRUG(+$P(PLN,U,6),2)),U,4)
	Q X
	;
CHK()	;other checks
	N X S X=1 I $G(^DPT(+$G(IBDFN),0))="" S X="0^Patient information lacking."
	Q X
	;
CHKSYS()	;various checks to determine if bill can be created, returns true if passes   XXXXXX
	;if fails then returns "0^error message"
	;requires nothing
	N X,Y,I S X=1
	I '$P($G(^IBE(350.9,1,1)),U,14) S X="0^MAS SERVICE PARAMETER UNKNOWN" G CHKSYSE
	I +$P($$SITE^VASITE,U,3)<1 S X="0^ACILITY UNDEFINED" G CHKSYSE
	;G:$D(IBB) CHKSYSE
	;I '$D(DUZ(0)) S X="0^FILEMAN ACCESS UNDEFINED" G CHKSYSE
	;I $S($D(DLAYGO):2\1-(DLAYGO\1),1:1),DUZ(0)'="@",$D(^DIC(399,0,"LAYGO"))  S DLAYGO=399
CHKSYSE	Q X
	;
GVARS(IFN)	;get data on bill IFN
	N I S X=1 I '$G(^DGCR(399,+$G(IFN),0)) S X=0 G GVARSE
	F I=0,"M" S IB(I)=$G(^DGCR(399,+IFN,I))
	S DGINPAR=$P($G(^DIC(36,+IB("M"),0)),U,6,10)
GVARSE	Q X

IBTRE6	;ALB/AAS - CLAIMS TRACKING OUTPUT CLIN DATA ; 2-SEP-1993
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
ADMDIAG(IBTRN)	; -- output admitting diagnosis (inpatient)
	;
	N X S X=""
	I '$G(IBTRN) G ADMDQ
	S IBETYP=$$TRTP^IBTRE1(IBTRN) I IBETYP>1 G ADMDQ
	S X=$$DIAG(+$O(^IBT(356.9,"ADG",+$P(^IBT(356,+IBTRN,0),"^",5),0)),1) I X'="" G ADMDQ
	I $D(VAIN(9)) S X=VAIN(9)
	I '$D(VAIN(9)) D
	.N VAIN,VAINDT
	.S VAINDT=$P(^IBT(356,IBTRN,0),U,6)
	.S VA200="" D INP^VADPT
	.S X=VAIN(9)
ADMDQ	Q X
	;
PDIAG(IBTRN)	; -- return primary diagnosis (inpatient)
	N X S X=""
	I '$G(IBTRN) G PDIAGQ
	S X=$$DIAG(+$G(^IBT(356.9,+$O(^IBT(356.9,"ATP",+$P(^IBT(356,+IBTRN,0),"^",5),1,0)),0)),1)
PDIAGQ	Q X
	;
SDIAG	; -- return secondary diagnosis (inpatient
	Q
	;
ODIAG	; -- return outpatient diagnosis
	Q
	;
DIAG(X,Y)	; -- Expand diagnosis from pointer
	; -- input x = pointer to diag
	;          y = if want text added (zero = number only)
	I '$G(X) Q ""
	Q $P($G(^ICD9(+$G(X),0)),"^")_$S($G(Y):" - "_$P($G(^ICD9(+$G(X),0)),"^",3),1:"")
	;
	;
APROV(IBTRN)	; -- return  provider (inpatient)
	;
	N X S X=""
	I '$G(IBTRN) G APROVQ
	S X=$O(^IBT(356.94,"ATP",+$P(^IBT(356,+IBTRN,0),"^",5),2,0)) I X S X=$P($G(^IBT(356.94,+X,0)),"^",3) G APROVQ
	S X=+$O(^IBT(356.94,"ATP",+$P(^IBT(356,+IBTRN,0),"^",5),1,0)) I X S X=$P($G(^IBT(356.94,+X,0)),"^",3) G APROVQ
	I $D(VAIN(2)) S X=VAIN(2) I 'X S X=$G(VAIN(11))
	I '$D(VAIN(2)) D
	.N VAIN,VAINDT
	.S VAINDT=$P(^IBT(356,IBTRN,0),U,6)
	.S VA200="" D INP^VADPT
	.S X=VAIN(2)
	.I 'X S X=VAIN(11)
APROVQ	Q $P($G(^VA(200,+X,0)),"^")
	;
ATTEND	; -- return attendings (inpatient)
	Q
	;
PROV	; -- return providers (inpatient)
	Q
	;
OPROV	; -- returns outpatient providers
	Q
	;
PROC(X,Y)	; -- Expand procedure from pointer
	; input x=proc^^date
	;       y= 1= exand
	;
	I '$G(Z) S Z=1
	I '+$G(X) Q ""
	Q $P($G(^ICD0(+X,0)),"^")_$S($G(Y):" - "_$P($G(^ICD0(+X,0)),"^",4),1:"")
	;
OPROC	; -- outpatient procedures
	Q
	;
IPROC	; -- inpatient procedures
	Q
	;
LISTP(IBTRN,IBXY)	; -- return last y  procedures for a tracking entry
	; -- input  ibtrn = tracking file pointer
	; -- output array of procedure by date - ibxy(date)=procedure node
	;
	N IBDGPM,IBDT,IBDA,IBX,IBCNT
	S (IBX,IBDT)="",IBXY=0
	I '$G(IBTRN) G LISTPQ
	S IBDGPM=$P($G(^IBT(356,IBTRN,0)),"^",5)
	Q:'IBDGPM
	F  S IBDT=$O(^IBT(356.91,"APP",IBDGPM,IBDT)) Q:'IBDT  S IBDA="" F  S IBDA=$O(^IBT(356.91,"APP",IBDGPM,IBDT,IBDA)) Q:'IBDA  D
	.S IBX(-IBDT,IBDA)=$G(^IBT(356.91,IBDA,0))
	;
	S IBDT="" F  S IBDT=$O(IBX(IBDT)) Q:'IBDT  S IBDA=0 F  S IBDA=$O(IBX(IBDT,IBDA)) Q:'IBDA  D
	.S IBXY=IBXY+1
	.S IBXY(IBXY)=IBX(IBDT,IBDA)
LISTPQ	Q
	;
LSTPDG(X,IBDT,Y)	; -- return current diagnosis for a tracking entry
	; -- input      X = tracking file pointer
	;            ibdt = date for current diagnosis (null = last)
	;               y = 1= primary (default)
	;                   2= secondary
	;
	N IBY,IBX S (IBY,IBX)=""
	I '$G(X) G LSTPDQ
	S:'$G(IBDT) IBDT=DT S IBDT=-(IBDT+.9)
	S:'$G(Y) Y=1 I Y'=1,Y'=2 S Y=1
	F  S IBDT=$O(^IBT(356.9,"APD",X,IBDT)) Q:'IBDT!($G(IBY))  S IBDA="" F  S IBDA=$O(^IBT(356.9,"APD",X,IBDT,IBDA)) Q:'IBDA!($G(IBY))  D
	.I $P(^IBT(356.9,IBDA,0),U,4)=Y S IBY=+^(0)
LSTPDQ	Q IBY
	;
DTCHK(DA,X)	; -- input transform for 356.94;.01.  date not before admission or after discharge
	N IBTRN,IBOK,IBCDT
	S IBOK=1
	G:'DA!($G(X)<1) DTCHKQ
	S IBTRN=+$O(^IBT(356,"AD",+$P(^IBT(356.94,DA,0),"^",2),0))
	G:'IBTRN DTCHKQ
	S IBCDT=$$CDT^IBTODD1(IBTRN)
	I X<$P(+IBCDT,".") S IBOK=0 G DTCHKQ ;before adm
	I $P(IBCDT,"^",2),X>$P(IBCDT,"^",2) S IBOK=0 G DTCHKQ ; after disch
	I X>$$FMADD^XLFDT(DT,7) S IBOK=0 G DTCHKQ
	;
DTCHKQ	Q IBOK

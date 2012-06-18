IBACVA1	;ALB/CPM - BILL CHAMPVA SUBSISTENCE CHARGE ; 29-JUL-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
BILL	; Create the CHAMPVA inpatient subsistence charge.
	S IBY=1 I '$$CHECK^IBECEAU(0) D ERRMSG^IBACVA2(1) G BILLQ
	S (IBCHGT,IBBILLED)=0
	;
	; - loop through each day of the admission, or until limit reached.
	F IBD=IBBDT:1:IBEDT S %H=IBD D YMD^%DTC S IBDT=X D  Q:IBY<0!(IBBILLED)
	.I IBBDT'=IBEDT S VAIP("D")=IBDT_.2359 D IN5^VADPT Q:'VAIP(10)  ; on leave
	.D LIM(IBDT) Q:IBY<0  ; can't find maximum limit
	.D PD(IBDT) Q:IBY<0  ; can't find daily per diem
	.S:'IBCHGT IBFR=IBDT ; set 'from date' on 1st pass
	.S IBCHGT=IBCHGT+IBCHG,IBTO=IBDT ; build cumulative charge/set 'to date'
	.I IBCHGT'<IBLIM S IBCHGT=IBLIM,IBBILLED=1 ; quit if max limit reached
	;
	; - quit if there is no error, no charge to bill.
	I IBY=1,'IBCHGT W:$G(IBJOB)=4 !!,"There are no charges to be billed for this admission!" G BILLQ
	;
	; - send error message if error occurs.
	I $G(IBJOB)'=4,IBY<0 D ERRMSG^IBACVA2(1) G BILLQ
	;
	; - display message and get confirmation for Cancel/Edit/Add.
	I $G(IBJOB)=4 D  G:IBY<0 BILLQ
	.W !!,"The following billing parameters have been calculated:"
	.W !!,"    Bill From: ",$$DAT1^IBOUTL(IBFR)
	.W !,"      Bill To: ",$$DAT1^IBOUTL(IBTO)
	.W !,"       Charge: $",IBCHGT,!
	.D PROC^IBECEAU4("add")
	;
	; - bill the charge
	W !,"Billing the CHAMPVA inpatient subsistence charge..."
	S IBUNIT=1,IBDESC="CHAMPVA SUBSISTENCE",IBCHG=IBCHGT,IBSL="405:"_IBSL
	D ADD^IBECEAU3 W "completed."
	;
	; - need to pass to AR when I get an AR Category...
	; - AND, set IBCOMMIT=1 for C/E/A
	;
BILLQ	Q
	;
LIM(DATE)	; Find the CHAMPVA subsistence limit on DATE.
	;  Input:    DATE  --  The date on which to determine the limit
	;  Output:  IBLIM  --  The maximum subsistence charge for an episode
	N X S IBLIM=0
	S X=$O(^IBE(350.1,"E","CHAMPVA LIMIT",0)) I 'X S IBY="-1^IB083" G LIMQ
	S X=$O(^IBE(350.2,"AIVDT",+X,-(DATE+.1))),X=$O(^(+X,0))
	S IBLIM=$P($G(^IBE(350.2,+X,0)),"^",4) I 'IBLIM S IBY="-1^IB084"
LIMQ	Q
	;
PD(IBDT)	; Find the CHAMPVA per diem charge on IBDT.
	;  Input:    IBDT  --  The date on which to determine the per diem
	;  Output:  IBCHG  --  The CHAMPVA per diem charge on IBDT
	;          IBATYP  --  CHAMPVA Action Type
	S IBATYP=$O(^IBE(350.1,"E","CHAMPVA SUBSISTENCE",0)),IBCHG=0
	I 'IBATYP S IBY="-1^IB008" G PDQ
	D COST^IBAUTL2 I 'IBCHG S IBY="-1^IB029"
PDQ	Q
	;
PREV(DFN,DATE,LINK)	; Billed an admission the CHAMPVA subsistence charge?
	;  Input:     DFN  --  Pointer to patient in file #2
	;            DATE  --  Event (admission) date
	;            LINK  --  Pointer to mvmt in file #405
	;  Output:      0  --  Admission has not been billed, or
	;              >0  --  ien of billed charge in file #350
	I '$G(DFN)!'$G(DATE)!'$G(LINK) G PREVQ
	N IBN,IBND,IBP
	S IBP=0 F  S IBP=$O(^IB("ACVA",DFN,DATE,IBP)) Q:'IBP  S IBN=$$LAST^IBECEAU(IBP),IBND=$G(^IB(IBN,0)) I $P($G(^IBE(350.1,+$P(IBND,"^",3),0)),"^",5)'=2,$P(IBND,"^",4)=("405:"_LINK),"^3^4^"[("^"_+$P(IBND,"^",5)_"^") S Y=IBN Q
PREVQ	Q +$G(Y)

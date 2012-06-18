IBCU81	;ALB/ARH - THIRD PARTY BILLING UTILITIES (AUTOMATED BILLER) ;02 JUL 93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
EABD(IBETYP,IBTDT)	; -- compute earliest auto bill date: date entered plus days delay for event type
	;the difference betwieen this and EABD^IBTUTL is that the autobill of the event type may be turned off
	;and this procedure will still return a date
	; -- input   IBETYPE = pointer to type of entry file
	;            IBTDT   = episode date, if not passed in uses DT
	;
	N X,X1,X2,Y,IBETYPD S Y="" I '$G(IBETYP) G EABDQ
	S IBETYPD=$G(^IBE(356.6,+IBETYP,0)) I '$G(IBTDT) S IBTDT=DT
	S X2=+$P(IBETYPD,"^",6) ;set earliest autobill date to entered date plus days delay
	S X1=IBTDT D C^%DTC S Y=X\1
EABDQ	Q Y
	;
EVBILL(IBTRN)	;check if event is billable, return EABD if it is, the difference between this and BILL^IBTUTL is that
	;this procedure will return a date if the auto biller is turned off for this event type
	;returns "^error message" if it is not billable
	N X,Y,Z,E,IBTRND S (X,Y,E)="" S IBTRND=$G(^IBT(356,+$G(IBTRN),0)) I IBTRND="" G BILLQ
	;
	; -- billed and bill not cancelled and not inpt interim first or continuous
	S Z=$$BILLED^IBCU8(IBTRN),Y=$P(Z,U,2) I +Z,'Y S E="^Event already billed on "_$P($G(^DGCR(399,+Z,0)),U,1)_"." G BILLQ
	;
	; -- special type (not riem. ins), not billable, inactive
	I +$P(IBTRND,U,12) S E="^Bill may not be Reimbursable Insurance, possibly "_$$EXSET^IBEFUNC(+$P(IBTRND,U,12),356,.12)_"." G BILLQ
	I +$P(IBTRND,U,19) S E="^Event has a Reason Not Billable: "_$P($G(^IBE(356.8,+$P(IBTRND,U,19),0)),U,1)_"." G BILLQ
	I '$P(IBTRND,U,20) S E="^Event is Inactive." G BILLQ
	I 'Y S Y=+$G(^IBT(356,+$G(IBTRN),1)) I 'Y S Y=DT
	S X=$$EABD(+$P(IBTRND,U,18),Y)
BILLQ	Q X_E
	;
RXRF(IBTRN)	; returns rx # and refill date for given claims tracking rx entry
	N IBX,IBY,IBZ,X S X="" S IBX=$G(^IBT(356,+$G(IBTRN),0)) I IBX'="" S IBY=$P($G(^PSRX(+$P(IBX,U,8),0)),U,1) I IBY'="" S IBZ=+$G(^PSRX(+$P(IBX,U,8),1,+$P(IBX,U,10),0)) I +IBZ S X=IBY_"^"_IBZ
	Q X

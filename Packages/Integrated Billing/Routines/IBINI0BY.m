IBINI0BY	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.5,.02,1,2,"%D",1,0)
	;;=All rates by revenue code, bedsection, and inverse date effective.
	;;^DD(399.5,.02,1,2,"DT")
	;;=2900501
	;;^DD(399.5,.02,12)
	;;=VALID BILLING BEDSECTIONS ONLY
	;;^DD(399.5,.02,12.1)
	;;=S DIC("S")="I $P(^DGCR(399.1,+Y,0),U,5)"
	;;^DD(399.5,.02,21,0)
	;;=^^1^1^2911025^
	;;^DD(399.5,.02,21,1,0)
	;;=This is the Specialty for which we have approved billing rates.
	;;^DD(399.5,.02,"DT")
	;;=2900504
	;;^DD(399.5,.03,0)
	;;=REVENUE CODE^R*P399.2'^DGCR(399.2,^0;3^S DIC("S")="I $P(^DGCR(399.2,+Y,0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.5,.03,1,0)
	;;=^.1
	;;^DD(399.5,.03,1,1,0)
	;;=399.5^D
	;;^DD(399.5,.03,1,1,1)
	;;=S ^DGCR(399.5,"D",$E(X,1,30),DA)=""
	;;^DD(399.5,.03,1,1,2)
	;;=K ^DGCR(399.5,"D",$E(X,1,30),DA)
	;;^DD(399.5,.03,1,1,3)
	;;=Don't delete this.
	;;^DD(399.5,.03,1,1,"DT")
	;;=2900501
	;;^DD(399.5,.03,1,2,0)
	;;=399.5^AIVDT2^MUMPS
	;;^DD(399.5,.03,1,2,1)
	;;=S:$P(^DGCR(399.5,DA,0),U,2) ^DGCR(399.5,"AIVDT",$P(^(0),U,2),-^(0),X,DA)=""
	;;^DD(399.5,.03,1,2,2)
	;;=K:$P(^DGCR(399.5,DA,0),U,2) ^DGCR(399.5,"AIVDT",$P(^(0),U,2),-^(0),X,DA)
	;;^DD(399.5,.03,1,2,3)
	;;=DON'T DELETE
	;;^DD(399.5,.03,1,2,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.5,.03,1,2,"%D",1,0)
	;;=All rates by revenue code, bedsection, and inverse date effective.
	;;^DD(399.5,.03,1,2,"DT")
	;;=2900501
	;;^DD(399.5,.03,12)
	;;=Select Active Revenue Codes Only!
	;;^DD(399.5,.03,12.1)
	;;=S DIC("S")="I $P(^DGCR(399.2,+Y,0),U,3)"
	;;^DD(399.5,.03,21,0)
	;;=^^1^1^2920211^^
	;;^DD(399.5,.03,21,1,0)
	;;=This is the revenue code that will automatically be used with this rate.
	;;^DD(399.5,.03,"DT")
	;;=2900501
	;;^DD(399.5,.04,0)
	;;=AMOUNT^RNJ7,2O^^0;4^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999)!(X<1) X
	;;^DD(399.5,.04,2)
	;;=S Y(0)=Y S X=Y,X2="2$" D COMMA^%DTC S Y=X
	;;^DD(399.5,.04,2.1)
	;;=S X=Y,X2="2$" D COMMA^%DTC S Y=X
	;;^DD(399.5,.04,3)
	;;=Type a Dollar Amount between 1 and 9999, 2 Decimal Digits
	;;^DD(399.5,.04,21,0)
	;;=^^1^1^2911025^
	;;^DD(399.5,.04,21,1,0)
	;;=This is the unit charge dollar amount for this rate.
	;;^DD(399.5,.04,"DT")
	;;=2900529
	;;^DD(399.5,.05,0)
	;;=ACTIVE^S^0:NOT ACTIVE;1:YES, ACTIVE;^0;5^Q
	;;^DD(399.5,.05,21,0)
	;;=^^4^4^2940214^^
	;;^DD(399.5,.05,21,1,0)
	;;=If a rate is no longer to be used it should be inactivated.  This may be
	;;^DD(399.5,.05,21,2,0)
	;;=necessary if you are building rates for the same care using different
	;;^DD(399.5,.05,21,3,0)
	;;=Revenue Codes and would like to keep the old entries in the file for
	;;^DD(399.5,.05,21,4,0)
	;;=reference purposes.
	;;^DD(399.5,.05,"DT")
	;;=2900501
	;;^DD(399.5,.06,0)
	;;=PAYORS TO USE WITH^S^i:INSURANCE CO.;p:PATIENTS;o:OTHER (INSTITUTIONS);op:PATIENTS & INSTITUTIONS;iop:ALL BUT CAT C'S;iopc:ALL;c:CAT C. BILLS ONLY;opc:ALL BUT INSURANCE CO.'S;^0;6^Q
	;;^DD(399.5,.06,21,0)
	;;=^^10^10^2940214^^
	;;^DD(399.5,.06,21,1,0)
	;;=Enter the payors that this Billing Rate is to be used with.  For the
	;;^DD(399.5,.06,21,2,0)
	;;=purposes of this field, the choices for payer are:
	;;^DD(399.5,.06,21,3,0)
	;;=   i - Insurance companies
	;;^DD(399.5,.06,21,4,0)
	;;=   o - Other (Institutions
	;;^DD(399.5,.06,21,5,0)
	;;=   p - Patients
	;;^DD(399.5,.06,21,6,0)
	;;=   c - Means Test/Cat C bills
	;;^DD(399.5,.06,21,7,0)
	;;= 
	;;^DD(399.5,.06,21,8,0)
	;;=All bills to patients will be considered patient bills except for
	;;^DD(399.5,.06,21,9,0)
	;;=Means test Co-payment bills, which may have a different amount or 
	;;^DD(399.5,.06,21,10,0)
	;;=maximum associated with it.
	;;^DD(399.5,.06,"DT")
	;;=2900504

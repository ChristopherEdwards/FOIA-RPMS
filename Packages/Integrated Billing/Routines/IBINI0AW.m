IBINI0AW	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.042,.02,1,1,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.042,.02,1,1,"%D",1,0)
	;;=Sets/deletes total charges.
	;;^DD(399.042,.02,1,1,"DT")
	;;=2920921
	;;^DD(399.042,.02,3)
	;;=Type a Dollar Amount between 0 and 99999, 2 Decimal Digits
	;;^DD(399.042,.02,21,0)
	;;=^^3^3^2911025^
	;;^DD(399.042,.02,21,1,0)
	;;=This is the unit charge for this revenue code.  It will be
	;;^DD(399.042,.02,21,2,0)
	;;=multiplied times the number of units to determine the total cost for
	;;^DD(399.042,.02,21,3,0)
	;;=this revenue code.
	;;^DD(399.042,.02,"DT")
	;;=2920921
	;;^DD(399.042,.03,0)
	;;=UNITS OF SERVICE^RNJ6,0X^^0;3^K:X'?1.N X I $D(X) S:X']"" X=1
	;;^DD(399.042,.03,1,0)
	;;=^.1
	;;^DD(399.042,.03,1,1,0)
	;;=399.042^TC^MUMPS
	;;^DD(399.042,.03,1,1,1)
	;;=D 31^IBCU2
	;;^DD(399.042,.03,1,1,2)
	;;=D 32^IBCU2
	;;^DD(399.042,.03,1,1,"%D",0)
	;;=^^1^1^2940214^^^
	;;^DD(399.042,.03,1,1,"%D",1,0)
	;;=Adds/deletes total charges.
	;;^DD(399.042,.03,1,1,"DT")
	;;=2920921
	;;^DD(399.042,.03,3)
	;;=Enter the number of units of service (accommodation days, miles, treatments, etc.) rendered to or for this patient for this revenue code.
	;;^DD(399.042,.03,21,0)
	;;=^^3^3^2940214^^^^
	;;^DD(399.042,.03,21,1,0)
	;;=This is the number of day of inpatient care or the number of outpatient
	;;^DD(399.042,.03,21,2,0)
	;;=visits for this revenue code.  It will be multiplied by the
	;;^DD(399.042,.03,21,3,0)
	;;=CHARGES field to determine the TOTAL charges for this revenue code.
	;;^DD(399.042,.03,"DT")
	;;=2920921
	;;^DD(399.042,.04,0)
	;;=TOTAL^RNJ9,2XI^^0;4^K:X?1.10N.1".".2N X
	;;^DD(399.042,.04,1,0)
	;;=^.1^^-1
	;;^DD(399.042,.04,1,1,0)
	;;=399.042^ATC^MUMPS
	;;^DD(399.042,.04,1,1,1)
	;;=S DGXRF=1 D TC^IBCU2 K DGXRF
	;;^DD(399.042,.04,1,1,2)
	;;=S DGXRF=2 D TC^IBCU2 K DGXRF
	;;^DD(399.042,.04,1,1,"%D",0)
	;;=^^1^1^2940216^^^
	;;^DD(399.042,.04,1,1,"%D",1,0)
	;;=Sets/deletes total charges, FY 1 charges.  Also sets FY 2 charges to "".
	;;^DD(399.042,.04,1,1,"DT")
	;;=2920921
	;;^DD(399.042,.04,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(399.042,.04,21,0)
	;;=^^2^2^2911025^
	;;^DD(399.042,.04,21,1,0)
	;;=This is the total charges for this revenue code.  It is computed by the
	;;^DD(399.042,.04,21,2,0)
	;;=system.
	;;^DD(399.042,.04,"DT")
	;;=2920921
	;;^DD(399.042,.05,0)
	;;=BEDSECTION^R*P399.1'^DGCR(399.1,^0;5^S DIC("S")="I $P(^(0),U,5)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.042,.05,1,0)
	;;=^.1
	;;^DD(399.042,.05,1,1,0)
	;;=399.042^ABS^MUMPS
	;;^DD(399.042,.05,1,1,1)
	;;=S ^DGCR(399,DA(1),"RC","ABS",$E(X,1,30),+^DGCR(399,DA(1),"RC",DA,0),DA)=""
	;;^DD(399.042,.05,1,1,2)
	;;=K ^DGCR(399,DA(1),"RC","ABS",$E(X,1,30),+^DGCR(399,DA(1),"RC",DA,0),DA)
	;;^DD(399.042,.05,1,1,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.042,.05,1,1,"%D",1,0)
	;;=Cross reference of all revenue codes with bedsections.
	;;^DD(399.042,.05,12)
	;;=ONLY BILLABLE BEDSECTIONS
	;;^DD(399.042,.05,12.1)
	;;=S DIC("S")="I $P(^(0),U,5)"
	;;^DD(399.042,.05,21,0)
	;;=^^2^2^2931018^^
	;;^DD(399.042,.05,21,1,0)
	;;=If this is an inpatient bill then this is the Specialty associated with
	;;^DD(399.042,.05,21,2,0)
	;;=authorized rates for the type of care provided for this revenue code.
	;;^DD(399.042,.05,23,0)
	;;=^^1^1^2931018^
	;;^DD(399.042,.05,23,1,0)
	;;=Includes only billable bedsections.
	;;^DD(399.042,.05,"DT")
	;;=2900514
	;;^DD(399.042,.06,0)
	;;=PROCEDURE^P81'^ICPT(^0;6^Q
	;;^DD(399.042,.06,1,0)
	;;=^.1^^-1
	;;^DD(399.042,.06,1,1,0)
	;;=399^ASC1^MUMPS
	;;^DD(399.042,.06,1,1,1)
	;;=I $$RC^IBEFUNC1(DA(1),DA) S ^DGCR(399,"ASC1",$E(X,1,30),DA(1),DA)=""

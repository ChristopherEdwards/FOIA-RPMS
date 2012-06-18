IBINI037	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(352.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(352.1,.03,21,3,0)
	;;=for Category C Means Test billing one year but may the next depending
	;;^DD(352.1,.03,21,4,0)
	;;=on legislation.
	;;^DD(352.1,.03,21,5,0)
	;;= 
	;;^DD(352.1,.03,21,6,0)
	;;=It is only necessary to add a new effective date for an appointment type
	;;^DD(352.1,.03,21,7,0)
	;;=if the characteristics need to be time sensitive.
	;;^DD(352.1,.03,"DT")
	;;=2911022
	;;^DD(352.1,.04,0)
	;;=IGNORE MEANS TEST^RS^1:YES;0:NO;^0;4^Q
	;;^DD(352.1,.04,21,0)
	;;=^^2^2^2920415^^^
	;;^DD(352.1,.04,21,1,0)
	;;=Set this field to 'YES' if this appointment type should NOT be billed
	;;^DD(352.1,.04,21,2,0)
	;;=for Category C means test billing.
	;;^DD(352.1,.04,"DT")
	;;=2911021
	;;^DD(352.1,.05,0)
	;;=PRINT ON INSURANCE REPORT^RS^1:YES;0:NO;^0;5^Q
	;;^DD(352.1,.05,21,0)
	;;=^^2^2^2920207^
	;;^DD(352.1,.05,21,1,0)
	;;=Set this field to 'YES' if you would like this appointment type to show
	;;^DD(352.1,.05,21,2,0)
	;;=up on the list of Veterans with insurance and outpatient visits.
	;;^DD(352.1,.05,"DT")
	;;=2911021
	;;^DD(352.1,.06,0)
	;;=DISPLAY ON INPUT SCREEN^RS^1:YES;0:NO;^0;6^Q
	;;^DD(352.1,.06,21,0)
	;;=^^3^3^2940213^^^
	;;^DD(352.1,.06,21,1,0)
	;;=Set this field to 'YES' if you would like this appointment type to
	;;^DD(352.1,.06,21,2,0)
	;;=be displayed as a potential billable visit on the outpatient visit
	;;^DD(352.1,.06,21,3,0)
	;;=screen when creating a third party bill.
	;;^DD(352.1,.06,"DT")
	;;=2911021

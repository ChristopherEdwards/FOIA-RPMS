IBINI0BZ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.5,.07,0)
	;;=NON-STANDARD RATE^S^0:NO;1:YES;^0;7^Q
	;;^DD(399.5,.07,3)
	;;=Enter whether or not this Billing Rate should NOT be set up automatically for bills to the identified payors and bedsections.
	;;^DD(399.5,.07,21,0)
	;;=^^9^9^2900515^
	;;^DD(399.5,.07,21,1,0)
	;;=This field should be answered 'YES' if this billing rate should not
	;;^DD(399.5,.07,21,2,0)
	;;=be automatically set up for all payers identified in the field 'PAYORS
	;;^DD(399.5,.07,21,3,0)
	;;=TO USE WITH."  This billing rate will only be used with insurance 
	;;^DD(399.5,.07,21,4,0)
	;;=companies where this revenue code has been listed in the  
	;;^DD(399.5,.07,21,5,0)
	;;=DIFFERENT REVENUE CODES TO USE field of the Insurance Company File.
	;;^DD(399.5,.07,21,6,0)
	;;= 
	;;^DD(399.5,.07,21,7,0)
	;;=If this field is left blank or answered 'NO' then this Revenue Code
	;;^DD(399.5,.07,21,8,0)
	;;=and amount will be set up automatically for this bedsection when a bill
	;;^DD(399.5,.07,21,9,0)
	;;=is created.
	;;^DD(399.5,.07,"DT")
	;;=2900515

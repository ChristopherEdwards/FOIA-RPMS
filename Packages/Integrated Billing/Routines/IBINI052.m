IBINI052	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.5,.03,21,1,0)
	;;=This is the first day of the year in which the health insurance policy's
	;;^DD(355.5,.03,21,2,0)
	;;=benefits apply.  Exact date (with month and day) is required.
	;;^DD(355.5,.03,23,0)
	;;=^^3^3^2931217^
	;;^DD(355.5,.03,23,1,0)
	;;=This field must match the year for an entry for this patient and policy
	;;^DD(355.5,.03,23,2,0)
	;;=in the annual benefits field.  It is automatically stored by the system
	;;^DD(355.5,.03,23,3,0)
	;;=when creating an entry.  It is not editable.
	;;^DD(355.5,.03,"DT")
	;;=2931217
	;;^DD(355.5,.04,0)
	;;=DEDUCTIBLE MET?^S^0:NO;1:YES;^0;4^Q
	;;^DD(355.5,.04,21,0)
	;;=^^3^3^2930713^^^
	;;^DD(355.5,.04,21,1,0)
	;;=If the dollar amount of claims against this policy is less than the 
	;;^DD(355.5,.04,21,2,0)
	;;=the policy's annual deductible, enter "NO".  If it is equal to or 
	;;^DD(355.5,.04,21,3,0)
	;;=greater than the annual deductible, enter "YES".
	;;^DD(355.5,.04,"DT")
	;;=2930513
	;;^DD(355.5,.05,0)
	;;=AMOUNT OF DEDUCTIBLE MET^NJ9,2^^0;5^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.5,.05,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.5,.05,21,0)
	;;=^^1^1^2930713^
	;;^DD(355.5,.05,21,1,0)
	;;=Enter the dollar amount of claims against this policy.
	;;^DD(355.5,.05,"DT")
	;;=2930513
	;;^DD(355.5,.06,0)
	;;=DEDUCTIBLE (INPT) MET?^S^1:YES;0:NO;^0;6^Q
	;;^DD(355.5,.06,21,0)
	;;=^^4^4^2930713^
	;;^DD(355.5,.06,21,1,0)
	;;=If the dollar amount of claims for inpatient services is less than
	;;^DD(355.5,.06,21,2,0)
	;;=the policy's annual deductible for inpatient services, enter "NO".
	;;^DD(355.5,.06,21,3,0)
	;;=If it is equal to or greater than the annual deductible for such
	;;^DD(355.5,.06,21,4,0)
	;;=services, enter "YES".
	;;^DD(355.5,.06,"DT")
	;;=2930513
	;;^DD(355.5,.07,0)
	;;=AMOUNT OF DEDUCTIBLE (INP) MET^NJ9,2^^0;7^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.5,.07,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.5,.07,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,.07,21,1,0)
	;;=Enter the dollar amount of claims against this policy for inpatient
	;;^DD(355.5,.07,21,2,0)
	;;=services.
	;;^DD(355.5,.07,"DT")
	;;=2930513
	;;^DD(355.5,.08,0)
	;;=DEDUCTIBLE (OPT) MET?^S^0:NO;1:YES;^0;8^Q
	;;^DD(355.5,.08,21,0)
	;;=^^4^4^2930713^
	;;^DD(355.5,.08,21,1,0)
	;;=If the dollar amount of claims for outpatient services is less than
	;;^DD(355.5,.08,21,2,0)
	;;=the policy's annual deductible for outpatient services, enter "NO".
	;;^DD(355.5,.08,21,3,0)
	;;=If it is equal to or greater than the annual deductible for such
	;;^DD(355.5,.08,21,4,0)
	;;=services, enter "YES".
	;;^DD(355.5,.08,"DT")
	;;=2930513
	;;^DD(355.5,.09,0)
	;;=AMOUNT OF DEDUCTIBLE (OPT) MET^NJ6,0^^0;9^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.5,.09,3)
	;;=Type a Number between 0 and 999999, 0 Decimal Digits
	;;^DD(355.5,.09,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,.09,21,1,0)
	;;=Enter the dollar amount of claims against this policy for outpatient
	;;^DD(355.5,.09,21,2,0)
	;;=services.
	;;^DD(355.5,.09,"DT")
	;;=2930513
	;;^DD(355.5,.1,0)
	;;=AMT LIFETIME MAX USED (OPT)^NJ7,0^^0;10^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.5,.1,3)
	;;=Type a Number between 0 and 9999999, 0 Decimal Digits
	;;^DD(355.5,.1,21,0)
	;;=^^3^3^2931214^^^^
	;;^DD(355.5,.1,21,1,0)
	;;=Enter the dollar amount of claims against this policy, which can
	;;^DD(355.5,.1,21,2,0)
	;;=then be compared to the maximum amount available over the life of
	;;^DD(355.5,.1,21,3,0)
	;;=the policy.

IBINI050	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,5.1,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,5.1,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,5.1,21,1,0)
	;;=If this policy provides a benefit for nursing home services, this
	;;^DD(355.4,5.1,21,2,0)
	;;=is the percentage of nursing home charges that the policy will cover.
	;;^DD(355.4,5.1,"DT")
	;;=2930520
	;;^DD(355.4,5.11,0)
	;;=MENTAL HEALTH INPATIENT (%)^NJ3,0^^5;11^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,5.11,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,5.11,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,5.11,21,1,0)
	;;=If this policy provides a benefit for mental health inpatient services,
	;;^DD(355.4,5.11,21,2,0)
	;;=this is the percentage of the charges that the policy will cover.
	;;^DD(355.4,5.11,"DT")
	;;=2930520
	;;^DD(355.4,5.12,0)
	;;=OTHER INPATIENT CHARGES (%)^NJ3,0^^5;12^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,5.12,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,5.12,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,5.12,21,1,0)
	;;=If this policy provides a benefit for other inpatient charges, this
	;;^DD(355.4,5.12,21,2,0)
	;;=is the percentage of those charges that the policy will cover.
	;;^DD(355.4,5.12,"DT")
	;;=2930520
	;;^DD(355.4,5.14,0)
	;;=MH INPT. MAX DAYS PER YEAR^NJ3,0^^5;14^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,5.14,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,5.14,21,0)
	;;=^^3^3^2930708^
	;;^DD(355.4,5.14,21,1,0)
	;;=If this policy provides a benefit for mental health inpatient
	;;^DD(355.4,5.14,21,2,0)
	;;=services, this is the maximum number of days per year of this
	;;^DD(355.4,5.14,21,3,0)
	;;=benefit.
	;;^DD(355.4,5.14,"DT")
	;;=2930708

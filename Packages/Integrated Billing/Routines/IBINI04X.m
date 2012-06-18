IBINI04X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,3.04,0)
	;;=HOME HEALTH MED. EQUIPMENT (%)^NJ3,0^^3;4^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.04,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,3.04,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,3.04,21,1,0)
	;;=If this policy provides a benefit for medical equipment used in
	;;^DD(355.4,3.04,21,2,0)
	;;=home health care services, this is the percentage of that benefit.
	;;^DD(355.4,3.04,"DT")
	;;=2930513
	;;^DD(355.4,3.05,0)
	;;=HOME HEALTH VISIT DEFINITION^F^^3;5^K:$L(X)>30!($L(X)<3) X
	;;^DD(355.4,3.05,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(355.4,3.05,21,0)
	;;=^^2^2^2930607^^
	;;^DD(355.4,3.05,21,1,0)
	;;=If this policy provides for home health visits, this defines the
	;;^DD(355.4,3.05,21,2,0)
	;;=nature of the visits.
	;;^DD(355.4,3.05,"DT")
	;;=2930513
	;;^DD(355.4,3.06,0)
	;;=OCCUPATIONAL THERAPY # VISITS^NJ3,0^^3;6^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.06,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,3.06,21,0)
	;;=^^2^2^2930826^
	;;^DD(355.4,3.06,21,1,0)
	;;=If this policy has a benefit for occupational therapy, then this is
	;;^DD(355.4,3.06,21,2,0)
	;;=the maximum number of OT visits that the policy allows in one year.
	;;^DD(355.4,3.06,"DT")
	;;=2930826
	;;^DD(355.4,3.07,0)
	;;=PHYSICAL THERAPY # VISITS^NJ3,0^^3;7^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.07,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,3.07,21,0)
	;;=^^2^2^2930826^
	;;^DD(355.4,3.07,21,1,0)
	;;=If this policy has a benefit for physical therapy, then this is the
	;;^DD(355.4,3.07,21,2,0)
	;;=maximum number of PT visits that the policy allows in one year.
	;;^DD(355.4,3.07,"DT")
	;;=2930826
	;;^DD(355.4,3.08,0)
	;;=SPEECH THERAPY # VISITS^NJ3,0^^3;8^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.08,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,3.08,21,0)
	;;=^^2^2^2930826^
	;;^DD(355.4,3.08,21,1,0)
	;;=If this policy has a benefit for speech therapy, then this is the
	;;^DD(355.4,3.08,21,2,0)
	;;=maximum number of ST visits that the policy allows in one year.
	;;^DD(355.4,3.08,"DT")
	;;=2930826
	;;^DD(355.4,3.09,0)
	;;=MEDICATION COUNSELING # VISITS^NJ3,0^^3;9^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.09,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,3.09,21,0)
	;;=^^2^2^2940213^^
	;;^DD(355.4,3.09,21,1,0)
	;;=If this policy has a benefit for medication counseling, then this is the
	;;^DD(355.4,3.09,21,2,0)
	;;=maximum number of MC visits that the policy allows in one year.
	;;^DD(355.4,3.09,"DT")
	;;=2930826
	;;^DD(355.4,4.01,0)
	;;=HOSPICE ANNUAL DEDUCTIBLE^NJ9,2^^4;1^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,4.01,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,4.01,21,0)
	;;=^^4^4^2930607^
	;;^DD(355.4,4.01,21,1,0)
	;;=If this policy provides hospice services, this is the amount that
	;;^DD(355.4,4.01,21,2,0)
	;;=the policy does not cover in claims.  This information will be used
	;;^DD(355.4,4.01,21,3,0)
	;;=in calculating whether reimbursement for claims against this policy
	;;^DD(355.4,4.01,21,4,0)
	;;=are appropriate.
	;;^DD(355.4,4.01,"DT")
	;;=2930513
	;;^DD(355.4,4.02,0)
	;;=HOSPICE INPATIENT ANNUAL MAX^NJ9,2^^4;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,4.02,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,4.02,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,4.02,21,1,0)
	;;=If this policy provides hospice inpatient services, this is the

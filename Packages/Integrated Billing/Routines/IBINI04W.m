IBINI04W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,2.11,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,2.11,21,0)
	;;=^^2^2^2930607^^
	;;^DD(355.4,2.11,21,1,0)
	;;=If this policy has a benefit for mental health outpatient services,
	;;^DD(355.4,2.11,21,2,0)
	;;=this is the percentage covered by that benefit.
	;;^DD(355.4,2.11,"DT")
	;;=2930603
	;;^DD(355.4,2.12,0)
	;;=PRESCRIPTION (%)^NJ6,0^^2;12^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.12,3)
	;;=Type a Number between 0 and 999999, 0 Decimal Digits
	;;^DD(355.4,2.12,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,2.12,21,1,0)
	;;=If this policy has a benefit for prescription services, this is the
	;;^DD(355.4,2.12,21,2,0)
	;;=percentage covered by that benefit.
	;;^DD(355.4,2.12,"DT")
	;;=2930513
	;;^DD(355.4,2.13,0)
	;;=OUTPATIENT SURGERY (%)^NJ6,0^^2;13^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.13,3)
	;;=Type a Number between 0 and 999999, 0 Decimal Digits
	;;^DD(355.4,2.13,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,2.13,21,1,0)
	;;=If this policy has a benefit for outpatient surgery services, this
	;;^DD(355.4,2.13,21,2,0)
	;;=is the percentage covered by that benefit.
	;;^DD(355.4,2.13,"DT")
	;;=2930513
	;;^DD(355.4,2.14,0)
	;;=MH OPT. MAX DAYS PER YEAR^NJ3,0^^2;14^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.14,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,2.14,21,0)
	;;=^^3^3^2930708^
	;;^DD(355.4,2.14,21,1,0)
	;;=If this policy provides a benefit for mental health outpatient
	;;^DD(355.4,2.14,21,2,0)
	;;=services, this is the maximum number of days per year of this
	;;^DD(355.4,2.14,21,3,0)
	;;=benefit.
	;;^DD(355.4,2.14,"DT")
	;;=2930708
	;;^DD(355.4,2.15,0)
	;;=OUTPATIENT VISITS PER YEAR^NJ3,0^^2;15^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.15,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,2.15,21,0)
	;;=^^2^2^2930825^
	;;^DD(355.4,2.15,21,1,0)
	;;=If this policy provides outpatient benefits, this is the maximum
	;;^DD(355.4,2.15,21,2,0)
	;;=number of visits per year.
	;;^DD(355.4,2.15,"DT")
	;;=2930825
	;;^DD(355.4,2.17,0)
	;;=ADULT DAY HEALTH CARE^S^0:NO;1:YES;^2;17^Q
	;;^DD(355.4,2.17,21,0)
	;;=^^2^2^2930827^
	;;^DD(355.4,2.17,21,1,0)
	;;=This indicates whether the policy has a benefit for Adult Day Health
	;;^DD(355.4,2.17,21,2,0)
	;;=Care services.
	;;^DD(355.4,2.17,"DT")
	;;=2930827
	;;^DD(355.4,3.01,0)
	;;=HOME HEALTH CARE LEVEL^S^0:NONE;1:NURSES AIDE;2:LPN;3:RN;4:THERAPIST/OTHER;^3;1^Q
	;;^DD(355.4,3.01,21,0)
	;;=^^2^2^2930825^^
	;;^DD(355.4,3.01,21,1,0)
	;;=If this policy provides home health care, this is the highest level
	;;^DD(355.4,3.01,21,2,0)
	;;=of nursing care that it will cover.
	;;^DD(355.4,3.01,"DT")
	;;=2930924
	;;^DD(355.4,3.02,0)
	;;=HOME HEALTH VISITS PER YEAR^NJ3,0^^3;2^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.02,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,3.02,21,0)
	;;=^^2^2^2930825^^
	;;^DD(355.4,3.02,21,1,0)
	;;=If this policy provides home health care, this is the maximum
	;;^DD(355.4,3.02,21,2,0)
	;;=number of visits per year.
	;;^DD(355.4,3.02,"DT")
	;;=2930513
	;;^DD(355.4,3.03,0)
	;;=HOME HEALTH MAX DAYS PER YEAR^NJ3,0^^3;3^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,3.03,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(355.4,3.03,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,3.03,21,1,0)
	;;=If this policy provides home health care, this is the maximum number
	;;^DD(355.4,3.03,21,2,0)
	;;=of days per year of home health care services.
	;;^DD(355.4,3.03,"DT")
	;;=2930513

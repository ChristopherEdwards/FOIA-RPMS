IBINI02V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,6.11,21,0)
	;;=^^1^1^2930805^
	;;^DD(350.9,6.11,21,1,0)
	;;=This is the number of random selections generated this week.
	;;^DD(350.9,6.11,"DT")
	;;=2930804
	;;^DD(350.9,6.12,0)
	;;=MEDICINE ADMISSION COUNTER^NJ2,0^^6;12^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.12,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.12,21,0)
	;;=^^2^2^2930805^
	;;^DD(350.9,6.12,21,1,0)
	;;=This is the number of admissions for this service counted by the
	;;^DD(350.9,6.12,21,2,0)
	;;=claims tracking module so far this week.
	;;^DD(350.9,6.12,"DT")
	;;=2930804
	;;^DD(350.9,6.13,0)
	;;=SURGERY SAMPLE SIZE^NJ2,0^^6;13^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.13,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(350.9,6.13,21,0)
	;;=^^3^3^2930901^^
	;;^DD(350.9,6.13,21,1,0)
	;;=This is the number of required Utilization Reviews that you wish to have
	;;^DD(350.9,6.13,21,2,0)
	;;=done each week for Surgery admissions.  The minimum recommended by
	;;^DD(350.9,6.13,21,3,0)
	;;=the QA office is one per week.
	;;^DD(350.9,6.13,"DT")
	;;=2940113
	;;^DD(350.9,6.14,0)
	;;=SURGERY WEEKLY ADMISSIONS^NJ2,0^^6;14^K:+X'=X!(X>99)!(X<5)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.14,3)
	;;=Type a Number between 5 and 99, 0 Decimal Digits
	;;^DD(350.9,6.14,21,0)
	;;=^^3^3^2930805^^
	;;^DD(350.9,6.14,21,1,0)
	;;=This is the minimum number of admissions for Surgery that your Medical
	;;^DD(350.9,6.14,21,2,0)
	;;=Center generally averages.  This is used along with the Surgery
	;;^DD(350.9,6.14,21,3,0)
	;;=sample size to compute a random number.
	;;^DD(350.9,6.14,"DT")
	;;=2930901
	;;^DD(350.9,6.15,0)
	;;=SURGERY RANDOM NUMBER^NJ2,0^^6;15^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.15,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.15,21,0)
	;;=^^4^4^2940209^^^
	;;^DD(350.9,6.15,21,1,0)
	;;=This is an internally computed random number.  It is re-computed each
	;;^DD(350.9,6.15,21,2,0)
	;;=week.  When the count of the Surgery admissions reaches a multiple of
	;;^DD(350.9,6.15,21,3,0)
	;;=this number it is considered the random selection.  The total number
	;;^DD(350.9,6.15,21,4,0)
	;;=of random selections for UR will not exceed the Surgery sample size.
	;;^DD(350.9,6.15,"DT")
	;;=2930804
	;;^DD(350.9,6.16,0)
	;;=SURGERY ENTRIES MET^NJ2,0^^6;16^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.16,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.16,21,0)
	;;=^^1^1^2930805^
	;;^DD(350.9,6.16,21,1,0)
	;;=This is the number of random selections generated this week.
	;;^DD(350.9,6.16,"DT")
	;;=2930804
	;;^DD(350.9,6.17,0)
	;;=SURGERY ADMISSION COUNTER^NJ2,0^^6;17^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.17,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.17,21,0)
	;;=^^2^2^2930805^
	;;^DD(350.9,6.17,21,1,0)
	;;=This is the number of admissions for this service counted by the
	;;^DD(350.9,6.17,21,2,0)
	;;=claims tracking module so far this week.
	;;^DD(350.9,6.17,"DT")
	;;=2930804
	;;^DD(350.9,6.18,0)
	;;=PSYCH SAMPLE SIZE^NJ2,0^^6;18^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.18,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(350.9,6.18,21,0)
	;;=^^3^3^2930805^
	;;^DD(350.9,6.18,21,1,0)
	;;=This is the number of required Utilization Reviews that you wish to have
	;;^DD(350.9,6.18,21,2,0)
	;;=done each week for Psychiatry admissions.  The minimum recommended by
	;;^DD(350.9,6.18,21,3,0)
	;;=the QA office is one per week.
	;;^DD(350.9,6.18,"DT")
	;;=2940113

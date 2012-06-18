IBINI04Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,5.02,21,2,0)
	;;=for each admission.  
	;;^DD(355.4,5.02,"DT")
	;;=2930520
	;;^DD(355.4,5.03,0)
	;;=INPATIENT LIFETIME MAXIMUM^NJ10,2^^5;3^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.4,5.03,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(355.4,5.03,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.4,5.03,21,1,0)
	;;=If this policy provides inpatient services, this is the maximum
	;;^DD(355.4,5.03,21,2,0)
	;;=amount over the life of this policy for this benefit.
	;;^DD(355.4,5.03,"DT")
	;;=2931028
	;;^DD(355.4,5.04,0)
	;;=INPATIENT ANNUAL MAXIMUM^NJ9,2^^5;4^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,5.04,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,5.04,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.4,5.04,21,1,0)
	;;=If this policy provides inpatient services, this is the maximum
	;;^DD(355.4,5.04,21,2,0)
	;;=annual amount of this benefit.
	;;^DD(355.4,5.04,"DT")
	;;=2930520
	;;^DD(355.4,5.05,0)
	;;=MH LIFETIME INPATIENT MAXIMUM^NJ10,2^^5;5^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.4,5.05,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(355.4,5.05,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,5.05,21,1,0)
	;;=If this policy provides a benefit for mental health inpatient services,
	;;^DD(355.4,5.05,21,2,0)
	;;=this is the maximum amount over the life of the policy for this benefit.
	;;^DD(355.4,5.05,"DT")
	;;=2931028
	;;^DD(355.4,5.06,0)
	;;=MH ANNUAL INPATIENT MAXIMUM^NJ9,2^^5;6^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,5.06,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,5.06,21,0)
	;;=^^3^3^2930607^
	;;^DD(355.4,5.06,21,1,0)
	;;=If this policy provides a benefit for mental health inpatient services,
	;;^DD(355.4,5.06,21,2,0)
	;;=this is the maximum amount that this policy will pay toward these
	;;^DD(355.4,5.06,21,3,0)
	;;=services in one year.
	;;^DD(355.4,5.06,"DT")
	;;=2930520
	;;^DD(355.4,5.07,0)
	;;=DRUG & ALCOHOL LIFETIME MAX^NJ10,2^^5;7^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.4,5.07,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(355.4,5.07,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,5.07,21,1,0)
	;;=If this policy provides a benefit for drug and alcohol services,
	;;^DD(355.4,5.07,21,2,0)
	;;=this is the maximum amount over the life of the policy for this benefit.
	;;^DD(355.4,5.07,"DT")
	;;=2931028
	;;^DD(355.4,5.08,0)
	;;=DRUG & ALCOHOL ANNUAL MAX^NJ9,2^^5;8^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,5.08,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,5.08,21,0)
	;;=^^3^3^2930607^
	;;^DD(355.4,5.08,21,1,0)
	;;=If this policy provides a benefit for drug and alcohol services,
	;;^DD(355.4,5.08,21,2,0)
	;;=this is the maximum amount that this policy will pay toward these
	;;^DD(355.4,5.08,21,3,0)
	;;=services in one year.
	;;^DD(355.4,5.08,"DT")
	;;=2930520
	;;^DD(355.4,5.09,0)
	;;=ROOM AND BOARD (%)^NJ3,0^^5;9^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,5.09,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,5.09,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,5.09,21,1,0)
	;;=If this policy provides a room and board benefit, this is the 
	;;^DD(355.4,5.09,21,2,0)
	;;=percentage of room and board charges that the policy will cover.
	;;^DD(355.4,5.09,"DT")
	;;=2930520
	;;^DD(355.4,5.1,0)
	;;=NURSING HOME (%)^NJ3,0^^5;10^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X

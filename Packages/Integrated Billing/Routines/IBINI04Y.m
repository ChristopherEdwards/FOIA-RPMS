IBINI04Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,4.02,21,2,0)
	;;=maximum amount of coverage for one year.
	;;^DD(355.4,4.02,"DT")
	;;=2930513
	;;^DD(355.4,4.03,0)
	;;=HOSPICE INPT. LIFETIME MAX^NJ10,2^^4;3^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.4,4.03,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(355.4,4.03,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,4.03,21,1,0)
	;;=If this policy provides hospice inpatient services, this is the
	;;^DD(355.4,4.03,21,2,0)
	;;=maximum amount over the life of the policy for this benefit.
	;;^DD(355.4,4.03,"DT")
	;;=2931028
	;;^DD(355.4,4.04,0)
	;;=ROOM AND BOARD (%)^NJ3,0^^4;4^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,4.04,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,4.04,21,0)
	;;=^^2^2^2930607^^^^
	;;^DD(355.4,4.04,21,1,0)
	;;=If this policy provides a room and board benefit, this is the 
	;;^DD(355.4,4.04,21,2,0)
	;;=percentage of the charges that the policy will cover.
	;;^DD(355.4,4.04,"DT")
	;;=2930513
	;;^DD(355.4,4.05,0)
	;;=OTHER INPATIENT CHARGES (%)^NJ3,0^^4;5^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,4.05,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,4.05,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,4.05,21,1,0)
	;;=If this policy provides a benefit for other inpatient charges, this
	;;^DD(355.4,4.05,21,2,0)
	;;=is the percentage covered by that benefit.
	;;^DD(355.4,4.05,"DT")
	;;=2930513
	;;^DD(355.4,4.06,0)
	;;=IV INFUSION OPT.^S^0:NO;1:YES;^4;6^Q
	;;^DD(355.4,4.06,21,0)
	;;=^^2^2^2930826^
	;;^DD(355.4,4.06,21,1,0)
	;;=This indicates whether the policy has a benefit for outpatient IV
	;;^DD(355.4,4.06,21,2,0)
	;;=Infusion services.
	;;^DD(355.4,4.06,"DT")
	;;=2930826
	;;^DD(355.4,4.07,0)
	;;=IV INFUSION INPT.^S^0:NO;1:YES;^4;7^Q
	;;^DD(355.4,4.07,21,0)
	;;=^^2^2^2930826^
	;;^DD(355.4,4.07,21,1,0)
	;;=This indicates whether the policy has a benefit for inpatient IV
	;;^DD(355.4,4.07,21,2,0)
	;;=Infusion services.
	;;^DD(355.4,4.07,"DT")
	;;=2930826
	;;^DD(355.4,4.08,0)
	;;=IV ANTIBIOTICS OPT.^S^0:NO;1:YES;^4;8^Q
	;;^DD(355.4,4.08,21,0)
	;;=^^2^2^2930826^
	;;^DD(355.4,4.08,21,1,0)
	;;=This indicates whether the policy has a benefit for outpatient IV
	;;^DD(355.4,4.08,21,2,0)
	;;=Antibiotics services.
	;;^DD(355.4,4.08,"DT")
	;;=2930826
	;;^DD(355.4,4.09,0)
	;;=IV ANTIBIOTICS INPT.^S^0:NO;1:YES;^4;9^Q
	;;^DD(355.4,4.09,3)
	;;=
	;;^DD(355.4,4.09,21,0)
	;;=^^2^2^2931001^^^
	;;^DD(355.4,4.09,21,1,0)
	;;=This indicates whether the policy has a benefit for inpatient IV
	;;^DD(355.4,4.09,21,2,0)
	;;=Antibiotics.
	;;^DD(355.4,4.09,"DT")
	;;=2930907
	;;^DD(355.4,5.01,0)
	;;=ANNUAL DEDUCTIBLE (INPATIENT)^NJ9,2^^5;1^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,5.01,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,5.01,21,0)
	;;=^^4^4^2930607^
	;;^DD(355.4,5.01,21,1,0)
	;;=If this policy provides for inpatient services, this is the amount
	;;^DD(355.4,5.01,21,2,0)
	;;=that the policy does not cover in claims.  This information will
	;;^DD(355.4,5.01,21,3,0)
	;;=be used in calculating whether reimburseent for claims against
	;;^DD(355.4,5.01,21,4,0)
	;;=this policy are appropriate.
	;;^DD(355.4,5.01,"DT")
	;;=2930604
	;;^DD(355.4,5.02,0)
	;;=PER ADMISSION DEDUCTIBLE^NJ9,2^^5;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,5.02,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,5.02,21,0)
	;;=^^2^2^2930713^^
	;;^DD(355.4,5.02,21,1,0)
	;;=This is the dollar amount that this policy does not cover in claims

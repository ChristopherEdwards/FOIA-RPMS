IBINI04U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,1.05,21,2,0)
	;;=included, for example 12/12/93@1300.
	;;^DD(355.4,1.05,"DT")
	;;=2930707
	;;^DD(355.4,1.06,0)
	;;=LAST EDIT BY^P200'^VA(200,^1;6^Q
	;;^DD(355.4,1.06,3)
	;;=
	;;^DD(355.4,1.06,9)
	;;=^
	;;^DD(355.4,1.06,21,0)
	;;=^^1^1^2930604^
	;;^DD(355.4,1.06,21,1,0)
	;;=This is the name of the person who last edited the information.
	;;^DD(355.4,1.06,"DT")
	;;=2930520
	;;^DD(355.4,1.07,0)
	;;=PERSON CONTACTED^F^^1;7^K:$L(X)>30!($L(X)<3) X
	;;^DD(355.4,1.07,.1)
	;;=WHO DID YOU TALK TO AT THE INSURANCE COMPANY
	;;^DD(355.4,1.07,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(355.4,1.07,21,0)
	;;=^^2^2^2930607^^
	;;^DD(355.4,1.07,21,1,0)
	;;=This is the name of the person who was contacted for verification 
	;;^DD(355.4,1.07,21,2,0)
	;;=purposes.
	;;^DD(355.4,1.07,"DT")
	;;=2930701
	;;^DD(355.4,1.08,0)
	;;=COMMENTS^F^^1;8^K:$L(X)>80!($L(X)<3) X
	;;^DD(355.4,1.08,3)
	;;=Answer must be 3-80 characters in length.
	;;^DD(355.4,1.08,21,0)
	;;=^^1^1^2930607^
	;;^DD(355.4,1.08,21,1,0)
	;;=Enter any additional information here.
	;;^DD(355.4,1.08,"DT")
	;;=2930520
	;;^DD(355.4,1.09,0)
	;;=CONTACT'S PHONE NUMBER^F^^1;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(355.4,1.09,.1)
	;;=WHAT WAS THEIR PHONE NUMBER
	;;^DD(355.4,1.09,3)
	;;=Answer must be 7-20 characters in length.
	;;^DD(355.4,1.09,21,0)
	;;=^^2^2^2930907^^
	;;^DD(355.4,1.09,21,1,0)
	;;=Enter the telephone number of the person who was contacted for
	;;^DD(355.4,1.09,21,2,0)
	;;=verification purposes.
	;;^DD(355.4,1.09,"DT")
	;;=2930907
	;;^DD(355.4,2.01,0)
	;;=ANNUAL DEDUCTIBLE (OPT)^NJ9,2^^2;1^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,2.01,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,2.01,21,0)
	;;=^^3^3^2930607^
	;;^DD(355.4,2.01,21,1,0)
	;;=This is the amount that this policy does not cover in claims.
	;;^DD(355.4,2.01,21,2,0)
	;;=This information will be used in calculating whether reimbursement
	;;^DD(355.4,2.01,21,3,0)
	;;=for claims against this policy are appropriate.
	;;^DD(355.4,2.01,"DT")
	;;=2930604
	;;^DD(355.4,2.02,0)
	;;=PER VISIT DEDUCTIBLE^NJ8,2^^2;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>99999)!(X<0) X
	;;^DD(355.4,2.02,3)
	;;=Type a Dollar Amount between 0 and 99999, 2 Decimal Digits
	;;^DD(355.4,2.02,21,0)
	;;=^^2^2^2940213^
	;;^DD(355.4,2.02,21,1,0)
	;;=This is the deductible that the patient must pay for each outpatient
	;;^DD(355.4,2.02,21,2,0)
	;;=visit.
	;;^DD(355.4,2.02,"DT")
	;;=2930513
	;;^DD(355.4,2.03,0)
	;;=OUTPATIENT LIFETIME MAXIMUM^NJ10,2^^2;3^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.4,2.03,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(355.4,2.03,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,2.03,21,1,0)
	;;=If this policy has a lifetime maximum benefit for outpatient services,
	;;^DD(355.4,2.03,21,2,0)
	;;=then this is the amount of that benefit.
	;;^DD(355.4,2.03,"DT")
	;;=2931028
	;;^DD(355.4,2.04,0)
	;;=OUTPATIENT ANNUAL MAXIMUM^NJ8,2^^2;4^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>99999)!(X<0) X
	;;^DD(355.4,2.04,3)
	;;=Type a Dollar Amount between 0 and 99999, 2 Decimal Digits
	;;^DD(355.4,2.04,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,2.04,21,1,0)
	;;=If this policy has a benefit for outpatient services, then this
	;;^DD(355.4,2.04,21,2,0)
	;;=amount is the maxiumum of that benefit for one year.
	;;^DD(355.4,2.04,"DT")
	;;=2930513
	;;^DD(355.4,2.05,0)
	;;=MH LIFETIME OUTPATIENT MAX.^NJ7,0^^2;5^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.05,3)
	;;=Type a Number between 0 and 9999999, 0 Decimal Digits

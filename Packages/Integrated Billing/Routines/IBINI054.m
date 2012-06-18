IBINI054	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.5,.18,21,1,0)
	;;=Enter the dollar amount of claims against this policy for mental
	;;^DD(355.5,.18,21,2,0)
	;;=health services.
	;;^DD(355.5,.18,"DT")
	;;=2931214
	;;^DD(355.5,.19,0)
	;;=AMT LIFETIME MAX USED (INPT)^NJ10,2^^0;19^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.5,.19,3)
	;;=Type a Dollar Amount between 0 and 9999999, 0 Decimal Digits
	;;^DD(355.5,.19,21,0)
	;;=^^3^3^2931214^
	;;^DD(355.5,.19,21,1,0)
	;;=Enter the dollar amount of inpatient claims against this policy, which
	;;^DD(355.5,.19,21,2,0)
	;;=can then be compared to the maxium amount available over the life of
	;;^DD(355.5,.19,21,3,0)
	;;=the policy.
	;;^DD(355.5,.19,"DT")
	;;=2931214
	;;^DD(355.5,.2,0)
	;;=AMT MH LIFET MAX USED (OPT)^NJ10,2^^0;20^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(355.5,.2,3)
	;;=Type a Dollar Amount between 0 and 9999999, 0 Decimal Digits
	;;^DD(355.5,.2,21,0)
	;;=^^3^3^2931214^
	;;^DD(355.5,.2,21,1,0)
	;;=Enter the dollar amount of MH claims against this policy, which can
	;;^DD(355.5,.2,21,2,0)
	;;=then be compared to the maximum amount available over the life of
	;;^DD(355.5,.2,21,3,0)
	;;=the policy.
	;;^DD(355.5,.2,"DT")
	;;=2931214
	;;^DD(355.5,1.01,0)
	;;=DATE ENTERED^D^^1;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.5,1.01,9)
	;;=^
	;;^DD(355.5,1.01,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,1.01,21,1,0)
	;;=This is the date that this entry was created.  It is automatically
	;;^DD(355.5,1.01,21,2,0)
	;;=triggered by the creation of the entry.
	;;^DD(355.5,1.01,"DT")
	;;=2930513
	;;^DD(355.5,1.02,0)
	;;=ENTERED BY^P200'^VA(200,^1;2^Q
	;;^DD(355.5,1.02,9)
	;;=^
	;;^DD(355.5,1.02,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,1.02,21,1,0)
	;;=This is the user who created this entry.  It is automatically
	;;^DD(355.5,1.02,21,2,0)
	;;=triggered by the creation of this entry.
	;;^DD(355.5,1.02,"DT")
	;;=2930513
	;;^DD(355.5,1.03,0)
	;;=DATE LAST VERIFIED^D^^1;3^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.5,1.03,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,1.03,21,1,0)
	;;=This is the date that the entry was verified.  It is automatically
	;;^DD(355.5,1.03,21,2,0)
	;;=triggered by the verification process.
	;;^DD(355.5,1.03,"DT")
	;;=2930707
	;;^DD(355.5,1.04,0)
	;;=VERIFIED BY^P200'^VA(200,^1;4^Q
	;;^DD(355.5,1.04,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,1.04,21,1,0)
	;;=This is the person who verified the entry.  It is automatically
	;;^DD(355.5,1.04,21,2,0)
	;;=triggered by the verification process.
	;;^DD(355.5,1.04,"DT")
	;;=2930513
	;;^DD(355.5,1.05,0)
	;;=DATE LAST EDITED^D^^1;5^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.5,1.05,3)
	;;=
	;;^DD(355.5,1.05,9)
	;;=^
	;;^DD(355.5,1.05,21,0)
	;;=^^2^2^2930713^^
	;;^DD(355.5,1.05,21,1,0)
	;;=This is the date that the entry was last edited.  It is automatically
	;;^DD(355.5,1.05,21,2,0)
	;;=triggered whenever editing takes place.
	;;^DD(355.5,1.05,"DT")
	;;=2930707
	;;^DD(355.5,1.06,0)
	;;=EDITED BY^P200'^VA(200,^1;6^Q
	;;^DD(355.5,1.06,9)
	;;=^
	;;^DD(355.5,1.06,21,0)
	;;=^^2^2^2930713^
	;;^DD(355.5,1.06,21,1,0)
	;;=This is the name of the person who last edited the entry.  It is
	;;^DD(355.5,1.06,21,2,0)
	;;=automatically triggered whenever editing takes place.
	;;^DD(355.5,1.06,"DT")
	;;=2930513
	;;^DD(355.5,1.07,0)
	;;=PERSON CONTACTED^RF^^1;7^K:$L(X)>30!($L(X)<3) X
	;;^DD(355.5,1.07,.1)
	;;=WHO DID YOU TALK TO AT THE INSURANCE COMPANY?
	;;^DD(355.5,1.07,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(355.5,1.07,21,0)
	;;=^^2^2^2930702^^^
	;;^DD(355.5,1.07,21,1,0)
	;;=Give the name of the person at the insurance company with whom you

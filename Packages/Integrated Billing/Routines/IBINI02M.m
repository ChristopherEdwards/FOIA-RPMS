IBINI02M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,1.3,21,2,0)
	;;=that has a prescription refill.
	;;^DD(350.9,1.3,23,0)
	;;=^^1^1^2940121^^
	;;^DD(350.9,1.3,23,1,0)
	;;=Should probably be a genaric code like 99070 SPECIAL SUPPLIES.
	;;^DD(350.9,1.3,"DT")
	;;=2940105
	;;^DD(350.9,1.31,0)
	;;=UB-92 ADDRESS COLUMN^NJ2,0^^1;31^K:+X'=X!(X>80)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,1.31,3)
	;;=Type a Number between 1 and 80, 0 Decimal Digits.  Applies only to the UB-92 Claim Form.
	;;^DD(350.9,1.31,21,0)
	;;=^^7^7^2940121^^
	;;^DD(350.9,1.31,21,1,0)
	;;=This is the column on which the Mailing Address should begin printing on
	;;^DD(350.9,1.31,21,2,0)
	;;=the UB-92.  The purpose of this field to to help in placing the mailing
	;;^DD(350.9,1.31,21,3,0)
	;;=address in the area required so that is visible through an envelopes
	;;^DD(350.9,1.31,21,4,0)
	;;=window.  Please note that on the UB-92 the Mailing Address block (FL 38)
	;;^DD(350.9,1.31,21,5,0)
	;;=has a maximum width of 40 characters.  The number entered here will cause
	;;^DD(350.9,1.31,21,6,0)
	;;=the address be moved to the right and therefore the allowable width of 
	;;^DD(350.9,1.31,21,7,0)
	;;=the mailing address will be reduced.
	;;^DD(350.9,1.31,"DT")
	;;=2940112
	;;^DD(350.9,2.01,0)
	;;=AGENT CASHIER MAIL SYMBOL^F^^2;1^K:$L(X)>25!($L(X)<1) X
	;;^DD(350.9,2.01,3)
	;;=Enter the mail routing symbol for the agent cashier.  Answer must be 1-25 characters in length.
	;;^DD(350.9,2.01,21,0)
	;;=^^2^2^2920204^
	;;^DD(350.9,2.01,21,1,0)
	;;=This is the facility mail routing symbol for the Agent Cashier.  This
	;;^DD(350.9,2.01,21,2,0)
	;;=may begin with 04 (for Fiscal Service) at most facilities.
	;;^DD(350.9,2.01,"DT")
	;;=2920204
	;;^DD(350.9,2.02,0)
	;;=AGENT CASHIER STREET ADDRESS^F^^2;2^K:$L(X)>25!($L(X)<3) X
	;;^DD(350.9,2.02,3)
	;;=Enter the street address for the Agent Cashier.  Aswer must be 3-25 characters in length.
	;;^DD(350.9,2.02,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,2.02,21,1,0)
	;;=This is the street address that checks should be mailed to.  This will
	;;^DD(350.9,2.02,21,2,0)
	;;=appear on the on all claim forms as the billing address.
	;;^DD(350.9,2.02,"DT")
	;;=2920302
	;;^DD(350.9,2.03,0)
	;;=AGENT CASHIER CITY^F^^2;3^K:$L(X)>15!($L(X)<1) X
	;;^DD(350.9,2.03,3)
	;;=Enter the City for the Agent Cashier.  Answer must be 1-15 characters in length.
	;;^DD(350.9,2.03,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,2.03,21,1,0)
	;;=This is the City for the Agent Cashier.  This will be part of the address
	;;^DD(350.9,2.03,21,2,0)
	;;=that Checks are mailed to and will appear on the claim forms.
	;;^DD(350.9,2.03,"DT")
	;;=2920204
	;;^DD(350.9,2.04,0)
	;;=AGENT CASHIER STATE^P5'^DIC(5,^2;4^Q
	;;^DD(350.9,2.04,3)
	;;=Enter the state for the Agent Cashier.
	;;^DD(350.9,2.04,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,2.04,21,1,0)
	;;=This is the state for the Agent Cashier.  This will be the State part
	;;^DD(350.9,2.04,21,2,0)
	;;=of the address that checks are mailed to as it appears on the claim forms.
	;;^DD(350.9,2.04,"DT")
	;;=2920204
	;;^DD(350.9,2.05,0)
	;;=AGENT CASHIER ZIP CODE^F^^2;5^K:$L(X)>5!($L(X)<5)!'(X?5N) X
	;;^DD(350.9,2.05,3)
	;;=Answer must be 5 characters in length.
	;;^DD(350.9,2.05,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,2.05,21,1,0)
	;;=Enter the zip code for the Agent Cashier.  This will be the zip code that
	;;^DD(350.9,2.05,21,2,0)
	;;=checks will be mailed to as it should appear on the claim forms.
	;;^DD(350.9,2.05,"DT")
	;;=2920204
	;;^DD(350.9,2.06,0)
	;;=AGENT CASHIER PHONE NUMBER^F^^2;6^K:$L(X)>25!($L(X)<4) X
	;;^DD(350.9,2.06,3)
	;;=Answer must be 4-25 characters in length.

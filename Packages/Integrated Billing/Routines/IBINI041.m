IBINI041	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.3,.02,21,2,0)
	;;= 
	;;^DD(354.3,.02,21,3,0)
	;;=The Medication Copayment exemption based on income uses the 
	;;^DD(354.3,.02,21,4,0)
	;;=Pension plus A&A threshold for income. 
	;;^DD(354.3,.02,21,5,0)
	;;=Income threshold is used to determine patients who require 
	;;^DD(354.3,.02,21,6,0)
	;;=adjudication.
	;;^DD(354.3,.02,22)
	;;=
	;;^DD(354.3,.02,"DT")
	;;=2930319
	;;^DD(354.3,.03,0)
	;;=BASE RATE FOR VETERAN^RNJ10,2^^0;3^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.03,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.03,21,0)
	;;=^^1^1^2921209^
	;;^DD(354.3,.03,21,1,0)
	;;=This is the rate for a single veteran.
	;;^DD(354.3,.03,"DT")
	;;=2930405
	;;^DD(354.3,.04,0)
	;;=BASE RATE WITH 1 DEPENDENT^RNJ10,2^^0;4^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.04,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.04,21,0)
	;;=^^1^1^2930120^^^^
	;;^DD(354.3,.04,21,1,0)
	;;=This is the amount for the Veteran with 1 Dependent.
	;;^DD(354.3,.04,"DT")
	;;=2930405
	;;^DD(354.3,.05,0)
	;;=BASE RATE WITH 2 DEPENDENTS^NJ10,2^^0;5^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.05,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.05,21,0)
	;;=^^3^3^2930430^^^
	;;^DD(354.3,.05,21,1,0)
	;;=This is the amount for the Veteran with 2 Dependents.  If this rate
	;;^DD(354.3,.05,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.05,21,3,0)
	;;=dependent amount, it can be left null and computed.
	;;^DD(354.3,.06,0)
	;;=BASE RATE WITH 3 DEPENDENTS^NJ10,2^^0;6^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.06,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.06,21,0)
	;;=^^3^3^2930430^^^
	;;^DD(354.3,.06,21,1,0)
	;;=This is the amount for the Veteran with 3 Dependents.  If this rate
	;;^DD(354.3,.06,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.06,21,3,0)
	;;=dependent amount for each dependent, it can be left null and computed.
	;;^DD(354.3,.07,0)
	;;=BASE RATE WITH 4 DEPENDENTS^NJ10,2^^0;7^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.07,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.07,21,0)
	;;=^^3^3^2930430^^
	;;^DD(354.3,.07,21,1,0)
	;;=This is the amount for the Veteran with 4 Dependents.  If this rate
	;;^DD(354.3,.07,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.07,21,3,0)
	;;=dependent amount for each dependent, it can be left null and computed.
	;;^DD(354.3,.08,0)
	;;=BASE RATE WITH 5 DEPENDENTS^NJ10,2^^0;8^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.08,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.08,21,0)
	;;=^^3^3^2930430^^
	;;^DD(354.3,.08,21,1,0)
	;;=This is the amount for the Veteran with 5 Dependents.  If this rate
	;;^DD(354.3,.08,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.08,21,3,0)
	;;=dependent amount for each dependent, it can be left null and computed.
	;;^DD(354.3,.08,"DT")
	;;=2930120
	;;^DD(354.3,.09,0)
	;;=BASE RATE WITH 6 DEPENDENTS^NJ10,2^^0;9^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.09,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.09,21,0)
	;;=^^3^3^2930430^^

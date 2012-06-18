IBINI042	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.3,.09,21,1,0)
	;;=This is the amount for the Veteran with 6 Dependents.  If this rate
	;;^DD(354.3,.09,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.09,21,3,0)
	;;=dependent amount for each dependent, it can be left null and computed.
	;;^DD(354.3,.1,0)
	;;=BASE RATE WITH 7 DEPENDENTS^NJ10,2^^0;10^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.1,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.1,21,0)
	;;=^^3^3^2930430^^
	;;^DD(354.3,.1,21,1,0)
	;;=This is the amount for the Veteran with 7 Dependents.  If this rate
	;;^DD(354.3,.1,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.1,21,3,0)
	;;=dependent amount for each dependent, it can be left null and computed.
	;;^DD(354.3,.1,"DT")
	;;=2930120
	;;^DD(354.3,.11,0)
	;;=BASE RATE WITH 8 DEPENDENTS^NJ10,2^^0;11^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.11,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.11,21,0)
	;;=^^3^3^2930430^^
	;;^DD(354.3,.11,21,1,0)
	;;=This is the amount for the Veteran with 8 Dependents.  If this rate
	;;^DD(354.3,.11,21,2,0)
	;;=is the same as the rate for Veteran with 1 dependent plus an additional
	;;^DD(354.3,.11,21,3,0)
	;;=dependent amount for each dependent, it can be left null and computed.
	;;^DD(354.3,.12,0)
	;;=ADDITIONAL DEPENDENT AMOUNT^RNJ10,2^^0;12^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(354.3,.12,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(354.3,.12,21,0)
	;;=^^1^1^2921209^
	;;^DD(354.3,.12,21,1,0)
	;;=This is the rate for each additional dependent.
	;;^DD(354.3,.12,23,0)
	;;=^^7^7^2921209^
	;;^DD(354.3,.12,23,1,0)
	;;=Calculation of the threshold amount will be based on the number of
	;;^DD(354.3,.12,23,2,0)
	;;=dependents a veteran has.  First the base rate will be determined.
	;;^DD(354.3,.12,23,3,0)
	;;=Second, look at the rate for the veteran with the correct number
	;;^DD(354.3,.12,23,4,0)
	;;=of dependents.  Third, if the entry for the veteran and the number
	;;^DD(354.3,.12,23,5,0)
	;;=of dependents is null, then the threshold will be the base rate
	;;^DD(354.3,.12,23,6,0)
	;;=plus the rate for each additional dependent times the number of 
	;;^DD(354.3,.12,23,7,0)
	;;=dependents.
	;;^DD(354.3,.12,"DT")
	;;=2930405

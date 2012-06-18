IBINI01K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.2,.05,21,4,0)
	;;=is valid then enter the date that this is inactive.  No entry is 
	;;^DD(350.2,.05,21,5,0)
	;;=necessary in this field if a more recent active date is added for an
	;;^DD(350.2,.05,21,6,0)
	;;=IB ACTION TYPE.
	;;^DD(350.2,.06,0)
	;;=ADDITIONAL AMOUNT^NJ10,2^^0;6^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(350.2,.06,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(350.2,.06,21,0)
	;;=^^4^4^2940209^^^^
	;;^DD(350.2,.06,21,1,0)
	;;=This is a fixed additional dollar amount that will be added to the
	;;^DD(350.2,.06,21,2,0)
	;;=basic charge after it has been computed. An example of this would
	;;^DD(350.2,.06,21,3,0)
	;;=be the additional charge of $200 added to HCFA Ambulatory Surgery rate
	;;^DD(350.2,.06,21,4,0)
	;;=groups for inter-ocular lens implants.
	;;^DD(350.2,.06,"DT")
	;;=2910913
	;;^DD(350.2,10,0)
	;;=UNIT CHARGE LOGIC^K^^10;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(350.2,10,3)
	;;=This is Standard MUMPS code.
	;;^DD(350.2,10,21,0)
	;;=^^3^3^2910305^^
	;;^DD(350.2,10,21,1,0)
	;;=If this charge is not fixed (ie an exact cost) the field contains the logic
	;;^DD(350.2,10,21,2,0)
	;;=to calculate the cost per unit.  It may need to use the logic in the IB
	;;^DD(350.2,10,21,3,0)
	;;=transaction type file to find this cost.

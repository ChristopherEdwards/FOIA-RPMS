IBINI01N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.21)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.21,.03,"DT")
	;;=2930810
	;;^DD(350.21,.04,0)
	;;=PASSED TO AR?^S^0:NO;1:YES;^0;4^Q
	;;^DD(350.21,.04,21,0)
	;;=^^2^2^2930810^
	;;^DD(350.21,.04,21,1,0)
	;;=This field is used to determine if IB actions with this status have
	;;^DD(350.21,.04,21,2,0)
	;;=already been passed to the Accounts Receivable module.
	;;^DD(350.21,.04,"DT")
	;;=2930810
	;;^DD(350.21,.05,0)
	;;=CANCELLED?^S^0:NO;1:YES;^0;5^Q
	;;^DD(350.21,.05,21,0)
	;;=^^2^2^2930810^
	;;^DD(350.21,.05,21,1,0)
	;;=This field is used to determine if IB actions with this status have
	;;^DD(350.21,.05,21,2,0)
	;;=been cancelled.
	;;^DD(350.21,.05,"DT")
	;;=2930810
	;;^DD(350.21,.06,0)
	;;=ON HOLD?^S^0:NO;1:YES;^0;6^Q
	;;^DD(350.21,.06,21,0)
	;;=^^2^2^2930810^
	;;^DD(350.21,.06,21,1,0)
	;;=This field is used to determine if IB actions are being held in the
	;;^DD(350.21,.06,21,2,0)
	;;=Integrated Billing module waiting to be passed to Accounts Receivable.
	;;^DD(350.21,.06,"DT")
	;;=2930810

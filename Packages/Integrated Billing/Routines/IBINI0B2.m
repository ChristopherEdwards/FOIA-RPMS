IBINI0B2	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.1,.17,12.1)
	;;=S DIC("S")="I +$P(^DGCR(399.1,+DA,0),U,4)"
	;;^DD(399.1,.17,21,0)
	;;=^^2^2^2940103^^
	;;^DD(399.1,.17,21,1,0)
	;;=A code and related dates that identify an event that relates to the payment
	;;^DD(399.1,.17,21,2,0)
	;;=of the claim.
	;;^DD(399.1,.17,23,0)
	;;=^^2^2^2940103^^^^
	;;^DD(399.1,.17,23,1,0)
	;;=For Occurrence Spans both this flag and Occurrence Code must be set.
	;;^DD(399.1,.17,23,2,0)
	;;=Setting this flag indicates two dates are required.
	;;^DD(399.1,.17,"DT")
	;;=2940103
	;;^DD(399.1,.18,0)
	;;=VALUE CODE^S^1:YES;0:NO;^0;11^Q
	;;^DD(399.1,.18,3)
	;;=Enter Yes if this is a Value Code.
	;;^DD(399.1,.18,"DT")
	;;=2931221
	;;^DD(399.1,.19,0)
	;;=VALUE CODE AMOUNT^*S^1:YES;0:NO;^0;12^Q
	;;^DD(399.1,.19,3)
	;;=Enter Yes if the value associated with this code is a dollar amount.
	;;^DD(399.1,.19,12)
	;;=Only applies to value codes.
	;;^DD(399.1,.19,12.1)
	;;=S DIC("S")="I +$P(^DGCR(399.1,+DA,0),U,11)"
	;;^DD(399.1,.19,21,0)
	;;=^^2^2^2940103^^
	;;^DD(399.1,.19,21,1,0)
	;;=Enter Yes if the value amount associated with this value code should be
	;;^DD(399.1,.19,21,2,0)
	;;=right justified to the right of the delimiter, ie with cents printed.
	;;^DD(399.1,.19,23,0)
	;;=^^4^4^2940103^^^
	;;^DD(399.1,.19,23,1,0)
	;;=If this is true then the value amount for the value code is a dollar
	;;^DD(399.1,.19,23,2,0)
	;;=amount and should be right justified to the right of the 
	;;^DD(399.1,.19,23,3,0)
	;;=delimiter.  The value amounts for all other value codes will be right
	;;^DD(399.1,.19,23,4,0)
	;;=justified to the left of the delimiter.
	;;^DD(399.1,.19,"DT")
	;;=2940103

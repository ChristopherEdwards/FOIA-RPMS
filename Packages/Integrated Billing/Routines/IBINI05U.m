IBINI05U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,.24,21,2,0)
	;;=then this is the review it was copied from.
	;;^DD(356.1,.24,"DT")
	;;=2930904
	;;^DD(356.1,1.01,0)
	;;=DATE ENTERED^D^^1;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.1,1.01,21,0)
	;;=^^2^2^2930726^
	;;^DD(356.1,1.01,21,1,0)
	;;=This is the date this review was entered into the computer.  It is
	;;^DD(356.1,1.01,21,2,0)
	;;=generated when the review is entered and not editable by the user.
	;;^DD(356.1,1.01,"DT")
	;;=2930714
	;;^DD(356.1,1.02,0)
	;;=ENTERED BY^P200'^VA(200,^1;2^Q
	;;^DD(356.1,1.02,21,0)
	;;=^^4^4^2940213^^
	;;^DD(356.1,1.02,21,1,0)
	;;=This is the user who was signed on to the computer system when this
	;;^DD(356.1,1.02,21,2,0)
	;;=review was created.  If this review was created automatically by
	;;^DD(356.1,1.02,21,3,0)
	;;=the computer from an admission or outpatient visit, then this might
	;;^DD(356.1,1.02,21,4,0)
	;;=be a user for MAS, IRM or other service.
	;;^DD(356.1,1.02,"DT")
	;;=2930610
	;;^DD(356.1,1.03,0)
	;;=LAST EDIT ON^D^^1;3^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.1,1.03,3)
	;;=
	;;^DD(356.1,1.03,21,0)
	;;=^^4^4^2930726^^^
	;;^DD(356.1,1.03,21,1,0)
	;;=This is the date that this review was last edited by a user using 
	;;^DD(356.1,1.03,21,2,0)
	;;=the input options.  Every time any
	;;^DD(356.1,1.03,21,3,0)
	;;=field other than the UR COMMENT field is edited this field is updated
	;;^DD(356.1,1.03,21,4,0)
	;;=to the current date.
	;;^DD(356.1,1.03,"DT")
	;;=2930714
	;;^DD(356.1,1.04,0)
	;;=LAST EDITED BY^P200'^VA(200,^1;4^Q
	;;^DD(356.1,1.04,21,0)
	;;=^^4^4^2940213^^
	;;^DD(356.1,1.04,21,1,0)
	;;=This is the signed on user who last edited this entry using the input
	;;^DD(356.1,1.04,21,2,0)
	;;=screens.  Every time a review is edited with the input screens, this
	;;^DD(356.1,1.04,21,3,0)
	;;=field is updated.  (If only the UR COMMENTS field is updated then
	;;^DD(356.1,1.04,21,4,0)
	;;=this field is not changed.)
	;;^DD(356.1,1.04,"DT")
	;;=2930610
	;;^DD(356.1,1.05,0)
	;;=DATE COMPLETED^D^^1;5^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.1,1.05,3)
	;;=
	;;^DD(356.1,1.05,5,1,0)
	;;=356.1^.21^2
	;;^DD(356.1,1.05,21,0)
	;;=^^2^2^2940213^^^
	;;^DD(356.1,1.05,21,1,0)
	;;=This is the date that this review was completed.  It is triggered by 
	;;^DD(356.1,1.05,21,2,0)
	;;=the REVIEW STATUS field every time the review is completed.
	;;^DD(356.1,1.05,"DT")
	;;=2930714
	;;^DD(356.1,1.06,0)
	;;=COMPLETED BY^P200'^VA(200,^1;6^Q
	;;^DD(356.1,1.06,5,1,0)
	;;=356.1^.21^3
	;;^DD(356.1,1.06,21,0)
	;;=^^2^2^2930726^
	;;^DD(356.1,1.06,21,1,0)
	;;=This is the user who completed this review.  It is triggered by the
	;;^DD(356.1,1.06,21,2,0)
	;;=REVIEW STATUS field when the status chages to complete.
	;;^DD(356.1,1.06,"DT")
	;;=2930610
	;;^DD(356.1,1.13,0)
	;;=ADD NEXT REVIEW^S^1:YES;0:NO;^1;13^Q
	;;^DD(356.1,1.13,21,0)
	;;=^^4^4^2940213^^
	;;^DD(356.1,1.13,21,1,0)
	;;=If you wish to add the next day reviewed at this time answer YEand
	;;^DD(356.1,1.13,21,2,0)
	;;=you may procede directly into the next review.  Answer NO and you
	;;^DD(356.1,1.13,21,3,0)
	;;=will be returned to the Hospital Review Screen.  You may add another
	;;^DD(356.1,1.13,21,4,0)
	;;=day for review at any time.
	;;^DD(356.1,1.13,"DT")
	;;=2930830
	;;^DD(356.1,1.14,0)
	;;=NEXT REVIEW EXACTLY THE SAME^S^1:YES;0:NO;^1;14^Q
	;;^DD(356.1,1.14,3)
	;;=
	;;^DD(356.1,1.14,21,0)
	;;=^^6^6^2940213^^
	;;^DD(356.1,1.14,21,1,0)
	;;=If the Next Day for Review is exactly the same as the day you just
	;;^DD(356.1,1.14,21,2,0)
	;;=finished entering answer YES and the computer will copy this days

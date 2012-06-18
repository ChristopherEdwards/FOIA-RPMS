IBINI05N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,1.01,21,2,0)
	;;=date that the automated tracker created this entry on.
	;;^DD(356,1.01,"DT")
	;;=2930824
	;;^DD(356,1.02,0)
	;;=ENTERED BY^P200'^VA(200,^1;2^Q
	;;^DD(356,1.02,3)
	;;=
	;;^DD(356,1.02,21,0)
	;;=^^2^2^2930712^
	;;^DD(356,1.02,21,1,0)
	;;=Enter the name of the user who first created this entry.  This is 
	;;^DD(356,1.02,21,2,0)
	;;=most important if this entry was not created by the automated tracker.
	;;^DD(356,1.02,"DT")
	;;=2930609
	;;^DD(356,1.03,0)
	;;=DATE LAST EDITED^D^^1;3^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356,1.03,21,0)
	;;=^^1^1^2930712^
	;;^DD(356,1.03,21,1,0)
	;;=Enter the date that this claim was last edited.
	;;^DD(356,1.03,"DT")
	;;=2930706
	;;^DD(356,1.04,0)
	;;=LAST EDITED BY^P200'^VA(200,^1;4^Q
	;;^DD(356,1.04,21,0)
	;;=^^1^1^2930719^^
	;;^DD(356,1.04,21,1,0)
	;;=Enter the user who last edited this claim tracking entry.
	;;^DD(356,1.04,"DT")
	;;=2930609
	;;^DD(356,1.05,0)
	;;=HOSPITAL REVIEWS ASSIGNED TO^P200'^VA(200,^1;5^Q
	;;^DD(356,1.05,21,0)
	;;=^^6^6^2940213^^^^
	;;^DD(356,1.05,21,1,0)
	;;=Enter the UR person that this case is assigned to if it is assigned to
	;;^DD(356,1.05,21,2,0)
	;;=an individual for hospital Reviews.
	;;^DD(356,1.05,21,3,0)
	;;= 
	;;^DD(356,1.05,21,4,0)
	;;=Cases may be assigned for an individual to follow for the length of their
	;;^DD(356,1.05,21,5,0)
	;;=admission.  If viewing pending work by who it is assigned to then this
	;;^DD(356,1.05,21,6,0)
	;;=field is used to sort the pending work.
	;;^DD(356,1.05,"DT")
	;;=2930825
	;;^DD(356,1.06,0)
	;;=INS. REVIEWS ASSIGNED TO^P200'^VA(200,^1;6^Q
	;;^DD(356,1.06,21,0)
	;;=^^6^6^2940213^^^
	;;^DD(356,1.06,21,1,0)
	;;=Enter the Insurance UR person that this case is assigned to if it 
	;;^DD(356,1.06,21,2,0)
	;;=is assigned to an individual for Insurance UR.
	;;^DD(356,1.06,21,3,0)
	;;= 
	;;^DD(356,1.06,21,4,0)
	;;=Cases may be assigned for an individual to follow for the length of their
	;;^DD(356,1.06,21,5,0)
	;;=admission.  If viewing pending work by who it is assigned to then this
	;;^DD(356,1.06,21,6,0)
	;;=field is used to sort the pending work.
	;;^DD(356,1.06,"DT")
	;;=2930825
	;;^DD(356,1.07,0)
	;;=FOLLOW-UP TYPE^S^1:NONE;2:ADMISSION NOTIFICATION;3:ADMISSION AND DISCHARGE NOTIFICATION;4:PRE-CERTIFICATION;5:PRE-CERT AND CONT. STAY;6:PRE-CERT AND DISCH.;7:PRE-CERT, CONT. STAY AND DISCH.;^1;7^Q
	;;^DD(356,1.07,21,0)
	;;=^^4^4^2940128^
	;;^DD(356,1.07,21,1,0)
	;;=Enter type of follow that the insurance company requires for this
	;;^DD(356,1.07,21,2,0)
	;;=visit.  This information will be used by the reports to determine
	;;^DD(356,1.07,21,3,0)
	;;=if the case requires pre-cert or not, or pre-cert and continued 
	;;^DD(356,1.07,21,4,0)
	;;=stay.
	;;^DD(356,1.07,"DT")
	;;=2940128
	;;^DD(356,1.08,0)
	;;=ADDITIONAL COMMENT^F^^1;8^K:$L(X)>80!($L(X)<3) X
	;;^DD(356,1.08,3)
	;;=If necessary, use this field for a brief additional explaination of why this case isn't billable.  Answer must be 3-80 characters in length.
	;;^DD(356,1.08,21,0)
	;;=^^2^2^2940128^
	;;^DD(356,1.08,21,1,0)
	;;=Enter any brief comment about this episode that may explain why
	;;^DD(356,1.08,21,2,0)
	;;=a case is not billable.
	;;^DD(356,1.08,"DT")
	;;=2940128

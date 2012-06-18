IBINI04Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.3,.09,3)
	;;=Enter the type of policy that best describes this policy.
	;;^DD(355.3,.09,21,0)
	;;=^^5^5^2931103^^^^
	;;^DD(355.3,.09,21,1,0)
	;;=Select the type of plan that best describes this plan.  The type of
	;;^DD(355.3,.09,21,2,0)
	;;=policy will be used to determine if reimbursement for claims from the
	;;^DD(355.3,.09,21,3,0)
	;;=insurance carrier are appropriate.It will also be used to determine
	;;^DD(355.3,.09,21,4,0)
	;;=what other fields and displays are appropriate for this plan.  If
	;;^DD(355.3,.09,21,5,0)
	;;=unknown or unsure pick the more general type of plan.
	;;^DD(355.3,.09,"DT")
	;;=2931103
	;;^DD(355.3,.1,0)
	;;=INDIVIDUAL POLICY PATIENT^P2'^DPT(^0;10^Q
	;;^DD(355.3,.1,21,0)
	;;=^^7^7^2940213^^^^
	;;^DD(355.3,.1,21,1,0)
	;;=This is the patient associated with this policy if this is an individual
	;;^DD(355.3,.1,21,2,0)
	;;=policy. 
	;;^DD(355.3,.1,21,3,0)
	;;= 
	;;^DD(355.3,.1,21,4,0)
	;;=If this is an individual policy, the system will store the patient 
	;;^DD(355.3,.1,21,5,0)
	;;=in this field.  Only one patient may be associated with an individual
	;;^DD(355.3,.1,21,6,0)
	;;=policy.  Many patients can be associated with a group policy.
	;;^DD(355.3,.1,21,7,0)
	;;= 
	;;^DD(355.3,.1,22)
	;;=
	;;^DD(355.3,.1,"DT")
	;;=2930601
	;;^DD(355.3,1.01,0)
	;;=DATE ENTERED^D^^1;1^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.3,1.01,5,1,0)
	;;=355.3^.01^2
	;;^DD(355.3,1.01,21,0)
	;;=^^2^2^2931102^^^
	;;^DD(355.3,1.01,21,1,0)
	;;=This is the date that this policy was entered.  It is triggered by
	;;^DD(355.3,1.01,21,2,0)
	;;=the creation of this entry.
	;;^DD(355.3,1.01,"DT")
	;;=2931102
	;;^DD(355.3,1.02,0)
	;;=ENTERED BY^P200'^VA(200,^1;2^Q
	;;^DD(355.3,1.02,5,1,0)
	;;=355.3^.01^3
	;;^DD(355.3,1.02,21,0)
	;;=^^2^2^2930603^
	;;^DD(355.3,1.02,21,1,0)
	;;=This is the user who created this entry.  It is automatically triggered
	;;^DD(355.3,1.02,21,2,0)
	;;=by the creation of this entry.
	;;^DD(355.3,1.02,"DT")
	;;=2930603
	;;^DD(355.3,1.03,0)
	;;=DATE LAST VERIFIED^D^^1;3^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.3,1.03,21,0)
	;;=^^5^5^2940213^
	;;^DD(355.3,1.03,21,1,0)
	;;=This is the date that this policy was last verified.  A policy is 
	;;^DD(355.3,1.03,21,2,0)
	;;=verified by selecting the Verify Policy Action on the Patient 
	;;^DD(355.3,1.03,21,3,0)
	;;=Insurance Management screen.  Generally this is the last time
	;;^DD(355.3,1.03,21,4,0)
	;;=that somebody contacted the insurance company and verified that
	;;^DD(355.3,1.03,21,5,0)
	;;=policy information is correct.
	;;^DD(355.3,1.03,"DT")
	;;=2930603
	;;^DD(355.3,1.04,0)
	;;=VERIFIED BY^P200'^VA(200,^1;4^Q
	;;^DD(355.3,1.04,21,0)
	;;=^^1^1^2940213^
	;;^DD(355.3,1.04,21,1,0)
	;;=This is the user who last verified that the policy information is correct.
	;;^DD(355.3,1.04,"DT")
	;;=2930603
	;;^DD(355.3,1.05,0)
	;;=DATE LAST EDITED^D^^1;5^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.3,1.05,21,0)
	;;=^^2^2^2940213^
	;;^DD(355.3,1.05,21,1,0)
	;;=This is the date that this policy was last edited.  It is automatically
	;;^DD(355.3,1.05,21,2,0)
	;;=updated any time a policy is editing using one of the options provided.
	;;^DD(355.3,1.05,"DT")
	;;=2930603
	;;^DD(355.3,1.06,0)
	;;=LAST EDITED BY^P200'^VA(200,^1;6^Q
	;;^DD(355.3,1.06,21,0)
	;;=^^2^2^2940213^
	;;^DD(355.3,1.06,21,1,0)
	;;=This is the user who last edited this policy.  It is automatically
	;;^DD(355.3,1.06,21,2,0)
	;;=updated everytime a policy is edited using one of the options.
	;;^DD(355.3,1.06,"DT")
	;;=2930603
	;;^DD(355.3,11,0)
	;;=COMMENTS^355.311^^11;0

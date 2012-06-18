IBINI04O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.3,.01,1,3,"DT")
	;;=2940213
	;;^DD(355.3,.01,1,3,"FIELD")
	;;=#1.02
	;;^DD(355.3,.01,1,4,0)
	;;=355.3^AGNA1^MUMPS
	;;^DD(355.3,.01,1,4,1)
	;;=S:$P(^IBA(355.3,DA,0),U,3) ^IBA(355.3,"AGNA",X,+$P(^(0),U,3),DA)=""
	;;^DD(355.3,.01,1,4,2)
	;;=K ^IBA(355.3,"AGNA",X,+$P(^IBA(355.3,DA,0),U,3),DA)
	;;^DD(355.3,.01,1,4,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(355.3,.01,1,4,"%D",1,0)
	;;=Cross reference of insurance companies and group names.
	;;^DD(355.3,.01,1,4,"DT")
	;;=2940213
	;;^DD(355.3,.01,1,5,0)
	;;=355.3^AGNU1^MUMPS
	;;^DD(355.3,.01,1,5,1)
	;;=S:$P(^IBA(355.3,DA,0),U,4) ^IBA(355.3,"AGNU",X,+$P(^(0),U,4),DA)=""
	;;^DD(355.3,.01,1,5,2)
	;;=K ^IBA(355.3,"AGNU",X,+$P(^IBA(355.3,DA,0),U,4),DA)
	;;^DD(355.3,.01,1,5,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(355.3,.01,1,5,"%D",1,0)
	;;=Cross reference of insurance companies and group numbers.
	;;^DD(355.3,.01,1,5,"DT")
	;;=2940213
	;;^DD(355.3,.01,3)
	;;=
	;;^DD(355.3,.01,21,0)
	;;=^^1^1^2930603^
	;;^DD(355.3,.01,21,1,0)
	;;=Select the insurance company that this policy is with.
	;;^DD(355.3,.01,"DT")
	;;=2940213
	;;^DD(355.3,.02,0)
	;;=IS THIS A GROUP POLICY?^S^1:YES;0:NO;^0;2^Q
	;;^DD(355.3,.02,1,0)
	;;=^.1^^0
	;;^DD(355.3,.02,3)
	;;=If this is a group policy answer "YES" so that other patients may be associated with it.  If this is an individual plan answer "NO" and only the current patient can have this policy.
	;;^DD(355.3,.02,21,0)
	;;=^^5^5^2940110^^
	;;^DD(355.3,.02,21,1,0)
	;;=Some policies are indiviual policies and are specific to a patient.  Many
	;;^DD(355.3,.02,21,2,0)
	;;=policies are group plans that many patients may have.  If this is a group
	;;^DD(355.3,.02,21,3,0)
	;;=plan, answer 'YES' so that other patients may be associated with this
	;;^DD(355.3,.02,21,4,0)
	;;=policy.  If this is an individual plan then answer 'NO' and only this 
	;;^DD(355.3,.02,21,5,0)
	;;=patient can be associated with this policy.
	;;^DD(355.3,.02,"DT")
	;;=2930525
	;;^DD(355.3,.03,0)
	;;=GROUP NAME^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>20!($L(X)<2) X
	;;^DD(355.3,.03,1,0)
	;;=^.1
	;;^DD(355.3,.03,1,1,0)
	;;=355.3^D
	;;^DD(355.3,.03,1,1,1)
	;;=S ^IBA(355.3,"D",$E(X,1,30),DA)=""
	;;^DD(355.3,.03,1,1,2)
	;;=K ^IBA(355.3,"D",$E(X,1,30),DA)
	;;^DD(355.3,.03,1,1,"DT")
	;;=2930525
	;;^DD(355.3,.03,1,2,0)
	;;=355.3^AGNA^MUMPS
	;;^DD(355.3,.03,1,2,1)
	;;=S:+^IBA(355.3,DA,0) ^IBA(355.3,"AGNA",+^(0),X,DA)=""
	;;^DD(355.3,.03,1,2,2)
	;;=K ^IBA(355.3,"AGNA",+^IBA(355.3,DA,0),X,DA)
	;;^DD(355.3,.03,1,2,"%D",0)
	;;=^^2^2^2930527^
	;;^DD(355.3,.03,1,2,"%D",1,0)
	;;=Cross reference of insurance companies and group names.
	;;^DD(355.3,.03,1,2,"%D",2,0)
	;;=|
	;;^DD(355.3,.03,1,2,"DT")
	;;=2930527
	;;^DD(355.3,.03,3)
	;;=Answer must be 2-20 characters in length.
	;;^DD(355.3,.03,21,0)
	;;=^^6^6^2930603^^
	;;^DD(355.3,.03,21,1,0)
	;;=If this is a group policy, enter the name of the group that this policy
	;;^DD(355.3,.03,21,2,0)
	;;=is associated with.  This is the name that the insurance
	;;^DD(355.3,.03,21,3,0)
	;;=company uses to identify the plan.  This will appear 
	;;^DD(355.3,.03,21,4,0)
	;;=on the health claims forms in the appropriate blocks.  It will also be
	;;^DD(355.3,.03,21,5,0)
	;;=used to help identify this policy so that other patients with the same
	;;^DD(355.3,.03,21,6,0)
	;;=plan can be associated with it.
	;;^DD(355.3,.03,"DT")
	;;=2930527
	;;^DD(355.3,.04,0)
	;;=GROUP NUMBER^F^^0;4^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>17!($L(X)<2) X
	;;^DD(355.3,.04,1,0)
	;;=^.1
	;;^DD(355.3,.04,1,1,0)
	;;=355.3^E
	;;^DD(355.3,.04,1,1,1)
	;;=S ^IBA(355.3,"E",$E(X,1,30),DA)=""

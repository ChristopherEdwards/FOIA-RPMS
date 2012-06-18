IBINI04P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.3,.04,1,1,2)
	;;=K ^IBA(355.3,"E",$E(X,1,30),DA)
	;;^DD(355.3,.04,1,1,"DT")
	;;=2930525
	;;^DD(355.3,.04,1,2,0)
	;;=355.3^AGNU^MUMPS
	;;^DD(355.3,.04,1,2,1)
	;;=S:+^IBA(355.3,DA,0) ^IBA(355.3,"AGNU",+^(0),X,DA)=""
	;;^DD(355.3,.04,1,2,2)
	;;=K ^IBA(355.3,"AGNU",+^IBA(355.3,DA,0),X,DA)
	;;^DD(355.3,.04,1,2,"%D",0)
	;;=^^1^1^2930527^
	;;^DD(355.3,.04,1,2,"%D",1,0)
	;;=Cross reference of insurance companies and group names.
	;;^DD(355.3,.04,1,2,"DT")
	;;=2930527
	;;^DD(355.3,.04,3)
	;;=Answer must be 2-17 characters in length.
	;;^DD(355.3,.04,21,0)
	;;=^^3^3^2930603^
	;;^DD(355.3,.04,21,1,0)
	;;=If this is a group policy enter the number which identifies this policy,
	;;^DD(355.3,.04,21,2,0)
	;;=i.e. group number/code that the insurance company uses to identify this
	;;^DD(355.3,.04,21,3,0)
	;;=plan.  Answer must be between 1 and 17 characters.
	;;^DD(355.3,.04,"DT")
	;;=2930611
	;;^DD(355.3,.05,0)
	;;=IS UTILIZATION REVIEW REQUIRED^S^1:YES;0:NO;^0;5^Q
	;;^DD(355.3,.05,3)
	;;=Answer "YES" if this policy requires Utilization Review for all billable cases.  Otherwise, answer "NO".
	;;^DD(355.3,.05,21,0)
	;;=^^5^5^2930604^^
	;;^DD(355.3,.05,21,1,0)
	;;=Answer "YES" if Utilization Review is required by the insurance company
	;;^DD(355.3,.05,21,2,0)
	;;=for this policy.  Answer "NO" if it is not required.  The UR staff will
	;;^DD(355.3,.05,21,3,0)
	;;=automatically be required to follow-up on all billable cases where this
	;;^DD(355.3,.05,21,4,0)
	;;=field is answered "YES".  If the field is answered "NO" then UR follow-up
	;;^DD(355.3,.05,21,5,0)
	;;=will be considered optional.
	;;^DD(355.3,.05,"DT")
	;;=2930223
	;;^DD(355.3,.06,0)
	;;=IS PRE-CERTIFICATION REQUIRED?^S^1:YES;0:NO;^0;6^Q
	;;^DD(355.3,.06,3)
	;;=Answer "YES" if pre-certification is required by this policy.  Otherwise answer "NO".
	;;^DD(355.3,.06,21,0)
	;;=^^5^5^2930603^
	;;^DD(355.3,.06,21,1,0)
	;;=Answer "YES" if this policy requires Pre-certification of all non-emergent
	;;^DD(355.3,.06,21,2,0)
	;;=admissions.  Answer "NO" if pre-certification is not required.   
	;;^DD(355.3,.06,21,3,0)
	;;=If pre-certification is required but not obtained, follow-up will be
	;;^DD(355.3,.06,21,4,0)
	;;=required by the MCCR tracking module.
	;;^DD(355.3,.06,21,5,0)
	;;=|
	;;^DD(355.3,.06,"DT")
	;;=2930223
	;;^DD(355.3,.07,0)
	;;=EXCLUDE PRE-EXISTING CONDITION^S^1:YES;0:NO;^0;7^Q
	;;^DD(355.3,.07,3)
	;;=Answer "YES" if this policy excludes any pre existing conditions.  Otherwise answer "NO".
	;;^DD(355.3,.07,21,0)
	;;=^^7^7^2940213^^^^
	;;^DD(355.3,.07,21,1,0)
	;;=Answer "YES" if the policy excludes any pre existing conditions.  Answer
	;;^DD(355.3,.07,21,2,0)
	;;="NO" if the policy covers any pre existing conditions.  If a patient has
	;;^DD(355.3,.07,21,3,0)
	;;=pre-exisiting conditions that are not covered they should be entered in
	;;^DD(355.3,.07,21,4,0)
	;;=the patient policy comment field.
	;;^DD(355.3,.07,21,5,0)
	;;= 
	;;^DD(355.3,.07,21,6,0)
	;;= 
	;;^DD(355.3,.07,21,7,0)
	;;= 
	;;^DD(355.3,.07,"DT")
	;;=2930702
	;;^DD(355.3,.08,0)
	;;=BENEFITS ASSIGNABLE?^S^1:YES;0:NO;^0;8^Q
	;;^DD(355.3,.08,3)
	;;=
	;;^DD(355.3,.08,21,0)
	;;=^^4^4^2940213^
	;;^DD(355.3,.08,21,1,0)
	;;=If this policy will allow assignment of benefits then answer YES,
	;;^DD(355.3,.08,21,2,0)
	;;=otherwise answer NO.  Normally this field will be answered YES.  
	;;^DD(355.3,.08,21,3,0)
	;;=However, it may be useful to track policies that do not allow for
	;;^DD(355.3,.08,21,4,0)
	;;=assignment of benefits.
	;;^DD(355.3,.08,"DT")
	;;=2930223
	;;^DD(355.3,.09,0)
	;;=TYPE OF PLAN^P355.1'^IBE(355.1,^0;9^Q

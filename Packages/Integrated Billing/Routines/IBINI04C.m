IBINI04C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.1,0,"GL")
	;;=^IBE(355.1,
	;;^DIC("B","TYPE OF PLAN",355.1)
	;;=
	;;^DIC(355.1,"%D",0)
	;;=^^6^6^2940214^^^^
	;;^DIC(355.1,"%D",1,0)
	;;=This file contains the standard types of plans that an insurance
	;;^DIC(355.1,"%D",2,0)
	;;=company may provide.  The type of plan may be dependent on the type
	;;^DIC(355.1,"%D",3,0)
	;;=of coverage provided by the insurance company and may affect the type
	;;^DIC(355.1,"%D",4,0)
	;;=of benefits that are available for the plan.
	;;^DIC(355.1,"%D",5,0)
	;;= 
	;;^DIC(355.1,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.1,0)
	;;=FIELD^^10^4
	;;^DD(355.1,0,"DDA")
	;;=N
	;;^DD(355.1,0,"DT")
	;;=2940111
	;;^DD(355.1,0,"ID",.03)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(355.1,.03,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,3)_"":"",2),$C(59),1)")
	;;^DD(355.1,0,"IX","B",355.1,.01)
	;;=
	;;^DD(355.1,0,"IX","C",355.1,.03)
	;;=
	;;^DD(355.1,0,"IX","D",355.1,.02)
	;;=
	;;^DD(355.1,0,"NM","TYPE OF PLAN")
	;;=
	;;^DD(355.1,0,"PT",355.3,.09)
	;;=
	;;^DD(355.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>40!($L(X)<3)!'(X'?1P.E) X
	;;^DD(355.1,.01,1,0)
	;;=^.1
	;;^DD(355.1,.01,1,1,0)
	;;=355.1^B
	;;^DD(355.1,.01,1,1,1)
	;;=S ^IBE(355.1,"B",$E(X,1,30),DA)=""
	;;^DD(355.1,.01,1,1,2)
	;;=K ^IBE(355.1,"B",$E(X,1,30),DA)
	;;^DD(355.1,.01,3)
	;;=Enter the name of this type of policy that best describes the policy.  Answer must be 3-40 characters in length.
	;;^DD(355.1,.01,21,0)
	;;=^^10^10^2940213^^^^
	;;^DD(355.1,.01,21,1,0)
	;;=There are a number of different types of policies, some have very
	;;^DD(355.1,.01,21,2,0)
	;;=specific types of coverage while others cover a much broader
	;;^DD(355.1,.01,21,3,0)
	;;=range of care.  This is the name of the type of policy.  Select
	;;^DD(355.1,.01,21,4,0)
	;;=the name that best describes the type of policy.  This is a list of 
	;;^DD(355.1,.01,21,5,0)
	;;=standard types of policies.
	;;^DD(355.1,.01,21,6,0)
	;;= 
	;;^DD(355.1,.01,21,7,0)
	;;=The type of policy may be dependent on the type of coverage provided
	;;^DD(355.1,.01,21,8,0)
	;;=by the insurance company and may affect the type of benefits that are
	;;^DD(355.1,.01,21,9,0)
	;;=available for the policy.  This will be used in determining if the
	;;^DD(355.1,.01,21,10,0)
	;;=reimbursement from the insurance company is appropriate for this policy.
	;;^DD(355.1,.01,"DT")
	;;=2930225
	;;^DD(355.1,.02,0)
	;;=ABBREVIATION^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>8!($L(X)<2) X
	;;^DD(355.1,.02,1,0)
	;;=^.1
	;;^DD(355.1,.02,1,1,0)
	;;=355.1^D
	;;^DD(355.1,.02,1,1,1)
	;;=S ^IBE(355.1,"D",$E(X,1,30),DA)=""
	;;^DD(355.1,.02,1,1,2)
	;;=K ^IBE(355.1,"D",$E(X,1,30),DA)
	;;^DD(355.1,.02,1,1,"DT")
	;;=2930603
	;;^DD(355.1,.02,3)
	;;=Enter the standard abbreviation.  Answer must be 2-8 characters in length.
	;;^DD(355.1,.02,21,0)
	;;=^^3^3^2930603^
	;;^DD(355.1,.02,21,1,0)
	;;=Enter the standard abbreviation for this type of policy.  The abbreviation
	;;^DD(355.1,.02,21,2,0)
	;;=will be used on standard displays of policy information where space is
	;;^DD(355.1,.02,21,3,0)
	;;=limited.
	;;^DD(355.1,.02,"DT")
	;;=2930603
	;;^DD(355.1,.03,0)
	;;=MAJOR CATEGORY^S^1:MAJOR MEDICAL;2:DENTAL;3:HMO;4:PPO;5:MEDICARE;6:MEDICAIDE;7:CHAMPUS;8:WORKMANS COMP;9:INDEMNITY;10:PRESCRIPTION;11:MEDICARE SUPPLEMENTAL;12:ALL OTHER;^0;3^Q
	;;^DD(355.1,.03,1,0)
	;;=^.1
	;;^DD(355.1,.03,1,1,0)
	;;=355.1^C
	;;^DD(355.1,.03,1,1,1)
	;;=S ^IBE(355.1,"C",$E(X,1,30),DA)=""
	;;^DD(355.1,.03,1,1,2)
	;;=K ^IBE(355.1,"C",$E(X,1,30),DA)
	;;^DD(355.1,.03,1,1,"DT")
	;;=2930603

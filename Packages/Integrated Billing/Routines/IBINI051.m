IBINI051	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(355.5,0,"GL")
	;;=^IBA(355.5,
	;;^DIC("B","INSURANCE CLAIMS YEAR TO DATE",355.5)
	;;=
	;;^DIC(355.5,"%D",0)
	;;=^^6^6^2940214^^^^
	;;^DIC(355.5,"%D",1,0)
	;;=This file will contain the claim to date information about a patient's
	;;^DIC(355.5,"%D",2,0)
	;;=health insurance claims to a specific carrier for a specific year.  This
	;;^DIC(355.5,"%D",3,0)
	;;=will allow estimate of receivables based on whether claims exceed deductibles
	;;^DIC(355.5,"%D",4,0)
	;;=or other maximum benefits.
	;;^DIC(355.5,"%D",5,0)
	;;= 
	;;^DIC(355.5,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(355.5,0)
	;;=FIELD^^1.09^29
	;;^DD(355.5,0,"DDA")
	;;=N
	;;^DD(355.5,0,"DT")
	;;=2931217
	;;^DD(355.5,0,"IX","APPY",355.5,.02)
	;;=
	;;^DD(355.5,0,"IX","APPY1",355.5,.01)
	;;=
	;;^DD(355.5,0,"IX","APPY2",355.5,.03)
	;;=
	;;^DD(355.5,0,"IX","APPY3",355.5,.17)
	;;=
	;;^DD(355.5,0,"IX","B",355.5,.01)
	;;=
	;;^DD(355.5,0,"IX","C",355.5,.02)
	;;=
	;;^DD(355.5,0,"NM","INSURANCE CLAIMS YEAR TO DATE")
	;;=
	;;^DD(355.5,.01,0)
	;;=POLICY^RP355.3I^IBA(355.3,^0;1^Q
	;;^DD(355.5,.01,1,0)
	;;=^.1
	;;^DD(355.5,.01,1,1,0)
	;;=355.5^B
	;;^DD(355.5,.01,1,1,1)
	;;=S ^IBA(355.5,"B",$E(X,1,30),DA)=""
	;;^DD(355.5,.01,1,1,2)
	;;=K ^IBA(355.5,"B",$E(X,1,30),DA)
	;;^DD(355.5,.01,1,2,0)
	;;=355.5^APPY1^MUMPS
	;;^DD(355.5,.01,1,2,1)
	;;=I +$P(^IBA(355.5,DA,0),U,2),-$P(^(0),U,3),+$P(^(0),U,17) S ^IBA(355.5,"APPY",+$P(^(0),U,2),X,-$P(^(0),U,3),+$P(^(0),U,17),DA)=""
	;;^DD(355.5,.01,1,2,2)
	;;=K ^IBA(355.5,"APPY",+$P(^IBA(355.5,DA,0),U,2),X,-$P(^(0),U,3),+$P(^(0),U,17),DA)
	;;^DD(355.5,.01,1,2,"%D",0)
	;;=^^1^1^2930831^^^^
	;;^DD(355.5,.01,1,2,"%D",1,0)
	;;=Cross-reference of patients by policy by year.
	;;^DD(355.5,.01,1,2,"DT")
	;;=2930831
	;;^DD(355.5,.01,3)
	;;=
	;;^DD(355.5,.01,21,0)
	;;=^^2^2^2930713^^
	;;^DD(355.5,.01,21,1,0)
	;;=Select the patient's health insurance policy against which claims
	;;^DD(355.5,.01,21,2,0)
	;;=may have been made.
	;;^DD(355.5,.01,"DT")
	;;=2930831
	;;^DD(355.5,.02,0)
	;;=PATIENT^P2'I^DPT(^0;2^Q
	;;^DD(355.5,.02,1,0)
	;;=^.1
	;;^DD(355.5,.02,1,1,0)
	;;=355.5^C
	;;^DD(355.5,.02,1,1,1)
	;;=S ^IBA(355.5,"C",$E(X,1,30),DA)=""
	;;^DD(355.5,.02,1,1,2)
	;;=K ^IBA(355.5,"C",$E(X,1,30),DA)
	;;^DD(355.5,.02,1,1,"DT")
	;;=2930622
	;;^DD(355.5,.02,1,2,0)
	;;=355.5^APPY^MUMPS
	;;^DD(355.5,.02,1,2,1)
	;;=I -$P(^IBA(355.5,DA,0),U,3),+^(0),+$P(^(0),U,17) S ^IBA(355.5,"APPY",X,+^(0),-$P(^(0),U,3),+$P(^(0),U,17),DA)=""
	;;^DD(355.5,.02,1,2,2)
	;;=K ^IBA(355.5,"APPY",X,+^IBA(355.5,DA,0),-$P(^(0),U,3),+$P(^(0),U,17),DA)
	;;^DD(355.5,.02,1,2,"%D",0)
	;;=^^1^1^2930831^^^^
	;;^DD(355.5,.02,1,2,"%D",1,0)
	;;=Cross-references patient by policy by year.
	;;^DD(355.5,.02,1,2,"DT")
	;;=2930831
	;;^DD(355.5,.02,21,0)
	;;=^^1^1^2930713^^
	;;^DD(355.5,.02,21,1,0)
	;;=Enter the name of the patient who is on this policy.
	;;^DD(355.5,.02,"DT")
	;;=2931217
	;;^DD(355.5,.03,0)
	;;=BENEFIT YEAR BEGINNING ON^RDI^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(355.5,.03,1,0)
	;;=^.1
	;;^DD(355.5,.03,1,1,0)
	;;=355.5^APPY2^MUMPS
	;;^DD(355.5,.03,1,1,1)
	;;=I +$P(^IBA(355.5,DA,0),U,2),+^(0),+$P(^(0),U,17) S ^IBA(355.5,"APPY",+$P(^(0),U,2),+^(0),-X,+$P(^(0),U,17),DA)=""
	;;^DD(355.5,.03,1,1,2)
	;;=K ^IBA(355.5,"APPY",+$P(^IBA(355.5,DA,0),U,2),+^(0),-X,+$P(^(0),U,17),DA)
	;;^DD(355.5,.03,1,1,"%D",0)
	;;=^^1^1^2930831^^^^
	;;^DD(355.5,.03,1,1,"%D",1,0)
	;;=Cross-reference of patients by policy by year.
	;;^DD(355.5,.03,1,1,"DT")
	;;=2930831
	;;^DD(355.5,.03,3)
	;;=
	;;^DD(355.5,.03,9)
	;;=^
	;;^DD(355.5,.03,21,0)
	;;=^^2^2^2931217^^^^

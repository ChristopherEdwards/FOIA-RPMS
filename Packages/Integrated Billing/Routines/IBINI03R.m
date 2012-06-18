IBINI03R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.1,.02,1,3,"DT")
	;;=2921223
	;;^DD(354.1,.02,1,4,0)
	;;=354.1^APIDT^MUMPS
	;;^DD(354.1,.02,1,4,1)
	;;=I $P(^IBA(354.1,DA,0),U,3),+^(0) S ^IBA(354.1,"APIDT",X,+$P(^(0),U,3),-($P(^(0),U)),DA)=""
	;;^DD(354.1,.02,1,4,2)
	;;=K ^IBA(354.1,"APIDT",+X,+$P(^IBA(354.1,DA,0),U,3),-($P(^(0),U)),DA)
	;;^DD(354.1,.02,1,4,"%D",0)
	;;=^^1^1^2940213^^^^
	;;^DD(354.1,.02,1,4,"%D",1,0)
	;;=Cross-reference of all records by patient, by type, by inverse date.
	;;^DD(354.1,.02,1,4,"DT")
	;;=2921118
	;;^DD(354.1,.02,1,5,0)
	;;=354.1^ACAN1^MUMPS
	;;^DD(354.1,.02,1,5,1)
	;;=I $P(^IBA(354.1,DA,0),"^",14) S ^IBA(354.1,"ACAN",X,-$P(^(0),"^",14),DA)=""
	;;^DD(354.1,.02,1,5,2)
	;;=K ^IBA(354.1,"ACAN",X,-$P(^IBA(354.1,DA,0),"^",14),DA)
	;;^DD(354.1,.02,1,5,3)
	;;=DO NOT DELETE
	;;^DD(354.1,.02,1,5,"%D",0)
	;;=^^6^6^2930430^^^^
	;;^DD(354.1,.02,1,5,"%D",1,0)
	;;=This cross-reference is set whenever bills are retroactively canceled 
	;;^DD(354.1,.02,1,5,"%D",2,0)
	;;=due to the medication copayment exemption patch.  It is used to
	;;^DD(354.1,.02,1,5,"%D",3,0)
	;;=prevent canceling charges in AR a second time.  This is
	;;^DD(354.1,.02,1,5,"%D",4,0)
	;;=necessary because the direct link between IB and AR is not maintained
	;;^DD(354.1,.02,1,5,"%D",5,0)
	;;=for this functionality as it is necessary to remove admin and interest
	;;^DD(354.1,.02,1,5,"%D",6,0)
	;;=charges that may have accumulated.
	;;^DD(354.1,.02,1,5,"DT")
	;;=2930113
	;;^DD(354.1,.02,21,0)
	;;=^^3^3^2921209^^^
	;;^DD(354.1,.02,21,1,0)
	;;=This is the patient that this Billing Exemption Entry is for.  
	;;^DD(354.1,.02,21,2,0)
	;;=The Patient must be in the Billing Patient File.  The Current Status for
	;;^DD(354.1,.02,21,3,0)
	;;=an exemption will be automatically stored in the Billing Patient file.
	;;^DD(354.1,.02,"DT")
	;;=2930204
	;;^DD(354.1,.03,0)
	;;=TYPE^RSI^1:COPAY INCOME EXEMPTION;^0;3^Q
	;;^DD(354.1,.03,1,0)
	;;=^.1^^-1
	;;^DD(354.1,.03,1,1,0)
	;;=354.1^AIVDT3^MUMPS
	;;^DD(354.1,.03,1,1,1)
	;;=N IBX S IBX=^IBA(354.1,DA,0) I $P(IBX,U,2),$P(IBX,U,3),$P(IBX,U,4)'="",$P(IBX,U,10) S ^IBA(354.1,"AIVDT",+$P(IBX,U,3),+$P(IBX,U,2),-($P(IBX,U)),DA)=""
	;;^DD(354.1,.03,1,1,2)
	;;=K ^IBA(354.1,"AIVDT",+X,+$P(^IBA(354.1,DA,0),U,2),-($P(^(0),U)),DA)
	;;^DD(354.1,.03,1,1,"%D",0)
	;;=^^2^2^2940213^
	;;^DD(354.1,.03,1,1,"%D",1,0)
	;;=Inverse date cross reference of all exemptions for a patient for a type of
	;;^DD(354.1,.03,1,1,"%D",2,0)
	;;=exemption.
	;;^DD(354.1,.03,1,1,"DT")
	;;=2921110
	;;^DD(354.1,.03,1,2,0)
	;;=354.1^APIDT2^MUMPS
	;;^DD(354.1,.03,1,2,1)
	;;=I $P(^IBA(354.1,DA,0),U,2),+^(0) S ^IBA(354.1,"APIDT",+$P(^(0),U,2),+X,-($P(^(0),U)),DA)=""
	;;^DD(354.1,.03,1,2,2)
	;;=K ^IBA(354.1,"APIDT",+$P(^IBA(354.1,DA,0),U,2),+X,-($P(^(0),U)),DA)
	;;^DD(354.1,.03,1,2,"%D",0)
	;;=^^1^1^2940213^^^^
	;;^DD(354.1,.03,1,2,"%D",1,0)
	;;=Cross-reference of all records by patient, by type, by inverse date.
	;;^DD(354.1,.03,1,2,"DT")
	;;=2921118
	;;^DD(354.1,.03,1,3,0)
	;;=354.1^ACY3^MUMPS
	;;^DD(354.1,.03,1,3,1)
	;;=I $P(^IBA(354.1,DA,0),U,2),+^(0) S ^IBA(354.1,"ACY",+X,+$P(^(0),U,2),+$E($P(^(0),U),1,3),DA)=""
	;;^DD(354.1,.03,1,3,2)
	;;=K ^IBA(354.1,"ACY",+X,+$P(^IBA(354.1,DA,0),U,2),+$E($P(^(0),U),1,3),DA)
	;;^DD(354.1,.03,1,3,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(354.1,.03,1,3,"%D",1,0)
	;;=Cross reference of all active entries for a patient by inverse date.
	;;^DD(354.1,.03,1,3,"DT")
	;;=2921118
	;;^DD(354.1,.03,21,0)
	;;=^^2^2^2930429^^^^
	;;^DD(354.1,.03,21,1,0)
	;;=This is the type of exemption that this entry is for.  Each type of 

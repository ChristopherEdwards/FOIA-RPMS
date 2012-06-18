IBINI03Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.1,.01,1,1,2)
	;;=K ^IBA(354.1,"B",$E(X,1,30),DA)
	;;^DD(354.1,.01,1,2,0)
	;;=354.1^ACY^MUMPS
	;;^DD(354.1,.01,1,2,1)
	;;=I $P(^IBA(354.1,DA,0),"^",2),$P(^(0),U,3),$P(^(0),U,10) S ^IBA(354.1,"ACY",+$P(^(0),"^",3),+$P(^(0),"^",2),$E(X,1,3),DA)=""
	;;^DD(354.1,.01,1,2,2)
	;;=K ^IBA(354.1,"ACY",+$P(^IBA(354.1,DA,0),"^",3),+$P(^(0),U,2),$E(X,1,3),DA)
	;;^DD(354.1,.01,1,2,"%D",0)
	;;=^^3^3^2921209^^^^
	;;^DD(354.1,.01,1,2,"%D",1,0)
	;;=Cross-reference of all ACTIVE entries for a patient for an effective
	;;^DD(354.1,.01,1,2,"%D",2,0)
	;;=date.  For Pharmacy Co-pay income exemption this equates to calendar
	;;^DD(354.1,.01,1,2,"%D",3,0)
	;;=year (CY).          
	;;^DD(354.1,.01,1,2,"DT")
	;;=2921118
	;;^DD(354.1,.01,1,3,0)
	;;=354.1^AIVDT^MUMPS
	;;^DD(354.1,.01,1,3,1)
	;;=N IBX S IBX=^IBA(354.1,DA,0) I $P(IBX,U,2),$P(IBX,U,3),$P(IBX,U,4)'="",$P(IBX,U,10) S ^IBA(354.1,"AIVDT",+$P(IBX,U,3),+$P(IBX,U,2),-($P(IBX,U)),DA)=""
	;;^DD(354.1,.01,1,3,2)
	;;=K ^IBA(354.1,"AIVDT",+$P(^IBA(354.1,DA,0),U,3),+$P(^(0),U,2),-X,DA)
	;;^DD(354.1,.01,1,3,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(354.1,.01,1,3,"%D",1,0)
	;;=Inverse date cross reference of all exemption entries for a patient.
	;;^DD(354.1,.01,1,3,"DT")
	;;=2921110
	;;^DD(354.1,.01,1,4,0)
	;;=354.1^APIDT1^MUMPS
	;;^DD(354.1,.01,1,4,1)
	;;=I $P(^IBA(354.1,DA,0),U,2),$P(^(0),U,3) S ^IBA(354.1,"APIDT",+$P(^(0),U,2),+$P(^(0),U,3),-X,DA)=""
	;;^DD(354.1,.01,1,4,2)
	;;=K ^IBA(354.1,"APIDT",+$P(^IBA(354.1,DA,0),U,2),+$P(^(0),U,3),-X,DA)
	;;^DD(354.1,.01,1,4,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(354.1,.01,1,4,"%D",1,0)
	;;=Cross reference of all exemptions by patient, by type and by inverse date.
	;;^DD(354.1,.01,1,4,"DT")
	;;=2921116
	;;^DD(354.1,.01,3)
	;;=
	;;^DD(354.1,.01,21,0)
	;;=^^7^7^2921209^^^^
	;;^DD(354.1,.01,21,1,0)
	;;=Enter the effective date of the exemption.  
	;;^DD(354.1,.01,21,2,0)
	;;= 
	;;^DD(354.1,.01,21,3,0)
	;;=Patients will be given 1 year of exemption from the Medication Copayment
	;;^DD(354.1,.01,21,4,0)
	;;=requirement from this effective date.  For patients who's exemption is
	;;^DD(354.1,.01,21,5,0)
	;;=based on income data, every effort will be made to keep this effective
	;;^DD(354.1,.01,21,6,0)
	;;=date consistent with the Means Test Date of Test or the Copayment
	;;^DD(354.1,.01,21,7,0)
	;;=Income Test Date of Test.
	;;^DD(354.1,.01,"DEL",1,0)
	;;=I 1 W !,"Deleting entries not allowed"
	;;^DD(354.1,.01,"DT")
	;;=2930407
	;;^DD(354.1,.02,0)
	;;=PATIENT^RP354'I^IBA(354,^0;2^Q
	;;^DD(354.1,.02,.1)
	;;=BILLING PATIENT
	;;^DD(354.1,.02,1,0)
	;;=^.1
	;;^DD(354.1,.02,1,1,0)
	;;=354.1^AP
	;;^DD(354.1,.02,1,1,1)
	;;=S ^IBA(354.1,"AP",$E(X,1,30),DA)=""
	;;^DD(354.1,.02,1,1,2)
	;;=K ^IBA(354.1,"AP",$E(X,1,30),DA)
	;;^DD(354.1,.02,1,1,"%D",0)
	;;=^^1^1^2921110^
	;;^DD(354.1,.02,1,1,"%D",1,0)
	;;=Cross-reference of Patient.
	;;^DD(354.1,.02,1,1,"DT")
	;;=2921110
	;;^DD(354.1,.02,1,2,0)
	;;=354.1^AIVDT2^MUMPS
	;;^DD(354.1,.02,1,2,1)
	;;=N IBX S IBX=^IBA(354.1,DA,0) I $P(IBX,U,2),$P(IBX,U,3),$P(IBX,U,4)'="",$P(IBX,U,10) S ^IBA(354.1,"AIVDT",+$P(IBX,U,3),+$P(IBX,U,2),-($P(IBX,U)),DA)=""
	;;^DD(354.1,.02,1,2,2)
	;;=K ^IBA(354.1,"AIVDT",+$P(^IBA(354.1,DA,0),"^",3),+X,-($P(^(0),U)),DA)
	;;^DD(354.1,.02,1,2,"DT")
	;;=2921110
	;;^DD(354.1,.02,1,3,0)
	;;=354.1^C
	;;^DD(354.1,.02,1,3,1)
	;;=S ^IBA(354.1,"C",$E(X,1,30),DA)=""
	;;^DD(354.1,.02,1,3,2)
	;;=K ^IBA(354.1,"C",$E(X,1,30),DA)
	;;^DD(354.1,.02,1,3,"%D",0)
	;;=^^2^2^2940213^^^^
	;;^DD(354.1,.02,1,3,"%D",1,0)
	;;=Cross-reference of all ACTIVE entries for a patient by calendar
	;;^DD(354.1,.02,1,3,"%D",2,0)
	;;=year (CY).  This equates to $e(effective date,1,3).

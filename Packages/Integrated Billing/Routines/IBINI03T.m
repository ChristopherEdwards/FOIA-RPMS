IBINI03T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.1,.07,21,6,0)
	;;=exemptions will be considered SYSTEM added.
	;;^DD(354.1,.07,21,7,0)
	;;=If the entry was Manually added then this is the user who
	;;^DD(354.1,.07,21,8,0)
	;;=entered the Hardship exemption.
	;;^DD(354.1,.07,"DT")
	;;=2930204
	;;^DD(354.1,.08,0)
	;;=DATE/TIME ADDED^RDI^^0;8^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(354.1,.08,3)
	;;=
	;;^DD(354.1,.08,21,0)
	;;=^^7^7^2921209^^^
	;;^DD(354.1,.08,21,1,0)
	;;=This is the date and time this entry was added.
	;;^DD(354.1,.08,21,2,0)
	;;= 
	;;^DD(354.1,.08,21,3,0)
	;;=The date time added will be different from the effective date in many
	;;^DD(354.1,.08,21,4,0)
	;;=cases, where the entry is based on actual income data and where there
	;;^DD(354.1,.08,21,5,0)
	;;=are changes to an exemption status.  When the exemption is based upon
	;;^DD(354.1,.08,21,6,0)
	;;=the fact that the patient is recieving pension, etc. the effective date
	;;^DD(354.1,.08,21,7,0)
	;;=and the date added may be the same.
	;;^DD(354.1,.08,"DT")
	;;=2930204
	;;^DD(354.1,.09,0)
	;;=ALERT^P354.4'^IBA(354.4,^0;9^Q
	;;^DD(354.1,.09,1,0)
	;;=^.1
	;;^DD(354.1,.09,1,1,0)
	;;=354.1^ALERT
	;;^DD(354.1,.09,1,1,1)
	;;=S ^IBA(354.1,"ALERT",$E(X,1,30),DA)=""
	;;^DD(354.1,.09,1,1,2)
	;;=K ^IBA(354.1,"ALERT",$E(X,1,30),DA)
	;;^DD(354.1,.09,1,1,"%D",0)
	;;=^^1^1^2930204^
	;;^DD(354.1,.09,1,1,"%D",1,0)
	;;=This is an index of alerted exemptions.
	;;^DD(354.1,.09,1,1,"DT")
	;;=2930204
	;;^DD(354.1,.09,3)
	;;=
	;;^DD(354.1,.09,21,0)
	;;=^^1^1^2921209^
	;;^DD(354.1,.09,21,1,0)
	;;=Future use.
	;;^DD(354.1,.09,21,2,0)
	;;=An alert or mail message may be posted in association with the creation
	;;^DD(354.1,.09,21,3,0)
	;;=or editing of an exemption record.  If Alerts are used, then this field
	;;^DD(354.1,.09,21,4,0)
	;;=will store the pointer to the alert entry.  Once an alert has been
	;;^DD(354.1,.09,21,5,0)
	;;=resolved it will be deleted.
	;;^DD(354.1,.09,"DT")
	;;=2930204
	;;^DD(354.1,.1,0)
	;;=ACTIVE^R*S^1:ACTIVE;0:INACTIVE;^0;10^Q
	;;^DD(354.1,.1,.1)
	;;=CURRENTLY ACTIVE
	;;^DD(354.1,.1,1,0)
	;;=^.1^^-1
	;;^DD(354.1,.1,1,1,0)
	;;=354.1^AA
	;;^DD(354.1,.1,1,1,1)
	;;=S ^IBA(354.1,"AA",$E(X,1,30),DA)=""
	;;^DD(354.1,.1,1,1,2)
	;;=K ^IBA(354.1,"AA",$E(X,1,30),DA)
	;;^DD(354.1,.1,1,1,"%D",0)
	;;=^^1^1^2921110^
	;;^DD(354.1,.1,1,1,"%D",1,0)
	;;=Cross-reference of Active Records.
	;;^DD(354.1,.1,1,1,"DT")
	;;=2921110
	;;^DD(354.1,.1,1,2,0)
	;;=354.1^AIVDT1^MUMPS
	;;^DD(354.1,.1,1,2,1)
	;;=N IBX S IBX=^IBA(354.1,DA,0) I +X,$P(IBX,U,2),$P(IBX,U,3),$P(IBX,U,4)'="" S ^IBA(354.1,"AIVDT",+$P(IBX,U,3),+$P(IBX,U,2),-($P(IBX,U)),DA)=""
	;;^DD(354.1,.1,1,2,2)
	;;=N IBX S IBX=^IBA(354.1,DA,0) K ^IBA(354.1,"AIVDT",+$P(IBX,U,3),+$P(IBX,U,2),-($P(IBX,U)),DA)
	;;^DD(354.1,.1,1,2,"%D",0)
	;;=^^4^4^2930430^^^^
	;;^DD(354.1,.1,1,2,"%D",1,0)
	;;=If this is the active record, patient has been entered, type has been
	;;^DD(354.1,.1,1,2,"%D",2,0)
	;;=entered, status has been entered; set up an inverse cross reference.
	;;^DD(354.1,.1,1,2,"%D",3,0)
	;;= 
	;;^DD(354.1,.1,1,2,"%D",4,0)
	;;=^iba(354.1,"aivdt",type,patient,inverse effective date,da)=""
	;;^DD(354.1,.1,1,2,"DT")
	;;=2921110
	;;^DD(354.1,.1,1,3,0)
	;;=354.1^ACY2^MUMPS
	;;^DD(354.1,.1,1,3,1)
	;;=I X,+$P(^IBA(354.1,DA,0),U,2),+$P(^(0),U,3),+^(0) S ^IBA(354.1,"ACY",+$P(^(0),U,3),+$P(^(0),U,2),+$E($P(^(0),U),1,3),DA)=""
	;;^DD(354.1,.1,1,3,2)
	;;=K ^IBA(354.1,"ACY",+$P(^IBA(354.1,DA,0),U,3),+$P(^(0),U,2),+$E($P(^(0),U),1,3),DA)
	;;^DD(354.1,.1,1,3,"%D",0)
	;;=^^2^2^2940213^^^^
	;;^DD(354.1,.1,1,3,"%D",1,0)
	;;=Cross-reference of all ACTIVE entries for a patient by calendar

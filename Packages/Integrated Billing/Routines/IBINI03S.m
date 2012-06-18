IBINI03S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.1,.03,21,2,0)
	;;=exemption will have its own record.
	;;^DD(354.1,.03,23,0)
	;;=^^2^2^2930429^^^^
	;;^DD(354.1,.03,23,1,0)
	;;=Currently there is only one type of record. Pharmacy Copay Exemptions
	;;^DD(354.1,.03,23,2,0)
	;;=based on income.
	;;^DD(354.1,.03,"DT")
	;;=2930204
	;;^DD(354.1,.04,0)
	;;=STATUS^RSI^1:EXEMPT;0:NON-EXEMPT;^0;4^Q
	;;^DD(354.1,.04,.1)
	;;=EXEMPTION STATUS
	;;^DD(354.1,.04,1,0)
	;;=^.1
	;;^DD(354.1,.04,1,1,0)
	;;=354.1^AS
	;;^DD(354.1,.04,1,1,1)
	;;=S ^IBA(354.1,"AS",$E(X,1,30),DA)=""
	;;^DD(354.1,.04,1,1,2)
	;;=K ^IBA(354.1,"AS",$E(X,1,30),DA)
	;;^DD(354.1,.04,1,1,"%D",0)
	;;=^^1^1^2921110^
	;;^DD(354.1,.04,1,1,"%D",1,0)
	;;=Cross-reference of Status.
	;;^DD(354.1,.04,1,1,"DT")
	;;=2921110
	;;^DD(354.1,.04,21,0)
	;;=^^3^3^2921209^^
	;;^DD(354.1,.04,21,1,0)
	;;=This is the Exemption Status of this record.  Enter whether the
	;;^DD(354.1,.04,21,2,0)
	;;=patient is exempt or not exempt from the TYPE of billing of this
	;;^DD(354.1,.04,21,3,0)
	;;=record.  Generally this data element will be entered by the system.
	;;^DD(354.1,.04,"DT")
	;;=2930204
	;;^DD(354.1,.05,0)
	;;=EXEMPTION REASON^RP354.2'I^IBE(354.2,^0;5^Q
	;;^DD(354.1,.05,1,0)
	;;=^.1
	;;^DD(354.1,.05,1,1,0)
	;;=354.1^AR
	;;^DD(354.1,.05,1,1,1)
	;;=S ^IBA(354.1,"AR",$E(X,1,30),DA)=""
	;;^DD(354.1,.05,1,1,2)
	;;=K ^IBA(354.1,"AR",$E(X,1,30),DA)
	;;^DD(354.1,.05,1,1,"%D",0)
	;;=^^1^1^2921110^
	;;^DD(354.1,.05,1,1,"%D",1,0)
	;;=Cross-reference of Exemption Reasons.
	;;^DD(354.1,.05,1,1,"DT")
	;;=2921110
	;;^DD(354.1,.05,21,0)
	;;=^^6^6^2930429^^^
	;;^DD(354.1,.05,21,1,0)
	;;=Enter the reason that the patient is exempt or not exempt from this type
	;;^DD(354.1,.05,21,2,0)
	;;=of billing.  Entry of this field will automatically update the STATUS
	;;^DD(354.1,.05,21,3,0)
	;;=of this exemption record to the STATUS of the Exemption Reason.  
	;;^DD(354.1,.05,21,4,0)
	;;=For exmple, an exemption reason of "In Receipt of Pension" will
	;;^DD(354.1,.05,21,5,0)
	;;=automatically trigger a STATUS of Exempt for the Pharmacy Copay
	;;^DD(354.1,.05,21,6,0)
	;;=Income Exemption.
	;;^DD(354.1,.05,"DT")
	;;=2930204
	;;^DD(354.1,.06,0)
	;;=HOW ADDED^S^1:SYSTEM;2:MANUAL;^0;6^Q
	;;^DD(354.1,.06,21,0)
	;;=^^4^4^2930429^^^^
	;;^DD(354.1,.06,21,1,0)
	;;=This field indicates whether this record was automatically added
	;;^DD(354.1,.06,21,2,0)
	;;=by the system or manually entered by a user.
	;;^DD(354.1,.06,21,3,0)
	;;= 
	;;^DD(354.1,.06,21,4,0)
	;;=This field will always be entered by the system.
	;;^DD(354.1,.06,23,0)
	;;=^^5^5^2930429^^
	;;^DD(354.1,.06,23,1,0)
	;;=This field is updated to manual whenever a user creates an entry that
	;;^DD(354.1,.06,23,2,0)
	;;=does not appear to be consistent with the data returned from MAS or
	;;^DD(354.1,.06,23,3,0)
	;;=when adding a hardship exemption.  Whenever this field is set to
	;;^DD(354.1,.06,23,4,0)
	;;=manual an electronic signature should be required and a bulletin or
	;;^DD(354.1,.06,23,5,0)
	;;=alert sent to an appropriate group.
	;;^DD(354.1,.06,"DT")
	;;=2921209
	;;^DD(354.1,.07,0)
	;;=USER ADDING ENTRY^P200'I^VA(200,^0;7^Q
	;;^DD(354.1,.07,21,0)
	;;=^^8^8^2930430^^^^
	;;^DD(354.1,.07,21,1,0)
	;;=This is the user who was responsible for adding this entry.  If the 
	;;^DD(354.1,.07,21,2,0)
	;;=entry was SYSTEM added then the user would be the signed 
	;;^DD(354.1,.07,21,3,0)
	;;=on user when the exemption was created.  This may be a user who
	;;^DD(354.1,.07,21,4,0)
	;;=edited the patient record or who entered a prescription or a
	;;^DD(354.1,.07,21,5,0)
	;;=user who corrected an exemption.  All changes except Hardship

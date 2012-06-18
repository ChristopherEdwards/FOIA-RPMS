IBINI05Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,.04,21,3,0)
	;;=category for this review.
	;;^DD(356.1,.04,"DT")
	;;=2930719
	;;^DD(356.1,.05,0)
	;;=INTENSITY OF SERVICE^*P356.3'^IBE(356.3,^0;5^S DIC("S")="I $P(^(0),U,2)=2" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.05,12)
	;;=Only categories for general units may be selected!
	;;^DD(356.1,.05,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=2"
	;;^DD(356.1,.05,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.1,.05,21,1,0)
	;;=Enter the Intensity of Service (IS) category that best describes the
	;;^DD(356.1,.05,21,2,0)
	;;=criteria met for continued stay days of care.  Select the PRIMARY
	;;^DD(356.1,.05,21,3,0)
	;;=category for this review.
	;;^DD(356.1,.05,"DT")
	;;=2930719
	;;^DD(356.1,.06,0)
	;;=CRITERIA MET IN 24 HOURS^S^1:YES;0:NO;^0;6^Q
	;;^DD(356.1,.06,21,0)
	;;=^^4^4^2940213^^
	;;^DD(356.1,.06,21,1,0)
	;;=For Pre-certification Reviews and Urgent Admission reviews enter if the
	;;^DD(356.1,.06,21,2,0)
	;;=patient met IS or SI criteria for acute admissions within 24 hours of
	;;^DD(356.1,.06,21,3,0)
	;;=admission.  If the criteria was not met, then selection of a REASON 
	;;^DD(356.1,.06,21,4,0)
	;;=FOR NON-ACUTE ADMISSIONS will be required.
	;;^DD(356.1,.07,0)
	;;=SPECIALTY FOR REVIEW^P45.7'^DIC(45.7,^0;7^Q
	;;^DD(356.1,.07,1,0)
	;;=^.1
	;;^DD(356.1,.07,1,1,0)
	;;=356.1^ASPC
	;;^DD(356.1,.07,1,1,1)
	;;=S ^IBT(356.1,"ASPC",$E(X,1,30),DA)=""
	;;^DD(356.1,.07,1,1,2)
	;;=K ^IBT(356.1,"ASPC",$E(X,1,30),DA)
	;;^DD(356.1,.07,1,1,"DT")
	;;=2930716
	;;^DD(356.1,.07,21,0)
	;;=^^3^3^2940216^^^^
	;;^DD(356.1,.07,21,1,0)
	;;=Enter the specialty that is treating the patient for this review.  
	;;^DD(356.1,.07,21,2,0)
	;;=Normally this will automatically be retrieved from the admission/transfer 
	;;^DD(356.1,.07,21,3,0)
	;;=records and you will only need to confirm.
	;;^DD(356.1,.07,"DT")
	;;=2940216
	;;^DD(356.1,.08,0)
	;;=SPECIALIZED UNIT SI^*P356.3'^IBE(356.3,^0;8^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.08,12)
	;;=Only categories for special units may be selected!
	;;^DD(356.1,.08,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356.1,.08,21,0)
	;;=^^8^8^2940213^^^^
	;;^DD(356.1,.08,21,1,0)
	;;=Enter the Severity of Illness (SI) category that best describes the
	;;^DD(356.1,.08,21,2,0)
	;;=criteria met for continued stay days of care.  Select the PRIMARY
	;;^DD(356.1,.08,21,3,0)
	;;=category for this review.
	;;^DD(356.1,.08,21,4,0)
	;;= 
	;;^DD(356.1,.08,21,5,0)
	;;=For patients in specialized units the SI categories are different
	;;^DD(356.1,.08,21,6,0)
	;;=than for non-specialized units.  The definition of specialized
	;;^DD(356.1,.08,21,7,0)
	;;=units for interqual is different than what we normally consider
	;;^DD(356.1,.08,21,8,0)
	;;=intensive care units.
	;;^DD(356.1,.08,22)
	;;=
	;;^DD(356.1,.08,"DT")
	;;=2930719
	;;^DD(356.1,.09,0)
	;;=SPECIALIZED UNIT IS^*P356.3'^IBE(356.3,^0;9^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.09,12)
	;;=Only categories for special units may be selected!
	;;^DD(356.1,.09,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356.1,.09,21,0)
	;;=^^8^8^2940213^^
	;;^DD(356.1,.09,21,1,0)
	;;=Enter the Intensity of Service (IS) category that best describes the
	;;^DD(356.1,.09,21,2,0)
	;;=criteria met for continued stay days of care.  Select the PRIMARY
	;;^DD(356.1,.09,21,3,0)
	;;=category for this review.
	;;^DD(356.1,.09,21,4,0)
	;;= 
	;;^DD(356.1,.09,21,5,0)
	;;=For patient in specialized units the IS categories are different
	;;^DD(356.1,.09,21,6,0)
	;;=than for non-specialized units.  The definition of specialized

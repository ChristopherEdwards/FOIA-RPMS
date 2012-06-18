IBINI05R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,.09,21,7,0)
	;;=units for interqual is different than what we normally consider
	;;^DD(356.1,.09,21,8,0)
	;;=intensive care units.
	;;^DD(356.1,.09,"DT")
	;;=2930719
	;;^DD(356.1,.1,0)
	;;=PROVIDER INTERVIEWED?^S^1:YES;0:NO;^0;10^Q
	;;^DD(356.1,.1,21,0)
	;;=^^3^3^2930719^
	;;^DD(356.1,.1,21,1,0)
	;;=For Pre-certification reviews and Urgent Admission reviews enter whether
	;;^DD(356.1,.1,21,2,0)
	;;=or not UR interviewed the provider regarding the appropriateness of the
	;;^DD(356.1,.1,21,3,0)
	;;=admission.
	;;^DD(356.1,.1,"DT")
	;;=2930610
	;;^DD(356.1,.11,0)
	;;=ADMISSION DECISION INFLUENCED^S^1:YES;0:NO;^0;11^Q
	;;^DD(356.1,.11,21,0)
	;;=^^3^3^2930719^
	;;^DD(356.1,.11,21,1,0)
	;;=If the provider was interviewed about the appropriateness of admission
	;;^DD(356.1,.11,21,2,0)
	;;=then answer whether or not the decision to admit the patient was
	;;^DD(356.1,.11,21,3,0)
	;;=influenced.
	;;^DD(356.1,.11,"DT")
	;;=2930610
	;;^DD(356.1,.12,0)
	;;=D/C SCREENS MET^*P356.3'^IBE(356.3,^0;12^S DIC("S")="I $P(^(0),U,2)=2" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.12,3)
	;;=
	;;^DD(356.1,.12,12)
	;;=Only categories for general units may be selected!
	;;^DD(356.1,.12,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=2"
	;;^DD(356.1,.12,21,0)
	;;=^^1^1^2930719^^
	;;^DD(356.1,.12,21,1,0)
	;;=Enter the Intensity of Service category whose discharge screens were met.
	;;^DD(356.1,.12,"DT")
	;;=2930719
	;;^DD(356.1,.13,0)
	;;=SPECIAL CARE D/C SCREENS MET^*P356.3'^IBE(356.3,^0;13^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.13,3)
	;;=
	;;^DD(356.1,.13,12)
	;;=Only categories for specialized units may be selected!
	;;^DD(356.1,.13,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356.1,.13,21,0)
	;;=^^2^2^2930726^^^
	;;^DD(356.1,.13,21,1,0)
	;;=Enter the Intesity of Service Category whose discharge screens were
	;;^DD(356.1,.13,21,2,0)
	;;=met.
	;;^DD(356.1,.13,"DT")
	;;=2930719
	;;^DD(356.1,.14,0)
	;;=SI/IS APPLY ALL DAYS^S^1:YES;0:NO;^0;14^Q
	;;^DD(356.1,.14,21,0)
	;;=^^6^6^2940213^^^^
	;;^DD(356.1,.14,21,1,0)
	;;=Answer whether or not the Severity of Illness (SI) or Intensity of
	;;^DD(356.1,.14,21,2,0)
	;;=Service (IS) criteria apply to all days.  If not, then the number
	;;^DD(356.1,.14,21,3,0)
	;;=of non-acute days and the reason for non-acute days should be
	;;^DD(356.1,.14,21,4,0)
	;;=answered.
	;;^DD(356.1,.14,21,5,0)
	;;= 
	;;^DD(356.1,.14,21,6,0)
	;;=The dates of non-acute care should be entered in the comments field.
	;;^DD(356.1,.14,22)
	;;=
	;;^DD(356.1,.14,"DT")
	;;=2930610
	;;^DD(356.1,.19,0)
	;;=ACTIVE^S^1:YES;0:NO;^0;19^Q
	;;^DD(356.1,.19,3)
	;;=Enter whether this Review is ACTIVE or not.  Answering "NO" has a similar effect to deleting the entry, it will no longer appear on reports or input screens.
	;;^DD(356.1,.19,21,0)
	;;=^^5^5^2930726^
	;;^DD(356.1,.19,21,1,0)
	;;=Enter if this review is active or not.  If a review is not active it
	;;^DD(356.1,.19,21,2,0)
	;;=will not be used or displayed on input screens or reports.  
	;;^DD(356.1,.19,21,3,0)
	;;= 
	;;^DD(356.1,.19,21,4,0)
	;;=Inactivating an entry has the same effect as deleting the entry, with the
	;;^DD(356.1,.19,21,5,0)
	;;=added benefit of leaving the data for later review if necessary.
	;;^DD(356.1,.19,"DT")
	;;=2930610
	;;^DD(356.1,.2,0)
	;;=NEXT REVIEW DATE^D^^0;20^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.1,.2,1,0)
	;;=^.1
	;;^DD(356.1,.2,1,1,0)
	;;=356.1^APEND
	;;^DD(356.1,.2,1,1,1)
	;;=S ^IBT(356.1,"APEND",$E(X,1,30),DA)=""
	;;^DD(356.1,.2,1,1,2)
	;;=K ^IBT(356.1,"APEND",$E(X,1,30),DA)

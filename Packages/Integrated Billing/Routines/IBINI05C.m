IBINI05C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.02,1,1,0)
	;;=356^C
	;;^DD(356,.02,1,1,1)
	;;=S ^IBT(356,"C",$E(X,1,30),DA)=""
	;;^DD(356,.02,1,1,2)
	;;=K ^IBT(356,"C",$E(X,1,30),DA)
	;;^DD(356,.02,1,1,"DT")
	;;=2930621
	;;^DD(356,.02,1,2,0)
	;;=356^ADM1^MUMPS
	;;^DD(356,.02,1,2,1)
	;;=S:$P(^IBT(356,DA,0),"^",5) ^IBT(356,"ADM",X,+$P(^(0),"^",5),DA)=""
	;;^DD(356,.02,1,2,2)
	;;=K ^IBT(356,"ADM",X,+$P(^IBT(356,DA,0),"^",5),DA)
	;;^DD(356,.02,1,2,"%D",0)
	;;=^^1^1^2930702^^
	;;^DD(356,.02,1,2,"%D",1,0)
	;;=Cross-reference of all admissions by patient.
	;;^DD(356,.02,1,2,"DT")
	;;=2930702
	;;^DD(356,.02,1,3,0)
	;;=356^APTDT1^MUMPS
	;;^DD(356,.02,1,3,1)
	;;=S:$P(^IBT(356,DA,0),U,6) ^IBT(356,"APTDT",X,-($P(^(0),U,6)),DA)=""
	;;^DD(356,.02,1,3,2)
	;;=K ^IBT(356,"APTDT",X,-($P(^IBT(356,DA,0),U,6)),DA)
	;;^DD(356,.02,1,3,"%D",0)
	;;=^^2^2^2930806^^
	;;^DD(356,.02,1,3,"%D",1,0)
	;;=Cross reference of all episodes of care by patient by date, in inverse
	;;^DD(356,.02,1,3,"%D",2,0)
	;;=date order so can list most recent first.
	;;^DD(356,.02,1,3,"DT")
	;;=2930806
	;;^DD(356,.02,1,4,0)
	;;=356^ASPC1^MUMPS
	;;^DD(356,.02,1,4,1)
	;;=S:$P(^IBT(356,DA,0),U,12) ^IBT(356,X,+$P(^(0),U,12),DA)=""
	;;^DD(356,.02,1,4,2)
	;;=K ^IBT(356,X,+$P(^IBT(356,DA,0),U,12),DA)
	;;^DD(356,.02,1,4,"%D",0)
	;;=^^1^1^2930712^
	;;^DD(356,.02,1,4,"%D",1,0)
	;;=Cross-reference of special types of bills by patient.
	;;^DD(356,.02,1,4,"DT")
	;;=2930712
	;;^DD(356,.02,1,5,0)
	;;=356^ADFN^MUMPS
	;;^DD(356,.02,1,5,1)
	;;=S ^IBT(356,"ADFN"_X,+^IBT(356,DA,0),DA)=""
	;;^DD(356,.02,1,5,2)
	;;=K ^IBT(356,"ADFN"_X,+^IBT(356,DA,0),DA)
	;;^DD(356,.02,1,5,"%D",0)
	;;=^^1^1^2931109^^
	;;^DD(356,.02,1,5,"%D",1,0)
	;;=Cross-reference by patient dfn for fast look-up.
	;;^DD(356,.02,1,5,"DT")
	;;=2930729
	;;^DD(356,.02,1,6,0)
	;;=356^ATOBIL^MUMPS
	;;^DD(356,.02,1,6,1)
	;;=S:$P(^IBT(356,DA,0),U,17)&($P(^(0),U,18)) ^IBT(356,"ATOBIL",+X,+$P(^(0),U,18),+$P(^(0),U,17),DA)=""
	;;^DD(356,.02,1,6,2)
	;;=K ^IBT(356,"ATOBIL",+X,+$P(^IBT(356,DA,0),U,18),+$P(^(0),U,17),DA)
	;;^DD(356,.02,1,6,"%D",0)
	;;=^^3^3^2930824^^^^
	;;^DD(356,.02,1,6,"%D",1,0)
	;;=This is a cross-reference of all active billable events that have not
	;;^DD(356,.02,1,6,"%D",2,0)
	;;=already been billed.  It is used by the autobilling software to determine
	;;^DD(356,.02,1,6,"%D",3,0)
	;;=the next autobill date for a patient by type of event.
	;;^DD(356,.02,1,6,"DT")
	;;=2930824
	;;^DD(356,.02,1,7,0)
	;;=356^APTY^MUMPS
	;;^DD(356,.02,1,7,1)
	;;=S:$P(^IBT(356,DA,0),U,6)&($P(^(0),U,18)) ^IBT(356,"APTY",X,+$P(^(0),U,18),+$P(^(0),U,6),DA)=""
	;;^DD(356,.02,1,7,2)
	;;=K ^IBT(356,"APTY",X,+$P(^IBT(356,DA,0),U,18),+$P(^(0),U,6),DA)
	;;^DD(356,.02,1,7,"%D",0)
	;;=^^1^1^2930809^^
	;;^DD(356,.02,1,7,"%D",1,0)
	;;=Cross-reference of all entries by patient by event type, by episode date.
	;;^DD(356,.02,1,7,"DT")
	;;=2930809
	;;^DD(356,.02,1,8,0)
	;;=356^AENC1^MUMPS
	;;^DD(356,.02,1,8,1)
	;;=S:$P(^IBT(356,DA,0),U,4) ^IBT(356,"AENC",X,+$P(^(0),U,4),DA)=""
	;;^DD(356,.02,1,8,2)
	;;=K ^IBT(356,"AENC",X,+$P(^IBT(356,DA,0),U,4),DA)
	;;^DD(356,.02,1,8,"%D",0)
	;;=^^1^1^2930831^
	;;^DD(356,.02,1,8,"%D",1,0)
	;;=Cross reference of all outpatient encounters by patient
	;;^DD(356,.02,1,8,"DT")
	;;=2930831
	;;^DD(356,.02,21,0)
	;;=^^5^5^2930709^
	;;^DD(356,.02,21,1,0)
	;;=Enter the patient that this Claims Tracking entry is for.  This is 
	;;^DD(356,.02,21,2,0)
	;;=the patient whose admission, outpatient visit, prescription refill,
	;;^DD(356,.02,21,3,0)
	;;=prosthetic device or other encounter for medical care or services
	;;^DD(356,.02,21,4,0)
	;;=is being tracked.

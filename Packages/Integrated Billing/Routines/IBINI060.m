IBINI060	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.01,1,3,1)
	;;=S:$P(^IBT(356.2,DA,0),U,2) ^IBT(356.2,"ADFN"_+$P(^(0),U,2),X,DA)=""
	;;^DD(356.2,.01,1,3,2)
	;;=K ^IBT(356.2,"ADFN"_+$P(^IBT(356.2,DA,0),U,2),X,DA)
	;;^DD(356.2,.01,1,3,"%D",0)
	;;=^^1^1^2940213^
	;;^DD(356.2,.01,1,3,"%D",1,0)
	;;=Cross-reference used for quick look up of entries for a patient.
	;;^DD(356.2,.01,1,3,"DT")
	;;=2931207
	;;^DD(356.2,.01,3)
	;;=
	;;^DD(356.2,.01,21,0)
	;;=^^5^5^2930806^^^
	;;^DD(356.2,.01,21,1,0)
	;;=This is the date of the contact for this entry.
	;;^DD(356.2,.01,21,2,0)
	;;= 
	;;^DD(356.2,.01,21,3,0)
	;;=It is frequently necessary to call insurance companies for
	;;^DD(356.2,.01,21,4,0)
	;;=insurance verification, pre-certification reviews, continued stay review,
	;;^DD(356.2,.01,21,5,0)
	;;=appeals, etc.  This is the date that you called the insurance company.
	;;^DD(356.2,.01,"DT")
	;;=2931207
	;;^DD(356.2,.02,0)
	;;=TRACKING ID^P356'^IBT(356,^0;2^Q
	;;^DD(356.2,.02,1,0)
	;;=^.1
	;;^DD(356.2,.02,1,1,0)
	;;=356.2^C
	;;^DD(356.2,.02,1,1,1)
	;;=S ^IBT(356.2,"C",$E(X,1,30),DA)=""
	;;^DD(356.2,.02,1,1,2)
	;;=K ^IBT(356.2,"C",$E(X,1,30),DA)
	;;^DD(356.2,.02,1,1,"DT")
	;;=2930702
	;;^DD(356.2,.02,1,2,0)
	;;=356.2^ATRP^MUMPS
	;;^DD(356.2,.02,1,2,1)
	;;=S:$P(^IBT(356.2,DA,0),"^",4) ^IBT(356.2,"ATRTP",X,+$P(^(0),"^",4),DA)=""
	;;^DD(356.2,.02,1,2,2)
	;;=K ^IBT(356.2,"ATRTP",X,+$P(^IBT(356.2,DA,0),"^",4),DA)
	;;^DD(356.2,.02,1,2,"%D",0)
	;;=^^1^1^2930712^
	;;^DD(356.2,.02,1,2,"%D",1,0)
	;;=Index of all communications by tracking id and type.
	;;^DD(356.2,.02,1,2,"DT")
	;;=2930712
	;;^DD(356.2,.02,1,3,0)
	;;=356.2^ATIDT1^MUMPS
	;;^DD(356.2,.02,1,3,1)
	;;=S:$P(^IBT(356.2,DA,0),U) ^IBT(356.2,"ATIDT",X,-$P(^(0),U),DA)=""
	;;^DD(356.2,.02,1,3,2)
	;;=K ^IBT(356.2,"ATIDT",X,-$P(^IBT(356.2,DA,0),U),DA)
	;;^DD(356.2,.02,1,3,"%D",0)
	;;=^^2^2^2930728^^
	;;^DD(356.2,.02,1,3,"%D",1,0)
	;;=Cross-Reference of all entries by tracking ID and by inverse date so can
	;;^DD(356.2,.02,1,3,"%D",2,0)
	;;=list most recent first.
	;;^DD(356.2,.02,1,3,"DT")
	;;=2930728
	;;^DD(356.2,.02,1,4,0)
	;;=356.2^APRE^MUMPS
	;;^DD(356.2,.02,1,4,1)
	;;=S:$P(^IBT(356.2,DA,0),U,28) ^IBT(356.2,"APRE",X,$P(^(0),U,28),DA)=""
	;;^DD(356.2,.02,1,4,2)
	;;=K ^IBT(356.2,"APRE",X,+$P(^IBT(356.2,DA,0),U,28),DA)
	;;^DD(356.2,.02,1,4,"%D",0)
	;;=^^3^3^2930729^
	;;^DD(356.2,.02,1,4,"%D",1,0)
	;;=Cross-Reference of all pre-cert numbers by tracking ID.  This is used to
	;;^DD(356.2,.02,1,4,"%D",2,0)
	;;=display the Pre-cert number in the claims tracking screens and the
	;;^DD(356.2,.02,1,4,"%D",3,0)
	;;=Review edit screens.
	;;^DD(356.2,.02,1,4,"DT")
	;;=2930729
	;;^DD(356.2,.02,21,0)
	;;=^^3^3^2930806^
	;;^DD(356.2,.02,21,1,0)
	;;=This is the Claims Tracking entry that was the primary episode of care
	;;^DD(356.2,.02,21,2,0)
	;;=that caused this contact.  Generally contacts are associated with
	;;^DD(356.2,.02,21,3,0)
	;;=an episode of care but occasionally they are not.
	;;^DD(356.2,.02,"DT")
	;;=2930729
	;;^DD(356.2,.03,0)
	;;=RELATED REVIEW^P356.1'^IBT(356.1,^0;3^Q
	;;^DD(356.2,.03,1,0)
	;;=^.1
	;;^DD(356.2,.03,1,1,0)
	;;=356.2^AD
	;;^DD(356.2,.03,1,1,1)
	;;=S ^IBT(356.2,"AD",$E(X,1,30),DA)=""
	;;^DD(356.2,.03,1,1,2)
	;;=K ^IBT(356.2,"AD",$E(X,1,30),DA)
	;;^DD(356.2,.03,1,1,"DT")
	;;=2930715
	;;^DD(356.2,.03,3)
	;;=
	;;^DD(356.2,.03,21,0)
	;;=^^5^5^2930806^^
	;;^DD(356.2,.03,21,1,0)
	;;=This is the review in the Claims Tracking Reviews file that this insurance
	;;^DD(356.2,.03,21,2,0)
	;;=contact is associated with.
	;;^DD(356.2,.03,21,3,0)
	;;= 
	;;^DD(356.2,.03,21,4,0)
	;;=This field will be system generated wheneve there is a utilization review

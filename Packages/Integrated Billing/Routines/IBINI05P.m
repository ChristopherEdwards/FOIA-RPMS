IBINI05P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,.01,21,8,0)
	;;=is automatically generated for you.
	;;^DD(356.1,.01,21,9,0)
	;;= 
	;;^DD(356.1,.01,21,10,0)
	;;=Normally the REVIEW DATEs are done in order. The pre-cert or urgent
	;;^DD(356.1,.01,21,11,0)
	;;=admission review is done before the continued stay reviews which
	;;^DD(356.1,.01,21,12,0)
	;;=in turn are normally done before the Discharge review.  The order of
	;;^DD(356.1,.01,21,13,0)
	;;=reviews shown on the main review screen is based on REVIEW DATE.
	;;^DD(356.1,.01,"DT")
	;;=2930714
	;;^DD(356.1,.02,0)
	;;=TRACKING ID^P356'^IBT(356,^0;2^Q
	;;^DD(356.1,.02,1,0)
	;;=^.1
	;;^DD(356.1,.02,1,1,0)
	;;=356.1^C
	;;^DD(356.1,.02,1,1,1)
	;;=S ^IBT(356.1,"C",$E(X,1,30),DA)=""
	;;^DD(356.1,.02,1,1,2)
	;;=K ^IBT(356.1,"C",$E(X,1,30),DA)
	;;^DD(356.1,.02,1,1,"DT")
	;;=2930702
	;;^DD(356.1,.02,1,2,0)
	;;=356.1^ATIDT1^MUMPS
	;;^DD(356.1,.02,1,2,1)
	;;=S:+^IBT(356.1,DA,0) ^IBT(356.1,"ATIDT",X,-$P(^(0),U),DA)=""
	;;^DD(356.1,.02,1,2,2)
	;;=K ^IBT(356.1,"ATIDT",X,-$P(^IBT(356.1,DA,0),U),DA)
	;;^DD(356.1,.02,1,2,"%D",0)
	;;=^^2^2^2930714^
	;;^DD(356.1,.02,1,2,"%D",1,0)
	;;=Cross reference in inverse date order of all reviews for a tracking  
	;;^DD(356.1,.02,1,2,"%D",2,0)
	;;=entry.
	;;^DD(356.1,.02,1,2,"DT")
	;;=2930714
	;;^DD(356.1,.02,1,3,0)
	;;=356.1^ATRTP1^MUMPS
	;;^DD(356.1,.02,1,3,1)
	;;=S:$P(^IBT(356.1,DA,0),U,22) ^IBT(356.1,"ATRTP",X,+$P($G(^IBE(356.11,+$P(^(0),U,22),0)),U,2),DA)=""
	;;^DD(356.1,.02,1,3,2)
	;;=K ^IBT(356.1,"ATRTP",X,+$P($G(^IBE(356.11,+$P(^IBT(356.1,DA,0),U,22),0)),U,2),DA)
	;;^DD(356.1,.02,1,3,"%D",0)
	;;=^^2^2^2930904^^^^
	;;^DD(356.1,.02,1,3,"%D",1,0)
	;;=Cross reference of all reviews for a tracking entry by type of review
	;;^DD(356.1,.02,1,3,"%D",2,0)
	;;=code.
	;;^DD(356.1,.02,1,3,"DT")
	;;=2930904
	;;^DD(356.1,.02,3)
	;;=
	;;^DD(356.1,.02,21,0)
	;;=^^3^3^2930719^^
	;;^DD(356.1,.02,21,1,0)
	;;=This is the Claims Tracking entry that is being reviewed.  Generally
	;;^DD(356.1,.02,21,2,0)
	;;=only inpatient admissions will have reviews performed.
	;;^DD(356.1,.02,21,3,0)
	;;= 
	;;^DD(356.1,.02,"DT")
	;;=2930904
	;;^DD(356.1,.03,0)
	;;=DAY FOR REVIEW^NJ5,0^^0;3^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(356.1,.03,3)
	;;=Enter the numeric day of this review, ie, 3, 6, 9, 14, 21, 28, etc.  Type a Number between 0 and 99999, 0 Decimal Digits
	;;^DD(356.1,.03,21,0)
	;;=^^8^8^2940213^^^^
	;;^DD(356.1,.03,21,1,0)
	;;=This is the number of the day of a continued stay review.  Continued stay
	;;^DD(356.1,.03,21,2,0)
	;;=reviews for UR purposes are generally done on days 3, 6, 9, 14, 21, 28,
	;;^DD(356.1,.03,21,3,0)
	;;=and every 7 days thereafter.  This field is normally computed from the
	;;^DD(356.1,.03,21,4,0)
	;;=Review date field.  However, it may be changed for reviews that are not
	;;^DD(356.1,.03,21,5,0)
	;;=solely for UR purposes.
	;;^DD(356.1,.03,21,6,0)
	;;= 
	;;^DD(356.1,.03,21,7,0)
	;;=Pre-certification reviews, Urgent Admission reviews, and Discharge 
	;;^DD(356.1,.03,21,8,0)
	;;=reviews will not have any data in this field.
	;;^DD(356.1,.03,"DT")
	;;=2930714
	;;^DD(356.1,.04,0)
	;;=SEVERITY OF ILLNESS^*P356.3'^IBE(356.3,^0;4^S DIC("S")="I $P(^(0),U,2)=2" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.04,12)
	;;=Only categories for general units may be selected!
	;;^DD(356.1,.04,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=2"
	;;^DD(356.1,.04,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.1,.04,21,1,0)
	;;=Enter the Severity of Illness (SI) category that best describes the
	;;^DD(356.1,.04,21,2,0)
	;;=criteria met for continued stay days of care.  Select the PRIMARY

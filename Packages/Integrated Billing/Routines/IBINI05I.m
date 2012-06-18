IBINI05I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.18,1,2,"DT")
	;;=2930709
	;;^DD(356,.18,1,3,0)
	;;=^^TRIGGER^356^.17
	;;^DD(356,.18,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y X ^DD(356,.18,1,3,1.1) X ^DD(356,.18,1,3,1.4)
	;;^DD(356,.18,1,3,1.1)
	;;=S X=DIV S X=$$EABD^IBTUTL($P($G(^IBT(356,+DA,0)),U,18),+$G(^IBT(356,+DA,1)))
	;;^DD(356,.18,1,3,1.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.18,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X="" S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.18,1,3,"%D",0)
	;;=^^2^2^2930824^^
	;;^DD(356,.18,1,3,"%D",1,0)
	;;=Sets the Earliest Auto Bill Date whenever Event Type is set.  Does not
	;;^DD(356,.18,1,3,"%D",2,0)
	;;=check if event is billable.
	;;^DD(356,.18,1,3,"CREATE VALUE")
	;;=S X=$$EABD^IBTUTL($P($G(^IBT(356,+DA,0)),U,18),+$G(^IBT(356,+DA,1)))
	;;^DD(356,.18,1,3,"DELETE VALUE")
	;;=@
	;;^DD(356,.18,1,3,"DT")
	;;=2930824
	;;^DD(356,.18,1,3,"FIELD")
	;;=EARLIEST AUTO BILL DATE
	;;^DD(356,.18,1,4,0)
	;;=356^APTY2^MUMPS
	;;^DD(356,.18,1,4,1)
	;;=S:$P(^IBT(356,DA,0),U,2)&($P(^(0),U,6)) ^IBT(356,"APTY",+$P(^(0),U,2),X,+$P(^(0),U,6),DA)=""
	;;^DD(356,.18,1,4,2)
	;;=K ^IBT(356,"APTY",+$P(^IBT(356,DA,0),U,2),X,+$P(^(0),U,6),DA)
	;;^DD(356,.18,1,4,"%D",0)
	;;=^^1^1^2930809^
	;;^DD(356,.18,1,4,"%D",1,0)
	;;=Cross-reference of all entries by patient by event type, by episode date.
	;;^DD(356,.18,1,4,"DT")
	;;=2930809
	;;^DD(356,.18,1,5,0)
	;;=^^TRIGGER^356^.07
	;;^DD(356,.18,1,5,1)
	;;=X ^DD(356,.18,1,5,1.3) I X S X=DIV S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X=DIV S X=$$ADT^IBTRE0(DA) X ^DD(356,.18,1,5,1.4)
	;;^DD(356,.18,1,5,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(2)=$C(59)_$S($D(^DD(356,.07,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,7)_":",2),$C(59),1)=""
	;;^DD(356,.18,1,5,1.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,7)=DIV,DIH=356,DIG=.07 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.18,1,5,2)
	;;=Q
	;;^DD(356,.18,1,5,"%D",0)
	;;=^^1^1^2931008^
	;;^DD(356,.18,1,5,"%D",1,0)
	;;= 
	;;^DD(356,.18,1,5,"CREATE CONDITION")
	;;=#.07=""
	;;^DD(356,.18,1,5,"CREATE VALUE")
	;;=S X=$$ADT^IBTRE0(DA)
	;;^DD(356,.18,1,5,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356,.18,1,5,"DT")
	;;=2931008
	;;^DD(356,.18,1,5,"FIELD")
	;;=#.07
	;;^DD(356,.18,21,0)
	;;=^^15^15^2940118^^^^
	;;^DD(356,.18,21,1,0)
	;;=This is the type of event that is being tracked.  This field
	;;^DD(356,.18,21,2,0)
	;;=is automatically stored when an entry is created.  Scheduled admissions
	;;^DD(356,.18,21,3,0)
	;;=are tracked to allow for precertification reviews.  When an admission
	;;^DD(356,.18,21,4,0)
	;;=occurs within 7 days of a scheduled admission the scheduled admission will
	;;^DD(356,.18,21,5,0)
	;;=be updated to an inpatient care event type automatically.
	;;^DD(356,.18,21,6,0)
	;;= 
	;;^DD(356,.18,21,7,0)
	;;=Choose an event type of Scheduled Admission only for future scheduled
	;;^DD(356,.18,21,8,0)
	;;=admissions and choose an event type of admission for past admissions.
	;;^DD(356,.18,21,9,0)
	;;=If you are using the scheduled admissions portion of the MAS package
	;;^DD(356,.18,21,10,0)
	;;=then scheduled admissions will automatically be added to claims tracking
	;;^DD(356,.18,21,11,0)
	;;=7 days before the scheduled admission and automatically converted to 

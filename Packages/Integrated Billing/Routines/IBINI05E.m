IBINI05E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.06,1,1,2)
	;;=K ^IBT(356,"D",$E(X,1,30),DA)
	;;^DD(356,.06,1,1,"DT")
	;;=2930820
	;;^DD(356,.06,1,2,0)
	;;=356^APTDT^MUMPS
	;;^DD(356,.06,1,2,1)
	;;=S:$P(^IBT(356,DA,0),U,2) ^IBT(356,"APTDT",+$P(^(0),U,2),-X,DA)=""
	;;^DD(356,.06,1,2,2)
	;;=K ^IBT(356,"APTDT",+$P(^IBT(356,DA,0),U,2),-X,DA)
	;;^DD(356,.06,1,2,"%D",0)
	;;=^^2^2^2931008^^^^
	;;^DD(356,.06,1,2,"%D",1,0)
	;;=Cross reference of all episodes of care by patient by date, in inverse
	;;^DD(356,.06,1,2,"%D",2,0)
	;;=date order so can list most recent first.
	;;^DD(356,.06,1,2,"DT")
	;;=2931008
	;;^DD(356,.06,1,4,0)
	;;=356^APTY1^MUMPS
	;;^DD(356,.06,1,4,1)
	;;=S:$P(^IBT(356,DA,0),U,2)&($P(^(0),U,18)) ^IBT(356,"APTY",+$P(^(0),U,2),+$P(^(0),U,18),X,DA)=""
	;;^DD(356,.06,1,4,2)
	;;=K ^IBT(356,"APTY",+$P(^IBT(356,DA,0),U,2),+$P(^(0),U,18),X,DA)
	;;^DD(356,.06,1,4,"%D",0)
	;;=^^1^1^2930809^^
	;;^DD(356,.06,1,4,"%D",1,0)
	;;=Cross-reference of all entries by patient by event type, by episode date.
	;;^DD(356,.06,1,4,"DT")
	;;=2930809
	;;^DD(356,.06,21,0)
	;;=^^7^7^2930712^^
	;;^DD(356,.06,21,1,0)
	;;=This is the date of the episode of care or services that is being tracked.
	;;^DD(356,.06,21,2,0)
	;;=For admissions, it is the admission date.  For outpatient visits it is
	;;^DD(356,.06,21,3,0)
	;;=the visit date.  For prescription refills it is the refill date.  For
	;;^DD(356,.06,21,4,0)
	;;=prosthetic items it is the date that the prosthetic item was issued.
	;;^DD(356,.06,21,5,0)
	;;= 
	;;^DD(356,.06,21,6,0)
	;;=The data in this field is entered by the Claims tracking event tracker
	;;^DD(356,.06,21,7,0)
	;;=routines.
	;;^DD(356,.06,"DT")
	;;=2931008
	;;^DD(356,.07,0)
	;;=ADMISSION TYPE^S^1:SCHEDULED;2:URGENT;3:EMERGENT;4:UNSCHEDULED;5:COURT ORDERED;^0;7^Q
	;;^DD(356,.07,5,1,0)
	;;=356^.18^5
	;;^DD(356,.07,21,0)
	;;=^^5^5^2940213^^^^
	;;^DD(356,.07,21,1,0)
	;;=Enter whether this admission was a scheduled admission, a direct
	;;^DD(356,.07,21,2,0)
	;;=admission from the outpatient area, or whether this was an
	;;^DD(356,.07,21,3,0)
	;;=urgent or emergent admission.  The type of admission will impact
	;;^DD(356,.07,21,4,0)
	;;=whether pre-certification reviews should be done and the impact
	;;^DD(356,.07,21,5,0)
	;;=on reimbursements.
	;;^DD(356,.07,"DT")
	;;=2930820
	;;^DD(356,.08,0)
	;;=PRESCRIPTION^P52'^PSRX(^0;8^Q
	;;^DD(356,.08,1,0)
	;;=^.1
	;;^DD(356,.08,1,1,0)
	;;=356^ARXFL1^MUMPS
	;;^DD(356,.08,1,1,1)
	;;=S:$P(^IBT(356,DA,0),U,10) ^IBT(356,"ARXFL",X,+$P(^(0),U,10),DA)=""
	;;^DD(356,.08,1,1,2)
	;;=K ^IBT(356,"ARXFL",X,+$P(^IBT(356,DA,0),U,10),DA)
	;;^DD(356,.08,1,1,"%D",0)
	;;=^^2^2^2940213^^^
	;;^DD(356,.08,1,1,"%D",1,0)
	;;=This is a cross reference of all prescriptions and refills.  It is used
	;;^DD(356,.08,1,1,"%D",2,0)
	;;=to ensure that only 1 entry for each refill is created.
	;;^DD(356,.08,1,1,"DT")
	;;=2930813
	;;^DD(356,.08,21,0)
	;;=^^2^2^2940213^^
	;;^DD(356,.08,21,1,0)
	;;=If the entry that is being tracked is a prescription refill then this
	;;^DD(356,.08,21,2,0)
	;;=field should point to the entry in the prescription file.
	;;^DD(356,.08,"DT")
	;;=2930813
	;;^DD(356,.09,0)
	;;=PROSTHETIC ITEM^P660'^RMPR(660,^0;9^Q
	;;^DD(356,.09,1,0)
	;;=^.1
	;;^DD(356,.09,1,1,0)
	;;=356^APRO
	;;^DD(356,.09,1,1,1)
	;;=S ^IBT(356,"APRO",$E(X,1,30),DA)=""
	;;^DD(356,.09,1,1,2)
	;;=K ^IBT(356,"APRO",$E(X,1,30),DA)
	;;^DD(356,.09,1,1,"DT")
	;;=2940131
	;;^DD(356,.09,3)
	;;=
	;;^DD(356,.09,21,0)
	;;=^^2^2^2931221^^
	;;^DD(356,.09,21,1,0)
	;;=If this tracking entry is for a prothetic item, this is the pointer
	;;^DD(356,.09,21,2,0)
	;;=to the prosthetic item file.

IBINI05M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.3,21,1,0)
	;;=This is the ICD9 diagnosis code for the admitting diagnosis.
	;;^DD(356,.3,"DT")
	;;=2930901
	;;^DD(356,.31,0)
	;;=SPECIAL CONSENT ROI^S^1:NOT REQUIRED;2:OBTAINED;3:REQUIRED;4:REFUSED;^0;31^Q
	;;^DD(356,.31,21,0)
	;;=^^9^9^2930820^^
	;;^DD(356,.31,21,1,0)
	;;=Enter whether or not a special consent release of information 
	;;^DD(356,.31,21,2,0)
	;;=form for this patient for this
	;;^DD(356,.31,21,3,0)
	;;=episode of care is required, obtained, or not necessary.  If ROI is
	;;^DD(356,.31,21,4,0)
	;;=required but not obtained, certain clinical information may not be
	;;^DD(356,.31,21,5,0)
	;;=released to Insurance carriers.  This will affect contacts with
	;;^DD(356,.31,21,6,0)
	;;=insurance companies and bill preparation.
	;;^DD(356,.31,21,7,0)
	;;= 
	;;^DD(356,.31,21,8,0)
	;;=Generally a special consent is required if the patient has or was treated
	;;^DD(356,.31,21,9,0)
	;;=for Drug and Alcohol, HIV, and sickle cell anemia.
	;;^DD(356,.31,"DT")
	;;=2930824
	;;^DD(356,.32,0)
	;;=SCHEDULED ADMISSION^*P41.1'^DGS(41.1,^0;32^S DIC("S")="I +^(0)=$P(^IBT(356,DA,0),U,2)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356,.32,1,0)
	;;=^.1
	;;^DD(356,.32,1,1,0)
	;;=356^ASCH
	;;^DD(356,.32,1,1,1)
	;;=S ^IBT(356,"ASCH",$E(X,1,30),DA)=""
	;;^DD(356,.32,1,1,2)
	;;=K ^IBT(356,"ASCH",$E(X,1,30),DA)
	;;^DD(356,.32,1,1,"%D",0)
	;;=^^1^1^2930809^
	;;^DD(356,.32,1,1,"%D",1,0)
	;;=Regular index of scheduled admissions
	;;^DD(356,.32,1,1,"DT")
	;;=2930809
	;;^DD(356,.32,12)
	;;=You can only select scheduled admissions for the same patient.
	;;^DD(356,.32,12.1)
	;;=S DIC("S")="I +^(0)=$P(^IBT(356,DA,0),U,2)"
	;;^DD(356,.32,21,0)
	;;=^^7^7^2930809^
	;;^DD(356,.32,21,1,0)
	;;=If this claims tracking entry is for a scheduled admission, this is
	;;^DD(356,.32,21,2,0)
	;;=the scheduled admission.
	;;^DD(356,.32,21,3,0)
	;;= 
	;;^DD(356,.32,21,4,0)
	;;=This field points to the entry in the Scheduled Admissions file that
	;;^DD(356,.32,21,5,0)
	;;=is being tracked.  When this scheduled admission is acutally admitted,
	;;^DD(356,.32,21,6,0)
	;;=it will be converted to an inpatient admission tracking record 
	;;^DD(356,.32,21,7,0)
	;;=automatically.
	;;^DD(356,.32,"DT")
	;;=2930809
	;;^DD(356,1.01,0)
	;;=DATE ENTERED^D^^1;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356,1.01,1,0)
	;;=^.1
	;;^DD(356,1.01,1,1,0)
	;;=^^TRIGGER^356^.17
	;;^DD(356,1.01,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y X ^DD(356,1.01,1,1,1.1) X ^DD(356,1.01,1,1,1.4)
	;;^DD(356,1.01,1,1,1.1)
	;;=S X=DIV S X=$$EABD^IBTUTL($P($G(^IBT(356,+DA,0)),U,18),+$G(^IBT(356,+DA,1)))
	;;^DD(356,1.01,1,1,1.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,1.01,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X="" S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,1.01,1,1,"%D",0)
	;;=^^2^2^2930824^^
	;;^DD(356,1.01,1,1,"%D",1,0)
	;;=Sets the Earliest Auto Bill Date whenever Date Entered is set.  Does
	;;^DD(356,1.01,1,1,"%D",2,0)
	;;=not check if event is billable.
	;;^DD(356,1.01,1,1,"CREATE VALUE")
	;;=S X=$$EABD^IBTUTL($P($G(^IBT(356,+DA,0)),U,18),+$G(^IBT(356,+DA,1)))
	;;^DD(356,1.01,1,1,"DELETE VALUE")
	;;=@
	;;^DD(356,1.01,1,1,"FIELD")
	;;=EARLIEST AUTO BILL DATE
	;;^DD(356,1.01,3)
	;;=
	;;^DD(356,1.01,21,0)
	;;=^^2^2^2930712^
	;;^DD(356,1.01,21,1,0)
	;;=Enter the date that this entry was created.  This will usually be the

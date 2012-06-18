IBINI061	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.03,21,5,0)
	;;=entry created for a case that is also an insurance case.
	;;^DD(356.2,.03,"DT")
	;;=2930715
	;;^DD(356.2,.04,0)
	;;=TYPE OF CONTACT^R*P356.11'^IBE(356.11,^0;4^S DIC("S")="I $$CONTCT^IBTRC(DA,Y)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.2,.04,1,0)
	;;=^.1
	;;^DD(356.2,.04,1,1,0)
	;;=356.2^AC
	;;^DD(356.2,.04,1,1,1)
	;;=S ^IBT(356.2,"AC",$E(X,1,30),DA)=""
	;;^DD(356.2,.04,1,1,2)
	;;=K ^IBT(356.2,"AC",$E(X,1,30),DA)
	;;^DD(356.2,.04,1,1,"DT")
	;;=2930712
	;;^DD(356.2,.04,1,2,0)
	;;=356.2^ATRTP1^MUMPS
	;;^DD(356.2,.04,1,2,1)
	;;=S:$P(^IBT(356.2,DA,0),U,2) ^IBT(356.2,"ATRTP",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.2,.04,1,2,2)
	;;=K ^IBT(356.2,"ATRTP",+$P(^IBT(356.2,DA,0),U,2),X,DA)
	;;^DD(356.2,.04,1,2,"%D",0)
	;;=^^1^1^2930712^
	;;^DD(356.2,.04,1,2,"%D",1,0)
	;;=Index of all communications by tracking id and type.
	;;^DD(356.2,.04,1,2,"DT")
	;;=2930712
	;;^DD(356.2,.04,3)
	;;=
	;;^DD(356.2,.04,12)
	;;=If not associated with a tracking entry, only a patient or other type of contact may be selected.
	;;^DD(356.2,.04,12.1)
	;;=S DIC("S")="I $$CONTCT^IBTRC(DA,Y)"
	;;^DD(356.2,.04,21,0)
	;;=^^9^9^2940112^^^^
	;;^DD(356.2,.04,21,1,0)
	;;=This is the type of contact with a patient or insurance company that
	;;^DD(356.2,.04,21,2,0)
	;;=you are making.  If this is a contact with a patient then select patient.
	;;^DD(356.2,.04,21,3,0)
	;;=If this is a contact with an insurance company then indicate if this
	;;^DD(356.2,.04,21,4,0)
	;;=is for pre-certification, urgent/emergent admission,
	;;^DD(356.2,.04,21,5,0)
	;;=continued stay, discharge, outpatient treatment, or an appeal.  
	;;^DD(356.2,.04,21,6,0)
	;;=You may also select other if this is a contact that you wish to record
	;;^DD(356.2,.04,21,7,0)
	;;=but does not meet one of these categories.
	;;^DD(356.2,.04,21,8,0)
	;;= 
	;;^DD(356.2,.04,21,9,0)
	;;=To add an appeal it must be associated with a denial.
	;;^DD(356.2,.04,"DT")
	;;=2930803
	;;^DD(356.2,.05,0)
	;;=PATIENT^P2'^DPT(^0;5^Q
	;;^DD(356.2,.05,1,0)
	;;=^.1
	;;^DD(356.2,.05,1,1,0)
	;;=356.2^D
	;;^DD(356.2,.05,1,1,1)
	;;=S ^IBT(356.2,"D",$E(X,1,30),DA)=""
	;;^DD(356.2,.05,1,1,2)
	;;=K ^IBT(356.2,"D",$E(X,1,30),DA)
	;;^DD(356.2,.05,1,1,"DT")
	;;=2930729
	;;^DD(356.2,.05,1,2,0)
	;;=356.2^APACT^MUMPS
	;;^DD(356.2,.05,1,2,1)
	;;=S:$P(^IBT(356.2,DA,0),U,11) ^IBT(356.2,"APACT",X,+$P(^(0),U,11),DA)=""
	;;^DD(356.2,.05,1,2,2)
	;;=K ^IBT(356.2,"APACT",X,+$P(^IBT(356.2,DA,0),U,11),DA)
	;;^DD(356.2,.05,1,2,"%D",0)
	;;=^^2^2^2930811^^^
	;;^DD(356.2,.05,1,2,"%D",1,0)
	;;=Index of insurance contacts with actions by patient by action.
	;;^DD(356.2,.05,1,2,"%D",2,0)
	;;=Used primarily to find denials by patient.
	;;^DD(356.2,.05,1,2,"DT")
	;;=2930811
	;;^DD(356.2,.05,1,3,0)
	;;=^^TRIGGER^356.2^1.05
	;;^DD(356.2,.05,1,3,1)
	;;=X ^DD(356.2,.05,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^IBT(356.2,D0,1)):^(1),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X=DIV S X=$P($$HIP^IBTRC3(DA),"^",1) X ^DD(356.2,.05,1,3,1.4)
	;;^DD(356.2,.05,1,3,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^IBT(356.2,D0,1)):^(1),1:""),Y=$P(Y(1),U,5) X:$D(^DD(356.2,1.05,2)) ^(2) S X=Y=""
	;;^DD(356.2,.05,1,3,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,5)=DIV,DIH=356.2,DIG=1.05 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.05,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356.2,D0,1)):^(1),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(356.2,.05,1,3,2.4)
	;;^DD(356.2,.05,1,3,2.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,5)=DIV,DIH=356.2,DIG=1.05 D ^DICR:$N(^DD(DIH,DIG,1,0))>0

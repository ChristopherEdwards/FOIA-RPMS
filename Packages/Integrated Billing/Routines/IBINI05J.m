IBINI05J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.18,21,12,0)
	;;=an event type of admission after the patient has been admitted.
	;;^DD(356,.18,21,13,0)
	;;= 
	;;^DD(356,.18,21,14,0)
	;;=For admissions you will be able to specify the type of admission in
	;;^DD(356,.18,21,15,0)
	;;=another field.
	;;^DD(356,.18,"DT")
	;;=2931008
	;;^DD(356,.19,0)
	;;=REASON NOT BILLABLE^P356.8'^IBE(356.8,^0;19^Q
	;;^DD(356,.19,.1)
	;;=NOT BILLABLE REASON
	;;^DD(356,.19,1,0)
	;;=^.1
	;;^DD(356,.19,1,1,0)
	;;=356^AR
	;;^DD(356,.19,1,1,1)
	;;=S ^IBT(356,"AR",$E(X,1,30),DA)=""
	;;^DD(356,.19,1,1,2)
	;;=K ^IBT(356,"AR",$E(X,1,30),DA)
	;;^DD(356,.19,1,1,"%D",0)
	;;=^^1^1^2930709^
	;;^DD(356,.19,1,1,"%D",1,0)
	;;=Regular cross reference of reason not billable
	;;^DD(356,.19,1,1,"DT")
	;;=2930709
	;;^DD(356,.19,1,2,0)
	;;=356^ANABD1^MUMPS
	;;^DD(356,.19,1,2,1)
	;;=K:X ^IBT(356,"ANABD",+$P(^IBT(356,DA,0),U,18),+$P(^(0),U,17),DA)
	;;^DD(356,.19,1,2,2)
	;;=S:$P(^IBT(356,DA,0),U,20)&($P(^(0),U,17))&($P(^(0),U,18)) ^IBT(356,"ANABD",$P(^(0),U,18),$P(^(0),U,17),DA)=""
	;;^DD(356,.19,1,2,"%D",0)
	;;=^^2^2^2930709^
	;;^DD(356,.19,1,2,"%D",1,0)
	;;=Cross reference of all active, billable events by event type and next
	;;^DD(356,.19,1,2,"%D",2,0)
	;;=auto bill date.
	;;^DD(356,.19,1,2,"DT")
	;;=2930709
	;;^DD(356,.19,1,3,0)
	;;=^^TRIGGER^356^.17
	;;^DD(356,.19,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X="" S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.19,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X=DIV S X=$$BILL^IBTUTL(DA) X ^DD(356,.19,1,3,2.4)
	;;^DD(356,.19,1,3,2.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.19,1,3,"%D",0)
	;;=^^2^2^2930824^
	;;^DD(356,.19,1,3,"%D",1,0)
	;;=Deletes the Earliest Auto Bill Date (.17) when Reason Not Billable is set,
	;;^DD(356,.19,1,3,"%D",2,0)
	;;=event is no longer billable.  Re-sets EABD if Reason Not Billable is deleted.
	;;^DD(356,.19,1,3,"CREATE VALUE")
	;;=@
	;;^DD(356,.19,1,3,"DELETE VALUE")
	;;=S X=$$BILL^IBTUTL(DA)
	;;^DD(356,.19,1,3,"DT")
	;;=2930824
	;;^DD(356,.19,1,3,"FIELD")
	;;=EARLIEST AUTO BILL DATE
	;;^DD(356,.19,21,0)
	;;=^^6^6^2930712^^^
	;;^DD(356,.19,21,1,0)
	;;=Enter the primary reason this episode of care should not be billed to
	;;^DD(356,.19,21,2,0)
	;;=an insurance company.
	;;^DD(356,.19,21,3,0)
	;;= 
	;;^DD(356,.19,21,4,0)
	;;=If a reason not billable is entered, then this episode will no longer
	;;^DD(356,.19,21,5,0)
	;;=appear on reports as billable and will not be used by the automated
	;;^DD(356,.19,21,6,0)
	;;=biller as a billable event.
	;;^DD(356,.19,"DT")
	;;=2930824
	;;^DD(356,.2,0)
	;;=INACTIVE^S^0:INACTIVE;1:ACTIVE;^0;20^Q
	;;^DD(356,.2,1,0)
	;;=^.1
	;;^DD(356,.2,1,1,0)
	;;=356^ANABD2^MUMPS
	;;^DD(356,.2,1,1,1)
	;;=S:X&($P(^IBT(356,DA,0),U,19)="")&($P(^(0),U,18))&($P(^(0),U,17)) ^IBT(356,"ANABD",$P(^(0),U,18),$P(^(0),U,17),DA)=""
	;;^DD(356,.2,1,1,2)
	;;=K ^IBT(356,"ANABD",+$P(^IBT(356,DA,0),U,18),+$P(^(0),U,17),DA)
	;;^DD(356,.2,1,1,"%D",0)
	;;=^^2^2^2930709^^^^
	;;^DD(356,.2,1,1,"%D",1,0)
	;;=Cross reference of all active, billable events by event type and next
	;;^DD(356,.2,1,1,"%D",2,0)
	;;=auto bill date.
	;;^DD(356,.2,1,1,"DT")
	;;=2930709
	;;^DD(356,.2,1,2,0)
	;;=^^TRIGGER^356^.17
	;;^DD(356,.2,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X=DIV S X=$$BILL^IBTUTL(DA) X ^DD(356,.2,1,2,1.4)

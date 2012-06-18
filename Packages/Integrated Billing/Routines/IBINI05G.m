IBINI05G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.12,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X=DIV S X=$$BILL^IBTUTL(DA) X ^DD(356,.12,1,3,2.4)
	;;^DD(356,.12,1,3,2.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.12,1,3,"%D",0)
	;;=^^4^4^2940213^^^
	;;^DD(356,.12,1,3,"%D",1,0)
	;;=Deletes the Earliest Auto Bill Date (.17) if an Other Type of Bill is
	;;^DD(356,.12,1,3,"%D",2,0)
	;;=entered, the event may need a rate type other than reimbursable ins.
	;;^DD(356,.12,1,3,"%D",3,0)
	;;=and therefore should not be billed by the automated biller.
	;;^DD(356,.12,1,3,"%D",4,0)
	;;=Re-sets EABD if Other Type of Bill is deleted.
	;;^DD(356,.12,1,3,"CREATE VALUE")
	;;=@
	;;^DD(356,.12,1,3,"DELETE VALUE")
	;;=S X=$$BILL^IBTUTL(DA)
	;;^DD(356,.12,1,3,"DT")
	;;=2930824
	;;^DD(356,.12,1,3,"FIELD")
	;;=EARLIEST AUTO BILL DATE
	;;^DD(356,.12,21,0)
	;;=^^4^4^2940213^^^^
	;;^DD(356,.12,21,1,0)
	;;=If this claims tracking entry can be billed as other than an insurance
	;;^DD(356,.12,21,2,0)
	;;=claim or a patient bill enter the type of claim.  If a patient has
	;;^DD(356,.12,21,3,0)
	;;=ever had a claim type other than insurance then special warnings may
	;;^DD(356,.12,21,4,0)
	;;=be given in the billing and claims tracking package.
	;;^DD(356,.12,"DT")
	;;=2930824
	;;^DD(356,.14,0)
	;;=SECOND OPINION REQUIRED^S^1:YES;0:NO;^0;14^Q
	;;^DD(356,.14,21,0)
	;;=^^2^2^2930712^
	;;^DD(356,.14,21,1,0)
	;;=If this patient insurance policy requires a second opinion enter 'YES'.
	;;^DD(356,.14,21,2,0)
	;;=If a second opinion is not required then enter 'NO'.
	;;^DD(356,.14,"DT")
	;;=2930609
	;;^DD(356,.15,0)
	;;=SECOND OPINION OBTAINED^S^1:YES;0:NO;^0;15^Q
	;;^DD(356,.15,3)
	;;=
	;;^DD(356,.15,21,0)
	;;=^^8^8^2940213^^
	;;^DD(356,.15,21,1,0)
	;;=If a second opinion was required by this patients' insurance policy,
	;;^DD(356,.15,21,2,0)
	;;=enter 'YES' if it was obtained or 'NO' if it was not obtained.  If
	;;^DD(356,.15,21,3,0)
	;;=a second opinion was obtained but did not meet the insurance companies
	;;^DD(356,.15,21,4,0)
	;;=criteria for any reason, enter 'NO'.
	;;^DD(356,.15,21,5,0)
	;;= 
	;;^DD(356,.15,21,6,0)
	;;=This field will be used to help determine the estimated reimbursement
	;;^DD(356,.15,21,7,0)
	;;=from the insurance carrier.  If a second opinion was not obtained
	;;^DD(356,.15,21,8,0)
	;;=certain denials and penalties may be assessed.
	;;^DD(356,.15,"DT")
	;;=2930609
	;;^DD(356,.17,0)
	;;=EARLIEST AUTO BILL DATE^D^^0;17^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356,.17,1,0)
	;;=^.1
	;;^DD(356,.17,1,1,0)
	;;=356^ABD
	;;^DD(356,.17,1,1,1)
	;;=S ^IBT(356,"ABD",$E(X,1,30),DA)=""
	;;^DD(356,.17,1,1,2)
	;;=K ^IBT(356,"ABD",$E(X,1,30),DA)
	;;^DD(356,.17,1,1,"%D",0)
	;;=^^1^1^2930709^
	;;^DD(356,.17,1,1,"%D",1,0)
	;;=Regular cross reference of auto bill date field.
	;;^DD(356,.17,1,1,"DT")
	;;=2930709
	;;^DD(356,.17,1,2,0)
	;;=356^ATOBIL1^MUMPS
	;;^DD(356,.17,1,2,1)
	;;=S:$P(^IBT(356,DA,0),U,2)&($P(^(0),U,18)) ^IBT(356,"ATOBIL",+$P(^(0),U,2),+$P(^(0),U,18),+X,DA)=""
	;;^DD(356,.17,1,2,2)
	;;=K ^IBT(356,"ATOBIL",+$P(^IBT(356,DA,0),U,2),+$P(^(0),U,18),+X,DA)
	;;^DD(356,.17,1,2,"%D",0)
	;;=^^3^3^2930824^^
	;;^DD(356,.17,1,2,"%D",1,0)
	;;=Cross-reference of all billable, non-billed events by patient, event type,
	;;^DD(356,.17,1,2,"%D",2,0)
	;;=and earliest auto bill date.  Only events with entries in this x-ref
	;;^DD(356,.17,1,2,"%D",3,0)
	;;=will be considered for inclusion on a bill by the automated biller.

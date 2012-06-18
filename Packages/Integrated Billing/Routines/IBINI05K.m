IBINI05K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.2,1,2,1.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.2,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X="" S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.2,1,2,"%D",0)
	;;=^^1^1^2930824^
	;;^DD(356,.2,1,2,"%D",1,0)
	;;=Re-sets Earliest Auto Bill Date whenever Status is modified.
	;;^DD(356,.2,1,2,"CREATE VALUE")
	;;=S X=$$BILL^IBTUTL(DA)
	;;^DD(356,.2,1,2,"DELETE VALUE")
	;;=@
	;;^DD(356,.2,1,2,"DT")
	;;=2930824
	;;^DD(356,.2,1,2,"FIELD")
	;;=EARLIEST AUTO BILL DATE
	;;^DD(356,.2,21,0)
	;;=^^6^6^2930826^^^^
	;;^DD(356,.2,21,1,0)
	;;=An entry is automatically inactived if the parent event that is being
	;;^DD(356,.2,21,2,0)
	;;=tracked is either deleted or edited so that it no longer is a valid tracking
	;;^DD(356,.2,21,3,0)
	;;=entry.
	;;^DD(356,.2,21,4,0)
	;;= 
	;;^DD(356,.2,21,5,0)
	;;=Inactivating an entry has the same affect as deleting an entry except that
	;;^DD(356,.2,21,6,0)
	;;=the activity is left as a history.
	;;^DD(356,.2,"DT")
	;;=2930826
	;;^DD(356,.21,0)
	;;=ESTIMATED INS. PAYMENT (PRI)^NJ10,2^^0;21^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(356,.21,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(356,.21,21,0)
	;;=^^2^2^2930712^^
	;;^DD(356,.21,21,1,0)
	;;=This is the estimated amount that the primary insurance carrier is expected
	;;^DD(356,.21,21,2,0)
	;;=to pay on this claim.
	;;^DD(356,.21,"DT")
	;;=2930712
	;;^DD(356,.22,0)
	;;=ESTIMATED INS. PAYMENT (SEC)^NJ10,2^^0;22^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(356,.22,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(356,.22,21,0)
	;;=^^2^2^2930712^
	;;^DD(356,.22,21,1,0)
	;;=This the the estimated amount that the secondary insurance carrier is
	;;^DD(356,.22,21,2,0)
	;;=expected to pay on this claim.
	;;^DD(356,.22,"DT")
	;;=2930712
	;;^DD(356,.23,0)
	;;=ESTIMATED INS. PAYMENT (TER)^NJ10,2^^0;23^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(356,.23,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(356,.23,21,0)
	;;=^^2^2^2940213^^
	;;^DD(356,.23,21,1,0)
	;;=This is the estimated amount that the tertiary insurance carrier is
	;;^DD(356,.23,21,2,0)
	;;=expected to pay on this claim.
	;;^DD(356,.23,"DT")
	;;=2930712
	;;^DD(356,.24,0)
	;;=TRACKED AS INSURANCE CLAIM?^*S^1:YES;0:NO;^0;24^Q
	;;^DD(356,.24,.1)
	;;=INSURANCE CLAIM?
	;;^DD(356,.24,1,0)
	;;=^.1^^-1
	;;^DD(356,.24,1,1,0)
	;;=356^AI
	;;^DD(356,.24,1,1,1)
	;;=S ^IBT(356,"AI",$E(X,1,30),DA)=""
	;;^DD(356,.24,1,1,2)
	;;=K ^IBT(356,"AI",$E(X,1,30),DA)
	;;^DD(356,.24,1,1,"DT")
	;;=2930709
	;;^DD(356,.24,12)
	;;=Only patients who have active insurance for the episode
	;;^DD(356,.24,12.1)
	;;=S DIC("S")="I $S(Y=0:1,$$INSURED^IBCNS1($P(^IBT(356,DA,0),U,2),$P(^(0),U,6)):1,1:0)"
	;;^DD(356,.24,21,0)
	;;=^^5^5^2930804^^^
	;;^DD(356,.24,21,1,0)
	;;=Enter 'YES' if the patient is insured for this event.  Enter 'No' if 
	;;^DD(356,.24,21,2,0)
	;;=the patient is not insured for this event.  If this event is not
	;;^DD(356,.24,21,3,0)
	;;=tracked as an insurance claim, the field REASON NOT BILLABLE will
	;;^DD(356,.24,21,4,0)
	;;=automatically have entered "NOT INSURED" if it is not otherwise
	;;^DD(356,.24,21,5,0)
	;;=entered.
	;;^DD(356,.24,"DT")
	;;=2930827
	;;^DD(356,.25,0)
	;;=TRACKED AS RANDOM SAMPLE?^S^1:YES;0:NO;^0;25^Q

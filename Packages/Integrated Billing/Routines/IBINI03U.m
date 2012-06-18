IBINI03U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.1,.1,1,3,"%D",2,0)
	;;=year (CY).  This equates to $e(effective date,1,3).
	;;^DD(354.1,.1,1,3,"DT")
	;;=2921118
	;;^DD(354.1,.1,12)
	;;=Only 1 entry for a patient for an effective date can be active at one time
	;;^DD(354.1,.1,12.1)
	;;=S DIC("S")="I $$ACTIVE^IBARXEU(X)"
	;;^DD(354.1,.1,21,0)
	;;=^^4^4^2930430^^^^
	;;^DD(354.1,.1,21,1,0)
	;;=Only 1 record for an effective date can be active at a time.  When
	;;^DD(354.1,.1,21,2,0)
	;;=it is necessary to change a patient's exemption status the user will
	;;^DD(354.1,.1,21,3,0)
	;;=be asked if this is the currently active record.  If yes, then all 
	;;^DD(354.1,.1,21,4,0)
	;;=other records for the effective date will be inactivated automatically.
	;;^DD(354.1,.1,"DT")
	;;=2930204
	;;^DD(354.1,.11,0)
	;;=ELECTRONIC SIGNATURE^FO^^0;11^K:$L(X)>20!($L(X)<6) X
	;;^DD(354.1,.11,2)
	;;=S Y(0)=Y S Y(0)=Y S Y="<Hidden>"
	;;^DD(354.1,.11,2.1)
	;;=S Y(0)=Y S Y="<Hidden>"
	;;^DD(354.1,.11,3)
	;;=Answer must be 6-20 characters in length.
	;;^DD(354.1,.11,21,0)
	;;=^^4^4^2930430^^^
	;;^DD(354.1,.11,21,1,0)
	;;=Enter your Electronic Signature.  This field will be required whenever
	;;^DD(354.1,.11,21,2,0)
	;;=a user trys to create an exemption that is different from the
	;;^DD(354.1,.11,21,3,0)
	;;=exemption computed by the system.  This would
	;;^DD(354.1,.11,21,4,0)
	;;=be required in order to create a hardship exemption.
	;;^DD(354.1,.11,"DT")
	;;=2930422
	;;^DD(354.1,.12,0)
	;;=SECOND ELECTRONIC SIGNATURE^F^^0;12^K:$L(X)>40!($L(X)<3) X
	;;^DD(354.1,.12,3)
	;;=Answer must be 3-40 characters in length.
	;;^DD(354.1,.12,21,0)
	;;=^^3^3^2930430^
	;;^DD(354.1,.12,21,1,0)
	;;=A second electronic signature for hardship exemptions will be
	;;^DD(354.1,.12,21,2,0)
	;;=implemented in a future release.
	;;^DD(354.1,.12,21,3,0)
	;;=|
	;;^DD(354.1,.12,"DT")
	;;=2930422
	;;^DD(354.1,.13,0)
	;;=RETRO CANCEL BILLS START DATE^D^^0;13^S %DT="EX" D ^%DT S X=Y K:3991231<X!(2920129>X) X
	;;^DD(354.1,.13,3)
	;;=TYPE A DATE BETWEEN 1/29/1992 AND 12/31/2099
	;;^DD(354.1,.13,21,0)
	;;=^^4^4^2930430^^
	;;^DD(354.1,.13,21,1,0)
	;;=If this exemption requires retroactively canceling prior charges, this
	;;^DD(354.1,.13,21,2,0)
	;;=is the beginning date for the retroactive cancellation.  This must be 
	;;^DD(354.1,.13,21,3,0)
	;;=tracked to prevent duplicate retroactive cancellations of the same
	;;^DD(354.1,.13,21,4,0)
	;;=charges.
	;;^DD(354.1,.13,"DT")
	;;=2921209
	;;^DD(354.1,.14,0)
	;;=RETRO CANCEL BILLS END DATE^D^^0;14^S %DT="EX" D ^%DT S X=Y K:3991231<X!(2920129>X) X
	;;^DD(354.1,.14,1,0)
	;;=^.1
	;;^DD(354.1,.14,1,1,0)
	;;=354.1^ACAN^MUMPS
	;;^DD(354.1,.14,1,1,1)
	;;=I $P(^IBA(354.1,DA,0),"^",2) S ^IBA(354.1,"ACAN",$P(^(0),"^",2),-X,DA)=""
	;;^DD(354.1,.14,1,1,2)
	;;=K ^IBA(354.1,"ACAN",$P(^IBA(354.1,DA,0),"^",2),-X,DA)
	;;^DD(354.1,.14,1,1,3)
	;;=DO NOT DELETE
	;;^DD(354.1,.14,1,1,"%D",0)
	;;=^^6^6^2930430^^^^
	;;^DD(354.1,.14,1,1,"%D",1,0)
	;;=This cross-reference is set whenever bills are retroactively canceled
	;;^DD(354.1,.14,1,1,"%D",2,0)
	;;=due to the medication copayment exemption patch.  It is used to
	;;^DD(354.1,.14,1,1,"%D",3,0)
	;;=prevent canceling charges in AR for the same period.  This is
	;;^DD(354.1,.14,1,1,"%D",4,0)
	;;=necessary because the direct link between IB and AR is not maintained
	;;^DD(354.1,.14,1,1,"%D",5,0)
	;;=for this functionality as it is necessary to remove admin and interest
	;;^DD(354.1,.14,1,1,"%D",6,0)
	;;=charges that may have accumulated.
	;;^DD(354.1,.14,1,1,"DT")
	;;=2930113
	;;^DD(354.1,.14,3)
	;;=TYPE A DATE BETWEEN 1/29/1992 AND 12/31/2099

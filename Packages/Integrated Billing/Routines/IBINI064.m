IBINI064	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.11,12)
	;;=Only actions appropriate for the type of contact may be selected!
	;;^DD(356.2,.11,12.1)
	;;=S DIC("S")="N ACODE,CTYPE S ACODE=$P(^(0),U,3),CTYPE=$P(^IBT(356.2,DA,0),U,4) I $$SCREEN^IBTRC1(ACODE,CTYPE)"
	;;^DD(356.2,.11,21,0)
	;;=^^10^10^2940213^^^^
	;;^DD(356.2,.11,21,1,0)
	;;=Enter the action that the insurance company took on this call.  
	;;^DD(356.2,.11,21,2,0)
	;;=Each contact can only have one action.  If you need to enter
	;;^DD(356.2,.11,21,3,0)
	;;=more than one action, enter another contact.  If you change the
	;;^DD(356.2,.11,21,4,0)
	;;=action, previously entered information will be deleted.
	;;^DD(356.2,.11,21,5,0)
	;;= 
	;;^DD(356.2,.11,21,6,0)
	;;=If this contact was with an insurance company as part of an admission
	;;^DD(356.2,.11,21,7,0)
	;;=or continued stay review then you should enter the action that the
	;;^DD(356.2,.11,21,8,0)
	;;=insurance company took on thecall.  Based upon the answer to
	;;^DD(356.2,.11,21,9,0)
	;;=this question along with the type of contact, you will be prompted
	;;^DD(356.2,.11,21,10,0)
	;;=for varying information.
	;;^DD(356.2,.11,"DT")
	;;=2931007
	;;^DD(356.2,.12,0)
	;;=CARE AUTHORIZED FROM^RDX^^0;12^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) K:'$$AFDT^IBTUTL4(DA,X) X
	;;^DD(356.2,.12,4)
	;;=D HELP^IBTUTL3(DA)
	;;^DD(356.2,.12,21,0)
	;;=^^3^3^2930806^^
	;;^DD(356.2,.12,21,1,0)
	;;=If the insurance company pre-approved the admission for
	;;^DD(356.2,.12,21,2,0)
	;;=this patient, this is the beginning date that they approved care
	;;^DD(356.2,.12,21,3,0)
	;;=from.
	;;^DD(356.2,.12,"DT")
	;;=2940127
	;;^DD(356.2,.13,0)
	;;=CARE AUTHORIZED TO^RDX^^0;13^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) K:'$$ATDT^IBTUTL4(DA,X) X
	;;^DD(356.2,.13,1,0)
	;;=^.1
	;;^DD(356.2,.13,1,1,0)
	;;=^^TRIGGER^356.2^.24
	;;^DD(356.2,.13,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X=DIV S X=$P(^IBT(356.2,DA,0),U,13) X ^DD(356.2,.13,1,1,1.4)
	;;^DD(356.2,.13,1,1,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,24)=DIV,DIH=356.2,DIG=.24 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.13,1,1,2)
	;;=Q
	;;^DD(356.2,.13,1,1,"CREATE VALUE")
	;;=S X=$P(^IBT(356.2,DA,0),U,13)
	;;^DD(356.2,.13,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.2,.13,1,1,"FIELD")
	;;=#.24
	;;^DD(356.2,.13,3)
	;;=
	;;^DD(356.2,.13,4)
	;;=D HELP^IBTUTL3(DA)
	;;^DD(356.2,.13,21,0)
	;;=^^6^6^2940213^^
	;;^DD(356.2,.13,21,1,0)
	;;=If the insurance company pre-approved the admission for this
	;;^DD(356.2,.13,21,2,0)
	;;=patient, this is the ending date of the care approved. 
	;;^DD(356.2,.13,21,3,0)
	;;= 
	;;^DD(356.2,.13,21,4,0)
	;;=Typically insurance companies will approve only a certain number of
	;;^DD(356.2,.13,21,5,0)
	;;=days of care for reimbursement.  This is the ending date of the number
	;;^DD(356.2,.13,21,6,0)
	;;=of days that they approved for reimbursement.
	;;^DD(356.2,.13,"DT")
	;;=2940127
	;;^DD(356.2,.14,0)
	;;=DIAGNOSIS AUTHORIZED^*P80'^ICD9(^0;14^S DIC("S")="I '$P(^(0),U,9)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.2,.14,12)
	;;=Only Active Diagnosis may be selected
	;;^DD(356.2,.14,12.1)
	;;=S DIC("S")="I '$P(^(0),U,9)"
	;;^DD(356.2,.14,21,0)
	;;=^^6^6^2930928^^
	;;^DD(356.2,.14,21,1,0)
	;;=If the insurance company approved the care for this patient for 
	;;^DD(356.2,.14,21,2,0)
	;;=reimbursement this is the diagnosis that they approved.
	;;^DD(356.2,.14,21,3,0)
	;;= 
	;;^DD(356.2,.14,21,4,0)
	;;=Typically when an insurance company approves care for reimbursement

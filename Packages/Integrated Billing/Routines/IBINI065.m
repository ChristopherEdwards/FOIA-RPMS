IBINI065	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.14,21,5,0)
	;;=they approve it for a specific diagnosis.  This is the diagnosis that
	;;^DD(356.2,.14,21,6,0)
	;;=they approved.
	;;^DD(356.2,.14,23,0)
	;;=^^2^2^2930928^
	;;^DD(356.2,.14,23,1,0)
	;;= 
	;;^DD(356.2,.14,23,2,0)
	;;= 
	;;^DD(356.2,.14,"DT")
	;;=2930928
	;;^DD(356.2,.15,0)
	;;=DATES OF DENIAL FROM^RDX^^0;15^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) K:'$$DFDT^IBTUTL4(DA,X) X
	;;^DD(356.2,.15,3)
	;;=
	;;^DD(356.2,.15,4)
	;;=D HELP^IBTUTL3(DA)
	;;^DD(356.2,.15,21,0)
	;;=^^4^4^2940127^^
	;;^DD(356.2,.15,21,1,0)
	;;=If the insurance company disapproved or denied pre-approving
	;;^DD(356.2,.15,21,2,0)
	;;=the care for this patient, this is the beginning date of care
	;;^DD(356.2,.15,21,3,0)
	;;=that they denied.  For some patients there may be both a 
	;;^DD(356.2,.15,21,4,0)
	;;=number of approved and denied days.
	;;^DD(356.2,.15,"DT")
	;;=2940127
	;;^DD(356.2,.16,0)
	;;=DATES OF DENIAL TO^RDX^^0;16^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) K:'$$DTDT^IBTUTL4(DA,X) X
	;;^DD(356.2,.16,1,0)
	;;=^.1
	;;^DD(356.2,.16,1,1,0)
	;;=^^TRIGGER^356.2^.24
	;;^DD(356.2,.16,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X=DIV S X=$P(^IBT(356.2,DA,0),U,16) X ^DD(356.2,.16,1,1,1.4)
	;;^DD(356.2,.16,1,1,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,24)=DIV,DIH=356.2,DIG=.24 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.16,1,1,2)
	;;=Q
	;;^DD(356.2,.16,1,1,"CREATE VALUE")
	;;=S X=$P(^IBT(356.2,DA,0),U,16)
	;;^DD(356.2,.16,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.2,.16,1,1,"FIELD")
	;;=#.24
	;;^DD(356.2,.16,3)
	;;=
	;;^DD(356.2,.16,4)
	;;=D HELP^IBTUTL3(DA)
	;;^DD(356.2,.16,21,0)
	;;=^^4^4^2930806^
	;;^DD(356.2,.16,21,1,0)
	;;=If the insurance company disapproved or denied pre-approving  
	;;^DD(356.2,.16,21,2,0)
	;;=the care for this patient, this is the ending date of care
	;;^DD(356.2,.16,21,3,0)
	;;=that they denied.  For some patients there may be both a 
	;;^DD(356.2,.16,21,4,0)
	;;=number of approved and denied days.
	;;^DD(356.2,.16,"DT")
	;;=2940127
	;;^DD(356.2,.17,0)
	;;=METHOD OF CONTACT^S^1:PHONE;2:MAIL;3:OVERNIGHT MAIL;4:PERSONAL;5:VOICE MAIL;6:OTHER;^0;17^Q
	;;^DD(356.2,.17,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.2,.17,21,1,0)
	;;=This is the method that you used to contact the person contacted
	;;^DD(356.2,.17,21,2,0)
	;;=in this entry.  Most contacts will be by phone but many others will
	;;^DD(356.2,.17,21,3,0)
	;;=be by mail.
	;;^DD(356.2,.17,"DT")
	;;=2930915
	;;^DD(356.2,.18,0)
	;;=PARENT REVIEW^*P356.2'^IBT(356.2,^0;18^S DIC("S")="N TYPE S TYPE=$P(^IBE(356.7,+$P(^(0),U,11),0),U,3) I TYPE=20!(TYPE=30)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.2,.18,1,0)
	;;=^.1
	;;^DD(356.2,.18,1,1,0)
	;;=356.2^AP
	;;^DD(356.2,.18,1,1,1)
	;;=S ^IBT(356.2,"AP",$E(X,1,30),DA)=""
	;;^DD(356.2,.18,1,1,2)
	;;=K ^IBT(356.2,"AP",$E(X,1,30),DA)
	;;^DD(356.2,.18,1,1,"DT")
	;;=2930811
	;;^DD(356.2,.18,12)
	;;=Only penalties and denials can be appealed.
	;;^DD(356.2,.18,12.1)
	;;=S DIC("S")="N TYPE S TYPE=$P(^IBE(356.7,+$P(^(0),U,11),0),U,3) I TYPE=20!(TYPE=30)"
	;;^DD(356.2,.18,21,0)
	;;=^^3^3^2940213^^^^
	;;^DD(356.2,.18,21,1,0)
	;;=This is the first contact in a series of contacts.  This field will
	;;^DD(356.2,.18,21,2,0)
	;;=generally be system generated.  When adding an appeal to a denied 
	;;^DD(356.2,.18,21,3,0)
	;;=claim, this will be the denial contact that is being appealed.
	;;^DD(356.2,.18,"DT")
	;;=2930907
	;;^DD(356.2,.19,0)
	;;=REVIEW STATUS^S^0:INACTIVE;1:ENTERED;2:PENDING;10:COMPLETE;^0;19^Q

IBINI01R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.4,.02,21,0)
	;;=^^1^1^2920317^^
	;;^DD(350.4,.02,21,1,0)
	;;=The ambulatory surgery associated with this entry.
	;;^DD(350.4,.02,"DT")
	;;=2910830
	;;^DD(350.4,.03,0)
	;;=RATE GROUP^R*P350.1'^IBE(350.1,^0;3^S DIC("S")="I $P(^(0),U,1)[""MEDICARE RATE""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.4,.03,3)
	;;=May enter "Rate N" as abbrevation for Opt Medicare Rate N.
	;;^DD(350.4,.03,5,1,0)
	;;=350.4^.04^1
	;;^DD(350.4,.03,12)
	;;=Only Medicare Rate Action Type allowed.
	;;^DD(350.4,.03,12.1)
	;;=S DIC("S")="I $P(^(0),U,1)[""MEDICARE RATE"""
	;;^DD(350.4,.03,21,0)
	;;=^^2^2^2920415^^^^
	;;^DD(350.4,.03,21,1,0)
	;;=This is the HCFA rate group assigned to this procedure beginning with this
	;;^DD(350.4,.03,21,2,0)
	;;=entry's effective date.
	;;^DD(350.4,.03,"DT")
	;;=2911202
	;;^DD(350.4,.04,0)
	;;=STATUS^RS^1:ACTIVE;0:INACTIVE;^0;4^Q
	;;^DD(350.4,.04,1,0)
	;;=^.1
	;;^DD(350.4,.04,1,1,0)
	;;=^^TRIGGER^350.4^.03
	;;^DD(350.4,.04,1,1,1)
	;;=X ^DD(350.4,.04,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^IBE(350.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(350.4,.04,1,1,1.4)
	;;^DD(350.4,.04,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$C(59)_$S($D(^DD(350.4,.04,0)):$P(^(0),U,3),1:"") S X=$P($P(Y(1),$C(59)_Y(0)_":",2),$C(59),1)="INACTIVE"
	;;^DD(350.4,.04,1,1,1.4)
	;;=S DIH=$S($D(^IBE(350.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=350.4,DIG=.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.4,.04,1,1,2)
	;;=X ^DD(350.4,.04,1,1,2.3) I X S X=DIV S Y(1)=$S($D(^IBE(350.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(350.4,.04,1,1,2.4)
	;;^DD(350.4,.04,1,1,2.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(2)=$C(59)_$S($D(^DD(350.4,.04,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^IBE(350.4,D0,0)):^(0),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,4)_":",2),$C(59),1)="INACTIVE"
	;;^DD(350.4,.04,1,1,2.4)
	;;=S DIH=$S($D(^IBE(350.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=350.4,DIG=.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.4,.04,1,1,"%D",0)
	;;=^^1^1^2920421^
	;;^DD(350.4,.04,1,1,"%D",1,0)
	;;=Removes the Rate Group from any procedure being inactivated.
	;;^DD(350.4,.04,1,1,"CREATE CONDITION")
	;;=STATUS="INACTIVE"
	;;^DD(350.4,.04,1,1,"CREATE VALUE")
	;;=@
	;;^DD(350.4,.04,1,1,"DELETE CONDITION")
	;;=STATUS="INACTIVE"
	;;^DD(350.4,.04,1,1,"DELETE VALUE")
	;;=@
	;;^DD(350.4,.04,1,1,"DT")
	;;=2920421
	;;^DD(350.4,.04,1,1,"FIELD")
	;;=RATE GROUP
	;;^DD(350.4,.04,3)
	;;=Enter the appropriate STATUS for this procedure on and after the EFFECTIVE DATE.
	;;^DD(350.4,.04,21,0)
	;;=^^1^1^2920415^^^^
	;;^DD(350.4,.04,21,1,0)
	;;=The STATUS for this procedure beginning with the EFFECTIVE DATE.
	;;^DD(350.4,.04,"DT")
	;;=2920421

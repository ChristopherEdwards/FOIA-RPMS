IBINI063	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.1,1,0)
	;;=^.1
	;;^DD(356.2,.1,1,1,0)
	;;=^^TRIGGER^356.2^.24
	;;^DD(356.2,.1,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.2,DA,0),U,10)=3 I X S X=DIV S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X="" X ^DD(356.2,.1,1,1,1.4)
	;;^DD(356.2,.1,1,1,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,24)=DIV,DIH=356.2,DIG=.24 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.1,1,1,2)
	;;=Q
	;;^DD(356.2,.1,1,1,"CREATE CONDITION")
	;;=I $P(^IBT(356.2,DA,0),U,10)=3
	;;^DD(356.2,.1,1,1,"CREATE VALUE")
	;;=@
	;;^DD(356.2,.1,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.2,.1,1,1,"DT")
	;;=2940207
	;;^DD(356.2,.1,1,1,"FIELD")
	;;=#.24
	;;^DD(356.2,.1,21,0)
	;;=^^3^3^2930809^^
	;;^DD(356.2,.1,21,1,0)
	;;=If this Insurance Action is an appeal, this is the status of the appeal.
	;;^DD(356.2,.1,21,2,0)
	;;=Appeals that are OPEN will continue to be on the list of pending work
	;;^DD(356.2,.1,21,3,0)
	;;=based on the next review date.
	;;^DD(356.2,.1,"DT")
	;;=2940207
	;;^DD(356.2,.11,0)
	;;=ACTION^*P356.7'^IBE(356.7,^0;11^S DIC("S")="N ACODE,CTYPE S ACODE=$P(^(0),U,3),CTYPE=$P(^IBT(356.2,DA,0),U,4) I $$SCREEN^IBTRC1(ACODE,CTYPE)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.2,.11,1,0)
	;;=^.1
	;;^DD(356.2,.11,1,1,0)
	;;=356.2^ACT
	;;^DD(356.2,.11,1,1,1)
	;;=S ^IBT(356.2,"ACT",$E(X,1,30),DA)=""
	;;^DD(356.2,.11,1,1,2)
	;;=K ^IBT(356.2,"ACT",$E(X,1,30),DA)
	;;^DD(356.2,.11,1,1,"%D",0)
	;;=^^1^1^2930908^^^
	;;^DD(356.2,.11,1,1,"%D",1,0)
	;;=Regular cross refence of actions
	;;^DD(356.2,.11,1,1,"DT")
	;;=2930811
	;;^DD(356.2,.11,1,2,0)
	;;=356.2^APACT1^MUMPS
	;;^DD(356.2,.11,1,2,1)
	;;=S:$P(^IBT(356.2,DA,0),U,5) ^IBT(356.2,"APACT",+$P(^(0),U,5),X,DA)=""
	;;^DD(356.2,.11,1,2,2)
	;;=K ^IBT(356.2,"APACT",+$P(^IBT(356.2,DA,0),U,5),X,DA)
	;;^DD(356.2,.11,1,2,"%D",0)
	;;=^^2^2^2930811^^^^
	;;^DD(356.2,.11,1,2,"%D",1,0)
	;;=Index of insurance contacts with actions by patient by action.
	;;^DD(356.2,.11,1,2,"%D",2,0)
	;;=Used primarily to find denials by patient.
	;;^DD(356.2,.11,1,2,"DT")
	;;=2930811
	;;^DD(356.2,.11,1,3,0)
	;;=356.2^AIACT1^MUMPS
	;;^DD(356.2,.11,1,3,1)
	;;=S:$P(^IBT(356.2,DA,0),U,8) ^IBT(356.2,"AIACT",+$P(^(0),U,8),X,DA)=""
	;;^DD(356.2,.11,1,3,2)
	;;=K ^IBT(356.2,"AIACT",+$P(^IBT(356.2,DA,0),U,8),X,DA)
	;;^DD(356.2,.11,1,3,"%D",0)
	;;=^^2^2^2930908^^^^
	;;^DD(356.2,.11,1,3,"%D",1,0)
	;;=Index of insurance contacts with actions by insurance co. by type of
	;;^DD(356.2,.11,1,3,"%D",2,0)
	;;=action.  Used primarily to find denials by insurance company.
	;;^DD(356.2,.11,1,3,"DT")
	;;=2930811
	;;^DD(356.2,.11,1,4,0)
	;;=^^TRIGGER^356.2^.19
	;;^DD(356.2,.11,1,4,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.2,DA,0),"^",19)=1 I X S X=DIV S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,19),X=X S DIU=X K Y S X=DIV S X=2 X ^DD(356.2,.11,1,4,1.4)
	;;^DD(356.2,.11,1,4,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,19)=DIV,DIH=356.2,DIG=.19 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.11,1,4,2)
	;;=Q
	;;^DD(356.2,.11,1,4,"%D",0)
	;;=^^2^2^2931005^
	;;^DD(356.2,.11,1,4,"%D",1,0)
	;;=Trigger Review Status from entered to Pending when an action is entered.
	;;^DD(356.2,.11,1,4,"%D",2,0)
	;;= 
	;;^DD(356.2,.11,1,4,"CREATE CONDITION")
	;;=I $P(^IBT(356.2,DA,0),"^",19)=1
	;;^DD(356.2,.11,1,4,"CREATE VALUE")
	;;=S X=2
	;;^DD(356.2,.11,1,4,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.2,.11,1,4,"DT")
	;;=2931005
	;;^DD(356.2,.11,1,4,"FIELD")
	;;=#.19
	;;^DD(356.2,.11,3)
	;;=Select the action taken by the insurance company on this call.

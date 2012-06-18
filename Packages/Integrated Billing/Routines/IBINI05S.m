IBINI05S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,.2,1,1,"%D",0)
	;;=^^2^2^2940213^^
	;;^DD(356.1,.2,1,1,"%D",1,0)
	;;=Cross reference of all non-completed reviews so it can be used as a tickler
	;;^DD(356.1,.2,1,1,"%D",2,0)
	;;=file.
	;;^DD(356.1,.2,1,1,"DT")
	;;=2930722
	;;^DD(356.1,.2,5,1,0)
	;;=356.1^.21^4
	;;^DD(356.1,.2,21,0)
	;;=^^7^7^2940213^^
	;;^DD(356.1,.2,21,1,0)
	;;=This is the date that this review should be reviewed next.  If the review
	;;^DD(356.1,.2,21,2,0)
	;;=status is entered then this field will contain the date it was entered.  If
	;;^DD(356.1,.2,21,3,0)
	;;=the review status is complete then the data in this field is automatically
	;;^DD(356.1,.2,21,4,0)
	;;=deleted.
	;;^DD(356.1,.2,21,5,0)
	;;= 
	;;^DD(356.1,.2,21,6,0)
	;;=This field is used to create your pending work lists.  Enter the date that
	;;^DD(356.1,.2,21,7,0)
	;;=you want to be reminded to follow-up on this review.
	;;^DD(356.1,.2,"DT")
	;;=2930722
	;;^DD(356.1,.21,0)
	;;=REVIEW STATUS^S^0:INACTIVE;1:ENTERED;2:PENDING;10:COMPLETE;^0;21^Q
	;;^DD(356.1,.21,1,0)
	;;=^.1
	;;^DD(356.1,.21,1,1,0)
	;;=356.1^AC
	;;^DD(356.1,.21,1,1,1)
	;;=S ^IBT(356.1,"AC",$E(X,1,30),DA)=""
	;;^DD(356.1,.21,1,1,2)
	;;=K ^IBT(356.1,"AC",$E(X,1,30),DA)
	;;^DD(356.1,.21,1,1,"DT")
	;;=2930714
	;;^DD(356.1,.21,1,2,0)
	;;=^^TRIGGER^356.1^1.05
	;;^DD(356.1,.21,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.1,D0,0),U,21)=10,$P($G(^(1)),U,5)="" I X S X=DIV S Y(1)=$S($D(^IBT(356.1,D0,1)):^(1),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y X ^DD(356.1,.21,1,2,1.1) X ^DD(356.1,.21,1,2,1.4)
	;;^DD(356.1,.21,1,2,1.1)
	;;=S X=DIV S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
	;;^DD(356.1,.21,1,2,1.4)
	;;=S DIH=$S($D(^IBT(356.1,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,5)=DIV,DIH=356.1,DIG=1.05 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.1,.21,1,2,2)
	;;=Q
	;;^DD(356.1,.21,1,2,"%D",0)
	;;=^^1^1^2930714^
	;;^DD(356.1,.21,1,2,"%D",1,0)
	;;=Trigger date completed when status changes to complete
	;;^DD(356.1,.21,1,2,"CREATE CONDITION")
	;;=I $P(^IBT(356.1,D0,0),U,21)=10,$P($G(^(1)),U,5)=""
	;;^DD(356.1,.21,1,2,"CREATE VALUE")
	;;=NOW
	;;^DD(356.1,.21,1,2,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.1,.21,1,2,"DT")
	;;=2930714
	;;^DD(356.1,.21,1,2,"FIELD")
	;;=#1.05
	;;^DD(356.1,.21,1,3,0)
	;;=^^TRIGGER^356.1^1.06
	;;^DD(356.1,.21,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.1,D0,0),U,21)=10,$P($G(^(1)),U,6)="" I X S X=DIV S Y(1)=$S($D(^IBT(356.1,D0,1)):^(1),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(356.1,.21,1,3,1.4)
	;;^DD(356.1,.21,1,3,1.4)
	;;=S DIH=$S($D(^IBT(356.1,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,6)=DIV,DIH=356.1,DIG=1.06 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.1,.21,1,3,2)
	;;=Q
	;;^DD(356.1,.21,1,3,"%D",0)
	;;=^^1^1^2930714^
	;;^DD(356.1,.21,1,3,"%D",1,0)
	;;=Trigger completed by when status changes to complete
	;;^DD(356.1,.21,1,3,"CREATE CONDITION")
	;;=I $P(^IBT(356.1,D0,0),U,21)=10,$P($G(^(1)),U,6)=""
	;;^DD(356.1,.21,1,3,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(356.1,.21,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.1,.21,1,3,"DT")
	;;=2930714
	;;^DD(356.1,.21,1,3,"FIELD")
	;;=#1.06
	;;^DD(356.1,.21,1,4,0)
	;;=^^TRIGGER^356.1^.2
	;;^DD(356.1,.21,1,4,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.1,DA,0),U,21)=10 I X S X=DIV S Y(1)=$S($D(^IBT(356.1,D0,0)):^(0),1:"") S X=$P(Y(1),U,20),X=X S DIU=X K Y S X="" X ^DD(356.1,.21,1,4,1.4)
	;;^DD(356.1,.21,1,4,1.4)
	;;=S DIH=$S($D(^IBT(356.1,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,20)=DIV,DIH=356.1,DIG=.2 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(356.1,.21,1,4,2)
	;;=Q

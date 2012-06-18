IBINI05T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.1,.21,1,4,"%D",0)
	;;=^^1^1^2940209^
	;;^DD(356.1,.21,1,4,"%D",1,0)
	;;=Deletes the Next Review Date whenever the status is set to completed.
	;;^DD(356.1,.21,1,4,"CREATE CONDITION")
	;;=I $P(^IBT(356.1,DA,0),U,21)=10
	;;^DD(356.1,.21,1,4,"CREATE VALUE")
	;;=@
	;;^DD(356.1,.21,1,4,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(356.1,.21,1,4,"DT")
	;;=2940209
	;;^DD(356.1,.21,1,4,"FIELD")
	;;=#.2
	;;^DD(356.1,.21,3)
	;;=Enter the status of this review.  Reviews that are not completed will continue to appear on your pending work lists.
	;;^DD(356.1,.21,21,0)
	;;=^^5^5^2940213^^
	;;^DD(356.1,.21,21,1,0)
	;;=This is the status of this review.  Reviews that are entered or pending
	;;^DD(356.1,.21,21,2,0)
	;;=should contain a next review date.  Once a review is completed, the next
	;;^DD(356.1,.21,21,3,0)
	;;=review date is automatically deleted.  If a review status is changed from
	;;^DD(356.1,.21,21,4,0)
	;;=complete to any other status then the next review date is automatically
	;;^DD(356.1,.21,21,5,0)
	;;=set to today, but may be edited.
	;;^DD(356.1,.21,"DT")
	;;=2940209
	;;^DD(356.1,.22,0)
	;;=TYPE OF REVIEW^R*P356.11'^IBE(356.11,^0;22^S DIC("S")="I $P(^(0),U,2)=15!($P(^(0),U,2)=30)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.22,1,0)
	;;=^.1
	;;^DD(356.1,.22,1,1,0)
	;;=356.1^AD
	;;^DD(356.1,.22,1,1,1)
	;;=S ^IBT(356.1,"AD",$E(X,1,30),DA)=""
	;;^DD(356.1,.22,1,1,2)
	;;=K ^IBT(356.1,"AD",$E(X,1,30),DA)
	;;^DD(356.1,.22,1,1,"DT")
	;;=2930719
	;;^DD(356.1,.22,1,2,0)
	;;=356.1^ATRTP^MUMPS
	;;^DD(356.1,.22,1,2,1)
	;;=S:$P(^IBT(356.1,DA,0),U,2) ^IBT(356.1,"ATRTP",$P(^(0),U,2),+$P($G(^IBE(356.11,X,0)),U,2),DA)=""
	;;^DD(356.1,.22,1,2,2)
	;;=K ^IBT(356.1,"ATRTP",+$P(^IBT(356.1,DA,0),U,2),+$P($G(^IBE(356.11,X,0)),U,2),DA)
	;;^DD(356.1,.22,1,2,"%D",0)
	;;=^^2^2^2930720^^^
	;;^DD(356.1,.22,1,2,"%D",1,0)
	;;=Cross reference of all reviews for a tracking entry by type of review
	;;^DD(356.1,.22,1,2,"%D",2,0)
	;;=code.
	;;^DD(356.1,.22,1,2,"DT")
	;;=2930720
	;;^DD(356.1,.22,12)
	;;=Only admission review types may be selected!
	;;^DD(356.1,.22,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=15!($P(^(0),U,2)=30)"
	;;^DD(356.1,.22,21,0)
	;;=^^1^1^2940127^^^^
	;;^DD(356.1,.22,21,1,0)
	;;=Enter whether or not this is an admission review or a continued stay review.
	;;^DD(356.1,.22,"DT")
	;;=2930901
	;;^DD(356.1,.23,0)
	;;=REVIEW METHODOLOGY^S^1:INTERQUAL;2:MILLIMAN & ROBERTSON;999:OTHER;^0;23^Q
	;;^DD(356.1,.23,21,0)
	;;=^^8^8^2930726^
	;;^DD(356.1,.23,21,1,0)
	;;=Enter the Review Methodology being used for this review.  Generally
	;;^DD(356.1,.23,21,2,0)
	;;=the INTERQUAL method is being used as the methodology for UR required
	;;^DD(356.1,.23,21,3,0)
	;;=review.  Insurance carriers may require other review methodologies.
	;;^DD(356.1,.23,21,4,0)
	;;= 
	;;^DD(356.1,.23,21,5,0)
	;;=Currently, if the type of review methodology is INTERQUAL then the
	;;^DD(356.1,.23,21,6,0)
	;;=categories for severity of illness and intensity of service will be
	;;^DD(356.1,.23,21,7,0)
	;;=prompted.  This data will be used for national roll-up purposes for
	;;^DD(356.1,.23,21,8,0)
	;;=UR.
	;;^DD(356.1,.23,"DT")
	;;=2940127
	;;^DD(356.1,.24,0)
	;;=REVIEW COPIED FROM^*P356.1'^IBT(356.1,^0;24^S DIC("S")="I $P(^(O),U,2)=$P(^IBT(356.1,DA,0),U,2)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.1,.24,12)
	;;=Must be for the same claims tracking id
	;;^DD(356.1,.24,12.1)
	;;=S DIC("S")="I $P(^(O),U,2)=$P(^IBT(356.1,DA,0),U,2)"
	;;^DD(356.1,.24,21,0)
	;;=^^2^2^2930904^
	;;^DD(356.1,.24,21,1,0)
	;;=If this review was automatically copied during the editing of a review

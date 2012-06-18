IBINI066	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.19,1,0)
	;;=^.1
	;;^DD(356.2,.19,1,1,0)
	;;=356.2^AE
	;;^DD(356.2,.19,1,1,1)
	;;=S ^IBT(356.2,"AE",$E(X,1,30),DA)=""
	;;^DD(356.2,.19,1,1,2)
	;;=K ^IBT(356.2,"AE",$E(X,1,30),DA)
	;;^DD(356.2,.19,1,1,"DT")
	;;=2940207
	;;^DD(356.2,.19,1,2,0)
	;;=^^TRIGGER^356.2^.24
	;;^DD(356.2,.19,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.2,DA,0),U,19)'=10 I X S X=DIV S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(356.2,.19,1,2,1.4)
	;;^DD(356.2,.19,1,2,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,24)=DIV,DIH=356.2,DIG=.24 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.19,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^IBT(356.2,DA,0),U,19)=10 I X S X=DIV S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X="" X ^DD(356.2,.19,1,2,2.4)
	;;^DD(356.2,.19,1,2,2.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,24)=DIV,DIH=356.2,DIG=.24 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,.19,1,2,"%D",0)
	;;=^^1^1^2940207^
	;;^DD(356.2,.19,1,2,"%D",1,0)
	;;=This trigger deletes the NEXT REVIEW DATE when completing a review.
	;;^DD(356.2,.19,1,2,"CREATE CONDITION")
	;;=I $P(^IBT(356.2,DA,0),U,19)'=10
	;;^DD(356.2,.19,1,2,"CREATE VALUE")
	;;=S X=DT
	;;^DD(356.2,.19,1,2,"DELETE CONDITION")
	;;=I $P(^IBT(356.2,DA,0),U,19)=10
	;;^DD(356.2,.19,1,2,"DELETE VALUE")
	;;=@
	;;^DD(356.2,.19,1,2,"DT")
	;;=2940207
	;;^DD(356.2,.19,1,2,"FIELD")
	;;=#.24
	;;^DD(356.2,.19,3)
	;;=
	;;^DD(356.2,.19,5,1,0)
	;;=356.2^.11^4
	;;^DD(356.2,.19,21,0)
	;;=^^2^2^2930907^^^
	;;^DD(356.2,.19,21,1,0)
	;;=Enter whether or not this entry is active or not.  Inactivating an
	;;^DD(356.2,.19,21,2,0)
	;;=entry has the same effect as deleting the entry.
	;;^DD(356.2,.19,"DT")
	;;=2940207
	;;^DD(356.2,.2,0)
	;;=CASE PENDING^S^1:UR/CLINICAL INFORMATION;2:PENDING MEDICAL REVIEW;3:OTHER;^0;20^Q
	;;^DD(356.2,.2,21,0)
	;;=^^4^4^2930806^
	;;^DD(356.2,.2,21,1,0)
	;;=If the action by the insurance company on this contact is pending, then
	;;^DD(356.2,.2,21,2,0)
	;;=this is what the case is pending for.  Generally cases are pending
	;;^DD(356.2,.2,21,3,0)
	;;=further UR/Clinical information from the site or Medical Review at
	;;^DD(356.2,.2,21,4,0)
	;;=the insurance company.
	;;^DD(356.2,.2,"DT")
	;;=2930610
	;;^DD(356.2,.21,0)
	;;=NO COVERAGE^S^1:PATIENT NOT ELIGIBLE;2:SERVICE NOT PROGRAM BENEFIT;3:COVERAGE CANCELED BEFORE TREATMENT;4:OTHER;^0;21^Q
	;;^DD(356.2,.21,21,0)
	;;=^^3^3^2930806^
	;;^DD(356.2,.21,21,1,0)
	;;=If the action by the insurance company on this contact was that
	;;^DD(356.2,.21,21,2,0)
	;;=the patient was not covered by this carrier for this care then
	;;^DD(356.2,.21,21,3,0)
	;;=this is the reason that they claim no coverge.
	;;^DD(356.2,.21,"DT")
	;;=2930610
	;;^DD(356.2,.22,0)
	;;=FOLLOW-UP WITH APPEAL^S^1:YES;0:NO;^0;22^Q
	;;^DD(356.2,.22,21,0)
	;;=^^3^3^2930806^
	;;^DD(356.2,.22,21,1,0)
	;;=If the action by the insurance company on this contact was a denial,
	;;^DD(356.2,.22,21,2,0)
	;;=then enter whether you wish to follow up with an appeal.  If you
	;;^DD(356.2,.22,21,3,0)
	;;=answer 'YES' then this will be included on your Pending Work.
	;;^DD(356.2,.22,"DT")
	;;=2930610
	;;^DD(356.2,.23,0)
	;;=TYPE OF APPEAL^S^1:CLINICAL;2:ADMINISTRATIVE;^0;23^Q
	;;^DD(356.2,.23,21,0)
	;;=^^2^2^2930806^
	;;^DD(356.2,.23,21,1,0)
	;;=If you are appealing the decision of an insurance company enter whether
	;;^DD(356.2,.23,21,2,0)
	;;=this is a clinical or administrative appeal.

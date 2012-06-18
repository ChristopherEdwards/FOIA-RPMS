IBINI06I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.399,.02,1,3,1.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X I $D(^(0)) S $P(^(0),U,11)=DIV,DIH=356,DIG=.11 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.399,.02,1,3,2)
	;;=X ^DD(356.399,.02,1,3,2.3) I X S X=DIV X ^DD(356.399,.02,1,3,89.2) S X=$S('$D(^DGCR(399,+$P(Y(101),U,11),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S DIU=X K Y S X="" X ^DD(356.399,.02,1,3,2.4)
	;;^DD(356.399,.02,1,3,2.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(356.399,.02,1,3,79.2) S X=$S('$D(^DGCR(399,+$P(Y(101),U,11),0)):"",1:$P(^(0),U,1))=$S('$D(^DGCR(399,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) S D0=I(0,0)
	;;^DD(356.399,.02,1,3,2.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X I $D(^(0)) S $P(^(0),U,11)=DIV,DIH=356,DIG=.11 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.399,.02,1,3,69.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),Y(1)=$S($D(^IBT(356.399,D0,0)):^(0),1:""),D0=$P(Y(1),U,1) S:'$D(^IBT(356,+D0,0)) D0=-1 S Y(101)=$S($D(^IBT(356,D0,0)):^(0),1:"")
	;;^DD(356.399,.02,1,3,79.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),Y(1)=$S($D(^IBT(356.399,D0,0)):^(0),1:""),D0=$P(Y(1),U,1) S:'$D(^IBT(356,+D0,0)) D0=-1 S Y(101)=$S($D(^IBT(356,D0,0)):^(0),1:"")
	;;^DD(356.399,.02,1,3,89.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),Y(1)=$S($D(^IBT(356.399,D0,0)):^(0),1:""),D0=$P(Y(1),U,1) S:'$D(^IBT(356,+D0,0)) D0=-1 S DIV(0)=D0 S Y(101)=$S($D(^IBT(356,D0,0)):^(0),1:"")
	;;^DD(356.399,.02,1,3,"%D",0)
	;;=^^3^3^2930826^
	;;^DD(356.399,.02,1,3,"%D",1,0)
	;;=Sets the events Initial Bill Number (356,.11) if that field does not
	;;^DD(356.399,.02,1,3,"%D",2,0)
	;;=already have a value.  Deletes the Initial Bill Number if that bill
	;;^DD(356.399,.02,1,3,"%D",3,0)
	;;=is being deleted from this entry.
	;;^DD(356.399,.02,1,3,"CREATE CONDITION")
	;;=CLAIM TRACKING ID:INITIAL BILL NUMBER=""
	;;^DD(356.399,.02,1,3,"CREATE VALUE")
	;;=S X=$P(^IBT(356.399,DA,0),U,2)
	;;^DD(356.399,.02,1,3,"DELETE CONDITION")
	;;=CLAIM TRACKING ID:INITIAL BILL NUMBER=BILL NUMBER
	;;^DD(356.399,.02,1,3,"DELETE VALUE")
	;;=@
	;;^DD(356.399,.02,1,3,"DT")
	;;=2930825
	;;^DD(356.399,.02,1,3,"FIELD")
	;;=CLAIM TRACKING ID:INITIAL BILL NUMBER
	;;^DD(356.399,.02,3)
	;;=The bill number associated with this Claims Tracking ID.
	;;^DD(356.399,.02,21,0)
	;;=^^1^1^2931128^^^
	;;^DD(356.399,.02,21,1,0)
	;;=This is the Bill associated with this Claims Tracking Entry.
	;;^DD(356.399,.02,"DT")
	;;=2931029

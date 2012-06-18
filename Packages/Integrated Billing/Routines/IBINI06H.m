IBINI06H	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.399,0,"GL")
	;;=^IBT(356.399,
	;;^DIC("B","CLAIMS TRACKING/BILL",356.399)
	;;=
	;;^DIC(356.399,"%D",0)
	;;=^^8^8^2940214^^
	;;^DIC(356.399,"%D",1,0)
	;;=This file serves as a bridge between Claims Tracking and the Bill Claims 
	;;^DIC(356.399,"%D",2,0)
	;;=file.  An entry is created automatically by the billing module to link
	;;^DIC(356.399,"%D",3,0)
	;;=the events being billed to the claims tracking entry.  It serves as a
	;;^DIC(356.399,"%D",4,0)
	;;=cross-reference in a many to many relationship for the entries in these
	;;^DIC(356.399,"%D",5,0)
	;;=two files.  Entries should not normally be added or edited manualy in 
	;;^DIC(356.399,"%D",6,0)
	;;=this file.  It should be maintained by the Billing Module.
	;;^DIC(356.399,"%D",7,0)
	;;= 
	;;^DIC(356.399,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.399,0)
	;;=FIELD^^.02^2
	;;^DD(356.399,0,"DDA")
	;;=N
	;;^DD(356.399,0,"DT")
	;;=2930726
	;;^DD(356.399,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGCR(399,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(399,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356.399,0,"IX","ACB",356.399,.02)
	;;=
	;;^DD(356.399,0,"IX","ACB1",356.399,.01)
	;;=
	;;^DD(356.399,0,"IX","B",356.399,.01)
	;;=
	;;^DD(356.399,0,"IX","C",356.399,.02)
	;;=
	;;^DD(356.399,0,"NM","CLAIMS TRACKING/BILL")
	;;=
	;;^DD(356.399,.01,0)
	;;=CLAIM TRACKING ID^RP356'^IBT(356,^0;1^Q
	;;^DD(356.399,.01,1,0)
	;;=^.1
	;;^DD(356.399,.01,1,1,0)
	;;=356.399^B
	;;^DD(356.399,.01,1,1,1)
	;;=S ^IBT(356.399,"B",$E(X,1,30),DA)=""
	;;^DD(356.399,.01,1,1,2)
	;;=K ^IBT(356.399,"B",$E(X,1,30),DA)
	;;^DD(356.399,.01,1,2,0)
	;;=356.399^ACB1^MUMPS
	;;^DD(356.399,.01,1,2,1)
	;;=S:$P(^IBT(356.399,DA,0),U,2) ^IBT(356.399,"ACB",X,$P(^(0),U,2),DA)=""
	;;^DD(356.399,.01,1,2,2)
	;;=K:$P(^IBT(356.399,DA,0),U,2) ^IBT(356.399,"ACB",X,$P(^(0),U,2),DA)
	;;^DD(356.399,.01,1,2,"%D",0)
	;;=^^2^2^2940213^
	;;^DD(356.399,.01,1,2,"%D",1,0)
	;;=Cross reference of bills and claims tracking entries.  Used to find
	;;^DD(356.399,.01,1,2,"%D",2,0)
	;;=all bills associated with a claims tracking entry.
	;;^DD(356.399,.01,1,2,"DT")
	;;=2930802
	;;^DD(356.399,.01,3)
	;;=The Claims Tracking ID to cross-reference with Bill Numbers.
	;;^DD(356.399,.01,21,0)
	;;=^^1^1^2931128^^^^
	;;^DD(356.399,.01,21,1,0)
	;;=This is the Claims Tracking entry that is associated with this bill.
	;;^DD(356.399,.01,"DT")
	;;=2930802
	;;^DD(356.399,.02,0)
	;;=BILL NUMBER^RP399'^DGCR(399,^0;2^Q
	;;^DD(356.399,.02,1,0)
	;;=^.1
	;;^DD(356.399,.02,1,1,0)
	;;=356.399^ACB^MUMPS
	;;^DD(356.399,.02,1,1,1)
	;;=S:$P(^IBT(356.399,DA,0),U,1) ^IBT(356.399,"ACB",+^(0),X,DA)=""
	;;^DD(356.399,.02,1,1,2)
	;;=K:$P(^IBT(356.399,DA,0),U,1) ^IBT(356.399,"ACB",+^(0),X,DA)
	;;^DD(356.399,.02,1,1,"%D",0)
	;;=^^1^1^2930802^
	;;^DD(356.399,.02,1,1,"%D",1,0)
	;;=Cross-reference of claims events and bills.
	;;^DD(356.399,.02,1,1,"DT")
	;;=2930802
	;;^DD(356.399,.02,1,2,0)
	;;=356.399^C
	;;^DD(356.399,.02,1,2,1)
	;;=S ^IBT(356.399,"C",$E(X,1,30),DA)=""
	;;^DD(356.399,.02,1,2,2)
	;;=K ^IBT(356.399,"C",$E(X,1,30),DA)
	;;^DD(356.399,.02,1,2,"DT")
	;;=2931029
	;;^DD(356.399,.02,1,3,0)
	;;=^^TRIGGER^356^.11
	;;^DD(356.399,.02,1,3,1)
	;;=X ^DD(356.399,.02,1,3,1.3) I X S X=DIV X ^DD(356.399,.02,1,3,89.2) S X=$S('$D(^DGCR(399,+$P(Y(101),U,11),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S DIU=X K Y X ^DD(356.399,.02,1,3,1.1) X ^DD(356.399,.02,1,3,1.4)
	;;^DD(356.399,.02,1,3,1.1)
	;;=S X=DIV S X=$P(^IBT(356.399,DA,0),U,2)
	;;^DD(356.399,.02,1,3,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(356.399,.02,1,3,69.2) S X=$S('$D(^DGCR(399,+$P(Y(101),U,11),0)):"",1:$P(^(0),U,1))="" S D0=I(0,0)

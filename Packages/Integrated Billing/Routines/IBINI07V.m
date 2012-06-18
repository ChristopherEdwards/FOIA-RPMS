IBINI07V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.4,0,"GL")
	;;=^IBE(357.4,
	;;^DIC("B","SELECTION GROUP",357.4)
	;;=
	;;^DIC(357.4,"%D",0)
	;;=^^3^3^2931214^^
	;;^DIC(357.4,"%D",1,0)
	;;= 
	;;^DIC(357.4,"%D",2,0)
	;;=A Selection Group is a set of items on a list and the header that those
	;;^DIC(357.4,"%D",3,0)
	;;=items should appear under.
	;;^DD(357.4,0)
	;;=FIELD^^.03^3
	;;^DD(357.4,0,"DDA")
	;;=N
	;;^DD(357.4,0,"DIK")
	;;=IBXF4
	;;^DD(357.4,0,"DT")
	;;=2930604
	;;^DD(357.4,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(357.4,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(357.2,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(357.2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(357.4,0,"IX","APO",357.4,.02)
	;;=
	;;^DD(357.4,0,"IX","APO1",357.4,.03)
	;;=
	;;^DD(357.4,0,"IX","B",357.4,.01)
	;;=
	;;^DD(357.4,0,"IX","D",357.4,.03)
	;;=
	;;^DD(357.4,0,"NM","SELECTION GROUP")
	;;=
	;;^DD(357.4,0,"PT",357.3,.04)
	;;=
	;;^DD(357.4,.01,0)
	;;=HEADER^RF^^0;1^K:$L(X)>40!($L(X)<1) X
	;;^DD(357.4,.01,1,0)
	;;=^.1
	;;^DD(357.4,.01,1,1,0)
	;;=357.4^B
	;;^DD(357.4,.01,1,1,1)
	;;=S ^IBE(357.4,"B",$E(X,1,30),DA)=""
	;;^DD(357.4,.01,1,1,2)
	;;=K ^IBE(357.4,"B",$E(X,1,30),DA)
	;;^DD(357.4,.01,3)
	;;=What text do you want to appear at the top of this group?
	;;^DD(357.4,.01,21,0)
	;;=^^2^2^2930604^^^^
	;;^DD(357.4,.01,21,1,0)
	;;= 
	;;^DD(357.4,.01,21,2,0)
	;;=The name given to a group of selections appearing on a selection list.
	;;^DD(357.4,.01,"DEL",1,0)
	;;=I '$G(IBLISTPR) W "...Selection Groups can only be deleted through the Encounter Form Utilities!"
	;;^DD(357.4,.01,"DT")
	;;=2930604
	;;^DD(357.4,.02,0)
	;;=PRINT ORDER^RNJ5,2^^0;2^K:+X'=X!(X>99.99)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(357.4,.02,1,0)
	;;=^.1
	;;^DD(357.4,.02,1,1,0)
	;;=357.4^APO^MUMPS
	;;^DD(357.4,.02,1,1,1)
	;;=I $P(^IBE(357.4,DA,0),U,3) S ^IBE(357.4,"APO",$P(^(0),U,3),X,DA)=""
	;;^DD(357.4,.02,1,1,2)
	;;=I $P(^IBE(357.4,DA,0),U,3) K ^IBE(357.4,"APO",$P(^(0),U,3),X,DA)
	;;^DD(357.4,.02,1,1,"%D",0)
	;;=^^5^5^2940224^
	;;^DD(357.4,.02,1,1,"%D",1,0)
	;;= 
	;;^DD(357.4,.02,1,1,"%D",2,0)
	;;=Allows all groups in a selection list to be found in the order that they
	;;^DD(357.4,.02,1,1,"%D",3,0)
	;;=should appear. The subscripts are ^IBE(357.4,"APO",<selection list
	;;^DD(357.4,.02,1,1,"%D",4,0)
	;;=ien>,<print order for group>,<group ien>). If this field is re-indexed
	;;^DD(357.4,.02,1,1,"%D",5,0)
	;;=then the APO1 index on the .03 field need not be re-indexed.
	;;^DD(357.4,.02,1,1,"DT")
	;;=2921222
	;;^DD(357.4,.02,3)
	;;=Type a Number between 0 and 99.99, 2 Decimal Digits
	;;^DD(357.4,.02,21,0)
	;;=^^5^5^2921222^^^^
	;;^DD(357.4,.02,21,1,0)
	;;= 
	;;^DD(357.4,.02,21,2,0)
	;;=This will define the order that a group of selections will appear in as
	;;^DD(357.4,.02,21,3,0)
	;;=compared to the other groups of selections.
	;;^DD(357.4,.02,21,4,0)
	;;=A group header "BLANK" will be created by default with order number 0.
	;;^DD(357.4,.02,21,5,0)
	;;=This header will not print to the form.
	;;^DD(357.4,.02,"DT")
	;;=2921222
	;;^DD(357.4,.03,0)
	;;=SELECTION LIST^RP357.2'^IBE(357.2,^0;3^Q
	;;^DD(357.4,.03,1,0)
	;;=^.1
	;;^DD(357.4,.03,1,1,0)
	;;=357.4^D
	;;^DD(357.4,.03,1,1,1)
	;;=S ^IBE(357.4,"D",$E(X,1,30),DA)=""
	;;^DD(357.4,.03,1,1,2)
	;;=K ^IBE(357.4,"D",$E(X,1,30),DA)
	;;^DD(357.4,.03,1,1,"%D",0)
	;;=^^1^1^2921218^
	;;^DD(357.4,.03,1,1,"%D",1,0)
	;;=Used to find all the groups belonging to a selection list.
	;;^DD(357.4,.03,1,1,"DT")
	;;=2921218
	;;^DD(357.4,.03,1,2,0)
	;;=357.4^APO1^MUMPS
	;;^DD(357.4,.03,1,2,1)
	;;=I $P(^IBE(357.4,DA,0),U,2)]"" S ^IBE(357.4,"APO",X,$P(^(0),U,2),DA)=""

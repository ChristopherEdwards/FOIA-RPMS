IBINI093	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.4,0,"GL")
	;;=^IBE(358.4,
	;;^DIC("B","IMP/EXP SELECTION GROUP",358.4)
	;;=
	;;^DIC(358.4,"%D",0)
	;;=^^4^4^2940217^
	;;^DIC(358.4,"%D",1,0)
	;;= 
	;;^DIC(358.4,"%D",2,0)
	;;=This file is nearly identical to file #357.4. It is used by the
	;;^DIC(358.4,"%D",3,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.4,"%D",4,0)
	;;=that is being imported or exported.
	;;^DD(358.4,0)
	;;=FIELD^^.03^3
	;;^DD(358.4,0,"DDA")
	;;=N
	;;^DD(358.4,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(358.4,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(358.2,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(358.2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(358.4,0,"IX","APO",358.4,.02)
	;;=
	;;^DD(358.4,0,"IX","APO1",358.4,.03)
	;;=
	;;^DD(358.4,0,"IX","B",358.4,.01)
	;;=
	;;^DD(358.4,0,"IX","D",358.4,.03)
	;;=
	;;^DD(358.4,0,"NM","IMP/EXP SELECTION GROUP")
	;;=
	;;^DD(358.4,0,"PT",358.3,.04)
	;;=
	;;^DD(358.4,.01,0)
	;;=HEADER^RF^^0;1^K:$L(X)>40!($L(X)<1) X
	;;^DD(358.4,.01,1,0)
	;;=^.1
	;;^DD(358.4,.01,1,1,0)
	;;=358.4^B
	;;^DD(358.4,.01,1,1,1)
	;;=S ^IBE(358.4,"B",$E(X,1,30),DA)=""
	;;^DD(358.4,.01,1,1,2)
	;;=K ^IBE(358.4,"B",$E(X,1,30),DA)
	;;^DD(358.4,.01,3)
	;;=What text do you want to appear at the top of this group?
	;;^DD(358.4,.01,21,0)
	;;=^^2^2^2930604^^^^
	;;^DD(358.4,.01,21,1,0)
	;;= 
	;;^DD(358.4,.01,21,2,0)
	;;=The name given to a group of selections appearing on a selection list.
	;;^DD(358.4,.01,"DEL",1,0)
	;;=I '$G(IBLISTPR) W "...Selection Groups can only be deleted through the Encounter Form Utilities!"
	;;^DD(358.4,.01,"DT")
	;;=2930604
	;;^DD(358.4,.02,0)
	;;=PRINT ORDER^RNJ5,2^^0;2^K:+X'=X!(X>99.99)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(358.4,.02,1,0)
	;;=^.1
	;;^DD(358.4,.02,1,1,0)
	;;=358.4^APO^MUMPS
	;;^DD(358.4,.02,1,1,1)
	;;=I $P(^IBE(358.4,DA,0),U,3) S ^IBE(358.4,"APO",$P(^(0),U,3),X,DA)=""
	;;^DD(358.4,.02,1,1,2)
	;;=I $P(^IBE(358.4,DA,0),U,3) K ^IBE(358.4,"APO",$P(^(0),U,3),X,DA)
	;;^DD(358.4,.02,1,1,"DT")
	;;=2921222
	;;^DD(358.4,.02,3)
	;;=Type a Number between 0 and 99.99, 2 Decimal Digits
	;;^DD(358.4,.02,21,0)
	;;=^^5^5^2921222^^^^
	;;^DD(358.4,.02,21,1,0)
	;;= 
	;;^DD(358.4,.02,21,2,0)
	;;=This will define the order that a group of selections will appear in as
	;;^DD(358.4,.02,21,3,0)
	;;=compared to the other groups of selections.
	;;^DD(358.4,.02,21,4,0)
	;;=A group header "BLANK" will be created by default with order number 0.
	;;^DD(358.4,.02,"DT")
	;;=2921222
	;;^DD(358.4,.03,0)
	;;=SELECTION LIST^RP358.2'^IBE(358.2,^0;3^Q
	;;^DD(358.4,.03,1,0)
	;;=^.1
	;;^DD(358.4,.03,1,1,0)
	;;=358.4^D
	;;^DD(358.4,.03,1,1,1)
	;;=S ^IBE(358.4,"D",$E(X,1,30),DA)=""
	;;^DD(358.4,.03,1,1,2)
	;;=K ^IBE(358.4,"D",$E(X,1,30),DA)
	;;^DD(358.4,.03,1,1,"%D",0)
	;;=^^1^1^2921218^
	;;^DD(358.4,.03,1,1,"%D",1,0)
	;;=Used to find all the groups belonging to a selection list.
	;;^DD(358.4,.03,1,1,"DT")
	;;=2921218
	;;^DD(358.4,.03,1,2,0)
	;;=358.4^APO1^MUMPS
	;;^DD(358.4,.03,1,2,1)
	;;=I $P(^IBE(358.4,DA,0),U,2)]"" S ^IBE(358.4,"APO",X,$P(^(0),U,2),DA)=""
	;;^DD(358.4,.03,1,2,2)
	;;=I $P(^IBE(358.4,DA,0),U,2)]"" K ^IBE(358.4,"APO",X,$P(^(0),U,2),DA)
	;;^DD(358.4,.03,1,2,"DT")
	;;=2921222
	;;^DD(358.4,.03,3)
	;;=This identifies the selection list that contains this group.
	;;^DD(358.4,.03,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.4,.03,21,1,0)
	;;= 
	;;^DD(358.4,.03,21,2,0)
	;;=The Selection List this group belongs to.
	;;^DD(358.4,.03,"DT")
	;;=2921222

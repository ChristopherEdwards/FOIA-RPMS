IBINI091	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.3,0,"GL")
	;;=^IBE(358.3,
	;;^DIC("B","IMP/EXP SELECTION",358.3)
	;;=
	;;^DIC(358.3,"%D",0)
	;;=^^4^4^2940217^
	;;^DIC(358.3,"%D",1,0)
	;;= 
	;;^DIC(358.3,"%D",2,0)
	;;=This file is nearly identical to file #357.3. It is used by the
	;;^DIC(358.3,"%D",3,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.3,"%D",4,0)
	;;=that is being imported or exported.
	;;^DD(358.3,0)
	;;=FIELD^^1^5
	;;^DD(358.3,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(358.2,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(358.2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(358.3,0,"ID",.04)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(358.4,+$P(^(0),U,4),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(358.4,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(358.3,0,"IX","APO",358.3,.03)
	;;=
	;;^DD(358.3,0,"IX","APO1",358.3,.04)
	;;=
	;;^DD(358.3,0,"IX","APO2",358.3,.05)
	;;=
	;;^DD(358.3,0,"IX","B",358.3,.01)
	;;=
	;;^DD(358.3,0,"IX","C",358.3,.03)
	;;=
	;;^DD(358.3,0,"IX","D",358.3,.04)
	;;=
	;;^DD(358.3,0,"NM","IMP/EXP SELECTION")
	;;=
	;;^DD(358.3,.01,0)
	;;=SELECTION ID^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358.3,.01,1,0)
	;;=^.1
	;;^DD(358.3,.01,1,1,0)
	;;=358.3^B
	;;^DD(358.3,.01,1,1,1)
	;;=S ^IBE(358.3,"B",$E(X,1,30),DA)=""
	;;^DD(358.3,.01,1,1,2)
	;;=K ^IBE(358.3,"B",$E(X,1,30),DA)
	;;^DD(358.3,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.3,.01,21,0)
	;;=^^2^2^2930309^
	;;^DD(358.3,.01,21,1,0)
	;;= 
	;;^DD(358.3,.01,21,2,0)
	;;=The ID passed by the package.
	;;^DD(358.3,.01,"DT")
	;;=2921119
	;;^DD(358.3,.03,0)
	;;=SELECTION LIST^RP358.2'^IBE(358.2,^0;3^Q
	;;^DD(358.3,.03,1,0)
	;;=^.1
	;;^DD(358.3,.03,1,1,0)
	;;=358.3^C
	;;^DD(358.3,.03,1,1,1)
	;;=S ^IBE(358.3,"C",$E(X,1,30),DA)=""
	;;^DD(358.3,.03,1,1,2)
	;;=K ^IBE(358.3,"C",$E(X,1,30),DA)
	;;^DD(358.3,.03,1,1,"DT")
	;;=2921127
	;;^DD(358.3,.03,1,2,0)
	;;=358.3^APO^MUMPS
	;;^DD(358.3,.03,1,2,1)
	;;=I $P(^IBE(358.3,DA,0),U,5)]"",$P(^(0),U,4) S ^IBE(358.3,"APO",X,$P(^(0),U,4),$P(^(0),U,5),DA)=""
	;;^DD(358.3,.03,1,2,2)
	;;=I $P(^IBE(358.3,DA,0),U,5)]"",$P(^(0),U,4) K ^IBE(358.3,"APO",X,$P(^(0),U,4),$P(^(0),U,5),DA)
	;;^DD(358.3,.03,1,2,"DT")
	;;=2921222
	;;^DD(358.3,.03,21,0)
	;;=^^2^2^2921215^
	;;^DD(358.3,.03,21,1,0)
	;;= 
	;;^DD(358.3,.03,21,2,0)
	;;=Identifies the selection list that this selection belongs on.
	;;^DD(358.3,.03,"DT")
	;;=2921222
	;;^DD(358.3,.04,0)
	;;=SELECTION GROUP^RP358.4^IBE(358.4,^0;4^Q
	;;^DD(358.3,.04,1,0)
	;;=^.1
	;;^DD(358.3,.04,1,1,0)
	;;=358.3^D
	;;^DD(358.3,.04,1,1,1)
	;;=S ^IBE(358.3,"D",$E(X,1,30),DA)=""
	;;^DD(358.3,.04,1,1,2)
	;;=K ^IBE(358.3,"D",$E(X,1,30),DA)
	;;^DD(358.3,.04,1,1,"DT")
	;;=2921221
	;;^DD(358.3,.04,1,2,0)
	;;=358.3^APO1^MUMPS
	;;^DD(358.3,.04,1,2,1)
	;;=I $P(^IBE(358.3,DA,0),U,5)]"",$P(^(0),U,3) S ^IBE(358.3,"APO",$P(^(0),U,3),X,$P(^(0),U,5),DA)=""
	;;^DD(358.3,.04,1,2,2)
	;;=I $P(^IBE(358.3,DA,0),U,5)]"",$P(^(0),U,3) K ^IBE(358.3,"APO",$P(^(0),U,3),X,$P(^(0),U,5),DA)
	;;^DD(358.3,.04,1,2,"DT")
	;;=2921222
	;;^DD(358.3,.04,3)
	;;=Entries on a list are grouped under group headers - under which header should this entry appear?
	;;^DD(358.3,.04,21,0)
	;;=^^3^3^2930607^
	;;^DD(358.3,.04,21,1,0)
	;;= 
	;;^DD(358.3,.04,21,2,0)
	;;=The SELECTION GROUP that the selection belongs to.The selection will
	;;^DD(358.3,.04,21,3,0)
	;;=appear under the group header on the form.
	;;^DD(358.3,.04,"DT")
	;;=2921222
	;;^DD(358.3,.05,0)
	;;=PRINT ORDER WITHIN GROUP^RNJ6,2^^0;5^K:+X'=X!(X>999.99)!(X<0)!(X?.E1"."3N.N) X

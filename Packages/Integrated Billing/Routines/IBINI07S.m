IBINI07S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.3,0,"GL")
	;;=^IBE(357.3,
	;;^DIC("B","SELECTION",357.3)
	;;=
	;;^DIC(357.3,"%D",0)
	;;=^^4^4^2931214^^^
	;;^DIC(357.3,"%D",1,0)
	;;= 
	;;^DIC(357.3,"%D",2,0)
	;;=Contains the items appearing on the SELECTION LISTS. A selection can be
	;;^DIC(357.3,"%D",3,0)
	;;=composed of several fields, hence can occupy several subcolumns. Only the
	;;^DIC(357.3,"%D",4,0)
	;;=text is stored here, not the MARKING SYMBOLS.
	;;^DD(357.3,0)
	;;=FIELD^^1^6
	;;^DD(357.3,0,"DIK")
	;;=IBXF3
	;;^DD(357.3,0,"DT")
	;;=2931020
	;;^DD(357.3,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(357.2,+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(357.2,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(357.3,0,"ID",.04)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(357.4,+$P(^(0),U,4),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(357.4,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(357.3,0,"IX","APO",357.3,.03)
	;;=
	;;^DD(357.3,0,"IX","APO1",357.3,.04)
	;;=
	;;^DD(357.3,0,"IX","APO2",357.3,.05)
	;;=
	;;^DD(357.3,0,"IX","B",357.3,.01)
	;;=
	;;^DD(357.3,0,"IX","C",357.3,.03)
	;;=
	;;^DD(357.3,0,"IX","D",357.3,.04)
	;;=
	;;^DD(357.3,0,"NM","SELECTION")
	;;=
	;;^DD(357.3,.01,0)
	;;=SELECTION ID^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(357.3,.01,1,0)
	;;=^.1
	;;^DD(357.3,.01,1,1,0)
	;;=357.3^B
	;;^DD(357.3,.01,1,1,1)
	;;=S ^IBE(357.3,"B",$E(X,1,30),DA)=""
	;;^DD(357.3,.01,1,1,2)
	;;=K ^IBE(357.3,"B",$E(X,1,30),DA)
	;;^DD(357.3,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(357.3,.01,21,0)
	;;=^^2^2^2930309^
	;;^DD(357.3,.01,21,1,0)
	;;= 
	;;^DD(357.3,.01,21,2,0)
	;;=The ID passed by the package.
	;;^DD(357.3,.01,"DT")
	;;=2921119
	;;^DD(357.3,.02,0)
	;;=PLACE HOLDER ONLY^S^0:NO;1:YES;^0;2^Q
	;;^DD(357.3,.02,3)
	;;=Enter YES if this is a real entry on the list, NO if it is a place holder, used to add some blank space to the list.
	;;^DD(357.3,.02,"DT")
	;;=2931020
	;;^DD(357.3,.03,0)
	;;=SELECTION LIST^RP357.2'^IBE(357.2,^0;3^Q
	;;^DD(357.3,.03,1,0)
	;;=^.1
	;;^DD(357.3,.03,1,1,0)
	;;=357.3^C
	;;^DD(357.3,.03,1,1,1)
	;;=S ^IBE(357.3,"C",$E(X,1,30),DA)=""
	;;^DD(357.3,.03,1,1,2)
	;;=K ^IBE(357.3,"C",$E(X,1,30),DA)
	;;^DD(357.3,.03,1,1,"DT")
	;;=2921127
	;;^DD(357.3,.03,1,2,0)
	;;=357.3^APO^MUMPS
	;;^DD(357.3,.03,1,2,1)
	;;=I $P(^IBE(357.3,DA,0),U,5)]"",$P(^(0),U,4) S ^IBE(357.3,"APO",X,$P(^(0),U,4),$P(^(0),U,5),DA)=""
	;;^DD(357.3,.03,1,2,2)
	;;=I $P(^IBE(357.3,DA,0),U,5)]"",$P(^(0),U,4) K ^IBE(357.3,"APO",X,$P(^(0),U,4),$P(^(0),U,5),DA)
	;;^DD(357.3,.03,1,2,"%D",0)
	;;=^^7^7^2940224^
	;;^DD(357.3,.03,1,2,"%D",1,0)
	;;= 
	;;^DD(357.3,.03,1,2,"%D",2,0)
	;;=Allows all selections for a particular group in a selection list to be
	;;^DD(357.3,.03,1,2,"%D",3,0)
	;;=found in the order that they should appear. The subscripts are
	;;^DD(357.3,.03,1,2,"%D",4,0)
	;;=^IBE(357.3,"APO",<selection list ien>,<group ien>,<print order within
	;;^DD(357.3,.03,1,2,"%D",5,0)
	;;=group>,<selection ien>). If this field is re-indexed then the APO1 index
	;;^DD(357.3,.03,1,2,"%D",6,0)
	;;=on the .04 field and the APO2 index on the .05 field need not be
	;;^DD(357.3,.03,1,2,"%D",7,0)
	;;=re-indexed.
	;;^DD(357.3,.03,1,2,"DT")
	;;=2921222
	;;^DD(357.3,.03,21,0)
	;;=^^2^2^2921215^
	;;^DD(357.3,.03,21,1,0)
	;;= 
	;;^DD(357.3,.03,21,2,0)
	;;=Identifies the selection list that this selection belongs on.
	;;^DD(357.3,.03,"DT")
	;;=2921222
	;;^DD(357.3,.04,0)
	;;=SELECTION GROUP^RP357.4^IBE(357.4,^0;4^Q
	;;^DD(357.3,.04,1,0)
	;;=^.1
	;;^DD(357.3,.04,1,1,0)
	;;=357.3^D
	;;^DD(357.3,.04,1,1,1)
	;;=S ^IBE(357.3,"D",$E(X,1,30),DA)=""

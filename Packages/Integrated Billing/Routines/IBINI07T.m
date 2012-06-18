IBINI07T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.3,.04,1,1,2)
	;;=K ^IBE(357.3,"D",$E(X,1,30),DA)
	;;^DD(357.3,.04,1,1,"DT")
	;;=2921221
	;;^DD(357.3,.04,1,2,0)
	;;=357.3^APO1^MUMPS
	;;^DD(357.3,.04,1,2,1)
	;;=I $P(^IBE(357.3,DA,0),U,5)]"",$P(^(0),U,3) S ^IBE(357.3,"APO",$P(^(0),U,3),X,$P(^(0),U,5),DA)=""
	;;^DD(357.3,.04,1,2,2)
	;;=I $P(^IBE(357.3,DA,0),U,5)]"",$P(^(0),U,3) K ^IBE(357.3,"APO",$P(^(0),U,3),X,$P(^(0),U,5),DA)
	;;^DD(357.3,.04,1,2,"%D",0)
	;;=^^7^7^2940224^
	;;^DD(357.3,.04,1,2,"%D",1,0)
	;;= 
	;;^DD(357.3,.04,1,2,"%D",2,0)
	;;=Allows all selections for a particular group in a selection list to be
	;;^DD(357.3,.04,1,2,"%D",3,0)
	;;=found in the order that they should appear. The subscripts are
	;;^DD(357.3,.04,1,2,"%D",4,0)
	;;=^IBE(357.3,"APO",<selection list ien>,<group ien>,<print order within
	;;^DD(357.3,.04,1,2,"%D",5,0)
	;;=group>,<selection ien>). If this field is re-indexed then the APO index
	;;^DD(357.3,.04,1,2,"%D",6,0)
	;;=on the .03 field and the APO2 index on the .05 field need not be
	;;^DD(357.3,.04,1,2,"%D",7,0)
	;;=re-indexed.
	;;^DD(357.3,.04,1,2,"DT")
	;;=2921222
	;;^DD(357.3,.04,3)
	;;=Entries on a list are grouped under group headers - under which header should this entry appear?
	;;^DD(357.3,.04,21,0)
	;;=^^3^3^2930607^
	;;^DD(357.3,.04,21,1,0)
	;;= 
	;;^DD(357.3,.04,21,2,0)
	;;=The SELECTION GROUP that the selection belongs to.The selection will
	;;^DD(357.3,.04,21,3,0)
	;;=appear under the group header on the form.
	;;^DD(357.3,.04,"DT")
	;;=2921222
	;;^DD(357.3,.05,0)
	;;=PRINT ORDER WITHIN GROUP^RNJ6,2^^0;5^K:+X'=X!(X>999.99)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(357.3,.05,1,0)
	;;=^.1
	;;^DD(357.3,.05,1,1,0)
	;;=357.3^APO2^MUMPS
	;;^DD(357.3,.05,1,1,1)
	;;=I $P(^IBE(357.3,DA,0),U,3),$P(^(0),U,4) S ^IBE(357.3,"APO",$P(^(0),U,3),$P(^(0),U,4),X,DA)=""
	;;^DD(357.3,.05,1,1,2)
	;;=I $P(^IBE(357.3,DA,0),U,3),$P(^(0),U,4) K ^IBE(357.3,"APO",$P(^(0),U,3),$P(^(0),U,4),X,DA)
	;;^DD(357.3,.05,1,1,"%D",0)
	;;=^^7^7^2940224^
	;;^DD(357.3,.05,1,1,"%D",1,0)
	;;= 
	;;^DD(357.3,.05,1,1,"%D",2,0)
	;;=Allows all selections for a particular group in a selection list to be
	;;^DD(357.3,.05,1,1,"%D",3,0)
	;;=found in the order that they should appear. The subscripts are
	;;^DD(357.3,.05,1,1,"%D",4,0)
	;;=^IBE(357.3,"APO",<selection list ien>,<group ien>,<print order within
	;;^DD(357.3,.05,1,1,"%D",5,0)
	;;=group>,<selection ien>). If this field is re-indexed then the APO index
	;;^DD(357.3,.05,1,1,"%D",6,0)
	;;=on the .03 field and the APO1 index on the .04 field need not be
	;;^DD(357.3,.05,1,1,"%D",7,0)
	;;=re-indexed.
	;;^DD(357.3,.05,1,1,"DT")
	;;=2921222
	;;^DD(357.3,.05,3)
	;;=Type a Number between 0 and 999.99, 2 Decimal Digits
	;;^DD(357.3,.05,21,0)
	;;=^^2^2^2921229^^^^
	;;^DD(357.3,.05,21,1,0)
	;;=Determines the order that this selection entry will appear in under the
	;;^DD(357.3,.05,21,2,0)
	;;=header for the selection group.
	;;^DD(357.3,.05,"DT")
	;;=2921229
	;;^DD(357.3,1,0)
	;;=SUBCOLUMN VALUE^357.31IA^^1;0
	;;^DD(357.3,1,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.3,1,21,1,0)
	;;= 
	;;^DD(357.3,1,21,2,0)
	;;=The selection can be composed of multiple fields. Each field occupies its
	;;^DD(357.3,1,21,3,0)
	;;=own subcolumn on the form.
	;;^DD(357.31,0)
	;;=SUBCOLUMN VALUE SUB-FIELD^^.02^2
	;;^DD(357.31,0,"DIK")
	;;=IBXF3
	;;^DD(357.31,0,"DT")
	;;=2930402
	;;^DD(357.31,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(357.31,0,"IX","B",357.31,.01)
	;;=
	;;^DD(357.31,0,"NM","SUBCOLUMN VALUE")
	;;=
	;;^DD(357.31,0,"UP")
	;;=357.3
	;;^DD(357.31,.01,0)
	;;=SUBCOLUMN NUMBER^MRNJ1,0X^^0;1^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N)!($D(^IBE(357.3,DA(1),1,"B",X))) X

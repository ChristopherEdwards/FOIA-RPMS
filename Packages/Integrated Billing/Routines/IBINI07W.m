IBINI07W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.4,.03,1,2,2)
	;;=I $P(^IBE(357.4,DA,0),U,2)]"" K ^IBE(357.4,"APO",X,$P(^(0),U,2),DA)
	;;^DD(357.4,.03,1,2,"%D",0)
	;;=^^5^5^2940224^
	;;^DD(357.4,.03,1,2,"%D",1,0)
	;;= 
	;;^DD(357.4,.03,1,2,"%D",2,0)
	;;=Allows all groups in a selection list to be found in the order that they
	;;^DD(357.4,.03,1,2,"%D",3,0)
	;;=should appear. The subscripts are ^IBE(357.4,"APO",<selection list
	;;^DD(357.4,.03,1,2,"%D",4,0)
	;;=ien>,<print order for group>,<group ien>). If this field is re-indexed
	;;^DD(357.4,.03,1,2,"%D",5,0)
	;;=then the APO index on the .02 field need not be re-indexed.
	;;^DD(357.4,.03,1,2,"DT")
	;;=2921222
	;;^DD(357.4,.03,3)
	;;=This identifies the selection list that contains this group.
	;;^DD(357.4,.03,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.4,.03,21,1,0)
	;;= 
	;;^DD(357.4,.03,21,2,0)
	;;=The Selection List this group belongs to.
	;;^DD(357.4,.03,"DT")
	;;=2921222

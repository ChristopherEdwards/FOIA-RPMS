GMPLI00A	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(125.8,6,3)
	;;=Answer must be 3-25 characters in length.
	;;^DD(125.8,6,21,0)
	;;=^^1^1^2930908^
	;;^DD(125.8,6,21,1,0)
	;;=This is the description of why the change was made, if known.
	;;^DD(125.8,6,"DT")
	;;=2921028
	;;^DD(125.8,7,0)
	;;=REQUESTING PROVIDER^P200'^VA(200,^0;8^Q
	;;^DD(125.8,7,21,0)
	;;=^^2^2^2930908^
	;;^DD(125.8,7,21,1,0)
	;;=This is the provider who either changed this data, or directed it to be
	;;^DD(125.8,7,21,2,0)
	;;=changed.
	;;^DD(125.8,7,"DT")
	;;=2930305
	;;^DD(125.8,10,0)
	;;=OLD PROBLEM ENTRY^F^^1;1^K:$L(X)>150!($L(X)<1) X
	;;^DD(125.8,10,3)
	;;=Answer must be 1-150 characters in length.
	;;^DD(125.8,10,21,0)
	;;=^^2^2^2930908^
	;;^DD(125.8,10,21,1,0)
	;;=This is the entire problem entry (internal format) as it existed prior
	;;^DD(125.8,10,21,2,0)
	;;=to changing this data.
	;;^DD(125.8,10,23,0)
	;;=^^2^2^2930908^
	;;^DD(125.8,10,23,1,0)
	;;=This field consists of the original 0-node concatenated with an "^" and
	;;^DD(125.8,10,23,2,0)
	;;=the original 1-node, prior to modifying this data.
	;;^DD(125.8,10,"DT")
	;;=2930305

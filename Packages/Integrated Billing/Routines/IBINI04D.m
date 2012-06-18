IBINI04D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.1,.03,21,0)
	;;=^^3^3^2940111^^^
	;;^DD(355.1,.03,21,1,0)
	;;=Each type of policy must be identified with a major category.  It is the
	;;^DD(355.1,.03,21,2,0)
	;;=major category field that will be used to determine the type of policy
	;;^DD(355.1,.03,21,3,0)
	;;=internally by the computer.
	;;^DD(355.1,.03,"DT")
	;;=2940111
	;;^DD(355.1,10,0)
	;;=DESCRIPTION^355.11^^10;0
	;;^DD(355.1,10,21,0)
	;;=^^1^1^2930603^
	;;^DD(355.1,10,21,1,0)
	;;=Enter a one or two sentence description of the type of policy.
	;;^DD(355.11,0)
	;;=DESCRIPTION SUB-FIELD^^.01^1
	;;^DD(355.11,0,"DT")
	;;=2930603
	;;^DD(355.11,0,"NM","DESCRIPTION")
	;;=
	;;^DD(355.11,0,"UP")
	;;=355.1
	;;^DD(355.11,.01,0)
	;;=DESCRIPTION^W^^0;1^Q
	;;^DD(355.11,.01,"DT")
	;;=2930603

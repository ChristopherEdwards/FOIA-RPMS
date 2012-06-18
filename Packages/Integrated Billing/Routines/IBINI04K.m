IBINI04K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.2,10,21,1,0)
	;;=Enter a one or two sentence description of the type of coverage.
	;;^DD(355.21,0)
	;;=DESCRIPTION SUB-FIELD^^.01^1
	;;^DD(355.21,0,"DT")
	;;=2930602
	;;^DD(355.21,0,"NM","DESCRIPTION")
	;;=
	;;^DD(355.21,0,"UP")
	;;=355.2
	;;^DD(355.21,.01,0)
	;;=DESCRIPTION^W^^0;1^Q
	;;^DD(355.21,.01,21,0)
	;;=^^1^1^2930603^
	;;^DD(355.21,.01,21,1,0)
	;;=Enter a one or two sentence description of the type of coverage.
	;;^DD(355.21,.01,"DT")
	;;=2930602

IBINI06K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.4,10,"DT")
	;;=2930715
	;;^DD(356.41,0)
	;;=REASON SUB-FIELD^^.01^1
	;;^DD(356.41,0,"DT")
	;;=2930715
	;;^DD(356.41,0,"NM","REASON")
	;;=
	;;^DD(356.41,0,"UP")
	;;=356.4
	;;^DD(356.41,.01,0)
	;;=REASON^W^^0;1^Q
	;;^DD(356.41,.01,21,0)
	;;=^^1^1^2940213^
	;;^DD(356.41,.01,21,1,0)
	;;=This is the long description of the non-acute classification.
	;;^DD(356.41,.01,"DT")
	;;=2930715

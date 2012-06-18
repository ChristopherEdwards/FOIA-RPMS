IBINI04R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.3,11,21,0)
	;;=^^2^2^2931109^
	;;^DD(355.3,11,21,1,0)
	;;=Enter comments that are specific to this group plan.  Do not enter
	;;^DD(355.3,11,21,2,0)
	;;=comments about a specific patient or patient care here.
	;;^DD(355.311,0)
	;;=COMMENTS SUB-FIELD^^.01^1
	;;^DD(355.311,0,"DT")
	;;=2931109
	;;^DD(355.311,0,"NM","COMMENTS")
	;;=
	;;^DD(355.311,0,"UP")
	;;=355.3
	;;^DD(355.311,.01,0)
	;;=COMMENTS^W^^0;1^Q
	;;^DD(355.311,.01,3)
	;;=Enter comments specific to this Group Plan.  These comments will pertain to multiple patients who have this same group plan.
	;;^DD(355.311,.01,"DT")
	;;=2931109

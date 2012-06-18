IBINI012	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36.03,0,"NM","SYNONYM")
	;;=
	;;^DD(36.03,0,"UP")
	;;=36
	;;^DD(36.03,.01,0)
	;;=SYNONYM^MF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(36.03,.01,1,0)
	;;=^.1
	;;^DD(36.03,.01,1,1,0)
	;;=36.03^B
	;;^DD(36.03,.01,1,1,1)
	;;=S ^DIC(36,DA(1),10,"B",$E(X,1,30),DA)=""
	;;^DD(36.03,.01,1,1,2)
	;;=K ^DIC(36,DA(1),10,"B",$E(X,1,30),DA)
	;;^DD(36.03,.01,1,2,0)
	;;=36^C
	;;^DD(36.03,.01,1,2,1)
	;;=S ^DIC(36,"C",$E(X,1,30),DA(1),DA)=""
	;;^DD(36.03,.01,1,2,2)
	;;=K ^DIC(36,"C",$E(X,1,30),DA(1),DA)
	;;^DD(36.03,.01,1,2,"DT")
	;;=2930326
	;;^DD(36.03,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(36.03,.01,21,0)
	;;=^^1^1^2930607^
	;;^DD(36.03,.01,21,1,0)
	;;=Enter other terms for referring to this insurance company.
	;;^DD(36.03,.01,"DT")
	;;=2930326

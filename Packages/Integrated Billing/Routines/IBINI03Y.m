IBINI03Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.2,.1,1,1,"DT")
	;;=2921110
	;;^DD(354.2,.1,21,0)
	;;=^^2^2^2921208^^^
	;;^DD(354.2,.1,21,1,0)
	;;=Enter whether or not this Billing Exemption Reason can currently be
	;;^DD(354.2,.1,21,2,0)
	;;=used or not.
	;;^DD(354.2,.1,"DT")
	;;=2921110

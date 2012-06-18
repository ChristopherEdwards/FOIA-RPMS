IBINI035	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(351.2,2.03,"DT")
	;;=2930810
	;;^DD(351.2,2.04,0)
	;;=DATE LAST UPDATED^D^^2;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(351.2,2.04,21,0)
	;;=^^1^1^2930810^
	;;^DD(351.2,2.04,21,1,0)
	;;=This is the date/time that the entry was last updated.
	;;^DD(351.2,2.04,"DT")
	;;=2930810

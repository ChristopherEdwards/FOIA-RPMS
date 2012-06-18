IBINI020	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.6,3.03,5,1,0)
	;;=350.6^3.01^1
	;;^DD(350.6,3.03,21,0)
	;;=^^2^2^2920427^
	;;^DD(350.6,3.03,21,1,0)
	;;=This field contains the individual who purged the file.  The field is
	;;^DD(350.6,3.03,21,2,0)
	;;=updated by a trigger when the PURGE BEGIN DATE/TIME field is updated.
	;;^DD(350.6,3.03,"DT")
	;;=2920408

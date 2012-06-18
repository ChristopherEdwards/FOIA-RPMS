IBINI06R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.5,.03,21,3,0)
	;;=the expanded review screen for associated DRG's.  Generally this
	;;^DD(356.5,.03,21,4,0)
	;;=information will be from HCFA or the insurance industry.
	;;^DD(356.5,.03,"DT")
	;;=2930723

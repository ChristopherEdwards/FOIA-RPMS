IBINI03G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(353)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(353,1.01,3)
	;;=Answer must be 1-25 characters in length.  It must be in the form of [TAG^]ROUTINE.
	;;^DD(353,1.01,21,0)
	;;=^^2^2^2940213^^^^
	;;^DD(353,1.01,21,1,0)
	;;=This is the routine that will get executed for follow-up letters and bills 
	;;^DD(353,1.01,21,2,0)
	;;=printed in a batch if this is not a UB-82 entry.
	;;^DD(353,1.01,"DT")
	;;=2920427

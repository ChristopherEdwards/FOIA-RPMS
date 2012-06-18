IBINI01T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.41)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.41,.07,"DT")
	;;=2911113
	;;^DD(350.41,.08,0)
	;;=ERROR^F^^0;8^K:$L(X)>60!($L(X)<3) X
	;;^DD(350.41,.08,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(350.41,.08,21,0)
	;;=^^2^2^2940209^^
	;;^DD(350.41,.08,21,1,0)
	;;=Description of the error which prevented the entry from transferring to 
	;;^DD(350.41,.08,21,2,0)
	;;=350.4.  This field is edited automatically by the transfer program.
	;;^DD(350.41,.08,"DT")
	;;=2911125

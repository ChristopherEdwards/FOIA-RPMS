IBINI09S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(362.5,.03,23,2,0)
	;;=is chosen.
	;;^DD(362.5,.03,"DT")
	;;=2931229
	;;^DD(362.5,.04,0)
	;;=RECORD^P660'^RMPR(660,^0;4^Q
	;;^DD(362.5,.04,3)
	;;=Enter the record for this prosthetic item transaction.
	;;^DD(362.5,.04,5,1,0)
	;;=362.5^.01^3
	;;^DD(362.5,.04,21,0)
	;;=^^1^1^2931229^^^^
	;;^DD(362.5,.04,21,1,0)
	;;=This is the Prosthetic record for this item transaction.
	;;^DD(362.5,.04,23,0)
	;;=^^3^3^2931229^^^^
	;;^DD(362.5,.04,23,1,0)
	;;=This should be automatically set by the system if a prosthetic record
	;;^DD(362.5,.04,23,2,0)
	;;=is chosen.  This is not required because not all items may be from
	;;^DD(362.5,.04,23,3,0)
	;;=prosthetics, such as fee basis charges.
	;;^DD(362.5,.04,"DT")
	;;=2931229

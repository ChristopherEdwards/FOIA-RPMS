IBDEI01X	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.91)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.91)
	;;=^IBE(358.91,
	;;^UTILITY(U,$J,358.91,0)
	;;=IMP/EXP MARKING AREA^358.91^7^7
	;;^UTILITY(U,$J,358.91,1,0)
	;;=TWO SPACES^  
	;;^UTILITY(U,$J,358.91,2,0)
	;;=__^__^1^
	;;^UTILITY(U,$J,358.91,3,0)
	;;=(P) (S)^(P) (S)^1^
	;;^UTILITY(U,$J,358.91,4,0)
	;;=(A) (I)^(A) (I)^1
	;;^UTILITY(U,$J,358.91,5,0)
	;;=(Y)^(Y)^1^
	;;^UTILITY(U,$J,358.91,6,0)
	;;=__ yes^__ yes^1^
	;;^UTILITY(U,$J,358.91,7,0)
	;;=__ no^__ no^1^

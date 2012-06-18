IBINI08O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(357.91)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,357.91)
	;;=^IBE(357.91,
	;;^UTILITY(U,$J,357.91,0)
	;;=MARKING AREA TYPE^357.91^14^14
	;;^UTILITY(U,$J,357.91,1,0)
	;;=( )^( )^1^
	;;^UTILITY(U,$J,357.91,2,0)
	;;=_^_^1^
	;;^UTILITY(U,$J,357.91,3,0)
	;;=SPACE^ ^1^
	;;^UTILITY(U,$J,357.91,4,0)
	;;=BLANK^^1^
	;;^UTILITY(U,$J,357.91,5,0)
	;;=TWO SPACES^  ^1^
	;;^UTILITY(U,$J,357.91,6,0)
	;;=__ yes^__ yes^1^
	;;^UTILITY(U,$J,357.91,7,0)
	;;=__ no^__ no^1^
	;;^UTILITY(U,$J,357.91,8,0)
	;;=THREE SPACES^   ^1^
	;;^UTILITY(U,$J,357.91,9,0)
	;;=__^__^1^
	;;^UTILITY(U,$J,357.91,10,0)
	;;=(P) (S)^(P) (S)^1^
	;;^UTILITY(U,$J,357.91,11,0)
	;;=(Y)^(Y)^1^
	;;^UTILITY(U,$J,357.91,12,0)
	;;=(A) (I) (H)^(A) (I) (H)^1^
	;;^UTILITY(U,$J,357.91,13,0)
	;;=5 SPACES^     ^1^
	;;^UTILITY(U,$J,357.91,14,0)
	;;=(A) (I)^(A) (I)^1

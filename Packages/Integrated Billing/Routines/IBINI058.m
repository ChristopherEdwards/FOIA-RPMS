IBINI058	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.6,13,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,13,11,1,0)
	;;=Provides benefits for nursing home care.
	;;^UTILITY(U,$J,355.6,14,0)
	;;=EYE EXAM COVERAGE
	;;^UTILITY(U,$J,355.6,14,11,0)
	;;=^^2^2^2931130^
	;;^UTILITY(U,$J,355.6,14,11,1,0)
	;;=Provides benefits for eye examinations, lenses, frames, and contact
	;;^UTILITY(U,$J,355.6,14,11,2,0)
	;;=lenses based on a fixed fee schedule.
	;;^UTILITY(U,$J,355.6,15,0)
	;;=INPATIENT DEDUCTIBLE $50
	;;^UTILITY(U,$J,355.6,15,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,15,11,1,0)
	;;=Imposes a $50 inpatient hospital deductible per calendar year.
	;;^UTILITY(U,$J,355.6,16,0)
	;;=INPATIENT DEDUCTIBLE $100
	;;^UTILITY(U,$J,355.6,16,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,16,11,1,0)
	;;=Imposes a $100 inpatient hospital deductible per calendar year.
	;;^UTILITY(U,$J,355.6,17,0)
	;;=INPATIENT DEDUCTIBLE $250
	;;^UTILITY(U,$J,355.6,17,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,17,11,1,0)
	;;=Imposes a $250 inpatient hospital deductible per calendar year.
	;;^UTILITY(U,$J,355.6,18,0)
	;;=INPATIENT DEDUCTIBLE $500
	;;^UTILITY(U,$J,355.6,18,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,18,11,1,0)
	;;=Imposes a $500 inpatient hospital deductible per calendar year.

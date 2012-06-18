IBINI04I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.1,57,10,1,0)
	;;=Prescription only coverage.
	;;^UTILITY(U,$J,355.1,58,0)
	;;=MENTAL HEALTH ONLY^MH^12
	;;^UTILITY(U,$J,355.1,59,0)
	;;=HOSPITAL-MEDICAL INSURANCE^HMI^1
	;;^UTILITY(U,$J,355.1,59,10,0)
	;;=^^3^3^2940111^
	;;^UTILITY(U,$J,355.1,59,10,1,0)
	;;=A term used to indicate protection that provides benefits toward
	;;^UTILITY(U,$J,355.1,59,10,2,0)
	;;=the cost of any or all of the numerous health care services normally
	;;^UTILITY(U,$J,355.1,59,10,3,0)
	;;=covered under various health insurance plans.
	;;^UTILITY(U,$J,355.1,60,0)
	;;=CHAMPUS SUPPLEMENTAL^CS^1
	;;^UTILITY(U,$J,355.1,60,10,0)
	;;=^^3^3^2940209^
	;;^UTILITY(U,$J,355.1,60,10,1,0)
	;;=Insurance for patients who are retirees from the service.  All
	;;^UTILITY(U,$J,355.1,60,10,2,0)
	;;=automatically receive CHAMPUS, and may select the supplemental
	;;^UTILITY(U,$J,355.1,60,10,3,0)
	;;=policy of their choice.

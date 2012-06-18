IBINI03Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(354.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,354.2)
	;;=^IBE(354.2,
	;;^UTILITY(U,$J,354.2,0)
	;;=EXEMPTION REASON^354.2I^9^9
	;;^UTILITY(U,$J,354.2,1,0)
	;;=IN RECEIPT OF PENSION^Patient Receives VA Pension^1^1^40
	;;^UTILITY(U,$J,354.2,2,0)
	;;=IN RECEIPT OF A&A^Patient Receives Aid and Attendance^1^1^20
	;;^UTILITY(U,$J,354.2,3,0)
	;;=IN RECEIPT OF HB^Patient receives House Bound Benefits^1^1^30
	;;^UTILITY(U,$J,354.2,4,0)
	;;=INCOME<PENSION^Patients income below Copay Income Threshold^1^1^120
	;;^UTILITY(U,$J,354.2,5,0)
	;;=INCOME>PENSION^Patients income is greater than Copay Income Threshold^1^0^110
	;;^UTILITY(U,$J,354.2,6,0)
	;;=NO INCOME DATA^There is insufficient income data on file for the prior year.^1^0^210
	;;^UTILITY(U,$J,354.2,7,0)
	;;=NON-VETERAN^Patient is a non-Veteran^1^1^60
	;;^UTILITY(U,$J,354.2,8,0)
	;;=SC>50^Patient is Service Connected 50 percent or more.^1^1^10
	;;^UTILITY(U,$J,354.2,9,0)
	;;=HARDSHIP^Exempted Due to Hardship^1^1^2010

IBINI048	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(354.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,354.5)
	;;=^IBE(354.5,
	;;^UTILITY(U,$J,354.5,0)
	;;=BILLING ALERT DEFINITION^354.5^20^14
	;;^UTILITY(U,$J,354.5,1,0)
	;;=TO HARDSHIP^IB^Patient given Copay Hardship^^I^1^IBAERR3
	;;^UTILITY(U,$J,354.5,1,3)
	;;=E
	;;^UTILITY(U,$J,354.5,2,0)
	;;=FROM HARDSHIP^IB^Copay Hardship Removed^^I^1^IBAERR3
	;;^UTILITY(U,$J,354.5,2,3)
	;;=E
	;;^UTILITY(U,$J,354.5,3,0)
	;;=INCOME EXPIRED^IB^Copay Income Exemption expired^^I^1^IBAERR3
	;;^UTILITY(U,$J,354.5,3,3)
	;;=E
	;;^UTILITY(U,$J,354.5,10,0)
	;;=UNKNOWN ALERT^IB^Unknown Error Occured^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,10,3)
	;;=M
	;;^UTILITY(U,$J,354.5,11,0)
	;;=LOCK FAILED^IB^Adding a Copay Exemption Failed^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,11,3)
	;;=E
	;;^UTILITY(U,$J,354.5,12,0)
	;;=ADD PATIENT FAILED^IB^Failed Adding to Billing Patient file^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,12,3)
	;;=E
	;;^UTILITY(U,$J,354.5,13,0)
	;;=BAD DATE^IB^Adding a Copay Exemption Failed^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,13,3)
	;;=E
	;;^UTILITY(U,$J,354.5,14,0)
	;;=DICN FAILED^IB^Adding a Copay Exemption Failed^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,14,3)
	;;=E
	;;^UTILITY(U,$J,354.5,15,0)
	;;=EDITING FAILED^IB^Editing a Copay Exemption Failed^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,16,0)
	;;=CURRENT STATUS FAILED^IB^Failed while updating Current Status^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,16,3)
	;;=E
	;;^UTILITY(U,$J,354.5,17,0)
	;;=INACTIVATION FAILED^IB^Failed while inactiving old entries^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,17,3)
	;;=E
	;;^UTILITY(U,$J,354.5,18,0)
	;;=USER UNDEFINED^IB^Failed to add exemption, User undefined.^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,18,3)
	;;=M
	;;^UTILITY(U,$J,354.5,19,0)
	;;=PATIENT LOCKED WHILE ADDING^IB^Failed to add Billing Patient Entry, locked.^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,19,3)
	;;=M
	;;^UTILITY(U,$J,354.5,20,0)
	;;=FAILED IN AR^IB^Failed in Accounts Receivable^^R^11^IBAERR3
	;;^UTILITY(U,$J,354.5,20,3)
	;;=M

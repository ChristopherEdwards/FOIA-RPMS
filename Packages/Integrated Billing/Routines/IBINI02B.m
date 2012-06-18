IBINI02B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,350.8,93,0)
	;;=IB093^IB093 - place holder^IB093^1^1
	;;^UTILITY(U,$J,350.8,94,0)
	;;=IB094^IB094 - place holder^IB094^1^1
	;;^UTILITY(U,$J,350.8,95,0)
	;;=IB095^IB095 - place holder^IB095^1^1
	;;^UTILITY(U,$J,350.8,96,0)
	;;=IB096^IB096 - place holder^IB096^1^1
	;;^UTILITY(U,$J,350.8,97,0)
	;;=IB097^IB097 - place holder^IB097^1^1
	;;^UTILITY(U,$J,350.8,98,0)
	;;=IB098^IB098 - place holder^IB098^1^1
	;;^UTILITY(U,$J,350.8,99,0)
	;;=IB099^IB099 - place holder^IB099^1^1
	;;^UTILITY(U,$J,350.8,100,0)
	;;=PRCA SITE^Site not defined.^PRCA001^2^1
	;;^UTILITY(U,$J,350.8,101,0)
	;;=PRCA SERVICE^Service not defined.^PRCA002^2^1
	;;^UTILITY(U,$J,350.8,102,0)
	;;=PRCA NUMBERING SERIES^No common numbering series available for service^PRCA003^2^1
	;;^UTILITY(U,$J,350.8,103,0)
	;;=PRCA IN USE^Another user entering a bill, try later.^PRCA004^2^1
	;;^UTILITY(U,$J,350.8,104,0)
	;;=PRCA NO AR^Accounts Receivable package does not appear to be installed.^PRCA005^2^1
	;;^UTILITY(U,$J,350.8,105,0)
	;;=PRCA BILL RECORD^Bill record number is missing.^PRCA006^2^1
	;;^UTILITY(U,$J,350.8,106,0)
	;;=PRCA BILL NUMBER^Bill number undefined.^PRCA007^2^1
	;;^UTILITY(U,$J,350.8,107,0)
	;;=PRCA STATUS MISSING^Status of bills is missing.^PRCA008^2^1
	;;^UTILITY(U,$J,350.8,108,0)
	;;=PRCA STATUS INCORRECT^Status of bills is not correct.^PRCA009^2^1
	;;^UTILITY(U,$J,350.8,109,0)
	;;=PRCA DATE MISSING^Billing date is missing.^PRCA010^2^1
	;;^UTILITY(U,$J,350.8,110,0)
	;;=PRCA DATE WRONG^Billing date is not in expected format.^PRCA011^2^1
	;;^UTILITY(U,$J,350.8,111,0)
	;;=PRCA USER MISSING^Approving official is missing.^PRCA012^2^1
	;;^UTILITY(U,$J,350.8,112,0)
	;;=PRCA USER UNDEFINED^Approving official is undefined.^PRCA013^2^1
	;;^UTILITY(U,$J,350.8,113,0)
	;;=PRCA USER MISSING IN 200^Approving official is not in the person file.^PRCA014^2^1
	;;^UTILITY(U,$J,350.8,114,0)
	;;=PRCA FY MISSING^Fiscal year data is missing^PRCA015^2^1
	;;^UTILITY(U,$J,350.8,115,0)
	;;=PRCA FY BLANK^Fiscal year is blank.^PRCA016^2^1
	;;^UTILITY(U,$J,350.8,116,0)
	;;=PRCA AMOUNT^Amount of bill is less than zero.^PRCA017^2^1
	;;^UTILITY(U,$J,350.8,117,0)
	;;=PRCA NO DEBTOR^Debtor data is missing.^PRCA018^2^1
	;;^UTILITY(U,$J,350.8,118,0)
	;;=PRCA DEBTOR PROBLEM^Debtor is not in expected format or is not defined.^PRCA019^2^1
	;;^UTILITY(U,$J,350.8,119,0)
	;;=PRCA TRANSACTION^No transaction passed.^PRCA020^2^1
	;;^UTILITY(U,$J,350.8,120,0)
	;;=PRCA TRANSACTION UNDEF^Transaction type does not exist.^PRCA021^2^1
	;;^UTILITY(U,$J,350.8,121,0)
	;;=PRCA TRANSACTION INVALID^Invalid transaction type^PRCA022^2^1
	;;^UTILITY(U,$J,350.8,122,0)
	;;=PRCA INVALID AMOUNT^Amount is in an invalid format.^PRCA023^2^1
	;;^UTILITY(U,$J,350.8,123,0)
	;;=PRCA DATE FORMAT^Date of adjustment is not in a valid format.^PRCA024^2^1
	;;^UTILITY(U,$J,350.8,124,0)
	;;=PRCA CAT. MISSING^Category of bill is missing^PRCA025^2^1
	;;^UTILITY(U,$J,350.8,125,0)
	;;=PRCA CAT. UNDEF.^Category of bill is undefined.^PRCA026^2^1
	;;^UTILITY(U,$J,350.8,126,0)
	;;=PRCA TYPE CARE^Type of care is missing^PRCA027^2^1
	;;^UTILITY(U,$J,350.8,127,0)
	;;=PRCA TYPE CARE WRONG^Type of care is not in expected format^PRCA028^2^1
	;;^UTILITY(U,$J,350.8,128,0)
	;;=PRCA AMOUNT MISSING^Amount of bill is missing^PRCA029^2^1
	;;^UTILITY(U,$J,350.8,129,0)
	;;=PRCA APR1^Bill Approver field is blank.^60^2^3
	;;^UTILITY(U,$J,350.8,130,0)
	;;=PRCA APR2^Bill Approver is not in User file.^61^2^3
	;;^UTILITY(U,$J,350.8,131,0)
	;;=PRCA APR3^Bill Approver is not in the Person file.^62^2^3

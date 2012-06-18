IBINI02A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,350.8,59,0)
	;;=IB RATE TYPE^Rate Type is missing or is missing A/R Category Field.^IB059^1^3
	;;^UTILITY(U,$J,350.8,60,0)
	;;=IB REVIEWING USER^Reviewing User not in Usr file or Person file link missing.^IB060^1^3
	;;^UTILITY(U,$J,350.8,61,0)
	;;=IB STATEMENT FROM^Statement Covers From field not entered or inappropriate.^IB061^1^3
	;;^UTILITY(U,$J,350.8,62,0)
	;;=IB STATEMENT TO^Statement Covers To field not entered or inappropriate.^IB062^1^3
	;;^UTILITY(U,$J,350.8,63,0)
	;;=IB TIMEFRAME^Time Frame of Bill is missing or incorrect.^IB063^1^3
	;;^UTILITY(U,$J,350.8,64,0)
	;;=IB TOTAL CHARGES^Total Charges for Bill missing or equals zero.^IB064^1^3
	;;^UTILITY(U,$J,350.8,65,0)
	;;=IB WHO'S RESPONSIBLE^Who's Responsible for bill is not entered or incorrect.^IB065^1^3
	;;^UTILITY(U,$J,350.8,66,0)
	;;=IB066  IB DUPLICATE COPAYMENT^Patient already charged a Copayment for this date.^IB066^1^1
	;;^UTILITY(U,$J,350.8,67,0)
	;;=IB067  COMP & PENSION^Patient had a Compensation and Pension on this date.^IB067^1^1
	;;^UTILITY(U,$J,350.8,68,0)
	;;=IB068  IB CLOCK LOCKED^Patient's billing clock locked; adjust manually.^IB068^1^1
	;;^UTILITY(U,$J,350.8,69,0)
	;;=IB069  IB NO CHARGE^Exceeds maximum appropriate charges; no bill added.^IB069^1^1
	;;^UTILITY(U,$J,350.8,70,0)
	;;=IB NO VISIT CPT^Missing the visit procedure.^IB070^1^3
	;;^UTILITY(U,$J,350.8,71,0)
	;;=IB NO DX^No ICD-9 diagnosis.^IB071^1^3
	;;^UTILITY(U,$J,350.8,72,0)
	;;=IB NO CPT DX^A CPT procedure is missing an associated diagnosis.^IB072^1^3
	;;^UTILITY(U,$J,350.8,73,0)
	;;=IB BAD CPT DX^A CPT procedure associated diagnosis does not match any billing diagnosis.^IB073^1^3
	;;^UTILITY(U,$J,350.8,74,0)
	;;=IB ADD PATIENT FAILED^Failed to add patient to Billing Patient file.^IB074^1^2^12
	;;^UTILITY(U,$J,350.8,75,0)
	;;=IB BAD DATE FORMAT^Date in incorrect format.^IB075^1^2^13
	;;^UTILITY(U,$J,350.8,76,0)
	;;=IB ADD EXEMPTION FAILED^Failed to add exemption record to Billing Exemption file.^IB076^1^2^14
	;;^UTILITY(U,$J,350.8,77,0)
	;;=IB EXEMPTION UPDATE FAILED^Failed while updating exemption record.^IB077^1^2^15
	;;^UTILITY(U,$J,350.8,78,0)
	;;=IB FAILED CURRENT STATUS^Failed while updating current exemption status.^IB078^1^2^16
	;;^UTILITY(U,$J,350.8,79,0)
	;;=IB INACTIVATE EXEM FAILED^Failed while inactivating old exemption status.^IB079^1^2^17
	;;^UTILITY(U,$J,350.8,80,0)
	;;=IB ADD EX. BAD USER^Failed to add exemption.  User not defined.^IB080^1^2^18
	;;^UTILITY(U,$J,350.8,81,0)
	;;=IB ADD PT. ENTRY LOCKED^Failed to add patient to Billing Patient file.  Entry locked.^IB081^1^2^19
	;;^UTILITY(U,$J,350.8,82,0)
	;;=IB FAILED IN AR^Failed in Accounts Receivable while processing decrease adjustment or refund.^IB082^1^2^20
	;;^UTILITY(U,$J,350.8,83,0)
	;;=IB NO CHAMPVA LIMIT TYPE^Integrated Billing cannot find an action type for the CHAMPVA limit.^IB083^1^1
	;;^UTILITY(U,$J,350.8,84,0)
	;;=IB NO CHAMPVA LIMIT^Integrated Billing cannot find the CHAMPVA limit for the given date.^IB084^1^1
	;;^UTILITY(U,$J,350.8,85,0)
	;;=IB085^IB085 - place holder^IB085^1^1
	;;^UTILITY(U,$J,350.8,86,0)
	;;=IB086^IB086 - place holder^IB086^1^1
	;;^UTILITY(U,$J,350.8,87,0)
	;;=IB087^IB087 - place holder^IB087^1^1
	;;^UTILITY(U,$J,350.8,88,0)
	;;=IB088^IB088 - place holder^IB088^1^1
	;;^UTILITY(U,$J,350.8,89,0)
	;;=IB089^IB089 - place holder^IB089^1^1
	;;^UTILITY(U,$J,350.8,90,0)
	;;=IB090^IB090 - place holder^IB090^1^1
	;;^UTILITY(U,$J,350.8,91,0)
	;;=IB091^IB091 - place holder^IB091^1^1
	;;^UTILITY(U,$J,350.8,92,0)
	;;=IB092^IB092 - place holder^IB092^1^1

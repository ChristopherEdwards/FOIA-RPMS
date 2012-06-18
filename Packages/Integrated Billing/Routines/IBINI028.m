IBINI028	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,350.8)
	;;=^IBE(350.8,
	;;^UTILITY(U,$J,350.8,0)
	;;=IB ERROR^350.8I^154^154
	;;^UTILITY(U,$J,350.8,1,0)
	;;=IB VAEL MISSING^Patient eligibility data was expected but not there.^IB001^1^1
	;;^UTILITY(U,$J,350.8,2,0)
	;;=IB DFN^Patient pointer does not point to a valid patient file entry!^IB002^1^1
	;;^UTILITY(U,$J,350.8,3,0)
	;;=IB SERVICE^Application Service not in Service/Section file!^IB003^1^1
	;;^UTILITY(U,$J,350.8,4,0)
	;;=IB MISSING APP GL^Global location of parent file can't be determined for this entry.^IB004^1^1
	;;^UTILITY(U,$J,350.8,5,0)
	;;=IB NO PARENT^Application entry that created IB Action no longer exists.^IB005^1^1
	;;^UTILITY(U,$J,350.8,6,0)
	;;=IB NO SUBFILE^Application entry in a subfile that created IB Action no longer exists.^IB006^1^1
	;;^UTILITY(U,$J,350.8,7,0)
	;;=IB DUZ^User (DUZ) creating entry not a valid entry in New Person file.^IB007^1^1
	;;^UTILITY(U,$J,350.8,8,0)
	;;=IB ACTION TYPE^Integrated Billing can not determine Action Type from application.^IB008^1^1
	;;^UTILITY(U,$J,350.8,9,0)
	;;=IB SITE^Facility is not entered in IB Site Parameter file.^IB009^1^1
	;;^UTILITY(U,$J,350.8,10,0)
	;;=IB NO RX^Pharmacy called IB but no RX data passed.^IB010^1^1
	;;^UTILITY(U,$J,350.8,11,0)
	;;=IB NO BILL^IB expected Bill Number from AR but none returned.^IB011^1^1
	;;^UTILITY(U,$J,350.8,12,0)
	;;=IB SOFT LINK^Application did not pass link to entry creating entry.^IB012^1^1
	;;^UTILITY(U,$J,350.8,13,0)
	;;=IB UNITS^Application did not pass number of units to IB^IB013^1^1
	;;^UTILITY(U,$J,350.8,14,0)
	;;=IB ENTRY LOCKED^IB can't create new entry.  File locked by another user.^IB014^1^2^11
	;;^UTILITY(U,$J,350.8,15,0)
	;;=IB NOT INSTALLED^Integrated Billing files do not appear to be installed on this system.^IB015^1^1
	;;^UTILITY(U,$J,350.8,16,0)
	;;=IB PARAMETERS^IB site parameters not set up on this system.^IB016^1^1
	;;^UTILITY(U,$J,350.8,17,0)
	;;=IB SEQUENCE NUMBER^Sequence number is missing, can't pass IB entry to AR.^IB017^1^1
	;;^UTILITY(U,$J,350.8,18,0)
	;;=IB ZEROTH NODE^Entry in IB ACTION file appears to be missing.^IB018^1^1
	;;^UTILITY(U,$J,350.8,19,0)
	;;=IB FILER NOT QUEUED^An attempt to queue the IB filer was unsuccessful.^IB019^1^1
	;;^UTILITY(U,$J,350.8,20,0)
	;;=IB CANCELLATION REASON^Canceled Entry does not have expected cancellation reason.^IB020^1^1
	;;^UTILITY(U,$J,350.8,21,0)
	;;=IB CANCELLED PARENT^An attempt was made to cancel an IB ACTION entry that does not exist^IB021^1^1
	;;^UTILITY(U,$J,350.8,22,0)
	;;=IB CANCELED ACTION TYPE^The cancellation action type for this action type can not be determined.^IB022^1^1
	;;^UTILITY(U,$J,350.8,23,0)
	;;=IB MISSING SEQUENCE NUMBER^The SEQUENCE NUMBER field in the IB ACTION TYPE file is missing for the type.^IB023^1^1
	;;^UTILITY(U,$J,350.8,24,0)
	;;=IB BILL NUMBER^The bill number in the parent IB ACTION entry is missing.^IB024^1^1
	;;^UTILITY(U,$J,350.8,25,0)
	;;=IB UNIT<1^The billable unit is less than one.^IB025^1^1
	;;^UTILITY(U,$J,350.8,26,0)
	;;=IB ALREADY CANCELLED^Last update for entry you are cancelling is cancelled.^IB026^1^1
	;;^UTILITY(U,$J,350.8,27,0)
	;;=IB NO UPDATE PARENT^An attempt was made to update an IB Action, but its Parent entry does not exist.^IB027^1^1
	;;^UTILITY(U,$J,350.8,28,0)
	;;=IB FAILED WHILE EDITING^Integrated Billing failed while editing a newly created entry^IB028^1^1
	;;^UTILITY(U,$J,350.8,29,0)
	;;=IB NO CHARGE - ACTION TYPE^Integrated Billing cannot find a charge for a specific Action Type.^IB029^1^1

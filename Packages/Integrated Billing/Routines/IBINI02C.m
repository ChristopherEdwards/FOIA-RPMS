IBINI02C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,350.8,132,0)
	;;=PRCA ARREC1^Billing Record # field is blank - Checking stopped!^30^2^3
	;;^UTILITY(U,$J,350.8,133,0)
	;;=PRCA ARREC2^No matching AR Record - Checking stopped!^31^2^3
	;;^UTILITY(U,$J,350.8,134,0)
	;;=PRCA BDT1^Date Bill Generated field is blank.^40^2^3
	;;^UTILITY(U,$J,350.8,135,0)
	;;=PRCA BDT2^Date bill generated is not in expected format.^41^2^3
	;;^UTILITY(U,$J,350.8,136,0)
	;;=PRCA BNO1^Bill Number field is blank.^20^2^3
	;;^UTILITY(U,$J,350.8,137,0)
	;;=PRCA BNO2^Bill Number pattern match failed.^21^2^3
	;;^UTILITY(U,$J,350.8,138,0)
	;;=PRCA CARE1^Type of Care field is blank.^90^2^3
	;;^UTILITY(U,$J,350.8,139,0)
	;;=PRCA CARE2^Type of Care is not in expected format.^91^2^3
	;;^UTILITY(U,$J,350.8,140,0)
	;;=PRCA CAT1^Rate Type field is blank.^80^2^3
	;;^UTILITY(U,$J,350.8,141,0)
	;;=PRCA CAT2^Rate Type is not in expected format.^81^2^3
	;;^UTILITY(U,$J,350.8,142,0)
	;;=PRCA CAT3^Payer for this Rate Type should be in file.^82^2^3
	;;^UTILITY(U,$J,350.8,143,0)
	;;=PRCA DEBTOR1^Payer field is blank.^70^2^3
	;;^UTILITY(U,$J,350.8,144,0)
	;;=PRCA DEBTOR2^Payer is not in expected format.^71^2^3
	;;^UTILITY(U,$J,350.8,145,0)
	;;=PRCA FY1^Fiscal Year and Amount fields are blank.^50^2^3
	;;^UTILITY(U,$J,350.8,146,0)
	;;=PRCA FY2^Amount field must be greater than 0.^51^2^3
	;;^UTILITY(U,$J,350.8,147,0)
	;;=PRCA FY3^Fiscal Year field is blank.^52^2^3
	;;^UTILITY(U,$J,350.8,148,0)
	;;=PRCA PAT1^Patient field is blank.^100^2^3
	;;^UTILITY(U,$J,350.8,149,0)
	;;=PRCA SER1^No entry for billing Service/Section.^10^2^3
	;;^UTILITY(U,$J,350.8,150,0)
	;;=PRCA SER2^Billing Service not in the Service/Section File.^11^2^3
	;;^UTILITY(U,$J,350.8,151,0)
	;;=PRCA SITE1^Station Number field is blank.^1^2^3
	;;^UTILITY(U,$J,350.8,152,0)
	;;=PRCA SITE2^Station Number is not in the Site Parameter File.^2^2^3
	;;^UTILITY(U,$J,350.8,153,0)
	;;=PRCA STAT1^Bill Status (Service) is blank.^110^2^3
	;;^UTILITY(U,$J,350.8,154,0)
	;;=PRCA STAT2^Bill Status (Service) is inappropriate.^111^2^3

IBINI057	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(355.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,355.6)
	;;=^IBE(355.6,
	;;^UTILITY(U,$J,355.6,0)
	;;=INSURANCE RIDERS^355.6^18^18
	;;^UTILITY(U,$J,355.6,1,0)
	;;=EXTEND COVERAGE TO 365 DAYS
	;;^UTILITY(U,$J,355.6,1,11,0)
	;;=^^1^1^2931130^^
	;;^UTILITY(U,$J,355.6,1,11,1,0)
	;;=Extends coverage to 365 dates of in-hospital visits.
	;;^UTILITY(U,$J,355.6,2,0)
	;;=COVERAGE FOR ACCIDENTAL INJURY
	;;^UTILITY(U,$J,355.6,2,11,0)
	;;=^^3^3^2931130^
	;;^UTILITY(U,$J,355.6,2,11,1,0)
	;;=Provides first-aid coverage for accidental injuries and coverage
	;;^UTILITY(U,$J,355.6,2,11,2,0)
	;;=for certain medical emergency examinations provided in the doctor's
	;;^UTILITY(U,$J,355.6,2,11,3,0)
	;;=office, outpatient or emergcy department.
	;;^UTILITY(U,$J,355.6,3,0)
	;;=EXTEND DEPENDENTS TO AGE 23
	;;^UTILITY(U,$J,355.6,3,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,3,11,1,0)
	;;=Extends age limit for eligible dependents to 23.
	;;^UTILITY(U,$J,355.6,4,0)
	;;=AMBULANCE COVERAGE
	;;^UTILITY(U,$J,355.6,4,11,0)
	;;=^^2^2^2931130^
	;;^UTILITY(U,$J,355.6,4,11,1,0)
	;;=Provides benefits for necessary ambulance servcies to a hospital as ordered
	;;^UTILITY(U,$J,355.6,4,11,2,0)
	;;=by a physician or officer of the law.
	;;^UTILITY(U,$J,355.6,5,0)
	;;=NO LABORATORY MAXIMUM
	;;^UTILITY(U,$J,355.6,5,11,0)
	;;=^^3^3^2931130^
	;;^UTILITY(U,$J,355.6,5,11,1,0)
	;;=Removes Laboratory maximum and expands laboratory coverage to include
	;;^UTILITY(U,$J,355.6,5,11,2,0)
	;;=those in the doctor's office, outpatient department or independent lab
	;;^UTILITY(U,$J,355.6,5,11,3,0)
	;;=with no maximum benefit.
	;;^UTILITY(U,$J,355.6,6,0)
	;;=MENTAL HEALTH COVERAGE
	;;^UTILITY(U,$J,355.6,6,11,0)
	;;=^^5^5^2931130^
	;;^UTILITY(U,$J,355.6,6,11,1,0)
	;;=Provides coverage for specified mental health services provided by
	;;^UTILITY(U,$J,355.6,6,11,2,0)
	;;=psychiatrists, psychologists, and certified psychiatric social workers
	;;^UTILITY(U,$J,355.6,6,11,3,0)
	;;=when not otherwise covered by a plan.  
	;;^UTILITY(U,$J,355.6,6,11,4,0)
	;;= 
	;;^UTILITY(U,$J,355.6,6,11,5,0)
	;;=Inpatient and outpatient maximums may apply.
	;;^UTILITY(U,$J,355.6,7,0)
	;;=PRESCRIPTION COVERAGE
	;;^UTILITY(U,$J,355.6,7,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,7,11,1,0)
	;;=Provides coverage for medications and nonexperimental therapy.
	;;^UTILITY(U,$J,355.6,8,0)
	;;=ELIMINATE PRESCRIPTION COVER
	;;^UTILITY(U,$J,355.6,8,11,0)
	;;=^^2^2^2931130^
	;;^UTILITY(U,$J,355.6,8,11,1,0)
	;;=Eliminates benefits for prescription drugs and insulin from 
	;;^UTILITY(U,$J,355.6,8,11,2,0)
	;;=basic contract.
	;;^UTILITY(U,$J,355.6,9,0)
	;;=PRE-EXISTING COND. 11 MONTHS
	;;^UTILITY(U,$J,355.6,9,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,9,11,1,0)
	;;=Imposes an 11 month waiting period for pre-existing conditions.
	;;^UTILITY(U,$J,355.6,10,0)
	;;=EXTEND DEPENDENTS TO AGE 25
	;;^UTILITY(U,$J,355.6,10,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,10,11,1,0)
	;;=Extends coverage for student dependents to age 25.
	;;^UTILITY(U,$J,355.6,11,0)
	;;=ELIMINATE DEDUCTIBLE AND COPAY
	;;^UTILITY(U,$J,355.6,11,11,0)
	;;=^^1^1^2931130^
	;;^UTILITY(U,$J,355.6,11,11,1,0)
	;;=Eliminates deductibles and copayments for most hospital facility charges.
	;;^UTILITY(U,$J,355.6,12,0)
	;;=SUBSTANCE ABUSE 30 DAYS
	;;^UTILITY(U,$J,355.6,12,11,0)
	;;=^^2^2^2931130^
	;;^UTILITY(U,$J,355.6,12,11,1,0)
	;;=Provides benefits for up to 30 days of inpatient rehabilitation for
	;;^UTILITY(U,$J,355.6,12,11,2,0)
	;;=alcoholism or substance abuse during each calendar year.
	;;^UTILITY(U,$J,355.6,13,0)
	;;=NURSING HOME COVERAGE

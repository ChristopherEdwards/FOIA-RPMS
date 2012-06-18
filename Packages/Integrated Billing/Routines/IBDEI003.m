IBDEI003	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358)
	;;=^IBE(358,
	;;^UTILITY(U,$J,358,0)
	;;=IMP/EXP ENCOUNTER FORM^358I^7^6
	;;^UTILITY(U,$J,358,1,0)
	;;=BUFFALO'S GENERAL MEDICINE^^SOAP, orders, insurance information (NO allergy info)^1^0^^1^^132^80^1
	;;^UTILITY(U,$J,358,2,0)
	;;=BUFFALO'S OUTPATIENT SURGERY^^doctors notes, CPT codes, insurance information (NO allergy info)^1^0^^1^^132^80^2
	;;^UTILITY(U,$J,358,3,0)
	;;=W/DX,CPT,NOTES,VISIT TYPE^^Dx codes, CPT codes, progress notes (unstructured),allergies, visit type^1^0^^1^^132^80^1
	;;^UTILITY(U,$J,358,5,0)
	;;=W/DX,CPT,VISIT TYPE^^Dx codes, CPT codes, allergies, type of visit^1^0^^1^^132^80^1
	;;^UTILITY(U,$J,358,6,0)
	;;=W/PROBLEMS,CPT,VISIT TYPE^^Problems List, CPT codes, allergies, type of visit^1^0^^1^^132^80^1
	;;^UTILITY(U,$J,358,7,0)
	;;=W/DX,CPT,SOAP^^Dx codes, CPT codes, SOAP, allergies, full demographics^1^0^^1^^132^80^1

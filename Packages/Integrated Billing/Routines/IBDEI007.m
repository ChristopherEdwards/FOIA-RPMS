IBDEI007	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.1)
	;;=^IBE(358.1,
	;;^UTILITY(U,$J,358.1,0)
	;;=IMP/EXP ENCOUNTER FORM BLOCK^358.1I^89^78
	;;^UTILITY(U,$J,358.1,1,0)
	;;=PROGRESS NOTES (SOAP)^1^^23^0^132^30^^^2^^^Patient progess notes in SOAP format.
	;;^UTILITY(U,$J,358.1,2,0)
	;;=BUFFALO'S PROVIDER ORDERS^1^^54^0^132^21^^^2^^^FOR ENTERING ORDERS
	;;^UTILITY(U,$J,358.1,3,0)
	;;=PAGE 1 HEADER^1^^0^0^132^1^^^2^^^CLINIC & APPT DATE^
	;;^UTILITY(U,$J,358.1,4,0)
	;;=SIGNATURE^1^^75^0^132^5^^^2^^^SPACE FOR SIGNATURE & CLINIC^
	;;^UTILITY(U,$J,358.1,5,0)
	;;=VITALS^1^^19^0^132^4^^^2^^^FOR RECORDING VITALS^
	;;^UTILITY(U,$J,358.1,6,0)
	;;=BUFFALO'S DEMOGRAPHICS^1^^2^0^132^17^^^2^^^PATIENT DEMOGRAPHICS^
	;;^UTILITY(U,$J,358.1,7,0)
	;;=BUFFALO'S DOCTORS NOTES^2^^20^0^132^26^^^2^^^Dx,PROCDURE NOTES,FINDINGS, PLAN, ETC.
	;;^UTILITY(U,$J,358.1,8,0)
	;;=PAGE 1 HEADER^2^^0^0^132^1^^^2^^^CLINIC & APPT DATE^
	;;^UTILITY(U,$J,358.1,9,0)
	;;=SIGNATURE^2^^75^0^132^5^^^2^^^SPACE FOR SIGNATURE & CLINIC^
	;;^UTILITY(U,$J,358.1,10,0)
	;;=BUFFALO'S CPT CODES^2^^47^0^132^28^^^2^**CPT CHECKLIST**^C^CPT SELECTION LIST^
	;;^UTILITY(U,$J,358.1,11,0)
	;;=BUFFALO'S DEMOGRAPHICS^2^^2^0^132^17^^^2^^^PATIENT DEMOGRAPHICS^
	;;^UTILITY(U,$J,358.1,12,0)
	;;=APPOINTMENT^3^^0^93^38^3^^^2^^UC^Contains the clinic & date/time of appointment.
	;;^UTILITY(U,$J,358.1,13,0)
	;;=ALLERGIES^3^^26^0^50^9^^^1^******  PATIENT ALLERGIES  ******^UC^Displays the patient's allergies and has space for allergies to be written in.
	;;^UTILITY(U,$J,358.1,14,0)
	;;=SUPPLEMENTAL DEMOGRAPHICS^3^^9^0^49^17^^^2^^BUC^Contains address, insurance, employment and marital data.
	;;^UTILITY(U,$J,358.1,15,0)
	;;=VITAL SIGNS^3^^5^51^79^4^^^2^Vital Signs:^^For writting in the patient's vital signs.^
	;;^UTILITY(U,$J,358.1,16,0)
	;;=PROGRESS NOTES (UNSTRUCTURED)^3^^52^0^100^28^^^2^^BUC^Data fields (w/o data) - for writting progress notes (Not in SOAP format)^
	;;^UTILITY(U,$J,358.1,17,0)
	;;=DIAGNOSIS CODES^3^^9^52^80^26^^^1^PLEASE CHECK OFF DIAGNOSIS TREATED THIS VISIT^UC^This block contains a list of ICD-9 diagnosis codes to select from.^
	;;^UTILITY(U,$J,358.1,18,0)
	;;=CPT CODES^3^^35^0^129^16^^^1^PLEASE CHECK PROCEDURES PERFORMED THIS VISIT^CU^Contains a list of CPT codes that can be selected.^
	;;^UTILITY(U,$J,358.1,19,0)
	;;=BASIC DEMOGRAPHICS^3^^0^0^50^26^^^1^^BUC^Contains patient name,dob,sex,pid,SC conditions^
	;;^UTILITY(U,$J,358.1,20,0)
	;;=HIDDEN SC TREATMENT QUESTIONS^3^^77^0^46^2^^^2^^UC^Data fields - questions on SC of treatment - displayed only if applicable^
	;;^UTILITY(U,$J,358.1,21,0)
	;;=TYPE OF VISIT - 1994 CODES^3^^53^89^43^21^^^1^^^Selection list - visit types with their CPT codes^
	;;^UTILITY(U,$J,358.1,31,0)
	;;=APPOINTMENT^5^^0^94^38^3^^^2^^UC^Contains the clinic & date/time of appointment.
	;;^UTILITY(U,$J,358.1,32,0)
	;;=ALLERGIES^5^^17^0^50^9^^^1^******  PATIENT ALLERGIES  ******^UC^Displays the patient's allergies and has space for allergies to be written in.
	;;^UTILITY(U,$J,358.1,33,0)
	;;=DIAGNOSIS CODES^5^^26^0^132^13^^^1^PLEASE CHECK OFF DIAGNOSIS TREATED THIS VISIT^UC^This block contains a list of ICD-9 diagnosis codes to select from.^
	;;^UTILITY(U,$J,358.1,34,0)
	;;=INSURANCE INFORMATION^5^^11^0^50^5^^^2^^BUC^insurance indicator, insurance policies^
	;;^UTILITY(U,$J,358.1,35,0)
	;;=VITAL SIGNS^5^^10^54^30^16^^^1^Vital Signs:^^For writting in the patient's vital signs.^
	;;^UTILITY(U,$J,358.1,36,0)
	;;=SIGNATURE^5^^75^59^45^5^^^2^^^space for signature, prints clinic name^
	;;^UTILITY(U,$J,358.1,36,1)
	;;=

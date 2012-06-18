IBDEI008	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.1,37,0)
	;;=CPT CODES^5^^39^0^132^37^^^1^PLEASE CHECK PROCEDURES PERFORMED THIS VISIT^CU^Contains a list of CPT codes that can be selected.^
	;;^UTILITY(U,$J,358.1,38,0)
	;;=BASIC DEMOGRAPHICS^5^^0^0^50^17^^^1^^BUC^Contains patient name,dob,sex,pid,SC conditions^
	;;^UTILITY(U,$J,358.1,39,0)
	;;=HIDDEN SC TREATMENT QUESTIONS^5^^77^0^46^2^^^2^^UC^Data fields - questions on SC of treatment - displayed only if applicable^
	;;^UTILITY(U,$J,358.1,40,0)
	;;=TYPE OF VISIT - 1994 CODES^5^^5^89^43^21^^^1^^^Selection list - visit types with their CPT codes^
	;;^UTILITY(U,$J,358.1,41,0)
	;;=APPOINTMENT^6^^2^93^38^3^^^2^^UC^Contains the clinic & date/time of appointment.
	;;^UTILITY(U,$J,358.1,42,0)
	;;=ALLERGIES^6^^17^0^50^9^^^1^******  PATIENT ALLERGIES  ******^UC^Displays the patient's allergies and has space for allergies to be written in.
	;;^UTILITY(U,$J,358.1,43,0)
	;;=INSURANCE INFORMATION^6^^11^0^50^5^^^2^^BUC^insurance indicator, insurance policies^
	;;^UTILITY(U,$J,358.1,44,0)
	;;=CPT CODES^6^^59^0^132^17^^^1^PLEASE CHECK PROCEDURES PERFORMED THIS VISIT^CU^Contains a list of CPT codes that can be selected.^
	;;^UTILITY(U,$J,358.1,45,0)
	;;=VITAL SIGNS^6^^6^50^82^6^^^1^VITAL SIGNS:^^Data fields (w/o data) - to write in vital signs^
	;;^UTILITY(U,$J,358.1,46,0)
	;;=ACTIVE PROBLEMS^6^^12^50^82^14^^^1^ACTIVE PROBLEM LIST^UC^Data fields- patient's active problems^
	;;^UTILITY(U,$J,358.1,47,0)
	;;=OTHER NEW PROBLEMS^6^^26^0^132^10^^^1^OTHER PROBLEMS^UC^Data Fields (w/o data) for adding problems not on the Clinic Common Prob. List^
	;;^UTILITY(U,$J,358.1,48,0)
	;;=CLINIC COMMON PROBLEM LIST^6^^36^0^87^23^^^1^CLINIC COMMON PROBLEM LIST^CU^Selection list - clinic's common problems^
	;;^UTILITY(U,$J,358.1,49,0)
	;;=BASIC DEMOGRAPHICS^6^^0^0^50^17^^^1^^BUC^Contains patient name,dob,sex,pid,SC conditions^
	;;^UTILITY(U,$J,358.1,50,0)
	;;=SIGNATURE^6^^78^49^41^2^^^2^^^space for signature, prints clinic name^
	;;^UTILITY(U,$J,358.1,50,1)
	;;=
	;;^UTILITY(U,$J,358.1,51,0)
	;;=HIDDEN SC TREATMENT QUESTIONS^6^^77^0^46^2^^^2^^UC^Data fields - questions on SC of treatment - displayed only if applicable^
	;;^UTILITY(U,$J,358.1,52,0)
	;;=TYPE OF VISIT - 1994 CODES^6^^37^89^43^21^^^1^^^Selection list - visit types with their CPT codes^
	;;^UTILITY(U,$J,358.1,53,0)
	;;=ACTIVE PROBLEMS^^^62^0^74^14^^^1^ACTIVE PROBLEM LIST^UC^Data fields- patient's active problems^1
	;;^UTILITY(U,$J,358.1,54,0)
	;;=ALLERGIES^^^37^50^50^9^^^1^******  PATIENT ALLERGIES  ******^UC^Data fields - allergies^1
	;;^UTILITY(U,$J,358.1,55,0)
	;;=APPOINTMENT^^^32^39^38^3^^^2^^UC^Data fields - clinic & appt. date/time^1
	;;^UTILITY(U,$J,358.1,56,0)
	;;=APPOINTMENT STATUS^^^0^0^34^6^^^1^^^Data Fields - for recording appointment status^1
	;;^UTILITY(U,$J,358.1,57,0)
	;;=BASIC DEMOGRAPHICS^^^40^0^47^11^^^1^^BUC^Data fields - contains patient name,dob,sex,pid,SC conditions^1
	;;^UTILITY(U,$J,358.1,58,0)
	;;=BUFFALO'S CPT CODES^^^221^0^132^12^^^1^**CPT CHECKLIST**^C^Selection list - CPT codes^1
	;;^UTILITY(U,$J,358.1,59,0)
	;;=BUFFALO'S DEMOGRAPHICS^^^191^0^132^17^^^2^^^Data fields - name,PID,address,SC conditions,insurance^1
	;;^UTILITY(U,$J,358.1,60,0)
	;;=BUFFALO'S DOCTORS NOTES^^^233^0^132^20^^^2^^^Data fields (w/o data) - for entering Dx,procedures,notes,findings,plan,etc.^1
	;;^UTILITY(U,$J,358.1,61,0)
	;;=BUFFALO'S PROVIDER ORDERS^^^200^0^132^21^^^2^^^Data fields (w/o data) - space to indicate orders^1
	;;^UTILITY(U,$J,358.1,62,0)
	;;=CLINIC COMMON PROBLEM LIST^^^51^0^74^11^^^1^CLINIC COMMON PROBLEM LIST^CU^Selection list - clinic's common problems^1

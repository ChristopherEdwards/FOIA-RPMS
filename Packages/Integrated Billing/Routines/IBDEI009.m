IBDEI009	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQR(358.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,358.1,63,0)
	;;=CPT CODES^^^29^0^132^10^^^1^PLEASE CHECK OFF PROCEDURES PERFORMED THIS VISIT^CU^Selection list - CPT codes^1
	;;^UTILITY(U,$J,358.1,64,0)
	;;=DIAGNOSIS CODES^^^11^44^132^10^^^1^PLEASE CHECK OFF DIAGNOSIS TREATED THIS VISIT^UC^Selection list - ICD-9 dx codes^1
	;;^UTILITY(U,$J,358.1,65,0)
	;;=EMBOSSED CARD BLOCK^^^170^0^57^20^^^1^PLACE PATIENT CARD HERE^UC^Empty block - to imprint embossed card - sized for printing 132 col, 8 lpi^1
	;;^UTILITY(U,$J,358.1,66,0)
	;;=FUTURE APPOINTMENTS - SAME DAY^^^0^0^50^7^^^1^TODAY'S LATTER APPOINTMENTS^UC^Data fields - appointments for latter in the same day^1
	;;^UTILITY(U,$J,358.1,67,0)
	;;=FUTURE APPTS - ALL^^^0^0^50^9^^^1^FUTURE APPOINTMENTS^UC^Data fields - list of patient's future appointments^1
	;;^UTILITY(U,$J,358.1,68,0)
	;;=FUTURE APPTS - SAME CLINIC^^^0^0^50^7^^^1^CLINIC'S FUTURE APPOINTMENTS^UC^Data fields - future appointments for the same clinic^1
	;;^UTILITY(U,$J,358.1,69,0)
	;;=HIDDEN SC TREATMENT QUESTIONS^^^170^60^46^2^^^2^^UC^Data fields - questions on SC of treatment - displayed only if applicable^1
	;;^UTILITY(U,$J,358.1,70,0)
	;;=OTHER NEW PROBLEMS^^^76^0^75^12^^^1^OTHER PROBLEMS^UC^Data Fields (w/o data) for adding problems not on the Clinic Common Prob. List^1
	;;^UTILITY(U,$J,358.1,71,0)
	;;=PHYSICIAN'S ORDERS^^^138^0^132^12^^^2^Physician's Orders:^^Data fields (w/o data) - for the doctor to indicate tests,consults,disposition^1
	;;^UTILITY(U,$J,358.1,73,0)
	;;=PROGRESS NOTES (UNSTRUCTURED)^^^151^0^132^11^^^2^^BUC^Data fields (w/o data) - for writting progress notes (Not in SOAP format)^1
	;;^UTILITY(U,$J,358.1,74,0)
	;;=SIGNATURE^^^75^0^132^5^^^2^^^space for signature, prints clinic name^1
	;;^UTILITY(U,$J,358.1,75,0)
	;;=SUPPLEMENTAL DEMOGRAPHICS^^^120^0^50^17^^^1^^BUC^Data fields - contains address, insurance, employment and marital data.^1
	;;^UTILITY(U,$J,358.1,76,0)
	;;=TYPE OF VISIT - 1994 CODES^^^0^0^43^21^^^1^^^Selection list - visit types with their CPT codes^1
	;;^UTILITY(U,$J,358.1,78,0)
	;;=VITAL SIGNS^^^0^0^132^4^^^1^Vital Signs:^^Data fields (w/o data) - to write in vital signs^1
	;;^UTILITY(U,$J,358.1,79,0)
	;;=YES/NO QUESTIONS^^^23^0^80^6^^^1^PLEASE ANSWER THESE QUESTIONS^UC^Selection list - for any yes/no questions^1
	;;^UTILITY(U,$J,358.1,80,0)
	;;=APPOINTMENT^7^^0^93^38^3^^^2^^UC^Contains the clinic & date/time of appointment.
	;;^UTILITY(U,$J,358.1,81,0)
	;;=ALLERGIES^7^^26^0^50^9^^^1^******  PATIENT ALLERGIES  ******^UC^Displays the patient's allergies and has space for allergies to be written in.
	;;^UTILITY(U,$J,358.1,82,0)
	;;=SUPPLEMENTAL DEMOGRAPHICS^7^^9^0^49^17^^^2^^BUC^Contains address, insurance, employment and marital data.
	;;^UTILITY(U,$J,358.1,83,0)
	;;=VITAL SIGNS^7^^5^51^79^4^^^2^Vital Signs:^^For writting in the patient's vital signs.^
	;;^UTILITY(U,$J,358.1,84,0)
	;;=BASIC DEMOGRAPHICS^7^^0^0^50^26^^^1^^BUC^Contains patient name,dob,sex,pid,SC conditions^
	;;^UTILITY(U,$J,358.1,85,0)
	;;=HIDDEN SC TREATMENT QUESTIONS^7^^78^0^46^2^^^2^^UC^Data fields - questions on SC of treatment - displayed only if applicable^
	;;^UTILITY(U,$J,358.1,86,0)
	;;=DIAGNOSIS CODES^7^^11^52^80^24^^^2^PLEASE CHECK OFF DIAGNOSIS TREATED THIS VISIT^UC^This block contains a list of ICD-9 diagnosis codes to select from.^
	;;^UTILITY(U,$J,358.1,87,0)
	;;=CPT CODES^7^^36^0^132^11^^^2^PLEASE CHECK PROCEDURES PERFORMED THIS VISIT^CU^Contains a list of CPT codes that can be selected.^
	;;^UTILITY(U,$J,358.1,88,0)
	;;=PROGRESS NOTES (SOAP)^7^^48^0^132^32^^^2^Progress Notes:   (  ) Attached  (  ) See Chart^^Patient progess notes in SOAP format.^

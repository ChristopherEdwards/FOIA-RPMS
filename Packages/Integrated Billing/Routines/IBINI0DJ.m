IBINI0DJ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3377,1,1,0)
	;;=Allows inquiry to the Category C patients number of inpatient days
	;;^UTILITY(U,$J,"OPT",3377,1,2,0)
	;;=and amounts billed.
	;;^UTILITY(U,$J,"OPT",3377,25)
	;;=IBOBCRT
	;;^UTILITY(U,$J,"OPT",3377,"U")
	;;=PATIENT BILLING CLOCK INQUIRY
	;;^UTILITY(U,$J,"OPT",3378,0)
	;;=IB CANCEL/EDIT/ADD CHARGES^Cancel/Edit/Add Patient Charges^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3378,1,0)
	;;=^^2^2^2920205^^^
	;;^UTILITY(U,$J,"OPT",3378,1,1,0)
	;;=This option will allow the user to directly cancel, edit, or add
	;;^UTILITY(U,$J,"OPT",3378,1,2,0)
	;;=to patient charges.
	;;^UTILITY(U,$J,"OPT",3378,25)
	;;=IBECEA
	;;^UTILITY(U,$J,"OPT",3378,"U")
	;;=CANCEL/EDIT/ADD PATIENT CHARGE
	;;^UTILITY(U,$J,"OPT",3380,0)
	;;=IB OUTPUT VETS BY DISCH^Veterans w/Insurance and Discharges^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3380,1,0)
	;;=^^1^1^2930712^^^^
	;;^UTILITY(U,$J,"OPT",3380,1,1,0)
	;;=List of Veteran discharges by division that are billable.
	;;^UTILITY(U,$J,"OPT",3380,25)
	;;=INPDIS^IBCONSC
	;;^UTILITY(U,$J,"OPT",3380,"U")
	;;=VETERANS W/INSURANCE AND DISCH
	;;^UTILITY(U,$J,"OPT",3381,0)
	;;=IB BACKGRND VET DISCHS W/INS^Background Vet. Patients with Discharges and Ins^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3381,1,0)
	;;=^^2^2^2940207^
	;;^UTILITY(U,$J,"OPT",3381,1,1,0)
	;;=This option may be set to be queued once per week to run and generate 
	;;^UTILITY(U,$J,"OPT",3381,1,2,0)
	;;=a list of Veterans with Insurance and Discharges.
	;;^UTILITY(U,$J,"OPT",3381,25)
	;;=EN^IBCONS1
	;;^UTILITY(U,$J,"OPT",3381,"U")
	;;=BACKGROUND VET. PATIENTS WITH 
	;;^UTILITY(U,$J,"OPT",3382,0)
	;;=IB OUTPUT CONTINUOUS PATIENTS^Patient Currently Cont. Hospitalized since 1986^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3382,1,0)
	;;=^^2^2^2920304^^^
	;;^UTILITY(U,$J,"OPT",3382,1,1,0)
	;;=This option is a list of current inpatients continuously hospitalized
	;;^UTILITY(U,$J,"OPT",3382,1,2,0)
	;;=at the same level of care since 1986.
	;;^UTILITY(U,$J,"OPT",3382,25)
	;;=IBOBCR6
	;;^UTILITY(U,$J,"OPT",3382,"U")
	;;=PATIENT CURRENTLY CONT. HOSPIT
	;;^UTILITY(U,$J,"OPT",3383,0)
	;;=IB OUTPUT MOST COMMON OPT CPT^Most Commonly used Outpatient CPT Codes^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3383,1,0)
	;;=^^3^3^2920312^^^^
	;;^UTILITY(U,$J,"OPT",3383,1,1,0)
	;;=This option will list the most common Ambulatory Procedures and 
	;;^UTILITY(U,$J,"OPT",3383,1,2,0)
	;;=Ambulatory Surgeries performed in a date range for a given set of clinics.
	;;^UTILITY(U,$J,"OPT",3383,1,3,0)
	;;=This can be used to help build the CPT Check-off Sheets.
	;;^UTILITY(U,$J,"OPT",3383,25)
	;;=IBOCNC
	;;^UTILITY(U,$J,"OPT",3383,"U")
	;;=MOST COMMONLY USED OUTPATIENT 
	;;^UTILITY(U,$J,"OPT",3384,0)
	;;=IB OUTPUT INPTS WITHOUT INS^Inpatients w/Unknown or Expired Insurance^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3384,1,0)
	;;=^^3^3^2920604^^^
	;;^UTILITY(U,$J,"OPT",3384,1,1,0)
	;;=This option will produce a list of either current inpatients or admissions
	;;^UTILITY(U,$J,"OPT",3384,1,2,0)
	;;=for a date range where the patient has either unknown insurance or the 
	;;^UTILITY(U,$J,"OPT",3384,1,3,0)
	;;=insurance is expired.
	;;^UTILITY(U,$J,"OPT",3384,25)
	;;=IBOUNP4
	;;^UTILITY(U,$J,"OPT",3384,"U")
	;;=INPATIENTS W/UNKNOWN OR EXPIRE
	;;^UTILITY(U,$J,"OPT",3385,0)
	;;=IB OUTPUT OPTS WITHOUT INS^Outpatients w/Unknown or Expired Insurance^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3385,1,0)
	;;=^^2^2^2920604^^^
	;;^UTILITY(U,$J,"OPT",3385,1,1,0)
	;;=This report will produce a list of patients for clinic appointments

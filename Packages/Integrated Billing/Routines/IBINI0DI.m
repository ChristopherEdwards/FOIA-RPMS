IBINI0DI	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3373,10,14,0)
	;;=4132^HOLD
	;;^UTILITY(U,$J,"OPT",3373,10,14,"^")
	;;=IB MT ON HOLD MENU
	;;^UTILITY(U,$J,"OPT",3373,99)
	;;=55922,52531
	;;^UTILITY(U,$J,"OPT",3373,"U")
	;;=AUTOMATED MEANS TEST BILLING M
	;;^UTILITY(U,$J,"OPT",3374,0)
	;;=IB OUTPUT MANAGEMENT REPORTS^Management Reports (Billing) Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3374,1,0)
	;;=^^2^2^2940207^^^^
	;;^UTILITY(U,$J,"OPT",3374,1,1,0)
	;;=This menu contains reports that provide statistics or lists of bills
	;;^UTILITY(U,$J,"OPT",3374,1,2,0)
	;;=that can be used in managing the Billing program.
	;;^UTILITY(U,$J,"OPT",3374,10,0)
	;;=^19.01IP^11^10
	;;^UTILITY(U,$J,"OPT",3374,10,1,0)
	;;=2513^BILL
	;;^UTILITY(U,$J,"OPT",3374,10,1,"^")
	;;=IB OUTPUT STATISTICAL REPORT
	;;^UTILITY(U,$J,"OPT",3374,10,3,0)
	;;=3346^PROD
	;;^UTILITY(U,$J,"OPT",3374,10,3,"^")
	;;=IB OUTPUT CLK PROD
	;;^UTILITY(U,$J,"OPT",3374,10,4,0)
	;;=2324^RATE
	;;^UTILITY(U,$J,"OPT",3374,10,4,"^")
	;;=IB LIST OF BILLING RATES
	;;^UTILITY(U,$J,"OPT",3374,10,5,0)
	;;=3235^RCT
	;;^UTILITY(U,$J,"OPT",3374,10,5,"^")
	;;=IB REV CODE TOTALS
	;;^UTILITY(U,$J,"OPT",3374,10,6,0)
	;;=1215^STAT
	;;^UTILITY(U,$J,"OPT",3374,10,6,"^")
	;;=IB BILL STATUS REPORT
	;;^UTILITY(U,$J,"OPT",3374,10,7,0)
	;;=1223^TOTL
	;;^UTILITY(U,$J,"OPT",3374,10,7,"^")
	;;=IB BILLING TOTALS REPORT
	;;^UTILITY(U,$J,"OPT",3374,10,8,0)
	;;=3367^TREN
	;;^UTILITY(U,$J,"OPT",3374,10,8,"^")
	;;=IB OUTPUT TREND REPORT
	;;^UTILITY(U,$J,"OPT",3374,10,9,0)
	;;=3383^COMM
	;;^UTILITY(U,$J,"OPT",3374,10,9,"^")
	;;=IB OUTPUT MOST COMMON OPT CPT
	;;^UTILITY(U,$J,"OPT",3374,10,10,0)
	;;=3402^UNBB
	;;^UTILITY(U,$J,"OPT",3374,10,10,"^")
	;;=IB OUTPUT UNBILLED BASC
	;;^UTILITY(U,$J,"OPT",3374,10,11,0)
	;;=4170^RANK
	;;^UTILITY(U,$J,"OPT",3374,10,11,"^")
	;;=IB OUTPUT RANK CARRIERS
	;;^UTILITY(U,$J,"OPT",3374,99)
	;;=55768,44400
	;;^UTILITY(U,$J,"OPT",3374,"U")
	;;=MANAGEMENT REPORTS (BILLING) M
	;;^UTILITY(U,$J,"OPT",3375,0)
	;;=IB MT CLOCK MAINTENANCE^Patient Billing Clock Maintenance^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3375,1,0)
	;;=^^1^1^2920722^^^^
	;;^UTILITY(U,$J,"OPT",3375,1,1,0)
	;;=This option will allow adding or editing of Patient Billing Clocks.
	;;^UTILITY(U,$J,"OPT",3375,20)
	;;=
	;;^UTILITY(U,$J,"OPT",3375,25)
	;;=IBEMTBC
	;;^UTILITY(U,$J,"OPT",3375,"U")
	;;=PATIENT BILLING CLOCK MAINTENA
	;;^UTILITY(U,$J,"OPT",3376,0)
	;;=IB FLAG CONTINUOUS PATIENTS^Add/Edit Pts. Continuously Hospitalized Since 1986^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3376,1,0)
	;;=^^7^7^2920722^^^
	;;^UTILITY(U,$J,"OPT",3376,1,1,0)
	;;=This option can be used to add or edit entries in the file of patient
	;;^UTILITY(U,$J,"OPT",3376,1,2,0)
	;;=continuously hospitalized since 1986.  These patients are exempt from
	;;^UTILITY(U,$J,"OPT",3376,1,3,0)
	;;=the co-payment portion of the means test but may still be charged the
	;;^UTILITY(U,$J,"OPT",3376,1,4,0)
	;;=per diem.  The automated category C billing software will exempt these
	;;^UTILITY(U,$J,"OPT",3376,1,5,0)
	;;=patients from the co-payments.  In order to be considered continuously 
	;;^UTILITY(U,$J,"OPT",3376,1,6,0)
	;;=hospitalized the patient must not have changed levels of care, i.e., gone
	;;^UTILITY(U,$J,"OPT",3376,1,7,0)
	;;=from a NHCU to the hospital.
	;;^UTILITY(U,$J,"OPT",3376,25)
	;;=IBECPF
	;;^UTILITY(U,$J,"OPT",3376,"U")
	;;=ADD/EDIT PTS. CONTINUOUSLY HOS
	;;^UTILITY(U,$J,"OPT",3377,0)
	;;=IB MT CLOCK INQUIRY^Patient Billing Clock Inquiry^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3377,1,0)
	;;=^^2^2^2920722^^^

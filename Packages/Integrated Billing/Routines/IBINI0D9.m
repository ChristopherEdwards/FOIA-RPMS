IBINI0D9	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",2328,1,0)
	;;=^^2^2^2900606^^
	;;^UTILITY(U,$J,"OPT",2328,1,1,0)
	;;=This option will allow users to edit a bill that has been returned from
	;;^UTILITY(U,$J,"OPT",2328,1,2,0)
	;;=AR to MCCR and return it back to A/R
	;;^UTILITY(U,$J,"OPT",2328,25)
	;;=EN1^IBCRTN
	;;^UTILITY(U,$J,"OPT",2328,"U")
	;;=EDIT RETURNED BILL
	;;^UTILITY(U,$J,"OPT",2329,0)
	;;=IB RETURN BILL^Return Bill to A/R^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2329,1,0)
	;;=^^2^2^2940207^^^
	;;^UTILITY(U,$J,"OPT",2329,1,1,0)
	;;=This option will allow users to return a bill from MCCR to AR if it
	;;^UTILITY(U,$J,"OPT",2329,1,2,0)
	;;=had previously been returned to MCCR from AR.
	;;^UTILITY(U,$J,"OPT",2329,25)
	;;=EN2^IBCRTN
	;;^UTILITY(U,$J,"OPT",2329,"U")
	;;=RETURN BILL TO A/R
	;;^UTILITY(U,$J,"OPT",2330,0)
	;;=IB BACKGRND VETS INPT W/INS^Background Vet. Patients with Admissions and Ins^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2330,1,0)
	;;=^^2^2^2940207^^^^
	;;^UTILITY(U,$J,"OPT",2330,1,1,0)
	;;=This option may be set to be queued once per week to run and generate 
	;;^UTILITY(U,$J,"OPT",2330,1,2,0)
	;;=a list of Veterans with Insurance and Admissions.
	;;^UTILITY(U,$J,"OPT",2330,25)
	;;=EN1^IBCONS1
	;;^UTILITY(U,$J,"OPT",2330,"U")
	;;=BACKGROUND VET. PATIENTS WITH 
	;;^UTILITY(U,$J,"OPT",2331,0)
	;;=IB BACKGRND VETS OPT W/INS^Background Vet. Patients with Opt. Visits and Ins^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2331,1,0)
	;;=^^2^2^2930712^^^^
	;;^UTILITY(U,$J,"OPT",2331,1,1,0)
	;;=This option may be set to be queued once per week to run and generate
	;;^UTILITY(U,$J,"OPT",2331,1,2,0)
	;;=a list of Veterans with Insurance and Outpatient Visits.
	;;^UTILITY(U,$J,"OPT",2331,25)
	;;=EN2^IBCONS1
	;;^UTILITY(U,$J,"OPT",2331,"U")
	;;=BACKGROUND VET. PATIENTS WITH 
	;;^UTILITY(U,$J,"OPT",2335,0)
	;;=IB RETURN BILL MENU^Return Bill Menu^^M^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",2335,1,0)
	;;=^^2^2^2900806^^
	;;^UTILITY(U,$J,"OPT",2335,1,1,0)
	;;=Menu to access options related to editing bills returned by A/R to 
	;;^UTILITY(U,$J,"OPT",2335,1,2,0)
	;;=MCCR and returning them to A/R.
	;;^UTILITY(U,$J,"OPT",2335,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",2335,10,1,0)
	;;=2329^RETN
	;;^UTILITY(U,$J,"OPT",2335,10,1,"^")
	;;=IB RETURN BILL
	;;^UTILITY(U,$J,"OPT",2335,10,2,0)
	;;=2320^LIST
	;;^UTILITY(U,$J,"OPT",2335,10,2,"^")
	;;=IB RETURN BILL LIST
	;;^UTILITY(U,$J,"OPT",2335,10,3,0)
	;;=2328^EDIT
	;;^UTILITY(U,$J,"OPT",2335,10,3,"^")
	;;=IB EDIT RETURNED BILL
	;;^UTILITY(U,$J,"OPT",2335,20)
	;;=I $D(^%ZOSF("TEST")) S X="PRCAUT2" X ^%ZOSF("TEST") I $T D COUNT^PRCAUT2
	;;^UTILITY(U,$J,"OPT",2335,99)
	;;=55265,49227
	;;^UTILITY(U,$J,"OPT",2335,"U")
	;;=RETURN BILL MENU
	;;^UTILITY(U,$J,"OPT",2406,0)
	;;=IB BILLING SUPERVISOR MENU^Billing Supervisor Menu^^M^^IB SUPERVISOR^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",2406,1,0)
	;;=^^4^4^2940125^^^^
	;;^UTILITY(U,$J,"OPT",2406,1,1,0)
	;;=This menu contains all of the Medical Care Cost Recovery
	;;^UTILITY(U,$J,"OPT",2406,1,2,0)
	;;=Billing Module options.  Through this option, a user may
	;;^UTILITY(U,$J,"OPT",2406,1,3,0)
	;;=accomplish every phase of the billing process and access all
	;;^UTILITY(U,$J,"OPT",2406,1,4,0)
	;;=billing reports.
	;;^UTILITY(U,$J,"OPT",2406,10,0)
	;;=^19.01PI^19^8
	;;^UTILITY(U,$J,"OPT",2406,10,11,0)
	;;=1221^SYST
	;;^UTILITY(U,$J,"OPT",2406,10,11,"^")
	;;=IB SYSTEM DEFINITION MENU
	;;^UTILITY(U,$J,"OPT",2406,10,12,0)
	;;=3372^UB82
	;;^UTILITY(U,$J,"OPT",2406,10,12,"^")
	;;=IB THIRD PARTY BILLING MENU

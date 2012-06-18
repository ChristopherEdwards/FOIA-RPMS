IBINI0DL	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3434,1,4,0)
	;;=  #351  CATEGORY C BILLING CLOCK
	;;^UTILITY(U,$J,"OPT",3434,1,5,0)
	;;=  #399  BILL/CLAIMS
	;;^UTILITY(U,$J,"OPT",3434,1,6,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3434,1,7,0)
	;;=Entries from these files must be found, and placed in the appropriate
	;;^UTILITY(U,$J,"OPT",3434,1,8,0)
	;;=Search (Sort) template, before they may be archived.
	;;^UTILITY(U,$J,"OPT",3434,25)
	;;=ARCHIVE^IBP
	;;^UTILITY(U,$J,"OPT",3434,"U")
	;;=ARCHIVE BILLING DATA
	;;^UTILITY(U,$J,"OPT",3435,0)
	;;=IB PURGE BILLING DATA^Purge Billing Data^^R^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3435,1,0)
	;;=^^7^7^2940207^^^
	;;^UTILITY(U,$J,"OPT",3435,1,1,0)
	;;=This option may be used to purge data from the following files:
	;;^UTILITY(U,$J,"OPT",3435,1,2,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3435,1,3,0)
	;;=  #350  INTEGRATED BILLING ACTION
	;;^UTILITY(U,$J,"OPT",3435,1,4,0)
	;;=  #351  CATEGORY C BILLING CLOCK
	;;^UTILITY(U,$J,"OPT",3435,1,5,0)
	;;=  #399  BILL/CLAIMS
	;;^UTILITY(U,$J,"OPT",3435,1,6,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3435,1,7,0)
	;;=Entries from these files must be archived before they may be purged.
	;;^UTILITY(U,$J,"OPT",3435,25)
	;;=PURGE^IBP
	;;^UTILITY(U,$J,"OPT",3435,"U")
	;;=PURGE BILLING DATA
	;;^UTILITY(U,$J,"OPT",3436,0)
	;;=IB MT RELEASE CHARGES^Release Charges 'On Hold'^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3436,1,0)
	;;=^^9^9^2930826^^
	;;^UTILITY(U,$J,"OPT",3436,1,1,0)
	;;=This option is used to release Category C charges which are 'on hold'
	;;^UTILITY(U,$J,"OPT",3436,1,2,0)
	;;=awaiting claim disposition from the patient's insurance company.  Any
	;;^UTILITY(U,$J,"OPT",3436,1,3,0)
	;;=held up charges for a patient (which is specified by the user) may be
	;;^UTILITY(U,$J,"OPT",3436,1,4,0)
	;;=selected and passed to Accounts Receivable.  This option will also be
	;;^UTILITY(U,$J,"OPT",3436,1,5,0)
	;;=accessed from the 'Enter a Payment' option in the Accounts Receivable
	;;^UTILITY(U,$J,"OPT",3436,1,6,0)
	;;=package.  If the user posts a payment from an insurance company for a
	;;^UTILITY(U,$J,"OPT",3436,1,7,0)
	;;=bill which has any 'held' charges associated with it, the user may opt
	;;^UTILITY(U,$J,"OPT",3436,1,8,0)
	;;=to select any of the charges to pass to Accounts Receivable in order to
	;;^UTILITY(U,$J,"OPT",3436,1,9,0)
	;;=post a portion of the insurance company's payment to the patient's bill.
	;;^UTILITY(U,$J,"OPT",3436,25)
	;;=IBRREL
	;;^UTILITY(U,$J,"OPT",3436,"U")
	;;=RELEASE CHARGES 'ON HOLD'
	;;^UTILITY(U,$J,"OPT",3437,0)
	;;=IB OUTPUT HELD CHARGES^Held Charges Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3437,1,0)
	;;=^^4^4^2920415^^^
	;;^UTILITY(U,$J,"OPT",3437,1,1,0)
	;;=This option produces the Held Charges Report.  The report lists all
	;;^UTILITY(U,$J,"OPT",3437,1,2,0)
	;;=charges having the status of ON HOLD.  With each charge is listed bills
	;;^UTILITY(U,$J,"OPT",3437,1,3,0)
	;;=that are for the same outpatient visit or the same inpatient admission
	;;^UTILITY(U,$J,"OPT",3437,1,4,0)
	;;=with an overlap in the period covered.
	;;^UTILITY(U,$J,"OPT",3437,25)
	;;=MAIN^IBOHLD1
	;;^UTILITY(U,$J,"OPT",3437,"U")
	;;=HELD CHARGES REPORT
	;;^UTILITY(U,$J,"OPT",3537,0)
	;;=IB OUTPUT EVENTS REPORT^Outpatient/Registration Events Report^^R^^^^^^n^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3537,1,0)
	;;=^^2^2^2920609^^^^
	;;^UTILITY(U,$J,"OPT",3537,1,1,0)
	;;=Report of clinic check-ins, stop codes, registrations, and charges for
	;;^UTILITY(U,$J,"OPT",3537,1,2,0)
	;;=Category C patients.
	;;^UTILITY(U,$J,"OPT",3537,25)
	;;=IBOVOP

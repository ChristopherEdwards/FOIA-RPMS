IBINI0E4	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4185,1,3,0)
	;;=Information, Billing information (from Claims Tracking), Hospital Review
	;;^UTILITY(U,$J,"OPT",4185,1,4,0)
	;;=information and Insurance Review information.  Also included is provider,
	;;^UTILITY(U,$J,"OPT",4185,1,5,0)
	;;=diagnosis, and procedure information.
	;;^UTILITY(U,$J,"OPT",4185,1,6,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4185,1,7,0)
	;;=This report is the most complete summary of information about a single
	;;^UTILITY(U,$J,"OPT",4185,1,8,0)
	;;=visit available in Claims Tracking.
	;;^UTILITY(U,$J,"OPT",4185,25)
	;;=IBTOBI
	;;^UTILITY(U,$J,"OPT",4185,"U")
	;;=PRINT CT SUMMARY FOR BILLING
	;;^UTILITY(U,$J,"OPT",4186,0)
	;;=IBT OUTPUT REVIEW WORKSHEET^Review Worksheet Print^^R^^^^^^^^CLAIMS TRACKING (IB)
	;;^UTILITY(U,$J,"OPT",4186,1,0)
	;;=^^3^3^2931110^^
	;;^UTILITY(U,$J,"OPT",4186,1,1,0)
	;;=This option will print an Insurance Review worksheet for the selected 
	;;^UTILITY(U,$J,"OPT",4186,1,2,0)
	;;=patient.  If the patient is currently an inpatient, it will contain
	;;^UTILITY(U,$J,"OPT",4186,1,3,0)
	;;=the current inpatient information.  
	;;^UTILITY(U,$J,"OPT",4186,25)
	;;=RWM^IBTRC4
	;;^UTILITY(U,$J,"OPT",4186,"U")
	;;=REVIEW WORKSHEET PRINT
	;;^UTILITY(U,$J,"OPT",4187,0)
	;;=IBCN LIST INACTIVE INS W/PAT^List Inactive Ins. Co. Covering Patients^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4187,1,0)
	;;=^^5^5^2931104^
	;;^UTILITY(U,$J,"OPT",4187,1,1,0)
	;;=This option will list inactive insurance companies that have patients
	;;^UTILITY(U,$J,"OPT",4187,1,2,0)
	;;=listed as having this company as an insurer.  Run this report and then
	;;^UTILITY(U,$J,"OPT",4187,1,3,0)
	;;=use the Insurance Company Edit option and choose the (In)Activate Company
	;;^UTILITY(U,$J,"OPT",4187,1,4,0)
	;;=action to repoint those patients to a valid insurance company.
	;;^UTILITY(U,$J,"OPT",4187,1,5,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4187,25)
	;;=IBCOC
	;;^UTILITY(U,$J,"OPT",4187,99)
	;;=55825,41918
	;;^UTILITY(U,$J,"OPT",4187,"U")
	;;=LIST INACTIVE INS. CO. COVERIN
	;;^UTILITY(U,$J,"OPT",4244,0)
	;;=IB UB-92 TEST PATTERN PRINT^UB-92 Test Pattern Print^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",4244,1,0)
	;;=^^1^1^2931110^
	;;^UTILITY(U,$J,"OPT",4244,1,1,0)
	;;=Prints a test UB-92.  Generally used to assist setting up a printer.
	;;^UTILITY(U,$J,"OPT",4244,25)
	;;=IBCF3TP
	;;^UTILITY(U,$J,"OPT",4244,"U")
	;;=UB-92 TEST PATTERN PRINT
	;;^UTILITY(U,$J,"OPT",4245,0)
	;;=IBDF MISCELLANEOUS CLEANUP^Miscellaneous Cleanup^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4245,1,0)
	;;=^^6^6^2940202^^
	;;^UTILITY(U,$J,"OPT",4245,1,1,0)
	;;=This option is intended to delete various data structures that are no longer
	;;^UTILITY(U,$J,"OPT",4245,1,2,0)
	;;=in use.  The Encounter Form Utilties were designed to automatically delete all
	;;^UTILITY(U,$J,"OPT",4245,1,3,0)
	;;=data structures when no longer needed, so this option is a backup that should
	;;^UTILITY(U,$J,"OPT",4245,1,4,0)
	;;=rarely be needed.  Currently, the option deletes the compiled version of forms
	;;^UTILITY(U,$J,"OPT",4245,1,5,0)
	;;=where the form itself no longer exists.  It also deletes blocks that do not
	;;^UTILITY(U,$J,"OPT",4245,1,6,0)
	;;=belong to any form.
	;;^UTILITY(U,$J,"OPT",4245,20)
	;;=D GARBAGE^IBDF19
	;;^UTILITY(U,$J,"OPT",4245,"U")
	;;=MISCELLANEOUS CLEANUP
	;;^UTILITY(U,$J,"OPT",4246,0)
	;;=IBCN LIST NEW NOT VER^List New not Verified Policies^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4246,1,0)
	;;=^^4^4^2931129^
	;;^UTILITY(U,$J,"OPT",4246,1,1,0)
	;;=This option will list by patient new insurance entries that have never

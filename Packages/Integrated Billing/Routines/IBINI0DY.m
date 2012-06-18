IBINI0DY	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4150,1,2,0)
	;;=date range.  It will summarize totals by admission or discharge, cases
	;;^UTILITY(U,$J,"OPT",4150,1,3,0)
	;;=with insurance, billable inpatient cases, cases requiring reviews,
	;;^UTILITY(U,$J,"OPT",4150,1,4,0)
	;;=days approved, amount collectible approved for billing, number of days
	;;^UTILITY(U,$J,"OPT",4150,1,5,0)
	;;=denied, amount denied, and penalty dollars.
	;;^UTILITY(U,$J,"OPT",4150,1,6,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4150,10,0)
	;;=^19.01PI^0^0
	;;^UTILITY(U,$J,"OPT",4150,25)
	;;=IBTOSUM
	;;^UTILITY(U,$J,"OPT",4150,"U")
	;;=MCCR/UR SUMMARY REPORT
	;;^UTILITY(U,$J,"OPT",4151,0)
	;;=IBT OUTPUT PENDING ITEMS^Pending Work Report^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4151,1,0)
	;;=^^3^3^2931110^
	;;^UTILITY(U,$J,"OPT",4151,1,1,0)
	;;=This option will print a sorted list of Pending Reviews.  It is  
	;;^UTILITY(U,$J,"OPT",4151,1,2,0)
	;;=different from printing from the Pending Reviews option in that it
	;;^UTILITY(U,$J,"OPT",4151,1,3,0)
	;;=will limit the entries to just those you care to see.
	;;^UTILITY(U,$J,"OPT",4151,25)
	;;=IBTOPW
	;;^UTILITY(U,$J,"OPT",4151,"U")
	;;=PENDING WORK REPORT
	;;^UTILITY(U,$J,"OPT",4152,0)
	;;=IBT MANAGER MENU^Claims Tracking Master Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4152,1,0)
	;;=^^2^2^2940207^^^^
	;;^UTILITY(U,$J,"OPT",4152,1,1,0)
	;;=This is the main claims tracking menu.  It contains the various
	;;^UTILITY(U,$J,"OPT",4152,1,2,0)
	;;=user menus that can be assigned directly to UR or MCCR/UR personnel.
	;;^UTILITY(U,$J,"OPT",4152,10,0)
	;;=^19.01PI^4^4
	;;^UTILITY(U,$J,"OPT",4152,10,1,0)
	;;=4135^CT
	;;^UTILITY(U,$J,"OPT",4152,10,1,"^")
	;;=IBT USER COMBINED MCCR/UR MENU
	;;^UTILITY(U,$J,"OPT",4152,10,2,0)
	;;=4153^HR
	;;^UTILITY(U,$J,"OPT",4152,10,2,"^")
	;;=IBT USER MENU (HR)
	;;^UTILITY(U,$J,"OPT",4152,10,3,0)
	;;=4154^IR
	;;^UTILITY(U,$J,"OPT",4152,10,3,"^")
	;;=IBT USER MENU (IR)
	;;^UTILITY(U,$J,"OPT",4152,10,4,0)
	;;=4182^BI
	;;^UTILITY(U,$J,"OPT",4152,10,4,"^")
	;;=IBT USER MENU (BI)
	;;^UTILITY(U,$J,"OPT",4152,99)
	;;=55936,47661
	;;^UTILITY(U,$J,"OPT",4152,"U")
	;;=CLAIMS TRACKING MASTER MENU
	;;^UTILITY(U,$J,"OPT",4153,0)
	;;=IBT USER MENU (HR)^Claims Tracking Menu (Hospital Reviews)^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4153,1,0)
	;;=^^7^7^2940207^^^^
	;;^UTILITY(U,$J,"OPT",4153,1,1,0)
	;;=This is the main menu for UR personnel to enter Hospital Reviews into
	;;^UTILITY(U,$J,"OPT",4153,1,2,0)
	;;=the Claims Tracking Module.
	;;^UTILITY(U,$J,"OPT",4153,1,3,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4153,1,4,0)
	;;=From the menu the claims tracking module can be edited, UR Reviews can
	;;^UTILITY(U,$J,"OPT",4153,1,5,0)
	;;=be entered and reports printed.  
	;;^UTILITY(U,$J,"OPT",4153,1,6,0)
	;;=Supervisory functions will be available to those who hold the 
	;;^UTILITY(U,$J,"OPT",4153,1,7,0)
	;;=supervisory keys.
	;;^UTILITY(U,$J,"OPT",4153,10,0)
	;;=^19.01PI^9^7
	;;^UTILITY(U,$J,"OPT",4153,10,1,0)
	;;=4143^IC
	;;^UTILITY(U,$J,"OPT",4153,10,1,"^")
	;;=IBT OUTPUT CLAIM INQUIRY
	;;^UTILITY(U,$J,"OPT",4153,10,4,0)
	;;=4141^RM
	;;^UTILITY(U,$J,"OPT",4153,10,4,"^")
	;;=IBT OUTPUT MENU
	;;^UTILITY(U,$J,"OPT",4153,10,5,0)
	;;=4138^HR
	;;^UTILITY(U,$J,"OPT",4153,10,5,"^")
	;;=IBT EDIT REVIEWS
	;;^UTILITY(U,$J,"OPT",4153,10,6,0)
	;;=4136^SP
	;;^UTILITY(U,$J,"OPT",4153,10,6,"^")
	;;=IBT OUTPUT ONE ADMISSION SHEET
	;;^UTILITY(U,$J,"OPT",4153,10,7,0)
	;;=4142^SM
	;;^UTILITY(U,$J,"OPT",4153,10,7,"^")
	;;=IBT SUPERVISORS MENU
	;;^UTILITY(U,$J,"OPT",4153,10,8,0)
	;;=4155^PR^10

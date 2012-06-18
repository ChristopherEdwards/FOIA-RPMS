IBINI0DV	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4135,10,2,0)
	;;=4137^CT^20
	;;^UTILITY(U,$J,"OPT",4135,10,2,"^")
	;;=IBT EDIT TRACKING ENTRY
	;;^UTILITY(U,$J,"OPT",4135,10,4,0)
	;;=4138^HR^99
	;;^UTILITY(U,$J,"OPT",4135,10,4,"^")
	;;=IBT EDIT REVIEWS
	;;^UTILITY(U,$J,"OPT",4135,10,6,0)
	;;=4139^IR^50
	;;^UTILITY(U,$J,"OPT",4135,10,6,"^")
	;;=IBT EDIT COMMUNICATIONS
	;;^UTILITY(U,$J,"OPT",4135,10,7,0)
	;;=4140^AD^70
	;;^UTILITY(U,$J,"OPT",4135,10,7,"^")
	;;=IBT EDIT APPEALS/DENIALS
	;;^UTILITY(U,$J,"OPT",4135,10,9,0)
	;;=4141^RM^96
	;;^UTILITY(U,$J,"OPT",4135,10,9,"^")
	;;=IBT OUTPUT MENU
	;;^UTILITY(U,$J,"OPT",4135,10,10,0)
	;;=4142^SM^93
	;;^UTILITY(U,$J,"OPT",4135,10,10,"^")
	;;=IBT SUPERVISORS MENU
	;;^UTILITY(U,$J,"OPT",4135,10,11,0)
	;;=4143^IC^90
	;;^UTILITY(U,$J,"OPT",4135,10,11,"^")
	;;=IBT OUTPUT CLAIM INQUIRY
	;;^UTILITY(U,$J,"OPT",4135,10,13,0)
	;;=4145^PR^10
	;;^UTILITY(U,$J,"OPT",4135,10,13,"^")
	;;=IBT EDIT REVIEWS TO DO
	;;^UTILITY(U,$J,"OPT",4135,99)
	;;=55825,69299
	;;^UTILITY(U,$J,"OPT",4135,"U")
	;;=CLAIMS TRACKING MENU (COMBINED
	;;^UTILITY(U,$J,"OPT",4136,0)
	;;=IBT OUTPUT ONE ADMISSION SHEET^Single Patient Admission Sheet^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4136,1,0)
	;;=^^3^3^2930627^^
	;;^UTILITY(U,$J,"OPT",4136,1,1,0)
	;;=This option will print an admission sheet for one patient one
	;;^UTILITY(U,$J,"OPT",4136,1,2,0)
	;;=admission at a time.  It can be used to reprint an admission sheet
	;;^UTILITY(U,$J,"OPT",4136,1,3,0)
	;;=if needed.
	;;^UTILITY(U,$J,"OPT",4136,25)
	;;=IBTOAT
	;;^UTILITY(U,$J,"OPT",4136,"U")
	;;=SINGLE PATIENT ADMISSION SHEET
	;;^UTILITY(U,$J,"OPT",4137,0)
	;;=IBT EDIT TRACKING ENTRY^Claims Tracking Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4137,1,0)
	;;=^^3^3^2930907^^
	;;^UTILITY(U,$J,"OPT",4137,1,1,0)
	;;=This option allows enter/editing of Claims Tracking Entries.  Data
	;;^UTILITY(U,$J,"OPT",4137,1,2,0)
	;;=associated with a CT entry may affect if or how it is billed and the
	;;^UTILITY(U,$J,"OPT",4137,1,3,0)
	;;=types of reviews that may be or must be entered.
	;;^UTILITY(U,$J,"OPT",4137,25)
	;;=IBTRE
	;;^UTILITY(U,$J,"OPT",4137,"U")
	;;=CLAIMS TRACKING EDIT
	;;^UTILITY(U,$J,"OPT",4138,0)
	;;=IBT EDIT REVIEWS^Hospital Reviews^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4138,1,0)
	;;=^^3^3^2930819^^^
	;;^UTILITY(U,$J,"OPT",4138,1,1,0)
	;;=This option allows viewing and editing of UR reviews of claims
	;;^UTILITY(U,$J,"OPT",4138,1,2,0)
	;;=tracking entries.  This includes pre-admission/pre-certification
	;;^UTILITY(U,$J,"OPT",4138,1,3,0)
	;;=reviews, continuing stay reviews, and discharge reviews.
	;;^UTILITY(U,$J,"OPT",4138,25)
	;;=IBTRV
	;;^UTILITY(U,$J,"OPT",4138,"U")
	;;=HOSPITAL REVIEWS
	;;^UTILITY(U,$J,"OPT",4139,0)
	;;=IBT EDIT COMMUNICATIONS^Insurance Review Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4139,1,0)
	;;=^^2^2^2940307^^^
	;;^UTILITY(U,$J,"OPT",4139,1,1,0)
	;;=This option allows enter/editing of MCCR/UR related communications that
	;;^UTILITY(U,$J,"OPT",4139,1,2,0)
	;;=may or may not be associated with a claims tracking entry.
	;;^UTILITY(U,$J,"OPT",4139,25)
	;;=IBTRC
	;;^UTILITY(U,$J,"OPT",4139,"U")
	;;=INSURANCE REVIEW EDIT
	;;^UTILITY(U,$J,"OPT",4140,0)
	;;=IBT EDIT APPEALS/DENIALS^Appeal/Denial Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4140,1,0)
	;;=^^2^2^2930627^
	;;^UTILITY(U,$J,"OPT",4140,1,1,0)
	;;=This option allows for enter/editing appeals and denials and associated
	;;^UTILITY(U,$J,"OPT",4140,1,2,0)
	;;=communications.
	;;^UTILITY(U,$J,"OPT",4140,25)
	;;=IBTRD
	;;^UTILITY(U,$J,"OPT",4140,"U")
	;;=APPEAL/DENIAL EDIT

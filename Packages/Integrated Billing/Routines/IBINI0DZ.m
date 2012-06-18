IBINI0DZ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4153,10,8,"^")
	;;=IBT EDIT HR REVIEWS TO DO
	;;^UTILITY(U,$J,"OPT",4153,10,9,0)
	;;=4168^CT
	;;^UTILITY(U,$J,"OPT",4153,10,9,"^")
	;;=IBT EDIT HR TRACKING ENTRY
	;;^UTILITY(U,$J,"OPT",4153,99)
	;;=55825,69301
	;;^UTILITY(U,$J,"OPT",4153,"U")
	;;=CLAIMS TRACKING MENU (HOSPITAL
	;;^UTILITY(U,$J,"OPT",4154,0)
	;;=IBT USER MENU (IR)^Claims Tracking Menu (Insurance Reviews)^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4154,1,0)
	;;=^^7^7^2930826^^^
	;;^UTILITY(U,$J,"OPT",4154,1,1,0)
	;;=This is the main menu for MCCR/UR persons who do MCCR/UR Reviews 
	;;^UTILITY(U,$J,"OPT",4154,1,2,0)
	;;=(Insurance Reviews).
	;;^UTILITY(U,$J,"OPT",4154,1,3,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4154,1,4,0)
	;;=From the menu the claims tracking module can be edited, 
	;;^UTILITY(U,$J,"OPT",4154,1,5,0)
	;;=Insurance Reviews can be entered and reports printed.  
	;;^UTILITY(U,$J,"OPT",4154,1,6,0)
	;;=Supervisory functions will be available to those who hold the 
	;;^UTILITY(U,$J,"OPT",4154,1,7,0)
	;;=supervisory keys.
	;;^UTILITY(U,$J,"OPT",4154,10,0)
	;;=^19.01PI^12^8
	;;^UTILITY(U,$J,"OPT",4154,10,1,0)
	;;=4140^AD
	;;^UTILITY(U,$J,"OPT",4154,10,1,"^")
	;;=IBT EDIT APPEALS/DENIALS
	;;^UTILITY(U,$J,"OPT",4154,10,2,0)
	;;=4139^IR
	;;^UTILITY(U,$J,"OPT",4154,10,2,"^")
	;;=IBT EDIT COMMUNICATIONS
	;;^UTILITY(U,$J,"OPT",4154,10,4,0)
	;;=4143^IC
	;;^UTILITY(U,$J,"OPT",4154,10,4,"^")
	;;=IBT OUTPUT CLAIM INQUIRY
	;;^UTILITY(U,$J,"OPT",4154,10,8,0)
	;;=4141^RM
	;;^UTILITY(U,$J,"OPT",4154,10,8,"^")
	;;=IBT OUTPUT MENU
	;;^UTILITY(U,$J,"OPT",4154,10,9,0)
	;;=4142^SM
	;;^UTILITY(U,$J,"OPT",4154,10,9,"^")
	;;=IBT SUPERVISORS MENU
	;;^UTILITY(U,$J,"OPT",4154,10,10,0)
	;;=4136^SP
	;;^UTILITY(U,$J,"OPT",4154,10,10,"^")
	;;=IBT OUTPUT ONE ADMISSION SHEET
	;;^UTILITY(U,$J,"OPT",4154,10,11,0)
	;;=4156^PR^10
	;;^UTILITY(U,$J,"OPT",4154,10,11,"^")
	;;=IBT EDIT IR REVIEWS TO DO
	;;^UTILITY(U,$J,"OPT",4154,10,12,0)
	;;=4167^CT
	;;^UTILITY(U,$J,"OPT",4154,10,12,"^")
	;;=IBT EDIT IR TRACKING ENTRY
	;;^UTILITY(U,$J,"OPT",4154,99)
	;;=55825,69301
	;;^UTILITY(U,$J,"OPT",4154,"U")
	;;=CLAIMS TRACKING MENU (INSURANC
	;;^UTILITY(U,$J,"OPT",4155,0)
	;;=IBT EDIT HR REVIEWS TO DO^Pending Reviews^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4155,1,0)
	;;=^^3^3^2940211^^^^
	;;^UTILITY(U,$J,"OPT",4155,1,1,0)
	;;=This option will create a list of pending work for Hospital UR
	;;^UTILITY(U,$J,"OPT",4155,1,2,0)
	;;=personnel who do QM reviews.  From this option most all screens and
	;;^UTILITY(U,$J,"OPT",4155,1,3,0)
	;;=options needed to do the daily input are available.
	;;^UTILITY(U,$J,"OPT",4155,20)
	;;=S IBTRPRF=1 D ^IBTRPR K IBTRPRF
	;;^UTILITY(U,$J,"OPT",4155,"U")
	;;=PENDING REVIEWS
	;;^UTILITY(U,$J,"OPT",4156,0)
	;;=IBT EDIT IR REVIEWS TO DO^Pending Reviews^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4156,1,0)
	;;=^^3^3^2940211^^^^
	;;^UTILITY(U,$J,"OPT",4156,1,1,0)
	;;=This option will create a list of pending reviews that Insurance
	;;^UTILITY(U,$J,"OPT",4156,1,2,0)
	;;=Review personnel need to complete.  Most of the input screens and
	;;^UTILITY(U,$J,"OPT",4156,1,3,0)
	;;=options needed to do the daily work are available from this option.
	;;^UTILITY(U,$J,"OPT",4156,20)
	;;=S IBTRPRF=2 D ^IBTRPR K IBTRPRF
	;;^UTILITY(U,$J,"OPT",4156,"U")
	;;=PENDING REVIEWS
	;;^UTILITY(U,$J,"OPT",4157,0)
	;;=IBT SUP MANUALLY QUE RX FILLS^Manually Add Rx Refills to Claims Tracking^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4157,1,0)
	;;=^^3^3^2940207^^^
	;;^UTILITY(U,$J,"OPT",4157,1,1,0)
	;;=This option can be used to manually add rx refills to Claims tracking.

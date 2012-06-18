IBINI0DA	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",2406,10,13,0)
	;;=3373^CATC
	;;^UTILITY(U,$J,"OPT",2406,10,13,"^")
	;;=IB MEANS TEST MENU
	;;^UTILITY(U,$J,"OPT",2406,10,14,0)
	;;=2523^OUTP
	;;^UTILITY(U,$J,"OPT",2406,10,14,"^")
	;;=IB OUTPUT PATIENT REPORT MENU
	;;^UTILITY(U,$J,"OPT",2406,10,15,0)
	;;=3374^REPT
	;;^UTILITY(U,$J,"OPT",2406,10,15,"^")
	;;=IB OUTPUT MANAGEMENT REPORTS
	;;^UTILITY(U,$J,"OPT",2406,10,17,0)
	;;=1208^BILL
	;;^UTILITY(U,$J,"OPT",2406,10,17,"^")
	;;=IB EDIT BILLING INFO
	;;^UTILITY(U,$J,"OPT",2406,10,18,0)
	;;=3941^RXEX
	;;^UTILITY(U,$J,"OPT",2406,10,18,"^")
	;;=IB RX EXEMPTION MENU
	;;^UTILITY(U,$J,"OPT",2406,10,19,0)
	;;=4182^BI
	;;^UTILITY(U,$J,"OPT",2406,10,19,"^")
	;;=IBT USER MENU (BI)
	;;^UTILITY(U,$J,"OPT",2406,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2406,20)
	;;=I $D(^%ZOSF("TEST")) S X="PRCAUT2" X ^%ZOSF("TEST") I $T D COUNT^PRCAUT2
	;;^UTILITY(U,$J,"OPT",2406,99)
	;;=55907,52875
	;;^UTILITY(U,$J,"OPT",2406,99.1)
	;;=54444,49832
	;;^UTILITY(U,$J,"OPT",2406,"U")
	;;=BILLING SUPERVISOR MENU
	;;^UTILITY(U,$J,"OPT",2480,0)
	;;=IB EDIT SITE PARAMETERS^Enter/Edit IB Site Parameters^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2480,1,0)
	;;=^^3^3^2920109^^^^
	;;^UTILITY(U,$J,"OPT",2480,1,1,0)
	;;=This option allows entering and editing of Integrated Billing Site
	;;^UTILITY(U,$J,"OPT",2480,1,2,0)
	;;=Parameter file.  Modifying the site parameters can affect the performance
	;;^UTILITY(U,$J,"OPT",2480,1,3,0)
	;;=of Integrated Billing's background filer.
	;;^UTILITY(U,$J,"OPT",2480,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2480,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2480,25)
	;;=EDIT^IBEFUTL
	;;^UTILITY(U,$J,"OPT",2480,"U")
	;;=ENTER/EDIT IB SITE PARAMETERS
	;;^UTILITY(U,$J,"OPT",2481,0)
	;;=IB SITE STATUS DISPLAY^Display Integrated Billing Status^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2481,1,0)
	;;=^^2^2^2910416^^
	;;^UTILITY(U,$J,"OPT",2481,1,1,0)
	;;=This option displays information from the IB site parameter file and
	;;^UTILITY(U,$J,"OPT",2481,1,2,0)
	;;=pertinent information about the status of the IB background filer.
	;;^UTILITY(U,$J,"OPT",2481,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2481,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2481,25)
	;;=IBESTAT
	;;^UTILITY(U,$J,"OPT",2481,"U")
	;;=DISPLAY INTEGRATED BILLING STA
	;;^UTILITY(U,$J,"OPT",2482,0)
	;;=IB FILER STOP^Stop the Integrated Billing Background Filer^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2482,1,0)
	;;=^^3^3^2910304^
	;;^UTILITY(U,$J,"OPT",2482,1,1,0)
	;;=This option will cause the IB background filer to cease when it has
	;;^UTILITY(U,$J,"OPT",2482,1,2,0)
	;;=finished processing all its known transactions.  Processing with
	;;^UTILITY(U,$J,"OPT",2482,1,3,0)
	;;=Accounts Receivable will then be accomplished in the foreground.
	;;^UTILITY(U,$J,"OPT",2482,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2482,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2482,25)
	;;=STOP^IBEFUTL
	;;^UTILITY(U,$J,"OPT",2482,"U")
	;;=STOP THE INTEGRATED BILLING BA
	;;^UTILITY(U,$J,"OPT",2483,0)
	;;=IB FILER START^Start the Integrated Billing Background Filer^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2483,1,0)
	;;=^^4^4^2910417^^^
	;;^UTILITY(U,$J,"OPT",2483,1,1,0)
	;;=This option will task the IB background filer to run whether or not a
	;;^UTILITY(U,$J,"OPT",2483,1,2,0)
	;;=filer is currently running.  This option can be used when a filer
	;;^UTILITY(U,$J,"OPT",2483,1,3,0)
	;;=job has terminated unexpectedly and won't restart itself.  This will
	;;^UTILITY(U,$J,"OPT",2483,1,4,0)
	;;=force a filer to start running.
	;;^UTILITY(U,$J,"OPT",2483,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2483,20)
	;;=

IBINI0DB	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",2483,25)
	;;=START^IBEFUTL
	;;^UTILITY(U,$J,"OPT",2483,"U")
	;;=START THE INTEGRATED BILLING B
	;;^UTILITY(U,$J,"OPT",2484,0)
	;;=IB SITE MGR MENU^System Manager's Integrated Billing Menu^^M^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",2484,1,0)
	;;=^^3^3^2930927^
	;;^UTILITY(U,$J,"OPT",2484,1,1,0)
	;;=This menu contains the options for the System Manager to check on the
	;;^UTILITY(U,$J,"OPT",2484,1,2,0)
	;;=status of Integrated Billing, edit site parameters, and  manage the
	;;^UTILITY(U,$J,"OPT",2484,1,3,0)
	;;=background filer.
	;;^UTILITY(U,$J,"OPT",2484,10,0)
	;;=^19.01IP^11^11
	;;^UTILITY(U,$J,"OPT",2484,10,1,0)
	;;=2481
	;;^UTILITY(U,$J,"OPT",2484,10,1,"^")
	;;=IB SITE STATUS DISPLAY
	;;^UTILITY(U,$J,"OPT",2484,10,2,0)
	;;=2480
	;;^UTILITY(U,$J,"OPT",2484,10,2,"^")
	;;=IB EDIT SITE PARAMETERS
	;;^UTILITY(U,$J,"OPT",2484,10,3,0)
	;;=2483
	;;^UTILITY(U,$J,"OPT",2484,10,3,"^")
	;;=IB FILER START
	;;^UTILITY(U,$J,"OPT",2484,10,4,0)
	;;=2482
	;;^UTILITY(U,$J,"OPT",2484,10,4,"^")
	;;=IB FILER STOP
	;;^UTILITY(U,$J,"OPT",2484,10,5,0)
	;;=2558
	;;^UTILITY(U,$J,"OPT",2484,10,5,"^")
	;;=IB REPOST
	;;^UTILITY(U,$J,"OPT",2484,10,6,0)
	;;=2560
	;;^UTILITY(U,$J,"OPT",2484,10,6,"^")
	;;=IB OUTPUT IB INQ
	;;^UTILITY(U,$J,"OPT",2484,10,7,0)
	;;=2559
	;;^UTILITY(U,$J,"OPT",2484,10,7,"^")
	;;=IB OUTPUT INQ BY PATIENT
	;;^UTILITY(U,$J,"OPT",2484,10,8,0)
	;;=2562
	;;^UTILITY(U,$J,"OPT",2484,10,8,"^")
	;;=IB OUTPUT VERIFY RX LINKS
	;;^UTILITY(U,$J,"OPT",2484,10,9,0)
	;;=3396
	;;^UTILITY(U,$J,"OPT",2484,10,9,"^")
	;;=IB PURGE MENU
	;;^UTILITY(U,$J,"OPT",2484,10,10,0)
	;;=3547^DEVI
	;;^UTILITY(U,$J,"OPT",2484,10,10,"^")
	;;=IB SITE DEVICE SETUP
	;;^UTILITY(U,$J,"OPT",2484,10,11,0)
	;;=4107^EF
	;;^UTILITY(U,$J,"OPT",2484,10,11,"^")
	;;=IBDF IRM OPTIONS
	;;^UTILITY(U,$J,"OPT",2484,20)
	;;=D MENU^IBECK
	;;^UTILITY(U,$J,"OPT",2484,99)
	;;=55852,53999
	;;^UTILITY(U,$J,"OPT",2484,"U")
	;;=SYSTEM MANAGER'S INTEGRATED BI
	;;^UTILITY(U,$J,"OPT",2485,0)
	;;=IB FILER CLEAR PARAMETERS^Clear Integrated Billing Filer Parameters^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2485,1,0)
	;;=^^8^8^2940207^^^
	;;^UTILITY(U,$J,"OPT",2485,1,1,0)
	;;=This option will clear the IB site parameters to allow the IB filer to
	;;^UTILITY(U,$J,"OPT",2485,1,2,0)
	;;=start on its own whenever it needs to.  It will not edit the
	;;^UTILITY(U,$J,"OPT",2485,1,3,0)
	;;=field, FILE IN BACKGROUND.  It will only let the filer start when called
	;;^UTILITY(U,$J,"OPT",2485,1,4,0)
	;;=if this field is set to yes. 
	;;^UTILITY(U,$J,"OPT",2485,1,5,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",2485,1,6,0)
	;;=This option will be called as a start up job when the CPU is rebooted.
	;;^UTILITY(U,$J,"OPT",2485,1,7,0)
	;;=It will clear the two IB parameters that prevent the IB filer from
	;;^UTILITY(U,$J,"OPT",2485,1,8,0)
	;;=restarting if the CPU crashed while the filer was running.
	;;^UTILITY(U,$J,"OPT",2485,15)
	;;=
	;;^UTILITY(U,$J,"OPT",2485,20)
	;;=
	;;^UTILITY(U,$J,"OPT",2485,25)
	;;=CLEAR^IBEFUTL
	;;^UTILITY(U,$J,"OPT",2485,1916)
	;;=S
	;;^UTILITY(U,$J,"OPT",2485,"U")
	;;=CLEAR INTEGRATED BILLING FILER
	;;^UTILITY(U,$J,"OPT",2513,0)
	;;=IB OUTPUT STATISTICAL REPORT^Statistical Report (IB)^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",2513,1,0)
	;;=^^6^6^2910311^
	;;^UTILITY(U,$J,"OPT",2513,1,1,0)
	;;=This report lists the total number of Integrated Billing actions by
	;;^UTILITY(U,$J,"OPT",2513,1,2,0)
	;;=Action type along with the total charge by type for a date range.  The
	;;^UTILITY(U,$J,"OPT",2513,1,3,0)
	;;=net totals are also printed.  The net totals are derived by looking at

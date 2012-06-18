IBINI0D6	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1218,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1218,25)
	;;=EN^IBCONSC
	;;^UTILITY(U,$J,"OPT",1218,"U")
	;;=VETERANS W/INSURANCE AND OPT. 
	;;^UTILITY(U,$J,"OPT",1219,0)
	;;=IB MCCR PARAMETER EDIT^MCCR Site Parameter Enter/Edit^^R^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1219,1,0)
	;;=^^2^2^2880629^^^^
	;;^UTILITY(U,$J,"OPT",1219,1,1,0)
	;;=This option allows the user to define and edit the MCCR 
	;;^UTILITY(U,$J,"OPT",1219,1,2,0)
	;;=billing parameters for that site.
	;;^UTILITY(U,$J,"OPT",1219,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1219,25)
	;;=IBEPAR
	;;^UTILITY(U,$J,"OPT",1219,"U")
	;;=MCCR SITE PARAMETER ENTER/EDIT
	;;^UTILITY(U,$J,"OPT",1220,0)
	;;=IB ACTIVATE REVENUE CODES^Activate Revenue Codes^^E^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1220,1,0)
	;;=^^2^2^2920204^^^^
	;;^UTILITY(U,$J,"OPT",1220,1,1,0)
	;;=This option allows the user to activate the revenue codes which that
	;;^UTILITY(U,$J,"OPT",1220,1,2,0)
	;;=site has chosen to use for its third party billing.
	;;^UTILITY(U,$J,"OPT",1220,30)
	;;=DGCR(399.2,
	;;^UTILITY(U,$J,"OPT",1220,31)
	;;=AEMQ
	;;^UTILITY(U,$J,"OPT",1220,50)
	;;=DGCR(399.2,
	;;^UTILITY(U,$J,"OPT",1220,51)
	;;=[IB ACTIVATE]
	;;^UTILITY(U,$J,"OPT",1220,"U")
	;;=ACTIVATE REVENUE CODES
	;;^UTILITY(U,$J,"OPT",1221,0)
	;;=IB SYSTEM DEFINITION MENU^MCCR System Definition Menu^^M^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1221,1,0)
	;;=^^2^2^2940120^^
	;;^UTILITY(U,$J,"OPT",1221,1,1,0)
	;;=This option allows the user to set up the MCCR parameters necessary
	;;^UTILITY(U,$J,"OPT",1221,1,2,0)
	;;=for third party billing.
	;;^UTILITY(U,$J,"OPT",1221,10,0)
	;;=^19.01PI^11^11
	;;^UTILITY(U,$J,"OPT",1221,10,1,0)
	;;=1219^PARA
	;;^UTILITY(U,$J,"OPT",1221,10,1,"^")
	;;=IB MCCR PARAMETER EDIT
	;;^UTILITY(U,$J,"OPT",1221,10,2,0)
	;;=1220^ACTV
	;;^UTILITY(U,$J,"OPT",1221,10,2,"^")
	;;=IB ACTIVATE REVENUE CODES
	;;^UTILITY(U,$J,"OPT",1221,10,3,0)
	;;=1222^RATE
	;;^UTILITY(U,$J,"OPT",1221,10,3,"^")
	;;=IB RATE TYPE
	;;^UTILITY(U,$J,"OPT",1221,10,4,0)
	;;=963^INSU
	;;^UTILITY(U,$J,"OPT",1221,10,4,"^")
	;;=DG INSURANCE COMPANY EDIT
	;;^UTILITY(U,$J,"OPT",1221,10,5,0)
	;;=2311^ENTR
	;;^UTILITY(U,$J,"OPT",1221,10,5,"^")
	;;=IB BILLING RATES FILE
	;;^UTILITY(U,$J,"OPT",1221,10,6,0)
	;;=2321^FAST
	;;^UTILITY(U,$J,"OPT",1221,10,6,"^")
	;;=IB FAST ENTER BILLING RATES
	;;^UTILITY(U,$J,"OPT",1221,10,7,0)
	;;=2324^LIST
	;;^UTILITY(U,$J,"OPT",1221,10,7,"^")
	;;=IB LIST OF BILLING RATES
	;;^UTILITY(U,$J,"OPT",1221,10,8,0)
	;;=3348^BASC
	;;^UTILITY(U,$J,"OPT",1221,10,8,"^")
	;;=IB BASC UPDATE MENU
	;;^UTILITY(U,$J,"OPT",1221,10,9,0)
	;;=4133^FLAG
	;;^UTILITY(U,$J,"OPT",1221,10,9,"^")
	;;=IB MT FLAG OPT PARAMS
	;;^UTILITY(U,$J,"OPT",1221,10,10,0)
	;;=4134^LISF
	;;^UTILITY(U,$J,"OPT",1221,10,10,"^")
	;;=IB MT LIST FLAGGED PARAMS
	;;^UTILITY(U,$J,"OPT",1221,10,11,0)
	;;=4169^AUTO
	;;^UTILITY(U,$J,"OPT",1221,10,11,"^")
	;;=IB AUTO BILLER PARAMS
	;;^UTILITY(U,$J,"OPT",1221,99)
	;;=55767,67519
	;;^UTILITY(U,$J,"OPT",1221,"U")
	;;=MCCR SYSTEM DEFINITION MENU
	;;^UTILITY(U,$J,"OPT",1222,0)
	;;=IB RATE TYPE^Update Rate Type File^^R^^IB SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1222,1,0)
	;;=^^2^2^2940207^^^^
	;;^UTILITY(U,$J,"OPT",1222,1,1,0)
	;;=This option allows the user to add new entries to the RATE TYPE file
	;;^UTILITY(U,$J,"OPT",1222,1,2,0)
	;;=and to update existing entries.
	;;^UTILITY(U,$J,"OPT",1222,25)
	;;=15^IBCMENU
	;;^UTILITY(U,$J,"OPT",1222,30)
	;;=
	;;^UTILITY(U,$J,"OPT",1222,31)
	;;=
	;;^UTILITY(U,$J,"OPT",1222,50)
	;;=

IBINI0DR	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4102,0)
	;;=IBDF DEFINE AVAILABLE REPORT^Define Available Report (not Health Summaries)^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4102,1,0)
	;;=^^2^2^2930623^
	;;^UTILITY(U,$J,"OPT",4102,1,1,0)
	;;=Allows reports, other than Health Summaries, to be made available for
	;;^UTILITY(U,$J,"OPT",4102,1,2,0)
	;;=use by the print manager.
	;;^UTILITY(U,$J,"OPT",4102,20)
	;;=D EDITRPRT^IBDF11(0)
	;;^UTILITY(U,$J,"OPT",4102,"U")
	;;=DEFINE AVAILABLE REPORT (NOT H
	;;^UTILITY(U,$J,"OPT",4103,0)
	;;=IBDF DEFINE AVLABLE HLTH SMRY^Define Available Health Summary^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4103,1,0)
	;;=^^1^1^2930924^^
	;;^UTILITY(U,$J,"OPT",4103,1,1,0)
	;;=Allows a Health Summary to be made available for use by the print manager.
	;;^UTILITY(U,$J,"OPT",4103,20)
	;;=D EDITRPRT^IBDF11(1)
	;;^UTILITY(U,$J,"OPT",4103,"U")
	;;=DEFINE AVAILABLE HEALTH SUMMAR
	;;^UTILITY(U,$J,"OPT",4104,0)
	;;=IBDF EDIT DIVISION REPORTS^Edit Division Reports^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4104,1,0)
	;;=^^1^1^2930623^
	;;^UTILITY(U,$J,"OPT",4104,1,1,0)
	;;=Used to select reports that should print for the entire division.
	;;^UTILITY(U,$J,"OPT",4104,20)
	;;=D DIVSUP^IBDF11
	;;^UTILITY(U,$J,"OPT",4104,99)
	;;=55762,42279
	;;^UTILITY(U,$J,"OPT",4104,"U")
	;;=EDIT DIVISION REPORTS
	;;^UTILITY(U,$J,"OPT",4105,0)
	;;=IBDF EDIT CLINIC REPORTS^Edit Clinic Reports^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4105,1,0)
	;;=^^1^1^2930623^
	;;^UTILITY(U,$J,"OPT",4105,1,1,0)
	;;=Used to select reports that should print for the clinic.
	;;^UTILITY(U,$J,"OPT",4105,20)
	;;=D CLNCSUP^IBDF11
	;;^UTILITY(U,$J,"OPT",4105,"U")
	;;=EDIT CLINIC REPORTS
	;;^UTILITY(U,$J,"OPT",4106,0)
	;;=IBDF PRINT MANAGER^Print Manager^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4106,1,0)
	;;=^^3^3^2930924^
	;;^UTILITY(U,$J,"OPT",4106,1,1,0)
	;;=Contains all the options pertaining to the print manager, except for the
	;;^UTILITY(U,$J,"OPT",4106,1,2,0)
	;;=IBDF DEFINE AVLABLE HLTH SMRY option - that option allows the user to
	;;^UTILITY(U,$J,"OPT",4106,1,3,0)
	;;=enter mumps code, so it must be limited to IRM use.
	;;^UTILITY(U,$J,"OPT",4106,10,0)
	;;=^19.01PI^6^5
	;;^UTILITY(U,$J,"OPT",4106,10,1,0)
	;;=4104^ED^1
	;;^UTILITY(U,$J,"OPT",4106,10,1,"^")
	;;=IBDF EDIT DIVISION REPORTS
	;;^UTILITY(U,$J,"OPT",4106,10,2,0)
	;;=4105^EC^2
	;;^UTILITY(U,$J,"OPT",4106,10,2,"^")
	;;=IBDF EDIT CLINIC REPORTS
	;;^UTILITY(U,$J,"OPT",4106,10,4,0)
	;;=4103^DH^4
	;;^UTILITY(U,$J,"OPT",4106,10,4,"^")
	;;=IBDF DEFINE AVLABLE HLTH SMRY
	;;^UTILITY(U,$J,"OPT",4106,10,5,0)
	;;=4116^LC
	;;^UTILITY(U,$J,"OPT",4106,10,5,"^")
	;;=IBDF LIST CLINICS USING FORMS
	;;^UTILITY(U,$J,"OPT",4106,10,6,0)
	;;=4115^RC
	;;^UTILITY(U,$J,"OPT",4106,10,6,"^")
	;;=IBDF REPORT CLINIC SETUPS
	;;^UTILITY(U,$J,"OPT",4106,99)
	;;=55852,54009
	;;^UTILITY(U,$J,"OPT",4106,"U")
	;;=PRINT MANAGER
	;;^UTILITY(U,$J,"OPT",4107,0)
	;;=IBDF IRM OPTIONS^Encounter Form IRM Options^^M^^IBDF IRM^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4107,1,0)
	;;=^^3^3^2940202^^^
	;;^UTILITY(U,$J,"OPT",4107,1,1,0)
	;;=The basic intent of this menu is to contain the options that should only
	;;^UTILITY(U,$J,"OPT",4107,1,2,0)
	;;=be available to those technical users that can program in MUMPS, which is
	;;^UTILITY(U,$J,"OPT",4107,1,3,0)
	;;=a requirement, for example, when, adding a new PACKAGE INTERFACE.
	;;^UTILITY(U,$J,"OPT",4107,10,0)
	;;=^19.01PI^8^5
	;;^UTILITY(U,$J,"OPT",4107,10,3,0)
	;;=4119^EP^3
	;;^UTILITY(U,$J,"OPT",4107,10,3,"^")
	;;=IBDF EDIT PACKAGE INTERFACE

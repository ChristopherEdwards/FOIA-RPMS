IBINI0DQ	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4083,1,3,0)
	;;=   Deceased Patients
	;;^UTILITY(U,$J,"OPT",4083,1,4,0)
	;;=   Non-Veterans
	;;^UTILITY(U,$J,"OPT",4083,1,5,0)
	;;=   Patients who are rated SC greater than 50%
	;;^UTILITY(U,$J,"OPT",4083,1,6,0)
	;;=The user will be allowed to sort by Exemption Status Date, and by
	;;^UTILITY(U,$J,"OPT",4083,1,7,0)
	;;=Patient name.  Optionally, the user can store the results of the
	;;^UTILITY(U,$J,"OPT",4083,1,8,0)
	;;=search in a template named IB EXEMPTION LIST for local printing purposes.
	;;^UTILITY(U,$J,"OPT",4083,1,9,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4083,25)
	;;=IBARXEPL
	;;^UTILITY(U,$J,"OPT",4083,"U")
	;;=LETTERS TO EXEMPT PATIENTS
	;;^UTILITY(U,$J,"OPT",4093,0)
	;;=IBDF ENCOUNTER FORM^Encounter Forms^^M^^^^^^^y^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4093,1,0)
	;;=^^1^1^2930930^
	;;^UTILITY(U,$J,"OPT",4093,1,1,0)
	;;=Contains all of the encounter form options.
	;;^UTILITY(U,$J,"OPT",4093,10,0)
	;;=^19.01PI^11^5
	;;^UTILITY(U,$J,"OPT",4093,10,5,0)
	;;=4106^PM^3
	;;^UTILITY(U,$J,"OPT",4093,10,5,"^")
	;;=IBDF PRINT MANAGER
	;;^UTILITY(U,$J,"OPT",4093,10,8,0)
	;;=4178^TK^4
	;;^UTILITY(U,$J,"OPT",4093,10,8,"^")
	;;=IBDF EDIT TOOL KIT
	;;^UTILITY(U,$J,"OPT",4093,10,9,0)
	;;=4179^PR^2
	;;^UTILITY(U,$J,"OPT",4093,10,9,"^")
	;;=IBDF PRINT OPTIONS
	;;^UTILITY(U,$J,"OPT",4093,10,10,0)
	;;=4181^EE^1
	;;^UTILITY(U,$J,"OPT",4093,10,10,"^")
	;;=IBDF EDIT ENCOUNTER FORMS
	;;^UTILITY(U,$J,"OPT",4093,10,11,0)
	;;=4107^IR^5
	;;^UTILITY(U,$J,"OPT",4093,10,11,"^")
	;;=IBDF IRM OPTIONS
	;;^UTILITY(U,$J,"OPT",4093,99)
	;;=55852,54008
	;;^UTILITY(U,$J,"OPT",4093,"U")
	;;=ENCOUNTER FORMS
	;;^UTILITY(U,$J,"OPT",4094,0)
	;;=IBDF CLINIC SETUP/EDIT FORMS^Clinic Setup/Edit Forms^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4094,1,0)
	;;=^^1^1^2930820^^^^
	;;^UTILITY(U,$J,"OPT",4094,1,1,0)
	;;=The form generator for creating encounter forms.
	;;^UTILITY(U,$J,"OPT",4094,20)
	;;=D ^IBDF6
	;;^UTILITY(U,$J,"OPT",4094,"U")
	;;=CLINIC SETUP/EDIT FORMS
	;;^UTILITY(U,$J,"OPT",4095,0)
	;;=IBDF PRINT ENCOUNTER FORMS^Print Encounter Forms for Appointments^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4095,1,0)
	;;=^^2^2^2931012^^
	;;^UTILITY(U,$J,"OPT",4095,1,1,0)
	;;=For printing an encounter form for appointments, either by division,
	;;^UTILITY(U,$J,"OPT",4095,1,2,0)
	;;=clinic, or patient.
	;;^UTILITY(U,$J,"OPT",4095,20)
	;;=D ^IBDF1B
	;;^UTILITY(U,$J,"OPT",4095,"U")
	;;=PRINT ENCOUNTER FORMS FOR APPO
	;;^UTILITY(U,$J,"OPT",4096,0)
	;;=IBDF PRINT BLNK ENCOUNTER FORM^Print Blank Encounter Form^^A^^^^^^^y^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4096,1,0)
	;;=^^2^2^2930610^^^^
	;;^UTILITY(U,$J,"OPT",4096,1,1,0)
	;;=This option allows the user to select a clinic, and if an encounter form
	;;^UTILITY(U,$J,"OPT",4096,1,2,0)
	;;=is defined for use with an embossed patient card the form will be printed.
	;;^UTILITY(U,$J,"OPT",4096,20)
	;;=D MAIN^IBDF1A(0)
	;;^UTILITY(U,$J,"OPT",4096,"U")
	;;=PRINT BLANK ENCOUNTER FORM
	;;^UTILITY(U,$J,"OPT",4098,0)
	;;=IBDF PRNT FORM W/DATA NO APPT.^Print Form w/Patient Data, No Appt^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4098,1,0)
	;;=^^3^3^2930820^^^^
	;;^UTILITY(U,$J,"OPT",4098,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4098,1,2,0)
	;;=Allows an encounter form to be printed with patient data, but does not ask
	;;^UTILITY(U,$J,"OPT",4098,1,3,0)
	;;=that an appt. be selected. Uses current time as the appointment time.
	;;^UTILITY(U,$J,"OPT",4098,20)
	;;=D MAIN^IBDF1A(1)
	;;^UTILITY(U,$J,"OPT",4098,"U")
	;;=PRINT FORM W/PATIENT DATA, NO 

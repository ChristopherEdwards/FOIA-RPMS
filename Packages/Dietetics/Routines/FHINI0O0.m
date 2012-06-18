FHINI0O0	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1584,0)
	;;=FHASCM^Nutrition Patient Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1584,1,0)
	;;=^^2^2^2930910^^^^
	;;^UTILITY(U,$J,"OPT",1584,1,1,0)
	;;=This menu contains the primary clinical dietetic activities
	;;^UTILITY(U,$J,"OPT",1584,1,2,0)
	;;=performed by the clinician.
	;;^UTILITY(U,$J,"OPT",1584,10,0)
	;;=^19.01PI^10^10
	;;^UTILITY(U,$J,"OPT",1584,10,1,0)
	;;=1572^PS
	;;^UTILITY(U,$J,"OPT",1584,10,1,"^")
	;;=FHASXR
	;;^UTILITY(U,$J,"OPT",1584,10,2,0)
	;;=1573^EA
	;;^UTILITY(U,$J,"OPT",1584,10,2,"^")
	;;=FHASM1
	;;^UTILITY(U,$J,"OPT",1584,10,3,0)
	;;=1574^DA
	;;^UTILITY(U,$J,"OPT",1584,10,3,"^")
	;;=FHASMR
	;;^UTILITY(U,$J,"OPT",1584,10,4,0)
	;;=1582^EE
	;;^UTILITY(U,$J,"OPT",1584,10,4,"^")
	;;=FHASE3
	;;^UTILITY(U,$J,"OPT",1584,10,5,0)
	;;=1587^ES
	;;^UTILITY(U,$J,"OPT",1584,10,5,"^")
	;;=FHASE6
	;;^UTILITY(U,$J,"OPT",1584,10,6,0)
	;;=1589^PE
	;;^UTILITY(U,$J,"OPT",1584,10,6,"^")
	;;=FHASE5
	;;^UTILITY(U,$J,"OPT",1584,10,7,0)
	;;=1593^PP
	;;^UTILITY(U,$J,"OPT",1584,10,7,"^")
	;;=FHASP1
	;;^UTILITY(U,$J,"OPT",1584,10,8,0)
	;;=1631^PH
	;;^UTILITY(U,$J,"OPT",1584,10,8,"^")
	;;=FHASNR3
	;;^UTILITY(U,$J,"OPT",1584,10,9,0)
	;;=1632^LL
	;;^UTILITY(U,$J,"OPT",1584,10,9,"^")
	;;=FHASNR4
	;;^UTILITY(U,$J,"OPT",1584,10,10,0)
	;;=1624^LE
	;;^UTILITY(U,$J,"OPT",1584,10,10,"^")
	;;=FHASE7
	;;^UTILITY(U,$J,"OPT",1584,99)
	;;=56496,40638
	;;^UTILITY(U,$J,"OPT",1584,"U")
	;;=NUTRITION PATIENT MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1585,0)
	;;=FHASC9^Enter/Edit Nutrition Plans^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1585,1,0)
	;;=^^3^3^2920915^^^
	;;^UTILITY(U,$J,"OPT",1585,1,1,0)
	;;=This option is used to create and/or edit entries in the
	;;^UTILITY(U,$J,"OPT",1585,1,2,0)
	;;=nutrition plan file (115.5) used on the Nutrition Screening
	;;^UTILITY(U,$J,"OPT",1585,1,3,0)
	;;=form.
	;;^UTILITY(U,$J,"OPT",1585,25)
	;;=EN9^FHASC
	;;^UTILITY(U,$J,"OPT",1585,"U")
	;;=ENTER/EDIT NUTRITION PLANS
	;;^UTILITY(U,$J,"OPT",1586,0)
	;;=FHASC10^List Nutrition Plans^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1586,1,0)
	;;=^^2^2^2891106^
	;;^UTILITY(U,$J,"OPT",1586,1,1,0)
	;;=This option is used to list the entries in the nutrition plan
	;;^UTILITY(U,$J,"OPT",1586,1,2,0)
	;;=file (115.5).
	;;^UTILITY(U,$J,"OPT",1586,25)
	;;=EN10^FHASC
	;;^UTILITY(U,$J,"OPT",1586,"U")
	;;=LIST NUTRITION PLANS
	;;^UTILITY(U,$J,"OPT",1587,0)
	;;=FHASE6^Enter Patient Nutrition Status^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1587,1,0)
	;;=^^2^2^2891111^
	;;^UTILITY(U,$J,"OPT",1587,1,1,0)
	;;=This option is used to enter the current nutrition status
	;;^UTILITY(U,$J,"OPT",1587,1,2,0)
	;;=of a patient.
	;;^UTILITY(U,$J,"OPT",1587,25)
	;;=EN5^FHASN
	;;^UTILITY(U,$J,"OPT",1587,"U")
	;;=ENTER PATIENT NUTRITION STATUS
	;;^UTILITY(U,$J,"OPT",1588,0)
	;;=FHASE4^Encounter Statistics^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1588,1,0)
	;;=^^2^2^2930415^
	;;^UTILITY(U,$J,"OPT",1588,1,1,0)
	;;=This option is used to tabulate encounters, broken down by
	;;^UTILITY(U,$J,"OPT",1588,1,2,0)
	;;=clinician if desired, for any specified period of time.
	;;^UTILITY(U,$J,"OPT",1588,25)
	;;=FHASE1
	;;^UTILITY(U,$J,"OPT",1588,"U")
	;;=ENCOUNTER STATISTICS
	;;^UTILITY(U,$J,"OPT",1589,0)
	;;=FHASE5^Patient Encounter Inquiry^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1589,1,0)
	;;=^^2^2^2911209^^^
	;;^UTILITY(U,$J,"OPT",1589,1,1,0)
	;;=This option allows for a listing of the details of all encounters
	;;^UTILITY(U,$J,"OPT",1589,1,2,0)
	;;=from a given date for a specified patient.
	;;^UTILITY(U,$J,"OPT",1589,25)
	;;=FHASE2
	;;^UTILITY(U,$J,"OPT",1589,"U")
	;;=PATIENT ENCOUNTER INQUIRY
	;;^UTILITY(U,$J,"OPT",1590,0)
	;;=FHSYP1^Display Selected Lab Tests^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1590,1,0)
	;;=^^2^2^2920915^^^
	;;^UTILITY(U,$J,"OPT",1590,1,1,0)
	;;=This option will display all of the lab tests selected as
	;;^UTILITY(U,$J,"OPT",1590,1,2,0)
	;;=site parameters for this site.
	;;^UTILITY(U,$J,"OPT",1590,25)
	;;=EN1^FHSYSP
	;;^UTILITY(U,$J,"OPT",1590,"U")
	;;=DISPLAY SELECTED LAB TESTS
	;;^UTILITY(U,$J,"OPT",1591,0)
	;;=FHSYP2^Display Selected Drug Classifications^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1591,1,0)
	;;=^^2^2^2920915^^^
	;;^UTILITY(U,$J,"OPT",1591,1,1,0)
	;;=This option will display all of the drug classifications
	;;^UTILITY(U,$J,"OPT",1591,1,2,0)
	;;=selected as site parameters by this site.
	;;^UTILITY(U,$J,"OPT",1591,25)
	;;=EN2^FHSYSP
	;;^UTILITY(U,$J,"OPT",1591,"U")
	;;=DISPLAY SELECTED DRUG CLASSIFI
	;;^UTILITY(U,$J,"OPT",1592,0)
	;;=FHASNR^Nutrition Status Summary^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1592,1,0)
	;;=^^2^2^2930415^^
	;;^UTILITY(U,$J,"OPT",1592,1,1,0)
	;;=This option will display the nutrition status counts

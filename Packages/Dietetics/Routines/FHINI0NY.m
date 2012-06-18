FHINI0NY	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1564,1,0)
	;;=^^2^2^2880903^
	;;^UTILITY(U,$J,"OPT",1564,1,1,0)
	;;=This option will display the current food preferences for a
	;;^UTILITY(U,$J,"OPT",1564,1,2,0)
	;;=particular patient.
	;;^UTILITY(U,$J,"OPT",1564,25)
	;;=EN4^FHSEL1
	;;^UTILITY(U,$J,"OPT",1564,"U")
	;;=DISPLAY PATIENT PREFERENCES
	;;^UTILITY(U,$J,"OPT",1565,0)
	;;=FHSELX^Food Preference Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1565,1,0)
	;;=^^1^1^2880914^^^^
	;;^UTILITY(U,$J,"OPT",1565,1,1,0)
	;;=This menu allows access to all of the food preference options.
	;;^UTILITY(U,$J,"OPT",1565,10,0)
	;;=^19.01PI^2^2
	;;^UTILITY(U,$J,"OPT",1565,10,1,0)
	;;=1561^EP
	;;^UTILITY(U,$J,"OPT",1565,10,1,"^")
	;;=FHSEL1
	;;^UTILITY(U,$J,"OPT",1565,10,2,0)
	;;=1562^LP
	;;^UTILITY(U,$J,"OPT",1565,10,2,"^")
	;;=FHSEL2
	;;^UTILITY(U,$J,"OPT",1565,99)
	;;=56496,40780
	;;^UTILITY(U,$J,"OPT",1565,"U")
	;;=FOOD PREFERENCE MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1566,0)
	;;=FHSEL5^Tabulate Patient Meal Preferences^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1566,1,0)
	;;=^^3^3^2931004^^^^
	;;^UTILITY(U,$J,"OPT",1566,1,1,0)
	;;=This option will tabulate patient preferences for a given
	;;^UTILITY(U,$J,"OPT",1566,1,2,0)
	;;=meal. It will tabulate likes and dislikes for only those recipes
	;;^UTILITY(U,$J,"OPT",1566,1,3,0)
	;;=appearing on the menu.
	;;^UTILITY(U,$J,"OPT",1566,25)
	;;=FHSEL2
	;;^UTILITY(U,$J,"OPT",1566,"U")
	;;=TABULATE PATIENT MEAL PREFEREN
	;;^UTILITY(U,$J,"OPT",1567,0)
	;;=FHPRC11^Print Daily Diet Menus^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1567,1,0)
	;;=^^3^3^2920915^^
	;;^UTILITY(U,$J,"OPT",1567,1,1,0)
	;;=This option will print the Daily Routine and Modified Diet Menus
	;;^UTILITY(U,$J,"OPT",1567,1,2,0)
	;;=sheet for a given date. The items will be based upon the effective
	;;^UTILITY(U,$J,"OPT",1567,1,3,0)
	;;=menu cycle meals for the selected date.
	;;^UTILITY(U,$J,"OPT",1567,25)
	;;=FHPRC8
	;;^UTILITY(U,$J,"OPT",1567,"U")
	;;=PRINT DAILY DIET MENUS
	;;^UTILITY(U,$J,"OPT",1568,0)
	;;=FHFIL1^Print File Entries^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1568,1,0)
	;;=^^2^2^2950310^^^
	;;^UTILITY(U,$J,"OPT",1568,1,1,0)
	;;=This option is the standard FileMan Preint option except that
	;;^UTILITY(U,$J,"OPT",1568,1,2,0)
	;;=it is restricted to dietetic files.
	;;^UTILITY(U,$J,"OPT",1568,25)
	;;=PRNT^FHSYSF
	;;^UTILITY(U,$J,"OPT",1568,"U")
	;;=PRINT FILE ENTRIES
	;;^UTILITY(U,$J,"OPT",1569,0)
	;;=FHFIL2^Search File Entries^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1569,1,0)
	;;=^^2^2^2890726^
	;;^UTILITY(U,$J,"OPT",1569,1,1,0)
	;;=This option is the standard FileMan Search option except that
	;;^UTILITY(U,$J,"OPT",1569,1,2,0)
	;;=it is restricted to dietetic files.
	;;^UTILITY(U,$J,"OPT",1569,25)
	;;=SRCH^FHSYSF
	;;^UTILITY(U,$J,"OPT",1569,"U")
	;;=SEARCH FILE ENTRIES
	;;^UTILITY(U,$J,"OPT",1570,0)
	;;=FHFIL3^Inquire to Files^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1570,1,0)
	;;=^^2^2^2890726^
	;;^UTILITY(U,$J,"OPT",1570,1,1,0)
	;;=This option is the standard FileMan Inquire to Files option
	;;^UTILITY(U,$J,"OPT",1570,1,2,0)
	;;=except that it is restricted to dietetic files.
	;;^UTILITY(U,$J,"OPT",1570,25)
	;;=INQ^FHSYSF
	;;^UTILITY(U,$J,"OPT",1570,"U")
	;;=INQUIRE TO FILES
	;;^UTILITY(U,$J,"OPT",1571,0)
	;;=FHFIL4^File Dictionaries^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1571,1,0)
	;;=^^1^1^2901016^^
	;;^UTILITY(U,$J,"OPT",1571,1,1,0)
	;;=This option is the standard FileMan List File Attributes.
	;;^UTILITY(U,$J,"OPT",1571,25)
	;;=DIC^FHSYSF
	;;^UTILITY(U,$J,"OPT",1571,"U")
	;;=FILE DICTIONARIES
	;;^UTILITY(U,$J,"OPT",1572,0)
	;;=FHASXR^Print Screening Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1572,1,0)
	;;=^^3^3^2891106^
	;;^UTILITY(U,$J,"OPT",1572,1,1,0)
	;;=This option will print a nutrition screening form for a patient;
	;;^UTILITY(U,$J,"OPT",1572,1,2,0)
	;;=it contains any prior assessment data and a format for recording
	;;^UTILITY(U,$J,"OPT",1572,1,3,0)
	;;=clinical information of interest to dietetics.
	;;^UTILITY(U,$J,"OPT",1572,25)
	;;=FHASXR
	;;^UTILITY(U,$J,"OPT",1572,"U")
	;;=PRINT SCREENING REPORT
	;;^UTILITY(U,$J,"OPT",1573,0)
	;;=FHASM1^Enter Assessment^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1573,1,0)
	;;=^^2^2^2940407^^
	;;^UTILITY(U,$J,"OPT",1573,1,1,0)
	;;=This option is used to perform a nutrition assessment. The results
	;;^UTILITY(U,$J,"OPT",1573,1,2,0)
	;;=may optionally be saved.
	;;^UTILITY(U,$J,"OPT",1573,25)
	;;=FHASM1
	;;^UTILITY(U,$J,"OPT",1573,"U")
	;;=ENTER ASSESSMENT
	;;^UTILITY(U,$J,"OPT",1574,0)
	;;=FHASMR^Display Assessment^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1574,1,0)
	;;=^^2^2^2901005^^
	;;^UTILITY(U,$J,"OPT",1574,1,1,0)
	;;=This option allows the clinician to display any nutrition

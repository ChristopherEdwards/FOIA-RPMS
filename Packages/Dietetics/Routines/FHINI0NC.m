FHINI0NC	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1408,1,2,0)
	;;=admission for a given patient. It includes all of the
	;;^UTILITY(U,$J,"OPT",1408,1,3,0)
	;;='captured' data such as who entered the order and the exact
	;;^UTILITY(U,$J,"OPT",1408,1,4,0)
	;;=date and time of entry.
	;;^UTILITY(U,$J,"OPT",1408,25)
	;;=FHDMP
	;;^UTILITY(U,$J,"OPT",1408,"U")
	;;=PATIENT DATA LOG
	;;^UTILITY(U,$J,"OPT",1409,0)
	;;=FHSITE^Modify Site Parameters^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1409,1,0)
	;;=^^2^2^2940926^^^^
	;;^UTILITY(U,$J,"OPT",1409,1,1,0)
	;;=Allows for the modification of the entries in the FH Site
	;;^UTILITY(U,$J,"OPT",1409,1,2,0)
	;;=Parameter file (119.9).
	;;^UTILITY(U,$J,"OPT",1409,25)
	;;=FHSYSP
	;;^UTILITY(U,$J,"OPT",1409,"U")
	;;=MODIFY SITE PARAMETERS
	;;^UTILITY(U,$J,"OPT",1410,0)
	;;=FHPATM^Patient Movements^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1410,1,0)
	;;=3^^3^3^2880717^
	;;^UTILITY(U,$J,"OPT",1410,1,1,0)
	;;=This option will produce a listing of all patient movements (admissions,
	;;^UTILITY(U,$J,"OPT",1410,1,2,0)
	;;=discharges and transfers) from a specified date/time until the
	;;^UTILITY(U,$J,"OPT",1410,1,3,0)
	;;=present.
	;;^UTILITY(U,$J,"OPT",1410,25)
	;;=FHPATM
	;;^UTILITY(U,$J,"OPT",1410,"U")
	;;=PATIENT MOVEMENTS
	;;^UTILITY(U,$J,"OPT",1411,0)
	;;=FHNU4^Input Menu Data^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1411,1,0)
	;;=1^^2^2^2931201^^
	;;^UTILITY(U,$J,"OPT",1411,1,1,0)
	;;=This option allows a user to create and/or edit a menu in the
	;;^UTILITY(U,$J,"OPT",1411,1,2,0)
	;;=User Menu file (112.6).
	;;^UTILITY(U,$J,"OPT",1411,25)
	;;=FHNU4
	;;^UTILITY(U,$J,"OPT",1411,"U")
	;;=INPUT MENU DATA
	;;^UTILITY(U,$J,"OPT",1412,0)
	;;=FHNU1P^View/Print Menu^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1412,1,0)
	;;=^^2^2^2880717^^^^
	;;^UTILITY(U,$J,"OPT",1412,1,1,0)
	;;=This option allows a user to display and/or print a menu contained
	;;^UTILITY(U,$J,"OPT",1412,1,2,0)
	;;=in the User Menu file (112.6).
	;;^UTILITY(U,$J,"OPT",1412,25)
	;;=FHNU1
	;;^UTILITY(U,$J,"OPT",1412,"U")
	;;=VIEW/PRINT MENU
	;;^UTILITY(U,$J,"OPT",1413,0)
	;;=FHNU1D^View Meal^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1413,1,0)
	;;=^^2^2^2931027^^^^
	;;^UTILITY(U,$J,"OPT",1413,1,1,0)
	;;=This option will display a meal contained in the User Menu
	;;^UTILITY(U,$J,"OPT",1413,1,2,0)
	;;=file (112.6).
	;;^UTILITY(U,$J,"OPT",1413,25)
	;;=EN1^FHNU1
	;;^UTILITY(U,$J,"OPT",1413,"U")
	;;=VIEW MEAL
	;;^UTILITY(U,$J,"OPT",1414,0)
	;;=FHNU2^Print Analysis (32 Nutrients)^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1414,1,0)
	;;=^^2^2^2931027^^^^
	;;^UTILITY(U,$J,"OPT",1414,1,1,0)
	;;=This option produces a complete analysis of a User Menu including
	;;^UTILITY(U,$J,"OPT",1414,1,2,0)
	;;=all 32 nutrients, meal and daily totals, and %RDA values.
	;;^UTILITY(U,$J,"OPT",1414,25)
	;;=FHNU2
	;;^UTILITY(U,$J,"OPT",1414,"U")
	;;=PRINT ANALYSIS (32 NUTRIENTS)
	;;^UTILITY(U,$J,"OPT",1415,0)
	;;=FHNU8^Print Nutrient Intake Study (10 Nutrients)^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1415,1,0)
	;;=^^2^2^2880717^^^^
	;;^UTILITY(U,$J,"OPT",1415,1,1,0)
	;;=This option will produce a short-form analysis, using 10 nutrients,
	;;^UTILITY(U,$J,"OPT",1415,1,2,0)
	;;=of a User Menu for calorie count purposes.
	;;^UTILITY(U,$J,"OPT",1415,25)
	;;=FHNU8
	;;^UTILITY(U,$J,"OPT",1415,"U")
	;;=PRINT NUTRIENT INTAKE STUDY (1
	;;^UTILITY(U,$J,"OPT",1416,0)
	;;=FHNU5^Abbreviated Analysis^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1416,1,0)
	;;=^^4^4^2880717^^^
	;;^UTILITY(U,$J,"OPT",1416,1,1,0)
	;;=This option allows for entry and analysis of a group of food items
	;;^UTILITY(U,$J,"OPT",1416,1,2,0)
	;;=selected from the Food Nutrient file. It is designed for a quick analysis
	;;^UTILITY(U,$J,"OPT",1416,1,3,0)
	;;=and does not save the items selected nor does it analyze a
	;;^UTILITY(U,$J,"OPT",1416,1,4,0)
	;;=pre-existing User Menu entry.
	;;^UTILITY(U,$J,"OPT",1416,25)
	;;=FHNU5
	;;^UTILITY(U,$J,"OPT",1416,"U")
	;;=ABBREVIATED ANALYSIS
	;;^UTILITY(U,$J,"OPT",1417,0)
	;;=FHNUM^Energy/Nutrient Analysis^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1417,1,0)
	;;=^^2^2^2931027^^^^
	;;^UTILITY(U,$J,"OPT",1417,1,1,0)
	;;=This menu allows access to all of the Energy/Nutrient options
	;;^UTILITY(U,$J,"OPT",1417,1,2,0)
	;;=except for the file management options.
	;;^UTILITY(U,$J,"OPT",1417,10,0)
	;;=^19.01PI^6^6
	;;^UTILITY(U,$J,"OPT",1417,10,1,0)
	;;=1413^VM
	;;^UTILITY(U,$J,"OPT",1417,10,1,"^")
	;;=FHNU1D
	;;^UTILITY(U,$J,"OPT",1417,10,2,0)
	;;=1412^PM
	;;^UTILITY(U,$J,"OPT",1417,10,2,"^")
	;;=FHNU1P
	;;^UTILITY(U,$J,"OPT",1417,10,3,0)
	;;=1414^AN
	;;^UTILITY(U,$J,"OPT",1417,10,3,"^")
	;;=FHNU2
	;;^UTILITY(U,$J,"OPT",1417,10,4,0)
	;;=1411^MD
	;;^UTILITY(U,$J,"OPT",1417,10,4,"^")
	;;=FHNU4

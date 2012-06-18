FHINI0NX	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1554,"U")
	;;=CHECK INTEGRITY OF ROUTINES
	;;^UTILITY(U,$J,"OPT",1555,0)
	;;=FHX2^Recode Diets for all Inpatients^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1555,1,0)
	;;=^^5^5^2880717^
	;;^UTILITY(U,$J,"OPT",1555,1,1,0)
	;;=This option will automatically recode the production diet based
	;;^UTILITY(U,$J,"OPT",1555,1,2,0)
	;;=upon the clinical diet order for all inpatients using the current
	;;^UTILITY(U,$J,"OPT",1555,1,3,0)
	;;=data in the production diet file. It is used whenever significant
	;;^UTILITY(U,$J,"OPT",1555,1,4,0)
	;;=alterations have been made to the production diet file which
	;;^UTILITY(U,$J,"OPT",1555,1,5,0)
	;;=will affect the recoding of diets.
	;;^UTILITY(U,$J,"OPT",1555,25)
	;;=INP^FHORDR
	;;^UTILITY(U,$J,"OPT",1555,"U")
	;;=RECODE DIETS FOR ALL INPATIENT
	;;^UTILITY(U,$J,"OPT",1556,0)
	;;=FHX3^Check File Pointers^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1556,1,0)
	;;=^^5^5^2920605^^
	;;^UTILITY(U,$J,"OPT",1556,1,1,0)
	;;=This option will check all of the file relationships to ensure
	;;^UTILITY(U,$J,"OPT",1556,1,2,0)
	;;=that no entry has been deleted which is used by another file.
	;;^UTILITY(U,$J,"OPT",1556,1,3,0)
	;;=Since the patient file 'points' to many of these files it is
	;;^UTILITY(U,$J,"OPT",1556,1,4,0)
	;;=also checked if requested but may require a considerable
	;;^UTILITY(U,$J,"OPT",1556,1,5,0)
	;;=period of time.
	;;^UTILITY(U,$J,"OPT",1556,25)
	;;=FHXDB
	;;^UTILITY(U,$J,"OPT",1556,"U")
	;;=CHECK FILE POINTERS
	;;^UTILITY(U,$J,"OPT",1557,0)
	;;=FHX4^Create Dietetic File entry for all Inpatients^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1557,1,0)
	;;=^^4^4^2950121^^^^
	;;^UTILITY(U,$J,"OPT",1557,1,1,0)
	;;=This option will verify that all inpatients have a Dietetic
	;;^UTILITY(U,$J,"OPT",1557,1,2,0)
	;;=Patient file entry for the current admission. It is primarily
	;;^UTILITY(U,$J,"OPT",1557,1,3,0)
	;;=used when link failures have resulted in new admissions not
	;;^UTILITY(U,$J,"OPT",1557,1,4,0)
	;;=having a file entry created.
	;;^UTILITY(U,$J,"OPT",1557,25)
	;;=EN1^FHXIN
	;;^UTILITY(U,$J,"OPT",1557,"U")
	;;=CREATE DIETETIC FILE ENTRY FOR
	;;^UTILITY(U,$J,"OPT",1559,0)
	;;=FHPRC10^List Recipe Usage in Meals/Cycles^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1559,1,0)
	;;=^^2^2^2920107^^
	;;^UTILITY(U,$J,"OPT",1559,1,1,0)
	;;=This option will find all occurrences of a recipe in the
	;;^UTILITY(U,$J,"OPT",1559,1,2,0)
	;;=Meal file and the meal in the Menu Cycle file.
	;;^UTILITY(U,$J,"OPT",1559,25)
	;;=FHPRC7
	;;^UTILITY(U,$J,"OPT",1559,"U")
	;;=LIST RECIPE USAGE IN MEALS/CYC
	;;^UTILITY(U,$J,"OPT",1560,0)
	;;=FHSELM^Food Preferences^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1560,1,0)
	;;=^^2^2^2881103^^
	;;^UTILITY(U,$J,"OPT",1560,1,1,0)
	;;=This menu allows entry to all the food preference options
	;;^UTILITY(U,$J,"OPT",1560,1,2,0)
	;;=except for the file management options.
	;;^UTILITY(U,$J,"OPT",1560,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",1560,10,1,0)
	;;=1563^EP
	;;^UTILITY(U,$J,"OPT",1560,10,1,"^")
	;;=FHSEL3
	;;^UTILITY(U,$J,"OPT",1560,10,2,0)
	;;=1564^DP
	;;^UTILITY(U,$J,"OPT",1560,10,2,"^")
	;;=FHSEL4
	;;^UTILITY(U,$J,"OPT",1560,10,3,0)
	;;=1566^TP
	;;^UTILITY(U,$J,"OPT",1560,10,3,"^")
	;;=FHSEL5
	;;^UTILITY(U,$J,"OPT",1560,99)
	;;=56496,40780
	;;^UTILITY(U,$J,"OPT",1560,"U")
	;;=FOOD PREFERENCES
	;;^UTILITY(U,$J,"OPT",1561,0)
	;;=FHSEL1^Enter/Edit Food Preferences^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1561,1,0)
	;;=^^2^2^2890606^^
	;;^UTILITY(U,$J,"OPT",1561,1,1,0)
	;;=This option allows for the entry and editing of items into
	;;^UTILITY(U,$J,"OPT",1561,1,2,0)
	;;=the Food Preferences file (115.2).
	;;^UTILITY(U,$J,"OPT",1561,25)
	;;=EN1^FHSEL1
	;;^UTILITY(U,$J,"OPT",1561,"U")
	;;=ENTER/EDIT FOOD PREFERENCES
	;;^UTILITY(U,$J,"OPT",1562,0)
	;;=FHSEL2^List Food Preferences^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1562,1,0)
	;;=^^2^2^2901101^^^^
	;;^UTILITY(U,$J,"OPT",1562,1,1,0)
	;;=This option will list all of the entries in the Food
	;;^UTILITY(U,$J,"OPT",1562,1,2,0)
	;;=Preferences file (115.2).
	;;^UTILITY(U,$J,"OPT",1562,25)
	;;=EN2^FHSEL1
	;;^UTILITY(U,$J,"OPT",1562,"U")
	;;=LIST FOOD PREFERENCES
	;;^UTILITY(U,$J,"OPT",1563,0)
	;;=FHSEL3^Enter/Edit Patient Preferences^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1563,1,0)
	;;=^^2^2^2930208^^
	;;^UTILITY(U,$J,"OPT",1563,1,1,0)
	;;=This options allows for the entry and editing of food preferences
	;;^UTILITY(U,$J,"OPT",1563,1,2,0)
	;;=for a particular patient.
	;;^UTILITY(U,$J,"OPT",1563,25)
	;;=EN3^FHSEL1
	;;^UTILITY(U,$J,"OPT",1563,"U")
	;;=ENTER/EDIT PATIENT PREFERENCES
	;;^UTILITY(U,$J,"OPT",1564,0)
	;;=FHSEL4^Display Patient Preferences^^R^^^^^^^^

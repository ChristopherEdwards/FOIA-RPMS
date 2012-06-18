FHINI0O7	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1742,25)
	;;=FHPRC10
	;;^UTILITY(U,$J,"OPT",1742,"U")
	;;=DISPLAY MEAL ANALYSIS
	;;^UTILITY(U,$J,"OPT",1759,0)
	;;=FHNU12^Enter Nutrients (Common Units)^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1759,1,0)
	;;=^^2^2^2931027^^^
	;;^UTILITY(U,$J,"OPT",1759,1,1,0)
	;;=This option allow user to enter Nutrients in Common Units to
	;;^UTILITY(U,$J,"OPT",1759,1,2,0)
	;;=calculate the value per 100 grams to be stored in file (112).
	;;^UTILITY(U,$J,"OPT",1759,25)
	;;=FHNUT
	;;^UTILITY(U,$J,"OPT",1759,"U")
	;;=ENTER NUTRIENTS (COMMON UNITS)
	;;^UTILITY(U,$J,"OPT",1816,0)
	;;=FHPRC14^Input Recipe Menu^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1816,1,0)
	;;=^^2^2^2950313^^^^
	;;^UTILITY(U,$J,"OPT",1816,1,1,0)
	;;=This option allows user to create and/or edit recipe menu
	;;^UTILITY(U,$J,"OPT",1816,1,2,0)
	;;=for the User Menu file (112.6) to be used for the Meal Analysis.
	;;^UTILITY(U,$J,"OPT",1816,25)
	;;=FHPRC13
	;;^UTILITY(U,$J,"OPT",1816,"U")
	;;=INPUT RECIPE MENU
	;;^UTILITY(U,$J,"OPT",1817,0)
	;;=FHREC13^Display Analyzed Recipes List^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1817,1,0)
	;;=^^3^3^2940113^
	;;^UTILITY(U,$J,"OPT",1817,1,1,0)
	;;=This option will display a list of recipe names that have been
	;;^UTILITY(U,$J,"OPT",1817,1,2,0)
	;;=analyzed and also the ones that have not been analyzed with
	;;^UTILITY(U,$J,"OPT",1817,1,3,0)
	;;='**' preceding the name.
	;;^UTILITY(U,$J,"OPT",1817,25)
	;;=FHREC7
	;;^UTILITY(U,$J,"OPT",1817,"U")
	;;=DISPLAY ANALYZED RECIPES LIST
	;;^UTILITY(U,$J,"OPT",1818,0)
	;;=FHMTKP^Print Tray Tickets^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1818,1,0)
	;;=^^3^3^2941109^^^^
	;;^UTILITY(U,$J,"OPT",1818,1,1,0)
	;;=This option allows the user to print tray tickets three patients
	;;^UTILITY(U,$J,"OPT",1818,1,2,0)
	;;=per page for a selected patient, a ward, a Communication Office, or
	;;^UTILITY(U,$J,"OPT",1818,1,3,0)
	;;=all for one meal or all three meals.
	;;^UTILITY(U,$J,"OPT",1818,25)
	;;=FHMTK1
	;;^UTILITY(U,$J,"OPT",1818,"U")
	;;=PRINT TRAY TICKETS
	;;^UTILITY(U,$J,"OPT",1820,0)
	;;=FHMTKM^Tray Tickets^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1820,1,0)
	;;=^^2^2^2950302^^^^
	;;^UTILITY(U,$J,"OPT",1820,1,1,0)
	;;=This menu contains the options for producing the Diet Cards,
	;;^UTILITY(U,$J,"OPT",1820,1,2,0)
	;;=Tray Tickets, and the Diet Pattern list.
	;;^UTILITY(U,$J,"OPT",1820,10,0)
	;;=^19.01PI^7^4
	;;^UTILITY(U,$J,"OPT",1820,10,4,0)
	;;=1818^PT
	;;^UTILITY(U,$J,"OPT",1820,10,4,"^")
	;;=FHMTKP
	;;^UTILITY(U,$J,"OPT",1820,10,5,0)
	;;=1821^PD
	;;^UTILITY(U,$J,"OPT",1820,10,5,"^")
	;;=FHDCRP
	;;^UTILITY(U,$J,"OPT",1820,10,6,0)
	;;=1828^LD
	;;^UTILITY(U,$J,"OPT",1820,10,6,"^")
	;;=FHMTKN
	;;^UTILITY(U,$J,"OPT",1820,10,7,0)
	;;=1829^HP
	;;^UTILITY(U,$J,"OPT",1820,10,7,"^")
	;;=FHMTKH
	;;^UTILITY(U,$J,"OPT",1820,99)
	;;=56496,40678
	;;^UTILITY(U,$J,"OPT",1820,"U")
	;;=TRAY TICKETS
	;;^UTILITY(U,$J,"OPT",1821,0)
	;;=FHDCRP^Print Diet Cards^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1821,1,0)
	;;=^^4^4^2941013^^^^
	;;^UTILITY(U,$J,"OPT",1821,1,1,0)
	;;=This option allows user to print Diet Cards that consist of
	;;^UTILITY(U,$J,"OPT",1821,1,2,0)
	;;=patients' Diet patterns.  The Diet Cards can be printed
	;;^UTILITY(U,$J,"OPT",1821,1,3,0)
	;;=two patients per page or three per page for a selected
	;;^UTILITY(U,$J,"OPT",1821,1,4,0)
	;;=patient, a ward, a Communication Office, or all.
	;;^UTILITY(U,$J,"OPT",1821,25)
	;;=FHDCR1
	;;^UTILITY(U,$J,"OPT",1821,"U")
	;;=PRINT DIET CARDS
	;;^UTILITY(U,$J,"OPT",1823,0)
	;;=FHMTKE^Enter/Edit Patient Diet Pattern^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1823,1,0)
	;;=^^2^2^2950719^^
	;;^UTILITY(U,$J,"OPT",1823,1,1,0)
	;;=This option allows the user to enter a specific Diet Pattern for
	;;^UTILITY(U,$J,"OPT",1823,1,2,0)
	;;=a selected patient for the three meals.
	;;^UTILITY(U,$J,"OPT",1823,25)
	;;=FHMTK3
	;;^UTILITY(U,$J,"OPT",1823,"U")
	;;=ENTER/EDIT PATIENT DIET PATTER
	;;^UTILITY(U,$J,"OPT",1825,0)
	;;=FHMTKS^Enter/Edit Diet Patterns^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1825,1,0)
	;;=^^3^3^2941013^^
	;;^UTILITY(U,$J,"OPT",1825,1,1,0)
	;;=This option allows the user to enter/edit a Diet pattern which
	;;^UTILITY(U,$J,"OPT",1825,1,2,0)
	;;=consist of Recipe Categories and the quantities for the purpose
	;;^UTILITY(U,$J,"OPT",1825,1,3,0)
	;;=of printing the Tray Tickets.
	;;^UTILITY(U,$J,"OPT",1825,25)
	;;=FHMTK
	;;^UTILITY(U,$J,"OPT",1825,"U")
	;;=ENTER/EDIT DIET PATTERNS
	;;^UTILITY(U,$J,"OPT",1826,0)
	;;=FHMTKT^List Diet Patterns^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1826,1,0)
	;;=^^2^2^2941109^^

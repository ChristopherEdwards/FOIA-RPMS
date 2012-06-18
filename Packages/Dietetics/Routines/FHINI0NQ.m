FHINI0NQ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1504,10,3,"^")
	;;=FHSP5
	;;^UTILITY(U,$J,"OPT",1504,10,5,0)
	;;=1628^SC
	;;^UTILITY(U,$J,"OPT",1504,10,5,"^")
	;;=FHSP7
	;;^UTILITY(U,$J,"OPT",1504,10,6,0)
	;;=1629^SL
	;;^UTILITY(U,$J,"OPT",1504,10,6,"^")
	;;=FHSP8
	;;^UTILITY(U,$J,"OPT",1504,99)
	;;=56496,40785
	;;^UTILITY(U,$J,"OPT",1504,"U")
	;;=STANDING ORDERS
	;;^UTILITY(U,$J,"OPT",1505,0)
	;;=FHBUD^Budget Asst. Menu^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1505,1,0)
	;;=^^3^3^2950307^^^^
	;;^UTILITY(U,$J,"OPT",1505,1,1,0)
	;;=This menu contains those options most likely to be performed
	;;^UTILITY(U,$J,"OPT",1505,1,2,0)
	;;=by a budget assistant -- administrative reports, cost updating,
	;;^UTILITY(U,$J,"OPT",1505,1,3,0)
	;;=projected requirements, etc.
	;;^UTILITY(U,$J,"OPT",1505,10,0)
	;;=^19.01PI^9^5
	;;^UTILITY(U,$J,"OPT",1505,10,1,0)
	;;=1486^AM
	;;^UTILITY(U,$J,"OPT",1505,10,1,"^")
	;;=FHADMR
	;;^UTILITY(U,$J,"OPT",1505,10,2,0)
	;;=1512^XI
	;;^UTILITY(U,$J,"OPT",1505,10,2,"^")
	;;=FHINGM
	;;^UTILITY(U,$J,"OPT",1505,10,7,0)
	;;=1547^PU
	;;^UTILITY(U,$J,"OPT",1505,10,7,"^")
	;;=FHPRR1
	;;^UTILITY(U,$J,"OPT",1505,10,8,0)
	;;=1549^IC
	;;^UTILITY(U,$J,"OPT",1505,10,8,"^")
	;;=FHADMR8
	;;^UTILITY(U,$J,"OPT",1505,10,9,0)
	;;=1527^WP
	;;^UTILITY(U,$J,"OPT",1505,10,9,"^")
	;;=FHPRC7
	;;^UTILITY(U,$J,"OPT",1505,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1505,20)
	;;=S FHA1=4 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1505,99)
	;;=56496,40768
	;;^UTILITY(U,$J,"OPT",1505,"U")
	;;=BUDGET ASST. MENU
	;;^UTILITY(U,$J,"OPT",1506,0)
	;;=FHNO12^History of Supplemental Feedings^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1506,1,0)
	;;=2^^2^2^2941114^^^
	;;^UTILITY(U,$J,"OPT",1506,1,1,0)
	;;=This option will display all Supplemental Feeding orders
	;;^UTILITY(U,$J,"OPT",1506,1,2,0)
	;;=entered for this patient's admission.
	;;^UTILITY(U,$J,"OPT",1506,25)
	;;=FHNO8
	;;^UTILITY(U,$J,"OPT",1506,"U")
	;;=HISTORY OF SUPPLEMENTAL FEEDIN
	;;^UTILITY(U,$J,"OPT",1507,0)
	;;=FHING3^Enter/Edit Ingredients^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1507,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1507,1,1,0)
	;;=This option allows the user to add and/or edit entries in
	;;^UTILITY(U,$J,"OPT",1507,1,2,0)
	;;=the Ingredient file (113).
	;;^UTILITY(U,$J,"OPT",1507,25)
	;;=EN3^FHPRI
	;;^UTILITY(U,$J,"OPT",1507,"U")
	;;=ENTER/EDIT INGREDIENTS
	;;^UTILITY(U,$J,"OPT",1508,0)
	;;=FHING1^Enter/Edit Units^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1508,1,0)
	;;=^^2^2^2920604^^^^
	;;^UTILITY(U,$J,"OPT",1508,1,1,0)
	;;=This option allows the user to add and/or edit entries in the
	;;^UTILITY(U,$J,"OPT",1508,1,2,0)
	;;=Units file (119.1).
	;;^UTILITY(U,$J,"OPT",1508,25)
	;;=EN1^FHPRI
	;;^UTILITY(U,$J,"OPT",1508,"U")
	;;=ENTER/EDIT UNITS
	;;^UTILITY(U,$J,"OPT",1509,0)
	;;=FHING2^Enter/Edit Vendor File^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1509,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1509,1,1,0)
	;;=This option allows the user to add and/or edit entries in
	;;^UTILITY(U,$J,"OPT",1509,1,2,0)
	;;=the Vendor file (113.2)
	;;^UTILITY(U,$J,"OPT",1509,25)
	;;=EN2^FHPRI
	;;^UTILITY(U,$J,"OPT",1509,"U")
	;;=ENTER/EDIT VENDOR FILE
	;;^UTILITY(U,$J,"OPT",1510,0)
	;;=FHREC1^Enter/Edit Recipes^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1510,1,0)
	;;=2^^2^2^2920605^
	;;^UTILITY(U,$J,"OPT",1510,1,1,0)
	;;=This option allows for the creation and/or editing of recipes
	;;^UTILITY(U,$J,"OPT",1510,1,2,0)
	;;=in the Recipe file (114).
	;;^UTILITY(U,$J,"OPT",1510,25)
	;;=EN1^FHREC
	;;^UTILITY(U,$J,"OPT",1510,"U")
	;;=ENTER/EDIT RECIPES
	;;^UTILITY(U,$J,"OPT",1511,0)
	;;=FHING4^Enter/Edit Storage Locations^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1511,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1511,1,1,0)
	;;=This option allows the user to add and/or edit entries in
	;;^UTILITY(U,$J,"OPT",1511,1,2,0)
	;;=the Storage Location file (113.1).
	;;^UTILITY(U,$J,"OPT",1511,25)
	;;=EN4^FHPRI
	;;^UTILITY(U,$J,"OPT",1511,"U")
	;;=ENTER/EDIT STORAGE LOCATIONS
	;;^UTILITY(U,$J,"OPT",1512,0)
	;;=FHINGM^Ingredient Management^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1512,1,0)
	;;=^^4^4^2950714^^^^
	;;^UTILITY(U,$J,"OPT",1512,1,1,0)
	;;=This menu allows access to all options pertaining to the
	;;^UTILITY(U,$J,"OPT",1512,1,2,0)
	;;=management of the Ingredient file and the ingredient related
	;;^UTILITY(U,$J,"OPT",1512,1,3,0)
	;;=files such as the Units file, Vendor file, and Storage
	;;^UTILITY(U,$J,"OPT",1512,1,4,0)
	;;=Location file.
	;;^UTILITY(U,$J,"OPT",1512,10,0)
	;;=^19.01PI^14^13
	;;^UTILITY(U,$J,"OPT",1512,10,1,0)
	;;=1508^UE
	;;^UTILITY(U,$J,"OPT",1512,10,1,"^")
	;;=FHING1
	;;^UTILITY(U,$J,"OPT",1512,10,2,0)
	;;=1509^VE
	;;^UTILITY(U,$J,"OPT",1512,10,2,"^")
	;;=FHING2

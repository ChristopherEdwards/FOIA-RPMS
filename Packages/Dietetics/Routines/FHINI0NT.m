FHINI0NT	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1521,1,2,0)
	;;=entry in the Menu Cycle file (116).
	;;^UTILITY(U,$J,"OPT",1521,25)
	;;=EN2^FHPRC
	;;^UTILITY(U,$J,"OPT",1521,"U")
	;;=ENTER/EDIT MENU CYCLE
	;;^UTILITY(U,$J,"OPT",1522,0)
	;;=FHPRC2^Menu Cycle Effective Dates^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1522,1,0)
	;;=^^2^2^2880716^^
	;;^UTILITY(U,$J,"OPT",1522,1,1,0)
	;;=This option allows for the entry or editing of the Effective
	;;^UTILITY(U,$J,"OPT",1522,1,2,0)
	;;=Date field in the Menu Cycle file (116).
	;;^UTILITY(U,$J,"OPT",1522,25)
	;;=EN2^FHPRC4
	;;^UTILITY(U,$J,"OPT",1522,"U")
	;;=MENU CYCLE EFFECTIVE DATES
	;;^UTILITY(U,$J,"OPT",1523,0)
	;;=FHPRC3^Menu Cycle Query^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1523,1,0)
	;;=^^4^4^2880718^^^
	;;^UTILITY(U,$J,"OPT",1523,1,1,0)
	;;=This option will display, for any date, the menu cycle that
	;;^UTILITY(U,$J,"OPT",1523,1,2,0)
	;;=is in effect as well as the three meals. In the case where holiday
	;;^UTILITY(U,$J,"OPT",1523,1,3,0)
	;;=meals have been entered into the Holiday Meal file, those
	;;^UTILITY(U,$J,"OPT",1523,1,4,0)
	;;=meals will over-ride the normal cycle meals.
	;;^UTILITY(U,$J,"OPT",1523,25)
	;;=EN1^FHPRC4
	;;^UTILITY(U,$J,"OPT",1523,"U")
	;;=MENU CYCLE QUERY
	;;^UTILITY(U,$J,"OPT",1524,0)
	;;=FHPRC4^Enter/Edit Meals^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1524,1,0)
	;;=^^2^2^2880716^^
	;;^UTILITY(U,$J,"OPT",1524,1,1,0)
	;;=This option allows for the creation/editing of a meal including
	;;^UTILITY(U,$J,"OPT",1524,1,2,0)
	;;=the associated recipes and production diets.
	;;^UTILITY(U,$J,"OPT",1524,25)
	;;=EN3^FHPRC
	;;^UTILITY(U,$J,"OPT",1524,"U")
	;;=ENTER/EDIT MEALS
	;;^UTILITY(U,$J,"OPT",1525,0)
	;;=FHPRC5^Enter/Edit Holiday Meals^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1525,1,0)
	;;=^^6^6^2890607^^^^
	;;^UTILITY(U,$J,"OPT",1525,1,1,0)
	;;=This option allows for the entry/editing of the Holiday Meals
	;;^UTILITY(U,$J,"OPT",1525,1,2,0)
	;;=file (116.3) in which meals may be specified for a holiday
	;;^UTILITY(U,$J,"OPT",1525,1,3,0)
	;;=which will override the normal cycle meals. Only those
	;;^UTILITY(U,$J,"OPT",1525,1,4,0)
	;;=meals selected will override; the absence of a specific
	;;^UTILITY(U,$J,"OPT",1525,1,5,0)
	;;=meal entry will result in the retention of the normal cycle
	;;^UTILITY(U,$J,"OPT",1525,1,6,0)
	;;=meal.
	;;^UTILITY(U,$J,"OPT",1525,25)
	;;=EN4^FHPRC
	;;^UTILITY(U,$J,"OPT",1525,"U")
	;;=ENTER/EDIT HOLIDAY MEALS
	;;^UTILITY(U,$J,"OPT",1526,0)
	;;=FHPRC6^List Meal^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1526,1,0)
	;;=^^2^2^2880716^^
	;;^UTILITY(U,$J,"OPT",1526,1,1,0)
	;;=This option will list a meal contained in the Meal file (116.1)
	;;^UTILITY(U,$J,"OPT",1526,1,2,0)
	;;=as well as the associated recipes and production diets.
	;;^UTILITY(U,$J,"OPT",1526,25)
	;;=FHPRC3
	;;^UTILITY(U,$J,"OPT",1526,"U")
	;;=LIST MEAL
	;;^UTILITY(U,$J,"OPT",1527,0)
	;;=FHPRC7^Print Weekly Menu^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1527,1,0)
	;;=^^5^5^2920226^^^^
	;;^UTILITY(U,$J,"OPT",1527,1,1,0)
	;;=This option will print a seven day menu containing the 
	;;^UTILITY(U,$J,"OPT",1527,1,2,0)
	;;=individual recipes to be served at breakfast, noon, and
	;;^UTILITY(U,$J,"OPT",1527,1,3,0)
	;;=evening for each of the seven days. The meals, from which
	;;^UTILITY(U,$J,"OPT",1527,1,4,0)
	;;=the recipes are taken, are those that are or will be effective
	;;^UTILITY(U,$J,"OPT",1527,1,5,0)
	;;=during the week chosen.
	;;^UTILITY(U,$J,"OPT",1527,25)
	;;=FHPRC2
	;;^UTILITY(U,$J,"OPT",1527,"U")
	;;=PRINT WEEKLY MENU
	;;^UTILITY(U,$J,"OPT",1528,0)
	;;=FHREC3^List Recipes^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1528,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1528,1,1,0)
	;;=This option will list all recipes contained in the Recipe
	;;^UTILITY(U,$J,"OPT",1528,1,2,0)
	;;=file (114) and their associated data elements.
	;;^UTILITY(U,$J,"OPT",1528,25)
	;;=FHREC4
	;;^UTILITY(U,$J,"OPT",1528,"U")
	;;=LIST RECIPES
	;;^UTILITY(U,$J,"OPT",1529,0)
	;;=FHING5^List Ingredients - Recipe Data^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1529,1,0)
	;;=^^4^4^2890606^^^^
	;;^UTILITY(U,$J,"OPT",1529,1,1,0)
	;;=This option will list all ingredients along with data elements
	;;^UTILITY(U,$J,"OPT",1529,1,2,0)
	;;=associated with recipe preparation such as unit of issue, recipe
	;;^UTILITY(U,$J,"OPT",1529,1,3,0)
	;;=unit, number of recipe units in an issue unit, storage location,
	;;^UTILITY(U,$J,"OPT",1529,1,4,0)
	;;=thaw days, etc.
	;;^UTILITY(U,$J,"OPT",1529,25)
	;;=LIS1^FHPRI2
	;;^UTILITY(U,$J,"OPT",1529,"U")
	;;=LIST INGREDIENTS - RECIPE DATA
	;;^UTILITY(U,$J,"OPT",1530,0)
	;;=FHING6^List Units^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1530,1,0)
	;;=^^2^2^2880717^

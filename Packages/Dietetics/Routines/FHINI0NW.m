FHINI0NW	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1546,0)
	;;=FHING51^List Ingredients - Purchasing Data^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1546,1,0)
	;;=^^3^3^2920915^^^
	;;^UTILITY(U,$J,"OPT",1546,1,1,0)
	;;=This option will list all ingredients along with data elements
	;;^UTILITY(U,$J,"OPT",1546,1,2,0)
	;;=associated with purchasing the item: stock number, unit of
	;;^UTILITY(U,$J,"OPT",1546,1,3,0)
	;;=purchase, vendor, purchase price, etc.
	;;^UTILITY(U,$J,"OPT",1546,25)
	;;=LIS2^FHPRI2
	;;^UTILITY(U,$J,"OPT",1546,"U")
	;;=LIST INGREDIENTS - PURCHASING 
	;;^UTILITY(U,$J,"OPT",1547,0)
	;;=FHPRR1^Projected Usage^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1547,1,0)
	;;=^^5^5^2880717^
	;;^UTILITY(U,$J,"OPT",1547,1,1,0)
	;;=This option will produce, for a specified time period, the
	;;^UTILITY(U,$J,"OPT",1547,1,2,0)
	;;=ingredients and amounts needed in order to meet production
	;;^UTILITY(U,$J,"OPT",1547,1,3,0)
	;;=requirements. The production requirements are based upon the
	;;^UTILITY(U,$J,"OPT",1547,1,4,0)
	;;=menu cycle in effect and a specified average census for the
	;;^UTILITY(U,$J,"OPT",1547,1,5,0)
	;;=time period.
	;;^UTILITY(U,$J,"OPT",1547,25)
	;;=FHPRR1
	;;^UTILITY(U,$J,"OPT",1547,"U")
	;;=PROJECTED USAGE
	;;^UTILITY(U,$J,"OPT",1548,0)
	;;=FHREC10^Re-cost Recipes^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1548,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1548,1,1,0)
	;;=This option will re-price all recipes producing a cost/portion
	;;^UTILITY(U,$J,"OPT",1548,1,2,0)
	;;=using the latest prices in the Ingredient file.
	;;^UTILITY(U,$J,"OPT",1548,25)
	;;=FHREC3
	;;^UTILITY(U,$J,"OPT",1548,"U")
	;;=RE-COST RECIPES
	;;^UTILITY(U,$J,"OPT",1549,0)
	;;=FHADMR8^Edit Ingredient Cost^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1549,1,0)
	;;=2
	;;^UTILITY(U,$J,"OPT",1549,1,1,0)
	;;=This option allows for editing only the item cost field
	;;^UTILITY(U,$J,"OPT",1549,1,2,0)
	;;=in the Ingredient file (113).
	;;^UTILITY(U,$J,"OPT",1549,25)
	;;=EN3^FHADM5
	;;^UTILITY(U,$J,"OPT",1549,"U")
	;;=EDIT INGREDIENT COST
	;;^UTILITY(U,$J,"OPT",1550,0)
	;;=FHBIR^Birthday List^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1550,1,0)
	;;=^^3^3^2900920^^^
	;;^UTILITY(U,$J,"OPT",1550,1,1,0)
	;;=This option will print a list of all patients with a birthday in
	;;^UTILITY(U,$J,"OPT",1550,1,2,0)
	;;=a particular month or those with a birthday on a specific month
	;;^UTILITY(U,$J,"OPT",1550,1,3,0)
	;;=and day.
	;;^UTILITY(U,$J,"OPT",1550,25)
	;;=FHBIR
	;;^UTILITY(U,$J,"OPT",1550,99)
	;;=55593,31173
	;;^UTILITY(U,$J,"OPT",1550,"U")
	;;=BIRTHDAY LIST
	;;^UTILITY(U,$J,"OPT",1551,0)
	;;=FHPRC8^List Menu Cycle^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1551,1,0)
	;;=^^3^3^2880716^^
	;;^UTILITY(U,$J,"OPT",1551,1,1,0)
	;;=This option will list a specific menu cycle, showing for each
	;;^UTILITY(U,$J,"OPT",1551,1,2,0)
	;;=day of the cycle what meal will be served for breakfast, noon
	;;^UTILITY(U,$J,"OPT",1551,1,3,0)
	;;=and evening.
	;;^UTILITY(U,$J,"OPT",1551,25)
	;;=FHPRC5
	;;^UTILITY(U,$J,"OPT",1551,"U")
	;;=LIST MENU CYCLE
	;;^UTILITY(U,$J,"OPT",1552,0)
	;;=FHPRO6^List Dietetic Wards^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1552,1,0)
	;;=^^3^3^2920915^^^^
	;;^UTILITY(U,$J,"OPT",1552,1,1,0)
	;;=This option will list the dietetic wards contained in the
	;;^UTILITY(U,$J,"OPT",1552,1,2,0)
	;;=Dietetics Ward file (119.6) along with all of the associated
	;;^UTILITY(U,$J,"OPT",1552,1,3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"OPT",1552,25)
	;;=FHPRW
	;;^UTILITY(U,$J,"OPT",1552,"U")
	;;=LIST DIETETIC WARDS
	;;^UTILITY(U,$J,"OPT",1553,0)
	;;=FHPRC9^Edit Meal Production Diets^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1553,1,0)
	;;=^^4^4^2880716^^
	;;^UTILITY(U,$J,"OPT",1553,1,1,0)
	;;=This option allows for editing the production diets associated
	;;^UTILITY(U,$J,"OPT",1553,1,2,0)
	;;=with a recipe in a meal. It is designed for rapid and easy
	;;^UTILITY(U,$J,"OPT",1553,1,3,0)
	;;=modification of the production diet string associated with
	;;^UTILITY(U,$J,"OPT",1553,1,4,0)
	;;=the recipes.
	;;^UTILITY(U,$J,"OPT",1553,25)
	;;=FHPRC6
	;;^UTILITY(U,$J,"OPT",1553,"U")
	;;=EDIT MEAL PRODUCTION DIETS
	;;^UTILITY(U,$J,"OPT",1554,0)
	;;=FHX1^Check Integrity of Routines^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1554,1,0)
	;;=^^4^4^2890223^^
	;;^UTILITY(U,$J,"OPT",1554,1,1,0)
	;;=This option will check the integrity of all dietetic system
	;;^UTILITY(U,$J,"OPT",1554,1,2,0)
	;;=routines. An error will be shown for any routine which has been
	;;^UTILITY(U,$J,"OPT",1554,1,3,0)
	;;=modified. Routines for which patches have been issued will
	;;^UTILITY(U,$J,"OPT",1554,1,4,0)
	;;=normally show an error.
	;;^UTILITY(U,$J,"OPT",1554,25)
	;;=FHNTEG

FHINI0O6	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1635,"U")
	;;=LIST PATIENT EVENTS
	;;^UTILITY(U,$J,"OPT",1636,0)
	;;=FHADR9^Enter/Edit Nutritive Analysis Average^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1636,1,0)
	;;=^^2^2^2930406^^^^
	;;^UTILITY(U,$J,"OPT",1636,1,1,0)
	;;=This option allows user to Enter or Edit the Nutritiive Analysis
	;;^UTILITY(U,$J,"OPT",1636,1,2,0)
	;;=Average of one week regular menu.
	;;^UTILITY(U,$J,"OPT",1636,25)
	;;=EN1^FHADR61
	;;^UTILITY(U,$J,"OPT",1636,"U")
	;;=ENTER/EDIT NUTRITIVE ANALYSIS 
	;;^UTILITY(U,$J,"OPT",1707,0)
	;;=FHING52^List Ingredients - Nutrient Data^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1707,1,0)
	;;=^^4^4^2930331^^^^
	;;^UTILITY(U,$J,"OPT",1707,1,1,0)
	;;=This option will list all ingredients along with data elements
	;;^UTILITY(U,$J,"OPT",1707,1,2,0)
	;;=associated with food nutrient for running the recipe analysis
	;;^UTILITY(U,$J,"OPT",1707,1,3,0)
	;;=such as default nutrient, recipe unit, and weight of recipe unit
	;;^UTILITY(U,$J,"OPT",1707,1,4,0)
	;;=in LBS.
	;;^UTILITY(U,$J,"OPT",1707,25)
	;;=LIS3^FHPRI2
	;;^UTILITY(U,$J,"OPT",1707,"U")
	;;=LIST INGREDIENTS - NUTRIENT DA
	;;^UTILITY(U,$J,"OPT",1708,0)
	;;=FHORTFM^Tubefeeding Reports/Labels^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1708,1,0)
	;;=^^3^3^2930429^^^^
	;;^UTILITY(U,$J,"OPT",1708,1,1,0)
	;;=This is a menu which contains the options to display the
	;;^UTILITY(U,$J,"OPT",1708,1,2,0)
	;;=Preparation/Delivery of Tubefeedings, the Tubefeeding
	;;^UTILITY(U,$J,"OPT",1708,1,3,0)
	;;=Preparation, and the Tubefeeding Labels.
	;;^UTILITY(U,$J,"OPT",1708,10,0)
	;;=^19.01PI^4^4
	;;^UTILITY(U,$J,"OPT",1708,10,1,0)
	;;=1625^TF
	;;^UTILITY(U,$J,"OPT",1708,10,1,"^")
	;;=FHORTF5
	;;^UTILITY(U,$J,"OPT",1708,10,2,0)
	;;=1626^TL
	;;^UTILITY(U,$J,"OPT",1708,10,2,"^")
	;;=FHORTF5L
	;;^UTILITY(U,$J,"OPT",1708,10,3,0)
	;;=1630^TP
	;;^UTILITY(U,$J,"OPT",1708,10,3,"^")
	;;=FHORTF5P
	;;^UTILITY(U,$J,"OPT",1708,10,4,0)
	;;=1710^TX
	;;^UTILITY(U,$J,"OPT",1708,10,4,"^")
	;;=FHORT5S
	;;^UTILITY(U,$J,"OPT",1708,99)
	;;=56496,40737
	;;^UTILITY(U,$J,"OPT",1708,"U")
	;;=TUBEFEEDING REPORTS/LABELS
	;;^UTILITY(U,$J,"OPT",1709,0)
	;;=FHASNRR^Clinical Management Report^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1709,1,0)
	;;=^^2^2^2930415^^^
	;;^UTILITY(U,$J,"OPT",1709,1,1,0)
	;;=This menu allows user to access the Encounter Statistics, Nutrition
	;;^UTILITY(U,$J,"OPT",1709,1,2,0)
	;;=Status Summary, Nutrition Average, and Nutrition Matrix.
	;;^UTILITY(U,$J,"OPT",1709,10,0)
	;;=^19.01PI^4^4
	;;^UTILITY(U,$J,"OPT",1709,10,1,0)
	;;=1592^NS
	;;^UTILITY(U,$J,"OPT",1709,10,1,"^")
	;;=FHASNR
	;;^UTILITY(U,$J,"OPT",1709,10,2,0)
	;;=1607^NZ
	;;^UTILITY(U,$J,"OPT",1709,10,2,"^")
	;;=FHASNR2
	;;^UTILITY(U,$J,"OPT",1709,10,3,0)
	;;=1634^NA
	;;^UTILITY(U,$J,"OPT",1709,10,3,"^")
	;;=FHASNR5
	;;^UTILITY(U,$J,"OPT",1709,10,4,0)
	;;=1588^SE
	;;^UTILITY(U,$J,"OPT",1709,10,4,"^")
	;;=FHASE4
	;;^UTILITY(U,$J,"OPT",1709,99)
	;;=56496,40636
	;;^UTILITY(U,$J,"OPT",1709,"U")
	;;=CLINICAL MANAGEMENT REPORT
	;;^UTILITY(U,$J,"OPT",1710,0)
	;;=FHORT5S^Tubefeeding Pull Lists^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1710,1,0)
	;;=^^3^3^2930427^
	;;^UTILITY(U,$J,"OPT",1710,1,1,0)
	;;=This option will print pick lists for all tubefeeding products for
	;;^UTILITY(U,$J,"OPT",1710,1,2,0)
	;;=the selected Communication Office or Ward as well as a consolidated
	;;^UTILITY(U,$J,"OPT",1710,1,3,0)
	;;=pick list when all Communication Offices or Wards are selected.
	;;^UTILITY(U,$J,"OPT",1710,25)
	;;=PULL^FHORT5
	;;^UTILITY(U,$J,"OPT",1710,"U")
	;;=TUBEFEEDING PULL LISTS
	;;^UTILITY(U,$J,"OPT",1711,0)
	;;=FHREC11^Analyze All Recipes^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1711,1,0)
	;;=^^2^2^2940113^^
	;;^UTILITY(U,$J,"OPT",1711,1,1,0)
	;;=This option will re-analyze all recipes using the current nutrient
	;;^UTILITY(U,$J,"OPT",1711,1,2,0)
	;;=values in File 112. Updated results will be stored in 112.
	;;^UTILITY(U,$J,"OPT",1711,25)
	;;=ALL^FHREC5
	;;^UTILITY(U,$J,"OPT",1711,"U")
	;;=ANALYZE ALL RECIPES
	;;^UTILITY(U,$J,"OPT",1712,0)
	;;=FHREC12^Display Recipe Analysis^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1712,1,0)
	;;=^^1^1^2940113^^^
	;;^UTILITY(U,$J,"OPT",1712,1,1,0)
	;;=This option will display the nutrient analysis of a recipe.
	;;^UTILITY(U,$J,"OPT",1712,25)
	;;=FHREC6
	;;^UTILITY(U,$J,"OPT",1712,"U")
	;;=DISPLAY RECIPE ANALYSIS
	;;^UTILITY(U,$J,"OPT",1742,0)
	;;=FHPRC13^Display Meal Analysis^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1742,1,0)
	;;=^^2^2^2940104^^^^
	;;^UTILITY(U,$J,"OPT",1742,1,1,0)
	;;=This option will produce a nutrient analysis for a selected meal from
	;;^UTILITY(U,$J,"OPT",1742,1,2,0)
	;;=the Meal file using the nutrient analysis of the recipes.

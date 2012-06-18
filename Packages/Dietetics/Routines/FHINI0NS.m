FHINI0NS	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1516,1,2,0)
	;;=a Production Facility for a specified date. The forecast is based
	;;^UTILITY(U,$J,"OPT",1516,1,3,0)
	;;=upon MAS census counts for the same day of the week for
	;;^UTILITY(U,$J,"OPT",1516,1,4,0)
	;;=the last 9 occurrences and is then corrected by examining
	;;^UTILITY(U,$J,"OPT",1516,1,5,0)
	;;=the error between the forecast and the actual census for
	;;^UTILITY(U,$J,"OPT",1516,1,6,0)
	;;=the most recent three days.
	;;^UTILITY(U,$J,"OPT",1516,25)
	;;=FHPRF1
	;;^UTILITY(U,$J,"OPT",1516,"U")
	;;=FORECASTED DIET CENSUS
	;;^UTILITY(U,$J,"OPT",1517,0)
	;;=FHPRF4^List Production Diet Percentages^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1517,1,0)
	;;=^^2^2^2911212^^^^
	;;^UTILITY(U,$J,"OPT",1517,1,1,0)
	;;=This option will list the percentage of total census represented
	;;^UTILITY(U,$J,"OPT",1517,1,2,0)
	;;=by each production diet for each day of the week for a Service Point.
	;;^UTILITY(U,$J,"OPT",1517,25)
	;;=FHPRF2
	;;^UTILITY(U,$J,"OPT",1517,"U")
	;;=LIST PRODUCTION DIET PERCENTAG
	;;^UTILITY(U,$J,"OPT",1518,0)
	;;=FHPRO5^Meal Production Reports^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1518,1,0)
	;;=^^7^7^2930713^^^^
	;;^UTILITY(U,$J,"OPT",1518,1,1,0)
	;;=This option will produce, for a selected Production Facility
	;;^UTILITY(U,$J,"OPT",1518,1,2,0)
	;;=and meal, the ingredient requirements in the form of a
	;;^UTILITY(U,$J,"OPT",1518,1,3,0)
	;;=stockroom requisition list, the preparation requirements in
	;;^UTILITY(U,$J,"OPT",1518,1,4,0)
	;;=terms of all recipes needing preparation and the required
	;;^UTILITY(U,$J,"OPT",1518,1,5,0)
	;;=ingredient amounts, and service reports indicating the number
	;;^UTILITY(U,$J,"OPT",1518,1,6,0)
	;;=of portions of each recipe needed by Service Point as well as
	;;^UTILITY(U,$J,"OPT",1518,1,7,0)
	;;=the production diets associated with each recipe.
	;;^UTILITY(U,$J,"OPT",1518,25)
	;;=FHPRO1
	;;^UTILITY(U,$J,"OPT",1518,"U")
	;;=MEAL PRODUCTION REPORTS
	;;^UTILITY(U,$J,"OPT",1519,0)
	;;=FHPRCM^Menu Cycle Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1519,1,0)
	;;=^^2^2^2931201^^^^
	;;^UTILITY(U,$J,"OPT",1519,1,1,0)
	;;=This menu contains all of the various menu cycle options
	;;^UTILITY(U,$J,"OPT",1519,1,2,0)
	;;=and is designed for the management of the Menu Cycle.
	;;^UTILITY(U,$J,"OPT",1519,10,0)
	;;=^19.01PI^14^13
	;;^UTILITY(U,$J,"OPT",1519,10,1,0)
	;;=1521^CE
	;;^UTILITY(U,$J,"OPT",1519,10,1,"^")
	;;=FHPRC1
	;;^UTILITY(U,$J,"OPT",1519,10,2,0)
	;;=1522^CD
	;;^UTILITY(U,$J,"OPT",1519,10,2,"^")
	;;=FHPRC2
	;;^UTILITY(U,$J,"OPT",1519,10,3,0)
	;;=1523^CQ
	;;^UTILITY(U,$J,"OPT",1519,10,3,"^")
	;;=FHPRC3
	;;^UTILITY(U,$J,"OPT",1519,10,4,0)
	;;=1524^ME
	;;^UTILITY(U,$J,"OPT",1519,10,4,"^")
	;;=FHPRC4
	;;^UTILITY(U,$J,"OPT",1519,10,5,0)
	;;=1525^HE
	;;^UTILITY(U,$J,"OPT",1519,10,5,"^")
	;;=FHPRC5
	;;^UTILITY(U,$J,"OPT",1519,10,6,0)
	;;=1526^ML
	;;^UTILITY(U,$J,"OPT",1519,10,6,"^")
	;;=FHPRC6
	;;^UTILITY(U,$J,"OPT",1519,10,7,0)
	;;=1527^WP
	;;^UTILITY(U,$J,"OPT",1519,10,7,"^")
	;;=FHPRC7
	;;^UTILITY(U,$J,"OPT",1519,10,8,0)
	;;=1551^CL
	;;^UTILITY(U,$J,"OPT",1519,10,8,"^")
	;;=FHPRC8
	;;^UTILITY(U,$J,"OPT",1519,10,9,0)
	;;=1553^MP
	;;^UTILITY(U,$J,"OPT",1519,10,9,"^")
	;;=FHPRC9
	;;^UTILITY(U,$J,"OPT",1519,10,11,0)
	;;=1567^DP
	;;^UTILITY(U,$J,"OPT",1519,10,11,"^")
	;;=FHPRC11
	;;^UTILITY(U,$J,"OPT",1519,10,12,0)
	;;=1610^WR
	;;^UTILITY(U,$J,"OPT",1519,10,12,"^")
	;;=FHPRC12
	;;^UTILITY(U,$J,"OPT",1519,10,13,0)
	;;=1742^DM
	;;^UTILITY(U,$J,"OPT",1519,10,13,"^")
	;;=FHPRC13
	;;^UTILITY(U,$J,"OPT",1519,10,14,0)
	;;=1816^CR
	;;^UTILITY(U,$J,"OPT",1519,10,14,"^")
	;;=FHPRC14
	;;^UTILITY(U,$J,"OPT",1519,99)
	;;=56496,40749
	;;^UTILITY(U,$J,"OPT",1519,"U")
	;;=MENU CYCLE MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1520,0)
	;;=FHREC2^Print Adjusted Recipe^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1520,1,0)
	;;=^^5^5^2880718^^^
	;;^UTILITY(U,$J,"OPT",1520,1,1,0)
	;;=This option will adjust and print an adjusted recipe. For
	;;^UTILITY(U,$J,"OPT",1520,1,2,0)
	;;=any specified number of portions, the ingredient requirements
	;;^UTILITY(U,$J,"OPT",1520,1,3,0)
	;;=will be linearly adjusted upward or downward based upon the
	;;^UTILITY(U,$J,"OPT",1520,1,4,0)
	;;=number of portions specified as compared to the number of
	;;^UTILITY(U,$J,"OPT",1520,1,5,0)
	;;=portions contained in the recipe.
	;;^UTILITY(U,$J,"OPT",1520,25)
	;;=EN2^FHREC2
	;;^UTILITY(U,$J,"OPT",1520,"U")
	;;=PRINT ADJUSTED RECIPE
	;;^UTILITY(U,$J,"OPT",1521,0)
	;;=FHPRC1^Enter/Edit Menu Cycle^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1521,1,0)
	;;=^^2^2^2880716^^
	;;^UTILITY(U,$J,"OPT",1521,1,1,0)
	;;=This option will allow the creation and/or editing of an

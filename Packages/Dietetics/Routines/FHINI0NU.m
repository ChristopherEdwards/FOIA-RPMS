FHINI0NU	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1530,1,1,0)
	;;=This option produces a listing of all of the entries in the
	;;^UTILITY(U,$J,"OPT",1530,1,2,0)
	;;=Units file (119.1).
	;;^UTILITY(U,$J,"OPT",1530,25)
	;;=EN6^FHPRI
	;;^UTILITY(U,$J,"OPT",1530,"U")
	;;=LIST UNITS
	;;^UTILITY(U,$J,"OPT",1531,0)
	;;=FHING7^List Vendors^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1531,1,0)
	;;=^^2^2^2950614^^
	;;^UTILITY(U,$J,"OPT",1531,1,1,0)
	;;=This option produces a list of all of the vendors in the
	;;^UTILITY(U,$J,"OPT",1531,1,2,0)
	;;=Vendor file (113.2) as well as all associated data elements.
	;;^UTILITY(U,$J,"OPT",1531,25)
	;;=FHPRI3
	;;^UTILITY(U,$J,"OPT",1531,"U")
	;;=LIST VENDORS
	;;^UTILITY(U,$J,"OPT",1532,0)
	;;=FHING8^List Storage Locations^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1532,1,0)
	;;=^^3^3^2880717^
	;;^UTILITY(U,$J,"OPT",1532,1,1,0)
	;;=This option produces a list of all storage locations contained
	;;^UTILITY(U,$J,"OPT",1532,1,2,0)
	;;=in the Storage Location file (113.1) as well as all associated
	;;^UTILITY(U,$J,"OPT",1532,1,3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"OPT",1532,25)
	;;=EN8^FHPRI
	;;^UTILITY(U,$J,"OPT",1532,"U")
	;;=LIST STORAGE LOCATIONS
	;;^UTILITY(U,$J,"OPT",1533,0)
	;;=FHPRF5^Enter/Edit Other Meals^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1533,1,0)
	;;=^^6^6^2911212^^^^
	;;^UTILITY(U,$J,"OPT",1533,1,1,0)
	;;=This option allows for the building of a table of other
	;;^UTILITY(U,$J,"OPT",1533,1,2,0)
	;;=meals. The table is by Service Point, day of the week, and
	;;^UTILITY(U,$J,"OPT",1533,1,3,0)
	;;=meal (breakfast, noon, evening). The values represent
	;;^UTILITY(U,$J,"OPT",1533,1,4,0)
	;;=other meals (for outpatients, residents, guests, volunteers,
	;;^UTILITY(U,$J,"OPT",1533,1,5,0)
	;;=etc.) that would not be included in the inpatient forecast or
	;;^UTILITY(U,$J,"OPT",1533,1,6,0)
	;;=census.
	;;^UTILITY(U,$J,"OPT",1533,25)
	;;=EN2^FHPRF
	;;^UTILITY(U,$J,"OPT",1533,"U")
	;;=ENTER/EDIT OTHER MEALS
	;;^UTILITY(U,$J,"OPT",1534,0)
	;;=FHPRF6^List Other Meals^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1534,1,0)
	;;=^^3^3^2911212^^^^
	;;^UTILITY(U,$J,"OPT",1534,1,1,0)
	;;=This option will list the Other Meals table showing for
	;;^UTILITY(U,$J,"OPT",1534,1,2,0)
	;;=each Service Point how many other meals are required
	;;^UTILITY(U,$J,"OPT",1534,1,3,0)
	;;=each day of the week for breakfast, noon, and evening.
	;;^UTILITY(U,$J,"OPT",1534,25)
	;;=FHPRF4
	;;^UTILITY(U,$J,"OPT",1534,"U")
	;;=LIST OTHER MEALS
	;;^UTILITY(U,$J,"OPT",1535,0)
	;;=FHING9^Enter/Edit Preparation Areas^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1535,1,0)
	;;=^^2^2^2920505^^
	;;^UTILITY(U,$J,"OPT",1535,1,1,0)
	;;=This option allows the user to add and/or edit entries in
	;;^UTILITY(U,$J,"OPT",1535,1,2,0)
	;;=the Preparation Area file (114.2).
	;;^UTILITY(U,$J,"OPT",1535,25)
	;;=EN9^FHREC
	;;^UTILITY(U,$J,"OPT",1535,"U")
	;;=ENTER/EDIT PREPARATION AREAS
	;;^UTILITY(U,$J,"OPT",1536,0)
	;;=FHING10^List Preparation Areas^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1536,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1536,1,1,0)
	;;=This option produces a listing of the entries in the
	;;^UTILITY(U,$J,"OPT",1536,1,2,0)
	;;=Preparation Area file (114.2).
	;;^UTILITY(U,$J,"OPT",1536,25)
	;;=EN10^FHREC
	;;^UTILITY(U,$J,"OPT",1536,"U")
	;;=LIST PREPARATION AREAS
	;;^UTILITY(U,$J,"OPT",1537,0)
	;;=FHING11^List Recipes Containing an Ingredient^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1537,1,0)
	;;=^^4^4^2880717^^
	;;^UTILITY(U,$J,"OPT",1537,1,1,0)
	;;=This option will produce a list of all recipes in the Recipe
	;;^UTILITY(U,$J,"OPT",1537,1,2,0)
	;;=file which contain a selected ingredient. In addition, the
	;;^UTILITY(U,$J,"OPT",1537,1,3,0)
	;;=listing shows which meals and menu cycle days reference
	;;^UTILITY(U,$J,"OPT",1537,1,4,0)
	;;=that recipe.
	;;^UTILITY(U,$J,"OPT",1537,25)
	;;=FHPRI1
	;;^UTILITY(U,$J,"OPT",1537,"U")
	;;=LIST RECIPES CONTAINING AN ING
	;;^UTILITY(U,$J,"OPT",1538,0)
	;;=FHADM^Production Reports^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1538,1,0)
	;;=^^2^2^2950302^^^^
	;;^UTILITY(U,$J,"OPT",1538,1,1,0)
	;;=This menu contains the lists and reports used for daily food
	;;^UTILITY(U,$J,"OPT",1538,1,2,0)
	;;=production.
	;;^UTILITY(U,$J,"OPT",1538,10,0)
	;;=^19.01PI^15^14
	;;^UTILITY(U,$J,"OPT",1538,10,2,0)
	;;=1518^MR
	;;^UTILITY(U,$J,"OPT",1538,10,2,"^")
	;;=FHPRO5
	;;^UTILITY(U,$J,"OPT",1538,10,3,0)
	;;=1520^RP
	;;^UTILITY(U,$J,"OPT",1538,10,3,"^")
	;;=FHREC2
	;;^UTILITY(U,$J,"OPT",1538,10,4,0)
	;;=1527^WP
	;;^UTILITY(U,$J,"OPT",1538,10,4,"^")
	;;=FHPRC7
	;;^UTILITY(U,$J,"OPT",1538,10,5,0)
	;;=1514^FM
	;;^UTILITY(U,$J,"OPT",1538,10,5,"^")
	;;=FHPRFM
	;;^UTILITY(U,$J,"OPT",1538,10,6,0)
	;;=1547^PU

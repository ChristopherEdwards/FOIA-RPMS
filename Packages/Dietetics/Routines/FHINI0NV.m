FHINI0NV	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1538,10,6,"^")
	;;=FHPRR1
	;;^UTILITY(U,$J,"OPT",1538,10,7,0)
	;;=1502^SO
	;;^UTILITY(U,$J,"OPT",1538,10,7,"^")
	;;=FHSP5
	;;^UTILITY(U,$J,"OPT",1538,10,8,0)
	;;=1421^WL
	;;^UTILITY(U,$J,"OPT",1538,10,8,"^")
	;;=FHNO3
	;;^UTILITY(U,$J,"OPT",1538,10,9,0)
	;;=1463^BW
	;;^UTILITY(U,$J,"OPT",1538,10,9,"^")
	;;=FHNO10
	;;^UTILITY(U,$J,"OPT",1538,10,10,0)
	;;=1420^LA
	;;^UTILITY(U,$J,"OPT",1538,10,10,"^")
	;;=FHNO2
	;;^UTILITY(U,$J,"OPT",1538,10,11,0)
	;;=1566^TP
	;;^UTILITY(U,$J,"OPT",1538,10,11,"^")
	;;=FHSEL5
	;;^UTILITY(U,$J,"OPT",1538,10,12,0)
	;;=1567^DP
	;;^UTILITY(U,$J,"OPT",1538,10,12,"^")
	;;=FHPRC11
	;;^UTILITY(U,$J,"OPT",1538,10,13,0)
	;;=1610^WR
	;;^UTILITY(U,$J,"OPT",1538,10,13,"^")
	;;=FHPRC12
	;;^UTILITY(U,$J,"OPT",1538,10,14,0)
	;;=1628^SP
	;;^UTILITY(U,$J,"OPT",1538,10,14,"^")
	;;=FHSP7
	;;^UTILITY(U,$J,"OPT",1538,10,15,0)
	;;=1629^SL
	;;^UTILITY(U,$J,"OPT",1538,10,15,"^")
	;;=FHSP8
	;;^UTILITY(U,$J,"OPT",1538,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1538,20)
	;;=S FHA1=7 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1538,99)
	;;=56496,40784
	;;^UTILITY(U,$J,"OPT",1538,"U")
	;;=PRODUCTION REPORTS
	;;^UTILITY(U,$J,"OPT",1539,0)
	;;=FHREC4^Enter/Edit Recipe Categories^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1539,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1539,1,1,0)
	;;=This option allows for the addition/editing of recipe
	;;^UTILITY(U,$J,"OPT",1539,1,2,0)
	;;=categories contained in the Recipe Category file (114.1).
	;;^UTILITY(U,$J,"OPT",1539,25)
	;;=EN3^FHREC
	;;^UTILITY(U,$J,"OPT",1539,"U")
	;;=ENTER/EDIT RECIPE CATEGORIES
	;;^UTILITY(U,$J,"OPT",1540,0)
	;;=FHREC5^List Recipe Categories^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1540,1,0)
	;;=^^3^3^2941027^^^
	;;^UTILITY(U,$J,"OPT",1540,1,1,0)
	;;=This option will list all of the recipe categories in the
	;;^UTILITY(U,$J,"OPT",1540,1,2,0)
	;;=Recipe Category file (114.1) and their associated data
	;;^UTILITY(U,$J,"OPT",1540,1,3,0)
	;;=elements.
	;;^UTILITY(U,$J,"OPT",1540,25)
	;;=EN4^FHREC
	;;^UTILITY(U,$J,"OPT",1540,"U")
	;;=LIST RECIPE CATEGORIES
	;;^UTILITY(U,$J,"OPT",1541,0)
	;;=FHPRO^Food Production^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1541,1,0)
	;;=^^3^3^2930713^^^^
	;;^UTILITY(U,$J,"OPT",1541,1,1,0)
	;;=This menu allows access to options needed frequently in
	;;^UTILITY(U,$J,"OPT",1541,1,2,0)
	;;=food production, including most recipe and menu cycle file management
	;;^UTILITY(U,$J,"OPT",1541,1,3,0)
	;;=options as well as all production reports.
	;;^UTILITY(U,$J,"OPT",1541,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",1541,10,1,0)
	;;=1538^PR
	;;^UTILITY(U,$J,"OPT",1541,10,1,"^")
	;;=FHADM
	;;^UTILITY(U,$J,"OPT",1541,10,2,0)
	;;=1519^XM
	;;^UTILITY(U,$J,"OPT",1541,10,2,"^")
	;;=FHPRCM
	;;^UTILITY(U,$J,"OPT",1541,10,3,0)
	;;=1513^XR
	;;^UTILITY(U,$J,"OPT",1541,10,3,"^")
	;;=FHRECM
	;;^UTILITY(U,$J,"OPT",1541,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1541,20)
	;;=S FHA1=7 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1541,99)
	;;=56496,40777
	;;^UTILITY(U,$J,"OPT",1541,"U")
	;;=FOOD PRODUCTION
	;;^UTILITY(U,$J,"OPT",1542,0)
	;;=FHREC6^Enter/Edit Serving Utensils^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1542,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1542,1,1,0)
	;;=This option allows for the addition/editing of serving
	;;^UTILITY(U,$J,"OPT",1542,1,2,0)
	;;=utensil names contained in the Serving Utensil file (114.3).
	;;^UTILITY(U,$J,"OPT",1542,25)
	;;=EN5^FHREC
	;;^UTILITY(U,$J,"OPT",1542,"U")
	;;=ENTER/EDIT SERVING UTENSILS
	;;^UTILITY(U,$J,"OPT",1543,0)
	;;=FHREC7^List Serving Utensils^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1543,1,0)
	;;=^^2^2^2890606^^^^
	;;^UTILITY(U,$J,"OPT",1543,1,1,0)
	;;=This option will list all serving utensils contained in the
	;;^UTILITY(U,$J,"OPT",1543,1,2,0)
	;;=Serving Utensil file (114.3).
	;;^UTILITY(U,$J,"OPT",1543,25)
	;;=EN6^FHREC
	;;^UTILITY(U,$J,"OPT",1543,"U")
	;;=LIST SERVING UTENSILS
	;;^UTILITY(U,$J,"OPT",1544,0)
	;;=FHREC8^Enter/Edit Equipment^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1544,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1544,1,1,0)
	;;=This option allows for the addition/editing of equipment names
	;;^UTILITY(U,$J,"OPT",1544,1,2,0)
	;;=contained in the Equipment file (114.4).
	;;^UTILITY(U,$J,"OPT",1544,25)
	;;=EN7^FHREC
	;;^UTILITY(U,$J,"OPT",1544,"U")
	;;=ENTER/EDIT EQUIPMENT
	;;^UTILITY(U,$J,"OPT",1545,0)
	;;=FHREC9^List Equipment^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1545,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1545,1,1,0)
	;;=This option will list all equipment names contained in the
	;;^UTILITY(U,$J,"OPT",1545,1,2,0)
	;;=Equipment file (114.4).
	;;^UTILITY(U,$J,"OPT",1545,25)
	;;=EN8^FHREC
	;;^UTILITY(U,$J,"OPT",1545,"U")
	;;=LIST EQUIPMENT

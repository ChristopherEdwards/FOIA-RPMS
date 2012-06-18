FHINI0ND	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1417,10,5,0)
	;;=1416^AA
	;;^UTILITY(U,$J,"OPT",1417,10,5,"^")
	;;=FHNU5
	;;^UTILITY(U,$J,"OPT",1417,10,6,0)
	;;=1415^NI
	;;^UTILITY(U,$J,"OPT",1417,10,6,"^")
	;;=FHNU8
	;;^UTILITY(U,$J,"OPT",1417,20)
	;;=W @IOF,!!?16,"E N E R G Y / N U T R I E N T   A N A L Y S I S",!!!
	;;^UTILITY(U,$J,"OPT",1417,99)
	;;=56496,40695
	;;^UTILITY(U,$J,"OPT",1417,"U")
	;;=ENERGY/NUTRIENT ANALYSIS
	;;^UTILITY(U,$J,"OPT",1418,0)
	;;=FHNO1I^Supplemental Feeding Inquiry^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1418,1,0)
	;;=^^1^1^2880717^^^^
	;;^UTILITY(U,$J,"OPT",1418,1,1,0)
	;;=Displays current supplemental feedings ordered for an inpatient.
	;;^UTILITY(U,$J,"OPT",1418,25)
	;;=EN2^FHNO7
	;;^UTILITY(U,$J,"OPT",1418,"U")
	;;=SUPPLEMENTAL FEEDING INQUIRY
	;;^UTILITY(U,$J,"OPT",1419,0)
	;;=FHNO1E^Change Patient Supplemental Feedings^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1419,1,0)
	;;=^^1^1^2880717^^^^
	;;^UTILITY(U,$J,"OPT",1419,1,1,0)
	;;=Allows editing of supplemental feedings ordered for an inpatient.
	;;^UTILITY(U,$J,"OPT",1419,25)
	;;=FHNO5
	;;^UTILITY(U,$J,"OPT",1419,"U")
	;;=CHANGE PATIENT SUPPLEMENTAL FE
	;;^UTILITY(U,$J,"OPT",1420,0)
	;;=FHNO2^Run SF Labels/Consolid Ingred List^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1420,1,0)
	;;=^^3^3^2930929^^^^
	;;^UTILITY(U,$J,"OPT",1420,1,1,0)
	;;=This option will produce supplemental feeding labels for any
	;;^UTILITY(U,$J,"OPT",1420,1,2,0)
	;;=selected feeding period as well as a consolidated ingredient
	;;^UTILITY(U,$J,"OPT",1420,1,3,0)
	;;=requirements list.
	;;^UTILITY(U,$J,"OPT",1420,25)
	;;=FHNO2
	;;^UTILITY(U,$J,"OPT",1420,"U")
	;;=RUN SF LABELS/CONSOLID INGRED 
	;;^UTILITY(U,$J,"OPT",1421,0)
	;;=FHNO3^Ward Supplemental Feeding Lists^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1421,1,0)
	;;=^^5^5^2881103^^^^
	;;^UTILITY(U,$J,"OPT",1421,1,1,0)
	;;=This option produces a page for each ward listing all patients
	;;^UTILITY(U,$J,"OPT",1421,1,2,0)
	;;=having a current supplemental feeding order as well as the
	;;^UTILITY(U,$J,"OPT",1421,1,3,0)
	;;=actual feeding items. Optionally, a site parameter allows for
	;;^UTILITY(U,$J,"OPT",1421,1,4,0)
	;;=this listing to contain an ingredient pick list for delivery
	;;^UTILITY(U,$J,"OPT",1421,1,5,0)
	;;=purposes if desired.
	;;^UTILITY(U,$J,"OPT",1421,25)
	;;=FHNO3
	;;^UTILITY(U,$J,"OPT",1421,"U")
	;;=WARD SUPPLEMENTAL FEEDING LIST
	;;^UTILITY(U,$J,"OPT",1422,0)
	;;=FHNOM^Supplemental Feedings^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1422,1,0)
	;;=^^2^2^2950315^^^^
	;;^UTILITY(U,$J,"OPT",1422,1,1,0)
	;;=This menu allows entry to all supplemental feeding options
	;;^UTILITY(U,$J,"OPT",1422,1,2,0)
	;;=except the file management options.
	;;^UTILITY(U,$J,"OPT",1422,10,0)
	;;=^19.01PI^12^7
	;;^UTILITY(U,$J,"OPT",1422,10,1,0)
	;;=1419^SF
	;;^UTILITY(U,$J,"OPT",1422,10,1,"^")
	;;=FHNO1E
	;;^UTILITY(U,$J,"OPT",1422,10,2,0)
	;;=1418^IN
	;;^UTILITY(U,$J,"OPT",1422,10,2,"^")
	;;=FHNO1I
	;;^UTILITY(U,$J,"OPT",1422,10,3,0)
	;;=1420^LA
	;;^UTILITY(U,$J,"OPT",1422,10,3,"^")
	;;=FHNO2
	;;^UTILITY(U,$J,"OPT",1422,10,4,0)
	;;=1421^WL
	;;^UTILITY(U,$J,"OPT",1422,10,4,"^")
	;;=FHNO3
	;;^UTILITY(U,$J,"OPT",1422,10,10,0)
	;;=1462^WR
	;;^UTILITY(U,$J,"OPT",1422,10,10,"^")
	;;=FHNO9
	;;^UTILITY(U,$J,"OPT",1422,10,11,0)
	;;=1463^WP
	;;^UTILITY(U,$J,"OPT",1422,10,11,"^")
	;;=FHNO10
	;;^UTILITY(U,$J,"OPT",1422,10,12,0)
	;;=1506^SH
	;;^UTILITY(U,$J,"OPT",1422,10,12,"^")
	;;=FHNO12
	;;^UTILITY(U,$J,"OPT",1422,20)
	;;=W @IOF,!!?19,"S U P P L E M E N T A L   F E E D I N G S",!!!
	;;^UTILITY(U,$J,"OPT",1422,99)
	;;=56496,40687
	;;^UTILITY(U,$J,"OPT",1422,"U")
	;;=SUPPLEMENTAL FEEDINGS
	;;^UTILITY(U,$J,"OPT",1423,0)
	;;=FHNU6^Enter/Edit Nutrients^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1423,1,0)
	;;=^^3^3^2890606^^
	;;^UTILITY(U,$J,"OPT",1423,1,1,0)
	;;=This option allows for additions and editing of entries in the
	;;^UTILITY(U,$J,"OPT",1423,1,2,0)
	;;=Food Nutrients file (112). The nutrient values for USDA items
	;;^UTILITY(U,$J,"OPT",1423,1,3,0)
	;;=cannot be edited.
	;;^UTILITY(U,$J,"OPT",1423,25)
	;;=EN2^FHNU
	;;^UTILITY(U,$J,"OPT",1423,"U")
	;;=ENTER/EDIT NUTRIENTS
	;;^UTILITY(U,$J,"OPT",1424,0)
	;;=FHNO4^Enter/Edit Supplemental Feedings^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1424,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1424,1,1,0)
	;;=This option allows for the addition/editing of items in the
	;;^UTILITY(U,$J,"OPT",1424,1,2,0)
	;;=Supplemental Feedings file (118).
	;;^UTILITY(U,$J,"OPT",1424,25)
	;;=EN3^FHNO1
	;;^UTILITY(U,$J,"OPT",1424,"U")
	;;=ENTER/EDIT SUPPLEMENTAL FEEDIN
	;;^UTILITY(U,$J,"OPT",1425,0)
	;;=FHNO6^Enter/Edit Supplemental Feeding Menus^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1425,1,0)
	;;=^^2^2^2880717^^

FHINI0O1	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1592,1,2,0)
	;;=by either ward or by clinician.
	;;^UTILITY(U,$J,"OPT",1592,25)
	;;=FHASN1
	;;^UTILITY(U,$J,"OPT",1592,"U")
	;;=NUTRITION STATUS SUMMARY
	;;^UTILITY(U,$J,"OPT",1593,0)
	;;=FHASP1^Print Nutrition Profile^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1593,1,0)
	;;=^^3^3^2950922^^^
	;;^UTILITY(U,$J,"OPT",1593,1,1,0)
	;;=This option will print a Nutrition Profile listing important
	;;^UTILITY(U,$J,"OPT",1593,1,2,0)
	;;=events, drugs, lab tests, etc. which may be of importance in
	;;^UTILITY(U,$J,"OPT",1593,1,3,0)
	;;=developing treatment recommendations.
	;;^UTILITY(U,$J,"OPT",1593,25)
	;;=FHASP
	;;^UTILITY(U,$J,"OPT",1593,"U")
	;;=PRINT NUTRITION PROFILE
	;;^UTILITY(U,$J,"OPT",1594,0)
	;;=FHADMR2A^Calculate NPO/Trays^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1594,1,0)
	;;=^^2^2^2930623^^^^
	;;^UTILITY(U,$J,"OPT",1594,1,1,0)
	;;=This option is used to calculate the number of NPO and
	;;^UTILITY(U,$J,"OPT",1594,1,2,0)
	;;=cafeteria meals served.
	;;^UTILITY(U,$J,"OPT",1594,25)
	;;=EN1^FHADM2A
	;;^UTILITY(U,$J,"OPT",1594,200)
	;;=2951011.1755^^1D^
	;;^UTILITY(U,$J,"OPT",1594,"U")
	;;=CALCULATE NPO/TRAYS
	;;^UTILITY(U,$J,"OPT",1595,0)
	;;=FHCTF^Tickler File^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1595,1,0)
	;;=^^1^1^2950302^^^
	;;^UTILITY(U,$J,"OPT",1595,1,1,0)
	;;=This is the menu of Tickler File options.
	;;^UTILITY(U,$J,"OPT",1595,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",1595,10,1,0)
	;;=1596^DI
	;;^UTILITY(U,$J,"OPT",1595,10,1,"^")
	;;=FHCTF1
	;;^UTILITY(U,$J,"OPT",1595,10,2,0)
	;;=1597^CL
	;;^UTILITY(U,$J,"OPT",1595,10,2,"^")
	;;=FHCTF2
	;;^UTILITY(U,$J,"OPT",1595,10,3,0)
	;;=1598^EN
	;;^UTILITY(U,$J,"OPT",1595,10,3,"^")
	;;=FHCTF3
	;;^UTILITY(U,$J,"OPT",1595,99)
	;;=56496,40646
	;;^UTILITY(U,$J,"OPT",1595,"U")
	;;=TICKLER FILE
	;;^UTILITY(U,$J,"OPT",1596,0)
	;;=FHCTF1^Display Tickler File^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1596,1,0)
	;;=^^3^3^2950302^^
	;;^UTILITY(U,$J,"OPT",1596,1,1,0)
	;;=This option will display all Tickler File entries for a
	;;^UTILITY(U,$J,"OPT",1596,1,2,0)
	;;=clinician. It scanns all wards for which the clinician is
	;;^UTILITY(U,$J,"OPT",1596,1,3,0)
	;;=responsible.
	;;^UTILITY(U,$J,"OPT",1596,25)
	;;=FHCTF1
	;;^UTILITY(U,$J,"OPT",1596,"U")
	;;=DISPLAY TICKLER FILE
	;;^UTILITY(U,$J,"OPT",1597,0)
	;;=FHCTF2^Clear Tickler File Entries^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1597,1,0)
	;;=^^2^2^2910820^
	;;^UTILITY(U,$J,"OPT",1597,1,1,0)
	;;=This option allows the clinician to clear Tickler File
	;;^UTILITY(U,$J,"OPT",1597,1,2,0)
	;;=entries by performing the required reviews.
	;;^UTILITY(U,$J,"OPT",1597,25)
	;;=FHCTF3
	;;^UTILITY(U,$J,"OPT",1597,"U")
	;;=CLEAR TICKLER FILE ENTRIES
	;;^UTILITY(U,$J,"OPT",1598,0)
	;;=FHCTF3^Enter Tickler File Item^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1598,1,0)
	;;=^^2^2^2910820^
	;;^UTILITY(U,$J,"OPT",1598,1,1,0)
	;;=This option allows for the entry of a 'personal' or non-patient
	;;^UTILITY(U,$J,"OPT",1598,1,2,0)
	;;=related Tickler File item.
	;;^UTILITY(U,$J,"OPT",1598,25)
	;;=EN1^FHCTF
	;;^UTILITY(U,$J,"OPT",1598,"U")
	;;=ENTER TICKLER FILE ITEM
	;;^UTILITY(U,$J,"OPT",1599,0)
	;;=FHPRO7^Enter/Edit Production Facilities^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1599,1,0)
	;;=^^3^3^2911204^
	;;^UTILITY(U,$J,"OPT",1599,1,1,0)
	;;=This option is used to enter and edit values for the various
	;;^UTILITY(U,$J,"OPT",1599,1,2,0)
	;;=Production Facilities. A Production Facility is generally a main
	;;^UTILITY(U,$J,"OPT",1599,1,3,0)
	;;=kitchen where bulk food is prepared.
	;;^UTILITY(U,$J,"OPT",1599,25)
	;;=EN5^FHPRO
	;;^UTILITY(U,$J,"OPT",1599,"U")
	;;=ENTER/EDIT PRODUCTION FACILITI
	;;^UTILITY(U,$J,"OPT",1600,0)
	;;=FHPRO8^Enter/Edit Service Points^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1600,1,0)
	;;=^^3^3^2911204^
	;;^UTILITY(U,$J,"OPT",1600,1,1,0)
	;;=This option is used to enter and edit values for Service Points.
	;;^UTILITY(U,$J,"OPT",1600,1,2,0)
	;;=Service Points are various tray assembly lines and cafeterias where
	;;^UTILITY(U,$J,"OPT",1600,1,3,0)
	;;=bulk food from the Production Facility is served.
	;;^UTILITY(U,$J,"OPT",1600,25)
	;;=EN6^FHPRO
	;;^UTILITY(U,$J,"OPT",1600,"U")
	;;=ENTER/EDIT SERVICE POINTS
	;;^UTILITY(U,$J,"OPT",1601,0)
	;;=FHPRO9^Enter/Edit Communication Offices^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1601,1,0)
	;;=^^3^3^2911211^^^
	;;^UTILITY(U,$J,"OPT",1601,1,1,0)
	;;=This option is used to enter and edit values for Communication Offices.
	;;^UTILITY(U,$J,"OPT",1601,1,2,0)
	;;=The Communication Office processes all diet orders for the wards for
	;;^UTILITY(U,$J,"OPT",1601,1,3,0)
	;;=which it is responsible.
	;;^UTILITY(U,$J,"OPT",1601,25)
	;;=EN7^FHPRO

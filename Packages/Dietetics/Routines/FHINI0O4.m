FHINI0O4	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1617,"U")
	;;=ENTER/EDIT DIETETIC SATISFACTI
	;;^UTILITY(U,$J,"OPT",1618,0)
	;;=FHADR8^Enter/Edit Dietetic Service Equipment^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1618,1,0)
	;;=^^2^2^2930126^^
	;;^UTILITY(U,$J,"OPT",1618,1,1,0)
	;;=This option allows the user to indicate the Dietetic System
	;;^UTILITY(U,$J,"OPT",1618,1,2,0)
	;;=Equipment the facility has and the Brand of the Equipment.
	;;^UTILITY(U,$J,"OPT",1618,25)
	;;=EN1^FHADR10
	;;^UTILITY(U,$J,"OPT",1618,"U")
	;;=ENTER/EDIT DIETETIC SERVICE EQ
	;;^UTILITY(U,$J,"OPT",1619,0)
	;;=FHADRP^Print Annual Dietetic Report^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1619,1,0)
	;;=^^1^1^2920227^^^
	;;^UTILITY(U,$J,"OPT",1619,1,1,0)
	;;=This option allows the user to print the Annual Dietetic Report.
	;;^UTILITY(U,$J,"OPT",1619,25)
	;;=EN1^FHADRPT
	;;^UTILITY(U,$J,"OPT",1619,"U")
	;;=PRINT ANNUAL DIETETIC REPORT
	;;^UTILITY(U,$J,"OPT",1620,0)
	;;=FHADRS^Purge Old Annual Dietetic Data^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1620,1,0)
	;;=^^2^2^2930205^^^^
	;;^UTILITY(U,$J,"OPT",1620,1,1,0)
	;;=This option allows the user to Purge the Annual Dietetic Data
	;;^UTILITY(U,$J,"OPT",1620,1,2,0)
	;;=that is prior than three years from current year.
	;;^UTILITY(U,$J,"OPT",1620,25)
	;;=EN1^FHADRSY
	;;^UTILITY(U,$J,"OPT",1620,"U")
	;;=PURGE OLD ANNUAL DIETETIC DATA
	;;^UTILITY(U,$J,"OPT",1621,0)
	;;=FHADRR^Annual Report Management^^M^^^^^^^^DIETETICS^^1
	;;^UTILITY(U,$J,"OPT",1621,1,0)
	;;=^^3^3^2930513^^^^
	;;^UTILITY(U,$J,"OPT",1621,1,1,0)
	;;=This menu allows access to options necessary for data collection
	;;^UTILITY(U,$J,"OPT",1621,1,2,0)
	;;=and calculation for the seven sections in each quarter and allows
	;;^UTILITY(U,$J,"OPT",1621,1,3,0)
	;;=the user to print the final report.
	;;^UTILITY(U,$J,"OPT",1621,10,0)
	;;=^19.01PI^11^11
	;;^UTILITY(U,$J,"OPT",1621,10,1,0)
	;;=1611^EA^1
	;;^UTILITY(U,$J,"OPT",1621,10,1,"^")
	;;=FHADR1
	;;^UTILITY(U,$J,"OPT",1621,10,2,0)
	;;=1612^EC^3
	;;^UTILITY(U,$J,"OPT",1621,10,2,"^")
	;;=FHADR2
	;;^UTILITY(U,$J,"OPT",1621,10,3,0)
	;;=1613^EB^2
	;;^UTILITY(U,$J,"OPT",1621,10,3,"^")
	;;=FHADR3
	;;^UTILITY(U,$J,"OPT",1621,10,4,0)
	;;=1614^ED^4
	;;^UTILITY(U,$J,"OPT",1621,10,4,"^")
	;;=FHADR4
	;;^UTILITY(U,$J,"OPT",1621,10,5,0)
	;;=1615^EE^5
	;;^UTILITY(U,$J,"OPT",1621,10,5,"^")
	;;=FHADR5
	;;^UTILITY(U,$J,"OPT",1621,10,6,0)
	;;=1616^EF^6
	;;^UTILITY(U,$J,"OPT",1621,10,6,"^")
	;;=FHADR6
	;;^UTILITY(U,$J,"OPT",1621,10,7,0)
	;;=1617^EG^7
	;;^UTILITY(U,$J,"OPT",1621,10,7,"^")
	;;=FHADR7
	;;^UTILITY(U,$J,"OPT",1621,10,8,0)
	;;=1618^EH^8
	;;^UTILITY(U,$J,"OPT",1621,10,8,"^")
	;;=FHADR8
	;;^UTILITY(U,$J,"OPT",1621,10,9,0)
	;;=1619^PR^10
	;;^UTILITY(U,$J,"OPT",1621,10,9,"^")
	;;=FHADRP
	;;^UTILITY(U,$J,"OPT",1621,10,10,0)
	;;=1620^PU^11
	;;^UTILITY(U,$J,"OPT",1621,10,10,"^")
	;;=FHADRS
	;;^UTILITY(U,$J,"OPT",1621,10,11,0)
	;;=1636^EI^9
	;;^UTILITY(U,$J,"OPT",1621,10,11,"^")
	;;=FHADR9
	;;^UTILITY(U,$J,"OPT",1621,20)
	;;=S FHA1=8 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1621,99)
	;;=56496,40617
	;;^UTILITY(U,$J,"OPT",1621,"U")
	;;=ANNUAL REPORT MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1622,0)
	;;=FHING12^Enter/Edit Current Ingredient QOH^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1622,1,0)
	;;=^^2^2^2920728^^^^
	;;^UTILITY(U,$J,"OPT",1622,1,1,0)
	;;=This option allows user to enter/edit Quantity On Hand one at the time
	;;^UTILITY(U,$J,"OPT",1622,1,2,0)
	;;=or either by Food Group Order or Storage Location.
	;;^UTILITY(U,$J,"OPT",1622,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1622,25)
	;;=EN1^FHREP
	;;^UTILITY(U,$J,"OPT",1622,"U")
	;;=ENTER/EDIT CURRENT INGREDIENT 
	;;^UTILITY(U,$J,"OPT",1623,0)
	;;=FHING13^Display Ingredient Inventory List^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1623,1,0)
	;;=^^1^1^2920915^^^^
	;;^UTILITY(U,$J,"OPT",1623,1,1,0)
	;;=This option allow the user to display the Inventory Worksheet or Report.
	;;^UTILITY(U,$J,"OPT",1623,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1623,25)
	;;=EN2^FHREP1
	;;^UTILITY(U,$J,"OPT",1623,"U")
	;;=DISPLAY INGREDIENT INVENTORY L
	;;^UTILITY(U,$J,"OPT",1624,0)
	;;=FHASE7^List Encounters^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1624,1,0)
	;;=^^2^2^2920501^
	;;^UTILITY(U,$J,"OPT",1624,1,1,0)
	;;=This option will list all encounters for a single clinician
	;;^UTILITY(U,$J,"OPT",1624,1,2,0)
	;;=based upon a starting and ending date.
	;;^UTILITY(U,$J,"OPT",1624,25)
	;;=IND^FHASE1
	;;^UTILITY(U,$J,"OPT",1624,"U")
	;;=LIST ENCOUNTERS
	;;^UTILITY(U,$J,"OPT",1625,0)
	;;=FHORTF5^Preparation/Delivery of Tubefeedings^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1625,1,0)
	;;=^^1^1^2930415^^^^
	;;^UTILITY(U,$J,"OPT",1625,1,1,0)
	;;=This option produces the Preparation/Delivery and the Pull List.

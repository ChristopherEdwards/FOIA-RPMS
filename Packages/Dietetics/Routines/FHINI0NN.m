FHINI0NN	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1484,10,9,0)
	;;=1519^XM
	;;^UTILITY(U,$J,"OPT",1484,10,9,"^")
	;;=FHPRCM
	;;^UTILITY(U,$J,"OPT",1484,10,10,0)
	;;=1486^AM
	;;^UTILITY(U,$J,"OPT",1484,10,10,"^")
	;;=FHADMR
	;;^UTILITY(U,$J,"OPT",1484,10,11,0)
	;;=1538^PR
	;;^UTILITY(U,$J,"OPT",1484,10,11,"^")
	;;=FHADM
	;;^UTILITY(U,$J,"OPT",1484,10,12,0)
	;;=1493^XF
	;;^UTILITY(U,$J,"OPT",1484,10,12,"^")
	;;=FHFILM
	;;^UTILITY(U,$J,"OPT",1484,10,13,0)
	;;=1503^SO
	;;^UTILITY(U,$J,"OPT",1484,10,13,"^")
	;;=FHSPX
	;;^UTILITY(U,$J,"OPT",1484,10,14,0)
	;;=1565^FP
	;;^UTILITY(U,$J,"OPT",1484,10,14,"^")
	;;=FHSELX
	;;^UTILITY(U,$J,"OPT",1484,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1484,20)
	;;=S FHA1=4 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1484,99)
	;;=56496,40785
	;;^UTILITY(U,$J,"OPT",1484,99.1)
	;;=53952,47936
	;;^UTILITY(U,$J,"OPT",1484,"U")
	;;=DIETETIC ADMINISTRATION
	;;^UTILITY(U,$J,"OPT",1485,0)
	;;=FHADMR1^Enter/Edit Served Meals^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1485,1,0)
	;;=^^2^2^2920611^^
	;;^UTILITY(U,$J,"OPT",1485,1,1,0)
	;;=This option allows for entry and/or editing of the various values
	;;^UTILITY(U,$J,"OPT",1485,1,2,0)
	;;=used in the Served Ration Report.
	;;^UTILITY(U,$J,"OPT",1485,25)
	;;=EN1^FHADM2
	;;^UTILITY(U,$J,"OPT",1485,"U")
	;;=ENTER/EDIT SERVED MEALS
	;;^UTILITY(U,$J,"OPT",1486,0)
	;;=FHADMR^Administrative Menu^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1486,1,0)
	;;=^^2^2^2950307^^^^
	;;^UTILITY(U,$J,"OPT",1486,1,1,0)
	;;=This menu contains the various administrative and cost reports
	;;^UTILITY(U,$J,"OPT",1486,1,2,0)
	;;=produced by the system.
	;;^UTILITY(U,$J,"OPT",1486,10,0)
	;;=^19.01PI^13^11
	;;^UTILITY(U,$J,"OPT",1486,10,1,0)
	;;=1485^RE
	;;^UTILITY(U,$J,"OPT",1486,10,1,"^")
	;;=FHADMR1
	;;^UTILITY(U,$J,"OPT",1486,10,2,0)
	;;=1487^RR
	;;^UTILITY(U,$J,"OPT",1486,10,2,"^")
	;;=FHADMR2
	;;^UTILITY(U,$J,"OPT",1486,10,3,0)
	;;=1488^AR
	;;^UTILITY(U,$J,"OPT",1486,10,3,"^")
	;;=FHADMR3
	;;^UTILITY(U,$J,"OPT",1486,10,6,0)
	;;=1495^PE
	;;^UTILITY(U,$J,"OPT",1486,10,6,"^")
	;;=FHADMR4
	;;^UTILITY(U,$J,"OPT",1486,10,7,0)
	;;=1496^PR
	;;^UTILITY(U,$J,"OPT",1486,10,7,"^")
	;;=FHADMR5
	;;^UTILITY(U,$J,"OPT",1486,10,8,0)
	;;=1477^SR
	;;^UTILITY(U,$J,"OPT",1486,10,8,"^")
	;;=FHNO11
	;;^UTILITY(U,$J,"OPT",1486,10,9,0)
	;;=1608^RS
	;;^UTILITY(U,$J,"OPT",1486,10,9,"^")
	;;=FHCMRR1
	;;^UTILITY(U,$J,"OPT",1486,10,10,0)
	;;=1609^SP
	;;^UTILITY(U,$J,"OPT",1486,10,10,"^")
	;;=FHCMRR2
	;;^UTILITY(U,$J,"OPT",1486,10,11,0)
	;;=1627^TC
	;;^UTILITY(U,$J,"OPT",1486,10,11,"^")
	;;=FHORTF5C
	;;^UTILITY(U,$J,"OPT",1486,10,12,0)
	;;=1622^QE
	;;^UTILITY(U,$J,"OPT",1486,10,12,"^")
	;;=FHING12
	;;^UTILITY(U,$J,"OPT",1486,10,13,0)
	;;=1623^QW
	;;^UTILITY(U,$J,"OPT",1486,10,13,"^")
	;;=FHING13
	;;^UTILITY(U,$J,"OPT",1486,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1486,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1486,99)
	;;=56496,40735
	;;^UTILITY(U,$J,"OPT",1486,"U")
	;;=ADMINISTRATIVE MENU
	;;^UTILITY(U,$J,"OPT",1487,0)
	;;=FHADMR2^Served Meals Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1487,1,0)
	;;=^^2^2^2941125^^^^
	;;^UTILITY(U,$J,"OPT",1487,1,1,0)
	;;=This option will print the Served Ration Report for any time
	;;^UTILITY(U,$J,"OPT",1487,1,2,0)
	;;=period specified.
	;;^UTILITY(U,$J,"OPT",1487,25)
	;;=EN2^FHADM21
	;;^UTILITY(U,$J,"OPT",1487,"U")
	;;=SERVED MEALS REPORT
	;;^UTILITY(U,$J,"OPT",1488,0)
	;;=FHADMR3^Additional Meals Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1488,1,0)
	;;=^^4^4^2880717^^
	;;^UTILITY(U,$J,"OPT",1488,1,1,0)
	;;=This option will print the individual meal counts used in the
	;;^UTILITY(U,$J,"OPT",1488,1,2,0)
	;;=Served Ration Report for other than inpatients. These values
	;;^UTILITY(U,$J,"OPT",1488,1,3,0)
	;;=are converted to rations when used in calculations for the
	;;^UTILITY(U,$J,"OPT",1488,1,4,0)
	;;=Served Ration Report.
	;;^UTILITY(U,$J,"OPT",1488,25)
	;;=FHADM3
	;;^UTILITY(U,$J,"OPT",1488,"U")
	;;=ADDITIONAL MEALS REPORT
	;;^UTILITY(U,$J,"OPT",1489,0)
	;;=FHORD14^Reprint Diet Labels^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1489,1,0)
	;;=^^2^2^2930702^^^
	;;^UTILITY(U,$J,"OPT",1489,1,1,0)
	;;=This option will reprint a diet card label for an individual
	;;^UTILITY(U,$J,"OPT",1489,1,2,0)
	;;=patient or for all patients on a specified ward.
	;;^UTILITY(U,$J,"OPT",1489,25)
	;;=FHORD13
	;;^UTILITY(U,$J,"OPT",1489,"U")
	;;=REPRINT DIET LABELS
	;;^UTILITY(U,$J,"OPT",1490,0)
	;;=FHSYSM^System Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1490,1,0)
	;;=^^5^5^2911127^^^
	;;^UTILITY(U,$J,"OPT",1490,1,1,0)
	;;=This menu allows a system manager to modify site parameters,
	;;^UTILITY(U,$J,"OPT",1490,1,2,0)
	;;=purge dietetic data, check the integrity of the dietetic
	;;^UTILITY(U,$J,"OPT",1490,1,3,0)
	;;=routines and file pointers, tally production diets for all

FHINI0NR	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1512,10,3,0)
	;;=1507^IE
	;;^UTILITY(U,$J,"OPT",1512,10,3,"^")
	;;=FHING3
	;;^UTILITY(U,$J,"OPT",1512,10,4,0)
	;;=1511^LE
	;;^UTILITY(U,$J,"OPT",1512,10,4,"^")
	;;=FHING4
	;;^UTILITY(U,$J,"OPT",1512,10,5,0)
	;;=1529^IR
	;;^UTILITY(U,$J,"OPT",1512,10,5,"^")
	;;=FHING5
	;;^UTILITY(U,$J,"OPT",1512,10,6,0)
	;;=1530^UL
	;;^UTILITY(U,$J,"OPT",1512,10,6,"^")
	;;=FHING6
	;;^UTILITY(U,$J,"OPT",1512,10,7,0)
	;;=1531^VL
	;;^UTILITY(U,$J,"OPT",1512,10,7,"^")
	;;=FHING7
	;;^UTILITY(U,$J,"OPT",1512,10,8,0)
	;;=1532^LL
	;;^UTILITY(U,$J,"OPT",1512,10,8,"^")
	;;=FHING8
	;;^UTILITY(U,$J,"OPT",1512,10,10,0)
	;;=1546^IP
	;;^UTILITY(U,$J,"OPT",1512,10,10,"^")
	;;=FHING51
	;;^UTILITY(U,$J,"OPT",1512,10,11,0)
	;;=1537^RL
	;;^UTILITY(U,$J,"OPT",1512,10,11,"^")
	;;=FHING11
	;;^UTILITY(U,$J,"OPT",1512,10,12,0)
	;;=1622^QE
	;;^UTILITY(U,$J,"OPT",1512,10,12,"^")
	;;=FHING12
	;;^UTILITY(U,$J,"OPT",1512,10,13,0)
	;;=1623^QW
	;;^UTILITY(U,$J,"OPT",1512,10,13,"^")
	;;=FHING13
	;;^UTILITY(U,$J,"OPT",1512,10,14,0)
	;;=1707^IN
	;;^UTILITY(U,$J,"OPT",1512,10,14,"^")
	;;=FHING52
	;;^UTILITY(U,$J,"OPT",1512,99)
	;;=56496,40671
	;;^UTILITY(U,$J,"OPT",1512,"U")
	;;=INGREDIENT MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1513,0)
	;;=FHRECM^Recipe Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1513,1,0)
	;;=^^2^2^2941027^^^^
	;;^UTILITY(U,$J,"OPT",1513,1,1,0)
	;;=This menu contains all of the options relating to the management
	;;^UTILITY(U,$J,"OPT",1513,1,2,0)
	;;=of recipes.
	;;^UTILITY(U,$J,"OPT",1513,10,0)
	;;=^19.01PI^16^16
	;;^UTILITY(U,$J,"OPT",1513,10,1,0)
	;;=1510^RE
	;;^UTILITY(U,$J,"OPT",1513,10,1,"^")
	;;=FHREC1
	;;^UTILITY(U,$J,"OPT",1513,10,2,0)
	;;=1520^RP
	;;^UTILITY(U,$J,"OPT",1513,10,2,"^")
	;;=FHREC2
	;;^UTILITY(U,$J,"OPT",1513,10,3,0)
	;;=1528^RL
	;;^UTILITY(U,$J,"OPT",1513,10,3,"^")
	;;=FHREC3
	;;^UTILITY(U,$J,"OPT",1513,10,4,0)
	;;=1535^PE
	;;^UTILITY(U,$J,"OPT",1513,10,4,"^")
	;;=FHING9
	;;^UTILITY(U,$J,"OPT",1513,10,5,0)
	;;=1536^PL
	;;^UTILITY(U,$J,"OPT",1513,10,5,"^")
	;;=FHING10
	;;^UTILITY(U,$J,"OPT",1513,10,6,0)
	;;=1539^CE
	;;^UTILITY(U,$J,"OPT",1513,10,6,"^")
	;;=FHREC4
	;;^UTILITY(U,$J,"OPT",1513,10,7,0)
	;;=1540^CL
	;;^UTILITY(U,$J,"OPT",1513,10,7,"^")
	;;=FHREC5
	;;^UTILITY(U,$J,"OPT",1513,10,8,0)
	;;=1542^SE
	;;^UTILITY(U,$J,"OPT",1513,10,8,"^")
	;;=FHREC6
	;;^UTILITY(U,$J,"OPT",1513,10,9,0)
	;;=1543^SL
	;;^UTILITY(U,$J,"OPT",1513,10,9,"^")
	;;=FHREC7
	;;^UTILITY(U,$J,"OPT",1513,10,10,0)
	;;=1544^EE
	;;^UTILITY(U,$J,"OPT",1513,10,10,"^")
	;;=FHREC8
	;;^UTILITY(U,$J,"OPT",1513,10,11,0)
	;;=1545^EL
	;;^UTILITY(U,$J,"OPT",1513,10,11,"^")
	;;=FHREC9
	;;^UTILITY(U,$J,"OPT",1513,10,12,0)
	;;=1548^RC
	;;^UTILITY(U,$J,"OPT",1513,10,12,"^")
	;;=FHREC10
	;;^UTILITY(U,$J,"OPT",1513,10,13,0)
	;;=1559^RU
	;;^UTILITY(U,$J,"OPT",1513,10,13,"^")
	;;=FHPRC10
	;;^UTILITY(U,$J,"OPT",1513,10,14,0)
	;;=1711^NA
	;;^UTILITY(U,$J,"OPT",1513,10,14,"^")
	;;=FHREC11
	;;^UTILITY(U,$J,"OPT",1513,10,15,0)
	;;=1712^ND
	;;^UTILITY(U,$J,"OPT",1513,10,15,"^")
	;;=FHREC12
	;;^UTILITY(U,$J,"OPT",1513,10,16,0)
	;;=1817^NL
	;;^UTILITY(U,$J,"OPT",1513,10,16,"^")
	;;=FHREC13
	;;^UTILITY(U,$J,"OPT",1513,99)
	;;=56496,40777
	;;^UTILITY(U,$J,"OPT",1513,"U")
	;;=RECIPE MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1514,0)
	;;=FHPRFM^Forecasting^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1514,1,0)
	;;=^^1^1^2921005^^^^
	;;^UTILITY(U,$J,"OPT",1514,1,1,0)
	;;=This menu contains all of the forecasting options.
	;;^UTILITY(U,$J,"OPT",1514,10,0)
	;;=^19.01PI^5^3
	;;^UTILITY(U,$J,"OPT",1514,10,2,0)
	;;=1516^FC
	;;^UTILITY(U,$J,"OPT",1514,10,2,"^")
	;;=FHPRF2
	;;^UTILITY(U,$J,"OPT",1514,10,4,0)
	;;=1472^DC
	;;^UTILITY(U,$J,"OPT",1514,10,4,"^")
	;;=FHORD11
	;;^UTILITY(U,$J,"OPT",1514,10,5,0)
	;;=1633^DP
	;;^UTILITY(U,$J,"OPT",1514,10,5,"^")
	;;=FHORD15
	;;^UTILITY(U,$J,"OPT",1514,99)
	;;=56496,40759
	;;^UTILITY(U,$J,"OPT",1514,"U")
	;;=FORECASTING
	;;^UTILITY(U,$J,"OPT",1515,0)
	;;=FHPRF1^Enter/Edit Production Diet Percentages^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1515,1,0)
	;;=^^3^3^2880718^^^
	;;^UTILITY(U,$J,"OPT",1515,1,1,0)
	;;=This option is part of the Forecasting module and is used to
	;;^UTILITY(U,$J,"OPT",1515,1,2,0)
	;;=enter and edit the percentage of total census represented by
	;;^UTILITY(U,$J,"OPT",1515,1,3,0)
	;;=each production diet for each day of the week.
	;;^UTILITY(U,$J,"OPT",1515,25)
	;;=EN1^FHPRF
	;;^UTILITY(U,$J,"OPT",1515,"U")
	;;=ENTER/EDIT PRODUCTION DIET PER
	;;^UTILITY(U,$J,"OPT",1516,0)
	;;=FHPRF2^Forecasted Diet Census^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1516,1,0)
	;;=^^6^6^2950111^^^^
	;;^UTILITY(U,$J,"OPT",1516,1,1,0)
	;;=This option allows for the forecast of the total census for

FHINI0NJ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1466,1,0)
	;;=^^3^3^2880717^
	;;^UTILITY(U,$J,"OPT",1466,1,1,0)
	;;=This menu allows access to the file management options associated
	;;^UTILITY(U,$J,"OPT",1466,1,2,0)
	;;=with the consult module as well as access to consult statistics
	;;^UTILITY(U,$J,"OPT",1466,1,3,0)
	;;=and the ability to perform mass re-assignment of consults.
	;;^UTILITY(U,$J,"OPT",1466,10,0)
	;;=^19.01PI^6^6
	;;^UTILITY(U,$J,"OPT",1466,10,1,0)
	;;=1460^WE
	;;^UTILITY(U,$J,"OPT",1466,10,1,"^")
	;;=FHORC5
	;;^UTILITY(U,$J,"OPT",1466,10,2,0)
	;;=1441^WL
	;;^UTILITY(U,$J,"OPT",1466,10,2,"^")
	;;=FHORC6
	;;^UTILITY(U,$J,"OPT",1466,10,3,0)
	;;=1442^CE
	;;^UTILITY(U,$J,"OPT",1466,10,3,"^")
	;;=FHORC7
	;;^UTILITY(U,$J,"OPT",1466,10,4,0)
	;;=1443^CL
	;;^UTILITY(U,$J,"OPT",1466,10,4,"^")
	;;=FHORC8
	;;^UTILITY(U,$J,"OPT",1466,10,5,0)
	;;=1444^CR
	;;^UTILITY(U,$J,"OPT",1466,10,5,"^")
	;;=FHORC9
	;;^UTILITY(U,$J,"OPT",1466,10,6,0)
	;;=1445^CX
	;;^UTILITY(U,$J,"OPT",1466,10,6,"^")
	;;=FHORC10
	;;^UTILITY(U,$J,"OPT",1466,99)
	;;=56496,40715
	;;^UTILITY(U,$J,"OPT",1466,"U")
	;;=CONSULT MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1467,0)
	;;=FHORDX^Diet Order Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1467,1,0)
	;;=^^2^2^2940707^^^^
	;;^UTILITY(U,$J,"OPT",1467,1,1,0)
	;;=This menu allows access to all file management options
	;;^UTILITY(U,$J,"OPT",1467,1,2,0)
	;;=relating to diet orders, tubefeedings and isolations.
	;;^UTILITY(U,$J,"OPT",1467,10,0)
	;;=^19.01PI^6^6
	;;^UTILITY(U,$J,"OPT",1467,10,1,0)
	;;=1433^DE
	;;^UTILITY(U,$J,"OPT",1467,10,1,"^")
	;;=FHORD6
	;;^UTILITY(U,$J,"OPT",1467,10,2,0)
	;;=1464^IE
	;;^UTILITY(U,$J,"OPT",1467,10,2,"^")
	;;=FHORI1
	;;^UTILITY(U,$J,"OPT",1467,10,3,0)
	;;=1450^TE
	;;^UTILITY(U,$J,"OPT",1467,10,3,"^")
	;;=FHORTF1
	;;^UTILITY(U,$J,"OPT",1467,10,4,0)
	;;=1459^DL
	;;^UTILITY(U,$J,"OPT",1467,10,4,"^")
	;;=FHORD7
	;;^UTILITY(U,$J,"OPT",1467,10,5,0)
	;;=1465^IL
	;;^UTILITY(U,$J,"OPT",1467,10,5,"^")
	;;=FHORI2
	;;^UTILITY(U,$J,"OPT",1467,10,6,0)
	;;=1451^TL
	;;^UTILITY(U,$J,"OPT",1467,10,6,"^")
	;;=FHORTF2
	;;^UTILITY(U,$J,"OPT",1467,99)
	;;=56496,40732
	;;^UTILITY(U,$J,"OPT",1467,"U")
	;;=DIET ORDER MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1468,0)
	;;=FHNUX^Energy/Nutrient Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1468,1,0)
	;;=^^2^2^2931027^^
	;;^UTILITY(U,$J,"OPT",1468,1,1,0)
	;;=This menu allows access to the file management options associated
	;;^UTILITY(U,$J,"OPT",1468,1,2,0)
	;;=with the Energy/Nutrient module.
	;;^UTILITY(U,$J,"OPT",1468,10,0)
	;;=^19.01PI^6^6
	;;^UTILITY(U,$J,"OPT",1468,10,1,0)
	;;=1423^NE
	;;^UTILITY(U,$J,"OPT",1468,10,1,"^")
	;;=FHNU6
	;;^UTILITY(U,$J,"OPT",1468,10,2,0)
	;;=1428^NL
	;;^UTILITY(U,$J,"OPT",1468,10,2,"^")
	;;=FHNU7
	;;^UTILITY(U,$J,"OPT",1468,10,3,0)
	;;=1432^RL
	;;^UTILITY(U,$J,"OPT",1468,10,3,"^")
	;;=FHNU9
	;;^UTILITY(U,$J,"OPT",1468,10,4,0)
	;;=1431^ML
	;;^UTILITY(U,$J,"OPT",1468,10,4,"^")
	;;=FHNU3
	;;^UTILITY(U,$J,"OPT",1468,10,5,0)
	;;=1497^RE
	;;^UTILITY(U,$J,"OPT",1468,10,5,"^")
	;;=FHNU11
	;;^UTILITY(U,$J,"OPT",1468,10,6,0)
	;;=1759^NG
	;;^UTILITY(U,$J,"OPT",1468,10,6,"^")
	;;=FHNU12
	;;^UTILITY(U,$J,"OPT",1468,99)
	;;=56496,40696
	;;^UTILITY(U,$J,"OPT",1468,"U")
	;;=ENERGY/NUTRIENT MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1469,0)
	;;=FHNOX^Supplemental Feeding Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1469,1,0)
	;;=^^2^2^2941018^^^^
	;;^UTILITY(U,$J,"OPT",1469,1,1,0)
	;;=This menu contains the file management options pertaining to the
	;;^UTILITY(U,$J,"OPT",1469,1,2,0)
	;;=Supplemental Feedings module.
	;;^UTILITY(U,$J,"OPT",1469,10,0)
	;;=^19.01PI^5^5
	;;^UTILITY(U,$J,"OPT",1469,10,1,0)
	;;=1457^BE
	;;^UTILITY(U,$J,"OPT",1469,10,1,"^")
	;;=FHNO8
	;;^UTILITY(U,$J,"OPT",1469,10,2,0)
	;;=1424^SE
	;;^UTILITY(U,$J,"OPT",1469,10,2,"^")
	;;=FHNO4
	;;^UTILITY(U,$J,"OPT",1469,10,3,0)
	;;=1429^SL
	;;^UTILITY(U,$J,"OPT",1469,10,3,"^")
	;;=FHNO5
	;;^UTILITY(U,$J,"OPT",1469,10,4,0)
	;;=1430^ML
	;;^UTILITY(U,$J,"OPT",1469,10,4,"^")
	;;=FHNO7
	;;^UTILITY(U,$J,"OPT",1469,10,5,0)
	;;=1425^ME
	;;^UTILITY(U,$J,"OPT",1469,10,5,"^")
	;;=FHNO6
	;;^UTILITY(U,$J,"OPT",1469,99)
	;;=56496,40688
	;;^UTILITY(U,$J,"OPT",1469,"U")
	;;=SUPPLEMENTAL FEEDING MANAGEMEN
	;;^UTILITY(U,$J,"OPT",1470,0)
	;;=FHWARD^Dietetic Orders^^M^^^^^^^^DIETETICS^^1
	;;^UTILITY(U,$J,"OPT",1470,1,0)
	;;=^^5^5^2940107^^^^
	;;^UTILITY(U,$J,"OPT",1470,1,1,0)
	;;=This menu allows access to all dietetic order options normally given
	;;^UTILITY(U,$J,"OPT",1470,1,2,0)
	;;=to ward personnel and includes the ability to order diets, consults,
	;;^UTILITY(U,$J,"OPT",1470,1,3,0)
	;;=early/late trays, NPO's, tubefeedings, and enter additional

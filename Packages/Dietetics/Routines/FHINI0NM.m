FHINI0NM	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1479,10,4,"^")
	;;=FHASCM
	;;^UTILITY(U,$J,"OPT",1479,10,5,0)
	;;=1410^PM
	;;^UTILITY(U,$J,"OPT",1479,10,5,"^")
	;;=FHPATM
	;;^UTILITY(U,$J,"OPT",1479,10,6,0)
	;;=1422^SF
	;;^UTILITY(U,$J,"OPT",1479,10,6,"^")
	;;=FHNOM
	;;^UTILITY(U,$J,"OPT",1479,10,7,0)
	;;=1478^XL
	;;^UTILITY(U,$J,"OPT",1479,10,7,"^")
	;;=FHCDLST
	;;^UTILITY(U,$J,"OPT",1479,10,8,0)
	;;=1504^SO
	;;^UTILITY(U,$J,"OPT",1479,10,8,"^")
	;;=FHSPM
	;;^UTILITY(U,$J,"OPT",1479,10,9,0)
	;;=1560^FP
	;;^UTILITY(U,$J,"OPT",1479,10,9,"^")
	;;=FHSELM
	;;^UTILITY(U,$J,"OPT",1479,10,10,0)
	;;=1595^TF
	;;^UTILITY(U,$J,"OPT",1479,10,10,"^")
	;;=FHCTF
	;;^UTILITY(U,$J,"OPT",1479,10,11,0)
	;;=1624^LE
	;;^UTILITY(U,$J,"OPT",1479,10,11,"^")
	;;=FHASE7
	;;^UTILITY(U,$J,"OPT",1479,10,13,0)
	;;=1635^PE
	;;^UTILITY(U,$J,"OPT",1479,10,13,"^")
	;;=FHORX2
	;;^UTILITY(U,$J,"OPT",1479,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1479,20)
	;;=S FHA1=2 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1479,99)
	;;=56496,40788
	;;^UTILITY(U,$J,"OPT",1479,99.1)
	;;=53522,42334
	;;^UTILITY(U,$J,"OPT",1479,"U")
	;;=CLINICAL DIETETICS
	;;^UTILITY(U,$J,"OPT",1480,0)
	;;=FHPRO3^Enter/Edit Production Diets^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1480,1,0)
	;;=^^2^2^2950203^^^
	;;^UTILITY(U,$J,"OPT",1480,1,1,0)
	;;=This option allows for the creation/editing of production
	;;^UTILITY(U,$J,"OPT",1480,1,2,0)
	;;=diets in the Production Diet file (116.2).
	;;^UTILITY(U,$J,"OPT",1480,25)
	;;=EN3^FHPRO
	;;^UTILITY(U,$J,"OPT",1480,"U")
	;;=ENTER/EDIT PRODUCTION DIETS
	;;^UTILITY(U,$J,"OPT",1481,0)
	;;=FHPRO4^List Production Diets^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1481,1,0)
	;;=^^3^3^2911211^^^^
	;;^UTILITY(U,$J,"OPT",1481,1,1,0)
	;;=This option will list all production diets contained in the
	;;^UTILITY(U,$J,"OPT",1481,1,2,0)
	;;=Production Diet file (116.2) along with all associated data
	;;^UTILITY(U,$J,"OPT",1481,1,3,0)
	;;=elements.
	;;^UTILITY(U,$J,"OPT",1481,25)
	;;=EN4^FHPRO
	;;^UTILITY(U,$J,"OPT",1481,"U")
	;;=LIST PRODUCTION DIETS
	;;^UTILITY(U,$J,"OPT",1482,0)
	;;=FHPROM^Production Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1482,1,0)
	;;=^^4^4^2950302^^^^
	;;^UTILITY(U,$J,"OPT",1482,1,1,0)
	;;=This menu allows access to the file management options associated
	;;^UTILITY(U,$J,"OPT",1482,1,2,0)
	;;=with food production, including service points, dietetic wards,
	;;^UTILITY(U,$J,"OPT",1482,1,3,0)
	;;=production diets, and production diet percentages used for
	;;^UTILITY(U,$J,"OPT",1482,1,4,0)
	;;=forecasting.
	;;^UTILITY(U,$J,"OPT",1482,10,0)
	;;=^19.01PI^14^9
	;;^UTILITY(U,$J,"OPT",1482,10,3,0)
	;;=1480^PE
	;;^UTILITY(U,$J,"OPT",1482,10,3,"^")
	;;=FHPRO3
	;;^UTILITY(U,$J,"OPT",1482,10,4,0)
	;;=1481^PL
	;;^UTILITY(U,$J,"OPT",1482,10,4,"^")
	;;=FHPRO4
	;;^UTILITY(U,$J,"OPT",1482,10,5,0)
	;;=1515^PP
	;;^UTILITY(U,$J,"OPT",1482,10,5,"^")
	;;=FHPRF1
	;;^UTILITY(U,$J,"OPT",1482,10,6,0)
	;;=1517^DP
	;;^UTILITY(U,$J,"OPT",1482,10,6,"^")
	;;=FHPRF4
	;;^UTILITY(U,$J,"OPT",1482,10,7,0)
	;;=1552^WL
	;;^UTILITY(U,$J,"OPT",1482,10,7,"^")
	;;=FHPRO6
	;;^UTILITY(U,$J,"OPT",1482,10,8,0)
	;;=1533^OE
	;;^UTILITY(U,$J,"OPT",1482,10,8,"^")
	;;=FHPRF5
	;;^UTILITY(U,$J,"OPT",1482,10,9,0)
	;;=1534^OL
	;;^UTILITY(U,$J,"OPT",1482,10,9,"^")
	;;=FHPRF6
	;;^UTILITY(U,$J,"OPT",1482,10,13,0)
	;;=1602^SL
	;;^UTILITY(U,$J,"OPT",1482,10,13,"^")
	;;=FHPRO10
	;;^UTILITY(U,$J,"OPT",1482,10,14,0)
	;;=1827^TM
	;;^UTILITY(U,$J,"OPT",1482,10,14,"^")
	;;=FHMTKMM
	;;^UTILITY(U,$J,"OPT",1482,99)
	;;=56496,40768
	;;^UTILITY(U,$J,"OPT",1482,"U")
	;;=PRODUCTION MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1483,0)
	;;=FHORO1^Enter Additional Order^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1483,1,0)
	;;=^^2^2^2940708^^
	;;^UTILITY(U,$J,"OPT",1483,1,1,0)
	;;=This option will allow the user to enter an additional order
	;;^UTILITY(U,$J,"OPT",1483,1,2,0)
	;;=for an inpatient.
	;;^UTILITY(U,$J,"OPT",1483,25)
	;;=EN1^FHORO
	;;^UTILITY(U,$J,"OPT",1483,"U")
	;;=ENTER ADDITIONAL ORDER
	;;^UTILITY(U,$J,"OPT",1484,0)
	;;=FHMGRA^Dietetic Administration^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1484,1,0)
	;;=^^2^2^2950307^^^^
	;;^UTILITY(U,$J,"OPT",1484,1,1,0)
	;;=This menu allows access to all options pertaining to dietetic
	;;^UTILITY(U,$J,"OPT",1484,1,2,0)
	;;=administration as well as food production.
	;;^UTILITY(U,$J,"OPT",1484,10,0)
	;;=^19.01PI^14^10
	;;^UTILITY(U,$J,"OPT",1484,10,2,0)
	;;=1513^XR
	;;^UTILITY(U,$J,"OPT",1484,10,2,"^")
	;;=FHRECM
	;;^UTILITY(U,$J,"OPT",1484,10,3,0)
	;;=1512^XI
	;;^UTILITY(U,$J,"OPT",1484,10,3,"^")
	;;=FHINGM
	;;^UTILITY(U,$J,"OPT",1484,10,4,0)
	;;=1482^XP
	;;^UTILITY(U,$J,"OPT",1484,10,4,"^")
	;;=FHPROM
	;;^UTILITY(U,$J,"OPT",1484,10,8,0)
	;;=1621^XX
	;;^UTILITY(U,$J,"OPT",1484,10,8,"^")
	;;=FHADRR

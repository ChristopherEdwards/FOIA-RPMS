FHINI0NE	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1425,1,1,0)
	;;=This option allows for the creation/editing of supplemental
	;;^UTILITY(U,$J,"OPT",1425,1,2,0)
	;;=feeding menus in the Supplemental Feeding menu file (118.1).
	;;^UTILITY(U,$J,"OPT",1425,25)
	;;=EN4^FHNO1
	;;^UTILITY(U,$J,"OPT",1425,"U")
	;;=ENTER/EDIT SUPPLEMENTAL FEEDIN
	;;^UTILITY(U,$J,"OPT",1426,0)
	;;=FHMGR^Dietetics Management^^M^^^^^^^^DIETETICS^^1
	;;^UTILITY(U,$J,"OPT",1426,1,0)
	;;=^^3^3^2950420^^^^
	;;^UTILITY(U,$J,"OPT",1426,1,1,0)
	;;=This menu allows access to all options within the
	;;^UTILITY(U,$J,"OPT",1426,1,2,0)
	;;=Dietetics System, both administrative and clinical. Access to
	;;^UTILITY(U,$J,"OPT",1426,1,3,0)
	;;=all system management options is also available.
	;;^UTILITY(U,$J,"OPT",1426,10,0)
	;;=^19.01PI^11^5
	;;^UTILITY(U,$J,"OPT",1426,10,3,0)
	;;=1484^AD
	;;^UTILITY(U,$J,"OPT",1426,10,3,"^")
	;;=FHMGRA
	;;^UTILITY(U,$J,"OPT",1426,10,5,0)
	;;=1606^DF
	;;^UTILITY(U,$J,"OPT",1426,10,5,"^")
	;;=FHPRG
	;;^UTILITY(U,$J,"OPT",1426,10,8,0)
	;;=1490^SM
	;;^UTILITY(U,$J,"OPT",1426,10,8,"^")
	;;=FHSYSM
	;;^UTILITY(U,$J,"OPT",1426,10,10,0)
	;;=1492^CM
	;;^UTILITY(U,$J,"OPT",1426,10,10,"^")
	;;=FHMGRC
	;;^UTILITY(U,$J,"OPT",1426,10,11,0)
	;;=1493^XF
	;;^UTILITY(U,$J,"OPT",1426,10,11,"^")
	;;=FHFILM
	;;^UTILITY(U,$J,"OPT",1426,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1426,20)
	;;=S FHA1=1 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1426,99)
	;;=56496,40787
	;;^UTILITY(U,$J,"OPT",1426,99.1)
	;;=54454,31794
	;;^UTILITY(U,$J,"OPT",1426,1613)
	;;=EVE
	;;^UTILITY(U,$J,"OPT",1426,"U")
	;;=DIETETICS MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1427,0)
	;;=FHDIET^Clinical Dietetics^^M^^^^^^^^DIETETICS^^1
	;;^UTILITY(U,$J,"OPT",1427,1,0)
	;;=^^2^2^2950309^^^^
	;;^UTILITY(U,$J,"OPT",1427,1,1,0)
	;;=This menu contains all of the various options that the clinical
	;;^UTILITY(U,$J,"OPT",1427,1,2,0)
	;;=dietetics staff will require.
	;;^UTILITY(U,$J,"OPT",1427,10,0)
	;;=^19.01PI^13^12
	;;^UTILITY(U,$J,"OPT",1427,10,1,0)
	;;=1584^NM
	;;^UTILITY(U,$J,"OPT",1427,10,1,"^")
	;;=FHASCM
	;;^UTILITY(U,$J,"OPT",1427,10,2,0)
	;;=1417^EA
	;;^UTILITY(U,$J,"OPT",1427,10,2,"^")
	;;=FHNUM
	;;^UTILITY(U,$J,"OPT",1427,10,3,0)
	;;=1422^SF
	;;^UTILITY(U,$J,"OPT",1427,10,3,"^")
	;;=FHNOM
	;;^UTILITY(U,$J,"OPT",1427,10,4,0)
	;;=1410^PM
	;;^UTILITY(U,$J,"OPT",1427,10,4,"^")
	;;=FHPATM
	;;^UTILITY(U,$J,"OPT",1427,10,5,0)
	;;=1440^DO
	;;^UTILITY(U,$J,"OPT",1427,10,5,"^")
	;;=FHORDM
	;;^UTILITY(U,$J,"OPT",1427,10,6,0)
	;;=1449^DC
	;;^UTILITY(U,$J,"OPT",1427,10,6,"^")
	;;=FHORCM
	;;^UTILITY(U,$J,"OPT",1427,10,7,0)
	;;=1478^DR
	;;^UTILITY(U,$J,"OPT",1427,10,7,"^")
	;;=FHCDLST
	;;^UTILITY(U,$J,"OPT",1427,10,8,0)
	;;=1504^SO
	;;^UTILITY(U,$J,"OPT",1427,10,8,"^")
	;;=FHSPM
	;;^UTILITY(U,$J,"OPT",1427,10,9,0)
	;;=1560^FP
	;;^UTILITY(U,$J,"OPT",1427,10,9,"^")
	;;=FHSELM
	;;^UTILITY(U,$J,"OPT",1427,10,10,0)
	;;=1595^TF
	;;^UTILITY(U,$J,"OPT",1427,10,10,"^")
	;;=FHCTF
	;;^UTILITY(U,$J,"OPT",1427,10,12,0)
	;;=1624^LE
	;;^UTILITY(U,$J,"OPT",1427,10,12,"^")
	;;=FHASE7
	;;^UTILITY(U,$J,"OPT",1427,10,13,0)
	;;=1635^PE
	;;^UTILITY(U,$J,"OPT",1427,10,13,"^")
	;;=FHORX2
	;;^UTILITY(U,$J,"OPT",1427,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1427,20)
	;;=S FHA1=2 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1427,99)
	;;=56496,40785
	;;^UTILITY(U,$J,"OPT",1427,99.1)
	;;=55410,42176
	;;^UTILITY(U,$J,"OPT",1427,"U")
	;;=CLINICAL DIETETICS
	;;^UTILITY(U,$J,"OPT",1428,0)
	;;=FHNU7^List Nutrient File^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1428,1,0)
	;;=^^2^2^2890606^^^^
	;;^UTILITY(U,$J,"OPT",1428,1,1,0)
	;;=This option will produce a complete listing of the Food Nutrients
	;;^UTILITY(U,$J,"OPT",1428,1,2,0)
	;;=file (112) except for the actual nutrient values.
	;;^UTILITY(U,$J,"OPT",1428,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,25)
	;;=EN5^FHNU
	;;^UTILITY(U,$J,"OPT",1428,30)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,60)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,62)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,63)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,64)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,65)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,66)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,67)
	;;=
	;;^UTILITY(U,$J,"OPT",1428,"U")
	;;=LIST NUTRIENT FILE
	;;^UTILITY(U,$J,"OPT",1429,0)
	;;=FHNO5^List Supplemental Feedings^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1429,1,0)
	;;=^^3^3^2880717^^^
	;;^UTILITY(U,$J,"OPT",1429,1,1,0)
	;;=This option will list all supplemental feedings contained
	;;^UTILITY(U,$J,"OPT",1429,1,2,0)
	;;=in the Supplemental Feedings file (118) along will associated
	;;^UTILITY(U,$J,"OPT",1429,1,3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"OPT",1429,25)
	;;=EN6^FHNO1
	;;^UTILITY(U,$J,"OPT",1429,"U")
	;;=LIST SUPPLEMENTAL FEEDINGS

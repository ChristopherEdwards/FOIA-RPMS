FHINI0NL	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1475,10,3,"^")
	;;=FHORD9
	;;^UTILITY(U,$J,"OPT",1475,10,4,0)
	;;=1438^DH
	;;^UTILITY(U,$J,"OPT",1475,10,4,"^")
	;;=FHORD2
	;;^UTILITY(U,$J,"OPT",1475,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1475,20)
	;;=S FHA1=2 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1475,99)
	;;=56496,40789
	;;^UTILITY(U,$J,"OPT",1475,"U")
	;;=DIETETIC USER
	;;^UTILITY(U,$J,"OPT",1476,0)
	;;=FHPATP^Dietetic Patient Profile^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1476,1,0)
	;;=^^3^3^2880716^^
	;;^UTILITY(U,$J,"OPT",1476,1,1,0)
	;;=This option will display all of the pertinent dietetic
	;;^UTILITY(U,$J,"OPT",1476,1,2,0)
	;;=information about an inpatient -- diet orders, tubefeedings,
	;;^UTILITY(U,$J,"OPT",1476,1,3,0)
	;;=active consults, early/late trays, standing orders, etc.
	;;^UTILITY(U,$J,"OPT",1476,10,0)
	;;=^19.01PI^2^2
	;;^UTILITY(U,$J,"OPT",1476,10,1,0)
	;;=1461^PP
	;;^UTILITY(U,$J,"OPT",1476,10,1,"^")
	;;=FHORD9
	;;^UTILITY(U,$J,"OPT",1476,10,2,0)
	;;=1438^DH
	;;^UTILITY(U,$J,"OPT",1476,10,2,"^")
	;;=FHORD2
	;;^UTILITY(U,$J,"OPT",1476,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1476,20)
	;;=S FHA1=6 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1476,25)
	;;=
	;;^UTILITY(U,$J,"OPT",1476,99)
	;;=56496,40739
	;;^UTILITY(U,$J,"OPT",1476,"U")
	;;=DIETETIC PATIENT PROFILE
	;;^UTILITY(U,$J,"OPT",1477,0)
	;;=FHNO11^Supplemental Feeding Cost Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1477,1,0)
	;;=^^2^2^2930514^^^^
	;;^UTILITY(U,$J,"OPT",1477,1,1,0)
	;;=This option will produce a cost report for a ward, or all wards,
	;;^UTILITY(U,$J,"OPT",1477,1,2,0)
	;;=based upon the supplemental feedings currently ordered.
	;;^UTILITY(U,$J,"OPT",1477,25)
	;;=FHNO6
	;;^UTILITY(U,$J,"OPT",1477,"U")
	;;=SUPPLEMENTAL FEEDING COST REPO
	;;^UTILITY(U,$J,"OPT",1478,0)
	;;=FHCDLST^Dietetic Lists/Reports^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1478,1,0)
	;;=^^3^3^2950714^^^^
	;;^UTILITY(U,$J,"OPT",1478,1,1,0)
	;;=This menu contains the various lists and reports most often
	;;^UTILITY(U,$J,"OPT",1478,1,2,0)
	;;=required by the clinical staff or the diet communications
	;;^UTILITY(U,$J,"OPT",1478,1,3,0)
	;;=office.
	;;^UTILITY(U,$J,"OPT",1478,10,0)
	;;=^19.01PI^24^17
	;;^UTILITY(U,$J,"OPT",1478,10,1,0)
	;;=1474^DA
	;;^UTILITY(U,$J,"OPT",1478,10,1,"^")
	;;=FHORD13
	;;^UTILITY(U,$J,"OPT",1478,10,2,0)
	;;=1472^DC
	;;^UTILITY(U,$J,"OPT",1478,10,2,"^")
	;;=FHORD11
	;;^UTILITY(U,$J,"OPT",1478,10,3,0)
	;;=1453^EL
	;;^UTILITY(U,$J,"OPT",1478,10,3,"^")
	;;=FHOREL1
	;;^UTILITY(U,$J,"OPT",1478,10,4,0)
	;;=1439^NL
	;;^UTILITY(U,$J,"OPT",1478,10,4,"^")
	;;=FHORD5
	;;^UTILITY(U,$J,"OPT",1478,10,6,0)
	;;=1471^WD
	;;^UTILITY(U,$J,"OPT",1478,10,6,"^")
	;;=FHORD10
	;;^UTILITY(U,$J,"OPT",1478,10,8,0)
	;;=1463^WP
	;;^UTILITY(U,$J,"OPT",1478,10,8,"^")
	;;=FHNO10
	;;^UTILITY(U,$J,"OPT",1478,10,9,0)
	;;=1420^LA
	;;^UTILITY(U,$J,"OPT",1478,10,9,"^")
	;;=FHNO2
	;;^UTILITY(U,$J,"OPT",1478,10,10,0)
	;;=1421^WL
	;;^UTILITY(U,$J,"OPT",1478,10,10,"^")
	;;=FHNO3
	;;^UTILITY(U,$J,"OPT",1478,10,11,0)
	;;=1489^DR
	;;^UTILITY(U,$J,"OPT",1478,10,11,"^")
	;;=FHORD14
	;;^UTILITY(U,$J,"OPT",1478,10,12,0)
	;;=1494^IL
	;;^UTILITY(U,$J,"OPT",1478,10,12,"^")
	;;=FHORD41
	;;^UTILITY(U,$J,"OPT",1478,10,13,0)
	;;=1502^SO
	;;^UTILITY(U,$J,"OPT",1478,10,13,"^")
	;;=FHSP5
	;;^UTILITY(U,$J,"OPT",1478,10,14,0)
	;;=1550^BL
	;;^UTILITY(U,$J,"OPT",1478,10,14,"^")
	;;=FHBIR
	;;^UTILITY(U,$J,"OPT",1478,10,20,0)
	;;=1628^SP
	;;^UTILITY(U,$J,"OPT",1478,10,20,"^")
	;;=FHSP7
	;;^UTILITY(U,$J,"OPT",1478,10,21,0)
	;;=1629^SL
	;;^UTILITY(U,$J,"OPT",1478,10,21,"^")
	;;=FHSP8
	;;^UTILITY(U,$J,"OPT",1478,10,22,0)
	;;=1708^TR
	;;^UTILITY(U,$J,"OPT",1478,10,22,"^")
	;;=FHORTFM
	;;^UTILITY(U,$J,"OPT",1478,10,23,0)
	;;=1635^PE
	;;^UTILITY(U,$J,"OPT",1478,10,23,"^")
	;;=FHORX2
	;;^UTILITY(U,$J,"OPT",1478,10,24,0)
	;;=1820^TT
	;;^UTILITY(U,$J,"OPT",1478,10,24,"^")
	;;=FHMTKM
	;;^UTILITY(U,$J,"OPT",1478,99)
	;;=56496,40784
	;;^UTILITY(U,$J,"OPT",1478,"U")
	;;=DIETETIC LISTS/REPORTS
	;;^UTILITY(U,$J,"OPT",1479,0)
	;;=FHTECH^Clinical Dietetics^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1479,1,0)
	;;=^^2^2^2941019^^^^
	;;^UTILITY(U,$J,"OPT",1479,1,1,0)
	;;=This menu contains all of the various options that dietetic
	;;^UTILITY(U,$J,"OPT",1479,1,2,0)
	;;=technicians will require. It is the same as the FHDIET menu.
	;;^UTILITY(U,$J,"OPT",1479,10,0)
	;;=^19.01PI^13^12
	;;^UTILITY(U,$J,"OPT",1479,10,1,0)
	;;=1449^DC
	;;^UTILITY(U,$J,"OPT",1479,10,1,"^")
	;;=FHORCM
	;;^UTILITY(U,$J,"OPT",1479,10,2,0)
	;;=1440^DO
	;;^UTILITY(U,$J,"OPT",1479,10,2,"^")
	;;=FHORDM
	;;^UTILITY(U,$J,"OPT",1479,10,3,0)
	;;=1417^EA
	;;^UTILITY(U,$J,"OPT",1479,10,3,"^")
	;;=FHNUM
	;;^UTILITY(U,$J,"OPT",1479,10,4,0)
	;;=1584^NM

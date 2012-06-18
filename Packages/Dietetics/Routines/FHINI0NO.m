FHINI0NO	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1490,1,4,0)
	;;=inpatients, and create missing dietetic file entries for
	;;^UTILITY(U,$J,"OPT",1490,1,5,0)
	;;=inpatients.
	;;^UTILITY(U,$J,"OPT",1490,10,0)
	;;=^19.01PI^7^7
	;;^UTILITY(U,$J,"OPT",1490,10,1,0)
	;;=1409^SP
	;;^UTILITY(U,$J,"OPT",1490,10,1,"^")
	;;=FHSITE
	;;^UTILITY(U,$J,"OPT",1490,10,2,0)
	;;=1491^PD
	;;^UTILITY(U,$J,"OPT",1490,10,2,"^")
	;;=FHPURGE
	;;^UTILITY(U,$J,"OPT",1490,10,3,0)
	;;=1554^RI
	;;^UTILITY(U,$J,"OPT",1490,10,3,"^")
	;;=FHX1
	;;^UTILITY(U,$J,"OPT",1490,10,4,0)
	;;=1555^RD
	;;^UTILITY(U,$J,"OPT",1490,10,4,"^")
	;;=FHX2
	;;^UTILITY(U,$J,"OPT",1490,10,5,0)
	;;=1556^FP
	;;^UTILITY(U,$J,"OPT",1490,10,5,"^")
	;;=FHX3
	;;^UTILITY(U,$J,"OPT",1490,10,6,0)
	;;=1557^DF
	;;^UTILITY(U,$J,"OPT",1490,10,6,"^")
	;;=FHX4
	;;^UTILITY(U,$J,"OPT",1490,10,7,0)
	;;=1603^DL
	;;^UTILITY(U,$J,"OPT",1490,10,7,"^")
	;;=FHX5
	;;^UTILITY(U,$J,"OPT",1490,99)
	;;=56496,40797
	;;^UTILITY(U,$J,"OPT",1490,"U")
	;;=SYSTEM MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1491,0)
	;;=FHPURGE^Purge Dietetic Data^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1491,1,0)
	;;=^^3^3^2931027^^^^
	;;^UTILITY(U,$J,"OPT",1491,1,1,0)
	;;=This option allows the purging of dietetic data on all admissions
	;;^UTILITY(U,$J,"OPT",1491,1,2,0)
	;;=for which at least 400 days have elapsed since discharge. The
	;;^UTILITY(U,$J,"OPT",1491,1,3,0)
	;;=data is not archived but is permanently purged from the system.
	;;^UTILITY(U,$J,"OPT",1491,25)
	;;=FHSYSK
	;;^UTILITY(U,$J,"OPT",1491,"U")
	;;=PURGE DIETETIC DATA
	;;^UTILITY(U,$J,"OPT",1492,0)
	;;=FHMGRC^Clinical Management^^M^^^^^^^^DIETETICS^^1
	;;^UTILITY(U,$J,"OPT",1492,1,0)
	;;=^^2^2^2950420^^^^
	;;^UTILITY(U,$J,"OPT",1492,1,1,0)
	;;=This menu allows access to all options pertaining to clinical
	;;^UTILITY(U,$J,"OPT",1492,1,2,0)
	;;=dietetics.
	;;^UTILITY(U,$J,"OPT",1492,10,0)
	;;=^19.01PI^10^8
	;;^UTILITY(U,$J,"OPT",1492,10,1,0)
	;;=1427^CD
	;;^UTILITY(U,$J,"OPT",1492,10,1,"^")
	;;=FHDIET
	;;^UTILITY(U,$J,"OPT",1492,10,2,0)
	;;=1408^DM
	;;^UTILITY(U,$J,"OPT",1492,10,2,"^")
	;;=FHDMP
	;;^UTILITY(U,$J,"OPT",1492,10,3,0)
	;;=1467^XD
	;;^UTILITY(U,$J,"OPT",1492,10,3,"^")
	;;=FHORDX
	;;^UTILITY(U,$J,"OPT",1492,10,4,0)
	;;=1466^XM
	;;^UTILITY(U,$J,"OPT",1492,10,4,"^")
	;;=FHORCX
	;;^UTILITY(U,$J,"OPT",1492,10,5,0)
	;;=1469^XS
	;;^UTILITY(U,$J,"OPT",1492,10,5,"^")
	;;=FHNOX
	;;^UTILITY(U,$J,"OPT",1492,10,6,0)
	;;=1468^XE
	;;^UTILITY(U,$J,"OPT",1492,10,6,"^")
	;;=FHNUX
	;;^UTILITY(U,$J,"OPT",1492,10,7,0)
	;;=1493^XF
	;;^UTILITY(U,$J,"OPT",1492,10,7,"^")
	;;=FHFILM
	;;^UTILITY(U,$J,"OPT",1492,10,10,0)
	;;=1583^XC
	;;^UTILITY(U,$J,"OPT",1492,10,10,"^")
	;;=FHASCX
	;;^UTILITY(U,$J,"OPT",1492,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1492,20)
	;;=S FHA1=5 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1492,99)
	;;=56496,40727
	;;^UTILITY(U,$J,"OPT",1492,"U")
	;;=CLINICAL MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1493,0)
	;;=FHFILM^File Manager^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1493,1,0)
	;;=^^2^2^2911113^^^^
	;;^UTILITY(U,$J,"OPT",1493,1,1,0)
	;;=This menu allows access to FileMan print, search, inquire, and
	;;^UTILITY(U,$J,"OPT",1493,1,2,0)
	;;=list data dictionary options.
	;;^UTILITY(U,$J,"OPT",1493,10,0)
	;;=^19.01PI^4^4
	;;^UTILITY(U,$J,"OPT",1493,10,1,0)
	;;=1568^PE
	;;^UTILITY(U,$J,"OPT",1493,10,1,"^")
	;;=FHFIL1
	;;^UTILITY(U,$J,"OPT",1493,10,2,0)
	;;=1569^SE
	;;^UTILITY(U,$J,"OPT",1493,10,2,"^")
	;;=FHFIL2
	;;^UTILITY(U,$J,"OPT",1493,10,3,0)
	;;=1570^IE
	;;^UTILITY(U,$J,"OPT",1493,10,3,"^")
	;;=FHFIL3
	;;^UTILITY(U,$J,"OPT",1493,10,4,0)
	;;=1571^FD
	;;^UTILITY(U,$J,"OPT",1493,10,4,"^")
	;;=FHFIL4
	;;^UTILITY(U,$J,"OPT",1493,99)
	;;=56496,40652
	;;^UTILITY(U,$J,"OPT",1493,"U")
	;;=FILE MANAGER
	;;^UTILITY(U,$J,"OPT",1494,0)
	;;=FHORD41^Isolation/Precaution Patient List^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1494,1,0)
	;;=^^2^2^2880714^
	;;^UTILITY(U,$J,"OPT",1494,1,1,0)
	;;=This option will produce a list of all patients currently
	;;^UTILITY(U,$J,"OPT",1494,1,2,0)
	;;=on some type of isolation or precautions.
	;;^UTILITY(U,$J,"OPT",1494,25)
	;;=FHORD41
	;;^UTILITY(U,$J,"OPT",1494,"U")
	;;=ISOLATION/PRECAUTION PATIENT L
	;;^UTILITY(U,$J,"OPT",1495,0)
	;;=FHADMR4^Enter/Edit Staffing Data^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1495,1,0)
	;;=^^4^4^2920915^^^
	;;^UTILITY(U,$J,"OPT",1495,1,1,0)
	;;=This option allows for entry and/or editing of the various values
	;;^UTILITY(U,$J,"OPT",1495,1,2,0)
	;;=used in the Performance Standards Report. The value for the
	;;^UTILITY(U,$J,"OPT",1495,1,3,0)
	;;=Served Rations is automatically captured from the Served Ration
	;;^UTILITY(U,$J,"OPT",1495,1,4,0)
	;;=Report and cannot be edited.
	;;^UTILITY(U,$J,"OPT",1495,25)
	;;=EN1^FHADM4

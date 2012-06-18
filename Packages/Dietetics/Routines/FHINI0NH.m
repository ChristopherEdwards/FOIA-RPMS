FHINI0NH	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1447,1,2,0)
	;;=and status of a consult.
	;;^UTILITY(U,$J,"OPT",1447,25)
	;;=EN2^FHORC2
	;;^UTILITY(U,$J,"OPT",1447,"U")
	;;=CONSULT INQUIRY
	;;^UTILITY(U,$J,"OPT",1448,0)
	;;=FHORC4^Clear/Cancel/Reassign a Consult^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1448,1,0)
	;;=^^2^2^2880716^^
	;;^UTILITY(U,$J,"OPT",1448,1,1,0)
	;;=This option allows a clinician to clear (complete) a consult,
	;;^UTILITY(U,$J,"OPT",1448,1,2,0)
	;;=cancel it, or assign it to another clinician.
	;;^UTILITY(U,$J,"OPT",1448,25)
	;;=EN1^FHORC2
	;;^UTILITY(U,$J,"OPT",1448,"U")
	;;=CLEAR/CANCEL/REASSIGN A CONSUL
	;;^UTILITY(U,$J,"OPT",1449,0)
	;;=FHORCM^Dietetic Consults^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1449,1,0)
	;;=^^2^2^2880717^
	;;^UTILITY(U,$J,"OPT",1449,1,1,0)
	;;=This menu contains the majority of the Consult options and
	;;^UTILITY(U,$J,"OPT",1449,1,2,0)
	;;=is for routine use by the clinical dietetic staff.
	;;^UTILITY(U,$J,"OPT",1449,10,0)
	;;=^19.01PI^4^4
	;;^UTILITY(U,$J,"OPT",1449,10,1,0)
	;;=1446^AC
	;;^UTILITY(U,$J,"OPT",1449,10,1,"^")
	;;=FHORC2
	;;^UTILITY(U,$J,"OPT",1449,10,2,0)
	;;=1447^IN
	;;^UTILITY(U,$J,"OPT",1449,10,2,"^")
	;;=FHORC3
	;;^UTILITY(U,$J,"OPT",1449,10,3,0)
	;;=1448^CC
	;;^UTILITY(U,$J,"OPT",1449,10,3,"^")
	;;=FHORC4
	;;^UTILITY(U,$J,"OPT",1449,10,4,0)
	;;=1435^OC
	;;^UTILITY(U,$J,"OPT",1449,10,4,"^")
	;;=FHORC1
	;;^UTILITY(U,$J,"OPT",1449,99)
	;;=56496,40714
	;;^UTILITY(U,$J,"OPT",1449,"U")
	;;=DIETETIC CONSULTS
	;;^UTILITY(U,$J,"OPT",1450,0)
	;;=FHORTF1^Enter/Edit Tubefeeding Products^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1450,1,0)
	;;=^^2^2^2920505^^^
	;;^UTILITY(U,$J,"OPT",1450,1,1,0)
	;;=This option allows for the creation/editing of products in the
	;;^UTILITY(U,$J,"OPT",1450,1,2,0)
	;;=Tubefeeding file (118.2).
	;;^UTILITY(U,$J,"OPT",1450,25)
	;;=EN1^FHORT3
	;;^UTILITY(U,$J,"OPT",1450,"U")
	;;=ENTER/EDIT TUBEFEEDING PRODUCT
	;;^UTILITY(U,$J,"OPT",1451,0)
	;;=FHORTF2^List Tubefeeding Products^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1451,1,0)
	;;=^^3^3^2950302^^^
	;;^UTILITY(U,$J,"OPT",1451,1,1,0)
	;;=This option will list all tubefeeding products in the
	;;^UTILITY(U,$J,"OPT",1451,1,2,0)
	;;=Tubefeeding file (118.2) along with all associated data
	;;^UTILITY(U,$J,"OPT",1451,1,3,0)
	;;=elements.
	;;^UTILITY(U,$J,"OPT",1451,25)
	;;=EN2^FHORT3
	;;^UTILITY(U,$J,"OPT",1451,"U")
	;;=LIST TUBEFEEDING PRODUCTS
	;;^UTILITY(U,$J,"OPT",1452,0)
	;;=FHORTF3^Order Tubefeeding^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1452,1,0)
	;;=^^2^2^2920505^^^^
	;;^UTILITY(U,$J,"OPT",1452,1,1,0)
	;;=This option allows for the ordering of a tubefeeding for an
	;;^UTILITY(U,$J,"OPT",1452,1,2,0)
	;;=inpatient.
	;;^UTILITY(U,$J,"OPT",1452,25)
	;;=FHORT1
	;;^UTILITY(U,$J,"OPT",1452,"U")
	;;=ORDER TUBEFEEDING
	;;^UTILITY(U,$J,"OPT",1453,0)
	;;=FHOREL1^List Early/Late Trays^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1453,1,0)
	;;=^^2^2^2930427^^^
	;;^UTILITY(U,$J,"OPT",1453,1,1,0)
	;;=This option will list, for a specified date and meal, all
	;;^UTILITY(U,$J,"OPT",1453,1,2,0)
	;;=early and late tray orders.
	;;^UTILITY(U,$J,"OPT",1453,25)
	;;=FHORE2
	;;^UTILITY(U,$J,"OPT",1453,"U")
	;;=LIST EARLY/LATE TRAYS
	;;^UTILITY(U,$J,"OPT",1454,0)
	;;=FHOREL2^Order Early/Late Tray^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1454,1,0)
	;;=^^5^5^2880717^^
	;;^UTILITY(U,$J,"OPT",1454,1,1,0)
	;;=This option will allow the ordering of an early or late tray
	;;^UTILITY(U,$J,"OPT",1454,1,2,0)
	;;=for a patient. A series of trays, for specified days of the
	;;^UTILITY(U,$J,"OPT",1454,1,3,0)
	;;=week, may also be ordered in the case of patients on chemotherapy
	;;^UTILITY(U,$J,"OPT",1454,1,4,0)
	;;=or radiation therapy needing early or late trays on a
	;;^UTILITY(U,$J,"OPT",1454,1,5,0)
	;;=consistent basis.
	;;^UTILITY(U,$J,"OPT",1454,25)
	;;=FHORE1
	;;^UTILITY(U,$J,"OPT",1454,"U")
	;;=ORDER EARLY/LATE TRAY
	;;^UTILITY(U,$J,"OPT",1455,0)
	;;=FHOREL3^Cancel Early/Late Tray^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1455,1,0)
	;;=^^2^2^2880717^
	;;^UTILITY(U,$J,"OPT",1455,1,1,0)
	;;=This option will allow the cancellation of an early or late
	;;^UTILITY(U,$J,"OPT",1455,1,2,0)
	;;=tray order. Optionally, all future orders may be cancelled.
	;;^UTILITY(U,$J,"OPT",1455,25)
	;;=FHORE3
	;;^UTILITY(U,$J,"OPT",1455,"U")
	;;=CANCEL EARLY/LATE TRAY
	;;^UTILITY(U,$J,"OPT",1456,0)
	;;=FHORTF4^Cancel Tubefeeding Order^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1456,1,0)
	;;=^^2^2^2880717^
	;;^UTILITY(U,$J,"OPT",1456,1,1,0)
	;;=This option allows for the cancellation of an existing
	;;^UTILITY(U,$J,"OPT",1456,1,2,0)
	;;=tubefeeding order.
	;;^UTILITY(U,$J,"OPT",1456,25)
	;;=EN3^FHORT2
	;;^UTILITY(U,$J,"OPT",1456,"U")
	;;=CANCEL TUBEFEEDING ORDER

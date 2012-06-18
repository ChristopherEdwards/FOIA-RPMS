FHINI0NK	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1470,1,4,0)
	;;=orders. Supplemental feedings and standing orders are not
	;;^UTILITY(U,$J,"OPT",1470,1,5,0)
	;;=included as normal ward ordering functions.
	;;^UTILITY(U,$J,"OPT",1470,10,0)
	;;=^19.01PI^15^13
	;;^UTILITY(U,$J,"OPT",1470,10,1,0)
	;;=1455^XE
	;;^UTILITY(U,$J,"OPT",1470,10,1,"^")
	;;=FHOREL3
	;;^UTILITY(U,$J,"OPT",1470,10,2,0)
	;;=1456^XT
	;;^UTILITY(U,$J,"OPT",1470,10,2,"^")
	;;=FHORTF4
	;;^UTILITY(U,$J,"OPT",1470,10,3,0)
	;;=1461^PP
	;;^UTILITY(U,$J,"OPT",1470,10,3,"^")
	;;=FHORD9
	;;^UTILITY(U,$J,"OPT",1470,10,5,0)
	;;=1437^PI
	;;^UTILITY(U,$J,"OPT",1470,10,5,"^")
	;;=FHORD4
	;;^UTILITY(U,$J,"OPT",1470,10,6,0)
	;;=1436^ON
	;;^UTILITY(U,$J,"OPT",1470,10,6,"^")
	;;=FHORD3
	;;^UTILITY(U,$J,"OPT",1470,10,7,0)
	;;=1434^OD
	;;^UTILITY(U,$J,"OPT",1470,10,7,"^")
	;;=FHORD1
	;;^UTILITY(U,$J,"OPT",1470,10,8,0)
	;;=1454^OE
	;;^UTILITY(U,$J,"OPT",1470,10,8,"^")
	;;=FHOREL2
	;;^UTILITY(U,$J,"OPT",1470,10,9,0)
	;;=1435^OC
	;;^UTILITY(U,$J,"OPT",1470,10,9,"^")
	;;=FHORC1
	;;^UTILITY(U,$J,"OPT",1470,10,10,0)
	;;=1452^OT
	;;^UTILITY(U,$J,"OPT",1470,10,10,"^")
	;;=FHORTF3
	;;^UTILITY(U,$J,"OPT",1470,10,12,0)
	;;=1473^XN
	;;^UTILITY(U,$J,"OPT",1470,10,12,"^")
	;;=FHORD12
	;;^UTILITY(U,$J,"OPT",1470,10,13,0)
	;;=1438^PH
	;;^UTILITY(U,$J,"OPT",1470,10,13,"^")
	;;=FHORD2
	;;^UTILITY(U,$J,"OPT",1470,10,14,0)
	;;=1483^OA
	;;^UTILITY(U,$J,"OPT",1470,10,14,"^")
	;;=FHORO1
	;;^UTILITY(U,$J,"OPT",1470,10,15,0)
	;;=1833^PA
	;;^UTILITY(U,$J,"OPT",1470,10,15,"^")
	;;=GMRA PATIENT A/AR EDIT
	;;^UTILITY(U,$J,"OPT",1470,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1470,20)
	;;=S FHA1=3 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1470,99)
	;;=56496,40791
	;;^UTILITY(U,$J,"OPT",1470,"U")
	;;=DIETETIC ORDERS
	;;^UTILITY(U,$J,"OPT",1471,0)
	;;=FHORD10^Ward Diet Order List^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1471,1,0)
	;;=^^4^4^2920727^^^
	;;^UTILITY(U,$J,"OPT",1471,1,1,0)
	;;=This option will produce a list of all patients on a ward along
	;;^UTILITY(U,$J,"OPT",1471,1,2,0)
	;;=with a majority of the dietetic orders for the patient: diet
	;;^UTILITY(U,$J,"OPT",1471,1,3,0)
	;;=order, active consults, standing orders, early/late tray requests
	;;^UTILITY(U,$J,"OPT",1471,1,4,0)
	;;=for the next 72 hours, etc.
	;;^UTILITY(U,$J,"OPT",1471,25)
	;;=FHORD8
	;;^UTILITY(U,$J,"OPT",1471,"U")
	;;=WARD DIET ORDER LIST
	;;^UTILITY(U,$J,"OPT",1472,0)
	;;=FHORD11^Actual Diet Census^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1472,1,0)
	;;=^^3^3^2930603^^^^
	;;^UTILITY(U,$J,"OPT",1472,1,1,0)
	;;=This option will produce, for a specified date/time and Production
	;;^UTILITY(U,$J,"OPT",1472,1,2,0)
	;;=Facility, the production diet counts based upon the tallied diets
	;;^UTILITY(U,$J,"OPT",1472,1,3,0)
	;;=of all inpatients.
	;;^UTILITY(U,$J,"OPT",1472,25)
	;;=FHORD9
	;;^UTILITY(U,$J,"OPT",1472,200)
	;;=^^
	;;^UTILITY(U,$J,"OPT",1472,"U")
	;;=ACTUAL DIET CENSUS
	;;^UTILITY(U,$J,"OPT",1473,0)
	;;=FHORD12^Cancel NPO/Withhold Order^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1473,1,0)
	;;=^^2^2^2920318^^^
	;;^UTILITY(U,$J,"OPT",1473,1,1,0)
	;;=This option will list all current/future NPO or Withhold orders
	;;^UTILITY(U,$J,"OPT",1473,1,2,0)
	;;=and allows cancellation (or discontinuation) of the order.
	;;^UTILITY(U,$J,"OPT",1473,25)
	;;=EN2^FHORD3
	;;^UTILITY(U,$J,"OPT",1473,"U")
	;;=CANCEL NPO/WITHHOLD ORDER
	;;^UTILITY(U,$J,"OPT",1474,0)
	;;=FHORD13^Diet Activity Report/Labels^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1474,1,0)
	;;=^^4^4^2931208^^^^
	;;^UTILITY(U,$J,"OPT",1474,1,1,0)
	;;=This option will produce a listing, or diet card labels, for
	;;^UTILITY(U,$J,"OPT",1474,1,2,0)
	;;=all patients who have had MAS activity (e.g., change of room
	;;^UTILITY(U,$J,"OPT",1474,1,3,0)
	;;=or ward) or change of diet order or type of service, since
	;;^UTILITY(U,$J,"OPT",1474,1,4,0)
	;;=the last report was run.
	;;^UTILITY(U,$J,"OPT",1474,25)
	;;=FHORX1
	;;^UTILITY(U,$J,"OPT",1474,"U")
	;;=DIET ACTIVITY REPORT/LABELS
	;;^UTILITY(U,$J,"OPT",1475,0)
	;;=FHUSR^Dietetic User^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1475,1,0)
	;;=^^3^3^2891106^^^
	;;^UTILITY(U,$J,"OPT",1475,1,1,0)
	;;=This menu allows non-dietetic personnel access to the nutrition
	;;^UTILITY(U,$J,"OPT",1475,1,2,0)
	;;=assessment option, the energy/nutrient abbreviated analysis, the
	;;^UTILITY(U,$J,"OPT",1475,1,3,0)
	;;=dietetic patient profile, and the ability to review diet orders.
	;;^UTILITY(U,$J,"OPT",1475,10,0)
	;;=^19.01PI^4^4
	;;^UTILITY(U,$J,"OPT",1475,10,1,0)
	;;=1416^AA
	;;^UTILITY(U,$J,"OPT",1475,10,1,"^")
	;;=FHNU5
	;;^UTILITY(U,$J,"OPT",1475,10,2,0)
	;;=1574^DA
	;;^UTILITY(U,$J,"OPT",1475,10,2,"^")
	;;=FHASMR
	;;^UTILITY(U,$J,"OPT",1475,10,3,0)
	;;=1461^PP

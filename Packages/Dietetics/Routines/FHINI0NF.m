FHINI0NF	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1430,0)
	;;=FHNO7^List Supplemental Feeding Menus^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1430,1,0)
	;;=^^3^3^2880717^^^^
	;;^UTILITY(U,$J,"OPT",1430,1,1,0)
	;;=This option will list all supplemental feeding menus contained in the
	;;^UTILITY(U,$J,"OPT",1430,1,2,0)
	;;=Supplemental Feeding Menu file (118.1) along with associated
	;;^UTILITY(U,$J,"OPT",1430,1,3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"OPT",1430,25)
	;;=EN7^FHNO1
	;;^UTILITY(U,$J,"OPT",1430,"U")
	;;=LIST SUPPLEMENTAL FEEDING MENU
	;;^UTILITY(U,$J,"OPT",1431,0)
	;;=FHNU3^List User Menus^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1431,1,0)
	;;=^^2^2^2950313^^^^
	;;^UTILITY(U,$J,"OPT",1431,1,1,0)
	;;=This option will list the User Menus currently contained in the
	;;^UTILITY(U,$J,"OPT",1431,1,2,0)
	;;=User Menu file (112.6) by user.
	;;^UTILITY(U,$J,"OPT",1431,25)
	;;=EN8^FHNU
	;;^UTILITY(U,$J,"OPT",1431,"U")
	;;=LIST USER MENUS
	;;^UTILITY(U,$J,"OPT",1432,0)
	;;=FHNU9^List RDA Values^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1432,1,0)
	;;=^^1^1^2880717^
	;;^UTILITY(U,$J,"OPT",1432,1,1,0)
	;;=This option will list the contents of the RDA Values file (112.2).
	;;^UTILITY(U,$J,"OPT",1432,25)
	;;=FHNU10
	;;^UTILITY(U,$J,"OPT",1432,"U")
	;;=LIST RDA VALUES
	;;^UTILITY(U,$J,"OPT",1433,0)
	;;=FHORD6^Enter/Edit Diets^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1433,1,0)
	;;=^^2^2^2880714^
	;;^UTILITY(U,$J,"OPT",1433,1,1,0)
	;;=This option allows for the addition/editing of diet modifications
	;;^UTILITY(U,$J,"OPT",1433,1,2,0)
	;;=in the Diets file (111).
	;;^UTILITY(U,$J,"OPT",1433,25)
	;;=EN1^FHORD
	;;^UTILITY(U,$J,"OPT",1433,"U")
	;;=ENTER/EDIT DIETS
	;;^UTILITY(U,$J,"OPT",1434,0)
	;;=FHORD1^Order Diet^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1434,1,0)
	;;=^^3^3^2940107^^^
	;;^UTILITY(U,$J,"OPT",1434,1,1,0)
	;;=This option allows for the ordering of a diet, which is composed
	;;^UTILITY(U,$J,"OPT",1434,1,2,0)
	;;=of up to five diet modifications. The type of service, a beginning
	;;^UTILITY(U,$J,"OPT",1434,1,3,0)
	;;=date/time, and an optional ending date/time are also entered.
	;;^UTILITY(U,$J,"OPT",1434,25)
	;;=FHORD1
	;;^UTILITY(U,$J,"OPT",1434,"U")
	;;=ORDER DIET
	;;^UTILITY(U,$J,"OPT",1435,0)
	;;=FHORC1^Order Consult^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1435,1,0)
	;;=1^^1^1^2920605^
	;;^UTILITY(U,$J,"OPT",1435,1,1,0)
	;;=This option allows the ordering of a dietetic consult.
	;;^UTILITY(U,$J,"OPT",1435,25)
	;;=EN1^FHORC
	;;^UTILITY(U,$J,"OPT",1435,"U")
	;;=ORDER CONSULT
	;;^UTILITY(U,$J,"OPT",1436,0)
	;;=FHORD3^NPO/Hold Tray^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1436,1,0)
	;;=^^1^1^2920318^^^^
	;;^UTILITY(U,$J,"OPT",1436,1,1,0)
	;;=This option allows for the entry of an NPO order.
	;;^UTILITY(U,$J,"OPT",1436,25)
	;;=FHORD3
	;;^UTILITY(U,$J,"OPT",1436,"U")
	;;=NPO/HOLD TRAY
	;;^UTILITY(U,$J,"OPT",1437,0)
	;;=FHORD4^Enter/Cancel Isolation/Precautions^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1437,1,0)
	;;=^^3^3^2880914^^^
	;;^UTILITY(U,$J,"OPT",1437,1,1,0)
	;;=This option allows for placing a patient on isolation (as far
	;;^UTILITY(U,$J,"OPT",1437,1,2,0)
	;;=as dietetics is concerned) or removing the patient from an
	;;^UTILITY(U,$J,"OPT",1437,1,3,0)
	;;=existing isolation/precaution type.
	;;^UTILITY(U,$J,"OPT",1437,25)
	;;=FHORD4
	;;^UTILITY(U,$J,"OPT",1437,"U")
	;;=ENTER/CANCEL ISOLATION/PRECAUT
	;;^UTILITY(U,$J,"OPT",1438,0)
	;;=FHORD2^Review Diet Orders^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1438,1,0)
	;;=^^3^3^2950921^^^^
	;;^UTILITY(U,$J,"OPT",1438,1,1,0)
	;;=This option displays all diet orders entered as well as a
	;;^UTILITY(U,$J,"OPT",1438,1,2,0)
	;;='dietetic time line' indicating when each diet order will
	;;^UTILITY(U,$J,"OPT",1438,1,3,0)
	;;=become effective.
	;;^UTILITY(U,$J,"OPT",1438,25)
	;;=FHORD2
	;;^UTILITY(U,$J,"OPT",1438,"U")
	;;=REVIEW DIET ORDERS
	;;^UTILITY(U,$J,"OPT",1439,0)
	;;=FHORD5^NPO/Pass List^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1439,1,0)
	;;=^^2^2^2880714^
	;;^UTILITY(U,$J,"OPT",1439,1,1,0)
	;;=This option will produce a list of all patients who are presently
	;;^UTILITY(U,$J,"OPT",1439,1,2,0)
	;;=on NPO or for whom no order exists.
	;;^UTILITY(U,$J,"OPT",1439,25)
	;;=FHORD5
	;;^UTILITY(U,$J,"OPT",1439,"U")
	;;=NPO/PASS LIST
	;;^UTILITY(U,$J,"OPT",1440,0)
	;;=FHORDM^Diet Orders^^M^^^^^^^^^^1
	;;^UTILITY(U,$J,"OPT",1440,1,0)
	;;=^^3^3^2940707^^^^
	;;^UTILITY(U,$J,"OPT",1440,1,1,0)
	;;=This menu allows access to all Diet Order functions including
	;;^UTILITY(U,$J,"OPT",1440,1,2,0)
	;;=diet orders, NPO's, early/late trays, isolations,
	;;^UTILITY(U,$J,"OPT",1440,1,3,0)
	;;=tubefeedings, and additional orders.
	;;^UTILITY(U,$J,"OPT",1440,10,0)
	;;=^19.01PI^26^14

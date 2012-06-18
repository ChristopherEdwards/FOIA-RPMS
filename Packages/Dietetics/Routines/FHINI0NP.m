FHINI0NP	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1495,"U")
	;;=ENTER/EDIT STAFFING DATA
	;;^UTILITY(U,$J,"OPT",1496,0)
	;;=FHADMR5^Staffing Data Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1496,1,0)
	;;=^^3^3^2920915^^^
	;;^UTILITY(U,$J,"OPT",1496,1,1,0)
	;;=This option will produce the Performance Standards Report for any
	;;^UTILITY(U,$J,"OPT",1496,1,2,0)
	;;=specified time period. The value for the Served Rations is calculated
	;;^UTILITY(U,$J,"OPT",1496,1,3,0)
	;;=from the most recent data in the Served Ration Report.
	;;^UTILITY(U,$J,"OPT",1496,25)
	;;=EN2^FHADM4
	;;^UTILITY(U,$J,"OPT",1496,"U")
	;;=STAFFING DATA REPORT
	;;^UTILITY(U,$J,"OPT",1497,0)
	;;=FHNU11^Recipe Analysis^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1497,1,0)
	;;=^^4^4^2930510^^^^
	;;^UTILITY(U,$J,"OPT",1497,1,1,0)
	;;=This option allows for selection of items from the Food
	;;^UTILITY(U,$J,"OPT",1497,1,2,0)
	;;=Nutrient file which are then combined into a recipe and
	;;^UTILITY(U,$J,"OPT",1497,1,3,0)
	;;=optionally stored in the Food Nutrient file as an analyzed
	;;^UTILITY(U,$J,"OPT",1497,1,4,0)
	;;=food item.
	;;^UTILITY(U,$J,"OPT",1497,25)
	;;=FHNU11
	;;^UTILITY(U,$J,"OPT",1497,"U")
	;;=RECIPE ANALYSIS
	;;^UTILITY(U,$J,"OPT",1498,0)
	;;=FHSP1^Enter/Edit Standing Order File^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1498,1,0)
	;;=^^2^2^2890606^^^^
	;;^UTILITY(U,$J,"OPT",1498,1,1,0)
	;;=This option allows for the addition/editing of names
	;;^UTILITY(U,$J,"OPT",1498,1,2,0)
	;;=contained in the Standing Orders file (118.3).
	;;^UTILITY(U,$J,"OPT",1498,25)
	;;=EN1^FHSP
	;;^UTILITY(U,$J,"OPT",1498,"U")
	;;=ENTER/EDIT STANDING ORDER FILE
	;;^UTILITY(U,$J,"OPT",1499,0)
	;;=FHSP2^List Standing Order File^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1499,1,0)
	;;=^^2^2^2890606^^^
	;;^UTILITY(U,$J,"OPT",1499,1,1,0)
	;;=This option will list all standing order names contained
	;;^UTILITY(U,$J,"OPT",1499,1,2,0)
	;;=in the Standing Orders file (118.3).
	;;^UTILITY(U,$J,"OPT",1499,25)
	;;=EN2^FHSP
	;;^UTILITY(U,$J,"OPT",1499,"U")
	;;=LIST STANDING ORDER FILE
	;;^UTILITY(U,$J,"OPT",1500,0)
	;;=FHSP3^Enter/Edit Standing Orders^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1500,1,0)
	;;=^^3^3^2930930^^^^
	;;^UTILITY(U,$J,"OPT",1500,1,1,0)
	;;=This option allows for the entering and editing of a standing order
	;;^UTILITY(U,$J,"OPT",1500,1,2,0)
	;;=for a patient. The meals with which the standing order
	;;^UTILITY(U,$J,"OPT",1500,1,3,0)
	;;=are to be associated are also indicated.
	;;^UTILITY(U,$J,"OPT",1500,25)
	;;=EN1^FHSPED
	;;^UTILITY(U,$J,"OPT",1500,"U")
	;;=ENTER/EDIT STANDING ORDERS
	;;^UTILITY(U,$J,"OPT",1501,0)
	;;=FHSP4^Standing Order Inquiry^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1501,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1501,1,1,0)
	;;=This option allows for displaying the active standing orders
	;;^UTILITY(U,$J,"OPT",1501,1,2,0)
	;;=for a patient.
	;;^UTILITY(U,$J,"OPT",1501,25)
	;;=EN2^FHSPED
	;;^UTILITY(U,$J,"OPT",1501,"U")
	;;=STANDING ORDER INQUIRY
	;;^UTILITY(U,$J,"OPT",1502,0)
	;;=FHSP5^Tabulate Standing Orders^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1502,1,0)
	;;=^^3^3^2920915^^^^
	;;^UTILITY(U,$J,"OPT",1502,1,1,0)
	;;=This option will produce a tabulation of all standing orders
	;;^UTILITY(U,$J,"OPT",1502,1,2,0)
	;;=for a meal for a specified Communication Office or all
	;;^UTILITY(U,$J,"OPT",1502,1,3,0)
	;;=offices.
	;;^UTILITY(U,$J,"OPT",1502,25)
	;;=FHSPTAB
	;;^UTILITY(U,$J,"OPT",1502,"U")
	;;=TABULATE STANDING ORDERS
	;;^UTILITY(U,$J,"OPT",1503,0)
	;;=FHSPX^Standing Order Management^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1503,1,0)
	;;=^^2^2^2880806^^
	;;^UTILITY(U,$J,"OPT",1503,1,1,0)
	;;=This menu allows access to the file management options of the
	;;^UTILITY(U,$J,"OPT",1503,1,2,0)
	;;=Standing Order module.
	;;^UTILITY(U,$J,"OPT",1503,10,0)
	;;=^19.01PI^2^2
	;;^UTILITY(U,$J,"OPT",1503,10,1,0)
	;;=1498^SE
	;;^UTILITY(U,$J,"OPT",1503,10,1,"^")
	;;=FHSP1
	;;^UTILITY(U,$J,"OPT",1503,10,2,0)
	;;=1499^LS
	;;^UTILITY(U,$J,"OPT",1503,10,2,"^")
	;;=FHSP2
	;;^UTILITY(U,$J,"OPT",1503,99)
	;;=56496,40785
	;;^UTILITY(U,$J,"OPT",1503,"U")
	;;=STANDING ORDER MANAGEMENT
	;;^UTILITY(U,$J,"OPT",1504,0)
	;;=FHSPM^Standing Orders^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1504,1,0)
	;;=^^2^2^2930930^^^^
	;;^UTILITY(U,$J,"OPT",1504,1,1,0)
	;;=This menu allows access to the routine Standing Order
	;;^UTILITY(U,$J,"OPT",1504,1,2,0)
	;;=options.
	;;^UTILITY(U,$J,"OPT",1504,10,0)
	;;=^19.01PI^6^5
	;;^UTILITY(U,$J,"OPT",1504,10,1,0)
	;;=1500^SE
	;;^UTILITY(U,$J,"OPT",1504,10,1,"^")
	;;=FHSP3
	;;^UTILITY(U,$J,"OPT",1504,10,2,0)
	;;=1501^IN
	;;^UTILITY(U,$J,"OPT",1504,10,2,"^")
	;;=FHSP4
	;;^UTILITY(U,$J,"OPT",1504,10,3,0)
	;;=1502^TS

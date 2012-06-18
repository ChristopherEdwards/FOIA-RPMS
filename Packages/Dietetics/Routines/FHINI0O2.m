FHINI0O2	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1601,"U")
	;;=ENTER/EDIT COMMUNICATION OFFIC
	;;^UTILITY(U,$J,"OPT",1602,0)
	;;=FHPRO10^List Production/Service/Communication Facilities^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1602,1,0)
	;;=^^4^4^2940826^^^^
	;;^UTILITY(U,$J,"OPT",1602,1,1,0)
	;;=This option is used to produce a series of reports on each of the
	;;^UTILITY(U,$J,"OPT",1602,1,2,0)
	;;=Production Facilities, Service Points, Communication Offices, and
	;;^UTILITY(U,$J,"OPT",1602,1,3,0)
	;;=Supplemental Feeding Sites. The reports show all parameters
	;;^UTILITY(U,$J,"OPT",1602,1,4,0)
	;;=associated with each facility.
	;;^UTILITY(U,$J,"OPT",1602,25)
	;;=FHPRW1
	;;^UTILITY(U,$J,"OPT",1602,"U")
	;;=LIST PRODUCTION/SERVICE/COMMUN
	;;^UTILITY(U,$J,"OPT",1603,0)
	;;=FHX5^Update Patient Dietetic Location^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1603,1,0)
	;;=^^4^4^2950121^^^^
	;;^UTILITY(U,$J,"OPT",1603,1,1,0)
	;;=This option will determine the proper Dietetic Ward based upon
	;;^UTILITY(U,$J,"OPT",1603,1,2,0)
	;;=the Room-Bed (or Default MAS Ward if necessary) and insert the
	;;^UTILITY(U,$J,"OPT",1603,1,3,0)
	;;=location into the Dietetic Patient file for the appropriate
	;;^UTILITY(U,$J,"OPT",1603,1,4,0)
	;;=admission.
	;;^UTILITY(U,$J,"OPT",1603,25)
	;;=EN1^FHXWRD
	;;^UTILITY(U,$J,"OPT",1603,"U")
	;;=UPDATE PATIENT DIETETIC LOCATI
	;;^UTILITY(U,$J,"OPT",1604,0)
	;;=FHPRO11^Enter/Edit Supplemental Fdg. Sites^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1604,1,0)
	;;=^^3^3^2911204^
	;;^UTILITY(U,$J,"OPT",1604,1,1,0)
	;;=This option is used to enter and edit values for Supplemental
	;;^UTILITY(U,$J,"OPT",1604,1,2,0)
	;;=Feeding Sites. These sites assemble the supplemental feeding orders
	;;^UTILITY(U,$J,"OPT",1604,1,3,0)
	;;=for the wards which are asigned to them.
	;;^UTILITY(U,$J,"OPT",1604,25)
	;;=EN8^FHPRO
	;;^UTILITY(U,$J,"OPT",1604,"U")
	;;=ENTER/EDIT SUPPLEMENTAL FDG. S
	;;^UTILITY(U,$J,"OPT",1606,0)
	;;=FHPRG^Dietetic Facilities^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1606,1,0)
	;;=^^2^2^2920221^
	;;^UTILITY(U,$J,"OPT",1606,1,1,0)
	;;=This is a menu which allows the manager to build basic files
	;;^UTILITY(U,$J,"OPT",1606,1,2,0)
	;;=relating to the facilities available in the Dietetic Service.
	;;^UTILITY(U,$J,"OPT",1606,10,0)
	;;=^19.01PI^8^8
	;;^UTILITY(U,$J,"OPT",1606,10,1,0)
	;;=1601^CE
	;;^UTILITY(U,$J,"OPT",1606,10,1,"^")
	;;=FHPRO9
	;;^UTILITY(U,$J,"OPT",1606,10,2,0)
	;;=1599^FE
	;;^UTILITY(U,$J,"OPT",1606,10,2,"^")
	;;=FHPRO7
	;;^UTILITY(U,$J,"OPT",1606,10,3,0)
	;;=1604^NE
	;;^UTILITY(U,$J,"OPT",1606,10,3,"^")
	;;=FHPRO11
	;;^UTILITY(U,$J,"OPT",1606,10,4,0)
	;;=1600^SE
	;;^UTILITY(U,$J,"OPT",1606,10,4,"^")
	;;=FHPRO8
	;;^UTILITY(U,$J,"OPT",1606,10,5,0)
	;;=1602^SL
	;;^UTILITY(U,$J,"OPT",1606,10,5,"^")
	;;=FHPRO10
	;;^UTILITY(U,$J,"OPT",1606,10,6,0)
	;;=1458^WE
	;;^UTILITY(U,$J,"OPT",1606,10,6,"^")
	;;=FHPRO2
	;;^UTILITY(U,$J,"OPT",1606,10,7,0)
	;;=1552^WL
	;;^UTILITY(U,$J,"OPT",1606,10,7,"^")
	;;=FHPRO6
	;;^UTILITY(U,$J,"OPT",1606,10,8,0)
	;;=1409^SP
	;;^UTILITY(U,$J,"OPT",1606,10,8,"^")
	;;=FHSITE
	;;^UTILITY(U,$J,"OPT",1606,99)
	;;=56496,40780
	;;^UTILITY(U,$J,"OPT",1606,"U")
	;;=DIETETIC FACILITIES
	;;^UTILITY(U,$J,"OPT",1607,0)
	;;=FHASNR2^Nutrition Status Matrix^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1607,1,0)
	;;=^^3^3^2930415^
	;;^UTILITY(U,$J,"OPT",1607,1,1,0)
	;;=This option allows user to print in matrix form the changes of
	;;^UTILITY(U,$J,"OPT",1607,1,2,0)
	;;=inpatients' Nutrition Statuses from admission to XX number
	;;^UTILITY(U,$J,"OPT",1607,1,3,0)
	;;=of days or a selected start date to end date.
	;;^UTILITY(U,$J,"OPT",1607,25)
	;;=FHASN3
	;;^UTILITY(U,$J,"OPT",1607,"U")
	;;=NUTRITION STATUS MATRIX
	;;^UTILITY(U,$J,"OPT",1608,0)
	;;=FHCMRR1^Enter/Edit Cost of Meals Served^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1608,1,0)
	;;=^^1^1^2920227^^^^
	;;^UTILITY(U,$J,"OPT",1608,1,1,0)
	;;=This option allows user to enter or edit Cost of Meals Served.
	;;^UTILITY(U,$J,"OPT",1608,25)
	;;=EN1^FHCMSR
	;;^UTILITY(U,$J,"OPT",1608,"U")
	;;=ENTER/EDIT COST OF MEALS SERVE
	;;^UTILITY(U,$J,"OPT",1609,0)
	;;=FHCMRR2^Cost of Meals Served Report^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1609,1,0)
	;;=^^2^2^2921014^^^
	;;^UTILITY(U,$J,"OPT",1609,1,1,0)
	;;=This option allows the user to print the Cost of Meals Served Report
	;;^UTILITY(U,$J,"OPT",1609,1,2,0)
	;;=from a selected Month/Year to a selected Month/Year.
	;;^UTILITY(U,$J,"OPT",1609,25)
	;;=EN2^FHCMSR
	;;^UTILITY(U,$J,"OPT",1609,"U")
	;;=COST OF MEALS SERVED REPORT
	;;^UTILITY(U,$J,"OPT",1610,0)
	;;=FHPRC12^Print Weekly Menu Blocks^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1610,1,0)
	;;=^^5^5^2940104^^^^

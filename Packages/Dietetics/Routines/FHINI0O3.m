FHINI0O3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1610,1,1,0)
	;;=This option allows the user to print a seven days menu containing
	;;^UTILITY(U,$J,"OPT",1610,1,2,0)
	;;=the individual recipes under a selected Recipe Category for one
	;;^UTILITY(U,$J,"OPT",1610,1,3,0)
	;;=Production Diet or all to be served at breakfast, noon, and evening
	;;^UTILITY(U,$J,"OPT",1610,1,4,0)
	;;=for each of the seven days.  The meals from which the recipes are
	;;^UTILITY(U,$J,"OPT",1610,1,5,0)
	;;=taken, are those that are or will be effective during the week chosen.
	;;^UTILITY(U,$J,"OPT",1610,25)
	;;=FHPRC9
	;;^UTILITY(U,$J,"OPT",1610,"U")
	;;=PRINT WEEKLY MENU BLOCKS
	;;^UTILITY(U,$J,"OPT",1611,0)
	;;=FHADR1^Enter/Edit Facility Profile^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1611,1,0)
	;;=^^3^3^2930406^^^^
	;;^UTILITY(U,$J,"OPT",1611,1,1,0)
	;;=This option allows the user to enter or edit the facility Profile 
	;;^UTILITY(U,$J,"OPT",1611,1,2,0)
	;;=along with the Special Medical Programs, Primary Delivery System,
	;;^UTILITY(U,$J,"OPT",1611,1,3,0)
	;;=and Cook Chill.
	;;^UTILITY(U,$J,"OPT",1611,25)
	;;=EN1^FHADR1
	;;^UTILITY(U,$J,"OPT",1611,"U")
	;;=ENTER/EDIT FACILITY PROFILE
	;;^UTILITY(U,$J,"OPT",1612,0)
	;;=FHADR2^Enter/Edit Type of Service^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1612,1,0)
	;;=^^3^3^2920306^^^^
	;;^UTILITY(U,$J,"OPT",1612,1,1,0)
	;;=This option allows the user to enter or edit the number of Proposed
	;;^UTILITY(U,$J,"OPT",1612,1,2,0)
	;;=Patients' Meals currently served at Bedside, in a Cafeteria, and
	;;^UTILITY(U,$J,"OPT",1612,1,3,0)
	;;=at Dining Room.
	;;^UTILITY(U,$J,"OPT",1612,25)
	;;=FHADR2
	;;^UTILITY(U,$J,"OPT",1612,99)
	;;=55545,47198
	;;^UTILITY(U,$J,"OPT",1612,"U")
	;;=ENTER/EDIT TYPE OF SERVICE
	;;^UTILITY(U,$J,"OPT",1613,0)
	;;=FHADR3^Enter/Edit Hospital Outpatient Visits^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1613,1,0)
	;;=^^3^3^2930126^^^^
	;;^UTILITY(U,$J,"OPT",1613,1,1,0)
	;;=This option allows the user to enter or edit the number of
	;;^UTILITY(U,$J,"OPT",1613,1,2,0)
	;;=Outpatient visits to the Hospital and the Satellite Clinic
	;;^UTILITY(U,$J,"OPT",1613,1,3,0)
	;;=locations and the number of Outpatients that visit them.
	;;^UTILITY(U,$J,"OPT",1613,25)
	;;=EN1^FHADR3
	;;^UTILITY(U,$J,"OPT",1613,"U")
	;;=ENTER/EDIT HOSPITAL OUTPATIENT
	;;^UTILITY(U,$J,"OPT",1614,0)
	;;=FHADR4^Enter/Edit Staffing FTEE^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1614,1,0)
	;;=^^3^3^2920227^^^
	;;^UTILITY(U,$J,"OPT",1614,1,1,0)
	;;=This option allows the user to enter or edit the Staffing FTEE
	;;^UTILITY(U,$J,"OPT",1614,1,2,0)
	;;=of Clinical, Administrative, Support Staff, Supervisory, and
	;;^UTILITY(U,$J,"OPT",1614,1,3,0)
	;;=Measured.
	;;^UTILITY(U,$J,"OPT",1614,25)
	;;=EN1^FHADR7
	;;^UTILITY(U,$J,"OPT",1614,"U")
	;;=ENTER/EDIT STAFFING FTEE
	;;^UTILITY(U,$J,"OPT",1615,0)
	;;=FHADR5^Enter the Snapshot date for Modified Diets^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1615,1,0)
	;;=^^3^3^2920316^^^^
	;;^UTILITY(U,$J,"OPT",1615,1,1,0)
	;;=This option allows the user to enter a Sunday as the
	;;^UTILITY(U,$J,"OPT",1615,1,2,0)
	;;=Snapshot date to tabulate the Average number of patients that have
	;;^UTILITY(U,$J,"OPT",1615,1,3,0)
	;;=Modified Diet for the week Prior from that Sunday of each quarter.
	;;^UTILITY(U,$J,"OPT",1615,25)
	;;=EN1^FHADR6
	;;^UTILITY(U,$J,"OPT",1615,"U")
	;;=ENTER THE SNAPSHOT DATE FOR MO
	;;^UTILITY(U,$J,"OPT",1616,0)
	;;=FHADR6^Enter/Edit Cost Per Diem^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1616,1,0)
	;;=^^5^5^2920316^^^^
	;;^UTILITY(U,$J,"OPT",1616,1,1,0)
	;;=This option allows the user to enter or edit the Cost Per Diem
	;;^UTILITY(U,$J,"OPT",1616,1,2,0)
	;;=per Patient. The Cost include Total Personal Service Cost of
	;;^UTILITY(U,$J,"OPT",1616,1,3,0)
	;;=Technicians, Dietitians, Wageboard, and Clerical, Subsistence,
	;;^UTILITY(U,$J,"OPT",1616,1,4,0)
	;;=and Operating Supplies. In addition, the cumulative Fiscal
	;;^UTILITY(U,$J,"OPT",1616,1,5,0)
	;;=Year totals presented on the 830 Report will need to be entered.
	;;^UTILITY(U,$J,"OPT",1616,25)
	;;=EN1^FHADR8
	;;^UTILITY(U,$J,"OPT",1616,"U")
	;;=ENTER/EDIT COST PER DIEM
	;;^UTILITY(U,$J,"OPT",1617,0)
	;;=FHADR7^Enter/Edit Dietetic Satisfaction Survey^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1617,1,0)
	;;=^^3^3^2931230^^^^
	;;^UTILITY(U,$J,"OPT",1617,1,1,0)
	;;=This option allows the user to enter or edit the service
	;;^UTILITY(U,$J,"OPT",1617,1,2,0)
	;;=Satisfaction data which result from the Dietetic
	;;^UTILITY(U,$J,"OPT",1617,1,3,0)
	;;=Survey taken by the facility.
	;;^UTILITY(U,$J,"OPT",1617,25)
	;;=EN1^FHADR9

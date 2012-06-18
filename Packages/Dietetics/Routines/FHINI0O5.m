FHINI0O5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1625,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1625,25)
	;;=ALL^FHORT5
	;;^UTILITY(U,$J,"OPT",1625,"U")
	;;=PREPARATION/DELIVERY OF TUBEFE
	;;^UTILITY(U,$J,"OPT",1626,0)
	;;=FHORTF5L^Print Tubefeeding Labels^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1626,1,0)
	;;=^^1^1^2930415^
	;;^UTILITY(U,$J,"OPT",1626,1,1,0)
	;;=This option allows user to print the Tubefeeding labels.
	;;^UTILITY(U,$J,"OPT",1626,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1626,25)
	;;=LAB^FHORT5
	;;^UTILITY(U,$J,"OPT",1626,"U")
	;;=PRINT TUBEFEEDING LABELS
	;;^UTILITY(U,$J,"OPT",1627,0)
	;;=FHORTF5C^Print Tubefeeding Cost Report^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1627,1,0)
	;;=^^1^1^2930415^^^^
	;;^UTILITY(U,$J,"OPT",1627,1,1,0)
	;;=This option allow user to print the Tubefeeding Cost Report.
	;;^UTILITY(U,$J,"OPT",1627,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1627,25)
	;;=COST^FHORT5
	;;^UTILITY(U,$J,"OPT",1627,"U")
	;;=PRINT TUBEFEEDING COST REPORT
	;;^UTILITY(U,$J,"OPT",1628,0)
	;;=FHSP7^Consolidate Standing Orders^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1628,1,0)
	;;=^^2^2^2950719^^^^
	;;^UTILITY(U,$J,"OPT",1628,1,1,0)
	;;=This option allows user to tally by Service Point and
	;;^UTILITY(U,$J,"OPT",1628,1,2,0)
	;;=consolidate by meal or day.
	;;^UTILITY(U,$J,"OPT",1628,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1628,25)
	;;=E1^FHSP1
	;;^UTILITY(U,$J,"OPT",1628,"U")
	;;=CONSOLIDATE STANDING ORDERS
	;;^UTILITY(U,$J,"OPT",1629,0)
	;;=FHSP8^Print Standing Order Labels^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1629,1,0)
	;;=^^1^1^2920512^^^^
	;;^UTILITY(U,$J,"OPT",1629,1,1,0)
	;;=This option allows the user to print labels for standing orders.
	;;^UTILITY(U,$J,"OPT",1629,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1629,25)
	;;=E2^FHSP1
	;;^UTILITY(U,$J,"OPT",1629,"U")
	;;=PRINT STANDING ORDER LABELS
	;;^UTILITY(U,$J,"OPT",1630,0)
	;;=FHORTF5P^Tubefeeding Preparation^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1630,1,0)
	;;=^^2^2^2930415^
	;;^UTILITY(U,$J,"OPT",1630,1,1,0)
	;;=This option will print only the Tubefeeding Preparation Report
	;;^UTILITY(U,$J,"OPT",1630,1,2,0)
	;;=for use on the Wards.
	;;^UTILITY(U,$J,"OPT",1630,25)
	;;=PREP^FHORT5
	;;^UTILITY(U,$J,"OPT",1630,"U")
	;;=TUBEFEEDING PREPARATION
	;;^UTILITY(U,$J,"OPT",1631,0)
	;;=FHASNR3^Print Pat's Nutrition Status History^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1631,1,0)
	;;=^^4^4^2930630^^^^
	;;^UTILITY(U,$J,"OPT",1631,1,1,0)
	;;=This option will print the Nutrition Status History for an
	;;^UTILITY(U,$J,"OPT",1631,1,2,0)
	;;=inpatient or outpatient. The user can select a starting
	;;^UTILITY(U,$J,"OPT",1631,1,3,0)
	;;=and an ending date or take the default of FIRST,
	;;^UTILITY(U,$J,"OPT",1631,1,4,0)
	;;=the first date on file, to LAST, the last date on file.
	;;^UTILITY(U,$J,"OPT",1631,25)
	;;=FHASN5
	;;^UTILITY(U,$J,"OPT",1631,"U")
	;;=PRINT PAT'S NUTRITION STATUS H
	;;^UTILITY(U,$J,"OPT",1632,0)
	;;=FHASNR4^List Inpats By Nutrition Status Level^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1632,1,0)
	;;=^^2^2^2930630^^^^
	;;^UTILITY(U,$J,"OPT",1632,1,1,0)
	;;=This option will List all inpatients at the Nutrition Status
	;;^UTILITY(U,$J,"OPT",1632,1,2,0)
	;;=Level selected by the user.
	;;^UTILITY(U,$J,"OPT",1632,25)
	;;=FHASN6
	;;^UTILITY(U,$J,"OPT",1632,"U")
	;;=LIST INPATS BY NUTRITION STATU
	;;^UTILITY(U,$J,"OPT",1633,0)
	;;=FHORD15^Diet Census Percentage^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1633,1,0)
	;;=^^2^2^2950719^^
	;;^UTILITY(U,$J,"OPT",1633,1,1,0)
	;;=This option allows user to display the Actual Diet Census Percentage
	;;^UTILITY(U,$J,"OPT",1633,1,2,0)
	;;=or the Forecasted or Actual Diet Census Percentage of meal.
	;;^UTILITY(U,$J,"OPT",1633,25)
	;;=FHORD92
	;;^UTILITY(U,$J,"OPT",1633,"U")
	;;=DIET CENSUS PERCENTAGE
	;;^UTILITY(U,$J,"OPT",1634,0)
	;;=FHASNR5^Nutrition Status Average^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1634,1,0)
	;;=^^3^3^2930415^
	;;^UTILITY(U,$J,"OPT",1634,1,1,0)
	;;=This option displays the Averages of the Nutrition Statuses for ward(s)
	;;^UTILITY(U,$J,"OPT",1634,1,2,0)
	;;=or clinician(s) from a selected start date to end date.  This report
	;;^UTILITY(U,$J,"OPT",1634,1,3,0)
	;;=is very time consuming; therefore, it must be queued to print.
	;;^UTILITY(U,$J,"OPT",1634,25)
	;;=FHASN7
	;;^UTILITY(U,$J,"OPT",1634,"U")
	;;=NUTRITION STATUS AVERAGE
	;;^UTILITY(U,$J,"OPT",1635,0)
	;;=FHORX2^List Patient Events^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1635,1,0)
	;;=^^2^2^2930702^^
	;;^UTILITY(U,$J,"OPT",1635,1,1,0)
	;;=This option will list all patient dietetic events for a
	;;^UTILITY(U,$J,"OPT",1635,1,2,0)
	;;=specified period of time.
	;;^UTILITY(U,$J,"OPT",1635,25)
	;;=FHORX2

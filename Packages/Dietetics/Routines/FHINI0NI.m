FHINI0NI	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1457,0)
	;;=FHNO8^Enter/Edit Bulk Ward Feedings^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1457,1,0)
	;;=^^2^2^2941019^^^^
	;;^UTILITY(U,$J,"OPT",1457,1,1,0)
	;;=This option allows for adding/editing bulk feeding items to be
	;;^UTILITY(U,$J,"OPT",1457,1,2,0)
	;;=delivered to each ward.
	;;^UTILITY(U,$J,"OPT",1457,25)
	;;=FHNO4
	;;^UTILITY(U,$J,"OPT",1457,"U")
	;;=ENTER/EDIT BULK WARD FEEDINGS
	;;^UTILITY(U,$J,"OPT",1458,0)
	;;=FHPRO2^Enter/Edit Dietetic Wards^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1458,1,0)
	;;=^^3^3^2940413^^^^
	;;^UTILITY(U,$J,"OPT",1458,1,1,0)
	;;=This option allows for creating/editing of wards in the
	;;^UTILITY(U,$J,"OPT",1458,1,2,0)
	;;=Dietetics Ward file (119.6). Wards are selected from those
	;;^UTILITY(U,$J,"OPT",1458,1,3,0)
	;;=defined by the MAS ADT system.
	;;^UTILITY(U,$J,"OPT",1458,25)
	;;=EN2^FHPRO
	;;^UTILITY(U,$J,"OPT",1458,"U")
	;;=ENTER/EDIT DIETETIC WARDS
	;;^UTILITY(U,$J,"OPT",1459,0)
	;;=FHORD7^List Diets^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1459,1,0)
	;;=^^2^2^2880714^
	;;^UTILITY(U,$J,"OPT",1459,1,1,0)
	;;=This option will list all diets contained in the Diets file (111)
	;;^UTILITY(U,$J,"OPT",1459,1,2,0)
	;;=along with all associated data elements.
	;;^UTILITY(U,$J,"OPT",1459,25)
	;;=EN2^FHORD
	;;^UTILITY(U,$J,"OPT",1459,"U")
	;;=LIST DIETS
	;;^UTILITY(U,$J,"OPT",1460,0)
	;;=FHORC5^Enter/Edit Ward Assignments^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1460,1,0)
	;;=^^3^3^2880716^^
	;;^UTILITY(U,$J,"OPT",1460,1,1,0)
	;;=This option allows for the assignment of clinicians to each
	;;^UTILITY(U,$J,"OPT",1460,1,2,0)
	;;=ward. This assignment will be used to assign consults arising
	;;^UTILITY(U,$J,"OPT",1460,1,3,0)
	;;=from that ward to the indicated clinician.
	;;^UTILITY(U,$J,"OPT",1460,25)
	;;=EN9^FHORC5
	;;^UTILITY(U,$J,"OPT",1460,99)
	;;=55481,41901
	;;^UTILITY(U,$J,"OPT",1460,"U")
	;;=ENTER/EDIT WARD ASSIGNMENTS
	;;^UTILITY(U,$J,"OPT",1461,0)
	;;=FHORD9^Patient Profile^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1461,1,0)
	;;=^^5^5^2950929^^^^
	;;^UTILITY(U,$J,"OPT",1461,1,1,0)
	;;=This option will produce a comprehensive display of most
	;;^UTILITY(U,$J,"OPT",1461,1,2,0)
	;;=dietetic orders and data associated with a patient's
	;;^UTILITY(U,$J,"OPT",1461,1,3,0)
	;;=admission. It includes diet orders, active or saved consults,
	;;^UTILITY(U,$J,"OPT",1461,1,4,0)
	;;=early/late tray requests for the next 72 hours, standing
	;;^UTILITY(U,$J,"OPT",1461,1,5,0)
	;;=orders, tubefeedings, supplemental feedings, etc.
	;;^UTILITY(U,$J,"OPT",1461,25)
	;;=FHORD6
	;;^UTILITY(U,$J,"OPT",1461,"U")
	;;=PATIENT PROFILE
	;;^UTILITY(U,$J,"OPT",1462,0)
	;;=FHNO9^Review Bulk Ward Feedings^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1462,1,0)
	;;=^^2^2^2880717^^
	;;^UTILITY(U,$J,"OPT",1462,1,1,0)
	;;=This option will display the bulk ward supplemental feeding
	;;^UTILITY(U,$J,"OPT",1462,1,2,0)
	;;=items currently ordered for any selected ward.
	;;^UTILITY(U,$J,"OPT",1462,25)
	;;=EN2^FHNO4
	;;^UTILITY(U,$J,"OPT",1462,"U")
	;;=REVIEW BULK WARD FEEDINGS
	;;^UTILITY(U,$J,"OPT",1463,0)
	;;=FHNO10^Print Bulk Feedings/Cost Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1463,1,0)
	;;=^^4^4^2911212^^^
	;;^UTILITY(U,$J,"OPT",1463,1,1,0)
	;;=This option will produce a delivery listing or labels
	;;^UTILITY(U,$J,"OPT",1463,1,2,0)
	;;=for all bulk supplemental feedings for all wards served by a
	;;^UTILITY(U,$J,"OPT",1463,1,3,0)
	;;=Supplemental Feeding Site. A cost report and consolidated pick
	;;^UTILITY(U,$J,"OPT",1463,1,4,0)
	;;=list will also be produced.
	;;^UTILITY(U,$J,"OPT",1463,25)
	;;=FHNO41
	;;^UTILITY(U,$J,"OPT",1463,"U")
	;;=PRINT BULK FEEDINGS/COST REPOR
	;;^UTILITY(U,$J,"OPT",1464,0)
	;;=FHORI1^Enter/Edit Isolation/Precaution Types^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1464,1,0)
	;;=^^2^2^2880717^
	;;^UTILITY(U,$J,"OPT",1464,1,1,0)
	;;=This option allows for the creation/editing of entries in the
	;;^UTILITY(U,$J,"OPT",1464,1,2,0)
	;;=Isolation/Precaution Type file (119.4).
	;;^UTILITY(U,$J,"OPT",1464,25)
	;;=EN1^FHORD4
	;;^UTILITY(U,$J,"OPT",1464,"U")
	;;=ENTER/EDIT ISOLATION/PRECAUTIO
	;;^UTILITY(U,$J,"OPT",1465,0)
	;;=FHORI2^List Isolation/Precaution Types^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1465,1,0)
	;;=^^3^3^2880717^
	;;^UTILITY(U,$J,"OPT",1465,1,1,0)
	;;=This option will list all of the current entries in the
	;;^UTILITY(U,$J,"OPT",1465,1,2,0)
	;;=Isolation/Precaution Type file (119.4) along with the
	;;^UTILITY(U,$J,"OPT",1465,1,3,0)
	;;=associated data elements.
	;;^UTILITY(U,$J,"OPT",1465,25)
	;;=EN2^FHORD4
	;;^UTILITY(U,$J,"OPT",1465,"U")
	;;=LIST ISOLATION/PRECAUTION TYPE
	;;^UTILITY(U,$J,"OPT",1466,0)
	;;=FHORCX^Consult Management^^M^^^^^^^^

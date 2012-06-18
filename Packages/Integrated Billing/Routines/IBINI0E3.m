IBINI0E3	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4180,25)
	;;=IBDF17
	;;^UTILITY(U,$J,"OPT",4180,"U")
	;;=COPY CPT CHECK-OFF SHEET TO EN
	;;^UTILITY(U,$J,"OPT",4181,0)
	;;=IBDF EDIT ENCOUNTER FORMS^Edit Encounter Forms^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4181,1,0)
	;;=^^2^2^2931001^^^
	;;^UTILITY(U,$J,"OPT",4181,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4181,1,2,0)
	;;=Contains the options that involve editing encounter forms.
	;;^UTILITY(U,$J,"OPT",4181,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",4181,10,1,0)
	;;=4094^ED^1
	;;^UTILITY(U,$J,"OPT",4181,10,1,"^")
	;;=IBDF CLINIC SETUP/EDIT FORMS
	;;^UTILITY(U,$J,"OPT",4181,10,2,0)
	;;=4180^CC^2
	;;^UTILITY(U,$J,"OPT",4181,10,2,"^")
	;;=IBDF COPY CPTS TO FORM
	;;^UTILITY(U,$J,"OPT",4181,10,3,0)
	;;=3383^CPT^3
	;;^UTILITY(U,$J,"OPT",4181,10,3,"^")
	;;=IB OUTPUT MOST COMMON OPT CPT
	;;^UTILITY(U,$J,"OPT",4181,99)
	;;=55852,53992
	;;^UTILITY(U,$J,"OPT",4181,"U")
	;;=EDIT ENCOUNTER FORMS
	;;^UTILITY(U,$J,"OPT",4182,0)
	;;=IBT USER MENU (BI)^Claims Tracking Menu for Billing^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4182,1,0)
	;;=^^6^6^2931027^
	;;^UTILITY(U,$J,"OPT",4182,1,1,0)
	;;=This menu contains the options in Claims tracking designed specifically
	;;^UTILITY(U,$J,"OPT",4182,1,2,0)
	;;=for billing clerks and billing supervisors who do not need to have any
	;;^UTILITY(U,$J,"OPT",4182,1,3,0)
	;;=Utilization Review Input.  Options include the ability to flag  care as
	;;^UTILITY(U,$J,"OPT",4182,1,4,0)
	;;=not billable, UR reports on billing case, and a claims tracking update
	;;^UTILITY(U,$J,"OPT",4182,1,5,0)
	;;=option.
	;;^UTILITY(U,$J,"OPT",4182,1,6,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4182,10,0)
	;;=^19.01IP^3^3
	;;^UTILITY(U,$J,"OPT",4182,10,1,0)
	;;=4183^RN
	;;^UTILITY(U,$J,"OPT",4182,10,1,"^")
	;;=IBT EDIT REASON NOT BILLABLE
	;;^UTILITY(U,$J,"OPT",4182,10,2,0)
	;;=4184^CT
	;;^UTILITY(U,$J,"OPT",4182,10,2,"^")
	;;=IBT EDIT BI TRACKING ENTRY
	;;^UTILITY(U,$J,"OPT",4182,10,3,0)
	;;=4185^PS
	;;^UTILITY(U,$J,"OPT",4182,10,3,"^")
	;;=IBT OUTPUT BILLING SHEET
	;;^UTILITY(U,$J,"OPT",4182,99)
	;;=55917,43997
	;;^UTILITY(U,$J,"OPT",4182,"U")
	;;=CLAIMS TRACKING MENU FOR BILLI
	;;^UTILITY(U,$J,"OPT",4183,0)
	;;=IBT EDIT REASON NOT BILLABLE^Assign Reason Not Billable^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4183,1,0)
	;;=^^3^3^2931027^^
	;;^UTILITY(U,$J,"OPT",4183,1,1,0)
	;;=This option allows entry of a reason not billable.  Entry of a reason 
	;;^UTILITY(U,$J,"OPT",4183,1,2,0)
	;;=will automatically be printed on the Patients with Insurance Reports
	;;^UTILITY(U,$J,"OPT",4183,1,3,0)
	;;=and will cause the annotated care not to be automatically billed.
	;;^UTILITY(U,$J,"OPT",4183,25)
	;;=IBTRED2
	;;^UTILITY(U,$J,"OPT",4183,"U")
	;;=ASSIGN REASON NOT BILLABLE
	;;^UTILITY(U,$J,"OPT",4184,0)
	;;=IBT EDIT BI TRACKING ENTRY^Claims Tracking Edit^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4184,1,0)
	;;=^^2^2^2931027^
	;;^UTILITY(U,$J,"OPT",4184,1,1,0)
	;;=This option allows entry and display of claims tracking information
	;;^UTILITY(U,$J,"OPT",4184,1,2,0)
	;;=that is needed to perform billing functions.
	;;^UTILITY(U,$J,"OPT",4184,20)
	;;=S IBTRPRF=3 D ^IBTRE K IBTRPRF
	;;^UTILITY(U,$J,"OPT",4184,"U")
	;;=CLAIMS TRACKING EDIT
	;;^UTILITY(U,$J,"OPT",4185,0)
	;;=IBT OUTPUT BILLING SHEET^Print CT Summary for Billing^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4185,1,0)
	;;=^^8^8^2940307^^^^
	;;^UTILITY(U,$J,"OPT",4185,1,1,0)
	;;=This option allows printing of information from Claims Tracking about
	;;^UTILITY(U,$J,"OPT",4185,1,2,0)
	;;=a specific visit.  Included on the report is Visit Information, Insurance

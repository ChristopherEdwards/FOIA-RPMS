IBINI0E2	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4170,1,3,0)
	;;=which bills should be selected, as well as the number of carriers to
	;;^UTILITY(U,$J,"OPT",4170,1,4,0)
	;;=be ranked.
	;;^UTILITY(U,$J,"OPT",4170,1,5,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4170,1,6,0)
	;;=This output must be transmitted to the MCCR Program Office after the
	;;^UTILITY(U,$J,"OPT",4170,1,7,0)
	;;=beginning of the fiscal year.  The selected date range should be the
	;;^UTILITY(U,$J,"OPT",4170,1,8,0)
	;;=entire fiscal year (i.e., 10/1/92 through 9/30/93) and 30 carriers
	;;^UTILITY(U,$J,"OPT",4170,1,9,0)
	;;=should be ranked.  You should first run the report without transmitting
	;;^UTILITY(U,$J,"OPT",4170,1,10,0)
	;;=in order to first review the results.  When the report is being run
	;;^UTILITY(U,$J,"OPT",4170,1,11,0)
	;;=in the Production account, the user will always have the opportunity
	;;^UTILITY(U,$J,"OPT",4170,1,12,0)
	;;=to transmit the report centrally.  The central mailgroup is
	;;^UTILITY(U,$J,"OPT",4170,1,13,0)
	;;=G.MCCR DATA@DOMAIN.NAME, which is stored as a parameter in field
	;;^UTILITY(U,$J,"OPT",4170,1,14,0)
	;;=#4.05 in the IB SITE PARAMETERS (#350.9) file.
	;;^UTILITY(U,$J,"OPT",4170,25)
	;;=IBCORC
	;;^UTILITY(U,$J,"OPT",4170,"U")
	;;=RANK INSURANCE CARRIERS BY AMO
	;;^UTILITY(U,$J,"OPT",4171,0)
	;;=IB CLEAN AUTO BILLER LIST^Delete Auto Biller Results^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",4171,1,0)
	;;=^^1^1^2930908^
	;;^UTILITY(U,$J,"OPT",4171,1,1,0)
	;;=Deletes all entries from the auto biller results list before a certain date.
	;;^UTILITY(U,$J,"OPT",4171,25)
	;;=DELDT^IBCDE
	;;^UTILITY(U,$J,"OPT",4171,"U")
	;;=DELETE AUTO BILLER RESULTS
	;;^UTILITY(U,$J,"OPT",4178,0)
	;;=IBDF EDIT TOOL KIT^Edit Tool Kit^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4178,1,0)
	;;=^^3^3^2930924^^
	;;^UTILITY(U,$J,"OPT",4178,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4178,1,2,0)
	;;=Menu containing the options that allow the user to edit forms and blocks
	;;^UTILITY(U,$J,"OPT",4178,1,3,0)
	;;=contained in the tool kit.
	;;^UTILITY(U,$J,"OPT",4178,10,0)
	;;=^19.01PI^2^2
	;;^UTILITY(U,$J,"OPT",4178,10,1,0)
	;;=4108^EF
	;;^UTILITY(U,$J,"OPT",4178,10,1,"^")
	;;=IBDF EDIT TOOL KIT FORMS
	;;^UTILITY(U,$J,"OPT",4178,10,2,0)
	;;=4109^EB
	;;^UTILITY(U,$J,"OPT",4178,10,2,"^")
	;;=IBDF EDIT TOOL KIT BLOCKS
	;;^UTILITY(U,$J,"OPT",4178,99)
	;;=55852,53996
	;;^UTILITY(U,$J,"OPT",4178,"U")
	;;=EDIT TOOL KIT
	;;^UTILITY(U,$J,"OPT",4179,0)
	;;=IBDF PRINT OPTIONS^Print Options^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4179,1,0)
	;;=^^2^2^2930924^
	;;^UTILITY(U,$J,"OPT",4179,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4179,1,2,0)
	;;=Contains the options for printing encounter forms.
	;;^UTILITY(U,$J,"OPT",4179,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",4179,10,1,0)
	;;=4095^PF^1
	;;^UTILITY(U,$J,"OPT",4179,10,1,"^")
	;;=IBDF PRINT ENCOUNTER FORMS
	;;^UTILITY(U,$J,"OPT",4179,10,2,0)
	;;=4098^PD^2
	;;^UTILITY(U,$J,"OPT",4179,10,2,"^")
	;;=IBDF PRNT FORM W/DATA NO APPT.
	;;^UTILITY(U,$J,"OPT",4179,10,3,0)
	;;=4096^PB^3
	;;^UTILITY(U,$J,"OPT",4179,10,3,"^")
	;;=IBDF PRINT BLNK ENCOUNTER FORM
	;;^UTILITY(U,$J,"OPT",4179,99)
	;;=55852,54008
	;;^UTILITY(U,$J,"OPT",4179,"U")
	;;=PRINT OPTIONS
	;;^UTILITY(U,$J,"OPT",4180,0)
	;;=IBDF COPY CPTS TO FORM^Copy CPT Check-off Sheet to Encounter Form^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4180,1,0)
	;;=^^3^3^2930930^
	;;^UTILITY(U,$J,"OPT",4180,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4180,1,2,0)
	;;=Allows the user to select a CPT Check-off Sheet and Encounter Form. The
	;;^UTILITY(U,$J,"OPT",4180,1,3,0)
	;;=Check-off Sheet's CPT codes are then copied to the Encounter Form.

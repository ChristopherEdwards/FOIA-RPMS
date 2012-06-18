IBINI0DU	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4130,"U")
	;;=LIST SPECIAL INPATIENT BILLING
	;;^UTILITY(U,$J,"OPT",4132,0)
	;;=IB MT ON HOLD MENU^On Hold Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4132,1,0)
	;;=^^4^4^2930826^^^^
	;;^UTILITY(U,$J,"OPT",4132,1,1,0)
	;;=This menu is used to group all options which are used to manage
	;;^UTILITY(U,$J,"OPT",4132,1,2,0)
	;;=Integrated Billing actions which are placed on hold because the
	;;^UTILITY(U,$J,"OPT",4132,1,3,0)
	;;=patient has insurance coverage or because the outpatient copay
	;;^UTILITY(U,$J,"OPT",4132,1,4,0)
	;;=rate is over one year old.
	;;^UTILITY(U,$J,"OPT",4132,10,0)
	;;=^19.01IP^5^5
	;;^UTILITY(U,$J,"OPT",4132,10,1,0)
	;;=4127^LIST
	;;^UTILITY(U,$J,"OPT",4132,10,1,"^")
	;;=IB MT LIST HELD (RATE) CHARGES
	;;^UTILITY(U,$J,"OPT",4132,10,2,0)
	;;=4128^WAIT
	;;^UTILITY(U,$J,"OPT",4132,10,2,"^")
	;;=IB MT REL HELD (RATE) CHARGES
	;;^UTILITY(U,$J,"OPT",4132,10,3,0)
	;;=3436^HOLD
	;;^UTILITY(U,$J,"OPT",4132,10,3,"^")
	;;=IB MT RELEASE CHARGES
	;;^UTILITY(U,$J,"OPT",4132,10,4,0)
	;;=3437^HELD
	;;^UTILITY(U,$J,"OPT",4132,10,4,"^")
	;;=IB OUTPUT HELD CHARGES
	;;^UTILITY(U,$J,"OPT",4132,10,5,0)
	;;=3546^PASS
	;;^UTILITY(U,$J,"OPT",4132,10,5,"^")
	;;=IB MT PASS CONV CHARGES
	;;^UTILITY(U,$J,"OPT",4132,99)
	;;=55880,85934
	;;^UTILITY(U,$J,"OPT",4132,"U")
	;;=ON HOLD MENU
	;;^UTILITY(U,$J,"OPT",4133,0)
	;;=IB MT FLAG OPT PARAMS^Flag Stop Codes/Dispositions/Clinics^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4133,1,0)
	;;=^^4^4^2930831^^
	;;^UTILITY(U,$J,"OPT",4133,1,1,0)
	;;=This option is used to flag stop codes, dispositions, and clinics
	;;^UTILITY(U,$J,"OPT",4133,1,2,0)
	;;=which the site has determined to be exempt from the Means Test
	;;^UTILITY(U,$J,"OPT",4133,1,3,0)
	;;=outpatient copayment charge.  These parameters are all flagged
	;;^UTILITY(U,$J,"OPT",4133,1,4,0)
	;;=by date and may be inactivated and re-activated.
	;;^UTILITY(U,$J,"OPT",4133,25)
	;;=EN^IBEMTF
	;;^UTILITY(U,$J,"OPT",4133,"U")
	;;=FLAG STOP CODES/DISPOSITIONS/C
	;;^UTILITY(U,$J,"OPT",4134,0)
	;;=IB MT LIST FLAGGED PARAMS^List Flagged Stop Codes/Dispositions/Clinics^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4134,1,0)
	;;=^^2^2^2930831^
	;;^UTILITY(U,$J,"OPT",4134,1,1,0)
	;;=This output is used to generate a list of all stop codes, dispositions,
	;;^UTILITY(U,$J,"OPT",4134,1,2,0)
	;;=and clinics which are inactive as of a user-specified date.
	;;^UTILITY(U,$J,"OPT",4134,25)
	;;=EN^IBEMTF2
	;;^UTILITY(U,$J,"OPT",4134,"U")
	;;=LIST FLAGGED STOP CODES/DISPOS
	;;^UTILITY(U,$J,"OPT",4135,0)
	;;=IBT USER COMBINED MCCR/UR MENU^Claims Tracking Menu (Combined Functions)^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4135,1,0)
	;;=^^8^8^2940207^^^^
	;;^UTILITY(U,$J,"OPT",4135,1,1,0)
	;;=This is the main menu for MCCR/UR persons who do both Hospital UR
	;;^UTILITY(U,$J,"OPT",4135,1,2,0)
	;;=and MCCR UR (Insurance UR).  It contains all the options necessary
	;;^UTILITY(U,$J,"OPT",4135,1,3,0)
	;;=to do both hospital and Insurance Reviews.
	;;^UTILITY(U,$J,"OPT",4135,1,4,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4135,1,5,0)
	;;=From this menu the claims tracking module can be edited, UR Reviews can
	;;^UTILITY(U,$J,"OPT",4135,1,6,0)
	;;=be entered, Insurance Reviews can be entered an reports printed.  
	;;^UTILITY(U,$J,"OPT",4135,1,7,0)
	;;=Supervisory functions will be available to those who hold the 
	;;^UTILITY(U,$J,"OPT",4135,1,8,0)
	;;=supervisory keys.
	;;^UTILITY(U,$J,"OPT",4135,10,0)
	;;=^19.01PI^13^9
	;;^UTILITY(U,$J,"OPT",4135,10,1,0)
	;;=4136^SP^30
	;;^UTILITY(U,$J,"OPT",4135,10,1,"^")
	;;=IBT OUTPUT ONE ADMISSION SHEET

IBINI0DT	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4120,"U")
	;;=EDIT MARKING AREA (FOR SELECTI
	;;^UTILITY(U,$J,"OPT",4124,0)
	;;=IBDF IMPORT/EXPORT UTILITY^Import/Export Utility^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4124,1,0)
	;;=^^1^1^2930819^
	;;^UTILITY(U,$J,"OPT",4124,1,1,0)
	;;=Allows forms and blocks to be transferred between sites.
	;;^UTILITY(U,$J,"OPT",4124,20)
	;;=D ^IBDE
	;;^UTILITY(U,$J,"OPT",4124,"U")
	;;=IMPORT/EXPORT UTILITY
	;;^UTILITY(U,$J,"OPT",4126,0)
	;;=IB OUTPUT EMPLOYER REPORT^Employer Report^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",4126,1,0)
	;;=^^2^2^2940207^^^
	;;^UTILITY(U,$J,"OPT",4126,1,1,0)
	;;=For patients without active insurance, this report will list the patients
	;;^UTILITY(U,$J,"OPT",4126,1,2,0)
	;;=and/or the spouses employer.
	;;^UTILITY(U,$J,"OPT",4126,25)
	;;=IBOEMP
	;;^UTILITY(U,$J,"OPT",4126,"U")
	;;=EMPLOYER REPORT
	;;^UTILITY(U,$J,"OPT",4127,0)
	;;=IB MT LIST HELD (RATE) CHARGES^List Charges Awaiting New Copay Rate^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4127,1,0)
	;;=^^3^3^2930823^
	;;^UTILITY(U,$J,"OPT",4127,1,1,0)
	;;=This option is used to generate a list of all Means Test outpatient
	;;^UTILITY(U,$J,"OPT",4127,1,2,0)
	;;=copayment charges which have been placed on hold in Integrated
	;;^UTILITY(U,$J,"OPT",4127,1,3,0)
	;;=Billing because the outpatient copay rate is over one year old.
	;;^UTILITY(U,$J,"OPT",4127,25)
	;;=EN^IBEMTO1
	;;^UTILITY(U,$J,"OPT",4127,"U")
	;;=LIST CHARGES AWAITING NEW COPA
	;;^UTILITY(U,$J,"OPT",4128,0)
	;;=IB MT REL HELD (RATE) CHARGES^Release Charges Awaiting New Copay Rate^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4128,1,0)
	;;=^^7^7^2930823^
	;;^UTILITY(U,$J,"OPT",4128,1,1,0)
	;;=This option is used to release charges which have been placed on hold
	;;^UTILITY(U,$J,"OPT",4128,1,2,0)
	;;=in Integrated Billing because the outpatient copay rate is over one
	;;^UTILITY(U,$J,"OPT",4128,1,3,0)
	;;=year old.  If the new (less than one year old) rate has been entered
	;;^UTILITY(U,$J,"OPT",4128,1,4,0)
	;;=into the Billing table, the option will prompt the user to task off
	;;^UTILITY(U,$J,"OPT",4128,1,5,0)
	;;=a job which will automatically update the dollar amount and bill
	;;^UTILITY(U,$J,"OPT",4128,1,6,0)
	;;=all such charges.  The user will receive a bulletin when the tasked
	;;^UTILITY(U,$J,"OPT",4128,1,7,0)
	;;=job has completed.
	;;^UTILITY(U,$J,"OPT",4128,25)
	;;=ENO^IBEMTO
	;;^UTILITY(U,$J,"OPT",4128,"U")
	;;=RELEASE CHARGES AWAITING NEW C
	;;^UTILITY(U,$J,"OPT",4129,0)
	;;=IB MT DISP SPECIAL CASES^Disposition Special Inpatient Billing Cases^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4129,1,0)
	;;=^^2^2^2930823^
	;;^UTILITY(U,$J,"OPT",4129,1,1,0)
	;;=This option is used to enter the reason for not billing special inpatient
	;;^UTILITY(U,$J,"OPT",4129,1,2,0)
	;;=billing cases.
	;;^UTILITY(U,$J,"OPT",4129,25)
	;;=DISP^IBAMTI1
	;;^UTILITY(U,$J,"OPT",4129,"U")
	;;=DISPOSITION SPECIAL INPATIENT 
	;;^UTILITY(U,$J,"OPT",4130,0)
	;;=IB MT LIST SPECIAL CASES^List Special Inpatient Billing Cases^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4130,1,0)
	;;=^^4^4^2930823^
	;;^UTILITY(U,$J,"OPT",4130,1,1,0)
	;;=This option is used to list all special inpatient billing cases.  After
	;;^UTILITY(U,$J,"OPT",4130,1,2,0)
	;;=a case has been dispositioned, the output will include either the reason
	;;^UTILITY(U,$J,"OPT",4130,1,3,0)
	;;=for non-billing, or all of the charges which have been billed for the
	;;^UTILITY(U,$J,"OPT",4130,1,4,0)
	;;=admission.
	;;^UTILITY(U,$J,"OPT",4130,25)
	;;=LIST^IBAMTI2

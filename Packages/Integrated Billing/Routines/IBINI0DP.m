IBINI0DP	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3947,1,3,0)
	;;=this report will print a list of charges canceled during the installation/
	;;^UTILITY(U,$J,"OPT",3947,1,4,0)
	;;=conversion process.  The software may cancel other charges after
	;;^UTILITY(U,$J,"OPT",3947,1,5,0)
	;;=installation and this report can be used to list those charges.
	;;^UTILITY(U,$J,"OPT",3947,25)
	;;=IBARXEC1
	;;^UTILITY(U,$J,"OPT",3947,"U")
	;;=PRINT CHARGES CANCELED DUE TO 
	;;^UTILITY(U,$J,"OPT",3948,0)
	;;=IB RX PRINT VERIFY EXEMP^Print/Verify Patient Exemption Status^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3948,1,0)
	;;=^^10^10^2940207^^^^
	;;^UTILITY(U,$J,"OPT",3948,1,1,0)
	;;=This option can be used to search through the BILLING EXEMPTIONS file
	;;^UTILITY(U,$J,"OPT",3948,1,2,0)
	;;=and compare the currently stored active exemption for each patient
	;;^UTILITY(U,$J,"OPT",3948,1,3,0)
	;;=against what it calculates to be the correct exemption status for
	;;^UTILITY(U,$J,"OPT",3948,1,4,0)
	;;=the patient based on current data in the MAS files.  This report can
	;;^UTILITY(U,$J,"OPT",3948,1,5,0)
	;;=be run to just print a list of discrepancies or it can be run 
	;;^UTILITY(U,$J,"OPT",3948,1,6,0)
	;;=to automatically update each incorrect exemption status.
	;;^UTILITY(U,$J,"OPT",3948,1,7,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3948,1,8,0)
	;;=Initially the report should be run without updating the exemptions.  The
	;;^UTILITY(U,$J,"OPT",3948,1,9,0)
	;;=option Manually Change Copay Exemptions (Hardship) can be used to update
	;;^UTILITY(U,$J,"OPT",3948,1,10,0)
	;;=exemptions to the correct status one patient at a time if desired.
	;;^UTILITY(U,$J,"OPT",3948,25)
	;;=IBARXEPV
	;;^UTILITY(U,$J,"OPT",3948,"U")
	;;=PRINT/VERIFY PATIENT EXEMPTION
	;;^UTILITY(U,$J,"OPT",4082,0)
	;;=IB RX EDIT LETTER^Edit Copay Exemption Letter^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4082,1,0)
	;;=^^12^12^2930429^
	;;^UTILITY(U,$J,"OPT",4082,1,1,0)
	;;=This option will allow editing of the header, or station name and address,
	;;^UTILITY(U,$J,"OPT",4082,1,2,0)
	;;=and the main body of a letter.  The letter IB NOW EXEMPT is the letter
	;;^UTILITY(U,$J,"OPT",4082,1,3,0)
	;;=that was written to be sent to patients who become exempt during the
	;;^UTILITY(U,$J,"OPT",4082,1,4,0)
	;;=conversion to inform them that they no longer need to send in a 
	;;^UTILITY(U,$J,"OPT",4082,1,5,0)
	;;=copayment with their Rx refill requests.
	;;^UTILITY(U,$J,"OPT",4082,1,6,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",4082,1,7,0)
	;;=The first six lines of the header field will be centered at the top
	;;^UTILITY(U,$J,"OPT",4082,1,8,0)
	;;=of each letter.  Do not center these lines.  The patient address will
	;;^UTILITY(U,$J,"OPT",4082,1,9,0)
	;;=print beginning on line 17.  The main body will print after the patient
	;;^UTILITY(U,$J,"OPT",4082,1,10,0)
	;;=address section.  Do not include functions in either word processing
	;;^UTILITY(U,$J,"OPT",4082,1,11,0)
	;;=field as VA FileMan utilities are not used at this time to output
	;;^UTILITY(U,$J,"OPT",4082,1,12,0)
	;;=the letters.
	;;^UTILITY(U,$J,"OPT",4082,25)
	;;=IBARXEPE
	;;^UTILITY(U,$J,"OPT",4082,"U")
	;;=EDIT COPAY EXEMPTION LETTER
	;;^UTILITY(U,$J,"OPT",4083,0)
	;;=IB RX PRINT EX LETERS^Letters to Exempt Patients^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4083,1,0)
	;;=^^9^9^2930429^
	;;^UTILITY(U,$J,"OPT",4083,1,1,0)
	;;=This option will print the form letter IB NOW EXEMPT for all currently
	;;^UTILITY(U,$J,"OPT",4083,1,2,0)
	;;=exempt patients.  The following patients will not be included:

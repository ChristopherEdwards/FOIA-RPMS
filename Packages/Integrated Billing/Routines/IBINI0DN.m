IBINI0DN	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3547,1,3,0)
	;;=activity.
	;;^UTILITY(U,$J,"OPT",3547,30)
	;;=IBE(353,
	;;^UTILITY(U,$J,"OPT",3547,31)
	;;=AEMQL
	;;^UTILITY(U,$J,"OPT",3547,50)
	;;=IBE(353,
	;;^UTILITY(U,$J,"OPT",3547,51)
	;;=[IB DEVICE]
	;;^UTILITY(U,$J,"OPT",3547,"U")
	;;=SELECT DEFAULT DEVICE FOR FORM
	;;^UTILITY(U,$J,"OPT",3548,0)
	;;=IB HCFA-1500 TEST PATTERN^HCFA-1500 Test Pattern Print^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3548,1,0)
	;;=^^2^2^2930728^^^^
	;;^UTILITY(U,$J,"OPT",3548,1,1,0)
	;;=This option prints a test pattern on the HCFA-1500 form so that
	;;^UTILITY(U,$J,"OPT",3548,1,2,0)
	;;=the form alignment in the printer may be checked.
	;;^UTILITY(U,$J,"OPT",3548,25)
	;;=IBCF2TP
	;;^UTILITY(U,$J,"OPT",3548,"U")
	;;=HCFA-1500 TEST PATTERN PRINT
	;;^UTILITY(U,$J,"OPT",3582,0)
	;;=IB OUTPUT MENU^Output IB Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3582,1,0)
	;;=^^1^1^2940310^^^
	;;^UTILITY(U,$J,"OPT",3582,1,1,0)
	;;=This menu contains Inquiry and report options for Integrated Billing
	;;^UTILITY(U,$J,"OPT",3582,10,0)
	;;=^19.01IP^3^3
	;;^UTILITY(U,$J,"OPT",3582,10,1,0)
	;;=2516^FULL
	;;^UTILITY(U,$J,"OPT",3582,10,1,"^")
	;;=IB OUTPUT FULL INQ BY BILL NO
	;;^UTILITY(U,$J,"OPT",3582,10,2,0)
	;;=2514
	;;^UTILITY(U,$J,"OPT",3582,10,2,"^")
	;;=IB OUTPUT LIST ACTIONS
	;;^UTILITY(U,$J,"OPT",3582,10,3,0)
	;;=2513^^
	;;^UTILITY(U,$J,"OPT",3582,10,3,"^")
	;;=IB OUTPUT STATISTICAL REPORT
	;;^UTILITY(U,$J,"OPT",3582,99)
	;;=55951,34646
	;;^UTILITY(U,$J,"OPT",3582,"U")
	;;=OUTPUT IB MENU
	;;^UTILITY(U,$J,"OPT",3583,0)
	;;=IB BASC INACTIVE CODES^Delete/List Inactive Codes on Check-off Sheets^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3583,1,0)
	;;=^^2^2^2920730^^^^
	;;^UTILITY(U,$J,"OPT",3583,1,1,0)
	;;=Reports and deletes CPT procedure codes on Check-off Sheets that are
	;;^UTILITY(U,$J,"OPT",3583,1,2,0)
	;;=AMA inactive or Nationally, Locally, and Billing inactive.
	;;^UTILITY(U,$J,"OPT",3583,25)
	;;=IBERSI
	;;^UTILITY(U,$J,"OPT",3583,"U")
	;;=DELETE/LIST INACTIVE CODES ON 
	;;^UTILITY(U,$J,"OPT",3941,0)
	;;=IB RX EXEMPTION MENU^Medication Copay Income Exemption Menu^^M^^^^^^^^INCOME EXEMPTION PATCH
	;;^UTILITY(U,$J,"OPT",3941,1,0)
	;;=^^2^2^2930122^^
	;;^UTILITY(U,$J,"OPT",3941,1,1,0)
	;;=This is the primary menu in IB for the options to manage and print
	;;^UTILITY(U,$J,"OPT",3941,1,2,0)
	;;=reports on the Medication Copayment Income Exclusion functionality.
	;;^UTILITY(U,$J,"OPT",3941,10,0)
	;;=^19.01PI^10^9
	;;^UTILITY(U,$J,"OPT",3941,10,1,0)
	;;=3942^HARD
	;;^UTILITY(U,$J,"OPT",3941,10,1,"^")
	;;=IB RX HARDSHIP
	;;^UTILITY(U,$J,"OPT",3941,10,2,0)
	;;=3943^EXEM
	;;^UTILITY(U,$J,"OPT",3941,10,2,"^")
	;;=IB RX INQUIRE
	;;^UTILITY(U,$J,"OPT",3941,10,3,0)
	;;=3944^THRE
	;;^UTILITY(U,$J,"OPT",3941,10,3,"^")
	;;=IB RX ADD THRESHOLDS
	;;^UTILITY(U,$J,"OPT",3941,10,4,0)
	;;=3945^LIST
	;;^UTILITY(U,$J,"OPT",3941,10,4,"^")
	;;=IB RX PRINT THRESHOLDS
	;;^UTILITY(U,$J,"OPT",3941,10,6,0)
	;;=3946^PATI
	;;^UTILITY(U,$J,"OPT",3941,10,6,"^")
	;;=IB RX PRINT PAT. EXEMP.
	;;^UTILITY(U,$J,"OPT",3941,10,7,0)
	;;=3947^CHAR
	;;^UTILITY(U,$J,"OPT",3941,10,7,"^")
	;;=IB RX PRINT RETRO CHARGES
	;;^UTILITY(U,$J,"OPT",3941,10,8,0)
	;;=3948^VERI
	;;^UTILITY(U,$J,"OPT",3941,10,8,"^")
	;;=IB RX PRINT VERIFY EXEMP
	;;^UTILITY(U,$J,"OPT",3941,10,9,0)
	;;=4082^COLE
	;;^UTILITY(U,$J,"OPT",3941,10,9,"^")
	;;=IB RX EDIT LETTER
	;;^UTILITY(U,$J,"OPT",3941,10,10,0)
	;;=4083^LEPR
	;;^UTILITY(U,$J,"OPT",3941,10,10,"^")
	;;=IB RX PRINT EX LETERS
	;;^UTILITY(U,$J,"OPT",3941,99)
	;;=55733,49423
	;;^UTILITY(U,$J,"OPT",3941,99.1)
	;;=55609,31556

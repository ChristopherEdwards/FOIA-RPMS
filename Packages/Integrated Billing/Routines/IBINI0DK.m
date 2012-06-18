IBINI0DK	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3385,1,2,0)
	;;=that have unknown or expired insurance.
	;;^UTILITY(U,$J,"OPT",3385,25)
	;;=IBOUNP1
	;;^UTILITY(U,$J,"OPT",3385,"U")
	;;=OUTPATIENTS W/UNKNOWN OR EXPIR
	;;^UTILITY(U,$J,"OPT",3396,0)
	;;=IB PURGE MENU^Purge Menu^^M^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3396,1,0)
	;;=^^1^1^2920519^^^^
	;;^UTILITY(U,$J,"OPT",3396,1,1,0)
	;;=This menu contains all the Integrated billing purge options
	;;^UTILITY(U,$J,"OPT",3396,10,0)
	;;=^19.01IP^9^8
	;;^UTILITY(U,$J,"OPT",3396,10,2,0)
	;;=3355^BASC
	;;^UTILITY(U,$J,"OPT",3396,10,2,"^")
	;;=IB PURGE/BASC TRANSFER CLEANUP
	;;^UTILITY(U,$J,"OPT",3396,10,3,0)
	;;=3434
	;;^UTILITY(U,$J,"OPT",3396,10,3,"^")
	;;=IB PURGE/ARCHIVE BILLING DATA
	;;^UTILITY(U,$J,"OPT",3396,10,4,0)
	;;=3435
	;;^UTILITY(U,$J,"OPT",3396,10,4,"^")
	;;=IB PURGE BILLING DATA
	;;^UTILITY(U,$J,"OPT",3396,10,5,0)
	;;=3433
	;;^UTILITY(U,$J,"OPT",3396,10,5,"^")
	;;=IB PURGE/FIND BILLING DATA
	;;^UTILITY(U,$J,"OPT",3396,10,6,0)
	;;=3542
	;;^UTILITY(U,$J,"OPT",3396,10,6,"^")
	;;=IB PURGE LIST LOG ENTRIES
	;;^UTILITY(U,$J,"OPT",3396,10,7,0)
	;;=3543
	;;^UTILITY(U,$J,"OPT",3396,10,7,"^")
	;;=IB PURGE LOG INQUIRY
	;;^UTILITY(U,$J,"OPT",3396,10,8,0)
	;;=3544
	;;^UTILITY(U,$J,"OPT",3396,10,8,"^")
	;;=IB PURGE LIST TEMPLATE ENTRIES
	;;^UTILITY(U,$J,"OPT",3396,10,9,0)
	;;=3545
	;;^UTILITY(U,$J,"OPT",3396,10,9,"^")
	;;=IB PURGE DELETE TEMPLATE ENTRY
	;;^UTILITY(U,$J,"OPT",3396,99)
	;;=55269,54167
	;;^UTILITY(U,$J,"OPT",3396,"U")
	;;=PURGE MENU
	;;^UTILITY(U,$J,"OPT",3402,0)
	;;=IB OUTPUT UNBILLED BASC^Unbilled BASC for Insured Patient Appointments^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3402,1,0)
	;;=^^4^4^2920312^^
	;;^UTILITY(U,$J,"OPT",3402,1,1,0)
	;;=This report lists all BASC procedures for scheduled appointments of
	;;^UTILITY(U,$J,"OPT",3402,1,2,0)
	;;=insured patients that could not be matched with BASC procedures entered
	;;^UTILITY(U,$J,"OPT",3402,1,3,0)
	;;=on a bill for the patient.  The match is based on the appointment date
	;;^UTILITY(U,$J,"OPT",3402,1,4,0)
	;;=in scheduling and the procedure date in billing.
	;;^UTILITY(U,$J,"OPT",3402,25)
	;;=IBOBCC
	;;^UTILITY(U,$J,"OPT",3402,99)
	;;=55650,38160
	;;^UTILITY(U,$J,"OPT",3402,"U")
	;;=UNBILLED BASC FOR INSURED PATI
	;;^UTILITY(U,$J,"OPT",3433,0)
	;;=IB PURGE/FIND BILLING DATA^Find Billing Data to Archive^^R^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3433,1,0)
	;;=^^9^9^2920519^^
	;;^UTILITY(U,$J,"OPT",3433,1,1,0)
	;;=This option may be used to identify records to be archived and purged
	;;^UTILITY(U,$J,"OPT",3433,1,2,0)
	;;=from the following files:
	;;^UTILITY(U,$J,"OPT",3433,1,3,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3433,1,4,0)
	;;=  #350  INTEGRATED BILLING ACTION
	;;^UTILITY(U,$J,"OPT",3433,1,5,0)
	;;=  #351  CATEGORY C BILLING CLOCK
	;;^UTILITY(U,$J,"OPT",3433,1,6,0)
	;;=  #399  BILL/CLAIMS
	;;^UTILITY(U,$J,"OPT",3433,1,7,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3433,1,8,0)
	;;=Entries which are selected to be archived and then purged are placed
	;;^UTILITY(U,$J,"OPT",3433,1,9,0)
	;;=into a Search (Sort) template.
	;;^UTILITY(U,$J,"OPT",3433,25)
	;;=FIND^IBP
	;;^UTILITY(U,$J,"OPT",3433,"U")
	;;=FIND BILLING DATA TO ARCHIVE
	;;^UTILITY(U,$J,"OPT",3434,0)
	;;=IB PURGE/ARCHIVE BILLING DATA^Archive Billing Data^^R^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3434,1,0)
	;;=^^8^8^2920519^^^^
	;;^UTILITY(U,$J,"OPT",3434,1,1,0)
	;;=This option may be used to archive data from the following files:
	;;^UTILITY(U,$J,"OPT",3434,1,2,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3434,1,3,0)
	;;=  #350  INTEGRATED BILLING ACTION

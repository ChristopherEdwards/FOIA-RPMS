IBINI0DM	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",3537,"U")
	;;=OUTPATIENT/REGISTRATION EVENTS
	;;^UTILITY(U,$J,"OPT",3542,0)
	;;=IB PURGE LIST LOG ENTRIES^List Archive/Purge Log Entries^^R^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3542,1,0)
	;;=^^3^3^2920519^^^
	;;^UTILITY(U,$J,"OPT",3542,1,1,0)
	;;=This option may be used to list all of the log entries in the
	;;^UTILITY(U,$J,"OPT",3542,1,2,0)
	;;=IB ARCHIVE/PURGE LOG file, #350.6.  All entries in the file are
	;;^UTILITY(U,$J,"OPT",3542,1,3,0)
	;;=listed, in the order that they were added to the file.
	;;^UTILITY(U,$J,"OPT",3542,25)
	;;=LST^IBPO
	;;^UTILITY(U,$J,"OPT",3542,"U")
	;;=LIST ARCHIVE/PURGE LOG ENTRIES
	;;^UTILITY(U,$J,"OPT",3543,0)
	;;=IB PURGE LOG INQUIRY^Archive/Purge Log Inquiry^^R^^XUMGR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3543,1,0)
	;;=^^2^2^2920519^^^
	;;^UTILITY(U,$J,"OPT",3543,1,1,0)
	;;=This option may be used to provide a full inquiry of any entry in the
	;;^UTILITY(U,$J,"OPT",3543,1,2,0)
	;;=IB ARCHIVE/PURGE LOG, file #350.6.
	;;^UTILITY(U,$J,"OPT",3543,25)
	;;=INQ^IBPO
	;;^UTILITY(U,$J,"OPT",3543,"U")
	;;=ARCHIVE/PURGE LOG INQUIRY
	;;^UTILITY(U,$J,"OPT",3544,0)
	;;=IB PURGE LIST TEMPLATE ENTRIES^List Search Template Entries^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3544,1,0)
	;;=^^2^2^2920519^
	;;^UTILITY(U,$J,"OPT",3544,1,1,0)
	;;=This option may be used to list all entries in a Search Template which
	;;^UTILITY(U,$J,"OPT",3544,1,2,0)
	;;=are scheduled to be archived and purged.
	;;^UTILITY(U,$J,"OPT",3544,25)
	;;=TMP^IBPO
	;;^UTILITY(U,$J,"OPT",3544,"U")
	;;=LIST SEARCH TEMPLATE ENTRIES
	;;^UTILITY(U,$J,"OPT",3545,0)
	;;=IB PURGE DELETE TEMPLATE ENTRY^Delete Entry from Search Template^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3545,1,0)
	;;=^^10^10^2940207^^^
	;;^UTILITY(U,$J,"OPT",3545,1,1,0)
	;;=This option may be used to prevent a record from being purged from the
	;;^UTILITY(U,$J,"OPT",3545,1,2,0)
	;;=database.  The user will be prompted for an established Search Template
	;;^UTILITY(U,$J,"OPT",3545,1,3,0)
	;;=based on one of the following three files:
	;;^UTILITY(U,$J,"OPT",3545,1,4,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3545,1,5,0)
	;;=  350  INTEGRATED BILLING ACTION
	;;^UTILITY(U,$J,"OPT",3545,1,6,0)
	;;=  351  CATEGORY C BILLING CLOCK
	;;^UTILITY(U,$J,"OPT",3545,1,7,0)
	;;=  399  BILL/CLAIMS
	;;^UTILITY(U,$J,"OPT",3545,1,8,0)
	;;= 
	;;^UTILITY(U,$J,"OPT",3545,1,9,0)
	;;=The records stored in this template will be listed, and the user may
	;;^UTILITY(U,$J,"OPT",3545,1,10,0)
	;;=select a record to be deleted from the template.
	;;^UTILITY(U,$J,"OPT",3545,25)
	;;=IBPUDEL
	;;^UTILITY(U,$J,"OPT",3545,"U")
	;;=DELETE ENTRY FROM SEARCH TEMPL
	;;^UTILITY(U,$J,"OPT",3546,0)
	;;=IB MT PASS CONV CHARGES^Send Converted Charges to A/R^To be removed with the next version of IB^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3546,1,0)
	;;=^^2^2^2931229^^^^
	;;^UTILITY(U,$J,"OPT",3546,1,1,0)
	;;=This option sends converted charges to accounts receivable. User can 
	;;^UTILITY(U,$J,"OPT",3546,1,2,0)
	;;=use Patient name or a Cutoff date as selection criteria.
	;;^UTILITY(U,$J,"OPT",3546,25)
	;;=START^IBRCON3
	;;^UTILITY(U,$J,"OPT",3546,"U")
	;;=SEND CONVERTED CHARGES TO A/R
	;;^UTILITY(U,$J,"OPT",3547,0)
	;;=IB SITE DEVICE SETUP^Select Default Device for Forms^^E^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",3547,1,0)
	;;=^^3^3^2920722^^
	;;^UTILITY(U,$J,"OPT",3547,1,1,0)
	;;=This option allows associating devices as the default answer when printing
	;;^UTILITY(U,$J,"OPT",3547,1,2,0)
	;;=forms.  This is used to enter the default device for AR for follow-up

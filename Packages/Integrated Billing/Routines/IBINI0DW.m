IBINI0DW	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4141,0)
	;;=IBT OUTPUT MENU^Reports Menu (Claims Tracking)^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4141,1,0)
	;;=^^1^1^2940121^^^
	;;^UTILITY(U,$J,"OPT",4141,1,1,0)
	;;=This is the main reports menu for the Claims tracking module.
	;;^UTILITY(U,$J,"OPT",4141,10,0)
	;;=^19.01PI^11^11
	;;^UTILITY(U,$J,"OPT",4141,10,1,0)
	;;=4143^IC
	;;^UTILITY(U,$J,"OPT",4141,10,1,"^")
	;;=IBT OUTPUT CLAIM INQUIRY
	;;^UTILITY(U,$J,"OPT",4141,10,2,0)
	;;=4136^SP
	;;^UTILITY(U,$J,"OPT",4141,10,2,"^")
	;;=IBT OUTPUT ONE ADMISSION SHEET
	;;^UTILITY(U,$J,"OPT",4141,10,3,0)
	;;=4146^DD
	;;^UTILITY(U,$J,"OPT",4141,10,3,"^")
	;;=IBT OUTPUT DENIED DAYS REPORT
	;;^UTILITY(U,$J,"OPT",4141,10,4,0)
	;;=4147^AC
	;;^UTILITY(U,$J,"OPT",4141,10,4,"^")
	;;=IBT OUTPUT UR ACTIVITY REPORT
	;;^UTILITY(U,$J,"OPT",4141,10,5,0)
	;;=4148^SA
	;;^UTILITY(U,$J,"OPT",4141,10,5,"^")
	;;=IBT OUTPUT SCHED ADM W/INS
	;;^UTILITY(U,$J,"OPT",4141,10,6,0)
	;;=4149^UA
	;;^UTILITY(U,$J,"OPT",4141,10,6,"^")
	;;=IBT OUTPUT UNSCHE ADM W/INS
	;;^UTILITY(U,$J,"OPT",4141,10,7,0)
	;;=4150^MS
	;;^UTILITY(U,$J,"OPT",4141,10,7,"^")
	;;=IBT OUTPUT MCCR/UR SUMMARY
	;;^UTILITY(U,$J,"OPT",4141,10,8,0)
	;;=4151^TODO
	;;^UTILITY(U,$J,"OPT",4141,10,8,"^")
	;;=IBT OUTPUT PENDING ITEMS
	;;^UTILITY(U,$J,"OPT",4141,10,9,0)
	;;=4186^RW
	;;^UTILITY(U,$J,"OPT",4141,10,9,"^")
	;;=IBT OUTPUT REVIEW WORKSHEET
	;;^UTILITY(U,$J,"OPT",4141,10,10,0)
	;;=4185^BI
	;;^UTILITY(U,$J,"OPT",4141,10,10,"^")
	;;=IBT OUTPUT BILLING SHEET
	;;^UTILITY(U,$J,"OPT",4141,10,11,0)
	;;=4512^RC
	;;^UTILITY(U,$J,"OPT",4141,10,11,"^")
	;;=IBT OUTPUT LIST VISITS
	;;^UTILITY(U,$J,"OPT",4141,99)
	;;=55906,37057
	;;^UTILITY(U,$J,"OPT",4141,"U")
	;;=REPORTS MENU (CLAIMS TRACKING)
	;;^UTILITY(U,$J,"OPT",4142,0)
	;;=IBT SUPERVISORS MENU^Supervisors Menu (Claims Tracking)^^M^^IB CLAIMS SUPERVISOR^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4142,1,0)
	;;=^^3^3^2930627^
	;;^UTILITY(U,$J,"OPT",4142,1,1,0)
	;;=This option contains the supervisory options for the Claims tracking
	;;^UTILITY(U,$J,"OPT",4142,1,2,0)
	;;=module.  Site parameters may be edited.  Table files may be
	;;^UTILITY(U,$J,"OPT",4142,1,3,0)
	;;=maintained.  Background jobs may be repeated or re-queued.
	;;^UTILITY(U,$J,"OPT",4142,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",4142,10,1,0)
	;;=4144^PE
	;;^UTILITY(U,$J,"OPT",4142,10,1,"^")
	;;=IBT EDIT TRACKING PARAMETERS
	;;^UTILITY(U,$J,"OPT",4142,10,2,0)
	;;=4157^RX
	;;^UTILITY(U,$J,"OPT",4142,10,2,"^")
	;;=IBT SUP MANUALLY QUE RX FILLS
	;;^UTILITY(U,$J,"OPT",4142,10,3,0)
	;;=4158^OE
	;;^UTILITY(U,$J,"OPT",4142,10,3,"^")
	;;=IBT SUP MANUALLY QUE ENCTRS
	;;^UTILITY(U,$J,"OPT",4142,99)
	;;=55769,49846
	;;^UTILITY(U,$J,"OPT",4142,"U")
	;;=SUPERVISORS MENU (CLAIMS TRACK
	;;^UTILITY(U,$J,"OPT",4143,0)
	;;=IBT OUTPUT CLAIM INQUIRY^Inquire to Claims Tracking^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4143,1,0)
	;;=^^3^3^2940207^^^
	;;^UTILITY(U,$J,"OPT",4143,1,1,0)
	;;=This option allows viewing or printing a detailed inquiry to any claims
	;;^UTILITY(U,$J,"OPT",4143,1,2,0)
	;;=tracking entry.  This includes showing all associated reviews and
	;;^UTILITY(U,$J,"OPT",4143,1,3,0)
	;;=communications.
	;;^UTILITY(U,$J,"OPT",4143,25)
	;;=IBTOTR
	;;^UTILITY(U,$J,"OPT",4143,"U")
	;;=INQUIRE TO CLAIMS TRACKING
	;;^UTILITY(U,$J,"OPT",4144,0)
	;;=IBT EDIT TRACKING PARAMETERS^Claims Tracking Parameter Edit^^R^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",4144,1,0)
	;;=^^2^2^2940207^^
	;;^UTILITY(U,$J,"OPT",4144,1,1,0)
	;;=This option allows editing MCCR site parameters that affect the

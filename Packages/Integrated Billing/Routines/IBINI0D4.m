IBINI0D4	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"FUN",156,1)
	;;=S IBCDX=X,IBDTX=X1 D FCC^IBEFUNC1 S X=IBCHGX K IBCDX,IBDTX,IBCHGX
	;;^UTILITY(U,$J,"FUN",156,3)
	;;=2
	;;^UTILITY(U,$J,"FUN",156,9)
	;;=Returns the charge for procedure (X) on date (X1).
	;;^UTILITY(U,$J,"FUN",157,0)
	;;=IB CPT BILLING STATUS
	;;^UTILITY(U,$J,"FUN",157,1)
	;;=S IBCDX=X,IBDTX=X1 D FCBS^IBEFUNC1 S X=$P(IBSTX,"^",2) K IBCDX,IBDTX,IBSTX
	;;^UTILITY(U,$J,"FUN",157,3)
	;;=2
	;;^UTILITY(U,$J,"FUN",157,9)
	;;=Returns the billing status for procedure (X) on date (X1).
	;;^UTILITY(U,$J,"FUN",169,0)
	;;=IBNEXTAPPT
	;;^UTILITY(U,$J,"FUN",169,1)
	;;=S X=$$DAT1^IBOUTL($O(^DPT(D0,"S",DT)))
	;;^UTILITY(U,$J,"FUN",169,2)
	;;=X
	;;^UTILITY(U,$J,"FUN",169,3)
	;;=1
	;;^UTILITY(U,$J,"FUN",169,9)
	;;=Determines next appointment date from today.  Use only on files where D0 = dfn
	;;^UTILITY(U,$J,"KEY",133,0)
	;;=IB AUTHORIZE^^^n
	;;^UTILITY(U,$J,"KEY",134,0)
	;;=IB SUPERVISOR
	;;^UTILITY(U,$J,"KEY",135,0)
	;;=IB EDIT
	;;^UTILITY(U,$J,"KEY",151,0)
	;;=IB CLAIMS SUPERVISOR^SUPERVISOR FUNCTIONS FOR C.T.^^n
	;;^UTILITY(U,$J,"KEY",151,1,0)
	;;=^^3^3^2940210^^^
	;;^UTILITY(U,$J,"KEY",151,1,1,0)
	;;=This key should be allocated to individuals who may perform certain
	;;^UTILITY(U,$J,"KEY",151,1,2,0)
	;;=supervisory functions in Claims Tracking such as deleting claims tracking 
	;;^UTILITY(U,$J,"KEY",151,1,3,0)
	;;=entries and reviews.
	;;^UTILITY(U,$J,"KEY",152,0)
	;;=IB INSURANCE SUPERVISOR^INSURANCE SUPERVISOR KEY^^n
	;;^UTILITY(U,$J,"KEY",152,1,0)
	;;=^^3^3^2940107^^^^
	;;^UTILITY(U,$J,"KEY",152,1,1,0)
	;;=This key should only be given to those individuals who may perform
	;;^UTILITY(U,$J,"KEY",152,1,2,0)
	;;=supervisory insurance functions such as deleting insurance companies,
	;;^UTILITY(U,$J,"KEY",152,1,3,0)
	;;=deleting policies, and inactivating and merging insurance information.
	;;^UTILITY(U,$J,"KEY",154,0)
	;;=IBDF IRM
	;;^UTILITY(U,$J,"KEY",154,1,0)
	;;=^^3^3^2930929^
	;;^UTILITY(U,$J,"KEY",154,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"KEY",154,1,2,0)
	;;=Used to prevent access to Encounter Form Utility options that are for IRM
	;;^UTILITY(U,$J,"KEY",154,1,3,0)
	;;=staffs only.
	;;^UTILITY(U,$J,"OPT",1208,0)
	;;=IB EDIT BILLING INFO^Enter/Edit Billing Information^^R^^IB EDIT^^^^^^INTEGRATED BILLING^^^1
	;;^UTILITY(U,$J,"OPT",1208,1,0)
	;;=^^3^3^2940120^^^^
	;;^UTILITY(U,$J,"OPT",1208,1,1,0)
	;;=This option allows the user to enter the information required to
	;;^UTILITY(U,$J,"OPT",1208,1,2,0)
	;;=generate a third party bill and to edit existing billing
	;;^UTILITY(U,$J,"OPT",1208,1,3,0)
	;;=information.
	;;^UTILITY(U,$J,"OPT",1208,15)
	;;=D KILL^IBCMENU
	;;^UTILITY(U,$J,"OPT",1208,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1208,25)
	;;=EDI^IBCB
	;;^UTILITY(U,$J,"OPT",1208,"U")
	;;=ENTER/EDIT BILLING INFORMATION
	;;^UTILITY(U,$J,"OPT",1213,0)
	;;=IB AUTHORIZE BILL GENERATION^Authorize Bill Generation^^R^^IB AUTHORIZE^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"OPT",1213,1,0)
	;;=^^4^4^2880629^^^^
	;;^UTILITY(U,$J,"OPT",1213,1,1,0)
	;;=This option allows the user to perform final review of 
	;;^UTILITY(U,$J,"OPT",1213,1,2,0)
	;;=information contained in a billing record. The user is
	;;^UTILITY(U,$J,"OPT",1213,1,3,0)
	;;=then able to authorize the generation of the bill and
	;;^UTILITY(U,$J,"OPT",1213,1,4,0)
	;;=the release of the information to Fiscal.
	;;^UTILITY(U,$J,"OPT",1213,20)
	;;=
	;;^UTILITY(U,$J,"OPT",1213,25)
	;;=2^IBCMENU
	;;^UTILITY(U,$J,"OPT",1213,"U")
	;;=AUTHORIZE BILL GENERATION
	;;^UTILITY(U,$J,"OPT",1214,0)
	;;=IB PRINT BILL^Print Bill^^R^^^^^^^^INTEGRATED BILLING

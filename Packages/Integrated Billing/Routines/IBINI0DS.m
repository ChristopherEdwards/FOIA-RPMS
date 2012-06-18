IBINI0DS	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",4107,10,4,0)
	;;=4120^EM^4
	;;^UTILITY(U,$J,"OPT",4107,10,4,"^")
	;;=IBDF EDIT MARKING AREA
	;;^UTILITY(U,$J,"OPT",4107,10,5,0)
	;;=4102^DR^5
	;;^UTILITY(U,$J,"OPT",4107,10,5,"^")
	;;=IBDF DEFINE AVAILABLE REPORT
	;;^UTILITY(U,$J,"OPT",4107,10,7,0)
	;;=4124^IX^7
	;;^UTILITY(U,$J,"OPT",4107,10,7,"^")
	;;=IBDF IMPORT/EXPORT UTILITY
	;;^UTILITY(U,$J,"OPT",4107,10,8,0)
	;;=4245^MC^8
	;;^UTILITY(U,$J,"OPT",4107,10,8,"^")
	;;=IBDF MISCELLANEOUS CLEANUP
	;;^UTILITY(U,$J,"OPT",4107,99)
	;;=55915,40169
	;;^UTILITY(U,$J,"OPT",4107,"U")
	;;=ENCOUNTER FORM IRM OPTIONS
	;;^UTILITY(U,$J,"OPT",4108,0)
	;;=IBDF EDIT TOOL KIT FORMS^Edit Tool Kit Forms^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4108,1,0)
	;;=^^1^1^2930625^
	;;^UTILITY(U,$J,"OPT",4108,1,1,0)
	;;=Allows tool kit forms to be edited, created, deleted.
	;;^UTILITY(U,$J,"OPT",4108,20)
	;;=D FORMLIST^IBDF12
	;;^UTILITY(U,$J,"OPT",4108,"U")
	;;=EDIT TOOL KIT FORMS
	;;^UTILITY(U,$J,"OPT",4109,0)
	;;=IBDF EDIT TOOL KIT BLOCKS^Edit Tool Kit Blocks^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4109,1,0)
	;;=^^1^1^2930625^
	;;^UTILITY(U,$J,"OPT",4109,1,1,0)
	;;=Allows tool kit blocks to be edited, created, deleted.
	;;^UTILITY(U,$J,"OPT",4109,20)
	;;=D LIST^IBDF13
	;;^UTILITY(U,$J,"OPT",4109,"U")
	;;=EDIT TOOL KIT BLOCKS
	;;^UTILITY(U,$J,"OPT",4115,0)
	;;=IBDF REPORT CLINIC SETUPS^Report Clinic Setups^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4115,1,0)
	;;=^^2^2^2930721^
	;;^UTILITY(U,$J,"OPT",4115,1,1,0)
	;;=Reports on each clinic setup, listing the encounter forms and other reports
	;;^UTILITY(U,$J,"OPT",4115,1,2,0)
	;;=defined for use by the clinic.
	;;^UTILITY(U,$J,"OPT",4115,20)
	;;=D SETUPS^IBDF14
	;;^UTILITY(U,$J,"OPT",4115,"U")
	;;=REPORT CLINIC SETUPS
	;;^UTILITY(U,$J,"OPT",4116,0)
	;;=IBDF LIST CLINICS USING FORMS^List Clinics Using Forms^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4116,1,0)
	;;=^^1^1^2931025^^
	;;^UTILITY(U,$J,"OPT",4116,1,1,0)
	;;=For each encounter form this option lists the clinics using it.
	;;^UTILITY(U,$J,"OPT",4116,20)
	;;=D FORMUSE^IBDF15
	;;^UTILITY(U,$J,"OPT",4116,"U")
	;;=LIST CLINICS USING FORMS
	;;^UTILITY(U,$J,"OPT",4119,0)
	;;=IBDF EDIT PACKAGE INTERFACE^Edit Package Interface^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4119,1,0)
	;;=^^5^5^2930726^
	;;^UTILITY(U,$J,"OPT",4119,1,1,0)
	;;=This option only allows selection routines and output routines. It allows
	;;^UTILITY(U,$J,"OPT",4119,1,2,0)
	;;=Package Interfaces to be created, edited, and deleted. However, Package Interfaces
	;;^UTILITY(U,$J,"OPT",4119,1,3,0)
	;;=that are in use in any form should not be deleted. By creating their
	;;^UTILITY(U,$J,"OPT",4119,1,4,0)
	;;=own Package Interfaces the local sites can display data to their forms that
	;;^UTILITY(U,$J,"OPT",4119,1,5,0)
	;;=is not provided for in the tool kit.
	;;^UTILITY(U,$J,"OPT",4119,20)
	;;=D EDIT^IBDF16
	;;^UTILITY(U,$J,"OPT",4119,"U")
	;;=EDIT PACKAGE INTERFACE
	;;^UTILITY(U,$J,"OPT",4120,0)
	;;=IBDF EDIT MARKING AREA^Edit Marking Area (for selection lists)^^A^^^^^^^^INTEGRATED BILLING^^1
	;;^UTILITY(U,$J,"OPT",4120,1,0)
	;;=^^3^3^2930727^
	;;^UTILITY(U,$J,"OPT",4120,1,1,0)
	;;=Allows the local sites to create their own Marking Area to supplement those
	;;^UTILITY(U,$J,"OPT",4120,1,2,0)
	;;=that come with the tool kit. Marking Areas are the areas on a selection list
	;;^UTILITY(U,$J,"OPT",4120,1,3,0)
	;;=that are used for writting in to indicate choices.
	;;^UTILITY(U,$J,"OPT",4120,20)
	;;=D MARKING^IBDF16

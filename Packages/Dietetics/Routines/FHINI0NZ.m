FHINI0NZ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1574,1,2,0)
	;;=assessment on file.
	;;^UTILITY(U,$J,"OPT",1574,25)
	;;=FHASMR
	;;^UTILITY(U,$J,"OPT",1574,"U")
	;;=DISPLAY ASSESSMENT
	;;^UTILITY(U,$J,"OPT",1575,0)
	;;=FHASC1^Enter/Edit Nutrition Classifications^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1575,1,0)
	;;=^^2^2^2920915^^
	;;^UTILITY(U,$J,"OPT",1575,1,1,0)
	;;=This option allows creation and/or editing of entries in
	;;^UTILITY(U,$J,"OPT",1575,1,2,0)
	;;=the Nutrition Classification file (115.3).
	;;^UTILITY(U,$J,"OPT",1575,25)
	;;=EN1^FHASC
	;;^UTILITY(U,$J,"OPT",1575,"U")
	;;=ENTER/EDIT NUTRITION CLASSIFIC
	;;^UTILITY(U,$J,"OPT",1576,0)
	;;=FHASC2^List Nutrition Classifications^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1576,1,0)
	;;=^^2^2^2891106^
	;;^UTILITY(U,$J,"OPT",1576,1,1,0)
	;;=This option lists the entries in the Nutrition Classification
	;;^UTILITY(U,$J,"OPT",1576,1,2,0)
	;;=file (115.3).
	;;^UTILITY(U,$J,"OPT",1576,25)
	;;=EN2^FHASC
	;;^UTILITY(U,$J,"OPT",1576,"U")
	;;=LIST NUTRITION CLASSIFICATIONS
	;;^UTILITY(U,$J,"OPT",1578,0)
	;;=FHASC4^List Nutrition Statuses^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1578,1,0)
	;;=^^2^2^2911204^^
	;;^UTILITY(U,$J,"OPT",1578,1,1,0)
	;;=This option lists the entries in the Nutrition Status
	;;^UTILITY(U,$J,"OPT",1578,1,2,0)
	;;=file (115.4).
	;;^UTILITY(U,$J,"OPT",1578,25)
	;;=EN4^FHASN
	;;^UTILITY(U,$J,"OPT",1578,"U")
	;;=LIST NUTRITION STATUSES
	;;^UTILITY(U,$J,"OPT",1579,0)
	;;=FHASE1^Enter/Edit Encounter Types^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1579,1,0)
	;;=^^2^2^2891110^^
	;;^UTILITY(U,$J,"OPT",1579,1,1,0)
	;;=This option allows creation and/or editing of entries in the
	;;^UTILITY(U,$J,"OPT",1579,1,2,0)
	;;=Encounter Types file (115.6).
	;;^UTILITY(U,$J,"OPT",1579,25)
	;;=EN1^FHASE
	;;^UTILITY(U,$J,"OPT",1579,"U")
	;;=ENTER/EDIT ENCOUNTER TYPES
	;;^UTILITY(U,$J,"OPT",1580,0)
	;;=FHASE2^List Encounter Types^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1580,1,0)
	;;=^^2^2^2891110^^
	;;^UTILITY(U,$J,"OPT",1580,1,1,0)
	;;=This option lists the entries in the Encounter Types
	;;^UTILITY(U,$J,"OPT",1580,1,2,0)
	;;=file (115.6).
	;;^UTILITY(U,$J,"OPT",1580,25)
	;;=EN2^FHASE
	;;^UTILITY(U,$J,"OPT",1580,"U")
	;;=LIST ENCOUNTER TYPES
	;;^UTILITY(U,$J,"OPT",1581,0)
	;;=FHASC8^Enter/Edit Clinical Site Parameters^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1581,1,0)
	;;=^^2^2^2911210^^^^
	;;^UTILITY(U,$J,"OPT",1581,1,1,0)
	;;=This option allows for the entry and/or editing of site parameters
	;;^UTILITY(U,$J,"OPT",1581,1,2,0)
	;;=for the clinical dietetic functions.
	;;^UTILITY(U,$J,"OPT",1581,25)
	;;=EN3^FHSYSP
	;;^UTILITY(U,$J,"OPT",1581,"U")
	;;=ENTER/EDIT CLINICAL SITE PARAM
	;;^UTILITY(U,$J,"OPT",1582,0)
	;;=FHASE3^Enter/Edit Encounter^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1582,1,0)
	;;=^^1^1^2920915^^^^
	;;^UTILITY(U,$J,"OPT",1582,1,1,0)
	;;=This option is used to create or edit a dietetic encounter.
	;;^UTILITY(U,$J,"OPT",1582,25)
	;;=EN3^FHASE
	;;^UTILITY(U,$J,"OPT",1582,"U")
	;;=ENTER/EDIT ENCOUNTER
	;;^UTILITY(U,$J,"OPT",1583,0)
	;;=FHASCX^Clinical Management Menu^^M^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1583,1,0)
	;;=^^2^2^2930910^^^^
	;;^UTILITY(U,$J,"OPT",1583,1,1,0)
	;;=This menu allows for the management of the various files used
	;;^UTILITY(U,$J,"OPT",1583,1,2,0)
	;;=by the clinical and patient management functions of the system.
	;;^UTILITY(U,$J,"OPT",1583,10,0)
	;;=^19.01PI^18^12
	;;^UTILITY(U,$J,"OPT",1583,10,1,0)
	;;=1575^EC
	;;^UTILITY(U,$J,"OPT",1583,10,1,"^")
	;;=FHASC1
	;;^UTILITY(U,$J,"OPT",1583,10,2,0)
	;;=1576^LC
	;;^UTILITY(U,$J,"OPT",1583,10,2,"^")
	;;=FHASC2
	;;^UTILITY(U,$J,"OPT",1583,10,4,0)
	;;=1578^LS
	;;^UTILITY(U,$J,"OPT",1583,10,4,"^")
	;;=FHASC4
	;;^UTILITY(U,$J,"OPT",1583,10,5,0)
	;;=1579^ET
	;;^UTILITY(U,$J,"OPT",1583,10,5,"^")
	;;=FHASE1
	;;^UTILITY(U,$J,"OPT",1583,10,6,0)
	;;=1580^LT
	;;^UTILITY(U,$J,"OPT",1583,10,6,"^")
	;;=FHASE2
	;;^UTILITY(U,$J,"OPT",1583,10,7,0)
	;;=1581^XP
	;;^UTILITY(U,$J,"OPT",1583,10,7,"^")
	;;=FHASC8
	;;^UTILITY(U,$J,"OPT",1583,10,8,0)
	;;=1584^NM
	;;^UTILITY(U,$J,"OPT",1583,10,8,"^")
	;;=FHASCM
	;;^UTILITY(U,$J,"OPT",1583,10,9,0)
	;;=1585^EP
	;;^UTILITY(U,$J,"OPT",1583,10,9,"^")
	;;=FHASC9
	;;^UTILITY(U,$J,"OPT",1583,10,10,0)
	;;=1586^LP
	;;^UTILITY(U,$J,"OPT",1583,10,10,"^")
	;;=FHASC10
	;;^UTILITY(U,$J,"OPT",1583,10,12,0)
	;;=1590^XL
	;;^UTILITY(U,$J,"OPT",1583,10,12,"^")
	;;=FHSYP1
	;;^UTILITY(U,$J,"OPT",1583,10,13,0)
	;;=1591^XD
	;;^UTILITY(U,$J,"OPT",1583,10,13,"^")
	;;=FHSYP2
	;;^UTILITY(U,$J,"OPT",1583,10,18,0)
	;;=1709^CR
	;;^UTILITY(U,$J,"OPT",1583,10,18,"^")
	;;=FHASNRR
	;;^UTILITY(U,$J,"OPT",1583,99)
	;;=56496,40786
	;;^UTILITY(U,$J,"OPT",1583,99.1)
	;;=54375,50474
	;;^UTILITY(U,$J,"OPT",1583,"U")
	;;=CLINICAL MANAGEMENT MENU

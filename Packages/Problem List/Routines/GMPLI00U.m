GMPLI00U	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"KEY",267,0)
	;;=GMPL ICD CODE^ICD Coder
	;;^UTILITY(U,$J,"KEY",267,1,0)
	;;=^^3^3^2931126^^
	;;^UTILITY(U,$J,"KEY",267,1,1,0)
	;;=This key is used by the Problem List package to determine if the current
	;;^UTILITY(U,$J,"KEY",267,1,2,0)
	;;=user is trained and authorized to code provider text to the ICD Diagnosis
	;;^UTILITY(U,$J,"KEY",267,1,3,0)
	;;=codes.
	;;^UTILITY(U,$J,"OPT",7160,0)
	;;=GMPL CLINICAL USER^Patient Problem List^^R^^^^^^^^PROBLEM LIST^^
	;;^UTILITY(U,$J,"OPT",7160,1,0)
	;;=^^4^4^2940104^^^^
	;;^UTILITY(U,$J,"OPT",7160,1,1,0)
	;;=This option allows clinical users access to the Problem List
	;;^UTILITY(U,$J,"OPT",7160,1,2,0)
	;;=application; control is passed to the List Manager utility.
	;;^UTILITY(U,$J,"OPT",7160,1,3,0)
	;;=   
	;;^UTILITY(U,$J,"OPT",7160,1,4,0)
	;;=Management utilities will be found on the Mgt Menu.
	;;^UTILITY(U,$J,"OPT",7160,20)
	;;=
	;;^UTILITY(U,$J,"OPT",7160,25)
	;;=EN^GMPL
	;;^UTILITY(U,$J,"OPT",7160,99)
	;;=55529,51811
	;;^UTILITY(U,$J,"OPT",7160,"U")
	;;=PATIENT PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7338,0)
	;;=GMPL DATA ENTRY^Problem List Data Entry^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7338,1,0)
	;;=^^4^4^2931110^^^^
	;;^UTILITY(U,$J,"OPT",7338,1,1,0)
	;;=This option allows data entry/maintenance access to the Problem List
	;;^UTILITY(U,$J,"OPT",7338,1,2,0)
	;;=application; the List Manager utility is invoked here.
	;;^UTILITY(U,$J,"OPT",7338,1,3,0)
	;;=   
	;;^UTILITY(U,$J,"OPT",7338,1,4,0)
	;;=Management utilities will be found on the Mgt Menu.
	;;^UTILITY(U,$J,"OPT",7338,25)
	;;=DE^GMPL
	;;^UTILITY(U,$J,"OPT",7338,99)
	;;=55647,57316
	;;^UTILITY(U,$J,"OPT",7338,99.1)
	;;=55741,26413
	;;^UTILITY(U,$J,"OPT",7338,"U")
	;;=PROBLEM LIST DATA ENTRY
	;;^UTILITY(U,$J,"OPT",7339,0)
	;;=GMPL MGT MENU^Problem List Mgt Menu^^M^^^^^^^^PROBLEM LIST^^1^1
	;;^UTILITY(U,$J,"OPT",7339,1,0)
	;;=^^2^2^2930412^^^
	;;^UTILITY(U,$J,"OPT",7339,1,1,0)
	;;=This menu contains actions useful for management of the Problem
	;;^UTILITY(U,$J,"OPT",7339,1,2,0)
	;;=List application.
	;;^UTILITY(U,$J,"OPT",7339,10,0)
	;;=^19.01PI^9^6
	;;^UTILITY(U,$J,"OPT",7339,10,1,0)
	;;=7340^2^2
	;;^UTILITY(U,$J,"OPT",7339,10,1,"^")
	;;=GMPL PARAMETER EDIT
	;;^UTILITY(U,$J,"OPT",7339,10,3,0)
	;;=7160^1^1
	;;^UTILITY(U,$J,"OPT",7339,10,3,"^")
	;;=GMPL CLINICAL USER
	;;^UTILITY(U,$J,"OPT",7339,10,6,0)
	;;=7483^4^4
	;;^UTILITY(U,$J,"OPT",7339,10,6,"^")
	;;=GMPL PATIENT LISTING
	;;^UTILITY(U,$J,"OPT",7339,10,7,0)
	;;=7484^5^5
	;;^UTILITY(U,$J,"OPT",7339,10,7,"^")
	;;=GMPL PROBLEM LISTING
	;;^UTILITY(U,$J,"OPT",7339,10,8,0)
	;;=7535^3^3
	;;^UTILITY(U,$J,"OPT",7339,10,8,"^")
	;;=GMPL BUILD LIST MENU
	;;^UTILITY(U,$J,"OPT",7339,10,9,0)
	;;=7785^6^6
	;;^UTILITY(U,$J,"OPT",7339,10,9,"^")
	;;=GMPL REPLACE PROBLEMS
	;;^UTILITY(U,$J,"OPT",7339,15)
	;;=K GMPLMGR
	;;^UTILITY(U,$J,"OPT",7339,20)
	;;=S GMPLMGR=1
	;;^UTILITY(U,$J,"OPT",7339,99)
	;;=55916,45293
	;;^UTILITY(U,$J,"OPT",7339,99.1)
	;;=55741,26413
	;;^UTILITY(U,$J,"OPT",7339,"U")
	;;=PROBLEM LIST MGT MENU
	;;^UTILITY(U,$J,"OPT",7340,0)
	;;=GMPL PARAMETER EDIT^Edit PL Site Parameters^^R^^^^^^^^PROBLEM LIST^^
	;;^UTILITY(U,$J,"OPT",7340,1,0)
	;;=^^3^3^2930625^^^^
	;;^UTILITY(U,$J,"OPT",7340,1,1,0)
	;;=This option allows quick access to toggle the site parameters
	;;^UTILITY(U,$J,"OPT",7340,1,2,0)
	;;=controlling the behavior of the PL application; these are stored
	;;^UTILITY(U,$J,"OPT",7340,1,3,0)
	;;=in the PL Site Parameters file #125.99.
	;;^UTILITY(U,$J,"OPT",7340,20)
	;;=
	;;^UTILITY(U,$J,"OPT",7340,25)
	;;=PARAMS^GMPLX1
	;;^UTILITY(U,$J,"OPT",7340,30)
	;;=

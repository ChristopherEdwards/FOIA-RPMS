GMPLI00L	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(200)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(200,125.1,0)
	;;=PROBLEM SELECTION LIST^P125'^GMPL(125,^125;2^Q
	;;^DD(200,125.1,3)
	;;=Enter the list of problems you wish displayed to select from, when adding to a patient's problem list.
	;;^DD(200,125.1,21,0)
	;;=^^6^6^2931110^^
	;;^DD(200,125.1,21,1,0)
	;;=This is the user's preferred default list of problems to select from
	;;^DD(200,125.1,21,2,0)
	;;=when adding to a patient's problem list.  If there is a list specified
	;;^DD(200,125.1,21,3,0)
	;;=here from the Problem Selection List File (#125), it will be automatically
	;;^DD(200,125.1,21,4,0)
	;;=presented to the user when the "Add New Problem(s)" action is selected;
	;;^DD(200,125.1,21,5,0)
	;;=otherwise, the user will simply be prompted to select a problem from
	;;^DD(200,125.1,21,6,0)
	;;=the Clinical Lexicon Utility.
	;;^DD(200,125.1,"DT")
	;;=2931110

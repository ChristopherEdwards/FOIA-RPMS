GMPLI00X	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",7535,99)
	;;=55955,60970
	;;^UTILITY(U,$J,"OPT",7535,"U")
	;;=CREATE PROBLEM SELECTION LISTS
	;;^UTILITY(U,$J,"OPT",7537,0)
	;;=GMPL ASSIGN LIST^Assign Selection List to User(s)^^R^^^^^^^^PROBLEM LIST^^1
	;;^UTILITY(U,$J,"OPT",7537,1,0)
	;;=^^6^6^2940202^^^^
	;;^UTILITY(U,$J,"OPT",7537,1,1,0)
	;;=This option allows a selection list to be assigned to user(s) as his/her
	;;^UTILITY(U,$J,"OPT",7537,1,2,0)
	;;=preferred menu of problems to select from.  If a list is specified in
	;;^UTILITY(U,$J,"OPT",7537,1,3,0)
	;;=the Problem List Default Menu field (#125.1) of the New Person file,
	;;^UTILITY(U,$J,"OPT",7537,1,4,0)
	;;=then the Add New Problem(s) option will present this list of problems
	;;^UTILITY(U,$J,"OPT",7537,1,5,0)
	;;=to select from; searching the Clinical Lexicon Utility for a problem
	;;^UTILITY(U,$J,"OPT",7537,1,6,0)
	;;=not on this list is always an option from these menus.
	;;^UTILITY(U,$J,"OPT",7537,20)
	;;=S GMPLSLST=$$LIST^GMPLBLD2("")
	;;^UTILITY(U,$J,"OPT",7537,25)
	;;=USERS^GMPLBLD3("1")
	;;^UTILITY(U,$J,"OPT",7537,"U")
	;;=ASSIGN SELECTION LIST TO USER(
	;;^UTILITY(U,$J,"OPT",7681,0)
	;;=GMPL BUILD ENC FORM LIST^Copy Selection List from IB Encounter Form^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7681,1,0)
	;;=^^6^6^2940125^^
	;;^UTILITY(U,$J,"OPT",7681,1,1,0)
	;;=This option will allow creating a new selection list by copying a list
	;;^UTILITY(U,$J,"OPT",7681,1,2,0)
	;;=already created through the Encounter Form utility (Integrated Billing
	;;^UTILITY(U,$J,"OPT",7681,1,3,0)
	;;=package) into a new entry in file #125.  This list will then be available
	;;^UTILITY(U,$J,"OPT",7681,1,4,0)
	;;=for editing further (only the new list will be altered - the list saved
	;;^UTILITY(U,$J,"OPT",7681,1,5,0)
	;;=in the Integrated Billing pkg with the form will not be changed here),
	;;^UTILITY(U,$J,"OPT",7681,1,6,0)
	;;=or for use to select from when entering new problems to a patient's list.
	;;^UTILITY(U,$J,"OPT",7681,25)
	;;=GMPLBLDF
	;;^UTILITY(U,$J,"OPT",7681,"U")
	;;=COPY SELECTION LIST FROM IB EN
	;;^UTILITY(U,$J,"OPT",7683,0)
	;;=GMPL CODE LIST^Assign ICD Diagnoses to Problem List^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7683,1,0)
	;;=^^5^5^2940203^^^
	;;^UTILITY(U,$J,"OPT",7683,1,1,0)
	;;=This option allows access to a patient's problem list to add, review,
	;;^UTILITY(U,$J,"OPT",7683,1,2,0)
	;;=or edit the ICD Code assigned to each problem.  A detailed display of
	;;^UTILITY(U,$J,"OPT",7683,1,3,0)
	;;=problem data is available, as well as searching capability into both
	;;^UTILITY(U,$J,"OPT",7683,1,4,0)
	;;=the ICD Diagnosis file and the Clinical Lexicon Utility to facilitate
	;;^UTILITY(U,$J,"OPT",7683,1,5,0)
	;;=the coding process.
	;;^UTILITY(U,$J,"OPT",7683,25)
	;;=EN^GMPLCODE
	;;^UTILITY(U,$J,"OPT",7683,"U")
	;;=ASSIGN ICD DIAGNOSES TO PROBLE
	;;^UTILITY(U,$J,"OPT",7784,0)
	;;=GMPL DELETE LIST^Delete Problem Selection List^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7784,1,0)
	;;=^^4^4^2940126^
	;;^UTILITY(U,$J,"OPT",7784,1,1,0)
	;;=This option will allow the user to delete a problem selection list and
	;;^UTILITY(U,$J,"OPT",7784,1,2,0)
	;;=its contents that is no longer in use.  Once a list is selected, the
	;;^UTILITY(U,$J,"OPT",7784,1,3,0)
	;;=New Person file, "Problem Selection List" field, for pointers to the
	;;^UTILITY(U,$J,"OPT",7784,1,4,0)
	;;=chosen list; if any users are found, deleting the list is not permitted.
	;;^UTILITY(U,$J,"OPT",7784,25)
	;;=DELETE^GMPLBLD3
	;;^UTILITY(U,$J,"OPT",7784,"U")
	;;=DELETE PROBLEM SELECTION LIST

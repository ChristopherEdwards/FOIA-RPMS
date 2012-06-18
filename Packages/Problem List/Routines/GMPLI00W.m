GMPLI00W	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",7484,1,0)
	;;=^^4^4^2930824^
	;;^UTILITY(U,$J,"OPT",7484,1,1,0)
	;;=This option will generate a listing of all patients identified as
	;;^UTILITY(U,$J,"OPT",7484,1,2,0)
	;;=having a particular problem in the Problem file #9000011; the user
	;;^UTILITY(U,$J,"OPT",7484,1,3,0)
	;;=is first prompted for the problem, then the file is searched for
	;;^UTILITY(U,$J,"OPT",7484,1,4,0)
	;;=patients having this problem.
	;;^UTILITY(U,$J,"OPT",7484,25)
	;;=PROB^GMPLRPTS
	;;^UTILITY(U,$J,"OPT",7484,"U")
	;;=SEARCH FOR PATIENTS HAVING SEL
	;;^UTILITY(U,$J,"OPT",7522,0)
	;;=GMPL BUILD SELECTION LIST^Build Problem Selection List(s)^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7522,1,0)
	;;=^^5^5^2940202^^^^
	;;^UTILITY(U,$J,"OPT",7522,1,1,0)
	;;=This option allows access to utilities to facilitate the creation
	;;^UTILITY(U,$J,"OPT",7522,1,2,0)
	;;=and maintenance of problem menus, i.e. lists of commonly selected
	;;^UTILITY(U,$J,"OPT",7522,1,3,0)
	;;=problems.  Categories of problems may be defined, and lists created
	;;^UTILITY(U,$J,"OPT",7522,1,4,0)
	;;=from linking categories together; categories may be reused in multiple
	;;^UTILITY(U,$J,"OPT",7522,1,5,0)
	;;=lists.
	;;^UTILITY(U,$J,"OPT",7522,25)
	;;=EN^GMPLBLD
	;;^UTILITY(U,$J,"OPT",7522,"U")
	;;=BUILD PROBLEM SELECTION LIST(S
	;;^UTILITY(U,$J,"OPT",7523,0)
	;;=GMPL USER LIST^Preferred Problem Selection List^^A^^^^^^^^PROBLEM LIST^^1
	;;^UTILITY(U,$J,"OPT",7523,1,0)
	;;=^^6^6^2931001^
	;;^UTILITY(U,$J,"OPT",7523,1,1,0)
	;;=This option allows an individual user to define his/her own default
	;;^UTILITY(U,$J,"OPT",7523,1,2,0)
	;;=list of commonly selected problems; this list will be displayed when
	;;^UTILITY(U,$J,"OPT",7523,1,3,0)
	;;=the action 'Add New Problem(s)' is invoked, and the user may either
	;;^UTILITY(U,$J,"OPT",7523,1,4,0)
	;;=choose to add a problem from the menu (selected by display number)
	;;^UTILITY(U,$J,"OPT",7523,1,5,0)
	;;=or search the Clinical Lexicon for a problem not listed.  The same
	;;^UTILITY(U,$J,"OPT",7523,1,6,0)
	;;=prompts will asked per problem to complete the entry.
	;;^UTILITY(U,$J,"OPT",7523,20)
	;;=S DIE="^VA(200,",DR=125.1,DA=DUZ D ^DIE
	;;^UTILITY(U,$J,"OPT",7523,"U")
	;;=PREFERRED PROBLEM SELECTION LI
	;;^UTILITY(U,$J,"OPT",7535,0)
	;;=GMPL BUILD LIST MENU^Create Problem Selection Lists^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7535,1,0)
	;;=^^5^5^2931007^^
	;;^UTILITY(U,$J,"OPT",7535,1,1,0)
	;;=This menu contains options that facilitate building and maintaining
	;;^UTILITY(U,$J,"OPT",7535,1,2,0)
	;;=lists of commonly selected problems.  Problem groups are defined, and
	;;^UTILITY(U,$J,"OPT",7535,1,3,0)
	;;=these groups are then linked together to form a list; a group may be
	;;^UTILITY(U,$J,"OPT",7535,1,4,0)
	;;=reused, as a member of multiple lists, and it may be assigned a sequence
	;;^UTILITY(U,$J,"OPT",7535,1,5,0)
	;;=number and header for ordering and clarity within the list.
	;;^UTILITY(U,$J,"OPT",7535,10,0)
	;;=^19.01PI^6^5
	;;^UTILITY(U,$J,"OPT",7535,10,1,0)
	;;=7522^1^1
	;;^UTILITY(U,$J,"OPT",7535,10,1,"^")
	;;=GMPL BUILD SELECTION LIST
	;;^UTILITY(U,$J,"OPT",7535,10,3,0)
	;;=7537^3^3
	;;^UTILITY(U,$J,"OPT",7535,10,3,"^")
	;;=GMPL ASSIGN LIST
	;;^UTILITY(U,$J,"OPT",7535,10,4,0)
	;;=7681^2^2
	;;^UTILITY(U,$J,"OPT",7535,10,4,"^")
	;;=GMPL BUILD ENC FORM LIST
	;;^UTILITY(U,$J,"OPT",7535,10,5,0)
	;;=7784^5^5
	;;^UTILITY(U,$J,"OPT",7535,10,5,"^")
	;;=GMPL DELETE LIST
	;;^UTILITY(U,$J,"OPT",7535,10,6,0)
	;;=8021^4^4
	;;^UTILITY(U,$J,"OPT",7535,10,6,"^")
	;;=GMPL DE-ASSIGN LIST

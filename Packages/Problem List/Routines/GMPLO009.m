GMPLO009	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2531,1,5,0)
	;;=problem(s) or change which problems appear on the displayed view of the
	;;^UTILITY(U,$J,"PRO",2531,1,6,0)
	;;=list.  A new patient's list may be selected or a printout of the list
	;;^UTILITY(U,$J,"PRO",2531,1,7,0)
	;;=generated.
	;;^UTILITY(U,$J,"PRO",2531,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",2531,10,0)
	;;=^101.01PA^11^12
	;;^UTILITY(U,$J,"PRO",2531,10,1,0)
	;;=2350^SP^23^^^
	;;^UTILITY(U,$J,"PRO",2531,10,1,"^")
	;;=GMPL PATIENT
	;;^UTILITY(U,$J,"PRO",2531,10,2,0)
	;;=2345^AD^1
	;;^UTILITY(U,$J,"PRO",2531,10,2,"^")
	;;=GMPL NEW PROBLEM
	;;^UTILITY(U,$J,"PRO",2531,10,3,0)
	;;=2347^CM^13^^^
	;;^UTILITY(U,$J,"PRO",2531,10,3,1)
	;;=^^^
	;;^UTILITY(U,$J,"PRO",2531,10,3,"^")
	;;=GMPL ANNOTATE
	;;^UTILITY(U,$J,"PRO",2531,10,4,0)
	;;=2356^IN^11
	;;^UTILITY(U,$J,"PRO",2531,10,4,"^")
	;;=GMPL INACTIVATE
	;;^UTILITY(U,$J,"PRO",2531,10,5,0)
	;;=2348^DT^15
	;;^UTILITY(U,$J,"PRO",2531,10,5,"^")
	;;=GMPL DETAILED DISPLAY
	;;^UTILITY(U,$J,"PRO",2531,10,6,0)
	;;=2362^ED^5
	;;^UTILITY(U,$J,"PRO",2531,10,6,"^")
	;;=GMPL EDIT PROBLEM
	;;^UTILITY(U,$J,"PRO",2531,10,7,0)
	;;=2422^RM^3
	;;^UTILITY(U,$J,"PRO",2531,10,7,"^")
	;;=GMPL DELETE
	;;^UTILITY(U,$J,"PRO",2531,10,8,0)
	;;=2802^VW^21
	;;^UTILITY(U,$J,"PRO",2531,10,8,"^")
	;;=GMPL VIEW
	;;^UTILITY(U,$J,"PRO",2531,10,9,0)
	;;=2357^^7
	;;^UTILITY(U,$J,"PRO",2531,10,9,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2531,10,10,0)
	;;=2355^PP^25
	;;^UTILITY(U,$J,"PRO",2531,10,10,"^")
	;;=GMPL PRINT
	;;^UTILITY(U,$J,"PRO",2531,10,11,0)
	;;=2494^$^17^^^
	;;^UTILITY(U,$J,"PRO",2531,10,11,"^")
	;;=GMPL VERIFY
	;;^UTILITY(U,$J,"PRO",2531,20)
	;;=
	;;^UTILITY(U,$J,"PRO",2531,24)
	;;=I 1 X:$D(^ORD(101,+$P(^ORD(101,DA(1),10,DA,0),"^"),24)) ^(24)
	;;^UTILITY(U,$J,"PRO",2531,25,0)
	;;=2494
	;;^UTILITY(U,$J,"PRO",2531,25,2)
	;;=CF
	;;^UTILITY(U,$J,"PRO",2531,26)
	;;=D KEYS^GMPLMGR1,SHOW^VALM S:'$G(GMPCOUNT) XQORM("B")="Add New Problems"
	;;^UTILITY(U,$J,"PRO",2531,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",2531,99)
	;;=56019,56192
	;;^UTILITY(U,$J,"PRO",2531,"B",2494,25)
	;;=
	;;^UTILITY(U,$J,"PRO",2532,0)
	;;=GMPL VIEW ALL PROV^All Providers^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2532,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2532,1,1,0)
	;;=This action will remove any current screen on primary providers of care
	;;^UTILITY(U,$J,"PRO",2532,1,2,0)
	;;=for problems, and include problems being treated by all providers.
	;;^UTILITY(U,$J,"PRO",2532,20)
	;;=S:GMPLVIEW("PROV")'=0 GMPLVIEW("PROV")=0,GMPREBLD=1
	;;^UTILITY(U,$J,"PRO",2532,99)
	;;=55908,59667
	;;^UTILITY(U,$J,"PRO",2533,0)
	;;=GMPL VIEW ALL SERV^All Services^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2533,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2533,1,1,0)
	;;=This action will remove any current screen on services associated with
	;;^UTILITY(U,$J,"PRO",2533,1,2,0)
	;;=problems, and include problems being treated by all services.
	;;^UTILITY(U,$J,"PRO",2533,20)
	;;=S:"S"'[GMPLVIEW("VIEW") GMPLVIEW("VIEW")="S",GMPREBLD=1
	;;^UTILITY(U,$J,"PRO",2533,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2533,99)
	;;=55908,59668
	;;^UTILITY(U,$J,"PRO",2534,0)
	;;=GMPL USER PREFS^Preferred View of Problem List^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2534,1,0)
	;;=^^6^6^2930811^^
	;;^UTILITY(U,$J,"PRO",2534,1,1,0)
	;;=This menu contains actions allowing a user to change his/her preferred
	;;^UTILITY(U,$J,"PRO",2534,1,2,0)
	;;=view of patient problem lists.  A set of services may be defined here
	;;^UTILITY(U,$J,"PRO",2534,1,3,0)
	;;=that will be used as a default screen when displaying patient problem

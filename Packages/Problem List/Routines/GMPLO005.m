GMPLO005	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2440,1,0)
	;;=^^3^3^2930908^^
	;;^UTILITY(U,$J,"PRO",2440,1,1,0)
	;;=This action allows the entry/editing of the service primarily responsible
	;;^UTILITY(U,$J,"PRO",2440,1,2,0)
	;;=for the care of this problem.  This data will be used for screening and
	;;^UTILITY(U,$J,"PRO",2440,1,3,0)
	;;=grouping the problems displayed in the user's selected view of the list.
	;;^UTILITY(U,$J,"PRO",2440,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2440,20)
	;;=D SOURCE^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2440,99)
	;;=55908,59537
	;;^UTILITY(U,$J,"PRO",2441,0)
	;;=GMPL EDIT NEW NOTE^Append a new note to problem^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2441,1,0)
	;;=^^2^2^2930811^
	;;^UTILITY(U,$J,"PRO",2441,1,1,0)
	;;=This action will allow appending addtional comment(s) to the currently
	;;^UTILITY(U,$J,"PRO",2441,1,2,0)
	;;=selected problem.
	;;^UTILITY(U,$J,"PRO",2441,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2441,20)
	;;=D NOTE^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2441,99)
	;;=55908,59536
	;;^UTILITY(U,$J,"PRO",2448,0)
	;;=GMPL DT MENU^Detailed Display^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2448,1,0)
	;;=^^4^4^2930908^^
	;;^UTILITY(U,$J,"PRO",2448,1,1,0)
	;;=This menu contains actions available for navigating the problems
	;;^UTILITY(U,$J,"PRO",2448,1,2,0)
	;;=selected to review in the "Detailed Display" action.  The user may
	;;^UTILITY(U,$J,"PRO",2448,1,3,0)
	;;=go on to the next selected problem when finished reviewing, or exit
	;;^UTILITY(U,$J,"PRO",2448,1,4,0)
	;;=and return to the problem list.
	;;^UTILITY(U,$J,"PRO",2448,4)
	;;=40^4
	;;^UTILITY(U,$J,"PRO",2448,10,0)
	;;=^101.01PA^2^4
	;;^UTILITY(U,$J,"PRO",2448,10,1,0)
	;;=2357^^2^^^
	;;^UTILITY(U,$J,"PRO",2448,10,1,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2448,10,2,0)
	;;=2495^NP^1
	;;^UTILITY(U,$J,"PRO",2448,10,2,"^")
	;;=GMPL DT CONTINUE
	;;^UTILITY(U,$J,"PRO",2448,24)
	;;=I 1 X:$D(^ORD(101,+$P(^ORD(101,DA(1),10,DA,0),U),24)) ^(24)
	;;^UTILITY(U,$J,"PRO",2448,26)
	;;=D KEY^GMPLMGR1,SHOW^VALM S:XQORM("B")="Quit" XQORM("B")=$$DEFLT^GMPLDISP
	;;^UTILITY(U,$J,"PRO",2448,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",2448,99)
	;;=55986,30686
	;;^UTILITY(U,$J,"PRO",2450,0)
	;;=VALM NEXT SCREEN^Next Screen^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2450,1,0)
	;;=^^2^2^2920519^^^
	;;^UTILITY(U,$J,"PRO",2450,1,1,0)
	;;=This action will allow the user to view the next screen
	;;^UTILITY(U,$J,"PRO",2450,1,2,0)
	;;=of entries, if any exist.
	;;^UTILITY(U,$J,"PRO",2450,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",2450,2,1,0)
	;;=NX
	;;^UTILITY(U,$J,"PRO",2450,2,"B","NX",1)
	;;=
	;;^UTILITY(U,$J,"PRO",2450,15)
	;;=
	;;^UTILITY(U,$J,"PRO",2450,20)
	;;=D NEXT^VALM4
	;;^UTILITY(U,$J,"PRO",2450,99)
	;;=55983,43973
	;;^UTILITY(U,$J,"PRO",2450,"MEN","GMPL HIDDEN MENU")
	;;=2450^+^11
	;;^UTILITY(U,$J,"PRO",2451,0)
	;;=VALM PREVIOUS SCREEN^Previous Screen^^A^^^^^^^^LIST MANAGER
	;;^UTILITY(U,$J,"PRO",2451,1,0)
	;;=^^2^2^2920113^^
	;;^UTILITY(U,$J,"PRO",2451,1,1,0)
	;;=This action will allow the user to view the previous screen
	;;^UTILITY(U,$J,"PRO",2451,1,2,0)
	;;=of entries, if any exist.
	;;^UTILITY(U,$J,"PRO",2451,2,0)
	;;=^101.02A^3^2
	;;^UTILITY(U,$J,"PRO",2451,2,1,0)
	;;=PR
	;;^UTILITY(U,$J,"PRO",2451,2,2,0)
	;;=BK
	;;^UTILITY(U,$J,"PRO",2451,2,3,0)
	;;=PR
	;;^UTILITY(U,$J,"PRO",2451,2,"B","BK",2)
	;;=
	;;^UTILITY(U,$J,"PRO",2451,2,"B","PR",1)
	;;=
	;;^UTILITY(U,$J,"PRO",2451,2,"B","PR",3)
	;;=
	;;^UTILITY(U,$J,"PRO",2451,20)
	;;=D PREV^VALM4
	;;^UTILITY(U,$J,"PRO",2451,99)
	;;=55983,43973
	;;^UTILITY(U,$J,"PRO",2451,"MEN","GMPL HIDDEN MENU")
	;;=2451^-^12

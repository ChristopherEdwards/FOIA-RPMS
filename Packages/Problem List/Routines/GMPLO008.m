GMPLO008	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2495,1,0)
	;;=^^3^3^2930811^
	;;^UTILITY(U,$J,"PRO",2495,1,1,0)
	;;=If multiple problems were selected for review under the "Detailed
	;;^UTILITY(U,$J,"PRO",2495,1,2,0)
	;;=Display" action, this will allow retrieval of the data from the
	;;^UTILITY(U,$J,"PRO",2495,1,3,0)
	;;=next problem of those selected.
	;;^UTILITY(U,$J,"PRO",2495,20)
	;;=D EN^GMPLDISP
	;;^UTILITY(U,$J,"PRO",2495,24)
	;;=I $G(GMPI)<$G(GMPLNO)
	;;^UTILITY(U,$J,"PRO",2495,99)
	;;=55908,59531
	;;^UTILITY(U,$J,"PRO",2498,0)
	;;=GMPL DATA ENTRY^Problem List Data Entry^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2498,1,0)
	;;=^^4^4^2930811^^
	;;^UTILITY(U,$J,"PRO",2498,1,1,0)
	;;=This menu uses the List Manager utility to display a patient's problem
	;;^UTILITY(U,$J,"PRO",2498,1,2,0)
	;;=list with data relevant to the needs of a clinic or billing clerk.
	;;^UTILITY(U,$J,"PRO",2498,1,3,0)
	;;=Various actions may be taken here such as adding, removing, editing,
	;;^UTILITY(U,$J,"PRO",2498,1,4,0)
	;;=and printing problems.
	;;^UTILITY(U,$J,"PRO",2498,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",2498,10,0)
	;;=^101.01PA^10^11
	;;^UTILITY(U,$J,"PRO",2498,10,1,0)
	;;=2345^AD^1
	;;^UTILITY(U,$J,"PRO",2498,10,1,"^")
	;;=GMPL NEW PROBLEM
	;;^UTILITY(U,$J,"PRO",2498,10,2,0)
	;;=2362^ED^5
	;;^UTILITY(U,$J,"PRO",2498,10,2,"^")
	;;=GMPL EDIT PROBLEM
	;;^UTILITY(U,$J,"PRO",2498,10,3,0)
	;;=2357^^7
	;;^UTILITY(U,$J,"PRO",2498,10,3,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2498,10,4,0)
	;;=2422^RM^3
	;;^UTILITY(U,$J,"PRO",2498,10,4,"^")
	;;=GMPL DELETE
	;;^UTILITY(U,$J,"PRO",2498,10,5,0)
	;;=2502^PP^23
	;;^UTILITY(U,$J,"PRO",2498,10,5,"^")
	;;=GMPL PRINT LIST
	;;^UTILITY(U,$J,"PRO",2498,10,6,0)
	;;=2356^IN^11
	;;^UTILITY(U,$J,"PRO",2498,10,6,"^")
	;;=GMPL INACTIVATE
	;;^UTILITY(U,$J,"PRO",2498,10,7,0)
	;;=2347^CM^13^^^
	;;^UTILITY(U,$J,"PRO",2498,10,7,"^")
	;;=GMPL ANNOTATE
	;;^UTILITY(U,$J,"PRO",2498,10,8,0)
	;;=2350^SP^21
	;;^UTILITY(U,$J,"PRO",2498,10,8,"^")
	;;=GMPL PATIENT
	;;^UTILITY(U,$J,"PRO",2498,10,9,0)
	;;=2358^^17
	;;^UTILITY(U,$J,"PRO",2498,10,9,"^")
	;;=GMPLX BLANK2
	;;^UTILITY(U,$J,"PRO",2498,10,10,0)
	;;=2797^VW^15
	;;^UTILITY(U,$J,"PRO",2498,10,10,"^")
	;;=GMPL VIEW INCLUDE INACTIVE
	;;^UTILITY(U,$J,"PRO",2498,20)
	;;=
	;;^UTILITY(U,$J,"PRO",2498,24)
	;;=I 1 X:$D(^ORD(101,+$P(^ORD(101,DA(1),10,DA,0),"^"),24)) ^(24)
	;;^UTILITY(U,$J,"PRO",2498,26)
	;;=D KEY^GMPLMGR1,SHOW^VALM
	;;^UTILITY(U,$J,"PRO",2498,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",2498,99)
	;;=56019,56223
	;;^UTILITY(U,$J,"PRO",2502,0)
	;;=GMPL PRINT LIST^Print Problem List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2502,1,0)
	;;=^^3^3^2940201^^^^
	;;^UTILITY(U,$J,"PRO",2502,1,1,0)
	;;=This action will generate a complete listing of the patient's problem
	;;^UTILITY(U,$J,"PRO",2502,1,2,0)
	;;=list in chartable format.  Active and inactive problems will appear
	;;^UTILITY(U,$J,"PRO",2502,1,3,0)
	;;=here in this listing.
	;;^UTILITY(U,$J,"PRO",2502,20)
	;;=S Y="A",VALMBCK=$S(VALMCC:"",1:"R") D EN1^GMPLPRNT
	;;^UTILITY(U,$J,"PRO",2502,99)
	;;=55914,31779
	;;^UTILITY(U,$J,"PRO",2531,0)
	;;=GMPL PROBLEM LIST^Problem List^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2531,1,0)
	;;=^^7^7^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2531,1,1,0)
	;;=This menu uses the List Manager utility to display a patient's problem
	;;^UTILITY(U,$J,"PRO",2531,1,2,0)
	;;=list with data relevant to the needs of a clinician.  Various actions
	;;^UTILITY(U,$J,"PRO",2531,1,3,0)
	;;=may be taken here such as adding, removing, editing, inactivating, and
	;;^UTILITY(U,$J,"PRO",2531,1,4,0)
	;;=appending comments; the user may also see a detailed display of selected

GMPLO016	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2771,1,4,0)
	;;=a problem is available to facilitate the assignment of a code.
	;;^UTILITY(U,$J,"PRO",2771,4)
	;;=40^4
	;;^UTILITY(U,$J,"PRO",2771,10,0)
	;;=^101.01PA^5^3
	;;^UTILITY(U,$J,"PRO",2771,10,1,0)
	;;=2348^DT^1
	;;^UTILITY(U,$J,"PRO",2771,10,1,"^")
	;;=GMPL DETAILED DISPLAY
	;;^UTILITY(U,$J,"PRO",2771,10,2,0)
	;;=2350^SP^11
	;;^UTILITY(U,$J,"PRO",2771,10,2,"^")
	;;=GMPL PATIENT
	;;^UTILITY(U,$J,"PRO",2771,10,5,0)
	;;=2357^^5
	;;^UTILITY(U,$J,"PRO",2771,10,5,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2771,10,6,0)
	;;=2773^CD^3
	;;^UTILITY(U,$J,"PRO",2771,10,6,"^")
	;;=GMPL CODE ICD SEARCH
	;;^UTILITY(U,$J,"PRO",2771,10,8,0)
	;;=2358^^15
	;;^UTILITY(U,$J,"PRO",2771,10,8,"^")
	;;=GMPLX BLANK2
	;;^UTILITY(U,$J,"PRO",2771,24)
	;;=I 1 X:$D(^ORD(101,+$P(^ORD(101,DA(1),10,DA,0),"^"),24)) ^(24)
	;;^UTILITY(U,$J,"PRO",2771,26)
	;;=D KEY^GMPLMGR1,SHOW^VALM
	;;^UTILITY(U,$J,"PRO",2771,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",2771,99)
	;;=56015,60776
	;;^UTILITY(U,$J,"PRO",2773,0)
	;;=GMPL CODE ICD SEARCH^Search ICD Diagnoses for Codes^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2773,1,0)
	;;=^^3^3^2931105^
	;;^UTILITY(U,$J,"PRO",2773,1,1,0)
	;;=This option allows the user to search the ICD Diagnosis file for the
	;;^UTILITY(U,$J,"PRO",2773,1,2,0)
	;;=selected problem's text; for this option it is recommended that the
	;;^UTILITY(U,$J,"PRO",2773,1,3,0)
	;;=Multi-Term Lookup utility be setup to operate on this file (#80).
	;;^UTILITY(U,$J,"PRO",2773,20)
	;;=D EDIT^GMPLCODE
	;;^UTILITY(U,$J,"PRO",2773,24)
	;;=I +$G(GMPCOUNT)>0
	;;^UTILITY(U,$J,"PRO",2773,99)
	;;=55984,51099
	;;^UTILITY(U,$J,"PRO",2777,0)
	;;=GMPL EDIT ICD^ICD Code^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2777,1,0)
	;;=^^2^2^2931126^
	;;^UTILITY(U,$J,"PRO",2777,1,1,0)
	;;=This action allows a user with the GMPL ICD CODE key to assign a [new]
	;;^UTILITY(U,$J,"PRO",2777,1,2,0)
	;;=ICD Code to a problem.
	;;^UTILITY(U,$J,"PRO",2777,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2777,20)
	;;=D ICD^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2777,99)
	;;=55908,59533
	;;^UTILITY(U,$J,"PRO",2790,0)
	;;=GMPL VIEW OUTPAT^Outpatient View Menu^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2790,1,0)
	;;=^^6^6^2940111^^^^
	;;^UTILITY(U,$J,"PRO",2790,1,1,0)
	;;=This menu contains actions allowing the user to change his/her current
	;;^UTILITY(U,$J,"PRO",2790,1,2,0)
	;;=view of the patient's problem list.  The problems displayed onscreen
	;;^UTILITY(U,$J,"PRO",2790,1,3,0)
	;;=may be changed by selecting the status, clinic, and/or provider
	;;^UTILITY(U,$J,"PRO",2790,1,4,0)
	;;=from which the user wishes to see problems listed.  The number of
	;;^UTILITY(U,$J,"PRO",2790,1,5,0)
	;;=problems listed and the total number of problems will be shown in
	;;^UTILITY(U,$J,"PRO",2790,1,6,0)
	;;=the upper right-hand corner of the screen.
	;;^UTILITY(U,$J,"PRO",2790,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",2790,10,0)
	;;=^101.01PA^9^9
	;;^UTILITY(U,$J,"PRO",2790,10,1,0)
	;;=2434^AT^1
	;;^UTILITY(U,$J,"PRO",2790,10,1,"^")
	;;=GMPL VIEW ACTIVE
	;;^UTILITY(U,$J,"PRO",2790,10,2,0)
	;;=2436^SP^21
	;;^UTILITY(U,$J,"PRO",2790,10,2,"^")
	;;=GMPL VIEW PROVIDER
	;;^UTILITY(U,$J,"PRO",2790,10,3,0)
	;;=2438^IA^2
	;;^UTILITY(U,$J,"PRO",2790,10,3,"^")
	;;=GMPL VIEW INACTIVE
	;;^UTILITY(U,$J,"PRO",2790,10,4,0)
	;;=2439^BO^3
	;;^UTILITY(U,$J,"PRO",2790,10,4,"^")
	;;=GMPL VIEW BOTH
	;;^UTILITY(U,$J,"PRO",2790,10,5,0)
	;;=2532^AP^22
	;;^UTILITY(U,$J,"PRO",2790,10,5,"^")
	;;=GMPL VIEW ALL PROV
	;;^UTILITY(U,$J,"PRO",2790,10,6,0)
	;;=2799^SC^11
	;;^UTILITY(U,$J,"PRO",2790,10,6,"^")
	;;=GMPL VIEW CLINIC

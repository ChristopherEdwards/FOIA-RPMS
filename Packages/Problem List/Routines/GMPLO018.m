GMPLO018	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2796,99)
	;;=55915,45466
	;;^UTILITY(U,$J,"PRO",2797,0)
	;;=GMPL VIEW INCLUDE INACTIVE^Show All Problems^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2797,1,0)
	;;=^^3^3^2940107^
	;;^UTILITY(U,$J,"PRO",2797,1,1,0)
	;;=This action will include problems that are both active and inactive on
	;;^UTILITY(U,$J,"PRO",2797,1,2,0)
	;;=the list of problems displayed; active problems will appear first, followed
	;;^UTILITY(U,$J,"PRO",2797,1,3,0)
	;;=by the inactive problems.
	;;^UTILITY(U,$J,"PRO",2797,20)
	;;=D INACTIVE^GMPLMGR1
	;;^UTILITY(U,$J,"PRO",2797,99)
	;;=55914,31906
	;;^UTILITY(U,$J,"PRO",2798,0)
	;;=GMPL VIEW ALL CLIN^All Clinics^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2798,1,0)
	;;=^^2^2^2940110^
	;;^UTILITY(U,$J,"PRO",2798,1,1,0)
	;;=This action will remove any current screen on clinics associated with
	;;^UTILITY(U,$J,"PRO",2798,1,2,0)
	;;=problems, and include problems being followed by all clinics.
	;;^UTILITY(U,$J,"PRO",2798,20)
	;;=S:"C"'[GMPLVIEW("VIEW") GMPLVIEW("VIEW")="C",GMPREBLD=1
	;;^UTILITY(U,$J,"PRO",2798,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2798,99)
	;;=55908,59667
	;;^UTILITY(U,$J,"PRO",2799,0)
	;;=GMPL VIEW CLINIC^Selected Clinic(s)^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2799,1,0)
	;;=^^2^2^2940110^
	;;^UTILITY(U,$J,"PRO",2799,1,1,0)
	;;=This action will screen the problems from the current patient's list for
	;;^UTILITY(U,$J,"PRO",2799,1,2,0)
	;;=only those associated with the selected clinic(s) for care.
	;;^UTILITY(U,$J,"PRO",2799,20)
	;;=D NEWCLIN^GMPLMGR1
	;;^UTILITY(U,$J,"PRO",2799,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2799,99)
	;;=55908,59668
	;;^UTILITY(U,$J,"PRO",2801,0)
	;;=GMPL VIEW INPAT^Inpatient View Menu^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2801,1,0)
	;;=^^6^6^2940111^^^^
	;;^UTILITY(U,$J,"PRO",2801,1,1,0)
	;;=This menu contains actions allowing the user to change his/her current
	;;^UTILITY(U,$J,"PRO",2801,1,2,0)
	;;=view of the patient's problem list.  The problems displayed onscreen
	;;^UTILITY(U,$J,"PRO",2801,1,3,0)
	;;=may be changed by selecting the status, service, and/or provider
	;;^UTILITY(U,$J,"PRO",2801,1,4,0)
	;;=from which the user wishes to see problems listed.  The number of
	;;^UTILITY(U,$J,"PRO",2801,1,5,0)
	;;=problems listed and the total number of problems will be shown in
	;;^UTILITY(U,$J,"PRO",2801,1,6,0)
	;;=the upper right-hand corner of the screen.
	;;^UTILITY(U,$J,"PRO",2801,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",2801,10,0)
	;;=^101.01PA^9^9
	;;^UTILITY(U,$J,"PRO",2801,10,1,0)
	;;=2434^AT^1
	;;^UTILITY(U,$J,"PRO",2801,10,1,"^")
	;;=GMPL VIEW ACTIVE
	;;^UTILITY(U,$J,"PRO",2801,10,2,0)
	;;=2436^SP^21
	;;^UTILITY(U,$J,"PRO",2801,10,2,"^")
	;;=GMPL VIEW PROVIDER
	;;^UTILITY(U,$J,"PRO",2801,10,3,0)
	;;=2438^IA^2
	;;^UTILITY(U,$J,"PRO",2801,10,3,"^")
	;;=GMPL VIEW INACTIVE
	;;^UTILITY(U,$J,"PRO",2801,10,4,0)
	;;=2439^BO^3
	;;^UTILITY(U,$J,"PRO",2801,10,4,"^")
	;;=GMPL VIEW BOTH
	;;^UTILITY(U,$J,"PRO",2801,10,5,0)
	;;=2532^AP^22
	;;^UTILITY(U,$J,"PRO",2801,10,5,"^")
	;;=GMPL VIEW ALL PROV
	;;^UTILITY(U,$J,"PRO",2801,10,6,0)
	;;=2435^SS^11
	;;^UTILITY(U,$J,"PRO",2801,10,6,"^")
	;;=GMPL VIEW SERVICE
	;;^UTILITY(U,$J,"PRO",2801,10,7,0)
	;;=2533^AS^12
	;;^UTILITY(U,$J,"PRO",2801,10,7,"^")
	;;=GMPL VIEW ALL SERV
	;;^UTILITY(U,$J,"PRO",2801,10,8,0)
	;;=2791^PV^23
	;;^UTILITY(U,$J,"PRO",2801,10,8,"^")
	;;=GMPL VIEW RESTORE
	;;^UTILITY(U,$J,"PRO",2801,10,9,0)
	;;=2807^OP^13^^^Outpatient View
	;;^UTILITY(U,$J,"PRO",2801,10,9,"^")
	;;=GMPL VIEW SWITCH
	;;^UTILITY(U,$J,"PRO",2801,26)
	;;=W ""
	;;^UTILITY(U,$J,"PRO",2801,28)
	;;=Select View:

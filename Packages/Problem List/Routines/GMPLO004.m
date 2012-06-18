GMPLO004	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2431,2,0)
	;;=^101.02A^^0
	;;^UTILITY(U,$J,"PRO",2431,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2431,20)
	;;=D ONSET^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2431,99)
	;;=55908,59536
	;;^UTILITY(U,$J,"PRO",2433,0)
	;;=GMPL EDIT SC^Service Connection^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2433,1,0)
	;;=^^5^5^2930811^^^
	;;^UTILITY(U,$J,"PRO",2433,1,1,0)
	;;=This action allows editing the service connection status of the current
	;;^UTILITY(U,$J,"PRO",2433,1,2,0)
	;;=problem; if the service connection of this problem was previously
	;;^UTILITY(U,$J,"PRO",2433,1,3,0)
	;;=unknown, it may be entered here.  Data will only be asked for if the
	;;^UTILITY(U,$J,"PRO",2433,1,4,0)
	;;=patient has service connection indicated in the Patient file.  MCCR
	;;^UTILITY(U,$J,"PRO",2433,1,5,0)
	;;=will be using this data for billing purposes.
	;;^UTILITY(U,$J,"PRO",2433,2,0)
	;;=^101.02A^^0
	;;^UTILITY(U,$J,"PRO",2433,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2433,20)
	;;=D SC^GMPLEDT1 I 'GMPSC W !!,"This patient has no service-connection on file.",! H 2
	;;^UTILITY(U,$J,"PRO",2433,99)
	;;=55908,59537
	;;^UTILITY(U,$J,"PRO",2434,0)
	;;=GMPL VIEW ACTIVE^Active only^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2434,1,0)
	;;=^^2^2^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2434,1,1,0)
	;;=This action will screen the problems from the current patient's list
	;;^UTILITY(U,$J,"PRO",2434,1,2,0)
	;;=for only those that are currently active.
	;;^UTILITY(U,$J,"PRO",2434,20)
	;;=S:GMPLVIEW("ACT")'="A" GMPREBLD=1,GMPLVIEW("ACT")="A"
	;;^UTILITY(U,$J,"PRO",2434,99)
	;;=55908,59667
	;;^UTILITY(U,$J,"PRO",2435,0)
	;;=GMPL VIEW SERVICE^Selected Service(s)^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2435,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2435,1,1,0)
	;;=This action will screen the problems from the current patient's list
	;;^UTILITY(U,$J,"PRO",2435,1,2,0)
	;;=for only those associated with the selected service(s) for care.
	;;^UTILITY(U,$J,"PRO",2435,20)
	;;=D NEWSRV^GMPLMGR1
	;;^UTILITY(U,$J,"PRO",2435,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2435,99)
	;;=55908,59741
	;;^UTILITY(U,$J,"PRO",2436,0)
	;;=GMPL VIEW PROVIDER^Selected Provider^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2436,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2436,1,1,0)
	;;=This action will screen the problems from the current patient's list
	;;^UTILITY(U,$J,"PRO",2436,1,2,0)
	;;=for only those listed as being treated by the selected provider.
	;;^UTILITY(U,$J,"PRO",2436,20)
	;;=D NEWPROV^GMPLMGR1
	;;^UTILITY(U,$J,"PRO",2436,99)
	;;=55908,59741
	;;^UTILITY(U,$J,"PRO",2438,0)
	;;=GMPL VIEW INACTIVE^Inactive only^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2438,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2438,1,1,0)
	;;=This action will screen the problems from the current patient's list
	;;^UTILITY(U,$J,"PRO",2438,1,2,0)
	;;=for only those that are currently inactive.
	;;^UTILITY(U,$J,"PRO",2438,20)
	;;=S:GMPLVIEW("ACT")'="I" GMPREBLD=1,GMPLVIEW("ACT")="I"
	;;^UTILITY(U,$J,"PRO",2438,99)
	;;=55908,59668
	;;^UTILITY(U,$J,"PRO",2439,0)
	;;=GMPL VIEW BOTH^Active & Inactive^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2439,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2439,1,1,0)
	;;=This action will remove any current screen on problem status and include
	;;^UTILITY(U,$J,"PRO",2439,1,2,0)
	;;=problems that are both active and inactive on the display.
	;;^UTILITY(U,$J,"PRO",2439,20)
	;;=S:GMPLVIEW("ACT")'="" GMPREBLD=1,GMPLVIEW("ACT")=""
	;;^UTILITY(U,$J,"PRO",2439,99)
	;;=55908,59668
	;;^UTILITY(U,$J,"PRO",2440,0)
	;;=GMPL EDIT SERVICE^Service or Clinic^^A^^^^^^^^PROBLEM LIST

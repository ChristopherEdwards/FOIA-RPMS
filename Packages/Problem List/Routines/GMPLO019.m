GMPLO019	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2801,99)
	;;=56039,42784
	;;^UTILITY(U,$J,"PRO",2802,0)
	;;=GMPL VIEW^Select View of List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2802,1,0)
	;;=^^4^4^2940111^
	;;^UTILITY(U,$J,"PRO",2802,1,1,0)
	;;=This allows the user to change the problems displayed onscreen in the
	;;^UTILITY(U,$J,"PRO",2802,1,2,0)
	;;=patient's list, on-the-fly.  Various attributes are presented for selection
	;;^UTILITY(U,$J,"PRO",2802,1,3,0)
	;;=such as status, provider, and clinic (or service if the patient is currently
	;;^UTILITY(U,$J,"PRO",2802,1,4,0)
	;;=admitted).
	;;^UTILITY(U,$J,"PRO",2802,15)
	;;=D EXVIEW^GMPLMGR2
	;;^UTILITY(U,$J,"PRO",2802,20)
	;;=D ENVIEW^GMPLMGR2
	;;^UTILITY(U,$J,"PRO",2802,99)
	;;=55908,59667
	;;^UTILITY(U,$J,"PRO",2803,0)
	;;=GMPL UP SWITCH^Select New View of Problems^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2803,1,0)
	;;=^^6^6^2940113^
	;;^UTILITY(U,$J,"PRO",2803,1,1,0)
	;;=This action allows the user to switch to a different preferred view.
	;;^UTILITY(U,$J,"PRO",2803,1,2,0)
	;;=If one is currently editing a service view of problem lists, this
	;;^UTILITY(U,$J,"PRO",2803,1,3,0)
	;;=action will clear the current view and bring up a list of clinics from
	;;^UTILITY(U,$J,"PRO",2803,1,4,0)
	;;=which to select a view, and vice-versa from clinic to service list.
	;;^UTILITY(U,$J,"PRO",2803,1,5,0)
	;;=  
	;;^UTILITY(U,$J,"PRO",2803,1,6,0)
	;;=NOTE:  Each user may have only ONE preferred view at a time!
	;;^UTILITY(U,$J,"PRO",2803,20)
	;;=D SWITCH^GMPLPRF1
	;;^UTILITY(U,$J,"PRO",2803,99)
	;;=55908,59651
	;;^UTILITY(U,$J,"PRO",2804,0)
	;;=GMPL EDIT RECORDED^Date Recorded^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2804,1,0)
	;;=^^3^3^2940118^
	;;^UTILITY(U,$J,"PRO",2804,1,1,0)
	;;=This action allows editing of the date the problem was originally recorded;
	;;^UTILITY(U,$J,"PRO",2804,1,2,0)
	;;=date will default to NOW when entering a new problem, but may be changed
	;;^UTILITY(U,$J,"PRO",2804,1,3,0)
	;;=to an earlier date to reflect entry in the paper chart.
	;;^UTILITY(U,$J,"PRO",2804,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2804,20)
	;;=D RECORDED^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2804,99)
	;;=55908,59536
	;;^UTILITY(U,$J,"PRO",2805,0)
	;;=GMPL UP DELETE VIEW^Delete Preferred View & Exit^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2805,1,0)
	;;=^^3^3^2940127^
	;;^UTILITY(U,$J,"PRO",2805,1,1,0)
	;;=This action allows the user to delete his/her preferred view and exit
	;;^UTILITY(U,$J,"PRO",2805,1,2,0)
	;;=the utility.  The user will again see all active problems, when initially
	;;^UTILITY(U,$J,"PRO",2805,1,3,0)
	;;=displaying a patient's problem list.
	;;^UTILITY(U,$J,"PRO",2805,20)
	;;=D DELETE^GMPLPRF1
	;;^UTILITY(U,$J,"PRO",2805,99)
	;;=55909,58822
	;;^UTILITY(U,$J,"PRO",2807,0)
	;;=GMPL VIEW SWITCH^Inpatient View^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2807,1,0)
	;;=^^5^5^2940323^
	;;^UTILITY(U,$J,"PRO",2807,1,1,0)
	;;=This action will allow the user to switch from displaying the problems
	;;^UTILITY(U,$J,"PRO",2807,1,2,0)
	;;=in an outpatient mode to an inpatient mode, or vice-versa.  If clinic
	;;^UTILITY(U,$J,"PRO",2807,1,3,0)
	;;=information is currently being displayed, service and provider will now
	;;^UTILITY(U,$J,"PRO",2807,1,4,0)
	;;=be displayed after selecting this action; likewise, if service and
	;;^UTILITY(U,$J,"PRO",2807,1,5,0)
	;;=provider information are currently displayed, clinic will now be shown.
	;;^UTILITY(U,$J,"PRO",2807,20)
	;;=S X=$E(GMPLVIEW("VIEW")),GMPLVIEW("VIEW")=$S(X="S":"C",1:"S"),GMPREBLD=1,Y=$S(X="S":"Clinic",1:"Service/Provider") D CHGCAP^VALM("CLINIC",Y) K X,Y

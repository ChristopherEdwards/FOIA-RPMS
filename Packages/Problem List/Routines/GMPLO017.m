GMPLO017	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2790,10,7,0)
	;;=2798^CL^12
	;;^UTILITY(U,$J,"PRO",2790,10,7,"^")
	;;=GMPL VIEW ALL CLIN
	;;^UTILITY(U,$J,"PRO",2790,10,8,0)
	;;=2791^PV^23
	;;^UTILITY(U,$J,"PRO",2790,10,8,"^")
	;;=GMPL VIEW RESTORE
	;;^UTILITY(U,$J,"PRO",2790,10,9,0)
	;;=2807^IP^13
	;;^UTILITY(U,$J,"PRO",2790,10,9,"^")
	;;=GMPL VIEW SWITCH
	;;^UTILITY(U,$J,"PRO",2790,15)
	;;=
	;;^UTILITY(U,$J,"PRO",2790,20)
	;;=
	;;^UTILITY(U,$J,"PRO",2790,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2790,26)
	;;=W ""
	;;^UTILITY(U,$J,"PRO",2790,27)
	;;=
	;;^UTILITY(U,$J,"PRO",2790,28)
	;;=Select View: 
	;;^UTILITY(U,$J,"PRO",2790,99)
	;;=56004,56275
	;;^UTILITY(U,$J,"PRO",2791,0)
	;;=GMPL VIEW RESTORE^Preferred View^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2791,1,0)
	;;=^^2^2^2940323^^^^
	;;^UTILITY(U,$J,"PRO",2791,1,1,0)
	;;=This action will replace the currently specified view with the
	;;^UTILITY(U,$J,"PRO",2791,1,2,0)
	;;=user's pre-defined preferred view.
	;;^UTILITY(U,$J,"PRO",2791,20)
	;;~S X=$$VIEW^GMPLX1(DUZ) W:'$L(X) !,"You have no preferred view defined.",! Q:'$L(X)  S:X'=GMPLVIEW("VIEW") GMPREBLD=1,GMPLVIEW("VIEW")=X K X S:GMPLVIEW("PROV") G
	;;=MPLVIEW("PROV")=0,GMPREBLD=1 S:GMPLVIEW("ACT")'="A" GMPLVIEW("ACT")="A",GMPREBLD=1
	;;^UTILITY(U,$J,"PRO",2791,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2791,99)
	;;=55964,55397
	;;^UTILITY(U,$J,"PRO",2792,0)
	;;=GMPL UP ADD ITEM^Add Items to View^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2792,1,0)
	;;=^^2^2^2930811^^
	;;^UTILITY(U,$J,"PRO",2792,1,1,0)
	;;=This action allows the user to include additional service(s) in his/her
	;;^UTILITY(U,$J,"PRO",2792,1,2,0)
	;;=preferred view of patient problem lists.
	;;^UTILITY(U,$J,"PRO",2792,20)
	;;=D ADD^GMPLPRF1
	;;^UTILITY(U,$J,"PRO",2792,99)
	;;=55984,51207
	;;^UTILITY(U,$J,"PRO",2793,0)
	;;=GMPL UP REMOVE ITEM^Remove Items from View^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2793,1,0)
	;;=^^2^2^2930811^
	;;^UTILITY(U,$J,"PRO",2793,1,1,0)
	;;=This action allows the user to remove service(s) from his/her preferred
	;;^UTILITY(U,$J,"PRO",2793,1,2,0)
	;;=view of patient problem lists.
	;;^UTILITY(U,$J,"PRO",2793,20)
	;;=D REMOVE^GMPLPRF1
	;;^UTILITY(U,$J,"PRO",2793,99)
	;;=55984,51215
	;;^UTILITY(U,$J,"PRO",2794,0)
	;;=GMPL UP SAVE VIEW^Save Preferred View & Exit^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2794,1,0)
	;;=^^3^3^2930811^
	;;^UTILITY(U,$J,"PRO",2794,1,1,0)
	;;=This action allows the user to save any changes made to his/her
	;;^UTILITY(U,$J,"PRO",2794,1,2,0)
	;;=preferred view of patient problem lists; control is passed back
	;;^UTILITY(U,$J,"PRO",2794,1,3,0)
	;;=to the User Preferences menu.
	;;^UTILITY(U,$J,"PRO",2794,20)
	;;=S GMPSAVED=1,VALMBCK="Q" D SAVE^GMPLPRF1
	;;^UTILITY(U,$J,"PRO",2794,99)
	;;=55908,59652
	;;^UTILITY(U,$J,"PRO",2796,0)
	;;=GMPL MENU ASSIGN LIST^Assign List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2796,1,0)
	;;=^^6^6^2940202^^^^
	;;^UTILITY(U,$J,"PRO",2796,1,1,0)
	;;=This action allows the user to assign this list to a clinic or to user(s).
	;;^UTILITY(U,$J,"PRO",2796,1,2,0)
	;;=Linking a list to a clinic will invoke the list whenever a user selects
	;;^UTILITY(U,$J,"PRO",2796,1,3,0)
	;;=that clinic as the location where the patient was seen, when adding
	;;^UTILITY(U,$J,"PRO",2796,1,4,0)
	;;=new problems.  If a list is linked to a user, this is the list that will
	;;^UTILITY(U,$J,"PRO",2796,1,5,0)
	;;=always be invoked when that user is adding new problems, regardless of
	;;^UTILITY(U,$J,"PRO",2796,1,6,0)
	;;=the clinic specified that the patient was seen in.
	;;^UTILITY(U,$J,"PRO",2796,20)
	;;=D ASSIGN^GMPLBLD3

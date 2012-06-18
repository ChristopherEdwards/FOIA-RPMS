GMPLO003	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2423,99)
	;;=55985,55649
	;;^UTILITY(U,$J,"PRO",2424,0)
	;;=GMPL EDIT PROVIDER^Primary Provider^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2424,1,0)
	;;=^^2^2^2930811^
	;;^UTILITY(U,$J,"PRO",2424,1,1,0)
	;;=This action allows the entry/editing of the primary provider of care
	;;^UTILITY(U,$J,"PRO",2424,1,2,0)
	;;=for this problem.
	;;^UTILITY(U,$J,"PRO",2424,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2424,20)
	;;=D PROV^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2424,99)
	;;=55908,59536
	;;^UTILITY(U,$J,"PRO",2425,0)
	;;=GMPL EDIT SAVE^Save Changes and Exit^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2425,1,0)
	;;=^^4^4^2930908^^
	;;^UTILITY(U,$J,"PRO",2425,1,1,0)
	;;=This action allows the user to save any changes made to the current
	;;^UTILITY(U,$J,"PRO",2425,1,2,0)
	;;=problem, and return to the entire problem list.  If this action is
	;;^UTILITY(U,$J,"PRO",2425,1,3,0)
	;;=not selected and the problem has been changed, the user will be asked
	;;^UTILITY(U,$J,"PRO",2425,1,4,0)
	;;=when exiting if s/he wishes to save the changes.
	;;^UTILITY(U,$J,"PRO",2425,15)
	;;=S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",2425,20)
	;;=W !!,"Saving ..." D EN^GMPLSAVE W " done."
	;;^UTILITY(U,$J,"PRO",2425,99)
	;;=55908,59537
	;;^UTILITY(U,$J,"PRO",2427,0)
	;;=GMPL EDIT REMOVE^Remove Problem from List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2427,1,0)
	;;=^^4^4^2930811^^
	;;^UTILITY(U,$J,"PRO",2427,1,1,0)
	;;=This action will remove the current entry from the patient's list;
	;;^UTILITY(U,$J,"PRO",2427,1,2,0)
	;;=the problem is not physically deleted from the file, but flagged
	;;^UTILITY(U,$J,"PRO",2427,1,3,0)
	;;=as "removed" and, except for historical purposes, generally ignored.
	;;^UTILITY(U,$J,"PRO",2427,1,4,0)
	;;=The user is then returned to the entire problem list.
	;;^UTILITY(U,$J,"PRO",2427,20)
	;;=D DELETE^GMPLEDT2
	;;^UTILITY(U,$J,"PRO",2427,99)
	;;=55908,59537
	;;^UTILITY(U,$J,"PRO",2429,0)
	;;=GMPL EDIT NOTES^Edit Existing Note(s)^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2429,1,0)
	;;=^^5^5^2930908^^^
	;;^UTILITY(U,$J,"PRO",2429,1,1,0)
	;;=This action will allow editing of comments that have previously been
	;;^UTILITY(U,$J,"PRO",2429,1,2,0)
	;;=appended to a problem entry.  Notes will be displayed for editing
	;;^UTILITY(U,$J,"PRO",2429,1,3,0)
	;;=only if the current user is the author of the note; accessing this
	;;^UTILITY(U,$J,"PRO",2429,1,4,0)
	;;=action through the Manager's Menu will set a flag allowing all notes
	;;^UTILITY(U,$J,"PRO",2429,1,5,0)
	;;=for the current problem to be displayed and edited.
	;;^UTILITY(U,$J,"PRO",2429,2,0)
	;;=^101.02A^^0
	;;^UTILITY(U,$J,"PRO",2429,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2429,20)
	;;=D NTES^GMPLEDT4
	;;^UTILITY(U,$J,"PRO",2429,24)
	;;=
	;;^UTILITY(U,$J,"PRO",2429,99)
	;;=55908,59536
	;;^UTILITY(U,$J,"PRO",2430,0)
	;;=GMPL EDIT STATUS^Status^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2430,1,0)
	;;=^^2^2^2930908^
	;;^UTILITY(U,$J,"PRO",2430,1,1,0)
	;;=This action allows editing the status assigned to a problem; if the
	;;^UTILITY(U,$J,"PRO",2430,1,2,0)
	;;=problem is inactivated, the user will be asked for Date Resolved also.
	;;^UTILITY(U,$J,"PRO",2430,2,0)
	;;=^101.02A^^0
	;;^UTILITY(U,$J,"PRO",2430,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2430,20)
	;;=D STATUS^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2430,99)
	;;=55908,59538
	;;^UTILITY(U,$J,"PRO",2431,0)
	;;=GMPL EDIT ONSET^Onset^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2431,1,0)
	;;=^^1^1^2931126^^
	;;^UTILITY(U,$J,"PRO",2431,1,1,0)
	;;=This action allows the entry/editing of the date of onset of a problem.

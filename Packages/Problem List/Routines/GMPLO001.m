GMPLO001	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2345,0)
	;;=GMPL NEW PROBLEM^Add New Problems^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2345,1,0)
	;;=^^3^3^2930908^^^^
	;;^UTILITY(U,$J,"PRO",2345,1,1,0)
	;;=This action will allow the addition of a new entry to a patient's problem
	;;^UTILITY(U,$J,"PRO",2345,1,2,0)
	;;=list.  The user will be asked to select a term from the Clinical Lexicon
	;;^UTILITY(U,$J,"PRO",2345,1,3,0)
	;;=Utility describing the problem, and to enter other relevant information.
	;;^UTILITY(U,$J,"PRO",2345,20)
	;;=D ADD^GMPL
	;;^UTILITY(U,$J,"PRO",2345,99)
	;;=55965,59746
	;;^UTILITY(U,$J,"PRO",2346,0)
	;;=GMPL EDIT REFORMULATE^Reformulate Problem Description^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2346,1,0)
	;;=^^6^6^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2346,1,1,0)
	;;=This action allows limited reformulation of the current problem.
	;;^UTILITY(U,$J,"PRO",2346,1,2,0)
	;;=If new problem text is entered, the narrative is passed to the
	;;^UTILITY(U,$J,"PRO",2346,1,3,0)
	;;=Clinical Lexicon Utility to find a match; both the user's narrative
	;;^UTILITY(U,$J,"PRO",2346,1,4,0)
	;;=and the new Clinical term will be stored, as with a new problem entry.
	;;^UTILITY(U,$J,"PRO",2346,1,5,0)
	;;=If the new problem selected from the CLU is already an entry on
	;;^UTILITY(U,$J,"PRO",2346,1,6,0)
	;;=the patient's list, the user will be alerted.
	;;^UTILITY(U,$J,"PRO",2346,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2346,20)
	;;=D TERM^GMPLEDT1
	;;^UTILITY(U,$J,"PRO",2346,99)
	;;=55908,59537
	;;^UTILITY(U,$J,"PRO",2347,0)
	;;=GMPL ANNOTATE^Comment on a Problem^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2347,1,0)
	;;=^^2^2^2940517^^^
	;;^UTILITY(U,$J,"PRO",2347,1,1,0)
	;;=This action will append a brief comment(s) to a problem entry, up to
	;;^UTILITY(U,$J,"PRO",2347,1,2,0)
	;;=60 characters in length.
	;;^UTILITY(U,$J,"PRO",2347,20)
	;;=D NOTES^GMPL
	;;^UTILITY(U,$J,"PRO",2347,24)
	;;=I +$G(GMPCOUNT)>0
	;;^UTILITY(U,$J,"PRO",2347,99)
	;;=56019,56161
	;;^UTILITY(U,$J,"PRO",2348,0)
	;;=GMPL DETAILED DISPLAY^Detailed Display^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2348,1,0)
	;;=^^4^4^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2348,1,1,0)
	;;=This action will present an expanded display of each problem selected
	;;^UTILITY(U,$J,"PRO",2348,1,2,0)
	;;=from the patient's problem list.  All available information will be
	;;^UTILITY(U,$J,"PRO",2348,1,3,0)
	;;=shown, including comments by all authors and an audit trail of changes
	;;^UTILITY(U,$J,"PRO",2348,1,4,0)
	;;=made to the problem.
	;;^UTILITY(U,$J,"PRO",2348,20)
	;;=D EXPAND^GMPL
	;;^UTILITY(U,$J,"PRO",2348,24)
	;;=I +$G(GMPCOUNT)>0
	;;^UTILITY(U,$J,"PRO",2348,99)
	;;=55908,59531
	;;^UTILITY(U,$J,"PRO",2350,0)
	;;=GMPL PATIENT^Select New Patient^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",2350,1,0)
	;;=^^2^2^2930811^^^^
	;;^UTILITY(U,$J,"PRO",2350,1,1,0)
	;;=This allows selection of a new patient from within the Problem List
	;;^UTILITY(U,$J,"PRO",2350,1,2,0)
	;;=application; a new list will be generated and displayed for review.
	;;^UTILITY(U,$J,"PRO",2350,20)
	;;=D NEWPAT^GMPLMGR1
	;;^UTILITY(U,$J,"PRO",2350,99)
	;;=55908,59624
	;;^UTILITY(U,$J,"PRO",2355,0)
	;;=GMPL PRINT^Print Problem List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2355,1,0)
	;;=^^3^3^2940119^^^^
	;;^UTILITY(U,$J,"PRO",2355,1,1,0)
	;;=This action allows printing a copy of the problem list, either the
	;;^UTILITY(U,$J,"PRO",2355,1,2,0)
	;;=currently displayed view (which may be abbreviated) or the complete
	;;^UTILITY(U,$J,"PRO",2355,1,3,0)
	;;=list in chartable format.
	;;^UTILITY(U,$J,"PRO",2355,20)
	;;=D EN^GMPLPRNT

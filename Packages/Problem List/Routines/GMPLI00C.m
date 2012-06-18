GMPLI00C	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.99)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(125.99,3,21,9,0)
	;;=   
	;;^DD(125.99,3,21,10,0)
	;;=If this flag is set to NO, the user will be prompted for his/her free
	;;^DD(125.99,3,21,11,0)
	;;=text description of the problem only, when adding or editing a problem.
	;;^DD(125.99,3,21,12,0)
	;;=No search will be performed at that time on the CLU, and no link made
	;;^DD(125.99,3,21,13,0)
	;;=from the problem to an entry in the CLU.
	;;^DD(125.99,3,"DT")
	;;=2931102
	;;^DD(125.99,4,0)
	;;=DISPLAY ORDER^S^C:CHRONOLOGICAL;R:REVERSE-CHRONOLOGICAL;^0;5^Q
	;;^DD(125.99,4,3)
	;;=Enter the order in which the problems should be displayed for your site, according to the date each problem was recorded.
	;;^DD(125.99,4,21,0)
	;;=^^6^6^2940207^^^^
	;;^DD(125.99,4,21,1,0)
	;;=This flag allows each site to control how the problem list is displayed,
	;;^DD(125.99,4,21,2,0)
	;;=whether chronologically or reverse-chronologically by date recorded.
	;;^DD(125.99,4,21,3,0)
	;;=This ordering will be the same both onscreen and on the printed copy.
	;;^DD(125.99,4,21,4,0)
	;;=When new problems are added to a patient's list, they will be added as the
	;;^DD(125.99,4,21,5,0)
	;;=most recent problems, i.e. at the top of the list if reverse-chronological
	;;^DD(125.99,4,21,6,0)
	;;=or at the bottom if chronological.
	;;^DD(125.99,4,"DT")
	;;=2940207

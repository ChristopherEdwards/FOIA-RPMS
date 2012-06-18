GMPLI005	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(125.1,3,21,3,0)
	;;=the previous problem group, and it will be underlined.
	;;^DD(125.1,3,"DT")
	;;=2931126
	;;^DD(125.1,4,0)
	;;=SHOW PROBLEMS^S^1:YES;0:NO;^0;5^Q
	;;^DD(125.1,4,3)
	;;=Enter YES to immediately display the problems in this category when using this list for selection.
	;;^DD(125.1,4,21,0)
	;;=^^4^4^2931221^^^
	;;^DD(125.1,4,21,1,0)
	;;=This field controls the initial display of this category in this selection
	;;^DD(125.1,4,21,2,0)
	;;=list.  If set to YES, the problems will automatically be displayed as part
	;;^DD(125.1,4,21,3,0)
	;;=of the list when it is initially built and displayed; if null or NO, the
	;;^DD(125.1,4,21,4,0)
	;;=category must be selected in order to expand the list and show the problems.
	;;^DD(125.1,4,"DT")
	;;=2931221

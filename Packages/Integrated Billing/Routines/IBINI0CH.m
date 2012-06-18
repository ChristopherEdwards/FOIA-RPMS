IBINI0CH	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIBT",526,0)
	;;=IB BILLING RATES^2900529.0958^^399.5^^^2920708^
	;;^UTILITY(U,$J,"DIBT",526,2,1)
	;;=399.5^^BILLING BEDSECTION^'".02^
	;;^UTILITY(U,$J,"DIBT",526,2,1,"CM")
	;;=S Y(1)=$S($D(^DGCR(399.5,D0,0)):^(0),1:"") S X=$S('$D(^DGCR(399.1,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) I D0>0 S X(1)=X
	;;^UTILITY(U,$J,"DIBT",526,2,2)
	;;=399.5^.01^EFFECTIVE DATE^^
	;;^UTILITY(U,$J,"DIBT",526,2,2,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",526,2,2,"F")
	;;=2891000.99999
	;;^UTILITY(U,$J,"DIBT",526,2,2,"IX")
	;;=^DGCR(399.5,"B",^DGCR(399.5,^2
	;;^UTILITY(U,$J,"DIBT",526,2,2,"T")
	;;=z
	;;^UTILITY(U,$J,"DIBT",526,2,3)
	;;=399.5^^BILLING BEDSECTION^".02^;S2
	;;^UTILITY(U,$J,"DIBT",526,2,3,"CM")
	;;=S Y(1)=$S($D(^DGCR(399.5,D0,0)):^(0),1:"") S X=$S('$D(^DGCR(399.1,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) I D0>0 S X(3)=X
	;;^UTILITY(U,$J,"DIBT",526,2,4)
	;;=399.5^.05^ACTIVE^^
	;;^UTILITY(U,$J,"DIBT",526,2,5)
	;;=399.5^^REVENUE CODE^".03^
	;;^UTILITY(U,$J,"DIBT",526,2,5,"CM")
	;;=S Y(1)=$S($D(^DGCR(399.5,D0,0)):^(0),1:"") S X=$S('$D(^DGCR(399.2,+$P(Y(1),U,3),0)):"",1:$P(^(0),U,1)) I D0>0 S X(5)=X
	;;^UTILITY(U,$J,"DIBT",526,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIBT",526,"%D",1,0)
	;;=Billing Rates List.
	;;^UTILITY(U,$J,"DIBT",642,0)
	;;=IB INCOMPLETE^2910318.1059^^350^^^2920708^
	;;^UTILITY(U,$J,"DIBT",642,2,1)
	;;=350^.05^STATUS^]^
	;;^UTILITY(U,$J,"DIBT",642,2,1,"F")
	;;=.99999
	;;^UTILITY(U,$J,"DIBT",642,2,1,"IX")
	;;=^IB("AC",^IB(^2
	;;^UTILITY(U,$J,"DIBT",642,2,1,"T")
	;;=2
	;;^UTILITY(U,$J,"DIBT",642,2,2)
	;;=350^^PATIENT^".02^
	;;^UTILITY(U,$J,"DIBT",642,2,2,"CM")
	;;=S Y(1)=$S($D(^IB(D0,0)):^(0),1:"") S X=$S('$D(^DPT(+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) I D0>0 S X(2)=X
	;;^UTILITY(U,$J,"DIBT",642,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIBT",642,"%D",1,0)
	;;=Integrated Billing Action List of entries with a Status of Incomplete.
	;;^UTILITY(U,$J,"DIBT",646,0)
	;;=IB CLK PROD^2920521.1136^@^399^10882^@^2940315
	;;^UTILITY(U,$J,"DIBT",646,2,1)
	;;=399^1^DATE ENTERED^'^;"Date Entered"
	;;^UTILITY(U,$J,"DIBT",646,2,1,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",646,2,1,"F")
	;;=2910100.99999^2910101
	;;^UTILITY(U,$J,"DIBT",646,2,1,"IX")
	;;=^DGCR(399,"APD",^DGCR(399,^2
	;;^UTILITY(U,$J,"DIBT",646,2,1,"T")
	;;=z^
	;;^UTILITY(U,$J,"DIBT",646,2,2)
	;;=399^^ENTERED/EDITED BY^+@"2^;"Clerk Entered By";S1
	;;^UTILITY(U,$J,"DIBT",646,2,2,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",646,2,2,"CM")
	;;=S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$S('$D(^VA(200,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) I D0>0 S X(2)=X
	;;^UTILITY(U,$J,"DIBT",646,2,2,"F")
	;;=.99999^1
	;;^UTILITY(U,$J,"DIBT",646,2,2,"T")
	;;=z^
	;;^UTILITY(U,$J,"DIBT",646,2,3)
	;;=399^^RATE TYPE^@".07^;"Rate Type";
	;;^UTILITY(U,$J,"DIBT",646,2,3,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",646,2,3,"CM")
	;;=S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$S('$D(^DGCR(399.3,+$P(Y(1),U,7),0)):"",1:$P(^(0),U,1)) I D0>0 S X(3)=X
	;;^UTILITY(U,$J,"DIBT",646,2,3,"F")
	;;=.99999^1
	;;^UTILITY(U,$J,"DIBT",646,2,3,"T")
	;;=z^
	;;^UTILITY(U,$J,"DIBT",646,2,4)
	;;=399^1^DATE ENTERED^^
	;;^UTILITY(U,$J,"DIBT",646,2,4,"IX")
	;;=^DGCR(399,"APD",^DGCR(399,^2
	;;^UTILITY(U,$J,"DIBT",646,"%D",0)
	;;=^^1^1^2920708^^^^
	;;^UTILITY(U,$J,"DIBT",646,"%D",1,0)
	;;=Clerk Productivity Report.
	;;^UTILITY(U,$J,"DIBT",802,0)
	;;=IB PRINT THRESHOLD^2930506.0933^@^354.3^1453^@^2931005
	;;^UTILITY(U,$J,"DIBT",802,2,1)
	;;=354.3^.02^TYPE^^;S1
	;;^UTILITY(U,$J,"DIBT",802,2,1,"IX")
	;;=^IBE(354.3,"AC",^IBE(354.3,^2
	;;^UTILITY(U,$J,"DIBT",802,2,2)
	;;=354.3^.01^DATE^^
	;;^UTILITY(U,$J,"DIBT",802,2,2,"ASK")
	;;=

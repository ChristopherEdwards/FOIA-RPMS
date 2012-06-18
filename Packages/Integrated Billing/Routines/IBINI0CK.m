IBINI0CK	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIBT",853,2,2,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",853,2,2,"F")
	;;=2931128.99999^T
	;;^UTILITY(U,$J,"DIBT",853,2,2,"T")
	;;=2931129.9999^T
	;;^UTILITY(U,$J,"DIBT",854,0)
	;;=IBNOTVER1^2931129.155^@^2^1453^@^2940309
	;;^UTILITY(U,$J,"DIBT",854,2,1)
	;;=2.312^^INSURANCE TYPE^'".01^
	;;^UTILITY(U,$J,"DIBT",854,2,1,2)
	;;=.312
	;;^UTILITY(U,$J,"DIBT",854,2,1,"CM")
	;;=S Y(1)=$S($D(^DPT(D0,.312,D1,0)):^(0),1:"") S X=$S('$D(^DIC(36,+$P(Y(1),U,1),0)):"",1:$P(^(0),U,1)) I D1>0 S X(1)=X
	;;^UTILITY(U,$J,"DIBT",854,2,1,"IX")
	;;=^DPT("AB",^DPT(^2
	;;^UTILITY(U,$J,"DIBT",854,2,2)
	;;=2.312^1.03^DATE LAST VERIFIED^@'^
	;;^UTILITY(U,$J,"DIBT",854,2,2,2)
	;;=.312
	;;^UTILITY(U,$J,"DIBT",854,2,2,"F")
	;;=?z^@
	;;^UTILITY(U,$J,"DIBT",854,2,2,"T")
	;;=@^@
	;;^UTILITY(U,$J,"DIBT",854,2,3)
	;;=2.312^1.01^DATE ENTERED^@'^
	;;^UTILITY(U,$J,"DIBT",854,2,3,2)
	;;=.312
	;;^UTILITY(U,$J,"DIBT",854,2,3,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",854,2,3,"F")
	;;=2931128.99999^T
	;;^UTILITY(U,$J,"DIBT",854,2,3,"T")
	;;=2931129.9999^T
	;;^UTILITY(U,$J,"DIBT",854,2,4)
	;;=2^.01^NAME^^
	;;^UTILITY(U,$J,"DIBT",854,2,4,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",854,2,4,"F")
	;;=@z^A
	;;^UTILITY(U,$J,"DIBT",854,2,4,"IX")
	;;=^DPT("B",^DPT(^2
	;;^UTILITY(U,$J,"DIBT",854,2,4,"T")
	;;=B^B
	;;^UTILITY(U,$J,"DIBT",877,0)
	;;=IBT LIST VISITS^2940124.0915^@^356^1453^@^2940318
	;;^UTILITY(U,$J,"DIBT",877,2,1)
	;;=356^.06^EPISODE DATE^]'^
	;;^UTILITY(U,$J,"DIBT",877,2,1,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",877,2,1,"F")
	;;=2940114.99999^T-9
	;;^UTILITY(U,$J,"DIBT",877,2,1,"IX")
	;;=^IBT(356,"D",^IBT(356,^2
	;;^UTILITY(U,$J,"DIBT",877,2,1,"T")
	;;=2940124.9999^T
	;;^UTILITY(U,$J,"DIBT",877,2,2)
	;;=356^^PATIENT^".02^
	;;^UTILITY(U,$J,"DIBT",877,2,2,"ASK")
	;;=
	;;^UTILITY(U,$J,"DIBT",877,2,2,"CM")
	;;=S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$S('$D(^DPT(+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) I D0>0 S X(2)=X
	;;^UTILITY(U,$J,"DIBT",877,2,2,"F")
	;;=@z^A
	;;^UTILITY(U,$J,"DIBT",877,2,2,"T")
	;;=ZZZ^ZZZ
	;;^UTILITY(U,$J,"DIE",318,0)
	;;=IB RATE EDIT^2920206.1418^^399.3^1453^^2931201
	;;^UTILITY(U,$J,"DIE",318,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",318,"%D",1,0)
	;;=Update Rate Type File.
	;;^UTILITY(U,$J,"DIE",318,"DR",1,399.3)
	;;=.01;.02;.04;.05;.08;.09;.03;.06;
	;;^UTILITY(U,$J,"DIE",319,0)
	;;=IB ACTIVATE^2880620^^399.2^^^2931201^
	;;^UTILITY(U,$J,"DIE",319,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",319,"%D",1,0)
	;;=Activate/inactivate revenue codes.
	;;^UTILITY(U,$J,"DIE",319,"DR",1,399.2)
	;;=2;
	;;^UTILITY(U,$J,"DIE",320,0)
	;;=IB MAIL^2880624^^399^^^^
	;;^UTILITY(U,$J,"DIE",320,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",320,"%D",1,0)
	;;=Enter/edit a bill's mailing address.
	;;^UTILITY(U,$J,"DIE",320,"DR",1,399)
	;;=104;105;106;107;108;109;
	;;^UTILITY(U,$J,"DIE",732,0)
	;;=IB EDIT SITE PARAM^2930204.0859^@^350.9^1453^@^2940112
	;;^UTILITY(U,$J,"DIE",732,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",732,"%D",1,0)
	;;=Enter/edit Integrated Billing Site Parameters.
	;;^UTILITY(U,$J,"DIE",732,"DR",1,350.9)
	;;=.02;.03;.07;.08;.09;.13;.14;.11;.12;
	;;^UTILITY(U,$J,"DIE",734,0)
	;;=IB EDIT CLEAR^2910304.0803^@^350.9^1453^@^2940314
	;;^UTILITY(U,$J,"DIE",734,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",734,"%D",1,0)
	;;=Clear Integrated Billing Filer Parameters.
	;;^UTILITY(U,$J,"DIE",734,"DR",1,350.9)
	;;=.04///@;.1///@;
	;;^UTILITY(U,$J,"DIE",1029,0)
	;;=IB REVCODE EDIT^2920917.1008^^399^0^^2920917
	;;^UTILITY(U,$J,"DIE",1029,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",1029,"%D",1,0)
	;;=Enter/Edit a bill's revenue code information.

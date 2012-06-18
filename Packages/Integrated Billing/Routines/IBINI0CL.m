IBINI0CL	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIE",1029,"DR",1,399)
	;;=D:$D(IBIFN) RCD^IBCU1;42;202;S:'X Y="@999";203;I $P(^DGCR(399,DA,"U1"),"^",11)="" S Y="@999";210;@999;
	;;^UTILITY(U,$J,"DIE",1029,"DR",2,399.042)
	;;=.01;.02;.03;.04;.05;I $P(^DGCR(399,DA,0),U,5)<3 S Y="@99";.06;I X="" S Y="@99";.07;@99;
	;;^UTILITY(U,$J,"DIE",1030,0)
	;;=IB BILLING CYCLE ADJUST^2920225.14^@^351^0^@^2940307
	;;^UTILITY(U,$J,"DIE",1030,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",1030,"%D",1,0)
	;;=Patient Billing Clock Maintenance, edit existing entry.
	;;^UTILITY(U,$J,"DIE",1030,"DR",1,351)
	;;=.03;.04;.05;I $P(^IBE(351,D0,0),"^",9)<91 S Y="@1";.06;I $P(^IBE(351,D0,0),"^",9)<181 S Y="@1";.07;I $P(^IBE(351,D0,0),"^",9)<271 S Y="@1";.08;@1;.09;15;
	;;^UTILITY(U,$J,"DIE",1031,0)
	;;=IB BILLING CYCLE ADD^2920225.1359^@^351^0^@^2940128
	;;^UTILITY(U,$J,"DIE",1031,"%D",0)
	;;=^^1^1^2920724^^^^
	;;^UTILITY(U,$J,"DIE",1031,"%D",1,0)
	;;=Patient Billing Clock Maintenance, new entry.
	;;^UTILITY(U,$J,"DIE",1031,"DR",1,351)
	;;=.03;.04;.05;I $P(^IBE(351,D0,0),"^",9)<91 S Y="@1";.06;I $P(^IBE(351,D0,0),"^",9)<181 S Y="@1";.07;I $P(^IBE(351,D0,0),"^",9)<271 S Y="@1";.08;@1;.09;
	;;^UTILITY(U,$J,"DIE",1034,0)
	;;=IB EDIT MCCR PARM^2940112.1455^^350.9^10882^@^2940318
	;;^UTILITY(U,$J,"DIE",1034,"%D",0)
	;;=^^1^1^2920708^
	;;^UTILITY(U,$J,"DIE",1034,"%D",1,0)
	;;=Enter/edit MCCR Site Parameters.
	;;^UTILITY(U,$J,"DIE",1034,"DR",1,350.9)
	;;=I '$D(IBDR) S IBDR="1,2,3,4,5";S:IBDR'["1" Y="@2";1.05;1.06;1.21;1.14;1.25;@2;S:IBDR'["2" Y="@3";1.01;1.02;1.08;@3;S:IBDR'["3" Y="@4";1.22;1.23;1.15;1.16;1.17;1.18;1.19;.12;1.28;.15;1.29;1.3;@4;S:IBDR'["4" Y="@5";1.1;1.2;1.04;1.31;
	;;^UTILITY(U,$J,"DIE",1034,"DR",1,350.9,1)
	;;=2.07;1.27;1.07;1.09;.09;.11;@5;S:IBDR'["5" Y="@99";1.26;2.01;2.02;2.03;2.04;2.05;2.06;@99;
	;;^UTILITY(U,$J,"DIE",1034,"ROU")
	;;=^IBXPAR
	;;^UTILITY(U,$J,"DIE",1034,"ROUOLD")
	;;=IBXPAR
	;;^UTILITY(U,$J,"DIE",1054,0)
	;;=IB STATUS^2920922.0906^^399^11416^^2940318
	;;^UTILITY(U,$J,"DIE",1054,"%D",0)
	;;=^^1^1^2920708^^
	;;^UTILITY(U,$J,"DIE",1054,"%D",1,0)
	;;=Edit a bill's status.
	;;^UTILITY(U,$J,"DIE",1054,"DIAB",1,1,399.044,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",1054,"DR",1,399)
	;;=S DIE("NO^")="OUTOK";I $D(IBYY) S Y=IBYY;@90;9;I $S(X="":1,X=1:1,1:0) S Y="@99";S IBX3=3;44;S Y="@99";@92;I $P(^DGCR(399,DA,"S"),"^",12)]"" S Y="@94";12///^S X=DT;S Y="@99";@94;14///^S X=DT;@99;K DIE("NO^");
	;;^UTILITY(U,$J,"DIE",1054,"DR",2,399.044)
	;;=.01
	;;^UTILITY(U,$J,"DIE",1054,"ROU")
	;;=^IBXST
	;;^UTILITY(U,$J,"DIE",1054,"ROUOLD")
	;;=IBXST
	;;^UTILITY(U,$J,"DIE",1059,0)
	;;=IB DEVICE^2940114.1615^@^353^10882^@^2940227
	;;^UTILITY(U,$J,"DIE",1059,"%D",0)
	;;=^^1^1^2920708^^
	;;^UTILITY(U,$J,"DIE",1059,"%D",1,0)
	;;=Bill Form Print Device Setup.
	;;^UTILITY(U,$J,"DIE",1059,"DR",1,353)
	;;=.01;.02;.03;
	;;^UTILITY(U,$J,"DIE",1071,0)
	;;=IB SCREEN1^2940216.1051^@^399^1453^@^2940317
	;;^UTILITY(U,$J,"DIE",1071,"%D",0)
	;;=^^1^1^2920708^^
	;;^UTILITY(U,$J,"DIE",1071,"%D",1,0)
	;;=Enter/Edit billing screen 1, demographic information.
	;;^UTILITY(U,$J,"DIE",1071,"DIAB",1,0,399,0)
	;;=.02:
	;;^UTILITY(U,$J,"DIE",1071,"DIAB",1,2,2.01,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",1071,"DR",1,399)
	;;=^2^DPT(^^S I(0,0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S D(0)=+X S X=$S(D(0)>0:D(0),1:"");S:IBDR20'["16" Y="@17";110;@17;S:IBDR20'["17" Y="@18";I $D(DFN) D DIS^DGRPDB W !!;.18;@18;D:IBDR20[11 DEM^VADPT;
	;;^UTILITY(U,$J,"DIE",1071,"DR",2,2)
	;;=S:IBDR20'["11" Y="@12";.03;@12;S:IBDR20'["12" Y="@13";1;@13;S:IBDR20'["13" Y="@14";.02;.05;@14;S:IBDR20'["14" Y="@15";1901;.361;@15;S:IBDR20'["15" Y="@16";.111;S:X="" Y=.114;.112;S:X="" Y=.114;.113;.114;.115;.1112;.117;.131;.12105;

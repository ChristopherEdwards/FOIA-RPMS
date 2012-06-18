IBINI0CS	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIE",1250,"%D",1,0)
	;;=Used to edit a marking area.
	;;^UTILITY(U,$J,"DIE",1250,"DIAB",4,0,357.91,0)
	;;=.02;T;REQ
	;;^UTILITY(U,$J,"DIE",1250,"DR",1,357.91)
	;;=.01;.03///NO;W !!,"Enter the characters that should be printed on the form, including spaces.",!!;.02R~T~;S IBDELETE=0;
	;;^UTILITY(U,$J,"DIE",1252,0)
	;;=IBDF PRINT MANAGER^2931110.0954^^409.95^^^2940208^
	;;^UTILITY(U,$J,"DIE",1252,"%D",0)
	;;=^^1^1^2940308^
	;;^UTILITY(U,$J,"DIE",1252,"%D",1,0)
	;;=Used to edit a clinic setup for the print manager.
	;;^UTILITY(U,$J,"DIE",1252,"DIAB",1,1,409.9502,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",1252,"DR",1,409.95)
	;;=.01;.02;.06;.03;.04;.05;.07;W !!,"You can now select reports that should be printed for the clinic",!,"IN ADDITION to the encounter forms that have been selected.",!;1;
	;;^UTILITY(U,$J,"DIE",1252,"DR",1,409.95,1)
	;;=W !!," You may enter reports that you DO NOT want to print for this clinic. Entering",!,"an EXCLUDED REPORT will prevent it from printing even if it is defined",!,"to print for the entire division.",!;2;
	;;^UTILITY(U,$J,"DIE",1252,"DR",2,409.9501)
	;;=.01;.02///FOR EVERY APPOINTMENT;
	;;^UTILITY(U,$J,"DIE",1252,"DR",2,409.9502)
	;;=.01
	;;^UTILITY(U,$J,"DIE",1253,0)
	;;=IBDF PRINT MANAGER^2930623.1304^^409.96^^^^
	;;^UTILITY(U,$J,"DIE",1253,"%D",0)
	;;=^^1^1^2940308^
	;;^UTILITY(U,$J,"DIE",1253,"%D",1,0)
	;;=Used to edit a division setup for the print manager.
	;;^UTILITY(U,$J,"DIE",1253,"DR",1,409.96)
	;;=.01;1;
	;;^UTILITY(U,$J,"DIE",1253,"DR",2,409.961)
	;;=.01;.02;
	;;^UTILITY(U,$J,"DIE",1256,0)
	;;=IBT UR INFO^2940128.1135^@^356^1453^@^2940128
	;;^UTILITY(U,$J,"DIE",1256,"DR",1,356)
	;;=.31;.25//NO;.24;1.07;.26//NONE;.27//NO;1.05;1.06;
	;;^UTILITY(U,$J,"DIE",1257,0)
	;;=IBT BILLING INFO^2940128.111^@^356^1453^@^2940228
	;;^UTILITY(U,$J,"DIE",1257,"DR",1,356)
	;;=.19;I X S Y="@99";.17;.12;.21;.22;.23;.28;.29;S Y="@999";@99;1.08;@999;
	;;^UTILITY(U,$J,"DIE",1258,0)
	;;=IBT PRECERT INFO^2930713.1439^@^356^1453^@^2930915
	;;^UTILITY(U,$J,"DIE",1258,"DR",1,356)
	;;=.14;.15;@99;
	;;^UTILITY(U,$J,"DIE",1259,0)
	;;=IBT ADD COMMENTS^2930726.0933^@^356.1^1453^@^2940201
	;;^UTILITY(U,$J,"DIE",1259,"DR",1,356.1)
	;;=11;
	;;^UTILITY(U,$J,"DIE",1260,0)
	;;=IBT STATUS CHANGE^2930810.0818^@^356.1^1453^@^2940226
	;;^UTILITY(U,$J,"DIE",1260,"DR",1,356.1)
	;;=.21;I X=3 S Y="@99";.2;@99;
	;;^UTILITY(U,$J,"DIE",1261,0)
	;;=IBT REVIEW INFO^2931221.0829^@^356.1^1453^@^2940202
	;;^UTILITY(U,$J,"DIE",1261,"DR",1,356.1)
	;;=.22;.01;.07;.23;
	;;^UTILITY(U,$J,"DIE",1262,0)
	;;=IBT SPECIAL UNIT^2930726.0956^@^356.1^1453^@^2930803
	;;^UTILITY(U,$J,"DIE",1262,"DR",1,356.1)
	;;=I $$TRTP^IBTRV($G(IBTRV))=40 S Y="@99";.08;.09;S Y="@999";@99;.13;@999;
	;;^UTILITY(U,$J,"DIE",1263,0)
	;;=IBT QUICK EDIT^2940207.0924^@^356.2^1453^@^2940311
	;;^UTILITY(U,$J,"DIE",1263,"DIAB",1,1,356.212,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",1263,"DIAB",1,1,356.213,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",1263,"DIAB",1,1,356.214,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",1263,"DIAB",2,0,356.2,6)
	;;=.08:
	;;^UTILITY(U,$J,"DIE",1263,"DR",1,356.2)
	;;=S DIE("NO^")="BACKOUTOK";.01;.04;I $$TCODE^IBTRC(DA)=70 S Y="@100";I $P(^IBT(356.2,DA,0),U,2) S Y="@200";@100;.05;@200;S IBTLST=$$LAST^IBTRC3($P(^IBT(356.2,DA,0),"^",2),DA);
	;;^UTILITY(U,$J,"DIE",1263,"DR",1,356.2,1)
	;;=N DFN S DFN=$P(^IBT(356.2,DA,0),U,5) I DFN W ! D DISP^IBCNS W !;1.05//^S X=$$HIPD^IBTRC3(DA,$G(IBTLST));S IBTLST=$$LAST^IBTRC3($P(^IBT(356.2,DA,0),"^",2),DA);I $$TCODE^IBTRC(DA)=70 S Y="@250";.06//^S X=$$PC^IBTRC3(DA,$G(IBTLST));

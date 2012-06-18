FHINI0N8	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"BUL",70,0)
	;;=FHDIDIP^Meal Pattern
	;;^UTILITY(U,$J,"BUL",70,1,0)
	;;=^^3^3^2940119^^^
	;;^UTILITY(U,$J,"BUL",70,1,1,0)
	;;=|1| on ward |2|, room |3| has no meal pattern for
	;;^UTILITY(U,$J,"BUL",70,1,2,0)
	;;=|4|
	;;^UTILITY(U,$J,"BUL",70,1,3,0)
	;;=Effective |5|
	;;^UTILITY(U,$J,"BUL",70,3,0)
	;;=^^1^1^2940119^^^
	;;^UTILITY(U,$J,"BUL",70,3,1,0)
	;;=Bulletin Ward Clinician when a Diet Order has no Meal Pattern.
	;;^UTILITY(U,$J,"BUL",70,4,0)
	;;=^3.64A^5^5
	;;^UTILITY(U,$J,"BUL",70,4,1,0)
	;;=1
	;;^UTILITY(U,$J,"BUL",70,4,1,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",70,4,1,1,1,0)
	;;=Patient name
	;;^UTILITY(U,$J,"BUL",70,4,2,0)
	;;=2
	;;^UTILITY(U,$J,"BUL",70,4,2,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",70,4,2,1,1,0)
	;;=Current ward
	;;^UTILITY(U,$J,"BUL",70,4,3,0)
	;;=3
	;;^UTILITY(U,$J,"BUL",70,4,3,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",70,4,3,1,1,0)
	;;=Room-Bed
	;;^UTILITY(U,$J,"BUL",70,4,4,0)
	;;=4
	;;^UTILITY(U,$J,"BUL",70,4,4,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",70,4,4,1,1,0)
	;;=Diet order
	;;^UTILITY(U,$J,"BUL",70,4,5,0)
	;;=5
	;;^UTILITY(U,$J,"BUL",70,4,5,1,0)
	;;=^^1^1^2940119^^^^
	;;^UTILITY(U,$J,"BUL",70,4,5,1,1,0)
	;;=Effective date of diet order
	;;^UTILITY(U,$J,"DIE",390,0)
	;;=FHINPR^2950428.0903^^114^479^^2950725
	;;^UTILITY(U,$J,"DIE",390,"%D",0)
	;;=^^1^1^2940120^^^
	;;^UTILITY(U,$J,"DIE",390,"%D",1,0)
	;;=This template is used to enter recipes into the recipe file.
	;;^UTILITY(U,$J,"DIE",390,"DR",1,114)
	;;=.01;8;2;3;4;5;6;7;11;12;9;10//NO;1;1.5;20;103;
	;;^UTILITY(U,$J,"DIE",390,"DR",2,114.01)
	;;=.01;S FHX1=+X,Y0=$G(^FHING(FHX1,0)),UNT=$P(Y0,"^",16);W !,"  Units should be ",$S(UNT="EACH":"EACH",UNT="OZ"!(UNT="LB"):"WEIGHTS",1:"VOLUMES");1;S FHX2=+X*$P(Y0,"^",22);
	;;^UTILITY(U,$J,"DIE",390,"DR",2,114.01,1)
	;;=2//^S X=$S($P(Y0,"^",21):$P($G(^FHNU($P(Y0,"^",21),0)),"^",1),1:"");S FHX3=$P($G(^FHNU(+X,0)),"^",5) S:FHX3&(FHX3'=100) FHX2=FHX2*FHX3/100;3//^S X=+$J(FHX2,0,3);
	;;^UTILITY(U,$J,"DIE",390,"DR",2,114.0103)
	;;=.01;1//1;
	;;^UTILITY(U,$J,"DIE",390,"DR",2,114.03)
	;;=.01;W !,"  Portion Size: ",$P(^FH(114,+X,0),U,3);1;
	;;^UTILITY(U,$J,"DIE",390,"DR",2,114.05)
	;;=.01;
	;;^UTILITY(U,$J,"DIE",391,0)
	;;=FHASE^2950313.103^^115.7^479^^2950718
	;;^UTILITY(U,$J,"DIE",391,"%D",0)
	;;=^^2^2^2920814^^^^
	;;^UTILITY(U,$J,"DIE",391,"%D",1,0)
	;;=This template is used to enter data relating to a dietetic
	;;^UTILITY(U,$J,"DIE",391,"%D",2,0)
	;;=encounter.
	;;^UTILITY(U,$J,"DIE",391,"DR",1,115.7)
	;;=2//^S X=$P(^VA(200,DUZ,0),"^",1);3//^S X="",DIC("S")="I Y>2";K DIC("S") S FHX1=$S($D(^FH(115.6,+X,0)):^(0),1:"") I $P(FHX1,"^",5)'="Y" S Y="@1";4;@1;S FHX2=$P(FHX1,"^",3) I '$P(FHX1,"^",4) S Y=6;5;I X="F" S FHX2=$P(FHX1,"^",4);
	;;^UTILITY(U,$J,"DIE",391,"DR",1,115.7,1)
	;;=6//^S X=FHX2;S FHX2=$P(FHX1,"^",6) I FHX2'="B" S Y="@3";7;S FHX2=X,Y="@4";@3;7///^S X=FHX2;@4;10;S FHX3="" I $P(FHX1,"^",7)'="Y" S Y=8 S:FHX2="I" FHX3=1;@5;20;D CNT^FHASE I $P(FHX4,"^",10)'="",FHX3 S $P(^FHEN(ASE,0),U,10)="";
	;;^UTILITY(U,$J,"DIE",391,"DR",1,115.7,2)
	;;=I FHX2="I",FHX3<1 W *7,!?5,"Must select a patient." S Y="@5";@8;8//^S X=FHX3;I X<FHX3 W *7,!?5,"Group Size cannot be less than total person count (default)" S $P(^FHEN(ASE,0),U,10)="",Y="@8";I $P(FHX4,"^",13)'="" S Y="@9";
	;;^UTILITY(U,$J,"DIE",391,"DR",1,115.7,3)
	;;=101////^S X=DUZ;@9;I $P(FHX4,"^",14)'="" S Y=0;102///^S X="NOW";
	;;^UTILITY(U,$J,"DIE",391,"DR",2,115.701)
	;;=.01;S DFN=X,DGT=DTE D ^DGPMSTAT S X9=$G(^DIC(42,+DG1,44));1////^S X=X9;I $P(FHX1,"^",8)'="Y" S Y="@6";2;@6;I $P(FHX1,"^",9)'="Y" S Y="@7";3;@7;I FHX2="I" S DI(1)=+DI(1),Y=0;
	;;^UTILITY(U,$J,"DIE",392,0)
	;;=FHADM4^2891117.1345^^117.1^^^2950721^
	;;^UTILITY(U,$J,"DIE",392,"%D",0)
	;;=^^2^2^2891120^
	;;^UTILITY(U,$J,"DIE",392,"%D",1,0)
	;;=This template is used to input daily data into the Staffing
	;;^UTILITY(U,$J,"DIE",392,"%D",2,0)
	;;=Guidelines file (117.1).
	;;^UTILITY(U,$J,"DIE",392,"DR",1,117.1)
	;;=1//^S X=$P(FHX1,"^",1);2//^S X=$P(FHX1,"^",2);3//^S X=$P(FHX1,"^",3);4//^S X=$P(FHX1,"^",4);5//^S X=$P(FHX1,"^",5);6;7;8;9;10;11;12;13;14;15;16;17;18;19;
	;;^UTILITY(U,$J,"DIE",393,0)
	;;=FHADM2^2900112.0935^^117^^^2951002^
	;;^UTILITY(U,$J,"DIE",393,"%D",0)
	;;=^^2^2^2910514^^
	;;^UTILITY(U,$J,"DIE",393,"%D",1,0)
	;;=This template is used to enter served meals data which is used
	;;^UTILITY(U,$J,"DIE",393,"%D",2,0)
	;;=to complete the worksheet for AMIS segment 224.
	;;^UTILITY(U,$J,"DIE",393,"DR",1,117)
	;;=S DIE("NO^")="" S:'$D(FHN("D")) Y="@1";1//^S X=FHN("D",0);2//^S X=FHN("D",1);@1;S:'$D(FHN("N")) Y="@2";4//^S X=FHN("N",0);5//^S X=FHN("N",1);@2;S:'$D(FHN("H")) Y="@3";7//^S X=FHN("H",0);8//^S X=FHN("H",1);@3;K DIE("NO^");30;31;32;

FHINI0N9	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIE",393,"DR",1,117,1)
	;;=33;34;35;36;37;38;39;40;41;42;43;44;45;46;47;50;51;
	;;^UTILITY(U,$J,"DIE",394,0)
	;;=FHSITEC1^2910820.1214^^119.9^^^2950705^
	;;^UTILITY(U,$J,"DIE",394,"%D",0)
	;;=^^2^2^2911210^^^^
	;;^UTILITY(U,$J,"DIE",394,"%D",1,0)
	;;=This template is used to enter the clinical site parameters for the
	;;^UTILITY(U,$J,"DIE",394,"%D",2,0)
	;;=Dietetic System.
	;;^UTILITY(U,$J,"DIE",394,"DIAB",1,1,119.9001,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",394,"DIAB",1,1,119.985,0)
	;;=ALL
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9)
	;;=W !!,"--- Clinical Site Parameters";W !!,"The assessment default units are used for determining";W !,"the units for inputs when units are not specified";W !,"and for determining which units are used for output";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,1)
	;;=W !,"on the assessment and screening forms. Either English";W !,"or metric may be selected.";W !;70;W !!,"The Screening form makes provision for a";W !,"site-selectable line being added to the form as the";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,2)
	;;=W !,"last line under the S: (or subjective) section.";W !,"If an entry is made, the user should consider the";W !,"indenting and column usage of the existing lines in";W !,"determining the line to be entered. Just press RETURN";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,3)
	;;=W !,"to bypass having this extra line.";W !;75;W !!,"A Nutrition Profile may optionally be printed following each";W !,"Screening form. Answer YES if you wish the profile printed,";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,4)
	;;=W !,"NO if you do not. Answer A (for Ask user) if you wish the user to be";W !,"prompted as to whether a profile will be printed.";W !;74;W !!,"In selecting laboratory results to be displayed, the";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,5)
	;;=W !,"program allows for the selection of the number of days";W !,"in the past for which data will be searched. Thus,";W !,"selecting 30 as a value will result in the most recent";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,6)
	;;=W !,"lab test results obtained in the last 30 days being displayed.";W !;71;W !!,"You should select only those laboratory tests in which";W !,"the clinical staff is typically interested. You will also";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,7)
	;;=W !,"be prompted as to whether you wish those results to be";W !,"printed on the Assessment report and the Screening form.";W !;80;W !!,"You should select only those drug classifications in";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,8)
	;;=W !,"which the clinical staff is typically interested.";W !,"In displaying prescribed drugs, the actual drug name";W !,"will appear, but the selection of drugs to be displayed";
	;;^UTILITY(U,$J,"DIE",394,"DR",1,119.9,9)
	;;=W !,"will be controlled by the drug classifications selected.";W !;85;
	;;^UTILITY(U,$J,"DIE",394,"DR",2,119.9001)
	;;=.01:4
	;;^UTILITY(U,$J,"DIE",394,"DR",2,119.985)
	;;=.01
	;;^UTILITY(U,$J,"DIE",395,0)
	;;=FHSEL^2920219.1217^^115^^^2950717^
	;;^UTILITY(U,$J,"DIE",395,"%D",0)
	;;=^^3^3^2930909^^
	;;^UTILITY(U,$J,"DIE",395,"%D",1,0)
	;;=This template is used to enter the food preferences for a patient.
	;;^UTILITY(U,$J,"DIE",395,"%D",2,0)
	;;=It will prompt for the quantity only if the selected preference
	;;^UTILITY(U,$J,"DIE",395,"%D",3,0)
	;;=is a 'Like' rather than a 'Dislike'.
	;;^UTILITY(U,$J,"DIE",395,"DR",1,115)
	;;=10;
	;;^UTILITY(U,$J,"DIE",395,"DR",2,115.09)
	;;=.01;S X9=$P($G(^FH(115.2,+X,0)),"^",2);1;S:X9="D" Y="@1";2//1;@1;
	;;^UTILITY(U,$J,"DIE",396,0)
	;;=FHCMSR^2920220.1546^^117.2^^^2950630^
	;;^UTILITY(U,$J,"DIE",396,"%D",0)
	;;=^^3^3^2920520^^^^
	;;^UTILITY(U,$J,"DIE",396,"%D",1,0)
	;;=This template is used to enter values into File 117.2, the
	;;^UTILITY(U,$J,"DIE",396,"%D",2,0)
	;;=Dietetic Cost of Meals file used to generate the Dietetic
	;;^UTILITY(U,$J,"DIE",396,"%D",3,0)
	;;=Cost of Meals Report.
	;;^UTILITY(U,$J,"DIE",396,"DR",1,117.2)
	;;=1//^S X=$P(FHX1,"^",1);2//^S X=$P(FHX1,"^",2);3//^S X=$P(FHX1,"^",3);4//^S X=$P(FHX1,"^",4);5//^S X=$P(FHX1,"^",5);6//^S X=$P(FHX1,"^",6);7;8;9;10;11;12;13;14;15;16;17;18;19//^S X=35;20//^S X=12;21//^S X=22;22//^S X=6;23//^S X=12;
	;;^UTILITY(U,$J,"DIE",396,"DR",1,117.2,1)
	;;=24//^S X=13;
	;;^UTILITY(U,$J,"DIE",396,"ROUOLD")
	;;=
	;;^UTILITY(U,$J,"DIPT",326,0)
	;;=FHNULST^2850412^^112^^^2950711^
	;;^UTILITY(U,$J,"DIPT",326,"%D",0)
	;;=^^1^1^2880516^
	;;^UTILITY(U,$J,"DIPT",326,"%D",1,0)
	;;=This template is used to print the nutrient data file.
	;;^UTILITY(U,$J,"DIPT",326,"F",1)
	;;=.01~1;C62~4;"QUICK";C69~2;"COMMON";C75~3;"GM/UNIT";C86;D1~4.2;C96;L30~4.4;"QUICK";C127~

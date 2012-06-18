FHINI0KJ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.011,2,21,1,0)
	;;=This field contains the age, in years, of the subject at the
	;;^DD(115.011,2,21,2,0)
	;;=time of the assessment.
	;;^DD(115.011,2,"DT")
	;;=2890702
	;;^DD(115.011,3,0)
	;;=HEIGHT^NJ4,1^^0;4^K:+X'=X!(X>96)!(X<12)!(X?.E1"."2N.N) X
	;;^DD(115.011,3,3)
	;;=Type a Number between 12 and 96, 1 Decimal Digit
	;;^DD(115.011,3,21,0)
	;;=^^1^1^2920521^^^
	;;^DD(115.011,3,21,1,0)
	;;=This field contains the height, in inches, of the subject.
	;;^DD(115.011,3,"DT")
	;;=2890705
	;;^DD(115.011,4,0)
	;;=HEIGHT PARAMETERS^S^S:STATED;K:KNEE HEIGHT;^0;5^Q
	;;^DD(115.011,4,21,0)
	;;=^^2^2^2920520^^^
	;;^DD(115.011,4,21,1,0)
	;;=This field contains parameters relating to height; in particular,
	;;^DD(115.011,4,21,2,0)
	;;=an S would mean stated rather than measured.
	;;^DD(115.011,4,"DT")
	;;=2900411
	;;^DD(115.011,5,0)
	;;=WEIGHT^NJ3,0^^0;6^K:+X'=X!(X>750)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.011,5,3)
	;;=Type a Number between 0 and 750, 0 Decimal Digits
	;;^DD(115.011,5,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,5,21,1,0)
	;;=This field contains the weight, in pounds, of the subject.
	;;^DD(115.011,5,"DT")
	;;=2900411
	;;^DD(115.011,6,0)
	;;=WEIGHT PARAMETERS^S^A:ANTHROPOMETRIC;S:STATED;^0;7^Q
	;;^DD(115.011,6,21,0)
	;;=^^2^2^2900411^^
	;;^DD(115.011,6,21,1,0)
	;;=This field contains parameters relating to weight; in particular,
	;;^DD(115.011,6,21,2,0)
	;;=an S would mean stated rather than measured.
	;;^DD(115.011,6,"DT")
	;;=2900411
	;;^DD(115.011,7,0)
	;;=DATE WEIGHT TAKEN^D^^0;8^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.011,7,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.011,7,21,1,0)
	;;=This is the date the weight was determined.
	;;^DD(115.011,7,"DT")
	;;=2890705
	;;^DD(115.011,8,0)
	;;=USUAL WEIGHT^NJ3,0^^0;9^K:+X'=X!(X>750)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.011,8,3)
	;;=Type a Number between 0 and 750, 0 Decimal Digits
	;;^DD(115.011,8,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,8,21,1,0)
	;;=This is the usual weight, in pounds, of the subject.
	;;^DD(115.011,8,"DT")
	;;=2900411
	;;^DD(115.011,9,0)
	;;=IDEAL BODY WEIGHT^NJ3,0^^0;10^K:+X'=X!(X>750)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.011,9,3)
	;;=Type a Number between 0 and 750, 0 Decimal Digits
	;;^DD(115.011,9,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,9,21,1,0)
	;;=This is the ideal body weight, in pounds, of the subject.
	;;^DD(115.011,9,"DT")
	;;=2900411
	;;^DD(115.011,10,0)
	;;=FRAME SIZE^S^S:SMALL;M:MEDIUM;L:LARGE;^0;11^Q
	;;^DD(115.011,10,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,10,21,1,0)
	;;=This is the frame size of the individual, expressed as Small,
	;;^DD(115.011,10,21,2,0)
	;;=Medium or Large.
	;;^DD(115.011,10,"DT")
	;;=2890705
	;;^DD(115.011,11,0)
	;;=AMPUTATION %^NJ4,1^^0;12^K:+X'=X!(X>50)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(115.011,11,3)
	;;=Type a Number between 0 and 50, 1 Decimal Digit
	;;^DD(115.011,11,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,11,21,1,0)
	;;=This is the percentage of total body weight missing due to
	;;^DD(115.011,11,21,2,0)
	;;=amputations.
	;;^DD(115.011,11,"DT")
	;;=2890705
	;;^DD(115.011,15,0)
	;;=KCAL REQUIRED^NJ5,0^^0;16^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.011,15,3)
	;;=Type a Number between 0 and 10000, 0 Decimal Digits
	;;^DD(115.011,15,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,15,21,1,0)
	;;=This is the total energy needs of the patient expressed in
	;;^DD(115.011,15,21,2,0)
	;;=calories.
	;;^DD(115.011,15,"DT")
	;;=2890705
	;;^DD(115.011,16,0)
	;;=PROTEIN (GM) REQUIRED^NJ3,0^^0;17^K:+X'=X!(X>400)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.011,16,3)
	;;=Type a Number between 0 and 400, 0 Decimal Digits
	;;^DD(115.011,16,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.011,16,21,1,0)
	;;=This is the protein requirements of the person.
	;;^DD(115.011,16,"DT")
	;;=2890705
	;;^DD(115.011,17,0)
	;;=FLUID (ML/DAY) REQUIRED^NJ5,0^^0;18^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.011,17,3)
	;;=Type a Number between 0 and 10000, 0 Decimal Digits
	;;^DD(115.011,17,21,0)
	;;=^^1^1^2891121^^
	;;^DD(115.011,17,21,1,0)
	;;=This is the fluid requirements, in ml/day, of the person.
	;;^DD(115.011,17,"DT")
	;;=2890705
	;;^DD(115.011,18,0)
	;;=RISK CATEGORY^P115.4'^FH(115.4,^0;19^Q
	;;^DD(115.011,18,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,18,21,1,0)
	;;=This is a pointer to the Nutrition Status file (115.4) indicating
	;;^DD(115.011,18,21,2,0)
	;;=the current status of the patient for this assessment.
	;;^DD(115.011,18,"DT")
	;;=2890705
	;;^DD(115.011,19,0)
	;;=NUTRITION PROBLEM^P115.3'^FH(115.3,^0;20^Q
	;;^DD(115.011,19,21,0)
	;;=^^3^3^2891121^
	;;^DD(115.011,19,21,1,0)
	;;=This is a pointer to the Nutrition Classification file (115.3)

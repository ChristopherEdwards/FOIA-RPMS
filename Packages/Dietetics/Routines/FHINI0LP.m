FHINI0LP	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.3,45,"DT")
	;;=2930706
	;;^DD(117.3,46,0)
	;;=MG NA^NJ5,0^^3;8^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,46,3)
	;;=Type a Number between 0 and 99999, 0 Decimal Digits
	;;^DD(117.3,46,21,0)
	;;=^^2^2^2930706^^^
	;;^DD(117.3,46,21,1,0)
	;;=This field contains the milligrams Sodium taken from Nutritive
	;;^DD(117.3,46,21,2,0)
	;;=Analysis Average.
	;;^DD(117.3,46,"DT")
	;;=2930706
	;;^DD(117.3,47,0)
	;;=STAFF CERT DIAB ED (CDE)^NJ2,0^^1;14^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,47,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,47,21,0)
	;;=^^2^2^2930129^^^^
	;;^DD(117.3,47,21,1,0)
	;;=This field contains the number of the Specialty Staff Certified Diabetes
	;;^DD(117.3,47,21,2,0)
	;;=Educators (CDE) at your facility.
	;;^DD(117.3,47,"DT")
	;;=2930129
	;;^DD(117.3,48,0)
	;;=STAFF CERT IN NUTR SUPP^NJ2,0^^1;15^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,48,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,48,21,0)
	;;=^^2^2^2930129^^^^
	;;^DD(117.3,48,21,1,0)
	;;=This field contains the number of Specialty Staff Certified in Nutrition
	;;^DD(117.3,48,21,2,0)
	;;=Support at your facility.
	;;^DD(117.3,48,"DT")
	;;=2930129
	;;^DD(117.3,49,0)
	;;=STAFF REG CLIN DIE TECH^NJ2,0^^1;16^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,49,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,49,21,0)
	;;=^^2^2^2930129^^
	;;^DD(117.3,49,21,1,0)
	;;=This field contains the number of Specialty Staff Registered
	;;^DD(117.3,49,21,2,0)
	;;=Clinical Dietetic Technicians at your facility.
	;;^DD(117.3,49,"DT")
	;;=2930129
	;;^DD(117.3,50,0)
	;;=STAFF W/CLIN PRIVILEGES^NJ2,0^^1;17^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,50,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,50,21,0)
	;;=^^2^2^2930129^
	;;^DD(117.3,50,21,1,0)
	;;=This field contains the number of Specialty Staff with Clinical
	;;^DD(117.3,50,21,2,0)
	;;=Privileges (not scope of practice).
	;;^DD(117.3,50,"DT")
	;;=2930129
	;;^DD(117.3,51,0)
	;;=DO YOU USE COOK CHILL FOODS?^S^Y:YES;N:NO;^0;21^Q
	;;^DD(117.3,51,21,0)
	;;=^^2^2^2930204^
	;;^DD(117.3,51,21,1,0)
	;;=This field contains a Y or N on whether the Dietitians use Cook
	;;^DD(117.3,51,21,2,0)
	;;=Chill Foods.
	;;^DD(117.3,51,"DT")
	;;=2930204
	;;^DD(117.3,52,0)
	;;=SELECT 1 OR 2^S^1:LESS AND EQUAL 25% OF MENU ITEMS;2:GREATER THAN 25% OF MENU ITEMS;^0;22^Q
	;;^DD(117.3,52,21,0)
	;;=^^3^3^2930204^
	;;^DD(117.3,52,21,1,0)
	;;=This field will be asked if the Dietitians use Cook Chill Foods.
	;;^DD(117.3,52,21,2,0)
	;;=It contains a 1 for less and equal to 25% of menu items cook
	;;^DD(117.3,52,21,3,0)
	;;=chilled or a 2 for greater than 25% of menu items cook chilled.
	;;^DD(117.3,52,"DT")
	;;=2930204
	;;^DD(117.3,53,0)
	;;=FUNDED NUTRITION RESEARCH?^S^Y:YES;N:NO;^0;23^Q
	;;^DD(117.3,53,21,0)
	;;=^^2^2^2930204^
	;;^DD(117.3,53,21,1,0)
	;;=This field contains a Y or N on whether the Dietitians have
	;;^DD(117.3,53,21,2,0)
	;;=Funded Nutrition Research.
	;;^DD(117.3,53,"DT")
	;;=2930204
	;;^DD(117.3,54,0)
	;;=ASSIGNED CLINICAL FTEE^NJ4,1^^0;24^K:+X'=X!(X>99.9)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(117.3,54,3)
	;;=Type a Number between 0 and 99.9, 1 Decimal Digit
	;;^DD(117.3,54,21,0)
	;;=^^2^2^2930204^
	;;^DD(117.3,54,21,1,0)
	;;=This field contains the Assigned Clinical FTEE on the Funded
	;;^DD(117.3,54,21,2,0)
	;;=Nutrition Research.
	;;^DD(117.3,54,"DT")
	;;=2930204
	;;^DD(117.3,55,0)
	;;=UNFUNDED NUTRITION RESEARCH?^S^Y:YES;N:NO;^0;25^Q
	;;^DD(117.3,55,21,0)
	;;=^^2^2^2930204^
	;;^DD(117.3,55,21,1,0)
	;;=This field contains a Y or a N on whether the Dietitians have
	;;^DD(117.3,55,21,2,0)
	;;=Unfunded Nutrition Research.
	;;^DD(117.3,55,"DT")
	;;=2930204
	;;^DD(117.3,56,0)
	;;=AREAS OF RESEARCH^117.356S^^AREA;0
	;;^DD(117.3,56,21,0)
	;;=^^2^2^2930204^
	;;^DD(117.3,56,21,1,0)
	;;=This multiple contains a list of Areas of Research under the
	;;^DD(117.3,56,21,2,0)
	;;=Unfunded Nutrition Research.
	;;^DD(117.3,57,0)
	;;=ASSIGNED TOTAL CLINICAL FTEE^NJ5,1^^0;26^K:+X'=X!(X>999.9)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(117.3,57,3)
	;;=Type a Number between 0 and 999.9, 1 Decimal Digit
	;;^DD(117.3,57,21,0)
	;;=^^3^3^2930204^
	;;^DD(117.3,57,21,1,0)
	;;=This field contains the Assigned Total Clinical FTEE of the
	;;^DD(117.3,57,21,2,0)
	;;=total of all the Areas of Research selected under the Unfunded
	;;^DD(117.3,57,21,3,0)
	;;=Nutrition Research.
	;;^DD(117.3,57,"DT")
	;;=2930204
	;;^DD(117.3,58,0)
	;;=APPETIZING^117.358^^APP;0
	;;^DD(117.3,58,21,0)
	;;=^^3^3^2931228^^^^
	;;^DD(117.3,58,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five

FHINI0LO	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.3,30,21,3,0)
	;;=include the diet communications personnel.
	;;^DD(117.3,30,"DT")
	;;=2920130
	;;^DD(117.3,31,0)
	;;=SUPERVISORY FTEE^NJ7,3^^1;10^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.3,31,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.3,31,21,0)
	;;=^^2^2^2950223^^^
	;;^DD(117.3,31,21,1,0)
	;;=This field contains the FTEE of all the supervisory cooks and the
	;;^DD(117.3,31,21,2,0)
	;;=supervisory food service workers.
	;;^DD(117.3,31,"DT")
	;;=2920130
	;;^DD(117.3,31.5,0)
	;;=MODIFIED DIET SNAPSHOT DATE^D^^1;12^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(117.3,31.5,21,0)
	;;=^^3^3^2920722^^^^
	;;^DD(117.3,31.5,21,1,0)
	;;=This field contains the Modified Diet Snapshot date for building the
	;;^DD(117.3,31.5,21,2,0)
	;;=list of dates in Tabulating the total Modified Diet and calculating
	;;^DD(117.3,31.5,21,3,0)
	;;=the average of a week for each quarter.
	;;^DD(117.3,31.5,"DT")
	;;=2920310
	;;^DD(117.3,31.6,0)
	;;=UNS/INT HOURS^NJ6,2^^1;13^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.3,31.6,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.3,31.6,21,0)
	;;=^^2^2^2921125^
	;;^DD(117.3,31.6,21,1,0)
	;;=This field contains both the number of unscheduled hours and
	;;^DD(117.3,31.6,21,2,0)
	;;=intermittent hours worked by measured personnel.
	;;^DD(117.3,31.6,"DT")
	;;=2921125
	;;^DD(117.3,32,0)
	;;=TOTAL COST PER DIEM^117.332^^COST;0
	;;^DD(117.3,32,21,0)
	;;=^^1^1^2920820^^^^
	;;^DD(117.3,32,21,1,0)
	;;=This multiple contains the Cost Per Diem and Cost Per Meal.
	;;^DD(117.3,32,"DT")
	;;=2920212
	;;^DD(117.3,38,0)
	;;=DIETETIC EQUIPMENT^117.338P^^EQUI;0
	;;^DD(117.3,38,12)
	;;=SELECT ONLY THE DIETETIC SERVICE EQUIPMENT.
	;;^DD(117.3,38,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""E"""
	;;^DD(117.3,38,21,0)
	;;=^^1^1^2950223^^^^
	;;^DD(117.3,38,21,1,0)
	;;=This multiple contains the Dietetic Equipment available.
	;;^DD(117.3,38,"DT")
	;;=2920915
	;;^DD(117.3,39,0)
	;;=TOTAL CMR EQUIPMENT INV COST^NJ9,0^^3;1^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,39,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(117.3,39,21,0)
	;;=^^2^2^2930128^
	;;^DD(117.3,39,21,1,0)
	;;=This field is the total Consolidated Memorandum Report (CMR) Equipment
	;;^DD(117.3,39,21,2,0)
	;;=inventory Cost.
	;;^DD(117.3,39,"DT")
	;;=2930128
	;;^DD(117.3,40,0)
	;;=NUTRITIVE ANALYSIS DATE^D^^3;2^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(117.3,40,21,0)
	;;=^^2^2^2930128^^
	;;^DD(117.3,40,21,1,0)
	;;=This field contains the date the Nutritive Analysis Average for
	;;^DD(117.3,40,21,2,0)
	;;=one week regular menu was taken.
	;;^DD(117.3,40,"DT")
	;;=2930128
	;;^DD(117.3,41,0)
	;;=CALORIES^NJ4,0^^3;3^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,41,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117.3,41,21,0)
	;;=^^2^2^2930128^
	;;^DD(117.3,41,21,1,0)
	;;=This field contains the amount of Calories taken from the Nutritive
	;;^DD(117.3,41,21,2,0)
	;;=Average of one week regular menu.
	;;^DD(117.3,41,"DT")
	;;=2930128
	;;^DD(117.3,42,0)
	;;=% CHO^NJ2,0^^3;4^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,42,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,42,21,0)
	;;=^^2^2^2930128^^
	;;^DD(117.3,42,21,1,0)
	;;=This field contains the percentage Carbohydrates taken from the
	;;^DD(117.3,42,21,2,0)
	;;=Nutritive Analysis Average of one week regular menu.
	;;^DD(117.3,42,"DT")
	;;=2930128
	;;^DD(117.3,43,0)
	;;=% PRO^NJ2,0^^3;5^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,43,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,43,21,0)
	;;=^^2^2^2930128^
	;;^DD(117.3,43,21,1,0)
	;;=This field contains the percentage Protein taken from the Nutritive
	;;^DD(117.3,43,21,2,0)
	;;=Analysis Average of one week regular menu.
	;;^DD(117.3,43,"DT")
	;;=2930128
	;;^DD(117.3,44,0)
	;;=% FAT^NJ2,0^^3;6^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,44,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(117.3,44,21,0)
	;;=^^2^2^2930128^
	;;^DD(117.3,44,21,1,0)
	;;=This field contains the percentage Fat taken from the Nutritive
	;;^DD(117.3,44,21,2,0)
	;;=Analysis Average of one week regular menu.
	;;^DD(117.3,44,"DT")
	;;=2930128
	;;^DD(117.3,45,0)
	;;=MG CHOL^NJ3,0^^3;7^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,45,3)
	;;=Type a Number between 0 and 999, 0 Decimal Digits
	;;^DD(117.3,45,21,0)
	;;=^^2^2^2930706^^^
	;;^DD(117.3,45,21,1,0)
	;;=This field contains the milligrams Cholesterol taken from the Nutritive
	;;^DD(117.3,45,21,2,0)
	;;=Analysis Average of one week regular menu.

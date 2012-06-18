FHINI0LQ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.3,58,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question one
	;;^DD(117.3,58,21,3,0)
	;;=of the Dietetic Survey on whether the food looked attractive, appetizing.
	;;^DD(117.3,59,0)
	;;=TASTE^117.359^^TAS;0
	;;^DD(117.3,59,21,0)
	;;=^^3^3^2931228^^
	;;^DD(117.3,59,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,59,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question two
	;;^DD(117.3,59,21,3,0)
	;;=of the Dietetic Survey on whether the food tastes good.
	;;^DD(117.3,60,0)
	;;=TEMPERATURE^117.31^^TEM;0
	;;^DD(117.3,60,21,0)
	;;=^^3^3^2931228^^^^
	;;^DD(117.3,60,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,60,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question three
	;;^DD(117.3,60,21,3,0)
	;;=of the Dietetic Survey on the temperature of the food.
	;;^DD(117.3,60,22)
	;;=
	;;^DD(117.3,61,0)
	;;=VARIETY^117.361^^VAR;0
	;;^DD(117.3,61,21,0)
	;;=^^3^3^2931228^^
	;;^DD(117.3,61,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,61,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question
	;;^DD(117.3,61,21,3,0)
	;;=four of the Dietetic Survey on the variety of foods served.
	;;^DD(117.3,62,0)
	;;=CLEANLINESS^117.362^^CLN;0
	;;^DD(117.3,62,21,0)
	;;=^^4^4^2931228^
	;;^DD(117.3,62,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,62,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question five
	;;^DD(117.3,62,21,3,0)
	;;=of the Dietetic Survey on whether the dishes, cups, and utensils
	;;^DD(117.3,62,21,4,0)
	;;=were clean.
	;;^DD(117.3,63,0)
	;;=COURTEOUS^117.363^^CRS;0
	;;^DD(117.3,63,21,0)
	;;=^^4^4^2931228^
	;;^DD(117.3,63,21,1,0)
	;;=This multiple contains the number surveyed in regards to the five
	;;^DD(117.3,63,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question
	;;^DD(117.3,63,21,3,0)
	;;=six of the Dietetic Survey on whether the Dietetic Service staff
	;;^DD(117.3,63,21,4,0)
	;;=were courteous.
	;;^DD(117.3,64,0)
	;;=TIME^117.364^^TIM;0
	;;^DD(117.3,64,21,0)
	;;=^^3^3^2931228^^
	;;^DD(117.3,64,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,64,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question seven
	;;^DD(117.3,64,21,3,0)
	;;=of the Dietetic Survey on whether there was adequate time to eat.
	;;^DD(117.3,65,0)
	;;=INFO^117.365^^INF;0
	;;^DD(117.3,65,21,0)
	;;=^^4^4^2931228^^
	;;^DD(117.3,65,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,65,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question eight
	;;^DD(117.3,65,21,3,0)
	;;=of the Dietetic Survey on the diet information given by the
	;;^DD(117.3,65,21,4,0)
	;;=dietitian/dietetic technician.
	;;^DD(117.3,66,0)
	;;=OVERALL^117.366^^OVA;0
	;;^DD(117.3,66,21,0)
	;;=^^3^3^2931228^^^^
	;;^DD(117.3,66,21,1,0)
	;;=This multiple contains the numbers surveyed in regards to the five
	;;^DD(117.3,66,21,2,0)
	;;=ratings, Very Good, Good, Average, Fair, and Poor, for question nine
	;;^DD(117.3,66,21,3,0)
	;;=of the Dietetic Survey on the overall quality of the food service.
	;;^DD(117.31,0)
	;;=TEMPERATURE SUB-FIELD^^6^7
	;;^DD(117.31,0,"DT")
	;;=2931223
	;;^DD(117.31,0,"IX","B",117.31,.01)
	;;=
	;;^DD(117.31,0,"NM","TEMPERATURE")
	;;=
	;;^DD(117.31,0,"UP")
	;;=117.3
	;;^DD(117.31,.01,0)
	;;=TEMPERATURE NUMBER^NJ3,0X^^0;1^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(117.31,.01,1,0)
	;;=^.1
	;;^DD(117.31,.01,1,1,0)
	;;=117.31^B
	;;^DD(117.31,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"TEM","B",$E(X,1,30),DA)=""
	;;^DD(117.31,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"TEM","B",$E(X,1,30),DA)
	;;^DD(117.31,.01,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(117.31,.01,21,0)
	;;=^^2^2^2931223^
	;;^DD(117.31,.01,21,1,0)
	;;=This field contains a sequential number assigned to question three
	;;^DD(117.31,.01,21,2,0)
	;;=of the Dietetic Survey and has no meaning.
	;;^DD(117.31,.01,"DT")
	;;=2931223
	;;^DD(117.31,1,0)
	;;=GM&S^FX^^0;2^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.31,1,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.31,1,4)
	;;=D HEL^FHADR9
	;;^DD(117.31,1,21,0)
	;;=^^2^2^2931228^^^
	;;^DD(117.31,1,21,1,0)
	;;=This is a rating string containing numbers surveyed in GM&S with the
	;;^DD(117.31,1,21,2,0)
	;;=ratings specified in front of them on question three of the survey.

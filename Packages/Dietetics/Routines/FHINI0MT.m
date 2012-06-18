FHINI0MT	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.72)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.7211,10,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,10,"DT")
	;;=2870716
	;;^DD(119.7211,11,0)
	;;=MONDAY CENSUS PERCENTAGE^NJ5,1^^0;3^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,11,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,11,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,11,21,1,0)
	;;=This field contains the % of total census on Mondays for which this
	;;^DD(119.7211,11,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,11,"DT")
	;;=2870716
	;;^DD(119.7211,12,0)
	;;=TUESDAY CENSUS PERCENTAGE^NJ5,1^^0;4^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,12,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,12,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,12,21,1,0)
	;;=This field contains the % of total census on Tuesdays for which this
	;;^DD(119.7211,12,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,12,"DT")
	;;=2870716
	;;^DD(119.7211,13,0)
	;;=WEDNESDAY CENSUS PERCENTAGE^NJ5,1^^0;5^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,13,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,13,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,13,21,1,0)
	;;=This field contains the % of total census on Wednesdays for which this
	;;^DD(119.7211,13,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,13,"DT")
	;;=2870716
	;;^DD(119.7211,14,0)
	;;=THURSDAY CENSUS PERCENTAGE^NJ5,1^^0;6^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,14,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,14,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,14,21,1,0)
	;;=This field contains the % of total census on Thursdays for which this
	;;^DD(119.7211,14,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,14,"DT")
	;;=2870716
	;;^DD(119.7211,15,0)
	;;=FRIDAY CENSUS PERCENTAGE^NJ5,1^^0;7^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,15,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,15,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,15,21,1,0)
	;;=This field contains the % of total census on Fridays for which this
	;;^DD(119.7211,15,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,15,"DT")
	;;=2870716
	;;^DD(119.7211,16,0)
	;;=SATURDAY CENSUS PERCENTAGE^NJ5,1^^0;8^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,16,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,16,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,16,21,1,0)
	;;=This field contains the % of total census on Saturdays for which this
	;;^DD(119.7211,16,21,2,0)
	;;=production diet is to be forecast.
	;;^DD(119.7211,16,"DT")
	;;=2870716
	;;^DD(119.722,0)
	;;=CENSUS DATE SUB-FIELD^^5^5
	;;^DD(119.722,0,"DT")
	;;=2920108
	;;^DD(119.722,0,"NM","CENSUS DATE")
	;;=
	;;^DD(119.722,0,"UP")
	;;=119.72
	;;^DD(119.722,.01,0)
	;;=CENSUS DATE^DX^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=X
	;;^DD(119.722,.01,1,0)
	;;=^.1^^0
	;;^DD(119.722,.01,21,0)
	;;=^^2^2^2920220^
	;;^DD(119.722,.01,21,1,0)
	;;=This is the date for which the forecast census and actual census
	;;^DD(119.722,.01,21,2,0)
	;;=are tabulated.
	;;^DD(119.722,.01,"DT")
	;;=2920108
	;;^DD(119.722,1,0)
	;;=FORECAST CENSUS^NJ4,0^^0;2^K:+X'=X!(X>5000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.722,1,3)
	;;=Type a Number between 0 and 5000, 0 Decimal Digits
	;;^DD(119.722,1,21,0)
	;;=^^4^4^2920108^
	;;^DD(119.722,1,21,1,0)
	;;=This is the calculated forecast census for wards served by this
	;;^DD(119.722,1,21,2,0)
	;;=Service Point. It should be noted that some of these wards may
	;;^DD(119.722,1,21,3,0)
	;;=have only a small percentage of their patients served by the
	;;^DD(119.722,1,21,4,0)
	;;=Service Point.
	;;^DD(119.722,1,"DT")
	;;=2920108
	;;^DD(119.722,2,0)
	;;=ACTUAL CENSUS^NJ4,0^^0;3^K:+X'=X!(X>5000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.722,2,3)
	;;=Type a Number between 0 and 5000, 0 Decimal Digits
	;;^DD(119.722,2,21,0)
	;;=^^2^2^2920108^
	;;^DD(119.722,2,21,1,0)
	;;=This field contains the actual census of the wards served by this
	;;^DD(119.722,2,21,2,0)
	;;=Service Point based upon the MAS ward census values.
	;;^DD(119.722,2,"DT")
	;;=2920108
	;;^DD(119.722,3,0)
	;;=CORRECTED FORECAST^NJ4,0^^0;4^K:+X'=X!(X>5000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.722,3,3)
	;;=Type a Number between 0 and 5000, 0 Decimal Digits
	;;^DD(119.722,3,21,0)
	;;=^^3^3^2920108^
	;;^DD(119.722,3,21,1,0)
	;;=This field contains the corrected forecast which is the forecast
	;;^DD(119.722,3,21,2,0)
	;;=census corrected by applying the various percentages for tray,
	;;^DD(119.722,3,21,3,0)
	;;=cafeteria, and dining room utilization.
	;;^DD(119.722,3,"DT")
	;;=2920108
	;;^DD(119.722,5,0)
	;;=DATE OF LAST FORECAST^D^^0;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X

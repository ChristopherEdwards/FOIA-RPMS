FHINI0MS	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.72)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.721,22,0)
	;;=ADD. THURSDAY BREAKFAST^NJ4,0^^0;14^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,22,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,22,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,22,21,1,0)
	;;=This is the number of additional Thursday breakfast meals which are
	;;^DD(119.721,22,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,23,0)
	;;=ADD. THURSDAY NOON^NJ4,0^^0;15^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,23,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,23,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,23,21,1,0)
	;;=This is the number of additional Thursday noon meals which are
	;;^DD(119.721,23,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,24,0)
	;;=ADD. THURSDAY EVENING^NJ4,0^^0;16^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,24,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,24,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,24,21,1,0)
	;;=This is the number of additional Thursday evening meals which are
	;;^DD(119.721,24,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,25,0)
	;;=ADD. FRIDAY BREAKFAST^NJ4,0^^0;17^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,25,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,25,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,25,21,1,0)
	;;=This is the number of additional Friday breakfast meals which are
	;;^DD(119.721,25,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,26,0)
	;;=ADD. FRIDAY NOON^NJ4,0^^0;18^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,26,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,26,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,26,21,1,0)
	;;=This is the number of additional Friday noon meals which are
	;;^DD(119.721,26,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,27,0)
	;;=ADD. FRIDAY EVENING^NJ4,0^^0;19^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,27,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,27,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,27,21,1,0)
	;;=This is the number of additional Friday evening meals which are
	;;^DD(119.721,27,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,28,0)
	;;=ADD. SATURDAY BREAKFAST^NJ4,0^^0;20^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,28,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,28,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,28,21,1,0)
	;;=This is the number of additional Saturday breakfast meals which are
	;;^DD(119.721,28,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,29,0)
	;;=ADD. SATURDAY NOON^NJ4,0^^0;21^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,29,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,29,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,29,21,1,0)
	;;=This is the number of additional Saturday noon meals which are
	;;^DD(119.721,29,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.721,30,0)
	;;=ADD. SATURDAY EVENING^NJ4,0^^0;22^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,30,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,30,21,0)
	;;=^^2^2^2880716^^
	;;^DD(119.721,30,21,1,0)
	;;=This is the number of additional Saturday evening meals which are
	;;^DD(119.721,30,21,2,0)
	;;=to be added to the inpatient forecast.
	;;^DD(119.7211,0)
	;;=PRODUCTION DIET PERCENTAGE SUB-FIELD^^16^8
	;;^DD(119.7211,0,"DT")
	;;=2911112
	;;^DD(119.7211,0,"IX","B",119.7211,.01)
	;;=
	;;^DD(119.7211,0,"NM","PRODUCTION DIET PERCENTAGE")
	;;=
	;;^DD(119.7211,0,"UP")
	;;=119.72
	;;^DD(119.7211,.01,0)
	;;=FORECAST % PRODUCTION DIET^MP116.2'X^FH(116.2,^0;1^I $D(X) S DINUM=X
	;;^DD(119.7211,.01,1,0)
	;;=^.1
	;;^DD(119.7211,.01,1,1,0)
	;;=119.7211^B
	;;^DD(119.7211,.01,1,1,1)
	;;=S ^FH(119.72,DA(1),"A","B",$E(X,1,30),DA)=""
	;;^DD(119.7211,.01,1,1,2)
	;;=K ^FH(119.72,DA(1),"A","B",$E(X,1,30),DA)
	;;^DD(119.7211,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.7211,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the PRODUCTION DIET field.
	;;^DD(119.7211,.01,21,0)
	;;=^^2^2^2911211^^
	;;^DD(119.7211,.01,21,1,0)
	;;=This field is the production diet for which daily forecast percentages
	;;^DD(119.7211,.01,21,2,0)
	;;=are to be entered.
	;;^DD(119.7211,.01,"DT")
	;;=2911211
	;;^DD(119.7211,10,0)
	;;=SUNDAY CENSUS PERCENTAGE^NJ5,1^^0;2^K:+X'=X!(X>110)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(119.7211,10,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 110
	;;^DD(119.7211,10,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.7211,10,21,1,0)
	;;=This field contains the % of total census on Sundays for which this

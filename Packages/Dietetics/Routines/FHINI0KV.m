FHINI0KV	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.1,.01,"DT")
	;;=2910307
	;;^DD(115.1,1,0)
	;;=STRENGTH^RS^1:1/4;2:1/2;3:3/4;4:FULL;^0;2^Q
	;;^DD(115.1,1,3)
	;;=
	;;^DD(115.1,1,21,0)
	;;=^^3^3^2920818^^^^
	;;^DD(115.1,1,21,1,0)
	;;=This field contains the quantity of the tubefeeding and may
	;;^DD(115.1,1,21,2,0)
	;;=be expressed in Kilocalories per day, cc's per hour, or
	;;^DD(115.1,1,21,3,0)
	;;=similar rates.
	;;^DD(115.1,1,"DT")
	;;=2910307
	;;^DD(115.1,2,0)
	;;=QUANTITY^RF^^0;3^K:$L(X)>50!($L(X)<3) X
	;;^DD(115.1,2,3)
	;;=Answer must be 3-50 characters in length.
	;;^DD(115.1,2,21,0)
	;;=^^2^2^2911204^^^^
	;;^DD(115.1,2,21,1,0)
	;;=This field contains the strength of the tubefeeding product
	;;^DD(115.1,2,21,2,0)
	;;=and the degree, if any, of dilution.
	;;^DD(115.1,2,"DT")
	;;=2950926
	;;^DD(115.1,3,0)
	;;=PRODUCT CC'S/DAY^NJ5,0^^0;4^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.1,3,3)
	;;=Type a Number between 0 and 10000, 0 Decimal Digits
	;;^DD(115.1,3,21,0)
	;;=^^2^2^2911204^
	;;^DD(115.1,3,21,1,0)
	;;=This is the number of cc's of the TF product which are contained in
	;;^DD(115.1,3,21,2,0)
	;;=the order for a day (or less than a day if so indicated).
	;;^DD(115.1,3,"DT")
	;;=2910312
	;;^DD(115.1,4,0)
	;;=WATER CC'S/DAY^NJ5,0^^0;5^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.1,4,3)
	;;=Type a Number between 0 and 10000, 0 Decimal Digits
	;;^DD(115.1,4,21,0)
	;;=^^2^2^2911204^
	;;^DD(115.1,4,21,1,0)
	;;=This is the number of cc's of water to be used to dilute the TF product
	;;^DD(115.1,4,21,2,0)
	;;=if indicated.
	;;^DD(115.1,4,"DT")
	;;=2910312
	;;^DD(115.1,5,0)
	;;=KCALS/DAY^NJ5,0^^0;6^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.1,5,3)
	;;=Type a Number between 0 and 10000, 0 Decimal Digits
	;;^DD(115.1,5,21,0)
	;;=^^1^1^2911204^
	;;^DD(115.1,5,21,1,0)
	;;=This is the number of Kcal's contained in this TF product as prepared.
	;;^DD(115.1,5,"DT")
	;;=2910401
	;;^DD(115.1171,0)
	;;=COMMENTS SUB-FIELD^^.01^1
	;;^DD(115.1171,0,"NM","COMMENTS")
	;;=
	;;^DD(115.1171,0,"UP")
	;;=115.011
	;;^DD(115.1171,.01,0)
	;;=COMMENTS^W^^0;1^Q
	;;^DD(115.1171,.01,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.1171,.01,21,1,0)
	;;=This is the text of the comments relating to the
	;;^DD(115.1171,.01,21,2,0)
	;;=nutrition assessment.
	;;^DD(115.1171,.01,"DT")
	;;=2890616
	;;^DD(115.14,0)
	;;=DIET SEQUENCE SUB-FIELD^^1^2
	;;^DD(115.14,0,"NM","DIET SEQUENCE")
	;;=
	;;^DD(115.14,0,"UP")
	;;=115.01
	;;^DD(115.14,.01,0)
	;;=DIET SEQUENCE DATE/TIME^DIX^^0;1^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=X
	;;^DD(115.14,.01,3)
	;;=
	;;^DD(115.14,.01,21,0)
	;;=^^3^3^2880710^
	;;^DD(115.14,.01,21,1,0)
	;;=This field is the date/time that a diet order is to take effect;
	;;^DD(115.14,.01,21,2,0)
	;;=the order will remain in effect until the following date/time
	;;^DD(115.14,.01,21,3,0)
	;;=sequence entry.
	;;^DD(115.14,.01,"DT")
	;;=2880521
	;;^DD(115.14,1,0)
	;;=DIET ORDER #^RNJ5,0I^^0;2^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.14,1,3)
	;;=Type a Number between 1 and 99999, 0 Decimal Digits
	;;^DD(115.14,1,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.14,1,21,1,0)
	;;=This is the order number, in Field 3, of the diet order that is
	;;^DD(115.14,1,21,2,0)
	;;=to become effective at the indicated date/time.
	;;^DD(115.14,1,"DT")
	;;=2880521

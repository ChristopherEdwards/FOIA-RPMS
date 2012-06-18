FHINI0MQ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.72)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.72,0,"GL")
	;;=^FH(119.72,
	;;^DIC("B","SERVICE POINT",119.72)
	;;=
	;;^DIC(119.72,"%D",0)
	;;=^^3^3^2911204^
	;;^DIC(119.72,"%D",1,0)
	;;=This file is a list of Service Points and associated parameters.
	;;^DIC(119.72,"%D",2,0)
	;;=A Service Point is a tray assembly line or cafeteria where bulk
	;;^DIC(119.72,"%D",3,0)
	;;=food from a Production Facility is served.
	;;^DD(119.72,0)
	;;=FIELD^^200^7
	;;^DD(119.72,0,"DT")
	;;=2921016
	;;^DD(119.72,0,"IX","B",119.72,.01)
	;;=
	;;^DD(119.72,0,"IX","C",119.72,.5)
	;;=
	;;^DD(119.72,0,"NM","SERVICE POINT")
	;;=
	;;^DD(119.72,0,"PT",116.112,.01)
	;;=
	;;^DD(119.72,0,"PT",119.6,3)
	;;=
	;;^DD(119.72,0,"PT",119.6,4)
	;;=
	;;^DD(119.72,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(119.72,.01,1,0)
	;;=^.1
	;;^DD(119.72,.01,1,1,0)
	;;=119.72^B
	;;^DD(119.72,.01,1,1,1)
	;;=S ^FH(119.72,"B",$E(X,1,30),DA)=""
	;;^DD(119.72,.01,1,1,2)
	;;=K ^FH(119.72,"B",$E(X,1,30),DA)
	;;^DD(119.72,.01,1,1,"%D",0)
	;;=^^1^1^2940721^^
	;;^DD(119.72,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.72,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(119.72,.01,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.72,.01,21,1,0)
	;;=This is the name of the Service Point. It is either a tray assembly
	;;^DD(119.72,.01,21,2,0)
	;;=line or a cafeteria. It provides food to a group of wards.
	;;^DD(119.72,.01,"DT")
	;;=2921016
	;;^DD(119.72,.5,0)
	;;=SHORT NAME^RF^^0;4^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>6!($L(X)<1) X
	;;^DD(119.72,.5,1,0)
	;;=^.1
	;;^DD(119.72,.5,1,1,0)
	;;=119.72^C
	;;^DD(119.72,.5,1,1,1)
	;;=S ^FH(119.72,"C",$E(X,1,30),DA)=""
	;;^DD(119.72,.5,1,1,2)
	;;=K ^FH(119.72,"C",$E(X,1,30),DA)
	;;^DD(119.72,.5,1,1,"DT")
	;;=2930427
	;;^DD(119.72,.5,3)
	;;=Answer must be 1-6 characters in length.
	;;^DD(119.72,.5,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.72,.5,21,1,0)
	;;=This is a 6-character short-name to be used on various production
	;;^DD(119.72,.5,21,2,0)
	;;=reports.
	;;^DD(119.72,.5,"DT")
	;;=2930427
	;;^DD(119.72,1,0)
	;;=TYPE^RS^C:CAFETERIA;T:TRAY LINE;^0;2^Q
	;;^DD(119.72,1,21,0)
	;;=^^2^2^2920410^^
	;;^DD(119.72,1,21,1,0)
	;;=This indicates whether the Service Point is a Tray assembly point or
	;;^DD(119.72,1,21,2,0)
	;;=a Cafeteria.
	;;^DD(119.72,1,"DT")
	;;=2911203
	;;^DD(119.72,2,0)
	;;=PRODUCTION FACILITY^RP119.71'^FH(119.71,^0;3^Q
	;;^DD(119.72,2,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.72,2,21,1,0)
	;;=This field indicates the Production Facility responsible for preparing
	;;^DD(119.72,2,21,2,0)
	;;=the food served by this Service Point.
	;;^DD(119.72,2,"DT")
	;;=2911108
	;;^DD(119.72,10,0)
	;;=ADDITIONAL MEALS^119.721P^^B;0
	;;^DD(119.72,10,21,0)
	;;=^^3^3^2911211^^
	;;^DD(119.72,10,21,1,0)
	;;=This multiple represents the number of additional meals, over
	;;^DD(119.72,10,21,2,0)
	;;=and above the forecast or inpatient census, which are to be
	;;^DD(119.72,10,21,3,0)
	;;=produced for each meal for each day of the week.
	;;^DD(119.72,11,0)
	;;=PRODUCTION DIET PERCENTAGE^119.7211P^^A;0
	;;^DD(119.72,11,21,0)
	;;=^^3^3^2880717^
	;;^DD(119.72,11,21,1,0)
	;;=This multiple contains the percentage of the total census
	;;^DD(119.72,11,21,2,0)
	;;=represented by each production diet for each day of the
	;;^DD(119.72,11,21,3,0)
	;;=week.
	;;^DD(119.72,200,0)
	;;=CENSUS DATE^119.722DA^^C;0
	;;^DD(119.72,200,21,0)
	;;=^^2^2^2920107^
	;;^DD(119.72,200,21,1,0)
	;;=This field contains the date for which various census forecast data
	;;^DD(119.72,200,21,2,0)
	;;=is available.
	;;^DD(119.721,0)
	;;=ADDITIONAL MEALS SUB-FIELD^^30^22
	;;^DD(119.721,0,"DT")
	;;=2911211
	;;^DD(119.721,0,"IX","B",119.721,.01)
	;;=
	;;^DD(119.721,0,"NM","ADDITIONAL MEALS")
	;;=
	;;^DD(119.721,0,"UP")
	;;=119.72
	;;^DD(119.721,.01,0)
	;;=ADD. MEALS PRODUCTION DIET^MP116.2'X^FH(116.2,^0;1^I $D(X) S DINUM=X
	;;^DD(119.721,.01,1,0)
	;;=^.1
	;;^DD(119.721,.01,1,1,0)
	;;=119.721^B
	;;^DD(119.721,.01,1,1,1)
	;;=S ^FH(119.72,DA(1),"B","B",$E(X,1,30),DA)=""
	;;^DD(119.721,.01,1,1,2)
	;;=K ^FH(119.72,DA(1),"B","B",$E(X,1,30),DA)
	;;^DD(119.721,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.721,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the PRODUCTION DIET field.
	;;^DD(119.721,.01,21,0)
	;;=^^2^2^2911211^^
	;;^DD(119.721,.01,21,1,0)
	;;=This is the name of the production diet for which additional meals
	;;^DD(119.721,.01,21,2,0)
	;;=are to be added.
	;;^DD(119.721,.01,"DT")
	;;=2911211
	;;^DD(119.721,10,0)
	;;=ADD. SUNDAY BREAKFAST^NJ4,0^^0;2^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.721,10,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 1000
	;;^DD(119.721,10,21,0)
	;;=^^2^2^2880716^^

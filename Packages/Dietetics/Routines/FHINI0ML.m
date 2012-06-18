FHINI0ML	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.6,0,"GL")
	;;=^FH(119.6,
	;;^DIC("B","DIETETICS WARD",119.6)
	;;=
	;;^DIC(119.6,"%D",0)
	;;=^^5^5^2911204^^^
	;;^DIC(119.6,"%D",1,0)
	;;=This file is a list of wards in the hospital and associated room-beds
	;;^DIC(119.6,"%D",2,0)
	;;=and contains various dietetic specific information such
	;;^DIC(119.6,"%D",3,0)
	;;=as the assigned clinician, bulk nourishments for the ward, and
	;;^DIC(119.6,"%D",4,0)
	;;=which Service Point, Communication Office, and Supplemental Feeding
	;;^DIC(119.6,"%D",5,0)
	;;=Site is assigned responsibility for the ward.
	;;^DD(119.6,0)
	;;=FIELD^^101^26
	;;^DD(119.6,0,"DT")
	;;=2940413
	;;^DD(119.6,0,"IX","AP",119.6,11)
	;;=
	;;^DD(119.6,0,"IX","AR",119.62,.01)
	;;=
	;;^DD(119.6,0,"IX","AS1",119.6,3)
	;;=
	;;^DD(119.6,0,"IX","AS2",119.6,4)
	;;=
	;;^DD(119.6,0,"IX","AS3",119.6,5)
	;;=
	;;^DD(119.6,0,"IX","AW",119.63,.01)
	;;=
	;;^DD(119.6,0,"IX","B",119.6,.01)
	;;=
	;;^DD(119.6,0,"NM","DIETETICS WARD")
	;;=
	;;^DD(119.6,0,"PT",115.01,11)
	;;=
	;;^DD(119.6,0,"PT",115.01,13)
	;;=
	;;^DD(119.6,0,"PT",115.012,5)
	;;=
	;;^DD(119.6,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<1) X
	;;^DD(119.6,.01,1,0)
	;;=^.1
	;;^DD(119.6,.01,1,1,0)
	;;=119.6^B
	;;^DD(119.6,.01,1,1,1)
	;;=S ^FH(119.6,"B",$E(X,1,30),DA)=""
	;;^DD(119.6,.01,1,1,2)
	;;=K ^FH(119.6,"B",$E(X,1,30),DA)
	;;^DD(119.6,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.6,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.6,.01,3)
	;;=Answer must be 1-30 characters in length.
	;;^DD(119.6,.01,21,0)
	;;=^^1^1^2920507^^^^
	;;^DD(119.6,.01,21,1,0)
	;;=This is the name of a ward on which dietetic activity occurs.
	;;^DD(119.6,.01,"DT")
	;;=2911015
	;;^DD(119.6,1,0)
	;;=CLINICIAN^RP200'^VA(200,^0;2^Q
	;;^DD(119.6,1,21,0)
	;;=^^3^3^2880717^
	;;^DD(119.6,1,21,1,0)
	;;=This field contains the clinician assigned to the ward and the
	;;^DD(119.6,1,21,2,0)
	;;=one to whom dietetic consults will be routed and notification
	;;^DD(119.6,1,21,3,0)
	;;=made of special diet orders and tubefeedings.
	;;^DD(119.6,2,0)
	;;=ROOM-BED^119.62P^^R;0
	;;^DD(119.6,2,21,0)
	;;=^^2^2^2911211^^^
	;;^DD(119.6,2,21,1,0)
	;;=This is a pointer to File 405.4 and indicates that that room-bed
	;;^DD(119.6,2,21,2,0)
	;;=is to be considered part of this Dietetic Ward.
	;;^DD(119.6,2.5,0)
	;;=ASSOCIATED MAS WARD^119.63P^^W;0
	;;^DD(119.6,2.5,21,0)
	;;=^^3^3^2911211^^
	;;^DD(119.6,2.5,21,1,0)
	;;=This is a list of MAS wards which are to be used as defaults to this
	;;^DD(119.6,2.5,21,2,0)
	;;=Dietetic ward for purposes of patient location when the room-bed is
	;;^DD(119.6,2.5,21,3,0)
	;;=unknown and for purposes of forecasting.
	;;^DD(119.6,3,0)
	;;=TRAY SERVICE POINT^*P119.72'^FH(119.72,^0;5^S DIC("S")="I $P(^(0),U,2)=""T""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(119.6,3,1,0)
	;;=^.1
	;;^DD(119.6,3,1,1,0)
	;;=119.6^AS1^MUMPS
	;;^DD(119.6,3,1,1,1)
	;;=S Y="" S:$P(^FH(119.6,DA,0),"^",5) Y=Y_"T" S:$P(^(0),"^",6) Y=Y_"C" S:$P(^(0),"^",7) Y=Y_"D" S $P(^(0),"^",10)=Y
	;;^DD(119.6,3,1,1,2)
	;;=S $P(^FH(119.6,DA,0),"^",10)=""
	;;^DD(119.6,3,1,1,"%D",0)
	;;=^^3^3^2940823^^
	;;^DD(119.6,3,1,1,"%D",1,0)
	;;=This cross-reference, along with that on Fields 4 and 5, is used to
	;;^DD(119.6,3,1,1,"%D",2,0)
	;;=set the Services Field. It is a string containing C, T, and/or D
	;;^DD(119.6,3,1,1,"%D",3,0)
	;;=indicating which services are available for this ward.
	;;^DD(119.6,3,1,1,"DT")
	;;=2911031
	;;^DD(119.6,3,12)
	;;=Allows selection only of tray lines
	;;^DD(119.6,3,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""T"""
	;;^DD(119.6,3,21,0)
	;;=^^4^4^2920505^^^^
	;;^DD(119.6,3,21,1,0)
	;;=This field, if used, indicates that tray service is available to this
	;;^DD(119.6,3,21,2,0)
	;;=ward and is provided by the indicated Service Point. Note: if a Dining
	;;^DD(119.6,3,21,3,0)
	;;=Room is also available, then a Tray Service Point must be specified
	;;^DD(119.6,3,21,4,0)
	;;=as Dining Room trays are prepared there.
	;;^DD(119.6,3,"DT")
	;;=2911204
	;;^DD(119.6,3.5,0)
	;;=TRAY FORECAST %^NJ3,0^^0;17^K:+X'=X!(X>120)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.6,3.5,3)
	;;=Type a Number between 0 and 120, 0 Decimal Digits
	;;^DD(119.6,3.5,21,0)
	;;=^^1^1^2911204^
	;;^DD(119.6,3.5,21,1,0)
	;;=This is the % of patients on the ward typically receiving tray service.
	;;^DD(119.6,3.5,"DT")
	;;=2911120
	;;^DD(119.6,4,0)
	;;=CAFETERIA SERVICE POINT^*P119.72'^FH(119.72,^0;6^S DIC("S")="I $P(^(0),U,2)=""C""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(119.6,4,1,0)
	;;=^.1
	;;^DD(119.6,4,1,1,0)
	;;=119.6^AS2^MUMPS
	;;^DD(119.6,4,1,1,1)
	;;=S Y="" S:$P(^FH(119.6,DA,0),"^",5) Y=Y_"T" S:$P(^(0),"^",6) Y=Y_"C" S:$P(^(0),"^",7) Y=Y_"D" S $P(^(0),"^",10)=Y

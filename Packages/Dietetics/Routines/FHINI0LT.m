FHINI0LT	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.338,0)
	;;=DIETETIC EQUIPMENT SUB-FIELD^^1^2
	;;^DD(117.338,0,"DT")
	;;=2920915
	;;^DD(117.338,0,"IX","B",117.338,.01)
	;;=
	;;^DD(117.338,0,"NM","DIETETIC EQUIPMENT")
	;;=
	;;^DD(117.338,0,"UP")
	;;=117.3
	;;^DD(117.338,.01,0)
	;;=DIETETIC EQUIPMENT^M*P117.4'^FH(117.4,^0;1^S DIC("S")="I $P(^(0),U,2)=""E""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(117.338,.01,1,0)
	;;=^.1
	;;^DD(117.338,.01,1,1,0)
	;;=117.338^B
	;;^DD(117.338,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"EQUI","B",$E(X,1,30),DA)=""
	;;^DD(117.338,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"EQUI","B",$E(X,1,30),DA)
	;;^DD(117.338,.01,12)
	;;=SELECT ONLY THE DIETETIC SERVICE EQUIPMENT.
	;;^DD(117.338,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""E"""
	;;^DD(117.338,.01,21,0)
	;;=^^1^1^2920916^^^^
	;;^DD(117.338,.01,21,1,0)
	;;=This field contains the pointer to The Dietetic Report Category file.
	;;^DD(117.338,.01,"DT")
	;;=2920915
	;;^DD(117.338,1,0)
	;;=BRAND^F^^0;2^K:$L(X)>45!($L(X)<3) X
	;;^DD(117.338,1,3)
	;;=Answer must be 3-45 characters in length.
	;;^DD(117.338,1,21,0)
	;;=^^1^1^2920207^
	;;^DD(117.338,1,21,1,0)
	;;=This field contains the Brand of the Dietetic Equipment Service.
	;;^DD(117.338,1,"DT")
	;;=2920207
	;;^DD(117.356,0)
	;;=AREAS OF RESEARCH SUB-FIELD^^.01^1
	;;^DD(117.356,0,"DT")
	;;=2930204
	;;^DD(117.356,0,"IX","B",117.356,.01)
	;;=
	;;^DD(117.356,0,"NM","AREAS OF RESEARCH")
	;;=
	;;^DD(117.356,0,"UP")
	;;=117.3
	;;^DD(117.356,.01,0)
	;;=AREAS OF RESEARCH^MRS^1:CLINICAL;2:COMMUNITY;3:COST/BENEFIT;4:EDUCATION;5:MANAGEMENT;^0;1^Q
	;;^DD(117.356,.01,1,0)
	;;=^.1
	;;^DD(117.356,.01,1,1,0)
	;;=117.356^B
	;;^DD(117.356,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"AREA","B",$E(X,1,30),DA)=""
	;;^DD(117.356,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"AREA","B",$E(X,1,30),DA)
	;;^DD(117.356,.01,21,0)
	;;=^^2^2^2930204^
	;;^DD(117.356,.01,21,1,0)
	;;=This field contains Areas of Research under Unfunded Nutrition
	;;^DD(117.356,.01,21,2,0)
	;;=Research.
	;;^DD(117.356,.01,"DT")
	;;=2930204
	;;^DD(117.358,0)
	;;=APPETIZING SUB-FIELD^^6^7
	;;^DD(117.358,0,"DT")
	;;=2931222
	;;^DD(117.358,0,"IX","B",117.358,.01)
	;;=
	;;^DD(117.358,0,"NM","APPETIZING")
	;;=
	;;^DD(117.358,0,"UP")
	;;=117.3
	;;^DD(117.358,.01,0)
	;;=APPETIZING NUMBER^NJ3,0X^^0;1^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(117.358,.01,1,0)
	;;=^.1
	;;^DD(117.358,.01,1,1,0)
	;;=117.358^B
	;;^DD(117.358,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"APP","B",$E(X,1,30),DA)=""
	;;^DD(117.358,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"APP","B",$E(X,1,30),DA)
	;;^DD(117.358,.01,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(117.358,.01,21,0)
	;;=^^2^2^2931222^^^^
	;;^DD(117.358,.01,21,1,0)
	;;=This field contains a sequential number assigned to the first question
	;;^DD(117.358,.01,21,2,0)
	;;=of the Dietetic Survey and has no meaning.
	;;^DD(117.358,.01,"DT")
	;;=2931221
	;;^DD(117.358,1,0)
	;;=GM&S^FX^^0;2^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.358,1,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.358,1,4)
	;;=D HEL^FHADR9
	;;^DD(117.358,1,21,0)
	;;=^^2^2^2931229^^^^
	;;^DD(117.358,1,21,1,0)
	;;=This is a rating string containing numbers surveyed in GM&S with the 
	;;^DD(117.358,1,21,2,0)
	;;=ratings specified in front of them on question one of the survey.
	;;^DD(117.358,1,"DT")
	;;=2931229
	;;^DD(117.358,2,0)
	;;=NHCU^FX^^0;3^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.358,2,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.358,2,4)
	;;=D HEL^FHADR9
	;;^DD(117.358,2,21,0)
	;;=^^2^2^2931229^^^
	;;^DD(117.358,2,21,1,0)
	;;=This is a rating string containing numbers surveyed in NHCU with the
	;;^DD(117.358,2,21,2,0)
	;;=ratings specified in front of them on question one of the survey.
	;;^DD(117.358,2,"DT")
	;;=2931229
	;;^DD(117.358,3,0)
	;;=PSYCH^FX^^0;4^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.358,3,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.358,3,4)
	;;=D HEL^FHADR9
	;;^DD(117.358,3,21,0)
	;;=^^2^2^2931229^^^^
	;;^DD(117.358,3,21,1,0)
	;;=This is a rating string containing numbers surveyed in PSYCH with the
	;;^DD(117.358,3,21,2,0)
	;;=ratings specified in front of them on question one of the survey.
	;;^DD(117.358,3,"DT")
	;;=2931229
	;;^DD(117.358,4,0)
	;;=DOM^FX^^0;5^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.358,4,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.358,4,4)
	;;=D HEL^FHADR9
	;;^DD(117.358,4,21,0)
	;;=^^2^2^2931229^^^
	;;^DD(117.358,4,21,1,0)
	;;=This is a rating string containing numbers surveyed in DOM with the
	;;^DD(117.358,4,21,2,0)
	;;=ratings specified in front of them on question one of the survey.

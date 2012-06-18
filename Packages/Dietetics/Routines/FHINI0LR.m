FHINI0LR	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.31,1,"DT")
	;;=2931230
	;;^DD(117.31,2,0)
	;;=NHCU^FX^^0;3^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.31,2,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.31,2,4)
	;;=D HEL^FHADR9
	;;^DD(117.31,2,21,0)
	;;=^^2^2^2931223^
	;;^DD(117.31,2,21,1,0)
	;;=This is a rating string containing numbers surveyed in NHCU with the
	;;^DD(117.31,2,21,2,0)
	;;=ratings specified in front of them for question three of the survey.
	;;^DD(117.31,2,"DT")
	;;=2931230
	;;^DD(117.31,3,0)
	;;=PSYCH^FX^^0;4^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.31,3,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.31,3,4)
	;;=D HEL^FHADR9
	;;^DD(117.31,3,21,0)
	;;=^^2^2^2931223^
	;;^DD(117.31,3,21,1,0)
	;;=This is a rating string containing numbers surveyed in PSYCH with the
	;;^DD(117.31,3,21,2,0)
	;;=ratings specified in front of them on question three of the survey.
	;;^DD(117.31,3,"DT")
	;;=2931230
	;;^DD(117.31,4,0)
	;;=DOM^FX^^0;5^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.31,4,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.31,4,4)
	;;=D HEL^FHADR9
	;;^DD(117.31,4,21,0)
	;;=^^2^2^2931223^
	;;^DD(117.31,4,21,1,0)
	;;=This is a rating string containing numbers surveyed in DOM with the
	;;^DD(117.31,4,21,2,0)
	;;=ratings specified in front of them on question three of the survey.
	;;^DD(117.31,4,"DT")
	;;=2931230
	;;^DD(117.31,5,0)
	;;=SCI^FX^^0;6^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.31,5,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.31,5,4)
	;;=D HEL^FHADR9
	;;^DD(117.31,5,21,0)
	;;=^^2^2^2931223^
	;;^DD(117.31,5,21,1,0)
	;;=This is a rating string containing numbers surveyed in SCI with the
	;;^DD(117.31,5,21,2,0)
	;;=ratings specified in front of them on question three of the survey.
	;;^DD(117.31,5,"DT")
	;;=2931230
	;;^DD(117.31,6,0)
	;;=OTHER^FX^^0;7^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.31,6,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.31,6,4)
	;;=D HEL^FHADR9
	;;^DD(117.31,6,21,0)
	;;=^^3^3^2931229^^
	;;^DD(117.31,6,21,1,0)
	;;=This is a rating string containing numbers surveyed in other service
	;;^DD(117.31,6,21,2,0)
	;;=with the ratings specified in front of them on question three of
	;;^DD(117.31,6,21,3,0)
	;;=the survey.
	;;^DD(117.31,6,"DT")
	;;=2931230
	;;^DD(117.312,0)
	;;=SPECIALIZED MEDICAL PROGRAMS SUB-FIELD^^1^2
	;;^DD(117.312,0,"DT")
	;;=2920915
	;;^DD(117.312,0,"IX","B",117.312,.01)
	;;=
	;;^DD(117.312,0,"NM","SPECIALIZED MEDICAL PROGRAMS")
	;;=
	;;^DD(117.312,0,"UP")
	;;=117.3
	;;^DD(117.312,.01,0)
	;;=SPECIALIZED MEDICAL PROGRAMS^M*P117.4'^FH(117.4,^0;1^S DIC("S")="I $P(^(0),U,2)=""S""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(117.312,.01,1,0)
	;;=^.1
	;;^DD(117.312,.01,1,1,0)
	;;=117.312^B
	;;^DD(117.312,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"SPEC","B",$E(X,1,30),DA)=""
	;;^DD(117.312,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"SPEC","B",$E(X,1,30),DA)
	;;^DD(117.312,.01,12)
	;;=SELECT ONLY THE SPECIALIZED MEDICAL PROGRAMS.
	;;^DD(117.312,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""S"""
	;;^DD(117.312,.01,21,0)
	;;=^^2^2^2920916^^^^
	;;^DD(117.312,.01,21,1,0)
	;;=This field points to the Dietetic Report Categories for the Specialized
	;;^DD(117.312,.01,21,2,0)
	;;=Medical Programs.
	;;^DD(117.312,.01,"DT")
	;;=2920915
	;;^DD(117.312,1,0)
	;;=ASSIGNED CLINICAL FTEE^NJ4,1^^0;2^K:+X'=X!(X>99.9)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(117.312,1,3)
	;;=Type a Number between 0 and 99.9, 1 Decimal Digit
	;;^DD(117.312,1,21,0)
	;;=^^2^2^2920130^
	;;^DD(117.312,1,21,1,0)
	;;=This field contains the Assigned Clinical Ftee of the Specialized
	;;^DD(117.312,1,21,2,0)
	;;=Medical Programs.
	;;^DD(117.312,1,"DT")
	;;=2920130
	;;^DD(117.313,0)
	;;=PRIMARY DELIVERY SYSTEM SUB-FIELD^^.01^1
	;;^DD(117.313,0,"DT")
	;;=2920915
	;;^DD(117.313,0,"IX","B",117.313,.01)
	;;=
	;;^DD(117.313,0,"NM","PRIMARY DELIVERY SYSTEM")
	;;=
	;;^DD(117.313,0,"UP")
	;;=117.3
	;;^DD(117.313,.01,0)
	;;=PRIMARY DELIVERY SYSTEM^M*P117.4'^FH(117.4,^0;1^S DIC("S")="I $P(^(0),U,2)=""D""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(117.313,.01,1,0)
	;;=^.1
	;;^DD(117.313,.01,1,1,0)
	;;=117.313^B
	;;^DD(117.313,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"DELV","B",$E(X,1,30),DA)=""
	;;^DD(117.313,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"DELV","B",$E(X,1,30),DA)
	;;^DD(117.313,.01,12)
	;;=SELECT ONLY THE PRIMARY DELIVERY SYSTEM.
	;;^DD(117.313,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""D"""
	;;^DD(117.313,.01,21,0)
	;;=^^2^2^2920916^^^^
	;;^DD(117.313,.01,21,1,0)
	;;=This field points to the Dietetic Report Categories for the Primary
	;;^DD(117.313,.01,21,2,0)
	;;=Delivery System.

FHINI0LU	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.358,4,"DT")
	;;=2931229
	;;^DD(117.358,5,0)
	;;=SCI^FX^^0;6^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.358,5,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.358,5,4)
	;;=D HEL^FHADR9
	;;^DD(117.358,5,21,0)
	;;=^^2^2^2931222^^
	;;^DD(117.358,5,21,1,0)
	;;=This is a rating string containing numbers surveyed in SCI with the
	;;^DD(117.358,5,21,2,0)
	;;=ratings specified in front of them on question one of the survey.
	;;^DD(117.358,5,"DT")
	;;=2931229
	;;^DD(117.358,6,0)
	;;=OTHER^FX^^0;7^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.358,6,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.358,6,4)
	;;=D HEL^FHADR9
	;;^DD(117.358,6,21,0)
	;;=^^2^2^2931222^^
	;;^DD(117.358,6,21,1,0)
	;;=This is a rating string containing numbers surveyed in other services with
	;;^DD(117.358,6,21,2,0)
	;;=ratings specified in front of them on question one of the survey.
	;;^DD(117.358,6,"DT")
	;;=2931229
	;;^DD(117.359,0)
	;;=TASTE SUB-FIELD^^6^7
	;;^DD(117.359,0,"DT")
	;;=2931222
	;;^DD(117.359,0,"IX","B",117.359,.01)
	;;=
	;;^DD(117.359,0,"NM","TASTE")
	;;=
	;;^DD(117.359,0,"UP")
	;;=117.3
	;;^DD(117.359,.01,0)
	;;=TASTE NUMBER^NJ3,0X^^0;1^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(117.359,.01,1,0)
	;;=^.1
	;;^DD(117.359,.01,1,1,0)
	;;=117.359^B
	;;^DD(117.359,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"TAS","B",$E(X,1,30),DA)=""
	;;^DD(117.359,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"TAS","B",$E(X,1,30),DA)
	;;^DD(117.359,.01,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(117.359,.01,21,0)
	;;=^^2^2^2931222^^
	;;^DD(117.359,.01,21,1,0)
	;;=This field contains a sequential number assigned to question two
	;;^DD(117.359,.01,21,2,0)
	;;=of the Dietetic Survey and has no meaning.
	;;^DD(117.359,.01,"DT")
	;;=2931222
	;;^DD(117.359,1,0)
	;;=GM&S^FX^^0;2^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.359,1,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.359,1,4)
	;;=D HEL^FHADR9
	;;^DD(117.359,1,21,0)
	;;=^^2^2^2931222^
	;;^DD(117.359,1,21,1,0)
	;;=This is a rating string containing numbers surveyed in GM&S with the
	;;^DD(117.359,1,21,2,0)
	;;=ratings specified in front of them on question two of the survey.
	;;^DD(117.359,1,"DT")
	;;=2931229
	;;^DD(117.359,2,0)
	;;=NHCU^FX^^0;3^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.359,2,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.359,2,4)
	;;=D HEL^FHADR9
	;;^DD(117.359,2,21,0)
	;;=^^2^2^2931222^^
	;;^DD(117.359,2,21,1,0)
	;;=This is a rating string containing numbers surveyed in NHCU with the
	;;^DD(117.359,2,21,2,0)
	;;=ratings specified in front of them on question two of the survey.
	;;^DD(117.359,2,"DT")
	;;=2931229
	;;^DD(117.359,3,0)
	;;=PSYCH^FX^^0;4^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.359,3,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.359,3,4)
	;;=D HEL^FHADR9
	;;^DD(117.359,3,21,0)
	;;=^^2^2^2931222^
	;;^DD(117.359,3,21,1,0)
	;;=This is a rating string containing numbers surveyed in PSYCH with the
	;;^DD(117.359,3,21,2,0)
	;;=ratings specified in front of them on question two of the survey.
	;;^DD(117.359,3,"DT")
	;;=2931229
	;;^DD(117.359,4,0)
	;;=DOM^FX^^0;5^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.359,4,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.359,4,4)
	;;=D HEL^FHADR9
	;;^DD(117.359,4,21,0)
	;;=^^2^2^2931222^
	;;^DD(117.359,4,21,1,0)
	;;=This is a rating string containing numbers surveyed in DOM with the
	;;^DD(117.359,4,21,2,0)
	;;=ratings specified in front of them on question two of the survey.
	;;^DD(117.359,4,"DT")
	;;=2931229
	;;^DD(117.359,5,0)
	;;=SCI^FX^^0;6^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.359,5,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.359,5,4)
	;;=D HEL^FHADR9
	;;^DD(117.359,5,21,0)
	;;=^^2^2^2931222^^
	;;^DD(117.359,5,21,1,0)
	;;=This is a rating string containing numbers surveyed in SCI with the
	;;^DD(117.359,5,21,2,0)
	;;=ratings specified in front of them on question two of the survey.
	;;^DD(117.359,5,"DT")
	;;=2931229
	;;^DD(117.359,6,0)
	;;=OTHER^FX^^0;7^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.359,6,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.359,6,4)
	;;=D HEL^FHADR9
	;;^DD(117.359,6,21,0)
	;;=^^2^2^2931222^
	;;^DD(117.359,6,21,1,0)
	;;=This is a rating string containing numbers surveyed in other service
	;;^DD(117.359,6,21,2,0)
	;;=with the ratings specified in front of them on question two of the survey.
	;;^DD(117.359,6,"DT")
	;;=2931229
	;;^DD(117.361,0)
	;;=VARIETY SUB-FIELD^^6^7
	;;^DD(117.361,0,"DT")
	;;=2931223

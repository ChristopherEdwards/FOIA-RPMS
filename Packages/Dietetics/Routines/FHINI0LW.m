FHINI0LW	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.362,1,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.362,1,21,1,0)
	;;=This is a rating string containing numbers surveyed in GM&S with the
	;;^DD(117.362,1,21,2,0)
	;;=ratings specified in front of them on question five of the survey.
	;;^DD(117.362,1,"DT")
	;;=2931230
	;;^DD(117.362,2,0)
	;;=NHCU^FX^^0;3^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.362,2,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.362,2,4)
	;;=D HEL^FHADR9
	;;^DD(117.362,2,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.362,2,21,1,0)
	;;=This is a rating string containing numbers surveyed in NHCU with the
	;;^DD(117.362,2,21,2,0)
	;;=ratings specified in front of them on question five of the survey.
	;;^DD(117.362,2,"DT")
	;;=2931230
	;;^DD(117.362,3,0)
	;;=PSYCH^FX^^0;4^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.362,3,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.362,3,4)
	;;=D HEL^FHADR9
	;;^DD(117.362,3,21,0)
	;;=^^3^3^2931228^
	;;^DD(117.362,3,21,1,0)
	;;=This is a rating string containing numbers surveyed in PSYCH with
	;;^DD(117.362,3,21,2,0)
	;;=the ratings specified in front of them on question five of the
	;;^DD(117.362,3,21,3,0)
	;;=survey.
	;;^DD(117.362,3,"DT")
	;;=2931230
	;;^DD(117.362,4,0)
	;;=DOM^FX^^0;5^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.362,4,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.362,4,4)
	;;=D HEL^FHADR9
	;;^DD(117.362,4,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.362,4,21,1,0)
	;;=This is a rating string containing numbers surveyed in the DOM with
	;;^DD(117.362,4,21,2,0)
	;;=the ratings specified in front of them on question five of the survey.
	;;^DD(117.362,4,"DT")
	;;=2931230
	;;^DD(117.362,5,0)
	;;=SCI^FX^^0;6^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.362,5,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.362,5,4)
	;;=D HEL^FHADR9
	;;^DD(117.362,5,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.362,5,21,1,0)
	;;=This is a rating string containing numbers surveyed in SCI with the
	;;^DD(117.362,5,21,2,0)
	;;=ratings specified in front of them on question five of the survey.
	;;^DD(117.362,5,"DT")
	;;=2931230
	;;^DD(117.362,6,0)
	;;=OTHER^FX^^0;7^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.362,6,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.362,6,4)
	;;=D HEL^FHADR9
	;;^DD(117.362,6,21,0)
	;;=^^3^3^2931228^
	;;^DD(117.362,6,21,1,0)
	;;=This is a rating string containing numbers surveyed in other service
	;;^DD(117.362,6,21,2,0)
	;;=with the ratings specified in front of them on question five of the
	;;^DD(117.362,6,21,3,0)
	;;=survey.
	;;^DD(117.362,6,"DT")
	;;=2931230
	;;^DD(117.363,0)
	;;=COURTEOUS SUB-FIELD^^6^7
	;;^DD(117.363,0,"DT")
	;;=2931228
	;;^DD(117.363,0,"IX","B",117.363,.01)
	;;=
	;;^DD(117.363,0,"NM","COURTEOUS")
	;;=
	;;^DD(117.363,0,"UP")
	;;=117.3
	;;^DD(117.363,.01,0)
	;;=COURTEOUS NUMBER^NJ3,0X^^0;1^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(117.363,.01,1,0)
	;;=^.1
	;;^DD(117.363,.01,1,1,0)
	;;=117.363^B
	;;^DD(117.363,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"CRS","B",$E(X,1,30),DA)=""
	;;^DD(117.363,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"CRS","B",$E(X,1,30),DA)
	;;^DD(117.363,.01,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(117.363,.01,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.363,.01,21,1,0)
	;;=This field contains a sequential number assigned to question six of
	;;^DD(117.363,.01,21,2,0)
	;;=the Dietetic Survey and has no meaning.
	;;^DD(117.363,.01,"DT")
	;;=2931228
	;;^DD(117.363,1,0)
	;;=GM&S^FX^^0;2^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.363,1,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.363,1,4)
	;;=D HEL^FHADR9
	;;^DD(117.363,1,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.363,1,21,1,0)
	;;=This is a rating string containing numbers surveyed in GM&S with
	;;^DD(117.363,1,21,2,0)
	;;=the ratings specified in front of them on question six of the survey.
	;;^DD(117.363,1,"DT")
	;;=2931230
	;;^DD(117.363,2,0)
	;;=NHCU^FX^^0;3^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.363,2,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.363,2,4)
	;;=D HEL^FHADR9
	;;^DD(117.363,2,21,0)
	;;=^^2^2^2931228^
	;;^DD(117.363,2,21,1,0)
	;;=This is a rating string containing numbers surveyed in NHCU with the
	;;^DD(117.363,2,21,2,0)
	;;=ratings specified in front of them on question six of the survey.
	;;^DD(117.363,2,"DT")
	;;=2931230
	;;^DD(117.363,3,0)
	;;=PSYCH^FX^^0;4^K:$L(X)>35!($L(X)<2) X I $D(X) D C0^FHADR9
	;;^DD(117.363,3,3)
	;;=Answer must be 2-35 characters in length.
	;;^DD(117.363,3,4)
	;;=D HEL^FHADR9
	;;^DD(117.363,3,21,0)
	;;=^^2^2^2931228^

FHINI0MD	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119,0,"GL")
	;;=^FH(119,
	;;^DIC("B","DIETITIAN TICKLER FILE",119)
	;;=
	;;^DIC(119,"%D",0)
	;;=^^4^4^2910820^
	;;^DIC(119,"%D",1,0)
	;;=This file contains entries relating to required reviews for
	;;^DIC(119,"%D",2,0)
	;;=each dietitian response for a ward or group of wards. It can
	;;^DIC(119,"%D",3,0)
	;;=also be used to record personal or non-patient related
	;;^DIC(119,"%D",4,0)
	;;=entries.
	;;^DD(119,0)
	;;=FIELD^^1^2
	;;^DD(119,0,"DT")
	;;=2920320
	;;^DD(119,0,"IX","B",119,.01)
	;;=
	;;^DD(119,0,"NM","DIETITIAN TICKLER FILE")
	;;=
	;;^DD(119,.01,0)
	;;=DIETITIAN^RP200'X^VA(200,^0;1^I $D(X) S DINUM=X
	;;^DD(119,.01,1,0)
	;;=^.1
	;;^DD(119,.01,1,1,0)
	;;=119^B
	;;^DD(119,.01,1,1,1)
	;;=S ^FH(119,"B",$E(X,1,30),DA)=""
	;;^DD(119,.01,1,1,2)
	;;=K ^FH(119,"B",$E(X,1,30),DA)
	;;^DD(119,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the DIETITIAN field.
	;;^DD(119,.01,3)
	;;=
	;;^DD(119,.01,21,0)
	;;=^^1^1^2911204^
	;;^DD(119,.01,21,1,0)
	;;=This field is a pointer to the Dietitian in File 200.
	;;^DD(119,.01,"DT")
	;;=2910419
	;;^DD(119,1,0)
	;;=ITEM^119.01D^^I;0
	;;^DD(119,1,21,0)
	;;=^^1^1^2911204^
	;;^DD(119,1,21,1,0)
	;;=This field contains a free-text description of the item requiring action.
	;;^DD(119.01,0)
	;;=ITEM SUB-FIELD^^103^6
	;;^DD(119.01,0,"DT")
	;;=2920320
	;;^DD(119.01,0,"NM","ITEM")
	;;=
	;;^DD(119.01,0,"UP")
	;;=119
	;;^DD(119.01,.01,0)
	;;=ITEM^MDX^^0;1^S %DT="EST" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=X
	;;^DD(119.01,.01,1,0)
	;;=^.1^^0
	;;^DD(119.01,.01,21,0)
	;;=^^2^2^2920323^^^
	;;^DD(119.01,.01,21,1,0)
	;;=This field contains the date/time at which the item
	;;^DD(119.01,.01,21,2,0)
	;;=has or will become active.
	;;^DD(119.01,.01,"DT")
	;;=2910426
	;;^DD(119.01,1,0)
	;;=ITEM TYPE^S^C:CONSULT;D:DIET REVIEW;S:SUPP. FDG. REVIEW;X:PERSONAL;T:TUBEFEED;N:NUT. STATUS;O:ADDITIONAL ORDER;^0;2^Q
	;;^DD(119.01,1,21,0)
	;;=^^1^1^2920320^^^
	;;^DD(119.01,1,21,1,0)
	;;=This field indicates the nature of the item.
	;;^DD(119.01,1,"DT")
	;;=2920320
	;;^DD(119.01,2,0)
	;;=ITEM TEXT^F^^0;3^K:$L(X)>80!($L(X)<3) X
	;;^DD(119.01,2,3)
	;;=Answer must be 3-80 characters in length.
	;;^DD(119.01,2,21,0)
	;;=^^1^1^2911204^
	;;^DD(119.01,2,21,1,0)
	;;=This field contains a free-text description of the item.
	;;^DD(119.01,2,"DT")
	;;=2910419
	;;^DD(119.01,101,0)
	;;=PATIENT^P2'^DPT(^0;4^Q
	;;^DD(119.01,101,21,0)
	;;=^^1^1^2911204^
	;;^DD(119.01,101,21,1,0)
	;;=This field is a pointer to the patient to which the item is applicable.
	;;^DD(119.01,101,"DT")
	;;=2910419
	;;^DD(119.01,102,0)
	;;=ADMISSION^P405'^DGPM(^0;5^Q
	;;^DD(119.01,102,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.01,102,21,1,0)
	;;=This field is a pointer to the admission movement in File 405 to which
	;;^DD(119.01,102,21,2,0)
	;;=the item is applicable.
	;;^DD(119.01,102,"DT")
	;;=2910419
	;;^DD(119.01,103,0)
	;;=ENTRY #^NJ5,0^^0;6^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.01,103,3)
	;;=Type a Number between 1 and 99999, 0 Decimal Digits
	;;^DD(119.01,103,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.01,103,21,1,0)
	;;=This is a pointer to the order number for the appropriate Type of
	;;^DD(119.01,103,21,2,0)
	;;=Ticker File item.
	;;^DD(119.01,103,"DT")
	;;=2910419

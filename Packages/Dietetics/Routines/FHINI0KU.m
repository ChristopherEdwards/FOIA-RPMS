FHINI0KU	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.08,4,"DT")
	;;=2871111
	;;^DD(115.08,5,0)
	;;=DATE/TIME CANCELLED^D^^0;6^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.08,5,1,0)
	;;=^.1
	;;^DD(115.08,5,1,1,0)
	;;=115^ASP1^MUMPS
	;;^DD(115.08,5,1,1,1)
	;;=K ^FHPT("ASP",DA(2),DA(1),DA)
	;;^DD(115.08,5,1,1,2)
	;;=S ^FHPT("ASP",DA(2),DA(1),DA)=""
	;;^DD(115.08,5,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(115.08,5,1,1,"%D",1,0)
	;;=This cross-reference will delete the "ASP" standing order
	;;^DD(115.08,5,1,1,"%D",2,0)
	;;=entry if the order is cancelled.
	;;^DD(115.08,5,21,0)
	;;=^^3^3^2911223^^
	;;^DD(115.08,5,21,1,0)
	;;=This field contains the date/time the standing order was
	;;^DD(115.08,5,21,2,0)
	;;=cancelled and is automatically captured at time of
	;;^DD(115.08,5,21,3,0)
	;;=cancellation.
	;;^DD(115.08,5,"DT")
	;;=2871111
	;;^DD(115.08,6,0)
	;;=CANCELLING CLERK^P200'^VA(200,^0;7^Q
	;;^DD(115.08,6,21,0)
	;;=^^2^2^2920320^^^
	;;^DD(115.08,6,21,1,0)
	;;=This field contains the user who entered the cancellation
	;;^DD(115.08,6,21,2,0)
	;;=and is automatically captured at time of cancellation.
	;;^DD(115.08,6,"DT")
	;;=2871111
	;;^DD(115.08,7,0)
	;;=QUANTITY^NJ1,0^^0;8^K:+X'=X!(X>9)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.08,7,3)
	;;=Type a Number between 1 and 9, 0 Decimal Digits
	;;^DD(115.08,7,21,0)
	;;=^^1^1^2920220^
	;;^DD(115.08,7,21,1,0)
	;;=This is the quantity of the Standing Order.
	;;^DD(115.08,7,"DT")
	;;=2920103
	;;^DD(115.08,8,0)
	;;=DIET ASSOCIATED?^S^Y:YES;N:NO;^0;9^Q
	;;^DD(115.08,8,21,0)
	;;=^^2^2^2940722^
	;;^DD(115.08,8,21,1,0)
	;;=This field, if answered Yes, means this Standing Order is associated
	;;^DD(115.08,8,21,2,0)
	;;=with a diet order else if answered No, means it is not.
	;;^DD(115.08,8,"DT")
	;;=2940722
	;;^DD(115.09,0)
	;;=FOOD PREFERENCES SUB-FIELD^^3^4
	;;^DD(115.09,0,"DT")
	;;=2950407
	;;^DD(115.09,0,"IX","B",115.09,.01)
	;;=
	;;^DD(115.09,0,"NM","FOOD PREFERENCES")
	;;=
	;;^DD(115.09,0,"UP")
	;;=115
	;;^DD(115.09,.01,0)
	;;=FOOD PREFERENCES^MP115.2'^FH(115.2,^0;1^Q
	;;^DD(115.09,.01,1,0)
	;;=^.1
	;;^DD(115.09,.01,1,1,0)
	;;=115.09^B
	;;^DD(115.09,.01,1,1,1)
	;;=S ^FHPT(DA(1),"P","B",$E(X,1,30),DA)=""
	;;^DD(115.09,.01,1,1,2)
	;;=K ^FHPT(DA(1),"P","B",$E(X,1,30),DA)
	;;^DD(115.09,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.09,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the FOOD PREFERENCES field.
	;;^DD(115.09,.01,21,0)
	;;=^^2^2^2881201^^
	;;^DD(115.09,.01,21,1,0)
	;;=This field contains the food preference selected from the
	;;^DD(115.09,.01,21,2,0)
	;;=Food Preferences file (115.2).
	;;^DD(115.09,.01,"DT")
	;;=2880831
	;;^DD(115.09,1,0)
	;;=MEALS^RFX^^0;2^S:$P("ALL",X,1)="" X="BNE" S %=X,X="" S:%["B" X="B" S:%["N" X=X_"N" S:%["E" X=X_"E" K:$L(%)'=$L(X) X K %
	;;^DD(115.09,1,3)
	;;=Answer should be a string of meals (e.g., B  or BN or BNE) or A for all meals
	;;^DD(115.09,1,21,0)
	;;=^^2^2^2950418^^^^
	;;^DD(115.09,1,21,1,0)
	;;=This field contains the meals (B N and E) for which this food
	;;^DD(115.09,1,21,2,0)
	;;=preference is applicable.
	;;^DD(115.09,1,22)
	;;=
	;;^DD(115.09,1,"DT")
	;;=2880901
	;;^DD(115.09,2,0)
	;;=QUANTITY^NJ1,0^^0;3^K:+X'=X!(X>9)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.09,2,3)
	;;=Type a Number between 1 and 9, 0 Decimal Digits
	;;^DD(115.09,2,21,0)
	;;=^^2^2^2920220^
	;;^DD(115.09,2,21,1,0)
	;;=This is the quantity of the Food Preference applicable to this
	;;^DD(115.09,2,21,2,0)
	;;=patient.
	;;^DD(115.09,2,"DT")
	;;=2920103
	;;^DD(115.09,3,0)
	;;=DIET ASSOCIATED?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(115.09,3,21,0)
	;;=^^3^3^2950407^
	;;^DD(115.09,3,21,1,0)
	;;=This field, if answered Yes, means this Food Preference is a Diet
	;;^DD(115.09,3,21,2,0)
	;;=restriction that is associated with a diet order else if answered No,
	;;^DD(115.09,3,21,3,0)
	;;=means it is not.
	;;^DD(115.09,3,"DT")
	;;=2950407
	;;^DD(115.1,0)
	;;=TF PRODUCT SUB-FIELD^^5^6
	;;^DD(115.1,0,"DT")
	;;=2950926
	;;^DD(115.1,0,"IX","B",115.1,.01)
	;;=
	;;^DD(115.1,0,"NM","TF PRODUCT")
	;;=
	;;^DD(115.1,0,"UP")
	;;=115.04
	;;^DD(115.1,.01,0)
	;;=TF PRODUCT^MRP118.2'^FH(118.2,^0;1^Q
	;;^DD(115.1,.01,1,0)
	;;=^.1
	;;^DD(115.1,.01,1,1,0)
	;;=115.1^B
	;;^DD(115.1,.01,1,1,1)
	;;=S ^FHPT(DA(3),"A",DA(2),"TF",DA(1),"P","B",$E(X,1,30),DA)=""
	;;^DD(115.1,.01,1,1,2)
	;;=K ^FHPT(DA(3),"A",DA(2),"TF",DA(1),"P","B",$E(X,1,30),DA)
	;;^DD(115.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the TF PRODUCT field.
	;;^DD(115.1,.01,1,1,"DT")
	;;=2910307
	;;^DD(115.1,.01,3)
	;;=
	;;^DD(115.1,.01,21,0)
	;;=^^1^1^2920312^^^^
	;;^DD(115.1,.01,21,1,0)
	;;=This field contains the tubefeeding product to be administered.

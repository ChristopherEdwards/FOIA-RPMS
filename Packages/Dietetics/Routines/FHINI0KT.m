FHINI0KT	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.07,32,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,32,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,32,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,32,21,1,0)
	;;=This is the fourth supplemental feeding ordered for the 8pm
	;;^DD(115.07,32,21,2,0)
	;;=feeding.
	;;^DD(115.07,33,0)
	;;=8PM #4 QTY^NJ2,0^^0;28^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,33,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,33,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,33,21,1,0)
	;;=This is the ordered quantity of the fourth 8pm feeding.
	;;^DD(115.07,34,0)
	;;=DIETARY OR THERAPEUTIC^RS^D:DIETARY;T:THERAPEUTIC;^0;29^Q
	;;^DD(115.07,34,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,34,21,1,0)
	;;=This field indicates whether the supplemental feeding was
	;;^DD(115.07,34,21,2,0)
	;;=ordered for dietary or therapeutic reasons.
	;;^DD(115.07,34,"DT")
	;;=2850928
	;;^DD(115.07,40,0)
	;;=DATE/TIME LAST REVIEW^D^^0;30^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.07,40,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,40,21,1,0)
	;;=This is the date/time this supplemental feeding order was
	;;^DD(115.07,40,21,2,0)
	;;=last reviewed for appropriateness.
	;;^DD(115.07,40,"DT")
	;;=2871018
	;;^DD(115.07,41,0)
	;;=REVIEW CLERK^P200'^VA(200,^0;31^Q
	;;^DD(115.07,41,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,41,21,1,0)
	;;=This is the person conducting the last review and is captured
	;;^DD(115.07,41,21,2,0)
	;;=automatically at time of review.
	;;^DD(115.07,41,"DT")
	;;=2871018
	;;^DD(115.07,42,0)
	;;=DATE/TIME CANCELLED^D^^0;32^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.07,42,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,42,21,1,0)
	;;=This is the date/time this order was cancelled.
	;;^DD(115.07,42,"DT")
	;;=2871018
	;;^DD(115.07,43,0)
	;;=CANCELLING CLERK^P200'^VA(200,^0;33^Q
	;;^DD(115.07,43,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,43,21,1,0)
	;;=This is the person cancelling the order and is captured
	;;^DD(115.07,43,21,2,0)
	;;=automatically at time of cancellation.
	;;^DD(115.07,43,"DT")
	;;=2871018
	;;^DD(115.07,44,0)
	;;=DIET ASSOCIATED?^S^Y:YES;N:NO;^0;34^Q
	;;^DD(115.07,44,21,0)
	;;=^^2^2^2940722^
	;;^DD(115.07,44,21,1,0)
	;;=This field, if answered Yes, means this Supplemental Feeding Menu
	;;^DD(115.07,44,21,2,0)
	;;=is associated with a diet order else if answered No, means it is not.
	;;^DD(115.07,44,"DT")
	;;=2940722
	;;^DD(115.08,0)
	;;=STANDING ORDERS SUB-FIELD^^8^9
	;;^DD(115.08,0,"DT")
	;;=2940722
	;;^DD(115.08,0,"NM","STANDING ORDERS")
	;;=
	;;^DD(115.08,0,"UP")
	;;=115.01
	;;^DD(115.08,.01,0)
	;;=STANDING ORDERS^NJ4,0^^0;1^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.08,.01,1,0)
	;;=^.1^^0
	;;^DD(115.08,.01,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(115.08,.01,21,0)
	;;=^^2^2^2920103^^
	;;^DD(115.08,.01,21,1,0)
	;;=This field contains the sequence number of the standing order
	;;^DD(115.08,.01,21,2,0)
	;;=and has no meaning beyond that.
	;;^DD(115.08,.01,"DT")
	;;=2871108
	;;^DD(115.08,1,0)
	;;=ORDER^RP118.3'^FH(118.3,^0;2^Q
	;;^DD(115.08,1,1,0)
	;;=^.1
	;;^DD(115.08,1,1,1,0)
	;;=115^ASP^MUMPS
	;;^DD(115.08,1,1,1,1)
	;;=S ^FHPT("ASP",DA(2),DA(1),DA)=""
	;;^DD(115.08,1,1,1,2)
	;;=K ^FHPT("ASP",DA(2),DA(1),DA)
	;;^DD(115.08,1,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(115.08,1,1,1,"%D",1,0)
	;;=This creates an "ASP" cross-reference for active orders. It
	;;^DD(115.08,1,1,1,"%D",2,0)
	;;=is killed when the order is cancelled.
	;;^DD(115.08,1,21,0)
	;;=^^2^2^2920103^^^
	;;^DD(115.08,1,21,1,0)
	;;=This field contains the standing order (from the Standing Orders
	;;^DD(115.08,1,21,2,0)
	;;=file, 118.3).
	;;^DD(115.08,1,"DT")
	;;=2871111
	;;^DD(115.08,2,0)
	;;=MEALS^RFX^^0;3^S:$P("ALL",X,1)="" X="BNE" S %=X,X="" S:%["B" X="B" S:%["N" X=X_"N" S:%["E" X=X_"E" K:$L(%)'=$L(X) X K %
	;;^DD(115.08,2,3)
	;;=Answer should be a string of meals (e.g., B  or BN or BNE) or A for all meals
	;;^DD(115.08,2,21,0)
	;;=^^2^2^2880901^^
	;;^DD(115.08,2,21,1,0)
	;;=This field contains the meals to which this standing order
	;;^DD(115.08,2,21,2,0)
	;;=is applicable.
	;;^DD(115.08,2,"DT")
	;;=2880901
	;;^DD(115.08,3,0)
	;;=DATE/TIME ORDERED^RD^^0;4^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.08,3,21,0)
	;;=^^2^2^2880714^
	;;^DD(115.08,3,21,1,0)
	;;=This field contains the date/time at which the standing
	;;^DD(115.08,3,21,2,0)
	;;=order was entered.
	;;^DD(115.08,3,"DT")
	;;=2871111
	;;^DD(115.08,4,0)
	;;=ENTERING CLERK^RP200'^VA(200,^0;5^Q
	;;^DD(115.08,4,21,0)
	;;=^^2^2^2950317^^
	;;^DD(115.08,4,21,1,0)
	;;=This field contains the user who entered the order and is
	;;^DD(115.08,4,21,2,0)
	;;=automatically captured at the time of entry.

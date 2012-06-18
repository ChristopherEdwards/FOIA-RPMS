FHINI0KP	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.03,10,21,3,0)
	;;=initial one or a follow-up to a prior consult.
	;;^DD(115.03,10,"DT")
	;;=2850606
	;;^DD(115.03,11,0)
	;;=OE/RR ORDER^P100^OR(100,^0;13^Q
	;;^DD(115.03,11,21,0)
	;;=^^2^2^2890918^
	;;^DD(115.03,11,21,1,0)
	;;=This field contains a pointer to the OE/RR file order corresponding
	;;^DD(115.03,11,21,2,0)
	;;=to this order.
	;;^DD(115.03,11,"DT")
	;;=2890918
	;;^DD(115.04,0)
	;;=TUBEFEEDING SUB-FIELD^NL^15^11
	;;^DD(115.04,0,"DT")
	;;=2950926
	;;^DD(115.04,0,"NM","TUBEFEEDING")
	;;=
	;;^DD(115.04,0,"UP")
	;;=115.01
	;;^DD(115.04,.01,0)
	;;=TUBEFEEDING^D^^0;1^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.04,.01,21,0)
	;;=^^2^2^2910219^^^^
	;;^DD(115.04,.01,21,1,0)
	;;=This field contains the date/time the tubefeeding was ordered
	;;^DD(115.04,.01,21,2,0)
	;;=and will be effective.
	;;^DD(115.04,.01,"DT")
	;;=2850517
	;;^DD(115.04,3,0)
	;;=TF PRODUCT^115.1P^^P;0
	;;^DD(115.04,3,21,0)
	;;=^^1^1^2910509^^^^
	;;^DD(115.04,3,21,1,0)
	;;=This multiple contains the tubefeeding products selected.
	;;^DD(115.04,4,0)
	;;=COMMENT^F^^0;5^K:$L(X)>60!($L(X)<1) X
	;;^DD(115.04,4,3)
	;;=ANSWER MUST BE 1-60 CHARACTERS IN LENGTH
	;;^DD(115.04,4,21,0)
	;;=^^2^2^2910221^^^
	;;^DD(115.04,4,21,1,0)
	;;=This field contains any free-text comment entered at time
	;;^DD(115.04,4,21,2,0)
	;;=of order entry.
	;;^DD(115.04,4,"DT")
	;;=2850714
	;;^DD(115.04,6,0)
	;;=TOTAL CC'S^NJ5,0^^0;6^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.04,6,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 10000
	;;^DD(115.04,6,21,0)
	;;=^^2^2^2880715^
	;;^DD(115.04,6,21,1,0)
	;;=This field contains the total daily cc's administered of
	;;^DD(115.04,6,21,2,0)
	;;=the prepared (diluted) product.
	;;^DD(115.04,6,"DT")
	;;=2850714
	;;^DD(115.04,7,0)
	;;=TOTAL KCALS/DAY^NJ5,0^^0;7^K:+X'=X!(X>10000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.04,7,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 10000
	;;^DD(115.04,7,21,0)
	;;=^^2^2^2880715^
	;;^DD(115.04,7,21,1,0)
	;;=This field contains the total Kilocalories per day provided
	;;^DD(115.04,7,21,2,0)
	;;=by the tubefeeding.
	;;^DD(115.04,7,"DT")
	;;=2850714
	;;^DD(115.04,10,0)
	;;=ENTERING CLERK^RP200'^VA(200,^0;10^Q
	;;^DD(115.04,10,21,0)
	;;=^^2^2^2880715^
	;;^DD(115.04,10,21,1,0)
	;;=This field contains the user entering the tubefeeding order
	;;^DD(115.04,10,21,2,0)
	;;=and is automatically captured at time of entry.
	;;^DD(115.04,10,"DT")
	;;=2850714
	;;^DD(115.04,11,0)
	;;=CANCELLATION DATE/TIME^D^^0;11^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.04,11,21,0)
	;;=^^2^2^2920318^^
	;;^DD(115.04,11,21,1,0)
	;;=This field contains the date/time the tubefeeding order
	;;^DD(115.04,11,21,2,0)
	;;=was cancelled.
	;;^DD(115.04,11,"DT")
	;;=2850714
	;;^DD(115.04,12,0)
	;;=CANCELLING CLERK^P200'^VA(200,^0;12^Q
	;;^DD(115.04,12,21,0)
	;;=^^2^2^2920318^^
	;;^DD(115.04,12,21,1,0)
	;;=This field contains the user who cancelled the order and is
	;;^DD(115.04,12,21,2,0)
	;;=captured automatically at time of cancellation.
	;;^DD(115.04,12,"DT")
	;;=2850714
	;;^DD(115.04,13,0)
	;;=OE/RR ORDER^P100^OR(100,^0;14^Q
	;;^DD(115.04,13,21,0)
	;;=^^2^2^2890918^
	;;^DD(115.04,13,21,1,0)
	;;=This field contains a pointer to the OE/RR file order corresponding
	;;^DD(115.04,13,21,2,0)
	;;=to this order.
	;;^DD(115.04,13,"DT")
	;;=2890918
	;;^DD(115.04,14,0)
	;;=LAST REVIEW DATE/TIME^D^^0;15^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.04,14,21,0)
	;;=^^2^2^2911204^
	;;^DD(115.04,14,21,1,0)
	;;=This is the date/time that the Tubefeeding order was last reviewed.
	;;^DD(115.04,14,21,2,0)
	;;=Further reviews are based upon this last review date/time.
	;;^DD(115.04,14,"DT")
	;;=2910430
	;;^DD(115.04,15,0)
	;;=REVIEW CLERK^P200'^VA(200,^0;16^Q
	;;^DD(115.04,15,21,0)
	;;=^^1^1^2911204^
	;;^DD(115.04,15,21,1,0)
	;;=This is a pointer to File 200 of the person entering the review.
	;;^DD(115.04,15,"DT")
	;;=2910430
	;;^DD(115.05,0)
	;;=EARLY/LATE TRAY SUB-FIELD^NL^6^7
	;;^DD(115.05,0,"NM","EARLY/LATE TRAY")
	;;=
	;;^DD(115.05,0,"UP")
	;;=115.01
	;;^DD(115.05,.01,0)
	;;=EARLY/LATE TRAY^DX^^0;1^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=X
	;;^DD(115.05,.01,1,0)
	;;=^.1
	;;^DD(115.05,.01,1,1,0)
	;;=115^ADLT
	;;^DD(115.05,.01,1,1,1)
	;;=S ^FHPT("ADLT",$E(X,1,30),DA(2),DA(1),DA)=""
	;;^DD(115.05,.01,1,1,2)
	;;=K ^FHPT("ADLT",$E(X,1,30),DA(2),DA(1),DA)
	;;^DD(115.05,.01,21,0)
	;;=^^2^2^2910123^^
	;;^DD(115.05,.01,21,1,0)
	;;=This field contains the date/time at which the early/late
	;;^DD(115.05,.01,21,2,0)
	;;=tray is to be delivered.
	;;^DD(115.05,.01,"DT")
	;;=2850525
	;;^DD(115.05,1,0)
	;;=MEAL^RS^B:BREAKFAST;N:NOON;E:EVENING;^0;2^Q
	;;^DD(115.05,1,21,0)
	;;=^^1^1^2880718^^

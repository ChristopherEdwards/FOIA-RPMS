FHINI0KI	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.01,18,0)
	;;=DISCHARGE DATE/TIME^D^^0;14^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.01,18,21,0)
	;;=^^3^3^2911223^^
	;;^DD(115.01,18,21,1,0)
	;;=This is the date/time a discharge was processed. It may differ from the
	;;^DD(115.01,18,21,2,0)
	;;=date/time selected by the MAS clerk. It is used if the discharge is
	;;^DD(115.01,18,21,3,0)
	;;=deleted.
	;;^DD(115.01,18,"DT")
	;;=2911129
	;;^DD(115.01,20,0)
	;;=SUPPLEMENTAL FEEDING^115.07^^SF;0
	;;^DD(115.01,20,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.01,20,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.01,20,21,0)
	;;=^^2^2^2910708^^^^
	;;^DD(115.01,20,21,1,0)
	;;=This multiple contains the various supplemental feeding orders
	;;^DD(115.01,20,21,2,0)
	;;=which have been entered for the patient.
	;;^DD(115.01,20,"DT")
	;;=2850604
	;;^DD(115.01,30,0)
	;;=STANDING ORDERS^115.08^^SP;0
	;;^DD(115.01,30,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.01,30,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.01,30,21,0)
	;;=^^2^2^2950317^^^^
	;;^DD(115.01,30,21,1,0)
	;;=This field contains standing orders entered for the patient
	;;^DD(115.01,30,21,2,0)
	;;=during this admission.
	;;^DD(115.01,40,0)
	;;=TUBEFEEDING^115.04D^^TF;0
	;;^DD(115.01,40,21,0)
	;;=^^2^2^2910509^^^^
	;;^DD(115.01,40,21,1,0)
	;;=This multiple contains all tubefeeding orders entered during
	;;^DD(115.01,40,21,2,0)
	;;=this admission.
	;;^DD(115.01,50,0)
	;;=EARLY/LATE TRAY^115.05D^^EL;0
	;;^DD(115.01,50,21,0)
	;;=^^2^2^2910612^^^^
	;;^DD(115.01,50,21,1,0)
	;;=This multiple contains all early/late tray requests ordered
	;;^DD(115.01,50,21,2,0)
	;;=for this patient.
	;;^DD(115.01,80,0)
	;;=CONSULTATION^115.03IDA^^DR;0
	;;^DD(115.01,80,21,0)
	;;=^^2^2^2880909^^^
	;;^DD(115.01,80,21,1,0)
	;;=This multiple contains all of the dietetic consults ordered
	;;^DD(115.01,80,21,2,0)
	;;=during this admission.
	;;^DD(115.01,85,0)
	;;=ADDITIONAL ORDERS^115.06A^^OO;0
	;;^DD(115.01,85,21,0)
	;;=^^1^1^2950222^^^^
	;;^DD(115.01,85,21,1,0)
	;;=This multiple contains all Additional Orders entered during this admission.
	;;^DD(115.01,99,0)
	;;=DATE/TIME TICKET LAST PRINTED^D^^0;15^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.01,99,21,0)
	;;=^^5^5^2950420^^^^
	;;^DD(115.01,99,21,1,0)
	;;=This is the date/time of the last Tray Ticket generated for this
	;;^DD(115.01,99,21,2,0)
	;;=patient.  It is used, when the user only want to print the ticket
	;;^DD(115.01,99,21,3,0)
	;;=for the patient when there is a diet order, supplemental feeding,
	;;^DD(115.01,99,21,4,0)
	;;=food preference, isolation, standing order, or location change after
	;;^DD(115.01,99,21,5,0)
	;;=this date/time.
	;;^DD(115.01,99,"DT")
	;;=2940926
	;;^DD(115.01,100,0)
	;;=DATE/TIME CARD LAST PRINTED^D^^0;16^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.01,100,21,0)
	;;=^^5^5^2950420^^^^
	;;^DD(115.01,100,21,1,0)
	;;=This is the date/time of the last diet card generated for this
	;;^DD(115.01,100,21,2,0)
	;;=patient.  It is used, when the user only want to print the card
	;;^DD(115.01,100,21,3,0)
	;;=for the patient when there is a diet order, supplemental feeding,
	;;^DD(115.01,100,21,4,0)
	;;=food preference, isolation, standing order, or location change after
	;;^DD(115.01,100,21,5,0)
	;;=this date/time.
	;;^DD(115.01,100,"DT")
	;;=2940926
	;;^DD(115.011,0)
	;;=NUTRITION ASSESSMENT SUB-FIELD^^102^35
	;;^DD(115.011,0,"IX","B",115.011,.01)
	;;=
	;;^DD(115.011,0,"NM","NUTRITION ASSESSMENT")
	;;=
	;;^DD(115.011,0,"UP")
	;;=115
	;;^DD(115.011,.01,0)
	;;=NUTRITION ASSESSMENT^D^^0;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.011,.01,1,0)
	;;=^.1
	;;^DD(115.011,.01,1,1,0)
	;;=115.011^B
	;;^DD(115.011,.01,1,1,1)
	;;=S ^FHPT(DA(1),"N","B",$E(X,1,30),DA)=""
	;;^DD(115.011,.01,1,1,2)
	;;=K ^FHPT(DA(1),"N","B",$E(X,1,30),DA)
	;;^DD(115.011,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.011,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NUTRITION ASSESSMENT field.
	;;^DD(115.011,.01,21,0)
	;;=^^2^2^2891107^^^
	;;^DD(115.011,.01,21,1,0)
	;;=This field contains the date the nutrition assessment was
	;;^DD(115.011,.01,21,2,0)
	;;=performed.
	;;^DD(115.011,.01,"DT")
	;;=2891107
	;;^DD(115.011,1,0)
	;;=SEX^RS^M:MALE;F:FEMALE;^0;2^Q
	;;^DD(115.011,1,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,1,21,1,0)
	;;=This field contains a M or F corresponding to the sex of
	;;^DD(115.011,1,21,2,0)
	;;=the subject.
	;;^DD(115.011,1,"DT")
	;;=2890702
	;;^DD(115.011,2,0)
	;;=AGE^RNJ6,2^^0;3^K:+X'=X!(X>140)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(115.011,2,3)
	;;=Type a Number between 0 and 140, 2 Decimal Digits
	;;^DD(115.011,2,21,0)
	;;=^^2^2^2891121^

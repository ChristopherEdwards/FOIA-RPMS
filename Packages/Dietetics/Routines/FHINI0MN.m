FHINI0MN	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.6,16,"DT")
	;;=2880904
	;;^DD(119.6,20,0)
	;;=BULK NOURISHMENTS^119.61P^^BN;0
	;;^DD(119.6,20,21,0)
	;;=^^2^2^2911204^^
	;;^DD(119.6,20,21,1,0)
	;;=This multiple represents bulk nourishments (supplemental feedings)
	;;^DD(119.6,20,21,2,0)
	;;=delivered to this ward.
	;;^DD(119.6,21,0)
	;;=# DAYS TO REVIEW NPO^NJ1,0^^0;11^K:+X'=X!(X>7)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,21,3)
	;;=Type a Number between 1 and 7, 0 Decimal Digits
	;;^DD(119.6,21,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,21,21,1,0)
	;;=This field indicates the number of days following an NPO order after
	;;^DD(119.6,21,21,2,0)
	;;=which the patient should be reviewed.
	;;^DD(119.6,21,"DT")
	;;=2910430
	;;^DD(119.6,22,0)
	;;=# DAYS TO REVIEW TF^NJ2,0^^0;12^K:+X'=X!(X>30)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,22,3)
	;;=Type a Number between 1 and 30, 0 Decimal Digits
	;;^DD(119.6,22,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,22,21,1,0)
	;;=This field indicates the number of days following a Tubefeeding order
	;;^DD(119.6,22,21,2,0)
	;;=after which the patient should be reviewed.
	;;^DD(119.6,22,"DT")
	;;=2910430
	;;^DD(119.6,23,0)
	;;=# DAYS TO REVIEW SF^NJ2,0^^0;13^K:+X'=X!(X>30)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,23,3)
	;;=Type a Number between 1 and 30, 0 Decimal Digits
	;;^DD(119.6,23,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,23,21,1,0)
	;;=This field indicates the number of days following a Supplemental Feeding
	;;^DD(119.6,23,21,2,0)
	;;=order after which the patient should be reviewed.
	;;^DD(119.6,23,"DT")
	;;=2910430
	;;^DD(119.6,24,0)
	;;=# DAYS FOR STATUS AFTER ADMIT^NJ2,0^^0;14^K:+X'=X!(X>30)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,24,3)
	;;=Type a Number between 1 and 30, 0 Decimal Digits
	;;^DD(119.6,24,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,24,21,1,0)
	;;=This field indicates the number of days following admission after which
	;;^DD(119.6,24,21,2,0)
	;;=a Nutrition Status evaluation should have been performed.
	;;^DD(119.6,24,"DT")
	;;=2910517
	;;^DD(119.6,25,0)
	;;=# DAYS TO REVIEW STATUS I^NJ3,0^^0;20^K:+X'=X!(X>120)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,25,3)
	;;=Type a Number between 1 and 120, 0 Decimal Digits
	;;^DD(119.6,25,21,0)
	;;=^^2^2^2920106^^
	;;^DD(119.6,25,21,1,0)
	;;=This is the number of days after which a patient in this Nutrition
	;;^DD(119.6,25,21,2,0)
	;;=Status category should be reviewed.
	;;^DD(119.6,25,"DT")
	;;=2930222
	;;^DD(119.6,26,0)
	;;=# DAYS TO REVIEW STATUS II^NJ3,0^^0;21^K:+X'=X!(X>120)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,26,3)
	;;=Type a Number between 1 and 120, 0 Decimal Digits
	;;^DD(119.6,26,21,0)
	;;=^^2^2^2920106^^
	;;^DD(119.6,26,21,1,0)
	;;=This is the number of days after which a patient in this Nutrition
	;;^DD(119.6,26,21,2,0)
	;;=Status category should be reviewed.
	;;^DD(119.6,26,"DT")
	;;=2930222
	;;^DD(119.6,27,0)
	;;=# DAYS TO REVIEW STATUS III^NJ3,0^^0;22^K:+X'=X!(X>120)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,27,3)
	;;=Type a Number between 1 and 120, 0 Decimal Digits
	;;^DD(119.6,27,21,0)
	;;=^^2^2^2920106^^
	;;^DD(119.6,27,21,1,0)
	;;=This is the number of days after which a patient in this Nutrition
	;;^DD(119.6,27,21,2,0)
	;;=Status category should be reviewed.
	;;^DD(119.6,27,"DT")
	;;=2930222
	;;^DD(119.6,28,0)
	;;=# DAYS TO REVIEW STATUS IV^NJ3,0^^0;23^K:+X'=X!(X>120)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,28,3)
	;;=Type a Number between 1 and 120, 0 Decimal Digits
	;;^DD(119.6,28,21,0)
	;;=^^2^2^2920106^^
	;;^DD(119.6,28,21,1,0)
	;;=This is the number of days after which a patient in this Nutrition
	;;^DD(119.6,28,21,2,0)
	;;=Status category should be reviewed.
	;;^DD(119.6,28,"DT")
	;;=2930222
	;;^DD(119.6,29,0)
	;;=CAFETERIA ON TRAY TICKET^S^Y:YES;N:NO;^0;24^Q
	;;^DD(119.6,29,21,0)
	;;=^^2^2^2940413^
	;;^DD(119.6,29,21,1,0)
	;;=This field is optional and it is used to indicate whether patients
	;;^DD(119.6,29,21,2,0)
	;;=that go to the cafeteria should be included on the tray ticket.
	;;^DD(119.6,29,"DT")
	;;=2940413
	;;^DD(119.6,101,0)
	;;=SERVICES^F^^0;10^K:$L(X)>3!($L(X)<1) X
	;;^DD(119.6,101,3)
	;;=Answer must be 1-3 characters in length.
	;;^DD(119.6,101,21,0)
	;;=^^2^2^2940413^^
	;;^DD(119.6,101,21,1,0)
	;;=This field contains one or more of the characters T, C or D indicating
	;;^DD(119.6,101,21,2,0)
	;;=tray service, cafeteria service, and/or dining room service is available.
	;;^DD(119.6,101,"DT")
	;;=2911031
	;;^DD(119.61,0)
	;;=BULK NOURISHMENTS SUB-FIELD^NL^1^2
	;;^DD(119.61,0,"NM","BULK NOURISHMENTS")
	;;=
	;;^DD(119.61,0,"UP")
	;;=119.6
	;;^DD(119.61,.01,0)
	;;=BULK NOURISHMENTS^MP118'^FH(118,^0;1^Q
	;;^DD(119.61,.01,21,0)
	;;=^^2^2^2880717^
	;;^DD(119.61,.01,21,1,0)
	;;=This field contains the name of the bulk nourishment (supplemental

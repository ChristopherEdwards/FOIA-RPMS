FHINI0MV	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.73)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.73,0,"GL")
	;;=^FH(119.73,
	;;^DIC("B","COMMUNICATION OFFICE",119.73)
	;;=
	;;^DIC(119.73,"%D",0)
	;;=^^3^3^2911204^
	;;^DIC(119.73,"%D",1,0)
	;;=This file is a list of Communication Offices and associated parameters.
	;;^DIC(119.73,"%D",2,0)
	;;=A Communication Office has responsibility for processing diet orders
	;;^DIC(119.73,"%D",3,0)
	;;=for a group of wards.
	;;^DD(119.73,0)
	;;=FIELD^^102^31
	;;^DD(119.73,0,"DT")
	;;=2921007
	;;^DD(119.73,0,"IX","B",119.73,.01)
	;;=
	;;^DD(119.73,0,"NM","COMMUNICATION OFFICE")
	;;=
	;;^DD(119.73,0,"PT",119.6,6)
	;;=
	;;^DD(119.73,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(119.73,.01,1,0)
	;;=^.1
	;;^DD(119.73,.01,1,1,0)
	;;=119.73^B
	;;^DD(119.73,.01,1,1,1)
	;;=S ^FH(119.73,"B",$E(X,1,30),DA)=""
	;;^DD(119.73,.01,1,1,2)
	;;=K ^FH(119.73,"B",$E(X,1,30),DA)
	;;^DD(119.73,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.73,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.73,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(119.73,.01,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.73,.01,21,1,0)
	;;=This is the name of the Communication Office. It is responsible for
	;;^DD(119.73,.01,21,2,0)
	;;=processing the diet orders from a group of Dietetic wards.
	;;^DD(119.73,.01,"DT")
	;;=2921007
	;;^DD(119.73,6,0)
	;;=BEGIN BREAKFAST WINDOW^RFX^^2;7^D TIM^FHSYSP
	;;^DD(119.73,6,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,6,21,0)
	;;=^^3^3^2880713^
	;;^DD(119.73,6,21,1,0)
	;;=This is the latest time for which breakfast orders will be accepted
	;;^DD(119.73,6,21,2,0)
	;;=and is used as the time associated with the use of the 'B' (for
	;;^DD(119.73,6,21,3,0)
	;;=breakfast) time in diet orders.
	;;^DD(119.73,6,"DT")
	;;=2850302
	;;^DD(119.73,7,0)
	;;=BEGIN NOON WINDOW^RFX^^2;8^D TIM^FHSYSP
	;;^DD(119.73,7,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,7,21,0)
	;;=^^3^3^2880713^
	;;^DD(119.73,7,21,1,0)
	;;=This is the latest time for which noon orders will be accepted
	;;^DD(119.73,7,21,2,0)
	;;=and is used as the time associated with the use of the 'N' (for
	;;^DD(119.73,7,21,3,0)
	;;=noon) time in diet orders.
	;;^DD(119.73,7,"DT")
	;;=2850302
	;;^DD(119.73,8,0)
	;;=BEGIN EVENING WINDOW^RFX^^2;9^D TIM^FHSYSP
	;;^DD(119.73,8,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,8,21,0)
	;;=^^3^3^2880713^
	;;^DD(119.73,8,21,1,0)
	;;=This is the latest time for which evening orders will be accepted
	;;^DD(119.73,8,21,2,0)
	;;=and is used as the time associated with the use of the 'E' (for
	;;^DD(119.73,8,21,3,0)
	;;=evening) time in diet orders.
	;;^DD(119.73,8,"DT")
	;;=2850302
	;;^DD(119.73,9,0)
	;;=PROVIDE BAGGED MEALS?^S^Y:YES;N:NO;^2;10^Q
	;;^DD(119.73,9,21,0)
	;;=^^2^2^2910612^^^
	;;^DD(119.73,9,21,1,0)
	;;=If answered YES, this field indicates that bagged meals can be
	;;^DD(119.73,9,21,2,0)
	;;=ordered as part of the early/late tray ordering process.
	;;^DD(119.73,9,"DT")
	;;=2880116
	;;^DD(119.73,10,0)
	;;=EARLY BREAKFAST TIME 1^FX^^1;1^D TIM^FHSYSP
	;;^DD(119.73,10,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,10,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,10,21,1,0)
	;;=This is the first delivery time for an early breakfast tray.
	;;^DD(119.73,10,"DT")
	;;=2850517
	;;^DD(119.73,11,0)
	;;=EARLY BREAKFAST TIME 2^FX^^1;2^D TIM^FHSYSP
	;;^DD(119.73,11,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,11,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,11,21,1,0)
	;;=This is the second delivery time for an early breakfast tray.
	;;^DD(119.73,11,"DT")
	;;=2850517
	;;^DD(119.73,12,0)
	;;=EARLY BREAKFAST TIME 3^FX^^1;3^D TIM^FHSYSP
	;;^DD(119.73,12,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,12,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,12,21,1,0)
	;;=This is the third delivery time for an early breakfast tray.
	;;^DD(119.73,12,"DT")
	;;=2850517
	;;^DD(119.73,13,0)
	;;=LATE BREAKFAST TIME 1^FX^^1;4^D TIM^FHSYSP
	;;^DD(119.73,13,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,13,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,13,21,1,0)
	;;=This is the first delivery time for a late breakfast tray.
	;;^DD(119.73,13,"DT")
	;;=2850517
	;;^DD(119.73,14,0)
	;;=LATE BREAKFAST TIME 2^FX^^1;5^D TIM^FHSYSP
	;;^DD(119.73,14,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,14,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,14,21,1,0)
	;;=This is the second delivery time for a late breakfast tray.
	;;^DD(119.73,14,"DT")
	;;=2850517
	;;^DD(119.73,15,0)
	;;=LATE BREAKFAST TIME 3^FX^^1;6^D TIM^FHSYSP
	;;^DD(119.73,15,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,15,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,15,21,1,0)
	;;=This is the third delivery time for a late breakfast tray.

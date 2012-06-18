FHINI0MW	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.73)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.73,15,"DT")
	;;=2850517
	;;^DD(119.73,16,0)
	;;=EARLY NOON TIME 1^FX^^1;7^D TIM^FHSYSP
	;;^DD(119.73,16,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,16,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,16,21,1,0)
	;;=This is the first delivery time for an early noon tray.
	;;^DD(119.73,16,"DT")
	;;=2850517
	;;^DD(119.73,17,0)
	;;=EARLY NOON TIME 2^FX^^1;8^D TIM^FHSYSP
	;;^DD(119.73,17,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,17,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,17,21,1,0)
	;;=This is the second delivery time for an early noon tray.
	;;^DD(119.73,17,"DT")
	;;=2850517
	;;^DD(119.73,18,0)
	;;=EARLY NOON TIME 3^FX^^1;9^D TIM^FHSYSP
	;;^DD(119.73,18,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,18,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,18,21,1,0)
	;;=This is the third delivery time for an early noon tray.
	;;^DD(119.73,18,"DT")
	;;=2850517
	;;^DD(119.73,19,0)
	;;=LATE NOON TIME 1^FX^^1;10^D TIM^FHSYSP
	;;^DD(119.73,19,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,19,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,19,21,1,0)
	;;=This is the first delivery time for a late noon tray.
	;;^DD(119.73,19,"DT")
	;;=2850517
	;;^DD(119.73,20,0)
	;;=LATE NOON TIME 2^FX^^1;11^D TIM^FHSYSP
	;;^DD(119.73,20,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,20,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,20,21,1,0)
	;;=This is the second delivery time for a late noon tray.
	;;^DD(119.73,20,"DT")
	;;=2850517
	;;^DD(119.73,21,0)
	;;=LATE NOON TIME 3^FX^^1;12^D TIM^FHSYSP
	;;^DD(119.73,21,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,21,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,21,21,1,0)
	;;=This is the third delivery time for a late noon tray.
	;;^DD(119.73,21,"DT")
	;;=2850517
	;;^DD(119.73,22,0)
	;;=EARLY EVENING TIME 1^FX^^1;13^D TIM^FHSYSP
	;;^DD(119.73,22,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,22,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,22,21,1,0)
	;;=This is the first delivery time for an early evening tray.
	;;^DD(119.73,22,"DT")
	;;=2850517
	;;^DD(119.73,23,0)
	;;=EARLY EVENING TIME 2^FX^^1;14^D TIM^FHSYSP
	;;^DD(119.73,23,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,23,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,23,21,1,0)
	;;=This is the second delivery time for an early evening tray.
	;;^DD(119.73,23,"DT")
	;;=2850517
	;;^DD(119.73,24,0)
	;;=EARLY EVENING TIME 3^FX^^1;15^D TIM^FHSYSP
	;;^DD(119.73,24,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,24,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,24,21,1,0)
	;;=This is the third delivery time for an early evening tray.
	;;^DD(119.73,24,"DT")
	;;=2850517
	;;^DD(119.73,25,0)
	;;=LATE EVENING TIME 1^FX^^1;16^D TIM^FHSYSP
	;;^DD(119.73,25,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,25,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,25,21,1,0)
	;;=This is the first delivery time for a late evening tray.
	;;^DD(119.73,25,"DT")
	;;=2850517
	;;^DD(119.73,26,0)
	;;=LATE EVENING TIME 2^FX^^1;17^D TIM^FHSYSP
	;;^DD(119.73,26,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,26,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,26,21,1,0)
	;;=This is the second delivery time for a late evening tray.
	;;^DD(119.73,26,"DT")
	;;=2850517
	;;^DD(119.73,27,0)
	;;=LATE EVENING TIME 3^FX^^1;18^D TIM^FHSYSP
	;;^DD(119.73,27,3)
	;;=ANSWER MUST BE A TIME OF DAY
	;;^DD(119.73,27,21,0)
	;;=^^1^1^2880716^
	;;^DD(119.73,27,21,1,0)
	;;=This is the third delivery time for a late evening tray.
	;;^DD(119.73,27,"DT")
	;;=2850517
	;;^DD(119.73,28,0)
	;;=LATE BREAKFAST ALARM BEGIN^FXO^^2;1^D TIM^FHSYSP I $D(X) D MIL^FHSYSP S X=X1
	;;^DD(119.73,28,2)
	;;=S Y(0)=Y D MIP^FHSYSP
	;;^DD(119.73,28,2.1)
	;;=D MIP^FHSYSP
	;;^DD(119.73,28,3)
	;;=ANSWER MUST BE 1-7 CHARACTERS IN LENGTH
	;;^DD(119.73,28,21,0)
	;;=^^4^4^2880716^
	;;^DD(119.73,28,21,1,0)
	;;=This is the beginning of the late breakfast alarm period; that
	;;^DD(119.73,28,21,2,0)
	;;=is the time when persons entering diet orders will be reminded
	;;^DD(119.73,28,21,3,0)
	;;=that the normal cut-off time has passed and a late tray will
	;;^DD(119.73,28,21,4,0)
	;;=have to be ordered for breakfast if desired.
	;;^DD(119.73,28,"DT")
	;;=2871110
	;;^DD(119.73,29,0)
	;;=LATE BREAKFAST ALARM END^FXO^^2;2^D TIM^FHSYSP I $D(X) D MIL^FHSYSP S X=X1
	;;^DD(119.73,29,2)
	;;=S Y(0)=Y D MIP^FHSYSP
	;;^DD(119.73,29,2.1)
	;;=D MIP^FHSYSP
	;;^DD(119.73,29,3)
	;;=ANSWER MUST BE 1-7 CHARACTERS IN LENGTH
	;;^DD(119.73,29,21,0)
	;;=^^3^3^2880718^^
	;;^DD(119.73,29,21,1,0)
	;;=This is the end of the breakfast alarm period. It should be
	;;^DD(119.73,29,21,2,0)
	;;=one or two minutes earlier than the last breakfast late tray delivery
	;;^DD(119.73,29,21,3,0)
	;;=time.
	;;^DD(119.73,29,"DT")
	;;=2871110

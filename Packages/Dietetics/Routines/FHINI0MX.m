FHINI0MX	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.73)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.73,30,0)
	;;=LATE NOON ALARM BEGIN^FXO^^2;3^D TIM^FHSYSP I $D(X) D MIL^FHSYSP S X=X1
	;;^DD(119.73,30,2)
	;;=S Y(0)=Y D MIP^FHSYSP
	;;^DD(119.73,30,2.1)
	;;=D MIP^FHSYSP
	;;^DD(119.73,30,3)
	;;=ANSWER MUST BE 1-7 CHARACTERS IN LENGTH
	;;^DD(119.73,30,21,0)
	;;=^^3^3^2880716^
	;;^DD(119.73,30,21,1,0)
	;;=This is the beginning of the noon alarm period; persons entering
	;;^DD(119.73,30,21,2,0)
	;;=diet orders will be reminded that the noon cut-off has passed
	;;^DD(119.73,30,21,3,0)
	;;=and a late noon tray will have to be ordered if desired.
	;;^DD(119.73,30,"DT")
	;;=2871110
	;;^DD(119.73,31,0)
	;;=LATE NOON ALARM END^FXO^^2;4^D TIM^FHSYSP I $D(X) D MIL^FHSYSP S X=X1
	;;^DD(119.73,31,2)
	;;=S Y(0)=Y D MIP^FHSYSP
	;;^DD(119.73,31,2.1)
	;;=D MIP^FHSYSP
	;;^DD(119.73,31,3)
	;;=ANSWER MUST BE 1-7 CHARACTERS IN LENGTH
	;;^DD(119.73,31,21,0)
	;;=^^2^2^2880716^
	;;^DD(119.73,31,21,1,0)
	;;=This is the end of the noon alarm period and should be one or two
	;;^DD(119.73,31,21,2,0)
	;;=minutes earlier than the last noon late tray delivery time.
	;;^DD(119.73,31,"DT")
	;;=2871110
	;;^DD(119.73,32,0)
	;;=LATE EVENING ALARM BEGIN^FXO^^2;5^D TIM^FHSYSP I $D(X) D MIL^FHSYSP S X=X1
	;;^DD(119.73,32,2)
	;;=S Y(0)=Y D MIP^FHSYSP
	;;^DD(119.73,32,2.1)
	;;=D MIP^FHSYSP
	;;^DD(119.73,32,3)
	;;=ANSWER MUST BE 1-7 CHARACTERS IN LENGTH
	;;^DD(119.73,32,21,0)
	;;=^^4^4^2880716^
	;;^DD(119.73,32,21,1,0)
	;;=This is the beginning of the evening alarm period; that is the period
	;;^DD(119.73,32,21,2,0)
	;;=when persons entering diet orders will be reminded that the
	;;^DD(119.73,32,21,3,0)
	;;=evening cut-off has passed and a late evening tray will have
	;;^DD(119.73,32,21,4,0)
	;;=to be ordered if desired.
	;;^DD(119.73,32,"DT")
	;;=2871110
	;;^DD(119.73,33,0)
	;;=LATE EVENING ALARM END^FXO^^2;6^D TIM^FHSYSP I $D(X) D MIL^FHSYSP S X=X1
	;;^DD(119.73,33,2)
	;;=S Y(0)=Y D MIP^FHSYSP
	;;^DD(119.73,33,2.1)
	;;=D MIP^FHSYSP
	;;^DD(119.73,33,3)
	;;=ANSWER MUST BE 1-7 CHARACTERS IN LENGTH
	;;^DD(119.73,33,21,0)
	;;=^^3^3^2880716^
	;;^DD(119.73,33,21,1,0)
	;;=This is the end of the evening alarm period and should be one or
	;;^DD(119.73,33,21,2,0)
	;;=two minutes earlier than the last evening late tray delivery
	;;^DD(119.73,33,21,3,0)
	;;=time.
	;;^DD(119.73,33,"DT")
	;;=2871110
	;;^DD(119.73,101,0)
	;;=DATE/TIME LAST UPDATE^D^^0;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(119.73,101,21,0)
	;;=^^3^3^2950420^^^^
	;;^DD(119.73,101,21,1,0)
	;;=This is the date/time of the last Diet Activity report generated for
	;;^DD(119.73,101,21,2,0)
	;;=this Communication Office. It is used so that the following report
	;;^DD(119.73,101,21,3,0)
	;;=will show only changes after this date/time.
	;;^DD(119.73,101,"DT")
	;;=2911101
	;;^DD(119.73,102,0)
	;;=LAST LABEL UPDATE^D^^0;3^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(119.73,102,21,0)
	;;=^^2^2^2920822^
	;;^DD(119.73,102,21,1,0)
	;;=This is the last date/time the labels were generated for the
	;;^DD(119.73,102,21,2,0)
	;;=Diet Activity Report
	;;^DD(119.73,102,"DT")
	;;=2920822

FHINI0LD	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(116.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(116.3,0,"GL")
	;;=^FH(116.3,
	;;^DIC("B","HOLIDAY MEALS",116.3)
	;;=
	;;^DIC(116.3,"%D",0)
	;;=^^5^5^2880515^
	;;^DIC(116.3,"%D",1,0)
	;;=This file consists of a list of holiday dates for which special
	;;^DIC(116.3,"%D",2,0)
	;;=meals are prepared. It consists of the holiday date, name, and
	;;^DIC(116.3,"%D",3,0)
	;;=allows for entry of a breakfast, noon, and/or evening meal
	;;^DIC(116.3,"%D",4,0)
	;;=which, if present, will override the normal menu cycle meals
	;;^DIC(116.3,"%D",5,0)
	;;=on that date.
	;;^DD(116.3,0)
	;;=FIELD^^4^5
	;;^DD(116.3,0,"IX","B",116.3,.01)
	;;=
	;;^DD(116.3,0,"NM","HOLIDAY MEALS")
	;;=
	;;^DD(116.3,.01,0)
	;;=DATE^RD^^0;1^S %DT="EX" D ^%DT S X=Y,DINUM=X K:Y<1 X,DINUM
	;;^DD(116.3,.01,1,0)
	;;=^.1
	;;^DD(116.3,.01,1,1,0)
	;;=116.3^B
	;;^DD(116.3,.01,1,1,1)
	;;=S ^FH(116.3,"B",$E(X,1,30),DA)=""
	;;^DD(116.3,.01,1,1,2)
	;;=K ^FH(116.3,"B",$E(X,1,30),DA)
	;;^DD(116.3,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116.3,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the DATE field.
	;;^DD(116.3,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(116.3,.01,21,0)
	;;=^^3^3^2880717^
	;;^DD(116.3,.01,21,1,0)
	;;=This is the date of a holiday. A holiday, for purposes of this
	;;^DD(116.3,.01,21,2,0)
	;;=program, is a date upon which one or more of the normal cycle
	;;^DD(116.3,.01,21,3,0)
	;;=meals are suspended and other special meals substituted.
	;;^DD(116.3,1,0)
	;;=HOLIDAY NAME^RF^^0;5^K:$L(X)>30!($L(X)<1) X
	;;^DD(116.3,1,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(116.3,1,21,0)
	;;=^^1^1^2880717^
	;;^DD(116.3,1,21,1,0)
	;;=This field represents the name of the holiday.
	;;^DD(116.3,1,"DT")
	;;=2861206
	;;^DD(116.3,2,0)
	;;=BREAKFAST MEAL^P116.1'^FH(116.1,^0;2^Q
	;;^DD(116.3,2,21,0)
	;;=^^2^2^2880717^
	;;^DD(116.3,2,21,1,0)
	;;=This field, if present, contains the meal which will override
	;;^DD(116.3,2,21,2,0)
	;;=the normal cycle breakfast meal.
	;;^DD(116.3,2,"DT")
	;;=2861206
	;;^DD(116.3,3,0)
	;;=NOON MEAL^P116.1'^FH(116.1,^0;3^Q
	;;^DD(116.3,3,21,0)
	;;=^^2^2^2880717^
	;;^DD(116.3,3,21,1,0)
	;;=This field, if present, contains the meal which will override
	;;^DD(116.3,3,21,2,0)
	;;=the normal cycle noon meal.
	;;^DD(116.3,3,"DT")
	;;=2861206
	;;^DD(116.3,4,0)
	;;=EVENING MEAL^P116.1'^FH(116.1,^0;4^Q
	;;^DD(116.3,4,21,0)
	;;=^^2^2^2880717^
	;;^DD(116.3,4,21,1,0)
	;;=This field, if present, contains the meal which will override
	;;^DD(116.3,4,21,2,0)
	;;=the normal cycle evening meal.
	;;^DD(116.3,4,"DT")
	;;=2861206

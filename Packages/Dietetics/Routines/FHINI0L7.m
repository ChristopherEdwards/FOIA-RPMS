FHINI0L7	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(116)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(116,0,"GL")
	;;=^FH(116,
	;;^DIC("B","MENU CYCLE",116)
	;;=
	;;^DIC(116,"%D",0)
	;;=^^4^4^2880515^
	;;^DIC(116,"%D",1,0)
	;;=A menu cycle consists of some specified number of days each day
	;;^DIC(116,"%D",2,0)
	;;=of which is associated with a breakfast, noon, and evening meal.
	;;^DIC(116,"%D",3,0)
	;;=An effective date determines the start of the cycle and it will
	;;^DIC(116,"%D",4,0)
	;;=repeat until the effective date of another menu cycle begins.
	;;^DD(116,0)
	;;=FIELD^^3^4
	;;^DD(116,0,"IX","AB",116.02,.01)
	;;=
	;;^DD(116,0,"IX","B",116,.01)
	;;=
	;;^DD(116,0,"NM","MENU CYCLE")
	;;=
	;;^DD(116,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(+X=X)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(116,.01,1,0)
	;;=^.1
	;;^DD(116,.01,1,1,0)
	;;=116^B
	;;^DD(116,.01,1,1,1)
	;;=S ^FH(116,"B",$E(X,1,30),DA)=""
	;;^DD(116,.01,1,1,2)
	;;=K ^FH(116,"B",$E(X,1,30),DA)
	;;^DD(116,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(116,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(116,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(116,.01,21,1,0)
	;;=This is the name of a menu cycle, and is often 'Summer
	;;^DD(116,.01,21,2,0)
	;;=cycle' or 'Winter cycle.'
	;;^DD(116,1,0)
	;;=DAY^116.01^^DA;0
	;;^DD(116,1,21,0)
	;;=^^2^2^2880710^
	;;^DD(116,1,21,1,0)
	;;=This field contains the day number within the cycle and is
	;;^DD(116,1,21,2,0)
	;;=therefore 1 to the number of days in the cycle.
	;;^DD(116,2,0)
	;;=NO. DAYS IN CYCLE^RNJ3,0^^0;2^K:+X'=X!(X>365)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(116,2,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 365
	;;^DD(116,2,21,0)
	;;=^^3^3^2880710^
	;;^DD(116,2,21,1,0)
	;;=This is the number of days in the cycle, after which it will
	;;^DD(116,2,21,2,0)
	;;=repeat. The day numbers in the Day Field (Field 1) should
	;;^DD(116,2,21,3,0)
	;;=run from 1 to this number.
	;;^DD(116,2,"DT")
	;;=2851213
	;;^DD(116,3,0)
	;;=EFFECTIVE DATE^116.02D^^DT;0
	;;^DD(116,3,21,0)
	;;=^^4^4^2880710^
	;;^DD(116,3,21,1,0)
	;;=This multiple contains dates upon which this cycle will become
	;;^DD(116,3,21,2,0)
	;;=effective and will continue until superceded by the effective
	;;^DD(116,3,21,3,0)
	;;=date of this or another cycle. The date becomes Day 1 of the
	;;^DD(116,3,21,4,0)
	;;=selected cycle.
	;;^DD(116.01,0)
	;;=DAY SUB-FIELD^NL^3^4
	;;^DD(116.01,0,"NM","DAY")
	;;=
	;;^DD(116.01,0,"UP")
	;;=116
	;;^DD(116.01,.01,0)
	;;=DAY^MNJ3,0X^^0;1^K:+X'=X!(X>$P(^FH(116,DA(1),0),"^",2))!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(116.01,.01,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND THE # OF DAYS IN THE CYCLE
	;;^DD(116.01,.01,21,0)
	;;=^^1^1^2880710^
	;;^DD(116.01,.01,21,1,0)
	;;=This is the day number within the cycle.
	;;^DD(116.01,.01,"DT")
	;;=2860421
	;;^DD(116.01,1,0)
	;;=BREAKFAST MEAL^RP116.1'^FH(116.1,^0;2^Q
	;;^DD(116.01,1,21,0)
	;;=^^2^2^2880710^
	;;^DD(116.01,1,21,1,0)
	;;=This is the meal (File 116.1) which will be served for
	;;^DD(116.01,1,21,2,0)
	;;=breakfast on this cycle day.
	;;^DD(116.01,1,"DT")
	;;=2860818
	;;^DD(116.01,2,0)
	;;=NOON MEAL^RP116.1'^FH(116.1,^0;3^Q
	;;^DD(116.01,2,21,0)
	;;=^^2^2^2880710^
	;;^DD(116.01,2,21,1,0)
	;;=This is the meal (File 116.1) which will be served for
	;;^DD(116.01,2,21,2,0)
	;;=Noon or Lunch on this cycle day.
	;;^DD(116.01,2,"DT")
	;;=2860818
	;;^DD(116.01,3,0)
	;;=EVENING MEAL^RP116.1'^FH(116.1,^0;4^Q
	;;^DD(116.01,3,21,0)
	;;=^^2^2^2880710^
	;;^DD(116.01,3,21,1,0)
	;;=This is the meal (File 116.1) which will be served in
	;;^DD(116.01,3,21,2,0)
	;;=the evening of this cycle day.
	;;^DD(116.01,3,"DT")
	;;=2860818
	;;^DD(116.02,0)
	;;=EFFECTIVE DATE SUB-FIELD^^.01^1
	;;^DD(116.02,0,"NM","EFFECTIVE DATE")
	;;=
	;;^DD(116.02,0,"UP")
	;;=116
	;;^DD(116.02,.01,0)
	;;=EFFECTIVE DATE^MD^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(116.02,.01,1,0)
	;;=^.1
	;;^DD(116.02,.01,1,1,0)
	;;=116^AB
	;;^DD(116.02,.01,1,1,1)
	;;=S ^FH(116,"AB",$E(X,1,30),DA(1),DA)=""
	;;^DD(116.02,.01,1,1,2)
	;;=K ^FH(116,"AB",$E(X,1,30),DA(1),DA)
	;;^DD(116.02,.01,21,0)
	;;=^^1^1^2880710^
	;;^DD(116.02,.01,21,1,0)
	;;=This is the date upon which this cycle will become effective.
	;;^DD(116.02,.01,"DT")
	;;=2860818

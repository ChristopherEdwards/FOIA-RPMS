FHINI0KR	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.07,.01,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(115.07,.01,21,0)
	;;=^^2^2^2910708^^
	;;^DD(115.07,.01,21,1,0)
	;;=This field is merely the sequence in which the various orders
	;;^DD(115.07,.01,21,2,0)
	;;=were entered and has no meaning beyond that.
	;;^DD(115.07,.01,"DT")
	;;=2871018
	;;^DD(115.07,1,0)
	;;=DATE/TIME ORDERED^RD^^0;2^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.07,1,21,0)
	;;=^^2^2^2910612^^^
	;;^DD(115.07,1,21,1,0)
	;;=This is the date/time at which the order was entered and is
	;;^DD(115.07,1,21,2,0)
	;;=captured automatically.
	;;^DD(115.07,1,"DT")
	;;=2871018
	;;^DD(115.07,2,0)
	;;=ENTERING CLERK^RP200'^VA(200,^0;3^Q
	;;^DD(115.07,2,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,2,21,1,0)
	;;=This is the person actually entering the order and is captured
	;;^DD(115.07,2,21,2,0)
	;;=automatically at time of entry.
	;;^DD(115.07,2,"DT")
	;;=2871018
	;;^DD(115.07,3,0)
	;;=SF MENU^RP118.1'^FH(118.1,^0;4^Q
	;;^DD(115.07,3,21,0)
	;;=^^4^4^2880718^^
	;;^DD(115.07,3,21,1,0)
	;;=This is the supplemental feeding menu of the
	;;^DD(115.07,3,21,2,0)
	;;=Supplemental Feeding Menu file (118.1) that was selected. If
	;;^DD(115.07,3,21,3,0)
	;;=other than 'Individualized', the items from the selected
	;;^DD(115.07,3,21,4,0)
	;;=menu were moved into this order.
	;;^DD(115.07,3,"DT")
	;;=2871018
	;;^DD(115.07,10,0)
	;;=10AM FEEDING #1^*P118'^FH(118,^0;5^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,10,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,10,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,10,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,10,21,1,0)
	;;=This is the first supplemental feeding ordered for the 10am
	;;^DD(115.07,10,21,2,0)
	;;=feeding.
	;;^DD(115.07,10,"DT")
	;;=2871018
	;;^DD(115.07,11,0)
	;;=10AM #1 QTY^NJ2,0^^0;6^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,11,3)
	;;=Type a Number between 1 and 20, 0 Decimal Digits
	;;^DD(115.07,11,21,0)
	;;=^^1^1^2880710^^^
	;;^DD(115.07,11,21,1,0)
	;;=This is the ordered quantity of the first 10am feeding.
	;;^DD(115.07,11,"DT")
	;;=2871018
	;;^DD(115.07,12,0)
	;;=10AM FEEDING #2^*P118'^FH(118,^0;7^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,12,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,12,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,12,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,12,21,1,0)
	;;=This is the second supplemental feeding ordered for the 10am
	;;^DD(115.07,12,21,2,0)
	;;=feeding.
	;;^DD(115.07,13,0)
	;;=10AM #2 QTY^NJ2,0^^0;8^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,13,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,13,21,0)
	;;=^^1^1^2880710^^
	;;^DD(115.07,13,21,1,0)
	;;=This is the ordered quantity for the second 10am feeding.
	;;^DD(115.07,14,0)
	;;=10AM FEEDING #3^*P118'^FH(118,^0;9^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,14,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,14,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,14,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,14,21,1,0)
	;;=This is the third supplemental feeding ordered for the 10am
	;;^DD(115.07,14,21,2,0)
	;;=feeding.
	;;^DD(115.07,15,0)
	;;=10AM #3 QTY^NJ2,0^^0;10^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,15,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,15,21,0)
	;;=^^1^1^2880710^^
	;;^DD(115.07,15,21,1,0)
	;;=This is the ordered quantity for the third 10am feeding.
	;;^DD(115.07,16,0)
	;;=10AM FEEDING #4^*P118'^FH(118,^0;11^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,16,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,16,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,16,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,16,21,1,0)
	;;=This is the fourth supplemental feeding ordered for the 10am
	;;^DD(115.07,16,21,2,0)
	;;=feeding.
	;;^DD(115.07,17,0)
	;;=10AM #4 QTY^NJ2,0^^0;12^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,17,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,17,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,17,21,1,0)
	;;=This is the ordered quantity of the fourth 10am feeding.
	;;^DD(115.07,18,0)
	;;=2PM FEEDING #1^*P118'^FH(118,^0;13^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,18,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,18,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,18,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,18,21,1,0)
	;;=This is the first supplemental feeding ordered for the 2pm

FHINI0KS	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.07,18,21,2,0)
	;;=feeding.
	;;^DD(115.07,19,0)
	;;=2PM #1 QTY^NJ2,0^^0;14^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,19,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,19,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,19,21,1,0)
	;;=This is the ordered quantity of the first 2pm feeding.
	;;^DD(115.07,20,0)
	;;=2PM FEEDING #2^*P118'^FH(118,^0;15^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,20,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,20,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,20,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,20,21,1,0)
	;;=This is the second supplemental feeding ordered for the 2pm
	;;^DD(115.07,20,21,2,0)
	;;=feeding.
	;;^DD(115.07,21,0)
	;;=2PM #2 QTY^NJ2,0^^0;16^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,21,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,21,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,21,21,1,0)
	;;=This is the ordered quantity of the second 2pm feeding.
	;;^DD(115.07,22,0)
	;;=2PM FEEDING #3^*P118'^FH(118,^0;17^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,22,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,22,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,22,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,22,21,1,0)
	;;=This is the third supplemental feeding ordered for the 2pm
	;;^DD(115.07,22,21,2,0)
	;;=feeding.
	;;^DD(115.07,23,0)
	;;=2PM #3 QTY^NJ2,0^^0;18^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,23,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,23,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,23,21,1,0)
	;;=This is the ordered quantity of the third 2pm feeding.
	;;^DD(115.07,24,0)
	;;=2PM FEEDING #4^*P118'^FH(118,^0;19^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,24,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,24,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,24,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,24,21,1,0)
	;;=This is the fourth supplemental feeding ordered for the 2pm
	;;^DD(115.07,24,21,2,0)
	;;=feeding.
	;;^DD(115.07,25,0)
	;;=2PM #4 QTY^NJ2,0^^0;20^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,25,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,25,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,25,21,1,0)
	;;=This is the ordered quantity of the fourth 2pm feeding.
	;;^DD(115.07,26,0)
	;;=8PM FEEDING #1^*P118'^FH(118,^0;21^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,26,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,26,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,26,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,26,21,1,0)
	;;=This is the first supplemental feeding ordered for the 8pm
	;;^DD(115.07,26,21,2,0)
	;;=feeding.
	;;^DD(115.07,27,0)
	;;=8PM #1 QTY^NJ2,0^^0;22^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,27,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,27,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,27,21,1,0)
	;;=This is the ordered quantity of the first 8pm feeding.
	;;^DD(115.07,28,0)
	;;=8PM FEEDING #2^*P118'^FH(118,^0;23^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,28,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,28,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,28,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,28,21,1,0)
	;;=This is the second supplemental feeding ordered for the 8pm
	;;^DD(115.07,28,21,2,0)
	;;=feeding.
	;;^DD(115.07,29,0)
	;;=8PM #2 QTY^NJ2,0^^0;24^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,29,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,29,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,29,21,1,0)
	;;=This is the ordered quantity of the second 8pm feeding.
	;;^DD(115.07,30,0)
	;;=8PM FEEDING #3^*P118'^FH(118,^0;25^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(115.07,30,12)
	;;=Cannot select bulk nourishments
	;;^DD(115.07,30,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(115.07,30,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.07,30,21,1,0)
	;;=This is the third supplemental feeding ordered for the 8pm
	;;^DD(115.07,30,21,2,0)
	;;=feeding.
	;;^DD(115.07,31,0)
	;;=8PM #3 QTY^NJ2,0^^0;26^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.07,31,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(115.07,31,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.07,31,21,1,0)
	;;=This is the ordered quantity of the third 8pm feeding.
	;;^DD(115.07,32,0)
	;;=8PM FEEDING #4^*P118'^FH(118,^0;27^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X

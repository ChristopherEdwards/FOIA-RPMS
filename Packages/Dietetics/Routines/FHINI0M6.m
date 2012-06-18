FHINI0M6	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(118.1,13,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,13,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,13,21,0)
	;;=^^1^1^2880710^^
	;;^DD(118.1,13,21,1,0)
	;;=This is the fourth supplemental feeding item for the 10am feeding.
	;;^DD(118.1,13.5,0)
	;;=10AM #4 QTY^NJ2,0^^1;8^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,13.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,13.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,13.5,21,1,0)
	;;=This is the quantity of the fourth 10am feeding item.
	;;^DD(118.1,14,0)
	;;=2PM FEEDING #1^*P118'^FH(118,^1;9^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,14,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,14,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,14,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,14,21,1,0)
	;;=This is the first supplemental feeding item for the 2pm feeding.
	;;^DD(118.1,14.5,0)
	;;=2PM #1 QTY^NJ2,0^^1;10^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,14.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,14.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,14.5,21,1,0)
	;;=This is the quantity of the first 2pm feeding item.
	;;^DD(118.1,15,0)
	;;=2PM FEEDING #2^*P118'^FH(118,^1;11^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,15,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,15,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,15,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,15,21,1,0)
	;;=This is the second supplemental feeding item for the 2pm feeding.
	;;^DD(118.1,15.5,0)
	;;=2PM #2 QTY^NJ2,0^^1;12^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,15.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,15.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,15.5,21,1,0)
	;;=This is the quantity of the second 2pm feeding item.
	;;^DD(118.1,16,0)
	;;=2PM FEEDING #3^*P118'^FH(118,^1;13^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,16,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,16,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,16,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,16,21,1,0)
	;;=This is the third supplemental feeding item for the 2pm feeding.
	;;^DD(118.1,16.5,0)
	;;=2PM #3 QTY^NJ2,0^^1;14^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,16.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,16.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,16.5,21,1,0)
	;;=This is the quantity of the third 2pm feeding item.
	;;^DD(118.1,17,0)
	;;=2PM FEEDING #4^*P118'^FH(118,^1;15^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,17,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,17,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,17,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,17,21,1,0)
	;;=This is the fourth supplemental feeding item for the 2pm feeding.
	;;^DD(118.1,17.5,0)
	;;=2PM #4 QTY^NJ2,0^^1;16^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,17.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,17.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,17.5,21,1,0)
	;;=This is the quantity of the fourth 2pm feeding item.
	;;^DD(118.1,18,0)
	;;=8PM FEEDING #1^*P118'^FH(118,^1;17^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,18,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,18,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,18,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,18,21,1,0)
	;;=This is the first supplemental feeding item for the 8pm feeding.
	;;^DD(118.1,18.5,0)
	;;=8PM #1 QTY^NJ2,0^^1;18^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,18.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,18.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,18.5,21,1,0)
	;;=This is the quantity of the first 8pm feeding item.
	;;^DD(118.1,19,0)
	;;=8PM FEEDING #2^*P118'^FH(118,^1;19^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,19,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,19,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,19,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,19,21,1,0)
	;;=This is the second supplemental feeding item for the 8pm feeding.
	;;^DD(118.1,19.5,0)
	;;=8PM #2 QTY^NJ2,0^^1;20^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,19.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,19.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,19.5,21,1,0)
	;;=This is the quantity of the second 8pm feeding item.
	;;^DD(118.1,20,0)
	;;=8PM FEEDING #3^*P118'^FH(118,^1;21^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X

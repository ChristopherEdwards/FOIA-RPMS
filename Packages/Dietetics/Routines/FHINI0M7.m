FHINI0M7	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(118.1,20,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,20,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,20,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,20,21,1,0)
	;;=This is the third supplemental feeding item for the 8pm feeding.
	;;^DD(118.1,20.5,0)
	;;=8PM #3 QTY^NJ2,0^^1;22^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,20.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,20.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,20.5,21,1,0)
	;;=This is the quantity of the third 8pm feeding item.
	;;^DD(118.1,21,0)
	;;=8PM FEEDING #4^*P118'^FH(118,^1;23^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,21,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,21,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,21,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,21,21,1,0)
	;;=This is the fourth supplemental feeding item for the 8pm feeding.
	;;^DD(118.1,21.5,0)
	;;=8PM #4 QTY^NJ2,0^^1;24^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,21.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,21.5,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,21.5,21,1,0)
	;;=This is the quantity of the fourth 8pm feeding item.
	;;^DD(118.1,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(118.1,99,1,0)
	;;=^.1
	;;^DD(118.1,99,1,1,0)
	;;=118.1^AC^MUMPS
	;;^DD(118.1,99,1,1,1)
	;;=K:X'="Y" ^FH(118.1,DA,"I")
	;;^DD(118.1,99,1,1,2)
	;;=K ^FH(118.1,DA,"I")
	;;^DD(118.1,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(118.1,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(118.1,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(118.1,99,21,0)
	;;=^^2^2^2880831^
	;;^DD(118.1,99,21,1,0)
	;;=This field, if answered YES, will prohibit further selection
	;;^DD(118.1,99,21,2,0)
	;;=of this Supplemental Feeding Menu by dietetic personnel.
	;;^DD(118.1,99,"DT")
	;;=2880831

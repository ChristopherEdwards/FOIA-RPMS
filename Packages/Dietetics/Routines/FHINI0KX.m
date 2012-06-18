FHINI0KX	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.21,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the EXCLUDED RECIPES field.
	;;^DD(115.21,.01,21,0)
	;;=^^3^3^2880901^
	;;^DD(115.21,.01,21,1,0)
	;;=This field is a pointer to the Recipe file (114) and is a recipe
	;;^DD(115.21,.01,21,2,0)
	;;=which should NOT be served to patients expressing this food
	;;^DD(115.21,.01,21,3,0)
	;;=preference.

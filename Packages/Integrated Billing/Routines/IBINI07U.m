IBINI07U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.31,.01,1,0)
	;;=^.1
	;;^DD(357.31,.01,1,1,0)
	;;=357.31^B
	;;^DD(357.31,.01,1,1,1)
	;;=S ^IBE(357.3,DA(1),1,"B",$E(X,1,30),DA)=""
	;;^DD(357.31,.01,1,1,2)
	;;=K ^IBE(357.3,DA(1),1,"B",$E(X,1,30),DA)
	;;^DD(357.31,.01,3)
	;;=Which subcolumn is the value for?
	;;^DD(357.31,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.31,.01,21,1,0)
	;;= 
	;;^DD(357.31,.01,21,2,0)
	;;=The order that the subcolumn should appear on the form.
	;;^DD(357.31,.01,"DT")
	;;=2930402
	;;^DD(357.31,.02,0)
	;;=SUBCOLUMN VALUE^F^^0;2^K:$L(X)>150!($L(X)<1) X
	;;^DD(357.31,.02,3)
	;;=What value should go in the subcolumn?
	;;^DD(357.31,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.31,.02,21,1,0)
	;;= 
	;;^DD(357.31,.02,21,2,0)
	;;=The text that should appear in the subcolumn.
	;;^DD(357.31,.02,"DT")
	;;=2930401

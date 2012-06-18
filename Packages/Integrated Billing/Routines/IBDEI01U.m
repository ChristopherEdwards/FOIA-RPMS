IBDEI01U	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.8,.04,"DT")
	;;=2930715
	;;^DD(358.8,.05,0)
	;;=TEXT WIDTH^RNJ3,0^^0;5^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.8,.05,3)
	;;=How many columns should be allocated on the block for the text?
	;;^DD(358.8,.05,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.8,.05,21,1,0)
	;;= 
	;;^DD(358.8,.05,21,2,0)
	;;=The width of the text area, measured in characters.
	;;^DD(358.8,.05,"DT")
	;;=2930326
	;;^DD(358.8,.06,0)
	;;=TEXT HEIGHT^RNJ3,0^^0;6^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.8,.06,3)
	;;=How many lines on the block should be allocated for the text?
	;;^DD(358.8,.06,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.8,.06,21,1,0)
	;;= 
	;;^DD(358.8,.06,21,2,0)
	;;=The height of the text area, measured in lines.
	;;^DD(358.8,.06,"DT")
	;;=2930326
	;;^DD(358.8,1,0)
	;;=TEXT^358.81^^1;0
	;;^DD(358.8,1,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.8,1,21,1,0)
	;;= 
	;;^DD(358.8,1,21,2,0)
	;;=The text that should appear within the text area.
	;;^DD(358.81,0)
	;;=TEXT SUB-FIELD^^.01^1
	;;^DD(358.81,0,"NM","TEXT")
	;;=
	;;^DD(358.81,0,"UP")
	;;=358.8
	;;^DD(358.81,.01,0)
	;;=TEXT^WL^^0;1^Q
	;;^DD(358.81,.01,3)
	;;=Enter the text that you want to appear in the block.
	;;^DD(358.81,.01,"DT")
	;;=2930326

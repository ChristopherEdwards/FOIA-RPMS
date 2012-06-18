IBINI096	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.5,.13,.1)
	;;=HOW SHOULD THE TEXT LINES BE SPACED?
	;;^DD(358.5,.13,3)
	;;=How do you want the text lines to be spaced?
	;;^DD(358.5,.13,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.5,.13,21,1,0)
	;;= 
	;;^DD(358.5,.13,21,2,0)
	;;=Determines the spacing between lines of text.
	;;^DD(358.5,.13,"DT")
	;;=2930414
	;;^DD(358.5,.14,0)
	;;=WIDTH OF TEXT LINES^NJ3,0^^0;14^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.5,.14,.1)
	;;=HOW MANY CHARACTERS ACROSS SHOULD THE TEXT LINES BE?
	;;^DD(358.5,.14,3)
	;;=How many columns wide do you want the text?
	;;^DD(358.5,.14,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.5,.14,21,1,0)
	;;= 
	;;^DD(358.5,.14,21,2,0)
	;;=Determines how many characters across should be allocated to the text.
	;;^DD(358.5,.14,"DT")
	;;=2930414
	;;^DD(358.5,2,0)
	;;=SUBFIELD^358.52I^^2;0
	;;^DD(358.5,2,21,0)
	;;=^^2^2^2930730^^^^
	;;^DD(358.5,2,21,1,0)
	;;=A data field can be composed of multiple subfields. Each subfield can have
	;;^DD(358.5,2,21,2,0)
	;;=a label and data.
	;;^DD(358.5,2,"DT")
	;;=2930323
	;;^DD(358.52,0)
	;;=SUBFIELD SUB-FIELD^^.09^8
	;;^DD(358.52,0,"IX","B",358.52,.01)
	;;=
	;;^DD(358.52,0,"NM","SUBFIELD")
	;;=
	;;^DD(358.52,0,"UP")
	;;=358.5
	;;^DD(358.52,.01,0)
	;;=SUBFIELD LABEL^MF^^0;1^K:$L(X)>150!($L(X)<1) X
	;;^DD(358.52,.01,1,0)
	;;=^.1
	;;^DD(358.52,.01,1,1,0)
	;;=358.52^B
	;;^DD(358.52,.01,1,1,1)
	;;=S ^IBE(358.5,DA(1),2,"B",$E(X,1,30),DA)=""
	;;^DD(358.52,.01,1,1,2)
	;;=K ^IBE(358.5,DA(1),2,"B",$E(X,1,30),DA)
	;;^DD(358.52,.01,3)
	;;=What should the subfield be named? The label will print unless it is made invisible.
	;;^DD(358.52,.01,4)
	;;=
	;;^DD(358.52,.01,21,0)
	;;=^^3^3^2930730^^
	;;^DD(358.52,.01,21,1,0)
	;;= 
	;;^DD(358.52,.01,21,2,0)
	;;=The name of the subfield. The label prints to the form unless it is made
	;;^DD(358.52,.01,21,3,0)
	;;=invisible.
	;;^DD(358.52,.01,"DT")
	;;=2930730
	;;^DD(358.52,.03,0)
	;;=SUBCOLUMN LABEL APPEARANCE^FX^^0;3^S X=$$UPPER^VALM1(X) K:$L(X)>3!("UBI"'[$E(X,1))!("UBI"'[$E(X,2))!("UBI"'[$E(X,3)) X
	;;^DD(358.52,.03,.1)
	;;=HOW SHOULD THE LABEL APPEAR? CHOOSE FROM {U,B,I}
	;;^DD(358.52,.03,3)
	;;=B=bold,U=underline,I=invisible You can enter any combination of {B,U,I}. The label will not print if it is made invisible.
	;;^DD(358.52,.03,4)
	;;=
	;;^DD(358.52,.03,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.52,.03,21,1,0)
	;;= 
	;;^DD(358.52,.03,21,2,0)
	;;=The label can have characterisics, such as being underlined.
	;;^DD(358.52,.03,"DT")
	;;=2930616
	;;^DD(358.52,.04,0)
	;;=STARTING COLUMN FOR LABEL^NJ3,0XO^^0;4^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.52,.04,2)
	;;=S Y(0)=Y S:Y=+Y Y=Y+1
	;;^DD(358.52,.04,2.1)
	;;=S:Y=+Y Y=Y+1
	;;^DD(358.52,.04,3)
	;;=What block column should the label start in?
	;;^DD(358.52,.04,21,0)
	;;=^^2^2^2930715^^
	;;^DD(358.52,.04,21,1,0)
	;;= 
	;;^DD(358.52,.04,21,2,0)
	;;=The column, relative to the block, that the label should start at.
	;;^DD(358.52,.04,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.52,.04,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.52,.04,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.52,.04,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.52,.04,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.52,.04,"DT")
	;;=2930617
	;;^DD(358.52,.05,0)
	;;=STARTING ROW FOR LABEL^NJ3,0XO^^0;5^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.52,.05,2)
	;;=S Y(0)=Y S:Y=+Y Y=Y+1
	;;^DD(358.52,.05,2.1)
	;;=S:Y=+Y Y=Y+1

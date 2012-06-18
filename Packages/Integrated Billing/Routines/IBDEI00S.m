IBDEI00S	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.5,.05,"DT")
	;;=2930413
	;;^DD(358.5,.06,0)
	;;=TEXT LABEL^FO^^0;6^K:$L(X)>150!($L(X)<1) X
	;;^DD(358.5,.06,.1)
	;;=WHAT LABEL SHOULD BEGIN THE TEXT (OPTIONAL)
	;;^DD(358.5,.06,2)
	;;=S Y(0)=Y S Y=+Y+1
	;;^DD(358.5,.06,2.1)
	;;=S Y=+Y+1
	;;^DD(358.5,.06,3)
	;;=You can optionally begin the text with a label of your choice.
	;;^DD(358.5,.06,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.5,.06,21,1,0)
	;;= 
	;;^DD(358.5,.06,21,2,0)
	;;=The label that should precede the text.
	;;^DD(358.5,.06,"DT")
	;;=2930617
	;;^DD(358.5,.07,0)
	;;=TEXT LABEL APPEARANCE^FX^^0;7^K:$L(X)>2!($L(X)<1)!("BU"'[$E(X,1))!("UB"'[$E(X,2)) X
	;;^DD(358.5,.07,.1)
	;;=HOW SHOULD THE LABEL APPEAR? CHOOSE FROM {B,U}
	;;^DD(358.5,.07,3)
	;;=B=bold,U=underline. You can enter BU to make the label bold and underlined.
	;;^DD(358.5,.07,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.5,.07,21,1,0)
	;;= 
	;;^DD(358.5,.07,21,2,0)
	;;=The label can have characteristics, such as being underlined or
	;;^DD(358.5,.07,21,3,0)
	;;=emboldened.
	;;^DD(358.5,.07,"DT")
	;;=2930414
	;;^DD(358.5,.1,0)
	;;=TEXT STARTING COLUMN^NJ3,0XO^^0;10^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.5,.1,2)
	;;=S:Y=+Y Y=Y+1
	;;^DD(358.5,.1,2.1)
	;;=S Y=+Y+1
	;;^DD(358.5,.1,3)
	;;=What block column should the text start at?
	;;^DD(358.5,.1,21,0)
	;;=^^2^2^2930715^^
	;;^DD(358.5,.1,21,1,0)
	;;=This field determines what column the text should begin in.
	;;^DD(358.5,.1,21,2,0)
	;;=Applies only if the Package Interface returns a word-processing field.
	;;^DD(358.5,.1,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.5,.1,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.5,.1,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.5,.1,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.5,.1,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.5,.1,"DT")
	;;=2930617
	;;^DD(358.5,.11,0)
	;;=TEXT STARTING ROW^NJ3,0XO^^0;11^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.5,.11,2)
	;;=S Y(0)=Y S:Y=+Y Y=Y+1
	;;^DD(358.5,.11,2.1)
	;;=S:Y=+Y Y=Y+1
	;;^DD(358.5,.11,3)
	;;=What block row should the text begin in?
	;;^DD(358.5,.11,21,0)
	;;=^^4^4^2930715^^
	;;^DD(358.5,.11,21,1,0)
	;;= 
	;;^DD(358.5,.11,21,2,0)
	;;=Determines which line on the form, relative to the block, the text area
	;;^DD(358.5,.11,21,3,0)
	;;=should begin at. Only applies if the package interface returns a
	;;^DD(358.5,.11,21,4,0)
	;;=word-processing field.
	;;^DD(358.5,.11,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.5,.11,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.5,.11,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.5,.11,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.5,.11,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.5,.11,"DT")
	;;=2930617
	;;^DD(358.5,.12,0)
	;;=NUMBER OF FORM LINES FOR TEXT^NJ3,0^^0;12^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.5,.12,.1)
	;;=HOW MANY LINES OF THE FORM SHOULD BE ALLOCATED FOR THE TEXT?
	;;^DD(358.5,.12,3)
	;;=How many lines of the form should be allocated for the text?
	;;^DD(358.5,.12,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.5,.12,21,1,0)
	;;= 
	;;^DD(358.5,.12,21,2,0)
	;;=The number of lines on the form that should be allocated for the text.
	;;^DD(358.5,.12,"DT")
	;;=2930414
	;;^DD(358.5,.13,0)
	;;=SPACING OF TEXT LINES^S^1:SINGLE SPACED;2:DOUBLE SPACED;3:SINGLE, BUT DOUBLE IF BLANK;^0;13^Q

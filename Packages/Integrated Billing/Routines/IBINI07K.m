IBINI07K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.1,.05,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(357.1,.05,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(357.1,.05,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(357.1,.05,"DT")
	;;=2930715
	;;^DD(357.1,.06,0)
	;;=WIDTH IN CHARACTERS^RNJ3,0^^0;6^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.1,.06,.1)
	;;=HOW MANY CHARACTERS WIDE SHOULD THE BLOCK BE?
	;;^DD(357.1,.06,3)
	;;=How many characters wide should this block be?
	;;^DD(357.1,.06,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.1,.06,21,1,0)
	;;= 
	;;^DD(357.1,.06,21,2,0)
	;;=The width of the block, measured in the number of characters across.
	;;^DD(357.1,.06,"DT")
	;;=2930415
	;;^DD(357.1,.07,0)
	;;=HEIGHT IN LINES^RNJ3,0^^0;7^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.1,.07,.1)
	;;=HOW MANY LINES HIGH SHOULD THE BLOCK BE?
	;;^DD(357.1,.07,3)
	;;=How many lines high should this block be?
	;;^DD(357.1,.07,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.1,.07,21,1,0)
	;;= 
	;;^DD(357.1,.07,21,2,0)
	;;=The height of the block, measured by the number of lines it takes up.
	;;^DD(357.1,.07,"DT")
	;;=2930415
	;;^DD(357.1,.1,0)
	;;=OUTLINE TYPE^RS^1:SOLID LINE;2:INVISIBLE;^0;10^Q
	;;^DD(357.1,.1,.1)
	;;=OUTLINE TYPE (SOLID/INVISIBLE)
	;;^DD(357.1,.1,3)
	;;=Enter '1' if the block should have a box around it, '2' if not.
	;;^DD(357.1,.1,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.1,.1,21,1,0)
	;;= 
	;;^DD(357.1,.1,21,2,0)
	;;=How the block is outlined on the form.
	;;^DD(357.1,.1,"DT")
	;;=2930415
	;;^DD(357.1,.11,0)
	;;=BLOCK HEADER^F^^0;11^K:$L(X)>60!($L(X)<1) X
	;;^DD(357.1,.11,.1)
	;;=WHAT HEADER SHOULD APPEAR AT THE TOP OF THE BLOCK? (OPTIONAL)
	;;^DD(357.1,.11,3)
	;;=What text should appear at the top of the block?
	;;^DD(357.1,.11,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.1,.11,21,1,0)
	;;= 
	;;^DD(357.1,.11,21,2,0)
	;;=The text appearing at the top of the block.
	;;^DD(357.1,.11,"DT")
	;;=2940216
	;;^DD(357.1,.12,0)
	;;=HEADER APPEARANCE^FX^^0;12^S X=$$UPPER^VALM1(X) K:$L(X)>3!("UBC"'[$E(X,1))!("UBC"'[$E(X,2))!("UBC"'[$E(X,3)) X
	;;^DD(357.1,.12,.1)
	;;=HOW SHOULD THE BLOCK HEADER APPEAR? CHOOSE FROM {U,B,C}
	;;^DD(357.1,.12,3)
	;;=B=bold, U=underline, C=center. You can enter any combination of {B,U,C}.
	;;^DD(357.1,.12,21,0)
	;;=^^2^2^2940216^
	;;^DD(357.1,.12,21,1,0)
	;;= 
	;;^DD(357.1,.12,21,2,0)
	;;=This field determines the appearance of the block's header.
	;;^DD(357.1,.12,"DT")
	;;=2930616
	;;^DD(357.1,.13,0)
	;;=BRIEF DESCRIPTION^RF^^0;13^K:$L(X)>80!($L(X)<1) X
	;;^DD(357.1,.13,.1)
	;;=ENTER A BRIEF DESCRIPTION OF THE USE & CONTENTS OF THE BLOCK
	;;^DD(357.1,.13,3)
	;;=Answer must be 1-80 characters in length.
	;;^DD(357.1,.13,21,0)
	;;=^^2^2^2930607^
	;;^DD(357.1,.13,21,1,0)
	;;= 
	;;^DD(357.1,.13,21,2,0)
	;;=A brief description of the contents or use of the block.
	;;^DD(357.1,.13,"DT")
	;;=2930415
	;;^DD(357.1,.14,0)
	;;=TOOL KIT ORDER^NJ6,2^^0;14^K:+X'=X!(X>999.99)!(X<.01)!(X?.E1"."3N.N) X
	;;^DD(357.1,.14,1,0)
	;;=^.1
	;;^DD(357.1,.14,1,1,0)
	;;=357.1^D
	;;^DD(357.1,.14,1,1,1)
	;;=S ^IBE(357.1,"D",$E(X,1,30),DA)=""
	;;^DD(357.1,.14,1,1,2)
	;;=K ^IBE(357.1,"D",$E(X,1,30),DA)
	;;^DD(357.1,.14,1,1,"%D",0)
	;;=^^2^2^2940216^
	;;^DD(357.1,.14,1,1,"%D",1,0)
	;;=This index is used to locate all the 'tool box' blocks that can be used
	;;^DD(357.1,.14,1,1,"%D",2,0)
	;;=as templates to create a new block to be added to a form.
	;;^DD(357.1,.14,1,1,"DT")
	;;=2930108
	;;^DD(357.1,.14,3)
	;;=Enter a number greater than 0 if this block is part of the tool kit. The number will determine its listed order.

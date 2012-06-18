IBINI07H	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357,.01,3)
	;;=The form name must be 3-30 uppercase characters in length.
	;;^DD(357,.01,21,0)
	;;=^^2^2^2931110^^
	;;^DD(357,.01,21,1,0)
	;;= 
	;;^DD(357,.01,21,2,0)
	;;=The name of the encounter form.
	;;^DD(357,.01,"DEL",1,0)
	;;=I '$G(IBLISTPR) W "...Encounter Forms can only be deleted through the",!," DELETE UNUSED FORM action in the Encounter Form Utilities!"
	;;^DD(357,.01,"DT")
	;;=2931124
	;;^DD(357,.03,0)
	;;=BRIEF DESCRIPTION^RF^^0;3^K:$L(X)>80!($L(X)<1) X
	;;^DD(357,.03,.1)
	;;=BRIEF DESCRIPTION OF FORM'S USE & CONTENT
	;;^DD(357,.03,3)
	;;=Enter a brief description of the intended use of the form or its contents.
	;;^DD(357,.03,21,0)
	;;=^^3^3^2930607^
	;;^DD(357,.03,21,1,0)
	;;= 
	;;^DD(357,.03,21,2,0)
	;;=A brief description of the contents of the form and its intended use. This
	;;^DD(357,.03,21,3,0)
	;;=description will be displayed to the user.
	;;^DD(357,.03,"DT")
	;;=2940309
	;;^DD(357,.04,0)
	;;=TYPE OF USE^R*S^0:RESERVED FOR UTILITY;1:OUTPATIENT ENCOUNTER FORM;^0;4^Q
	;;^DD(357,.04,1,0)
	;;=^.1
	;;^DD(357,.04,1,1,0)
	;;=357^D
	;;^DD(357,.04,1,1,1)
	;;=S ^IBE(357,"D",$E(X,1,30),DA)=""
	;;^DD(357,.04,1,1,2)
	;;=K ^IBE(357,"D",$E(X,1,30),DA)
	;;^DD(357,.04,1,1,"%D",0)
	;;=^^1^1^2930825^
	;;^DD(357,.04,1,1,"%D",1,0)
	;;=Used to find forms of a particular type.
	;;^DD(357,.04,1,1,"DT")
	;;=2930825
	;;^DD(357,.04,3)
	;;=How will the form be used?
	;;^DD(357,.04,12)
	;;=Does not allow users to choose RESERVED FOR UTILITY
	;;^DD(357,.04,12.1)
	;;=S DIC("S")="I Y'=0"
	;;^DD(357,.04,21,0)
	;;=^^5^5^2930825^^^
	;;^DD(357,.04,21,1,0)
	;;=This field will be used to categorize forms by type of use. It is possible
	;;^DD(357,.04,21,2,0)
	;;=that the form generator that is part of the Encounter Form Utilities may
	;;^DD(357,.04,21,3,0)
	;;=be used to create forms other than encounter forms.
	;;^DD(357,.04,21,4,0)
	;;=The utilities use a couple of forms (GARBAGE, TOOL KIT), TYPE OF USE is
	;;^DD(357,.04,21,5,0)
	;;=RESERVED FOR UTILITY, that are not real forms.
	;;^DD(357,.04,"DT")
	;;=2930825
	;;^DD(357,.05,0)
	;;=COMPILED?^S^0:NO;1:YES;^0;5^Q
	;;^DD(357,.05,3)
	;;=Enter yes if a compiled copy of the form should be created and stored.
	;;^DD(357,.05,21,0)
	;;=^^2^2^2931201^^
	;;^DD(357,.05,21,1,0)
	;;=This indicates whether a compiled version of the form exists. The compiled
	;;^DD(357,.05,21,2,0)
	;;=version is much faster to print.
	;;^DD(357,.05,"DT")
	;;=2931124
	;;^DD(357,.07,0)
	;;=TOOL KIT^RS^0:NO;1:YES;^0;7^Q
	;;^DD(357,.07,.1)
	;;=SHOULD THIS FORM BE PART OF THE TOOL KIT?
	;;^DD(357,.07,1,0)
	;;=^.1
	;;^DD(357,.07,1,1,0)
	;;=357^C
	;;^DD(357,.07,1,1,1)
	;;=S ^IBE(357,"C",$E(X,1,30),DA)=""
	;;^DD(357,.07,1,1,2)
	;;=K ^IBE(357,"C",$E(X,1,30),DA)
	;;^DD(357,.07,1,1,"%D",0)
	;;=^^1^1^2930624^
	;;^DD(357,.07,1,1,"%D",1,0)
	;;=Used to find all of the tool kit forms.
	;;^DD(357,.07,1,1,"DT")
	;;=2930624
	;;^DD(357,.07,3)
	;;=Is this form part of the tool kit?
	;;^DD(357,.07,21,0)
	;;=^^3^3^2930607^
	;;^DD(357,.07,21,1,0)
	;;= 
	;;^DD(357,.07,21,2,0)
	;;=This field, if set to YES, means that the form can not be deleted and can
	;;^DD(357,.07,21,3,0)
	;;=not be added to a clinic setup.
	;;^DD(357,.07,"DT")
	;;=2931220
	;;^DD(357,.09,0)
	;;=RIGHT MARGIN^RNJ3,0^^0;9^K:+X'=X!(X>300)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357,.09,.1)
	;;=FORM'S RIGHT MARGIN (WIDTH IN CHARACTERS)
	;;^DD(357,.09,3)
	;;=How many columns (characters) wide should the form be?
	;;^DD(357,.09,21,0)
	;;=^^2^2^2930810^^
	;;^DD(357,.09,21,1,0)
	;;= 
	;;^DD(357,.09,21,2,0)
	;;=The number of characters wide the form is.
	;;^DD(357,.09,"DT")
	;;=2930420

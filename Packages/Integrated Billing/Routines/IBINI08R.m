IBINI08R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358,0,"GL")
	;;=^IBE(358,
	;;^DIC("B","IMP/EXP ENCOUNTER FORM",358)
	;;=
	;;^DIC(358,"%D",0)
	;;=^^4^4^2940217^
	;;^DIC(358,"%D",1,0)
	;;= 
	;;^DIC(358,"%D",2,0)
	;;=This file is nearly identical to file #357. It is used by the Import/Export
	;;^DIC(358,"%D",3,0)
	;;=Utility as a temporary staging area for data from that file that is being
	;;^DIC(358,"%D",4,0)
	;;=imported or exported.
	;;^DD(358,0)
	;;=FIELD^^1^9
	;;^DD(358,0,"DDA")
	;;=N
	;;^DD(358,0,"DT")
	;;=2931201
	;;^DD(358,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(358,0,"IX","B",358,.01)
	;;=
	;;^DD(358,0,"IX","C",358,.07)
	;;=
	;;^DD(358,0,"NM","IMP/EXP ENCOUNTER FORM")
	;;=
	;;^DD(358,0,"PT",358.1,.02)
	;;=
	;;^DD(358,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358,.01,1,0)
	;;=^.1
	;;^DD(358,.01,1,1,0)
	;;=358^B
	;;^DD(358,.01,1,1,1)
	;;=S ^IBE(358,"B",$E(X,1,30),DA)=""
	;;^DD(358,.01,1,1,2)
	;;=K ^IBE(358,"B",$E(X,1,30),DA)
	;;^DD(358,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(358,.01,21,1,0)
	;;= 
	;;^DD(358,.01,21,2,0)
	;;=The name of the encounter form.
	;;^DD(358,.01,"DEL",1,0)
	;;=I 1 W "...Encounter Forms can only be deleted through the",!," DELETE UNUSED FORM action in the Encounter Form Utilities!"
	;;^DD(358,.01,"DT")
	;;=2930225
	;;^DD(358,.03,0)
	;;=BRIEF DESCRIPTION^RF^^0;3^K:$L(X)>80!($L(X)<1) X
	;;^DD(358,.03,.1)
	;;=BRIEF DESRIPTION OF FORM'S USE & CONTENT
	;;^DD(358,.03,3)
	;;=Enter a brief description of the intended use of the form or its contents.
	;;^DD(358,.03,21,0)
	;;=^^3^3^2930607^
	;;^DD(358,.03,21,1,0)
	;;= 
	;;^DD(358,.03,21,2,0)
	;;=A brief description of the contents of the form and its intended use. This
	;;^DD(358,.03,21,3,0)
	;;=description will be displayed to the user.
	;;^DD(358,.03,"DT")
	;;=2930420
	;;^DD(358,.04,0)
	;;=TYPE OF USE^RS^1:OUTPATIENT ENCOUNTER FORM;^0;4^Q
	;;^DD(358,.04,3)
	;;=How will the form be used?
	;;^DD(358,.04,"DT")
	;;=2930802
	;;^DD(358,.05,0)
	;;=COMPILED?^S^0:NO;1:YES;^0;5^Q
	;;^DD(358,.05,"DT")
	;;=2931201
	;;^DD(358,.07,0)
	;;=TOOL KIT^RS^0:NO;1:YES;^0;7^Q
	;;^DD(358,.07,1,0)
	;;=^.1
	;;^DD(358,.07,1,1,0)
	;;=358^C
	;;^DD(358,.07,1,1,1)
	;;=S ^IBE(358,"C",$E(X,1,30),DA)=""
	;;^DD(358,.07,1,1,2)
	;;=K ^IBE(358,"C",$E(X,1,30),DA)
	;;^DD(358,.07,1,1,"%D",0)
	;;=^^1^1^2930624^
	;;^DD(358,.07,1,1,"%D",1,0)
	;;=Used to find all of the tool kit forms.
	;;^DD(358,.07,1,1,"DT")
	;;=2930624
	;;^DD(358,.07,3)
	;;=Is this form part of the tool kit?
	;;^DD(358,.07,21,0)
	;;=^^3^3^2930607^
	;;^DD(358,.07,21,1,0)
	;;= 
	;;^DD(358,.07,21,2,0)
	;;=This field, if set to YES, means that the form can not be deleted and can
	;;^DD(358,.07,21,3,0)
	;;=not be added to a clinic setup.
	;;^DD(358,.07,"DT")
	;;=2930624
	;;^DD(358,.09,0)
	;;=RIGHT MARGIN^RNJ3,0^^0;9^K:+X'=X!(X>300)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358,.09,.1)
	;;=FORM'S RIGHT MARGIN (WIDTH IN CHARACTERS)
	;;^DD(358,.09,3)
	;;=How many columns (characters) wide should the form be?
	;;^DD(358,.09,21,0)
	;;=^^2^2^2930607^
	;;^DD(358,.09,21,1,0)
	;;= 
	;;^DD(358,.09,21,2,0)
	;;=The number of characters wide the form is.
	;;^DD(358,.09,"DT")
	;;=2930420
	;;^DD(358,.1,0)
	;;=PAGE LENGTH^RNJ3,0^^0;10^K:+X'=X!(X>300)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358,.1,.1)
	;;=FORM'S PAGE LENGTH (IN LINES)
	;;^DD(358,.1,3)
	;;=How many lines should the form have?
	;;^DD(358,.1,21,0)
	;;=^^2^2^2921213^
	;;^DD(358,.1,21,1,0)
	;;= 
	;;^DD(358,.1,21,2,0)
	;;=This is the number of usable lines on the page.
	;;^DD(358,.1,"DT")
	;;=2930420
	;;^DD(358,.11,0)
	;;=NUMBER OF PAGES^RNJ2,0^^0;11^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X

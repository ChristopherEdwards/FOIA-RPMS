IBINI07J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.1,0,"GL")
	;;=^IBE(357.1,
	;;^DIC("B","ENCOUNTER FORM BLOCK",357.1)
	;;=
	;;^DIC(357.1,"%D",0)
	;;=^^3^3^2931214^^^
	;;^DIC(357.1,"%D",1,0)
	;;= 
	;;^DIC(357.1,"%D",2,0)
	;;=Contains descriptions of blocks, which are rectangular areas on an
	;;^DIC(357.1,"%D",3,0)
	;;=encounter form.
	;;^DD(357.1,0)
	;;=FIELD^^2^13
	;;^DD(357.1,0,"DDA")
	;;=N
	;;^DD(357.1,0,"DIK")
	;;=IBXF1
	;;^DD(357.1,0,"DT")
	;;=2931117
	;;^DD(357.1,0,"ID",.02)
	;;=W ""
	;;^DD(357.1,0,"IX","B",357.1,.01)
	;;=
	;;^DD(357.1,0,"IX","C",357.1,.02)
	;;=
	;;^DD(357.1,0,"IX","D",357.1,.14)
	;;=
	;;^DD(357.1,0,"NM","ENCOUNTER FORM BLOCK")
	;;=
	;;^DD(357.1,0,"PT",357.2,.02)
	;;=
	;;^DD(357.1,0,"PT",357.5,.02)
	;;=
	;;^DD(357.1,0,"PT",357.7,.06)
	;;=
	;;^DD(357.1,0,"PT",357.8,.02)
	;;=
	;;^DD(357.1,.01,0)
	;;=NAME^RFX^^0;1^S X=$$UP^XLFSTR(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(357.1,.01,1,0)
	;;=^.1
	;;^DD(357.1,.01,1,1,0)
	;;=357.1^B
	;;^DD(357.1,.01,1,1,1)
	;;=S ^IBE(357.1,"B",$E(X,1,30),DA)=""
	;;^DD(357.1,.01,1,1,2)
	;;=K ^IBE(357.1,"B",$E(X,1,30),DA)
	;;^DD(357.1,.01,3)
	;;=The block name must be 3-30 uppercase characters.
	;;^DD(357.1,.01,21,0)
	;;=^^3^3^2940216^
	;;^DD(357.1,.01,21,1,0)
	;;= 
	;;^DD(357.1,.01,21,2,0)
	;;= 
	;;^DD(357.1,.01,21,3,0)
	;;=The name of the block.
	;;^DD(357.1,.01,"DEL",1,0)
	;;=I '$G(IBLISTPR) W "...Encounter Form Blocks can only be deleted through the Encounter Form Utilities!"
	;;^DD(357.1,.01,"DT")
	;;=2931117
	;;^DD(357.1,.02,0)
	;;=FORM^RP357'^IBE(357,^0;2^Q
	;;^DD(357.1,.02,1,0)
	;;=^.1
	;;^DD(357.1,.02,1,1,0)
	;;=357.1^C
	;;^DD(357.1,.02,1,1,1)
	;;=S ^IBE(357.1,"C",$E(X,1,30),DA)=""
	;;^DD(357.1,.02,1,1,2)
	;;=K ^IBE(357.1,"C",$E(X,1,30),DA)
	;;^DD(357.1,.02,1,1,"%D",0)
	;;=^^1^1^2921116^
	;;^DD(357.1,.02,1,1,"%D",1,0)
	;;=Used to find all the blocks belonging to a particular form.
	;;^DD(357.1,.02,1,1,"DT")
	;;=2921116
	;;^DD(357.1,.02,3)
	;;=What form should this block appear on?
	;;^DD(357.1,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.1,.02,21,1,0)
	;;= 
	;;^DD(357.1,.02,21,2,0)
	;;=The form the block appears on.
	;;^DD(357.1,.02,"DT")
	;;=2921116
	;;^DD(357.1,.04,0)
	;;=BLOCK'S STARTING ROW^RNJ3,0XO^^0;4^S:+X=X X=X-1 K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.1,.04,.1)
	;;=WHAT ROW SHOULD THE BLOCK START IN?
	;;^DD(357.1,.04,2)
	;;=S Y(0)=Y S Y=(+Y)+1
	;;^DD(357.1,.04,2.1)
	;;=S Y=(+Y)+1
	;;^DD(357.1,.04,3)
	;;=What line should this block begin on?
	;;^DD(357.1,.04,21,0)
	;;=^^1^1^2940216^
	;;^DD(357.1,.04,21,1,0)
	;;=The row  on the encounter form that the block starts on.
	;;^DD(357.1,.04,23,0)
	;;=^^4^4^2940216^
	;;^DD(357.1,.04,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(357.1,.04,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(357.1,.04,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(357.1,.04,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(357.1,.04,"DT")
	;;=2930715
	;;^DD(357.1,.05,0)
	;;=BLOCK'S STARTING COLUMN^RNJ3,0XO^^0;5^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.1,.05,.1)
	;;=WHAT COLUMN SHOULD THE BLOCK START IN?
	;;^DD(357.1,.05,2)
	;;=S Y(0)=Y S Y=(+Y)+1
	;;^DD(357.1,.05,2.1)
	;;=S Y=(+Y)+1
	;;^DD(357.1,.05,3)
	;;=What column should this block begin on?
	;;^DD(357.1,.05,21,0)
	;;=^^1^1^2930715^^
	;;^DD(357.1,.05,21,1,0)
	;;=The column on the encounter form that the block starts on.
	;;^DD(357.1,.05,23,0)
	;;=^^4^4^2930715^
	;;^DD(357.1,.05,23,1,0)
	;;=The internal representation starts at 0, the external representation

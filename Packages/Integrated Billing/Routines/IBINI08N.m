IBINI08N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.91)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.91,0,"GL")
	;;=^IBE(357.91,
	;;^DIC("B","MARKING AREA TYPE",357.91)
	;;=
	;;^DIC(357.91,"%D",0)
	;;=^^4^4^2931214^^
	;;^DIC(357.91,"%D",1,0)
	;;= 
	;;^DIC(357.91,"%D",2,0)
	;;=This file contains the different types of marking areas that can be
	;;^DIC(357.91,"%D",3,0)
	;;=printed to a form for the user to write in. Examples are  ( ),__, etc.
	;;^DIC(357.91,"%D",4,0)
	;;=These are for the person completing the form to mark to indicate a choice.
	;;^DD(357.91,0)
	;;=FIELD^^.03^3
	;;^DD(357.91,0,"DDA")
	;;=N
	;;^DD(357.91,0,"DT")
	;;=2930811
	;;^DD(357.91,0,"IX","B",357.91,.01)
	;;=
	;;^DD(357.91,0,"NM","MARKING AREA TYPE")
	;;=
	;;^DD(357.91,0,"PT",357.22,.06)
	;;=
	;;^DD(357.91,.01,0)
	;;=NAME^RFX^^0;1^K:$L(X)>30 X
	;;^DD(357.91,.01,1,0)
	;;=^.1
	;;^DD(357.91,.01,1,1,0)
	;;=357.91^B
	;;^DD(357.91,.01,1,1,1)
	;;=S ^IBE(357.91,"B",$E(X,1,30),DA)=""
	;;^DD(357.91,.01,1,1,2)
	;;=K ^IBE(357.91,"B",$E(X,1,30),DA)
	;;^DD(357.91,.01,3)
	;;=NAME MUST BE UNDER 31 CHARACTERS
	;;^DD(357.91,.01,21,0)
	;;=^^1^1^2930608^
	;;^DD(357.91,.01,21,1,0)
	;;=The name should describe the appearance of the marking area on the form.
	;;^DD(357.91,.02,0)
	;;=DISPLAY STRING^F^^0;2^K:$L(X)>20!($L(X)<1) X
	;;^DD(357.91,.02,3)
	;;=Answer must be 1-20 characters in length.
	;;^DD(357.91,.02,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.91,.02,21,1,0)
	;;= 
	;;^DD(357.91,.02,21,2,0)
	;;=The text that should be displayed in the MARKING AREA.
	;;^DD(357.91,.02,"DT")
	;;=2921207
	;;^DD(357.91,.03,0)
	;;=TOOL KIT MEMBER?^S^0:NO;1:YES;^0;3^Q
	;;^DD(357.91,.03,3)
	;;=Enter YES if the MARKING AREA is part of the tool kit, NO otherwise.
	;;^DD(357.91,.03,21,0)
	;;=^^2^2^2930811^
	;;^DD(357.91,.03,21,1,0)
	;;=Used to prevent local sites from editing MARKING AREAS that are part of the
	;;^DD(357.91,.03,21,2,0)
	;;=tool kit.
	;;^DD(357.91,.03,"DT")
	;;=2930811

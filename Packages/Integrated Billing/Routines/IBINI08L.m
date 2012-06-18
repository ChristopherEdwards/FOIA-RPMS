IBINI08L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.8,0,"GL")
	;;=^IBE(357.8,
	;;^DIC("B","TEXT AREA",357.8)
	;;=
	;;^DIC(357.8,"%D",0)
	;;=^^3^3^2931214^^
	;;^DIC(357.8,"%D",1,0)
	;;= 
	;;^DIC(357.8,"%D",2,0)
	;;=A TEXT AREA rectangular area on the form that displays a word processing
	;;^DIC(357.8,"%D",3,0)
	;;=field. The text is automatically formatted to fit within the area.
	;;^DD(357.8,0)
	;;=FIELD^^1^7
	;;^DD(357.8,0,"DDA")
	;;=N
	;;^DD(357.8,0,"DT")
	;;=2930326
	;;^DD(357.8,0,"IX","B",357.8,.01)
	;;=
	;;^DD(357.8,0,"IX","C",357.8,.02)
	;;=
	;;^DD(357.8,0,"NM","TEXT AREA")
	;;=
	;;^DD(357.8,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(357.8,.01,1,0)
	;;=^.1
	;;^DD(357.8,.01,1,1,0)
	;;=357.8^B
	;;^DD(357.8,.01,1,1,1)
	;;=S ^IBE(357.8,"B",$E(X,1,30),DA)=""
	;;^DD(357.8,.01,1,1,2)
	;;=K ^IBE(357.8,"B",$E(X,1,30),DA)
	;;^DD(357.8,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(357.8,.01,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.8,.01,21,1,0)
	;;= 
	;;^DD(357.8,.01,21,2,0)
	;;=The name of the text area.
	;;^DD(357.8,.02,0)
	;;=BLOCK^RP357.1'^IBE(357.1,^0;2^Q
	;;^DD(357.8,.02,1,0)
	;;=^.1
	;;^DD(357.8,.02,1,1,0)
	;;=357.8^C
	;;^DD(357.8,.02,1,1,1)
	;;=S ^IBE(357.8,"C",$E(X,1,30),DA)=""
	;;^DD(357.8,.02,1,1,2)
	;;=K ^IBE(357.8,"C",$E(X,1,30),DA)
	;;^DD(357.8,.02,1,1,"%D",0)
	;;=^^3^3^2930326^
	;;^DD(357.8,.02,1,1,"%D",1,0)
	;;= 
	;;^DD(357.8,.02,1,1,"%D",2,0)
	;;=Used to find all of the text areas that should appear on a particular
	;;^DD(357.8,.02,1,1,"%D",3,0)
	;;=block.
	;;^DD(357.8,.02,1,1,"DT")
	;;=2930326
	;;^DD(357.8,.02,3)
	;;=What block do you want the text to appear in?
	;;^DD(357.8,.02,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.8,.02,21,1,0)
	;;= 
	;;^DD(357.8,.02,21,2,0)
	;;=The block the text area is displayed in.
	;;^DD(357.8,.02,"DT")
	;;=2930326
	;;^DD(357.8,.03,0)
	;;=TEXT AREA STARTING COLUMN^RNJ3,0XO^^0;3^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.8,.03,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(357.8,.03,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(357.8,.03,3)
	;;=What block column should the text begin in?
	;;^DD(357.8,.03,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.8,.03,21,1,0)
	;;= 
	;;^DD(357.8,.03,21,2,0)
	;;=The starting position of the text area, relative to the block.
	;;^DD(357.8,.03,23,0)
	;;=^^4^4^2930715^
	;;^DD(357.8,.03,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(357.8,.03,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(357.8,.03,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(357.8,.03,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(357.8,.03,"DT")
	;;=2930715
	;;^DD(357.8,.04,0)
	;;=TEXT AREA STARTING ROW^RNJ3,0XO^^0;4^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.8,.04,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(357.8,.04,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(357.8,.04,3)
	;;=What block row should the text begin in?
	;;^DD(357.8,.04,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.8,.04,21,1,0)
	;;= 
	;;^DD(357.8,.04,21,2,0)
	;;=The starting row of the text area, relative to the block.
	;;^DD(357.8,.04,23,0)
	;;=^^4^4^2930715^
	;;^DD(357.8,.04,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(357.8,.04,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(357.8,.04,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(357.8,.04,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.

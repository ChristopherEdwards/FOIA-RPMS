IBINI09I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.8,0,"GL")
	;;=^IBE(358.8,
	;;^DIC("B","IMP/EXP TEXT AREA",358.8)
	;;=
	;;^DIC(358.8,"%D",0)
	;;=^^3^3^2940217^
	;;^DIC(358.8,"%D",1,0)
	;;=This file is nearly identical to file #357.8. It is used by the
	;;^DIC(358.8,"%D",2,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.8,"%D",3,0)
	;;=that is being imported or exported.
	;;^DD(358.8,0)
	;;=FIELD^^1^7
	;;^DD(358.8,0,"DDA")
	;;=N
	;;^DD(358.8,0,"DT")
	;;=2930802
	;;^DD(358.8,0,"IX","B",358.8,.01)
	;;=
	;;^DD(358.8,0,"IX","C",358.8,.02)
	;;=
	;;^DD(358.8,0,"NM","IMP/EXP TEXT AREA")
	;;=
	;;^DD(358.8,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358.8,.01,1,0)
	;;=^.1
	;;^DD(358.8,.01,1,1,0)
	;;=358.8^B
	;;^DD(358.8,.01,1,1,1)
	;;=S ^IBE(358.8,"B",$E(X,1,30),DA)=""
	;;^DD(358.8,.01,1,1,2)
	;;=K ^IBE(358.8,"B",$E(X,1,30),DA)
	;;^DD(358.8,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(358.8,.01,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.8,.01,21,1,0)
	;;= 
	;;^DD(358.8,.01,21,2,0)
	;;=The name of the text area.
	;;^DD(358.8,.02,0)
	;;=BLOCK^RP358.1'^IBE(358.1,^0;2^Q
	;;^DD(358.8,.02,1,0)
	;;=^.1
	;;^DD(358.8,.02,1,1,0)
	;;=358.8^C
	;;^DD(358.8,.02,1,1,1)
	;;=S ^IBE(358.8,"C",$E(X,1,30),DA)=""
	;;^DD(358.8,.02,1,1,2)
	;;=K ^IBE(358.8,"C",$E(X,1,30),DA)
	;;^DD(358.8,.02,1,1,"%D",0)
	;;=^^3^3^2930326^
	;;^DD(358.8,.02,1,1,"%D",1,0)
	;;= 
	;;^DD(358.8,.02,1,1,"%D",2,0)
	;;=Used to find all of the text areas that should appear on a particular
	;;^DD(358.8,.02,1,1,"%D",3,0)
	;;=block.
	;;^DD(358.8,.02,1,1,"DT")
	;;=2930326
	;;^DD(358.8,.02,3)
	;;=What block do you want the text to appear in?
	;;^DD(358.8,.02,21,0)
	;;=^^2^2^2930802^^
	;;^DD(358.8,.02,21,1,0)
	;;= 
	;;^DD(358.8,.02,21,2,0)
	;;=The block the text area is displayed in.
	;;^DD(358.8,.02,"DT")
	;;=2930802
	;;^DD(358.8,.03,0)
	;;=TEXT AREA STARTING COLUMN^RNJ3,0XO^^0;3^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.8,.03,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(358.8,.03,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(358.8,.03,3)
	;;=What block column should the text begin in?
	;;^DD(358.8,.03,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.8,.03,21,1,0)
	;;= 
	;;^DD(358.8,.03,21,2,0)
	;;=The starting position of the text area, relative to the block.
	;;^DD(358.8,.03,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.8,.03,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.8,.03,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.8,.03,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.8,.03,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.8,.03,"DT")
	;;=2930715
	;;^DD(358.8,.04,0)
	;;=TEXT AREA STARTING ROW^RNJ3,0XO^^0;4^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.8,.04,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(358.8,.04,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(358.8,.04,3)
	;;=What block row should the text begin in?
	;;^DD(358.8,.04,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.8,.04,21,1,0)
	;;= 
	;;^DD(358.8,.04,21,2,0)
	;;=The starting row of the text area, relative to the block.
	;;^DD(358.8,.04,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.8,.04,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.8,.04,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.8,.04,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.8,.04,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.

IBINI09G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.7,0,"GL")
	;;=^IBE(358.7,
	;;^DIC("B","IMP/EXP FORM LINE",358.7)
	;;=
	;;^DIC(358.7,"%D",0)
	;;=^^3^3^2940217^
	;;^DIC(358.7,"%D",1,0)
	;;=This file is nearly identical to file #357.7. It is used by the
	;;^DIC(358.7,"%D",2,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.7,"%D",3,0)
	;;=that is being imported or exported.
	;;^DD(358.7,0)
	;;=FIELD^^.06^6
	;;^DD(358.7,0,"DDA")
	;;=N
	;;^DD(358.7,0,"DT")
	;;=2930802
	;;^DD(358.7,0,"ID",.02)
	;;=W " STARTING COL=",$P(^(0),U,2)+1
	;;^DD(358.7,0,"ID",.03)
	;;=W " STARTING ROW=",$P(^(0),U,3)+1
	;;^DD(358.7,0,"ID",.06)
	;;=W ""
	;;^DD(358.7,0,"IX","B",358.7,.01)
	;;=
	;;^DD(358.7,0,"IX","C",358.7,.06)
	;;=
	;;^DD(358.7,0,"NM","IMP/EXP FORM LINE")
	;;=
	;;^DD(358.7,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358.7,.01,1,0)
	;;=^.1
	;;^DD(358.7,.01,1,1,0)
	;;=358.7^B
	;;^DD(358.7,.01,1,1,1)
	;;=S ^IBE(358.7,"B",$E(X,1,30),DA)=""
	;;^DD(358.7,.01,1,1,2)
	;;=K ^IBE(358.7,"B",$E(X,1,30),DA)
	;;^DD(358.7,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(358.7,.01,21,0)
	;;=^^4^4^2930527^
	;;^DD(358.7,.01,21,1,0)
	;;= 
	;;^DD(358.7,.01,21,2,0)
	;;=The name given to the line. Lines should be given names that will allow
	;;^DD(358.7,.01,21,3,0)
	;;=them to be identifies, such as V(1,1), meaning a vertical line starting at
	;;^DD(358.7,.01,21,4,0)
	;;=coordinates (1,1).
	;;^DD(358.7,.02,0)
	;;=LINE STARTING COLUMN^RNJ3,0XO^^0;2^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.7,.02,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(358.7,.02,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(358.7,.02,3)
	;;=Enter the block column the line should begin at.
	;;^DD(358.7,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.7,.02,21,1,0)
	;;= 
	;;^DD(358.7,.02,21,2,0)
	;;=The column, relative to the block, that the line should begin at.
	;;^DD(358.7,.02,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.7,.02,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.7,.02,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.7,.02,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.7,.02,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.7,.02,"DT")
	;;=2930715
	;;^DD(358.7,.03,0)
	;;=LINE STARTING ROW^RNJ3,0XO^^0;3^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.7,.03,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(358.7,.03,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(358.7,.03,3)
	;;=Enter the block row the line should begin at.
	;;^DD(358.7,.03,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.7,.03,21,1,0)
	;;= 
	;;^DD(358.7,.03,21,2,0)
	;;=The row, relative to the block, that the line should begin at.
	;;^DD(358.7,.03,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.7,.03,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.7,.03,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.7,.03,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.7,.03,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.7,.03,"DT")
	;;=2930715
	;;^DD(358.7,.04,0)
	;;=ORIENTATION^RS^H:HORIZONTAL;V:VERTICAL;^0;4^Q
	;;^DD(358.7,.04,.1)
	;;=ORIENTATION (HORIZONTAL/VERTICAL)
	;;^DD(358.7,.04,3)
	;;=Should the line be horizontal or vertical?
	;;^DD(358.7,.04,21,0)
	;;=^^2^2^2930607^
	;;^DD(358.7,.04,21,1,0)
	;;= 
	;;^DD(358.7,.04,21,2,0)
	;;=The direction the line goes in.

IBINI08Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.21,0)
	;;=LIST COLUMN SUB-FIELD^^.04^4
	;;^DD(358.21,0,"ID","WRITE")
	;;=W "  COLUMN #",$P($G(^(0)),U)
	;;^DD(358.21,0,"IX","B",358.21,.01)
	;;=
	;;^DD(358.21,0,"NM","LIST COLUMN")
	;;=
	;;^DD(358.21,0,"UP")
	;;=358.2
	;;^DD(358.21,.01,0)
	;;=LIST COLUMN NUMBER^MNJ1,0^^0;1^K:+X'=X!(X>4)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.21,.01,1,0)
	;;=^.1
	;;^DD(358.21,.01,1,1,0)
	;;=358.21^B
	;;^DD(358.21,.01,1,1,1)
	;;=S ^IBE(358.2,DA(1),1,"B",$E(X,1,30),DA)=""
	;;^DD(358.21,.01,1,1,2)
	;;=K ^IBE(358.2,DA(1),1,"B",$E(X,1,30),DA)
	;;^DD(358.21,.01,3)
	;;=You can specify the position and height of up to 4 columns. Defaults will be used where needed.
	;;^DD(358.21,.01,21,0)
	;;=^^2^2^2930722^^
	;;^DD(358.21,.01,21,1,0)
	;;=The order that the columns will be filled. Column 1 will first be filled
	;;^DD(358.21,.01,21,2,0)
	;;=with items, then column 2, etc.
	;;^DD(358.21,.01,"DT")
	;;=2930802
	;;^DD(358.21,.02,0)
	;;=LIST COLUMN'S STARTING ROW^NJ3,0XO^^0;2^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.21,.02,.1)
	;;=WHAT ROW SHOULD THE LIST COLUMN START IN? (OPTIONAL)
	;;^DD(358.21,.02,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(358.21,.02,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(358.21,.02,3)
	;;=What row should the column begin in?
	;;^DD(358.21,.02,21,0)
	;;=^^2^2^2930715^^^
	;;^DD(358.21,.02,21,1,0)
	;;=The row, relative to the block, that the column should begin in. This is
	;;^DD(358.21,.02,21,2,0)
	;;=optional, since default values can be used.
	;;^DD(358.21,.02,23,0)
	;;=^^4^4^2930715^^
	;;^DD(358.21,.02,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.21,.02,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.21,.02,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.21,.02,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.21,.02,"DT")
	;;=2930802
	;;^DD(358.21,.03,0)
	;;=LIST COLUMN'S STARTING COLUMN^NJ3,0XO^^0;3^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.21,.03,.1)
	;;=WHAT LIST COLUMN SHOULD THE COLUMN START IN? (OPTIONAL)
	;;^DD(358.21,.03,2)
	;;=S Y(0)=Y S:+Y=Y Y=+Y+1
	;;^DD(358.21,.03,2.1)
	;;=S:+Y=Y Y=+Y+1
	;;^DD(358.21,.03,3)
	;;=At what block column should the list column begin at? The first subcolumn of the list column will start one character to the right of this.
	;;^DD(358.21,.03,21,0)
	;;=^^3^3^2930715^^
	;;^DD(358.21,.03,21,1,0)
	;;= 
	;;^DD(358.21,.03,21,2,0)
	;;=The column (# of characters to the right) that the column should begin in,
	;;^DD(358.21,.03,21,3,0)
	;;=relative to the block. It is optional, since a default value can be used.
	;;^DD(358.21,.03,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.21,.03,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.21,.03,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.21,.03,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.21,.03,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.21,.03,"DT")
	;;=2930802
	;;^DD(358.21,.04,0)
	;;=LIST COLUMN HEIGHT^NJ3,0^^0;4^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.21,.04,.1)
	;;=HOW MANY LINES HIGH SHOULD THE LIST COLUMN BE? (OPTIONAL)
	;;^DD(358.21,.04,3)
	;;=How many lines should the column cover?
	;;^DD(358.21,.04,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.21,.04,21,1,0)
	;;= 
	;;^DD(358.21,.04,21,2,0)
	;;=The number of lines the column should occupy. This is optional - if not

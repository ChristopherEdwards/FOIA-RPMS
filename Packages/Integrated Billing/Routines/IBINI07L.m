IBINI07L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.1,.14,21,0)
	;;=^^3^3^2930817^^^^
	;;^DD(357.1,.14,21,1,0)
	;;=A number>0 in this field means that the block is part of the tool kit.
	;;^DD(357.1,.14,21,2,0)
	;;=The value determines the order that the block will be listed to the
	;;^DD(357.1,.14,21,3,0)
	;;=screen that displays the tool kit blocks.
	;;^DD(357.1,.14,"DT")
	;;=2930817
	;;^DD(357.1,1,0)
	;;=COMPILED STRINGS^357.11A^^S;0
	;;^DD(357.1,1,21,0)
	;;=^^3^3^2931117^^
	;;^DD(357.1,1,21,1,0)
	;;=Contains a compiled list of the calls, along with the arguments, that should
	;;^DD(357.1,1,21,2,0)
	;;=be made to the routine that prints strings to the form. Before printing, the
	;;^DD(357.1,1,21,3,0)
	;;=block offset is added to the string position.
	;;^DD(357.1,2,0)
	;;=COMPILED VERTICAL LINES^357.12A^^V;0
	;;^DD(357.1,2,21,0)
	;;=^^3^3^2940216^
	;;^DD(357.1,2,21,1,0)
	;;=A compiled list of the vertical lines that are needed to print the block.
	;;^DD(357.1,2,21,2,0)
	;;=The arguments to the routine that prints the line are included. The
	;;^DD(357.1,2,21,3,0)
	;;=block's offset is must be added to the line's position.
	;;^DD(357.11,0)
	;;=COMPILED STRINGS SUB-FIELD^^.05^5
	;;^DD(357.11,0,"DIK")
	;;=IBXF1
	;;^DD(357.11,0,"DT")
	;;=2931115
	;;^DD(357.11,0,"IX","B",357.11,.01)
	;;=
	;;^DD(357.11,0,"NM","COMPILED STRINGS")
	;;=
	;;^DD(357.11,0,"UP")
	;;=357.1
	;;^DD(357.11,.01,0)
	;;=STRING ROW^NJ3,0^^0;1^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.11,.01,1,0)
	;;=^.1
	;;^DD(357.11,.01,1,1,0)
	;;=357.11^B
	;;^DD(357.11,.01,1,1,1)
	;;=S ^IBE(357.1,DA(1),"S","B",$E(X,1,30),DA)=""
	;;^DD(357.11,.01,1,1,2)
	;;=K ^IBE(357.1,DA(1),"S","B",$E(X,1,30),DA)
	;;^DD(357.11,.01,3)
	;;=Type a Number between 0 and 200, 0 Decimal Digits
	;;^DD(357.11,.01,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.11,.01,21,1,0)
	;;=The row that the string should be printed at.
	;;^DD(357.11,.01,"DT")
	;;=2931117
	;;^DD(357.11,.02,0)
	;;=COLUMN^RNJ3,0^^0;2^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.11,.02,3)
	;;=Type a Number between 0 and 200, 0 Decimal Digits
	;;^DD(357.11,.02,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.11,.02,21,1,0)
	;;=The column that the string should be printed at.
	;;^DD(357.11,.02,"DT")
	;;=2931115
	;;^DD(357.11,.03,0)
	;;=OPTIONS^F^^0;3^K:$L(X)>4!($L(X)<1) X
	;;^DD(357.11,.03,3)
	;;=Answer must be 1-4 characters in length.
	;;^DD(357.11,.03,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.11,.03,21,1,0)
	;;=The display characteristics that the string should have.
	;;^DD(357.11,.03,"DT")
	;;=2931115
	;;^DD(357.11,.04,0)
	;;=WIDTH^NJ3,0^^0;4^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.11,.04,3)
	;;=Type a Number between 0 and 200, 0 Decimal Digits
	;;^DD(357.11,.04,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.11,.04,21,1,0)
	;;=The width that the printed string should occupy. (optional)
	;;^DD(357.11,.04,"DT")
	;;=2931115
	;;^DD(357.11,.05,0)
	;;=STRING^F^^0;5^K:$L(X)>200!($L(X)<1) X
	;;^DD(357.11,.05,3)
	;;=Answer must be 1-200 characters in length.
	;;^DD(357.11,.05,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.11,.05,21,1,0)
	;;=The string that should be printed.
	;;^DD(357.11,.05,"DT")
	;;=2931115
	;;^DD(357.12,0)
	;;=COMPILED VERTICAL LINES SUB-FIELD^^.04^4
	;;^DD(357.12,0,"DIK")
	;;=IBXF1
	;;^DD(357.12,0,"DT")
	;;=2931117
	;;^DD(357.12,0,"IX","B",357.12,.01)
	;;=
	;;^DD(357.12,0,"NM","COMPILED VERTICAL LINES")
	;;=
	;;^DD(357.12,0,"UP")
	;;=357.1
	;;^DD(357.12,.01,0)
	;;=VERTICAL LINE ROW^NJ3,0^^0;1^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.12,.01,1,0)
	;;=^.1
	;;^DD(357.12,.01,1,1,0)
	;;=357.12^B
	;;^DD(357.12,.01,1,1,1)
	;;=S ^IBE(357.1,DA(1),"V","B",$E(X,1,30),DA)=""

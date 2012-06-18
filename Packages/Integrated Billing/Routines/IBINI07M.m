IBINI07M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.12,.01,1,1,2)
	;;=K ^IBE(357.1,DA(1),"V","B",$E(X,1,30),DA)
	;;^DD(357.12,.01,3)
	;;=Type a Number between 0 and 200, 0 Decimal Digits
	;;^DD(357.12,.01,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.12,.01,21,1,0)
	;;=The row that the line should begin at.
	;;^DD(357.12,.01,"DT")
	;;=2931117
	;;^DD(357.12,.02,0)
	;;=COLUMN^RNJ3,0^^0;2^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.12,.02,3)
	;;=Type a Number between 0 and 200, 0 Decimal Digits
	;;^DD(357.12,.02,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.12,.02,21,1,0)
	;;=The column that the line should begin at.
	;;^DD(357.12,.02,"DT")
	;;=2931117
	;;^DD(357.12,.03,0)
	;;=LENGTH^RNJ3,0^^0;3^K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.12,.03,3)
	;;=Type a Number between 0 and 200, 0 Decimal Digits
	;;^DD(357.12,.03,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.12,.03,21,1,0)
	;;=The length of the line.
	;;^DD(357.12,.03,"DT")
	;;=2931117
	;;^DD(357.12,.04,0)
	;;=CHARACTER^F^^0;4^K:$L(X)>30!($L(X)<1) X
	;;^DD(357.12,.04,3)
	;;=Answer must be 1-30 characters in length.
	;;^DD(357.12,.04,21,0)
	;;=^^1^1^2931117^
	;;^DD(357.12,.04,21,1,0)
	;;=The string (probably a single character) to use to create the string. (optional)
	;;^DD(357.12,.04,"DT")
	;;=2931117

FHINI0L3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.6,99,1,1,2)
	;;=K ^FH(115.6,DA,"I")
	;;^DD(115.6,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(115.6,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(115.6,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(115.6,99,21,0)
	;;=^^2^2^2950221^^
	;;^DD(115.6,99,21,1,0)
	;;=This field, when answered YES, will prohibit further
	;;^DD(115.6,99,21,2,0)
	;;=selection of this encounter type by dietetic personnel.
	;;^DD(115.6,99,"DT")
	;;=2891107
	;;^DD(115.6,101,0)
	;;=IDENT NUMBER^NJ2,0^^0;10^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.6,101,1,0)
	;;=^.1
	;;^DD(115.6,101,1,1,0)
	;;=115.6^AX
	;;^DD(115.6,101,1,1,1)
	;;=S ^FH(115.6,"AX",$E(X,1,30),DA)=""
	;;^DD(115.6,101,1,1,2)
	;;=K ^FH(115.6,"AX",$E(X,1,30),DA)
	;;^DD(115.6,101,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.6,101,21,0)
	;;=^^3^3^2900929^
	;;^DD(115.6,101,21,1,0)
	;;=This field is pre-set for some encounter types to uniquely
	;;^DD(115.6,101,21,2,0)
	;;=identify them for tabulation and other purposes. The number has
	;;^DD(115.6,101,21,3,0)
	;;=no meaning.
	;;^DD(115.6,101,"DT")
	;;=2901001

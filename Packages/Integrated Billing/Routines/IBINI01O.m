IBINI01O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.3,0,"GL")
	;;=^IBE(350.3,
	;;^DIC("B","IB CHARGE REMOVE REASONS",350.3)
	;;=
	;;^DIC(350.3,"%D",0)
	;;=^^6^6^2940214^^^^
	;;^DIC(350.3,"%D",1,0)
	;;=This file contains the reasons that an IB ACTION entry was cancelled.
	;;^DIC(350.3,"%D",2,0)
	;;= 
	;;^DIC(350.3,"%D",3,0)
	;;=This file comes pre-loaded with data and should not be edited or added
	;;^DIC(350.3,"%D",4,0)
	;;=to by sites.
	;;^DIC(350.3,"%D",5,0)
	;;= 
	;;^DIC(350.3,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.3,0)
	;;=FIELD^^.03^4
	;;^DD(350.3,0,"DT")
	;;=2920130
	;;^DD(350.3,0,"IX","B",350.3,.01)
	;;=
	;;^DD(350.3,0,"IX","C",350.3,.02)
	;;=
	;;^DD(350.3,0,"NM","IB CHARGE REMOVE REASONS")
	;;=
	;;^DD(350.3,0,"PT",350,.1)
	;;=
	;;^DD(350.3,.001,0)
	;;=NUMBER^NJ4,0^^ ^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.3,.001,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(350.3,.001,21,0)
	;;=^^1^1^2930406^^
	;;^DD(350.3,.001,21,1,0)
	;;=A number which is used to uniquely identify the entry in this file.
	;;^DD(350.3,.001,"DT")
	;;=2910419
	;;^DD(350.3,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(350.3,.01,1,0)
	;;=^.1
	;;^DD(350.3,.01,1,1,0)
	;;=350.3^B
	;;^DD(350.3,.01,1,1,1)
	;;=S ^IBE(350.3,"B",$E(X,1,30),DA)=""
	;;^DD(350.3,.01,1,1,2)
	;;=K ^IBE(350.3,"B",$E(X,1,30),DA)
	;;^DD(350.3,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(350.3,.01,21,0)
	;;=^^1^1^2910305^
	;;^DD(350.3,.01,21,1,0)
	;;=Enter the reason that the charges are being cancelled.
	;;^DD(350.3,.02,0)
	;;=ABBREVIATION^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>10!($L(X)<2) X
	;;^DD(350.3,.02,1,0)
	;;=^.1
	;;^DD(350.3,.02,1,1,0)
	;;=350.3^C
	;;^DD(350.3,.02,1,1,1)
	;;=S ^IBE(350.3,"C",$E(X,1,30),DA)=""
	;;^DD(350.3,.02,1,1,2)
	;;=K ^IBE(350.3,"C",$E(X,1,30),DA)
	;;^DD(350.3,.02,3)
	;;=Answer must be 2-10 characters in length.
	;;^DD(350.3,.02,21,0)
	;;=^^2^2^2910305^
	;;^DD(350.3,.02,21,1,0)
	;;=Enter a unique abbreviation for this cancellation reason that can
	;;^DD(350.3,.02,21,2,0)
	;;=assist in quick lookup of this entry.
	;;^DD(350.3,.03,0)
	;;=LIMIT^S^1:RX;2:OP MEANS TEST;3:GENERIC;4:OTHER;^0;3^Q
	;;^DD(350.3,.03,21,0)
	;;=^^2^2^2920415^^
	;;^DD(350.3,.03,21,1,0)
	;;=This field is a set of codes that identifies which type of charge
	;;^DD(350.3,.03,21,2,0)
	;;=the IB Charge Removal Reason can be used for.
	;;^DD(350.3,.03,"DT")
	;;=2920130

IBINI072	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.7,0,"GL")
	;;=^IBE(356.7,
	;;^DIC("B","CLAIMS TRACKING ACTION",356.7)
	;;=
	;;^DIC(356.7,"%D",0)
	;;=^^7^7^2940214^^^^
	;;^DIC(356.7,"%D",1,0)
	;;=This file contains a list of the types of actions that may be taken
	;;^DIC(356.7,"%D",2,0)
	;;=on a review or a contact by an insurance company
	;;^DIC(356.7,"%D",3,0)
	;;= 
	;;^DIC(356.7,"%D",4,0)
	;;=Do NOT add, edit, or delete entries in this file without instructions
	;;^DIC(356.7,"%D",5,0)
	;;=from your ISC.
	;;^DIC(356.7,"%D",6,0)
	;;= 
	;;^DIC(356.7,"%D",7,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.7,0)
	;;=FIELD^^.03^3
	;;^DD(356.7,0,"DDA")
	;;=N
	;;^DD(356.7,0,"DT")
	;;=2930728
	;;^DD(356.7,0,"IX","ACODE",356.7,.03)
	;;=
	;;^DD(356.7,0,"IX","B",356.7,.01)
	;;=
	;;^DD(356.7,0,"NM","CLAIMS TRACKING ACTION")
	;;=
	;;^DD(356.7,0,"PT",356.2,.11)
	;;=
	;;^DD(356.7,.001,0)
	;;=NUMBER^NJ6,0^^ ^K:+X'=X!(X>999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.7,.001,3)
	;;=Type a Number between 1 and 999999, 0 Decimal Digits
	;;^DD(356.7,.001,21,0)
	;;=^^1^1^2931128^
	;;^DD(356.7,.001,21,1,0)
	;;=This is the number of the Action.  It is used for look-up purposes.
	;;^DD(356.7,.001,"DT")
	;;=2930610
	;;^DD(356.7,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(356.7,.01,1,0)
	;;=^.1
	;;^DD(356.7,.01,1,1,0)
	;;=356.7^B
	;;^DD(356.7,.01,1,1,1)
	;;=S ^IBE(356.7,"B",$E(X,1,30),DA)=""
	;;^DD(356.7,.01,1,1,2)
	;;=K ^IBE(356.7,"B",$E(X,1,30),DA)
	;;^DD(356.7,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(356.7,.01,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.7,.01,21,1,0)
	;;=This is the name of the action that can be taken by an insurance 
	;;^DD(356.7,.01,21,2,0)
	;;=company on a review or contact.  Do not locally add, edit, or delete
	;;^DD(356.7,.01,21,3,0)
	;;=entries from this file.
	;;^DD(356.7,.03,0)
	;;=CODE^NJ3,0I^^0;3^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.7,.03,1,0)
	;;=^.1
	;;^DD(356.7,.03,1,1,0)
	;;=356.7^ACODE
	;;^DD(356.7,.03,1,1,1)
	;;=S ^IBE(356.7,"ACODE",$E(X,1,30),DA)=""
	;;^DD(356.7,.03,1,1,2)
	;;=K ^IBE(356.7,"ACODE",$E(X,1,30),DA)
	;;^DD(356.7,.03,1,1,"DT")
	;;=2930811
	;;^DD(356.7,.03,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(356.7,.03,21,0)
	;;=^^3^3^2931128^
	;;^DD(356.7,.03,21,1,0)
	;;=This is the code for this type of action entry.  This number is used
	;;^DD(356.7,.03,21,2,0)
	;;=internally by the Claims Tracking module and should not be modified 
	;;^DD(356.7,.03,21,3,0)
	;;=locally.
	;;^DD(356.7,.03,"DT")
	;;=2931128

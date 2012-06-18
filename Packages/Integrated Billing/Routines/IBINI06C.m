IBINI06C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.21)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.21,0,"GL")
	;;=^IBE(356.21,
	;;^DIC("B","CLAIMS TRACKING DENIAL REASONS",356.21)
	;;=
	;;^DIC(356.21,"%D",0)
	;;=^^9^9^2940214^^^
	;;^DIC(356.21,"%D",1,0)
	;;=This file is a list of the standard reasons for denial of a claim.  Do
	;;^DIC(356.21,"%D",2,0)
	;;=not add to or delete from this file.  Editing this file may have significant
	;;^DIC(356.21,"%D",3,0)
	;;=impact on the results of the MCCR NDB roll-up of claims tracking 
	;;^DIC(356.21,"%D",4,0)
	;;=information.
	;;^DIC(356.21,"%D",5,0)
	;;= 
	;;^DIC(356.21,"%D",6,0)
	;;=Do NOT add, edit, or delete entries in this file without instructions
	;;^DIC(356.21,"%D",7,0)
	;;=from your ISC.
	;;^DIC(356.21,"%D",8,0)
	;;= 
	;;^DIC(356.21,"%D",9,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.21,0)
	;;=FIELD^^.02^3
	;;^DD(356.21,0,"DDA")
	;;=N
	;;^DD(356.21,0,"DT")
	;;=2930825
	;;^DD(356.21,0,"IX","B",356.21,.01)
	;;=
	;;^DD(356.21,0,"NM","CLAIMS TRACKING DENIAL REASONS")
	;;=
	;;^DD(356.21,0,"PT",356.212,.01)
	;;=
	;;^DD(356.21,.001,0)
	;;=NUMBER^NJ5,0^^ ^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.21,.001,3)
	;;=Type a Number between 1 and 99999, 0 Decimal Digits
	;;^DD(356.21,.001,21,0)
	;;=^^2^2^2931128^
	;;^DD(356.21,.001,21,1,0)
	;;=This is the number of the entry.  You may select the Denial Reason by
	;;^DD(356.21,.001,21,2,0)
	;;=name or by number.
	;;^DD(356.21,.001,"DT")
	;;=2930610
	;;^DD(356.21,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>60!($L(X)<3)!'(X'?1P.E) X
	;;^DD(356.21,.01,1,0)
	;;=^.1
	;;^DD(356.21,.01,1,1,0)
	;;=356.21^B
	;;^DD(356.21,.01,1,1,1)
	;;=S ^IBE(356.21,"B",$E(X,1,30),DA)=""
	;;^DD(356.21,.01,1,1,2)
	;;=K ^IBE(356.21,"B",$E(X,1,30),DA)
	;;^DD(356.21,.01,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(356.21,.01,21,0)
	;;=^^2^2^2931128^
	;;^DD(356.21,.01,21,1,0)
	;;=This is the name of the denial reason.  Select the Denial reason by name
	;;^DD(356.21,.01,21,2,0)
	;;=or by number.
	;;^DD(356.21,.01,"DT")
	;;=2930825
	;;^DD(356.21,.02,0)
	;;=ABBREVIATION^F^^0;2^K:$L(X)>10!($L(X)<2) X
	;;^DD(356.21,.02,3)
	;;=Answer must be 2-10 characters in length.
	;;^DD(356.21,.02,21,0)
	;;=^^2^2^2931128^
	;;^DD(356.21,.02,21,1,0)
	;;=Enter the 2 to 10 character abbreviation for this Denial Reason.  The
	;;^DD(356.21,.02,21,2,0)
	;;=abbreviation may be used on displays and reports if the name is too long.
	;;^DD(356.21,.02,"DT")
	;;=2930610

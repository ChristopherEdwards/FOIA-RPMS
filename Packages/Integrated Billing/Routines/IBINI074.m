IBINI074	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.8,0,"GL")
	;;=^IBE(356.8,
	;;^DIC("B","CLAIMS TRACKING NON-BILLABLE REASONS",356.8)
	;;=
	;;^DIC(356.8,"%D",0)
	;;=^^7^7^2940214^^
	;;^DIC(356.8,"%D",1,0)
	;;=This is a file of reasons that may be entered into the claims tracking 
	;;^DIC(356.8,"%D",2,0)
	;;=module to specify why a potential claim isn't billable.
	;;^DIC(356.8,"%D",3,0)
	;;= 
	;;^DIC(356.8,"%D",4,0)
	;;=Do NOT add, edit, or delete entries in this file without instructions
	;;^DIC(356.8,"%D",5,0)
	;;=from your ISC.
	;;^DIC(356.8,"%D",6,0)
	;;= 
	;;^DIC(356.8,"%D",7,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.8,0)
	;;=FIELD^^.001^2
	;;^DD(356.8,0,"DDA")
	;;=N
	;;^DD(356.8,0,"DT")
	;;=2930930
	;;^DD(356.8,0,"IX","B",356.8,.01)
	;;=
	;;^DD(356.8,0,"NM","CLAIMS TRACKING NON-BILLABLE REASONS")
	;;=
	;;^DD(356.8,0,"PT",356,.19)
	;;=
	;;^DD(356.8,.001,0)
	;;=NUMBER^NJ4,0^^ ^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.8,.001,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(356.8,.001,21,0)
	;;=^^2^2^2931128^
	;;^DD(356.8,.001,21,1,0)
	;;=This is the number of the reason not billable.  It is used for look-up
	;;^DD(356.8,.001,21,2,0)
	;;=purposes only.
	;;^DD(356.8,.001,"DT")
	;;=2930930
	;;^DD(356.8,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(356.8,.01,1,0)
	;;=^.1
	;;^DD(356.8,.01,1,1,0)
	;;=356.8^B
	;;^DD(356.8,.01,1,1,1)
	;;=S ^IBE(356.8,"B",$E(X,1,30),DA)=""
	;;^DD(356.8,.01,1,1,2)
	;;=K ^IBE(356.8,"B",$E(X,1,30),DA)
	;;^DD(356.8,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(356.8,.01,21,0)
	;;=^^5^5^2940213^^^^
	;;^DD(356.8,.01,21,1,0)
	;;=Enter the name of the reason that a visit is not billable.  This is the name
	;;^DD(356.8,.01,21,2,0)
	;;=that will appear on displays and outputs.  If a claims tracking entry is 
	;;^DD(356.8,.01,21,3,0)
	;;=assigned a reaon not billable then it will be considered to not be 
	;;^DD(356.8,.01,21,4,0)
	;;=billable.  Users may select whether visits that have a reason not billable
	;;^DD(356.8,.01,21,5,0)
	;;=assigned should appear on the patients with visits and insurance reports.

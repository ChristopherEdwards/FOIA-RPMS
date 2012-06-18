IBINI05X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.11)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.11,0,"GL")
	;;=^IBE(356.11,
	;;^DIC("B","CLAIMS TRACKING REVIEW TYPE",356.11)
	;;=
	;;^DIC(356.11,"%D",0)
	;;=^^8^8^2940214^^^^
	;;^DIC(356.11,"%D",1,0)
	;;=This is the type of Review that is being performed by MCCR or UR.  This 
	;;^DIC(356.11,"%D",2,0)
	;;=file may contain the logic to determine which quesions and/or screens
	;;^DIC(356.11,"%D",3,0)
	;;=can be presented to the user in the future.
	;;^DIC(356.11,"%D",4,0)
	;;= 
	;;^DIC(356.11,"%D",5,0)
	;;=Do NOT add, edit, or delete entries in this file without instructions
	;;^DIC(356.11,"%D",6,0)
	;;=from your ISC.
	;;^DIC(356.11,"%D",7,0)
	;;= 
	;;^DIC(356.11,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.11,0)
	;;=FIELD^^.03^3
	;;^DD(356.11,0,"DDA")
	;;=N
	;;^DD(356.11,0,"DT")
	;;=2930826
	;;^DD(356.11,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(356.11,0,"IX","ACODE",356.11,.02)
	;;=
	;;^DD(356.11,0,"IX","B",356.11,.01)
	;;=
	;;^DD(356.11,0,"IX","C",356.11,.02)
	;;=
	;;^DD(356.11,0,"NM","CLAIMS TRACKING REVIEW TYPE")
	;;=
	;;^DD(356.11,0,"PT",356.1,.22)
	;;=
	;;^DD(356.11,0,"PT",356.2,.04)
	;;=
	;;^DD(356.11,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(356.11,.01,1,0)
	;;=^.1
	;;^DD(356.11,.01,1,1,0)
	;;=356.11^B
	;;^DD(356.11,.01,1,1,1)
	;;=S ^IBE(356.11,"B",$E(X,1,30),DA)=""
	;;^DD(356.11,.01,1,1,2)
	;;=K ^IBE(356.11,"B",$E(X,1,30),DA)
	;;^DD(356.11,.01,3)
	;;=Enter the name of the type of Review.  Answer must be 3-30 characters in length.
	;;^DD(356.11,.01,21,0)
	;;=^^1^1^2930714^
	;;^DD(356.11,.01,21,1,0)
	;;=This is the name of the type of Review being performed.
	;;^DD(356.11,.01,"DT")
	;;=2930714
	;;^DD(356.11,.02,0)
	;;=CODE^NJ3,0^^0;2^K:+X'=X!(X>100)!(X<10)!(X?.E1"."1N.N) X
	;;^DD(356.11,.02,1,0)
	;;=^.1
	;;^DD(356.11,.02,1,1,0)
	;;=356.11^ACODE
	;;^DD(356.11,.02,1,1,1)
	;;=S ^IBE(356.11,"ACODE",$E(X,1,30),DA)=""
	;;^DD(356.11,.02,1,1,2)
	;;=K ^IBE(356.11,"ACODE",$E(X,1,30),DA)
	;;^DD(356.11,.02,1,1,3)
	;;=DO NOT DELETE
	;;^DD(356.11,.02,1,1,"%D",0)
	;;=^^2^2^2930706^
	;;^DD(356.11,.02,1,1,"%D",1,0)
	;;=Regular cross-reference used to look-up review type internally by code
	;;^DD(356.11,.02,1,1,"%D",2,0)
	;;=number.
	;;^DD(356.11,.02,1,1,"DT")
	;;=2930706
	;;^DD(356.11,.02,1,2,0)
	;;=356.11^C
	;;^DD(356.11,.02,1,2,1)
	;;=S ^IBE(356.11,"C",$E(X,1,30),DA)=""
	;;^DD(356.11,.02,1,2,2)
	;;=K ^IBE(356.11,"C",$E(X,1,30),DA)
	;;^DD(356.11,.02,1,2,"DT")
	;;=2930803
	;;^DD(356.11,.02,3)
	;;=Type a Number between 10 and 100, 0 Decimal Digits
	;;^DD(356.11,.02,21,0)
	;;=^^2^2^2930714^
	;;^DD(356.11,.02,21,1,0)
	;;=Enter the internal code used by the claims tracking module to identify
	;;^DD(356.11,.02,21,2,0)
	;;=this specific type of review.
	;;^DD(356.11,.02,"DT")
	;;=2930803
	;;^DD(356.11,.03,0)
	;;=ABBREVIATION^F^^0;3^K:$L(X)>10!($L(X)<2) X
	;;^DD(356.11,.03,3)
	;;=Answer must be 2-10 characters in length.
	;;^DD(356.11,.03,21,0)
	;;=^^2^2^2930826^
	;;^DD(356.11,.03,21,1,0)
	;;=This is the abbreviation for this type of review that will be displayed
	;;^DD(356.11,.03,21,2,0)
	;;=on reports and input screens.
	;;^DD(356.11,.03,"DT")
	;;=2930826

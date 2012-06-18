IBINI08P	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.92)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.92,0,"GL")
	;;=^IBE(357.92,
	;;^DIC("B","PRINT CONDITIONS",357.92)
	;;=
	;;^DIC(357.92,"%D",0)
	;;=^^6^6^2931214^^
	;;^DIC(357.92,"%D",1,0)
	;;= 
	;;^DIC(357.92,"%D",2,0)
	;;=A table containing a list of conditions recognized by the print manager.
	;;^DIC(357.92,"%D",3,0)
	;;=They are used to specify the conditions under which reports should be
	;;^DIC(357.92,"%D",4,0)
	;;=printed. The print manager is a program that scans the appointments for
	;;^DIC(357.92,"%D",5,0)
	;;=selected clinics for a selected date, and prints specified reports under
	;;^DIC(357.92,"%D",6,0)
	;;=specified conditions.
	;;^DD(357.92,0)
	;;=FIELD^^.01^1
	;;^DD(357.92,0,"DT")
	;;=2930518
	;;^DD(357.92,0,"IX","B",357.92,.01)
	;;=
	;;^DD(357.92,0,"NM","PRINT CONDITIONS")
	;;=
	;;^DD(357.92,0,"PT",409.9501,.02)
	;;=
	;;^DD(357.92,0,"PT",409.961,.02)
	;;=
	;;^DD(357.92,.01,0)
	;;=PRINT CONDITION^RF^^0;1^K:$L(X)>40!($L(X)<3)!'(X'?1P.E) X
	;;^DD(357.92,.01,1,0)
	;;=^.1
	;;^DD(357.92,.01,1,1,0)
	;;=357.92^B
	;;^DD(357.92,.01,1,1,1)
	;;=S ^IBE(357.92,"B",$E(X,1,30),DA)=""
	;;^DD(357.92,.01,1,1,2)
	;;=K ^IBE(357.92,"B",$E(X,1,30),DA)
	;;^DD(357.92,.01,3)
	;;=Answer must be 3-40 characters in length.
	;;^DD(357.92,.01,21,0)
	;;=^^2^2^2930528^
	;;^DD(357.92,.01,21,1,0)
	;;= 
	;;^DD(357.92,.01,21,2,0)
	;;=A condition recognized by the Print Manager.
	;;^DD(357.92,.01,"DT")
	;;=2930518

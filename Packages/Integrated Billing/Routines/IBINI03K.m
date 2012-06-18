IBINI03K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(353.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(353.2,0,"GL")
	;;=^IBE(353.2,
	;;^DIC("B","TYPE OF SERVICE",353.2)
	;;=
	;;^DIC(353.2,"%D",0)
	;;=^^5^5^2940214^^
	;;^DIC(353.2,"%D",1,0)
	;;=This is a reference file containing the Types of Services that may be
	;;^DIC(353.2,"%D",2,0)
	;;=associated with a procedure.  This set is specifically defined for the
	;;^DIC(353.2,"%D",3,0)
	;;=HCFA 1500.
	;;^DIC(353.2,"%D",4,0)
	;;= 
	;;^DIC(353.2,"%D",5,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(353.2,0)
	;;=FIELD^^.03^3
	;;^DD(353.2,0,"DDA")
	;;=N
	;;^DD(353.2,0,"DT")
	;;=2920429
	;;^DD(353.2,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(353.2,0,"IX","B",353.2,.01)
	;;=
	;;^DD(353.2,0,"IX","C",353.2,.02)
	;;=
	;;^DD(353.2,0,"NM","TYPE OF SERVICE")
	;;=
	;;^DD(353.2,0,"PT",162.03,31)
	;;=
	;;^DD(353.2,0,"PT",399,169)
	;;=
	;;^DD(353.2,0,"PT",399.0304,9)
	;;=
	;;^DD(353.2,.01,0)
	;;=CODE^RF^^0;1^K:$L(X)>7!($L(X)<1)!'(X'?1P.E) X
	;;^DD(353.2,.01,1,0)
	;;=^.1
	;;^DD(353.2,.01,1,1,0)
	;;=353.2^B
	;;^DD(353.2,.01,1,1,1)
	;;=S ^IBE(353.2,"B",$E(X,1,30),DA)=""
	;;^DD(353.2,.01,1,1,2)
	;;=K ^IBE(353.2,"B",$E(X,1,30),DA)
	;;^DD(353.2,.01,3)
	;;=Answer must be 1-7 characters in length.
	;;^DD(353.2,.01,21,0)
	;;=^^2^2^2920427^
	;;^DD(353.2,.01,21,1,0)
	;;=This is the code that identifies a Type of Service associated with a visit
	;;^DD(353.2,.01,21,2,0)
	;;=on the HCFA 1500.
	;;^DD(353.2,.01,"DT")
	;;=2920427
	;;^DD(353.2,.02,0)
	;;=NAME^RF^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>50!($L(X)<3) X
	;;^DD(353.2,.02,1,0)
	;;=^.1
	;;^DD(353.2,.02,1,1,0)
	;;=353.2^C
	;;^DD(353.2,.02,1,1,1)
	;;=S ^IBE(353.2,"C",$E(X,1,30),DA)=""
	;;^DD(353.2,.02,1,1,2)
	;;=K ^IBE(353.2,"C",$E(X,1,30),DA)
	;;^DD(353.2,.02,1,1,3)
	;;=DO NOT DELETE
	;;^DD(353.2,.02,1,1,"DT")
	;;=2920630
	;;^DD(353.2,.02,3)
	;;=Answer must be 3-50 characters in length.
	;;^DD(353.2,.02,21,0)
	;;=^^1^1^2920429^^^
	;;^DD(353.2,.02,21,1,0)
	;;=This is the full name/description of this Type of Service.
	;;^DD(353.2,.02,"DT")
	;;=2920630
	;;^DD(353.2,.03,0)
	;;=ABBREVIATION^RF^^0;3^K:$L(X)>20!($L(X)<2) X
	;;^DD(353.2,.03,3)
	;;=Answer must be 2-20 characters in length.
	;;^DD(353.2,.03,21,0)
	;;=^^2^2^2920427^
	;;^DD(353.2,.03,21,1,0)
	;;=This is the abbreviation of the name of this entry.  Will primarily be
	;;^DD(353.2,.03,21,2,0)
	;;=used for reports.
	;;^DD(353.2,.03,"DT")
	;;=2920427

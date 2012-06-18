IBINI03I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(353.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(353.1,0,"GL")
	;;=^IBE(353.1,
	;;^DIC("B","PLACE OF SERVICE",353.1)
	;;=
	;;^DIC(353.1,"%D",0)
	;;=^^5^5^2940214^^
	;;^DIC(353.1,"%D",1,0)
	;;=This is a reference file containing the Place of Service codes that may be
	;;^DIC(353.1,"%D",2,0)
	;;=associated with a procedure.  This is a set of codes specifically defined to
	;;^DIC(353.1,"%D",3,0)
	;;=be used on the HCFA 1500.
	;;^DIC(353.1,"%D",4,0)
	;;= 
	;;^DIC(353.1,"%D",5,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(353.1,0)
	;;=FIELD^^.03^3
	;;^DD(353.1,0,"DDA")
	;;=N
	;;^DD(353.1,0,"DT")
	;;=2920429
	;;^DD(353.1,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(353.1,0,"IX","B",353.1,.01)
	;;=
	;;^DD(353.1,0,"IX","C",353.1,.02)
	;;=
	;;^DD(353.1,0,"NM","PLACE OF SERVICE")
	;;=
	;;^DD(353.1,0,"PT",162.03,30)
	;;=
	;;^DD(353.1,0,"PT",399,168)
	;;=
	;;^DD(353.1,0,"PT",399.0304,8)
	;;=
	;;^DD(353.1,.01,0)
	;;=CODE^RF^^0;1^K:$L(X)>7!($L(X)<1)!'(X'?1P.E) X
	;;^DD(353.1,.01,1,0)
	;;=^.1
	;;^DD(353.1,.01,1,1,0)
	;;=353.1^B
	;;^DD(353.1,.01,1,1,1)
	;;=S ^IBE(353.1,"B",$E(X,1,30),DA)=""
	;;^DD(353.1,.01,1,1,2)
	;;=K ^IBE(353.1,"B",$E(X,1,30),DA)
	;;^DD(353.1,.01,3)
	;;=Answer must be 1-7 characters in length.
	;;^DD(353.1,.01,21,0)
	;;=^^2^2^2920427^^^
	;;^DD(353.1,.01,21,1,0)
	;;=This is the code identifing the Place of Service associated
	;;^DD(353.1,.01,21,2,0)
	;;=with a visit.  Printed on the HCFA 1500.
	;;^DD(353.1,.01,"DT")
	;;=2920427
	;;^DD(353.1,.02,0)
	;;=NAME^RF^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>50!($L(X)<3) X
	;;^DD(353.1,.02,1,0)
	;;=^.1
	;;^DD(353.1,.02,1,1,0)
	;;=353.1^C
	;;^DD(353.1,.02,1,1,1)
	;;=S ^IBE(353.1,"C",$E(X,1,30),DA)=""
	;;^DD(353.1,.02,1,1,2)
	;;=K ^IBE(353.1,"C",$E(X,1,30),DA)
	;;^DD(353.1,.02,1,1,3)
	;;=DO NOT DELETE
	;;^DD(353.1,.02,1,1,"DT")
	;;=2920630
	;;^DD(353.1,.02,3)
	;;=Answer must be 3-50 characters in length.
	;;^DD(353.1,.02,21,0)
	;;=^^1^1^2920429^^^^
	;;^DD(353.1,.02,21,1,0)
	;;=This is the full name/description of this code.
	;;^DD(353.1,.02,"DT")
	;;=2920630
	;;^DD(353.1,.03,0)
	;;=ABBREVIATION^RF^^0;3^K:$L(X)>20!($L(X)<2) X
	;;^DD(353.1,.03,3)
	;;=Answer must be 2-20 characters in length.
	;;^DD(353.1,.03,21,0)
	;;=^^2^2^2920427^
	;;^DD(353.1,.03,21,1,0)
	;;=This is the abbreviation of the name of this entry.  This will most often
	;;^DD(353.1,.03,21,2,0)
	;;=be used for printing on reports.
	;;^DD(353.1,.03,"DT")
	;;=2920427

IBINI0B0	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(399.1,0,"GL")
	;;=^DGCR(399.1,
	;;^DIC("B","MCCR UTILITY",399.1)
	;;=
	;;^DIC(399.1,"%D",0)
	;;=^^5^5^2940215^^^^
	;;^DIC(399.1,"%D",1,0)
	;;=This file contains all of the Occurrence Codes, Discharge Bedsections,
	;;^DIC(399.1,"%D",2,0)
	;;=Discharge Statuses and Value Codes which may be used on the Third Party
	;;^DIC(399.1,"%D",3,0)
	;;=claim forms.
	;;^DIC(399.1,"%D",4,0)
	;;= 
	;;^DIC(399.1,"%D",5,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(399.1,0)
	;;=FIELD^^.19^13
	;;^DD(399.1,0,"DDA")
	;;=N
	;;^DD(399.1,0,"DT")
	;;=2940103
	;;^DD(399.1,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(399.1,0,"IX","AC",399.1,.14)
	;;=
	;;^DD(399.1,0,"IX","B",399.1,.01)
	;;=
	;;^DD(399.1,0,"IX","C",399.1,.02)
	;;=
	;;^DD(399.1,0,"IX","C1",399.1,.02)
	;;=
	;;^DD(399.1,0,"IX","D",399.1,.03)
	;;=
	;;^DD(399.1,0,"NM","MCCR UTILITY")
	;;=
	;;^DD(399.1,0,"PT",42.4,5)
	;;=
	;;^DD(399.1,0,"PT",399,161)
	;;=
	;;^DD(399.1,0,"PT",399,162)
	;;=
	;;^DD(399.1,0,"PT",399.041,.01)
	;;=
	;;^DD(399.1,0,"PT",399.042,.05)
	;;=
	;;^DD(399.1,0,"PT",399.047,.01)
	;;=
	;;^DD(399.1,0,"PT",399.5,.02)
	;;=
	;;^DD(399.1,0,"PT",11500.61,.01)
	;;=
	;;^DD(399.1,0,"PT",11000001.041,.01)
	;;=
	;;^DD(399.1,.001,0)
	;;=NUMBER^NJ3,0^^ ^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(399.1,.001,3)
	;;=Enter the internal file number of this entry.
	;;^DD(399.1,.001,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.001,21,1,0)
	;;=This is the internal file number of this entry.
	;;^DD(399.1,.001,"DT")
	;;=2880606
	;;^DD(399.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>60!($L(X)<3)!'(X'?1P.E) X
	;;^DD(399.1,.01,1,0)
	;;=^.1
	;;^DD(399.1,.01,1,1,0)
	;;=399.1^B
	;;^DD(399.1,.01,1,1,1)
	;;=S ^DGCR(399.1,"B",$E(X,1,30),DA)=""
	;;^DD(399.1,.01,1,1,2)
	;;=K ^DGCR(399.1,"B",$E(X,1,30),DA)
	;;^DD(399.1,.01,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(399.1,.01,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.01,21,1,0)
	;;=This is the full name/description of this entry.
	;;^DD(399.1,.01,"DT")
	;;=2920430
	;;^DD(399.1,.02,0)
	;;=CODE^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>3!($L(X)<1) X
	;;^DD(399.1,.02,1,0)
	;;=^.1
	;;^DD(399.1,.02,1,1,0)
	;;=399.1^C
	;;^DD(399.1,.02,1,1,1)
	;;=S ^DGCR(399.1,"C",$E(X,1,30),DA)=""
	;;^DD(399.1,.02,1,1,2)
	;;=K ^DGCR(399.1,"C",$E(X,1,30),DA)
	;;^DD(399.1,.02,1,2,0)
	;;=399.1^C1^MUMPS
	;;^DD(399.1,.02,1,2,1)
	;;=I +X S ^DGCR(399.1,"C1",+X,DA)=""
	;;^DD(399.1,.02,1,2,2)
	;;=K ^DGCR(399.1,"C1",+X,DA)
	;;^DD(399.1,.02,1,2,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.1,.02,1,2,"%D",1,0)
	;;=Cross reference of the codes that identify the entries.
	;;^DD(399.1,.02,3)
	;;=Enter code or number which corresponds to this entry.
	;;^DD(399.1,.02,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.02,21,1,0)
	;;=This identifies the code or number associated with this entry.
	;;^DD(399.1,.02,"DT")
	;;=2880831
	;;^DD(399.1,.03,0)
	;;=ABBREVIATION^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>20!($L(X)<2) X
	;;^DD(399.1,.03,1,0)
	;;=^.1
	;;^DD(399.1,.03,1,1,0)
	;;=399.1^D
	;;^DD(399.1,.03,1,1,1)
	;;=S ^DGCR(399.1,"D",$E(X,1,30),DA)=""
	;;^DD(399.1,.03,1,1,2)
	;;=K ^DGCR(399.1,"D",$E(X,1,30),DA)
	;;^DD(399.1,.03,3)
	;;=Enter the 2-20 character abbreviation (if any) of the name of this entry.
	;;^DD(399.1,.03,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.03,21,1,0)
	;;=This is the abbreviation (if any) of the name of this entry.
	;;^DD(399.1,.11,0)
	;;=OCCURRENCE CODE^S^1:YES;0:NO;^0;4^Q
	;;^DD(399.1,.11,3)
	;;=Enter the code which indicates whether or not this is an Occurrence Code.
	;;^DD(399.1,.11,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.1,.11,21,1,0)
	;;=This indicates whether or not this entry is an Occurrence Code.

IBINI0BU	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(399.4,0,"GL")
	;;=^DGCR(399.4,
	;;^DIC("B","MCCR INCONSISTENT DATA ELEMENTS",399.4)
	;;=
	;;^DIC(399.4,"%D",0)
	;;=^^6^6^2940215^^^
	;;^DIC(399.4,"%D",1,0)
	;;=This file contains a list of all possible reasons why a bill may be
	;;^DIC(399.4,"%D",2,0)
	;;=disapproved during the review phase of the billing process. Each
	;;^DIC(399.4,"%D",3,0)
	;;=element in this file corresponds directly to a form locator on the
	;;^DIC(399.4,"%D",4,0)
	;;=UB-82 form.
	;;^DIC(399.4,"%D",5,0)
	;;= 
	;;^DIC(399.4,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(399.4,0)
	;;=FIELD^^.01^2
	;;^DD(399.4,0,"DDA")
	;;=N
	;;^DD(399.4,0,"IX","B",399.4,.01)
	;;=
	;;^DD(399.4,0,"IX","C",399.4,.01)
	;;=
	;;^DD(399.4,0,"NM","MCCR INCONSISTENT DATA ELEMENTS")
	;;=
	;;^DD(399.4,0,"PT",399.044,.01)
	;;=
	;;^DD(399.4,0,"PT",399.045,.01)
	;;=
	;;^DD(399.4,.001,0)
	;;=NUMBER^NJ3,0^^ ^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(399.4,.001,3)
	;;=Enter form locator number which corresponds to this entry on the UB-82 form.
	;;^DD(399.4,.001,21,0)
	;;=^^2^2^2880901^
	;;^DD(399.4,.001,21,1,0)
	;;=This number corresponds to the form locator number of this entry on the
	;;^DD(399.4,.001,21,2,0)
	;;=UB-82 form.
	;;^DD(399.4,.01,0)
	;;=NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>55!($L(X)<3)!'(X'?1P.E) X
	;;^DD(399.4,.01,1,0)
	;;=^.1
	;;^DD(399.4,.01,1,1,0)
	;;=399.4^B
	;;^DD(399.4,.01,1,1,1)
	;;=S ^DGCR(399.4,"B",$E(X,1,30),DA)=""
	;;^DD(399.4,.01,1,1,2)
	;;=K ^DGCR(399.4,"B",$E(X,1,30),DA)
	;;^DD(399.4,.01,1,2,0)
	;;=399.4^C^KWIC
	;;^DD(399.4,.01,1,2,1)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?! '-/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2,^DD("KWIC")'[I S ^DGCR(399.4,"C",I,DA)=""
	;;^DD(399.4,.01,1,2,2)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?! '-/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2 K ^DGCR(399.4,"C",I,DA)
	;;^DD(399.4,.01,3)
	;;=Enter the 3-55 character reason for disapproval.
	;;^DD(399.4,.01,21,0)
	;;=^^2^2^2880901^
	;;^DD(399.4,.01,21,1,0)
	;;=This defines a reason why a bill may be disapproved during the review phase
	;;^DD(399.4,.01,21,2,0)
	;;=of the billing process.

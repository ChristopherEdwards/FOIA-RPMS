IBINI0B6	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.2,2,1,1,2)
	;;=K ^DGCR(399.2,"AC",DA)
	;;^DD(399.2,2,1,1,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.2,2,1,1,"%D",1,0)
	;;=Cross reference of all active revenue codes.
	;;^DD(399.2,2,1,2,0)
	;;=399.2^D1^MUMPS
	;;^DD(399.2,2,1,2,1)
	;;=S Z1=+X,Z=$P(^DGCR(399.2,DA,0),"^",1) X ^DD(399.2,2,9.3)
	;;^DD(399.2,2,1,2,2)
	;;=S Z1=+X,Z=$P(^DGCR(399.2,DA,0),"^",1) X ^DD(399.2,2,9.4)
	;;^DD(399.2,2,3)
	;;=Enter 'A' or '1' if you want to activate this code for usage. 'I' or '0' if you want this code to remain inactive.
	;;^DD(399.2,2,9.3)
	;;=S:Z1 ^DGCR(399.2,"D",Z,DA)="" K Z,Z1
	;;^DD(399.2,2,9.4)
	;;=K ^DGCR(399.2,"D",Z,DA),Z,Z1
	;;^DD(399.2,2,21,0)
	;;=^^1^1^2931221^^^^
	;;^DD(399.2,2,21,1,0)
	;;=This indicates whether or not this revenue code has been activated for use.
	;;^DD(399.2,2,"DT")
	;;=2931221
	;;^DD(399.2,3,0)
	;;=DESCRIPTION^RFX^^0;4^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>60!($L(X)<2) X
	;;^DD(399.2,3,1,0)
	;;=^.1
	;;^DD(399.2,3,1,1,0)
	;;=399.2^E^KWIC
	;;^DD(399.2,3,1,1,1)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?!'-/&:;)\|*#+`="[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2,^DD("KWIC")'[I S ^DGCR(399.2,"E",I,DA)=""
	;;^DD(399.2,3,1,1,2)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?!'-/&:;)\|*#+`="[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2 K ^DGCR(399.2,"E",I,DA)
	;;^DD(399.2,3,3)
	;;=Enter the 2-60 character description of this revenue code.
	;;^DD(399.2,3,5,1,0)
	;;=399.2^1^2
	;;^DD(399.2,3,21,0)
	;;=^^1^1^2931220^^
	;;^DD(399.2,3,21,1,0)
	;;=This is the full length description of this entry.
	;;^DD(399.2,3,"DT")
	;;=2931220
	;;^DD(399.2,4,0)
	;;=ALL INCLUSIVE^SX^0:NO;1:YES;^0;5^K X
	;;^DD(399.2,4,3)
	;;=Enter the code which indicates if this revenue code is an all inclusive rate.
	;;^DD(399.2,4,21,0)
	;;=^^1^1^2880901^
	;;^DD(399.2,4,21,1,0)
	;;=This indicates whether or not this revenue code is an all inclusive rate.
	;;^DD(399.2,4,"DT")
	;;=2880831

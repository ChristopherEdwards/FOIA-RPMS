FHINI0M3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(118,20,21,2,0)
	;;=computed field which obtains the value from the recipe file based
	;;^DD(118,20,21,3,0)
	;;=upon the 'Corresponding Recipe' pointer.
	;;^DD(118,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(118,99,1,0)
	;;=^.1
	;;^DD(118,99,1,1,0)
	;;=118^AD^MUMPS
	;;^DD(118,99,1,1,1)
	;;=K:X'="Y" ^FH(118,DA,"I")
	;;^DD(118,99,1,1,2)
	;;=K ^FH(118,DA,"I")
	;;^DD(118,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(118,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(118,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(118,99,21,0)
	;;=^^2^2^2880717^
	;;^DD(118,99,21,1,0)
	;;=This field, when answered YES, means that further selection of
	;;^DD(118,99,21,2,0)
	;;=this item by dietetic personnel is prohibited.
	;;^DD(118,99,"DT")
	;;=2860813
	;;^DD(118.01,0)
	;;=SYNONYM SUB-FIELD^^.01^1
	;;^DD(118.01,0,"IX","B",118.01,.01)
	;;=
	;;^DD(118.01,0,"NM","SYNONYM")
	;;=
	;;^DD(118.01,0,"UP")
	;;=118
	;;^DD(118.01,.01,0)
	;;=SYNONYM^MF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(118.01,.01,1,0)
	;;=^.1
	;;^DD(118.01,.01,1,1,0)
	;;=118.01^B
	;;^DD(118.01,.01,1,1,1)
	;;=S ^FH(118,DA(1),"S","B",$E(X,1,30),DA)=""
	;;^DD(118.01,.01,1,1,2)
	;;=K ^FH(118,DA(1),"S","B",$E(X,1,30),DA)
	;;^DD(118.01,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(118.01,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the SYNONYM field.
	;;^DD(118.01,.01,1,2,0)
	;;=118^B^MNEMONIC
	;;^DD(118.01,.01,1,2,1)
	;;=S:'$D(^FH(118,"B",$E(X,1,30),DA(1),DA)) ^(DA)=1
	;;^DD(118.01,.01,1,2,2)
	;;=I $D(^FH(118,"B",$E(X,1,30),DA(1),DA)),^(DA) K ^(DA)
	;;^DD(118.01,.01,1,2,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(118.01,.01,1,2,"%D",1,0)
	;;=This is the normal B cross-reference of the SYNONYM field.
	;;^DD(118.01,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(118.01,.01,21,0)
	;;=^^1^1^2901217^
	;;^DD(118.01,.01,21,1,0)
	;;=This field contains a synonym for the supplemental feeding.
	;;^DD(118.01,.01,"DT")
	;;=2900918

FHINI0MA	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(118.2,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(118.2,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(118.2,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(118.2,99,21,0)
	;;=^^2^2^2920818^^
	;;^DD(118.2,99,21,1,0)
	;;=This field, if answered YES, prohibits further selection of
	;;^DD(118.2,99,21,2,0)
	;;=this item by ward or dietetic personnel.
	;;^DD(118.2,99,"DT")
	;;=2860813
	;;^DD(118.21,0)
	;;=SYNONYM SUB-FIELD^NL^.01^1
	;;^DD(118.21,0,"NM","SYNONYM")
	;;=
	;;^DD(118.21,0,"UP")
	;;=118.2
	;;^DD(118.21,.01,0)
	;;=SYNONYM^MF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<1) X
	;;^DD(118.21,.01,1,0)
	;;=^.1
	;;^DD(118.21,.01,1,1,0)
	;;=118.2^C
	;;^DD(118.21,.01,1,1,1)
	;;=S ^FH(118.2,"C",$E(X,1,30),DA(1),DA)=""
	;;^DD(118.21,.01,1,1,2)
	;;=K ^FH(118.2,"C",$E(X,1,30),DA(1),DA)
	;;^DD(118.21,.01,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(118.21,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(118.21,.01,21,1,0)
	;;=This field contains an alternate name or synonym for the
	;;^DD(118.21,.01,21,2,0)
	;;=tubefeeding product.
	;;^DD(118.21,.01,"DT")
	;;=2850709

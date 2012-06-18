IBDEI00K	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.3,.05,1,0)
	;;=^.1
	;;^DD(358.3,.05,1,1,0)
	;;=358.3^APO2^MUMPS
	;;^DD(358.3,.05,1,1,1)
	;;=I $P(^IBE(358.3,DA,0),U,3),$P(^(0),U,4) S ^IBE(358.3,"APO",$P(^(0),U,3),$P(^(0),U,4),X,DA)=""
	;;^DD(358.3,.05,1,1,2)
	;;=I $P(^IBE(358.3,DA,0),U,3),$P(^(0),U,4) K ^IBE(358.3,"APO",$P(^(0),U,3),$P(^(0),U,4),X,DA)
	;;^DD(358.3,.05,1,1,"DT")
	;;=2921222
	;;^DD(358.3,.05,3)
	;;=Type a Number between 0 and 999.99, 2 Decimal Digits
	;;^DD(358.3,.05,21,0)
	;;=^^2^2^2921229^^^^
	;;^DD(358.3,.05,21,1,0)
	;;=Determines the order that this selection entry will appear in under the
	;;^DD(358.3,.05,21,2,0)
	;;=header for the selection group.
	;;^DD(358.3,.05,"DT")
	;;=2921229
	;;^DD(358.3,1,0)
	;;=SUBCOLUMN VALUE^358.31IA^^1;0
	;;^DD(358.3,1,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.3,1,21,1,0)
	;;= 
	;;^DD(358.3,1,21,2,0)
	;;=The selection can be composed of multiple fields. Each field occupies its
	;;^DD(358.3,1,21,3,0)
	;;=own subcolumn on the form.
	;;^DD(358.31,0)
	;;=SUBCOLUMN VALUE SUB-FIELD^^.02^2
	;;^DD(358.31,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(358.31,0,"IX","B",358.31,.01)
	;;=
	;;^DD(358.31,0,"NM","SUBCOLUMN VALUE")
	;;=
	;;^DD(358.31,0,"UP")
	;;=358.3
	;;^DD(358.31,.01,0)
	;;=SUBCOLUMN NUMBER^MRNJ1,0X^^0;1^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N)!($D(^IBE(358.3,DA(1),1,"B",X))) X
	;;^DD(358.31,.01,1,0)
	;;=^.1
	;;^DD(358.31,.01,1,1,0)
	;;=358.31^B
	;;^DD(358.31,.01,1,1,1)
	;;=S ^IBE(358.3,DA(1),1,"B",$E(X,1,30),DA)=""
	;;^DD(358.31,.01,1,1,2)
	;;=K ^IBE(358.3,DA(1),1,"B",$E(X,1,30),DA)
	;;^DD(358.31,.01,3)
	;;=Which subcolumn is the value for?
	;;^DD(358.31,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.31,.01,21,1,0)
	;;= 
	;;^DD(358.31,.01,21,2,0)
	;;=The order that the subcolumn should appear on the form.
	;;^DD(358.31,.01,"DT")
	;;=2930402
	;;^DD(358.31,.02,0)
	;;=SUBCOLUMN VALUE^F^^0;2^K:$L(X)>150!($L(X)<1) X
	;;^DD(358.31,.02,3)
	;;=What value should go in the subcolumn?
	;;^DD(358.31,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.31,.02,21,1,0)
	;;= 
	;;^DD(358.31,.02,21,2,0)
	;;=The text that should appear in the subcolumn.
	;;^DD(358.31,.02,"DT")
	;;=2930401

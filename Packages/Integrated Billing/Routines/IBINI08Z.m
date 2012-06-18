IBINI08Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.21,.04,21,3,0)
	;;=supplied the column will extend to the bottom of the block.
	;;^DD(358.21,.04,"DT")
	;;=2930802
	;;^DD(358.22,0)
	;;=SUBCOLUMN NUMBER SUB-FIELD^^.07^7
	;;^DD(358.22,0,"ID","WRITE")
	;;=D ID1^IBDFU5
	;;^DD(358.22,0,"IX","B",358.22,.01)
	;;=
	;;^DD(358.22,0,"NM","SUBCOLUMN NUMBER")
	;;=
	;;^DD(358.22,0,"UP")
	;;=358.2
	;;^DD(358.22,.01,0)
	;;=SUBCOLUMN NUMBER^MRNJ1,0X^^0;1^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N)!($D(^IBE(358.2,DA(1),2,"B",X))) X
	;;^DD(358.22,.01,.1)
	;;=Number of the subcolumn, subcolumns being numbered 1-6, left-to-right
	;;^DD(358.22,.01,1,0)
	;;=^.1
	;;^DD(358.22,.01,1,1,0)
	;;=358.22^B
	;;^DD(358.22,.01,1,1,1)
	;;=S ^IBE(358.2,DA(1),2,"B",$E(X,1,30),DA)=""
	;;^DD(358.22,.01,1,1,2)
	;;=K ^IBE(358.2,DA(1),2,"B",$E(X,1,30),DA)
	;;^DD(358.22,.01,3)
	;;=The SUBCOLUMN NUMBER determines the order in which the subcolumns will display. There are at most 6 subcolumns, numbered 1-6.
	;;^DD(358.22,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.22,.01,21,1,0)
	;;= 
	;;^DD(358.22,.01,21,2,0)
	;;=The order that the subcolumn will appear on the form.
	;;^DD(358.22,.01,"DT")
	;;=2930413
	;;^DD(358.22,.02,0)
	;;=SUBCOLUMN HEADER^F^^0;2^K:$L(X)>150!($L(X)<1) X
	;;^DD(358.22,.02,.1)
	;;=WHAT TEXT SHOULD APPEAR AT THE TOP OF THE SUBCOLUMN?
	;;^DD(358.22,.02,3)
	;;=What text should appear at the top of the subcolumn?
	;;^DD(358.22,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.22,.02,21,1,0)
	;;= 
	;;^DD(358.22,.02,21,2,0)
	;;=The text that will appear at the top of the subcolumn.
	;;^DD(358.22,.02,"DT")
	;;=2930414
	;;^DD(358.22,.03,0)
	;;=SUBCOLUMN WIDTH^NJ3,0^^0;3^K:+X'=X!(X>150)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.22,.03,.1)
	;;=HOW WIDE SHOULD THE SUBCOLUMN BE?
	;;^DD(358.22,.03,3)
	;;=How wide should the subcolumn be?
	;;^DD(358.22,.03,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.22,.03,21,1,0)
	;;= 
	;;^DD(358.22,.03,21,2,0)
	;;=The width of the subcolumn. If the subcolumn contains a MARKING AREA then
	;;^DD(358.22,.03,21,3,0)
	;;=the width of the MARKING AREA overrides what ever this is.
	;;^DD(358.22,.03,"DT")
	;;=2930414
	;;^DD(358.22,.04,0)
	;;=TYPE OF SUBCOLUMN^RS^1:TEXT;2:MARKING;^0;4^Q
	;;^DD(358.22,.04,.1)
	;;=SUBCOLUMN CONTAINS TEXT, OR FOR MARKING? (TEXT/MARKING)
	;;^DD(358.22,.04,3)
	;;=Enter '1' if the subcolumn will contain text, '2' if it will be for the user to mark his selections.
	;;^DD(358.22,.04,21,0)
	;;=^^4^4^2930527^
	;;^DD(358.22,.04,21,1,0)
	;;= 
	;;^DD(358.22,.04,21,2,0)
	;;=The subcolumn can contain either text, derived from what is returned by
	;;^DD(358.22,.04,21,3,0)
	;;=the PACKAGE INTERFACE, or a MARKING AREA, which is meant to be written in
	;;^DD(358.22,.04,21,4,0)
	;;=to select an entry on the list.
	;;^DD(358.22,.04,"DT")
	;;=2930428
	;;^DD(358.22,.05,0)
	;;=SUBCOLUMN'S DATA^NJ1,0X^^0;5^K:+X'=X!(X>7)!(X<1)!(X?.E1"."1N.N)!($P($G(^IBE(358.6,+$P($G(^IBE(358.2,DA(1),0)),U,11),2)),U,(2*X)-1)="")!((X=1)&'$P($G(^IBE(358.6,+$P($G(^IBE(358.2,DA(1),0)),U,11),2)),U,17)) X
	;;^DD(358.22,.05,.1)
	;;=WHAT DATA SHOULD BE CONTAINED IN THE SUBCOLUMN?
	;;^DD(358.22,.05,3)
	;;=WHAT DATA SHOULD BE CONTAINED IN THE SUBCOLUMN?
	;;^DD(358.22,.05,4)
	;;=D HELP2^IBDFU5
	;;^DD(358.22,.05,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.22,.05,21,1,0)
	;;= 
	;;^DD(358.22,.05,21,2,0)
	;;=The Package Interface returns a record, which is composed of fields. This
	;;^DD(358.22,.05,21,3,0)
	;;=identifies which field goes in the subcolumn.
	;;^DD(358.22,.05,"DT")
	;;=2930810
	;;^DD(358.22,.06,0)
	;;=MARKING AREA^P358.91'^IBE(358.91,^0;6^Q
	;;^DD(358.22,.06,.1)
	;;=TYPE OF MARKING AREA

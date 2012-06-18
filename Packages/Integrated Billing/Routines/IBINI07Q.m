IBINI07Q	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.21,.03,"DT")
	;;=2930930
	;;^DD(357.21,.04,0)
	;;=LIST COLUMN HEIGHT^NJ3,0^^0;4^K:+X'=X!(X>200)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.21,.04,.1)
	;;=HOW MANY LINES HIGH SHOULD THE LIST COLUMN BE? (OPTIONAL)
	;;^DD(357.21,.04,3)
	;;=How many lines should the column cover?
	;;^DD(357.21,.04,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.21,.04,21,1,0)
	;;= 
	;;^DD(357.21,.04,21,2,0)
	;;=The number of lines the column should occupy. This is optional - if not
	;;^DD(357.21,.04,21,3,0)
	;;=supplied the column will extend to the bottom of the block.
	;;^DD(357.21,.04,"DT")
	;;=2930802
	;;^DD(357.22,0)
	;;=SUBCOLUMN NUMBER SUB-FIELD^^.07^7
	;;^DD(357.22,0,"DIK")
	;;=IBXF2
	;;^DD(357.22,0,"DT")
	;;=2930413
	;;^DD(357.22,0,"ID","WRITE")
	;;=D ID1^IBDFU5
	;;^DD(357.22,0,"IX","B",357.22,.01)
	;;=
	;;^DD(357.22,0,"NM","SUBCOLUMN NUMBER")
	;;=
	;;^DD(357.22,0,"UP")
	;;=357.2
	;;^DD(357.22,.01,0)
	;;=SUBCOLUMN NUMBER^MRNJ1,0X^^0;1^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N)!($D(^IBE(357.2,DA(1),2,"B",X))) X
	;;^DD(357.22,.01,.1)
	;;=Number of the subcolumn, subcolumns being numbered 1-6, left-to-right
	;;^DD(357.22,.01,1,0)
	;;=^.1
	;;^DD(357.22,.01,1,1,0)
	;;=357.22^B
	;;^DD(357.22,.01,1,1,1)
	;;=S ^IBE(357.2,DA(1),2,"B",$E(X,1,30),DA)=""
	;;^DD(357.22,.01,1,1,2)
	;;=K ^IBE(357.2,DA(1),2,"B",$E(X,1,30),DA)
	;;^DD(357.22,.01,3)
	;;=The SUBCOLUMN NUMBER determines the order in which the subcolumns will display. There are at most 6 subcolumns, numbered 1-6.
	;;^DD(357.22,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.22,.01,21,1,0)
	;;= 
	;;^DD(357.22,.01,21,2,0)
	;;=The order that the subcolumn will appear on the form.
	;;^DD(357.22,.01,"DT")
	;;=2930413
	;;^DD(357.22,.02,0)
	;;=SUBCOLUMN HEADER^F^^0;2^K:$L(X)>150!($L(X)<1) X
	;;^DD(357.22,.02,.1)
	;;=WHAT TEXT SHOULD APPEAR AT THE TOP OF THE SUBCOLUMN?
	;;^DD(357.22,.02,3)
	;;=What text should appear at the top of the subcolumn?
	;;^DD(357.22,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.22,.02,21,1,0)
	;;= 
	;;^DD(357.22,.02,21,2,0)
	;;=The text that will appear at the top of the subcolumn.
	;;^DD(357.22,.02,"DT")
	;;=2930414
	;;^DD(357.22,.03,0)
	;;=SUBCOLUMN WIDTH^NJ3,0^^0;3^K:+X'=X!(X>150)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.22,.03,.1)
	;;=HOW WIDE SHOULD THE SUBCOLUMN BE?
	;;^DD(357.22,.03,3)
	;;=How wide should the subcolumn be?
	;;^DD(357.22,.03,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.22,.03,21,1,0)
	;;= 
	;;^DD(357.22,.03,21,2,0)
	;;=The width of the subcolumn. If the subcolumn contains a MARKING AREA then
	;;^DD(357.22,.03,21,3,0)
	;;=the width of the MARKING AREA overrides what ever this is.
	;;^DD(357.22,.03,"DT")
	;;=2930414
	;;^DD(357.22,.04,0)
	;;=TYPE OF SUBCOLUMN^RS^1:TEXT;2:MARKING;^0;4^Q
	;;^DD(357.22,.04,.1)
	;;=SUBCOLUMN CONTAINS TEXT, OR FOR MARKING? (TEXT/MARKING)
	;;^DD(357.22,.04,3)
	;;=Enter '1' if the subcolumn will contain text, '2' if it will be for the user to mark his selections.
	;;^DD(357.22,.04,21,0)
	;;=^^4^4^2930527^
	;;^DD(357.22,.04,21,1,0)
	;;= 
	;;^DD(357.22,.04,21,2,0)
	;;=The subcolumn can contain either text, derived from what is returned by
	;;^DD(357.22,.04,21,3,0)
	;;=the PACKAGE INTERFACE, or a MARKING AREA, which is meant to be written in
	;;^DD(357.22,.04,21,4,0)
	;;=to select an entry on the list.
	;;^DD(357.22,.04,"DT")
	;;=2930428
	;;^DD(357.22,.05,0)
	;;=SUBCOLUMN'S DATA^NJ1,0X^^0;5^K:+X'=X!(X>7)!(X<1)!(X?.E1"."1N.N)!($P($G(^IBE(357.6,+$P($G(^IBE(357.2,DA(1),0)),U,11),2)),U,(2*X)-1)="")!((X=1)&'$P($G(^IBE(357.6,+$P($G(^IBE(357.2,DA(1),0)),U,11),2)),U,17)) X
	;;^DD(357.22,.05,.1)
	;;=WHAT DATA SHOULD BE CONTAINED IN THE SUBCOLUMN?

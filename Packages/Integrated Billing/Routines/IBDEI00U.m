IBDEI00U	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.52,.05,3)
	;;=What block row should the label start in?
	;;^DD(358.52,.05,21,0)
	;;=^^2^2^2930608^
	;;^DD(358.52,.05,21,1,0)
	;;= 
	;;^DD(358.52,.05,21,2,0)
	;;=The row the label should be printed on.
	;;^DD(358.52,.05,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.52,.05,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.52,.05,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.52,.05,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.52,.05,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.52,.05,"DT")
	;;=2930617
	;;^DD(358.52,.06,0)
	;;=STARTING ROW FOR DATA^NJ3,0XO^^0;6^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.52,.06,2)
	;;=S Y(0)=Y S:Y=+Y Y=Y+1
	;;^DD(358.52,.06,2.1)
	;;=S:Y=+Y Y=Y+1
	;;^DD(358.52,.06,3)
	;;=What block row should the data begin in?
	;;^DD(358.52,.06,21,0)
	;;=^^2^2^2930715^^
	;;^DD(358.52,.06,21,1,0)
	;;= 
	;;^DD(358.52,.06,21,2,0)
	;;=The row, relative to the block, that the data should print on.
	;;^DD(358.52,.06,23,0)
	;;=^^4^4^2930715^^
	;;^DD(358.52,.06,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.52,.06,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.52,.06,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.52,.06,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.52,.06,"DT")
	;;=2930617
	;;^DD(358.52,.07,0)
	;;=STARTING COLUMN FOR DATA^NJ3,0XO^^0;7^S:+X=X X=X-1 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.52,.07,2)
	;;=S Y(0)=Y S:Y=+Y Y=Y+1
	;;^DD(358.52,.07,2.1)
	;;=S:Y=+Y Y=Y+1
	;;^DD(358.52,.07,3)
	;;=What block column should the data begin in?
	;;^DD(358.52,.07,21,0)
	;;=^^2^2^2930608^
	;;^DD(358.52,.07,21,1,0)
	;;= 
	;;^DD(358.52,.07,21,2,0)
	;;=The column, relative to the block, that the data should print on.
	;;^DD(358.52,.07,23,0)
	;;=^^4^4^2930715^
	;;^DD(358.52,.07,23,1,0)
	;;=The internal representation starts at 0, the external representation
	;;^DD(358.52,.07,23,2,0)
	;;=starts at 1. The difference is because for computing the form image
	;;^DD(358.52,.07,23,3,0)
	;;=it is convenient to work with displacements from the top left-hand
	;;^DD(358.52,.07,23,4,0)
	;;=corner. However, users do not want to work with row=0 or column=0.
	;;^DD(358.52,.07,"DT")
	;;=2930617
	;;^DD(358.52,.08,0)
	;;=LENGTH OF DATA^NJ3,0^^0;8^K:+X'=X!(X>150)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.52,.08,3)
	;;=How much space on the line should be allocated for the information to be displayed?
	;;^DD(358.52,.08,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.52,.08,21,1,0)
	;;= 
	;;^DD(358.52,.08,21,2,0)
	;;=The amount of space, in terms of characters, that should be allocated
	;;^DD(358.52,.08,21,3,0)
	;;=to the data.
	;;^DD(358.52,.08,"DT")
	;;=2930322
	;;^DD(358.52,.09,0)
	;;=DATA^NJ1,0X^^0;9^K:+X'=X!(X>7)!(X<1)!(X?.E1"."1N.N)!($P($G(^IBE(358.6,+$P($G(^IBE(358.5,DA(1),0)),U,3),2)),U,(2*X)-1)="") X
	;;^DD(358.52,.09,.1)
	;;=WHAT DATA SHOULD BE DISPLAYED IN THIS SUBFIELD?
	;;^DD(358.52,.09,3)
	;;=WHAT DATA SHOULD BE DISPLAYED IN THIS SUBFIELD?
	;;^DD(358.52,.09,4)
	;;=D HELP1^IBDFU5
	;;^DD(358.52,.09,21,0)
	;;=^^4^4^2930527^
	;;^DD(358.52,.09,21,1,0)
	;;= 
	;;^DD(358.52,.09,21,2,0)
	;;=The package interface returns a record that may be composed of multiple
	;;^DD(358.52,.09,21,3,0)
	;;=fields. This identifies which of those fields should appear in this

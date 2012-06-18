IBINI081	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.52,.09,.1)
	;;=WHAT DATA SHOULD BE DISPLAYED IN THIS SUBFIELD?
	;;^DD(357.52,.09,3)
	;;=WHAT DATA SHOULD BE DISPLAYED IN THIS SUBFIELD?
	;;^DD(357.52,.09,4)
	;;=D HELP1^IBDFU5
	;;^DD(357.52,.09,21,0)
	;;=^^4^4^2930527^
	;;^DD(357.52,.09,21,1,0)
	;;= 
	;;^DD(357.52,.09,21,2,0)
	;;=The package interface returns a record that may be composed of multiple
	;;^DD(357.52,.09,21,3,0)
	;;=fields. This identifies which of those fields should appear in this
	;;^DD(357.52,.09,21,4,0)
	;;=subfield.
	;;^DD(357.52,.09,"DT")
	;;=2930526

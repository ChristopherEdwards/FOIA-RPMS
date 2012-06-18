IBDEI00F	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.22,.06,3)
	;;=What type of marking area should appear in the subcolumn?
	;;^DD(358.22,.06,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.22,.06,21,1,0)
	;;= 
	;;^DD(358.22,.06,21,2,0)
	;;=This identifies which MARKING AREA should go in the subcolumn.
	;;^DD(358.22,.06,"DT")
	;;=2930414
	;;^DD(358.22,.07,0)
	;;=ALLOW EDITING OF TEXT?^S^0:NO;1:YES;^0;7^Q
	;;^DD(358.22,.07,.1)
	;;=ALLOW EDITING OF THE TEXT APPEARING IN THIS SUBCOLUMN? (YES/NO)
	;;^DD(358.22,.07,3)
	;;=Is it okey to edit the text appearing in this subcolumn?
	;;^DD(358.22,.07,21,0)
	;;=^^4^4^2930527^
	;;^DD(358.22,.07,21,1,0)
	;;= 
	;;^DD(358.22,.07,21,2,0)
	;;=This determines whether or not the user, when selecting items to appear on
	;;^DD(358.22,.07,21,3,0)
	;;=the list, will be able to edit the text appearing in the subcolum. This is
	;;^DD(358.22,.07,21,4,0)
	;;=ignored if the subcolumn contains a MARKING AREA.
	;;^DD(358.22,.07,"DT")
	;;=2930428

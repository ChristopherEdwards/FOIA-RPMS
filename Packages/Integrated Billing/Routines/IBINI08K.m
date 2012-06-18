IBINI08K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.7,.05,3)
	;;=How long should the line be?
	;;^DD(357.7,.05,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.7,.05,21,1,0)
	;;= 
	;;^DD(357.7,.05,21,2,0)
	;;=The length of the line. For horizontal lines the length is in terms of
	;;^DD(357.7,.05,21,3,0)
	;;=characters. For vertical lines it is in terms of rows.
	;;^DD(357.7,.05,"DT")
	;;=2930319
	;;^DD(357.7,.06,0)
	;;=BLOCK^RP357.1'^IBE(357.1,^0;6^Q
	;;^DD(357.7,.06,1,0)
	;;=^.1
	;;^DD(357.7,.06,1,1,0)
	;;=357.7^C
	;;^DD(357.7,.06,1,1,1)
	;;=S ^IBE(357.7,"C",$E(X,1,30),DA)=""
	;;^DD(357.7,.06,1,1,2)
	;;=K ^IBE(357.7,"C",$E(X,1,30),DA)
	;;^DD(357.7,.06,1,1,"%D",0)
	;;=^^2^2^2930319^
	;;^DD(357.7,.06,1,1,"%D",1,0)
	;;= 
	;;^DD(357.7,.06,1,1,"%D",2,0)
	;;=This cross-reference is used to find all lines belonging to a block.
	;;^DD(357.7,.06,1,1,"DT")
	;;=2930319
	;;^DD(357.7,.06,3)
	;;=What block should the line appear in?
	;;^DD(357.7,.06,4)
	;;=W "DOES THIS WORK",!
	;;^DD(357.7,.06,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.7,.06,21,1,0)
	;;= 
	;;^DD(357.7,.06,21,2,0)
	;;=The block the line appears in.
	;;^DD(357.7,.06,"DT")
	;;=2930319

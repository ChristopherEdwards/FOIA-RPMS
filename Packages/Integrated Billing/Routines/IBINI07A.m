IBINI07A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.91)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.91,.03,1,1,"DT")
	;;=2930713
	;;^DD(356.91,.03,1,2,0)
	;;=356.91^APP1^MUMPS
	;;^DD(356.91,.03,1,2,1)
	;;=S:$P(^IBT(356.91,DA,0),U,2) ^IBT(356.91,"APP",$P(^(0),U,2),-X,DA)=""
	;;^DD(356.91,.03,1,2,2)
	;;=K ^IBT(356.91,"APP",+$P(^IBT(356.91,DA,0),U,2),-X,DA)
	;;^DD(356.91,.03,1,2,"%D",0)
	;;=^^1^1^2930713^
	;;^DD(356.91,.03,1,2,"%D",1,0)
	;;=Cross reference of all procedures by  tracking ID and procedure date.
	;;^DD(356.91,.03,1,2,"DT")
	;;=2930713
	;;^DD(356.91,.03,3)
	;;=Dates must be during admission.
	;;^DD(356.91,.03,21,0)
	;;=^^1^1^2930713^^
	;;^DD(356.91,.03,21,1,0)
	;;=This is the date that the procedure was performed.
	;;^DD(356.91,.03,"DT")
	;;=2930902

IBINI08S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358,.11,3)
	;;=How many pages should the encounter form have?
	;;^DD(358,.11,21,0)
	;;=^^1^1^2930602^
	;;^DD(358,.11,21,1,0)
	;;=The encounter form may have multiple pages.
	;;^DD(358,.11,"DT")
	;;=2930602
	;;^DD(358,1,0)
	;;=EXPORT NOTES^358.01^^1;0
	;;^DD(358,1,21,0)
	;;=^^3^3^2930806^
	;;^DD(358,1,21,1,0)
	;;=Used to describe the form to other sites. The form can not be displayed
	;;^DD(358,1,21,2,0)
	;;=until after it is imported. Maybe if they knew more about it they wouldn't
	;;^DD(358,1,21,3,0)
	;;=want to import it! They will be able to read the EXPORT NOTES before importing it.
	;;^DD(358.01,0)
	;;=EXPORT NOTES SUB-FIELD^^.01^1
	;;^DD(358.01,0,"DT")
	;;=2930806
	;;^DD(358.01,0,"NM","EXPORT NOTES")
	;;=
	;;^DD(358.01,0,"UP")
	;;=358
	;;^DD(358.01,.01,0)
	;;=EXPORT NOTES^W^^0;1^Q
	;;^DD(358.01,.01,3)
	;;=What should other sites know about this form before importing it? The other site will not be able to display it until after they import it.
	;;^DD(358.01,.01,"DT")
	;;=2930806

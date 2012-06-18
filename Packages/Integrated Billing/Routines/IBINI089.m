IBINI089	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.6,8.06,"DT")
	;;=2931014
	;;^DD(357.6,8.07,0)
	;;=PIECE 7 NODE^F^^8;7^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.07,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.07,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.07,21,1,0)
	;;=For records you can optionally specify the node to store the field at.
	;;^DD(357.6,8.07,"DT")
	;;=2931014
	;;^DD(357.61,0)
	;;=DESCRIPTION SUB-FIELD^^.01^1
	;;^DD(357.61,0,"DT")
	;;=2921119
	;;^DD(357.61,0,"NM","DESCRIPTION")
	;;=
	;;^DD(357.61,0,"UP")
	;;=357.6
	;;^DD(357.61,.01,0)
	;;=/6^W^^0;1^Q
	;;^DD(357.61,.01,3)
	;;=Enter a description of the data being exchanged.
	;;^DD(357.61,.01,"DT")
	;;=2930210
	;;^DD(357.66,0)
	;;=PROTECTED LOCAL VARIABLES SUB-FIELD^^.01^1
	;;^DD(357.66,0,"DT")
	;;=2930608
	;;^DD(357.66,0,"IX","B",357.66,.01)
	;;=
	;;^DD(357.66,0,"NM","PROTECTED LOCAL VARIABLES")
	;;=
	;;^DD(357.66,0,"UP")
	;;=357.6
	;;^DD(357.66,.01,0)
	;;=PROTECTED LOCAL VARIABLES^MFX^^0;1^K:'$$VARIABLE^IBDFU5(X) X
	;;^DD(357.66,.01,1,0)
	;;=^.1
	;;^DD(357.66,.01,1,1,0)
	;;=357.66^B
	;;^DD(357.66,.01,1,1,1)
	;;=S ^IBE(357.6,DA(1),6,"B",$E(X,1,30),DA)=""
	;;^DD(357.66,.01,1,1,2)
	;;=K ^IBE(357.6,DA(1),6,"B",$E(X,1,30),DA)
	;;^DD(357.66,.01,3)
	;;=Enter variables that should be NEWED before the entry action or calling the interface.
	;;^DD(357.66,.01,21,0)
	;;=^^3^3^2930608^
	;;^DD(357.66,.01,21,1,0)
	;;= 
	;;^DD(357.66,.01,21,2,0)
	;;=A list of variables that should be newed before the entry action or
	;;^DD(357.66,.01,21,3,0)
	;;=calling the interface.
	;;^DD(357.66,.01,"DT")
	;;=2930608
	;;^DD(357.67,0)
	;;=REQUIRED LOCAL VARIABLES SUB-FIELD^^.01^1
	;;^DD(357.67,0,"DT")
	;;=2930521
	;;^DD(357.67,0,"IX","B",357.67,.01)
	;;=
	;;^DD(357.67,0,"NM","REQUIRED LOCAL VARIABLES")
	;;=
	;;^DD(357.67,0,"UP")
	;;=357.6
	;;^DD(357.67,.01,0)
	;;=REQUIRED LOCAL VARIABLE^MFX^^0;1^K:'$$VARIABLE^IBDFU5(X) X
	;;^DD(357.67,.01,1,0)
	;;=^.1
	;;^DD(357.67,.01,1,1,0)
	;;=357.67^B
	;;^DD(357.67,.01,1,1,1)
	;;=S ^IBE(357.6,DA(1),7,"B",$E(X,1,30),DA)=""
	;;^DD(357.67,.01,1,1,2)
	;;=K ^IBE(357.6,DA(1),7,"B",$E(X,1,30),DA)
	;;^DD(357.67,.01,3)
	;;=Enter any variables that must exist before the Package Interface routine is called.
	;;^DD(357.67,.01,21,0)
	;;=^^4^4^2930528^
	;;^DD(357.67,.01,21,1,0)
	;;= 
	;;^DD(357.67,.01,21,2,0)
	;;=A variable that is required input to the interface routine. The interface
	;;^DD(357.67,.01,21,3,0)
	;;=routine will not be called if all of the required variables are not
	;;^DD(357.67,.01,21,4,0)
	;;=defined.
	;;^DD(357.67,.01,"DT")
	;;=2930521

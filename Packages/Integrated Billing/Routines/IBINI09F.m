IBINI09F	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.61,0,"NM","DESCRIPTION")
	;;=
	;;^DD(358.61,0,"UP")
	;;=358.6
	;;^DD(358.61,.01,0)
	;;=/6^W^^0;1^Q
	;;^DD(358.61,.01,3)
	;;=Enter a description of the data being exchanged.
	;;^DD(358.61,.01,"DT")
	;;=2930210
	;;^DD(358.66,0)
	;;=PROTECTED LOCAL VARIABLES SUB-FIELD^^.01^1
	;;^DD(358.66,0,"IX","B",358.66,.01)
	;;=
	;;^DD(358.66,0,"NM","PROTECTED LOCAL VARIABLES")
	;;=
	;;^DD(358.66,0,"UP")
	;;=358.6
	;;^DD(358.66,.01,0)
	;;=PROTECTED LOCAL VARIABLES^MFX^^0;1^K:'$$VARIABLE^IBDFU5(X) X
	;;^DD(358.66,.01,1,0)
	;;=^.1
	;;^DD(358.66,.01,1,1,0)
	;;=358.66^B
	;;^DD(358.66,.01,1,1,1)
	;;=S ^IBE(358.6,DA(1),6,"B",$E(X,1,30),DA)=""
	;;^DD(358.66,.01,1,1,2)
	;;=K ^IBE(358.6,DA(1),6,"B",$E(X,1,30),DA)
	;;^DD(358.66,.01,3)
	;;=Enter variables that should be NEWED before the entry action or calling the interface.
	;;^DD(358.66,.01,21,0)
	;;=^^3^3^2930608^
	;;^DD(358.66,.01,21,1,0)
	;;= 
	;;^DD(358.66,.01,21,2,0)
	;;=A list of variables that should be newed before the entry action or
	;;^DD(358.66,.01,21,3,0)
	;;=calling the interface.
	;;^DD(358.66,.01,"DT")
	;;=2930608
	;;^DD(358.67,0)
	;;=REQUIRED LOCAL VARIABLES SUB-FIELD^^.01^1
	;;^DD(358.67,0,"IX","B",358.67,.01)
	;;=
	;;^DD(358.67,0,"NM","REQUIRED LOCAL VARIABLES")
	;;=
	;;^DD(358.67,0,"UP")
	;;=358.6
	;;^DD(358.67,.01,0)
	;;=REQUIRED LOCAL VARIABLE^MFX^^0;1^K:'$$VARIABLE^IBDFU5(X) X
	;;^DD(358.67,.01,1,0)
	;;=^.1
	;;^DD(358.67,.01,1,1,0)
	;;=358.67^B
	;;^DD(358.67,.01,1,1,1)
	;;=S ^IBE(358.6,DA(1),7,"B",$E(X,1,30),DA)=""
	;;^DD(358.67,.01,1,1,2)
	;;=K ^IBE(358.6,DA(1),7,"B",$E(X,1,30),DA)
	;;^DD(358.67,.01,3)
	;;=Enter any variables that must exist before the Package Interface routine is called.
	;;^DD(358.67,.01,21,0)
	;;=^^4^4^2930528^
	;;^DD(358.67,.01,21,1,0)
	;;= 
	;;^DD(358.67,.01,21,2,0)
	;;=A variable that is required input to the interface routine. The interface
	;;^DD(358.67,.01,21,3,0)
	;;=routine will not be called if all of the required variables are not
	;;^DD(358.67,.01,21,4,0)
	;;=defined.
	;;^DD(358.67,.01,"DT")
	;;=2930521

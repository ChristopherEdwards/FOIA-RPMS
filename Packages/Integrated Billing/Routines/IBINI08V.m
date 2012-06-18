IBINI08V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.1,.14,21,0)
	;;=^^4^4^2930607^
	;;^DD(358.1,.14,21,1,0)
	;;= 
	;;^DD(358.1,.14,21,2,0)
	;;=A value greater than 0 means that the block belongs to the tool kit. The
	;;^DD(358.1,.14,21,3,0)
	;;=value also determines the order that the block will be listed to the
	;;^DD(358.1,.14,21,4,0)
	;;=screen that displays the tool kit blocks.
	;;^DD(358.1,.14,"DT")
	;;=2930309
	;;^DD(358.1,1,0)
	;;=EXPORT NOTES^358.11^^1;0
	;;^DD(358.1,1,21,0)
	;;=^^2^2^2930806^
	;;^DD(358.1,1,21,1,0)
	;;=Should be give other sites information that will enable them to decide
	;;^DD(358.1,1,21,2,0)
	;;=whether or not they want to import the block. Only applies to tool kit blocks.
	;;^DD(358.11,0)
	;;=EXPORT NOTES SUB-FIELD^^.01^1
	;;^DD(358.11,0,"DT")
	;;=2930806
	;;^DD(358.11,0,"NM","EXPORT NOTES")
	;;=
	;;^DD(358.11,0,"UP")
	;;=358.1
	;;^DD(358.11,.01,0)
	;;=EXPORT NOTES^W^^0;1^Q
	;;^DD(358.11,.01,3)
	;;=What should other sites know about this tool kit block before importing it?
	;;^DD(358.11,.01,"DT")
	;;=2930806

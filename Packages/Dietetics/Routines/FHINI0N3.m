FHINI0N3	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.985,.01,1,0)
	;;=^.1
	;;^DD(119.985,.01,1,1,0)
	;;=119.985^B
	;;^DD(119.985,.01,1,1,1)
	;;=S ^FH(119.9,DA(1),"P","B",$E(X,1,30),DA)=""
	;;^DD(119.985,.01,1,1,2)
	;;=K ^FH(119.9,DA(1),"P","B",$E(X,1,30),DA)
	;;^DD(119.985,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.985,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the DRUG CLASSIFICATIONS field.
	;;^DD(119.985,.01,21,0)
	;;=^^2^2^2890709^
	;;^DD(119.985,.01,21,1,0)
	;;=This field is a pointer to File 50.605, VA Drug Classification
	;;^DD(119.985,.01,21,2,0)
	;;=and is a classification of interest to clinicians.
	;;^DD(119.985,.01,"DT")
	;;=2890709

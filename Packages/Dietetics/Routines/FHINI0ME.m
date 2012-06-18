FHINI0ME	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.1,0,"GL")
	;;=^FH(119.1,
	;;^DIC("B","UNITS",119.1)
	;;=
	;;^DIC(119.1,"%D",0)
	;;=^^2^2^2880515^
	;;^DIC(119.1,"%D",1,0)
	;;=This file consists of a list of units used by the ingredient file
	;;^DIC(119.1,"%D",2,0)
	;;=to indicate the dietetic issue unit.
	;;^DD(119.1,0)
	;;=FIELD^^.01^1
	;;^DD(119.1,0,"IX","B",119.1,.01)
	;;=
	;;^DD(119.1,0,"NM","UNITS")
	;;=
	;;^DD(119.1,0,"PT",113,5)
	;;=
	;;^DD(119.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>12!($L(X)<2) X
	;;^DD(119.1,.01,1,0)
	;;=^.1
	;;^DD(119.1,.01,1,1,0)
	;;=119.1^B
	;;^DD(119.1,.01,1,1,1)
	;;=S ^FH(119.1,"B",$E(X,1,30),DA)=""
	;;^DD(119.1,.01,1,1,2)
	;;=K ^FH(119.1,"B",$E(X,1,30),DA)
	;;^DD(119.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.1,.01,3)
	;;=ANSWER MUST BE 2-12 CHARACTERS IN LENGTH
	;;^DD(119.1,.01,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.1,.01,21,1,0)
	;;=This field contains the name of a unit which can be selected
	;;^DD(119.1,.01,21,2,0)
	;;=as the dietetic 'unit of issue' in the ingredient file.
	;;^DD(119.1,.01,"DT")
	;;=2880306

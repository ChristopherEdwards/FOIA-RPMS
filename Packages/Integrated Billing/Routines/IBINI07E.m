IBINI07E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.94)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.94,.02,1,0)
	;;=^.1
	;;^DD(356.94,.02,1,1,0)
	;;=356.94^C
	;;^DD(356.94,.02,1,1,1)
	;;=S ^IBT(356.94,"C",$E(X,1,30),DA)=""
	;;^DD(356.94,.02,1,1,2)
	;;=K ^IBT(356.94,"C",$E(X,1,30),DA)
	;;^DD(356.94,.02,1,1,"%D",0)
	;;=^^2^2^2940222^^
	;;^DD(356.94,.02,1,1,"%D",1,0)
	;;=Regular cross reference of all inpatient provider entries by the admission 
	;;^DD(356.94,.02,1,1,"%D",2,0)
	;;=movement.
	;;^DD(356.94,.02,1,1,"DT")
	;;=2940222
	;;^DD(356.94,.02,1,2,0)
	;;=356.94^ADG^MUMPS
	;;^DD(356.94,.02,1,2,1)
	;;=S:$P(^IBT(356.94,DA,0),U,4)=3&($P(^(0),U,3)) ^IBT(356.94,"ADG",X,+$P(^(0),U,3),DA)=""
	;;^DD(356.94,.02,1,2,2)
	;;=K ^IBT(356.94,"ADG",X,+$P(^IBT(356.94,DA,0),U,3),DA)
	;;^DD(356.94,.02,1,2,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.02,1,2,"%D",1,0)
	;;=Cross reference of all admitting provider entries by admission movement,
	;;^DD(356.94,.02,1,2,"%D",2,0)
	;;=by provider.
	;;^DD(356.94,.02,1,2,"DT")
	;;=2940222
	;;^DD(356.94,.02,1,3,0)
	;;=356.94^ADGPM^MUMPS
	;;^DD(356.94,.02,1,3,1)
	;;=S:$P(^IBT(356.94,DA,0),U,3) ^IBT(356.94,"ADGPM",X,+$P(^(0),U,3),DA)=""
	;;^DD(356.94,.02,1,3,2)
	;;=K ^IBT(356.94,"ADGPM",X,+$P(^IBT(356.94,DA,0),U,3),DA)
	;;^DD(356.94,.02,1,3,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.02,1,3,"%D",1,0)
	;;=Cross reference of all inpatient provider entries by patient movement,
	;;^DD(356.94,.02,1,3,"%D",2,0)
	;;=by provider.
	;;^DD(356.94,.02,1,3,"DT")
	;;=2940222
	;;^DD(356.94,.02,1,4,0)
	;;=356.94^ATP^MUMPS
	;;^DD(356.94,.02,1,4,1)
	;;=S:$P(^IBT(356.94,DA,0),U,4) ^IBT(356.94,"ATP",X,+$P(^(0),U,4),DA)=""
	;;^DD(356.94,.02,1,4,2)
	;;=K ^IBT(356.94,"ATP",X,+$P(^IBT(356.94,DA,0),U,4),DA)
	;;^DD(356.94,.02,1,4,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.02,1,4,"%D",1,0)
	;;=Cross reference of all inpatient provider entries by admission movement
	;;^DD(356.94,.02,1,4,"%D",2,0)
	;;=by type of provider.
	;;^DD(356.94,.02,1,4,"DT")
	;;=2940222
	;;^DD(356.94,.02,12)
	;;=Must be an admission movement.
	;;^DD(356.94,.02,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356.94,.02,21,0)
	;;=^^1^1^2940202^
	;;^DD(356.94,.02,21,1,0)
	;;=This is the admission movement that the provider is responsible for.
	;;^DD(356.94,.02,"DT")
	;;=2940222
	;;^DD(356.94,.03,0)
	;;=PROVIDER^*P200'^VA(200,^0;3^S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U,1),+Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.94,.03,1,0)
	;;=^.1
	;;^DD(356.94,.03,1,1,0)
	;;=356.94^D
	;;^DD(356.94,.03,1,1,1)
	;;=S ^IBT(356.94,"D",$E(X,1,30),DA)=""
	;;^DD(356.94,.03,1,1,2)
	;;=K ^IBT(356.94,"D",$E(X,1,30),DA)
	;;^DD(356.94,.03,1,1,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.03,1,1,"%D",1,0)
	;;=Regular cross-reference of all inpatient provider entries by
	;;^DD(356.94,.03,1,1,"%D",2,0)
	;;=provider.
	;;^DD(356.94,.03,1,1,"DT")
	;;=2940222
	;;^DD(356.94,.03,1,2,0)
	;;=356.94^ADG1^MUMPS
	;;^DD(356.94,.03,1,2,1)
	;;=S:$P(^IBT(356.94,DA,0),U,4)=3&($P(^(0),U,2)) ^IBT(356.94,"ADG",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.94,.03,1,2,2)
	;;=K ^IBT(356.94,"ADG",+$P(^IBT(356.94,DA,0),U,2),X,DA)
	;;^DD(356.94,.03,1,2,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.03,1,2,"%D",1,0)
	;;=Cross reference of all admitting provider entries by admission movement,
	;;^DD(356.94,.03,1,2,"%D",2,0)
	;;=by provider.
	;;^DD(356.94,.03,1,2,"DT")
	;;=2940222
	;;^DD(356.94,.03,1,3,0)
	;;=356.94^ADGPM1^MUMPS
	;;^DD(356.94,.03,1,3,1)
	;;=S:$P(^IBT(356.94,DA,0),U,2) ^IBT(356.94,"ADGPM",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.94,.03,1,3,2)
	;;=K ^IBT(356.94,"ADGPM",+$P(^IBT(356.94,DA,0),U,2),X,DA)
	;;^DD(356.94,.03,1,3,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.03,1,3,"%D",1,0)
	;;=Cross reference of all inpatient provider entries by patient movement, 

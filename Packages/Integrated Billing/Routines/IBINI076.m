IBINI076	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.9,0,"GL")
	;;=^IBT(356.9,
	;;^DIC("B","INPATIENT DIAGNOSIS",356.9)
	;;=
	;;^DIC(356.9,"%D",0)
	;;=^^3^3^2940214^^^^
	;;^DIC(356.9,"%D",1,0)
	;;=This file is designed to hold all inpatient diagnoses.
	;;^DIC(356.9,"%D",2,0)
	;;= 
	;;^DIC(356.9,"%D",3,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.9,0)
	;;=FIELD^^.04^4
	;;^DD(356.9,0,"DT")
	;;=2930901
	;;^DD(356.9,0,"ID",.03)
	;;=W "   ",$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)
	;;^DD(356.9,0,"ID",.04)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(356.9,.04,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,4)_"":"",2),$C(59),1)")
	;;^DD(356.9,0,"ID","WRITE")
	;;=N Y S Y=$G(^(0)) W "   ",$P($G(^DPT(+$P($G(^DGPM(+$P(Y,U,2),0)),U,3),0)),U)
	;;^DD(356.9,0,"IX","ADG",356.9,.01)
	;;=
	;;^DD(356.9,0,"IX","ADG1",356.9,.02)
	;;=
	;;^DD(356.9,0,"IX","ADG2",356.9,.04)
	;;=
	;;^DD(356.9,0,"IX","ADGPM",356.9,.01)
	;;=
	;;^DD(356.9,0,"IX","ADGPM1",356.9,.02)
	;;=
	;;^DD(356.9,0,"IX","APD",356.9,.02)
	;;=
	;;^DD(356.9,0,"IX","APD1",356.9,.03)
	;;=
	;;^DD(356.9,0,"IX","ATP",356.9,.04)
	;;=
	;;^DD(356.9,0,"IX","ATP1",356.9,.02)
	;;=
	;;^DD(356.9,0,"IX","B",356.9,.01)
	;;=
	;;^DD(356.9,0,"IX","C",356.9,.02)
	;;=
	;;^DD(356.9,0,"IX","D",356.9,.03)
	;;=
	;;^DD(356.9,0,"NM","INPATIENT DIAGNOSIS")
	;;=
	;;^DD(356.9,0,"PT",356,.3)
	;;=
	;;^DD(356.9,.01,0)
	;;=DIAGNOSIS^RP80'^ICD9(^0;1^Q
	;;^DD(356.9,.01,1,0)
	;;=^.1
	;;^DD(356.9,.01,1,1,0)
	;;=356.9^B
	;;^DD(356.9,.01,1,1,1)
	;;=S ^IBT(356.9,"B",$E(X,1,30),DA)=""
	;;^DD(356.9,.01,1,1,2)
	;;=K ^IBT(356.9,"B",$E(X,1,30),DA)
	;;^DD(356.9,.01,1,2,0)
	;;=356.9^ADG^MUMPS
	;;^DD(356.9,.01,1,2,1)
	;;=S:$P(^IBT(356.9,DA,0),U,4)=3&($P(^(0),U,2)) ^IBT(356.9,"ADG",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.9,.01,1,2,2)
	;;=K ^IBT(356.9,"ADG",+$P(^IBT(356.9,DA,0),U,2),X,DA)
	;;^DD(356.9,.01,1,2,"%D",0)
	;;=^^1^1^2930901^
	;;^DD(356.9,.01,1,2,"%D",1,0)
	;;=Cross-reference of admitting diagnosis by admission movement.
	;;^DD(356.9,.01,1,2,"DT")
	;;=2930901
	;;^DD(356.9,.01,1,3,0)
	;;=356.9^ADGPM^MUMPS
	;;^DD(356.9,.01,1,3,1)
	;;=S:$P(^IBT(356.9,DA,0),U,2) ^IBT(356.9,"ADGPM",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.9,.01,1,3,2)
	;;=K ^IBT(356.9,"ADGPM",+$P(^IBT(356.9,DA,0),U,2),X,DA)
	;;^DD(356.9,.01,1,3,"%D",0)
	;;=^^1^1^2930901^
	;;^DD(356.9,.01,1,3,"%D",1,0)
	;;=Cross-reference of all diagnosis by admission movement
	;;^DD(356.9,.01,1,3,"DT")
	;;=2930901
	;;^DD(356.9,.01,3)
	;;=
	;;^DD(356.9,.01,21,0)
	;;=^^1^1^2930720^^^^
	;;^DD(356.9,.01,21,1,0)
	;;=This is the diagnosis for this patient for this episode of care.
	;;^DD(356.9,.01,"DT")
	;;=2930901
	;;^DD(356.9,.02,0)
	;;=ADMISSION MOVEMENT^*P405'^DGPM(^0;2^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356.9,.02,1,0)
	;;=^.1
	;;^DD(356.9,.02,1,1,0)
	;;=356.9^C
	;;^DD(356.9,.02,1,1,1)
	;;=S ^IBT(356.9,"C",$E(X,1,30),DA)=""
	;;^DD(356.9,.02,1,1,2)
	;;=K ^IBT(356.9,"C",$E(X,1,30),DA)
	;;^DD(356.9,.02,1,1,"DT")
	;;=2930713
	;;^DD(356.9,.02,1,2,0)
	;;=356.9^APD^MUMPS
	;;^DD(356.9,.02,1,2,1)
	;;=S:$P(^IBT(356.9,DA,0),U,3) ^IBT(356.9,"APD",X,-$P(^(0),U,3),DA)=""
	;;^DD(356.9,.02,1,2,2)
	;;=K ^IBT(356.9,"APD",X,-$P(^IBT(356.9,DA,0),U,3),DA)
	;;^DD(356.9,.02,1,2,"%D",0)
	;;=^^1^1^2940213^^^^
	;;^DD(356.9,.02,1,2,"%D",1,0)
	;;=cross reference of all diagnoses by tracking id and inverse date
	;;^DD(356.9,.02,1,2,"DT")
	;;=2930713
	;;^DD(356.9,.02,1,3,0)
	;;=356.9^ATP1^MUMPS
	;;^DD(356.9,.02,1,3,1)
	;;=S:$P(^IBT(356.9,DA,0),U,4) ^IBT(356.9,"ATP",X,$P(^(0),U,4),DA)=""
	;;^DD(356.9,.02,1,3,2)
	;;=K ^IBT(356.9,"ATP",X,+$P(^IBT(356.9,DA,0),U,4),DA)
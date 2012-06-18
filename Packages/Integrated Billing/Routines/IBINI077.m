IBINI077	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.9,.02,1,3,"%D",0)
	;;=^^2^2^2930720^
	;;^DD(356.9,.02,1,3,"%D",1,0)
	;;=Cross reference of primary diagnosis for a tracking entry so only one
	;;^DD(356.9,.02,1,3,"%D",2,0)
	;;=diagnosis can be primary
	;;^DD(356.9,.02,1,3,"DT")
	;;=2930720
	;;^DD(356.9,.02,1,4,0)
	;;=356.9^ADG1^MUMPS
	;;^DD(356.9,.02,1,4,1)
	;;=S:$P(^IBT(356.9,DA,0),U,4)=3&(+^(0)) ^IBT(356.9,"ADG",X,+^(0),DA)=""
	;;^DD(356.9,.02,1,4,2)
	;;=K ^IBT(356.9,"ADG",X,+^IBT(356.9,DA,0),DA)
	;;^DD(356.9,.02,1,4,"%D",0)
	;;=^^1^1^2930901^
	;;^DD(356.9,.02,1,4,"%D",1,0)
	;;=Cross-reference of admitting diagnosis by admission movement.
	;;^DD(356.9,.02,1,4,"DT")
	;;=2930901
	;;^DD(356.9,.02,1,5,0)
	;;=356.9^ADGPM1^MUMPS
	;;^DD(356.9,.02,1,5,1)
	;;=S:+^IBT(356.9,DA,0) ^IBT(356.9,"ADGPM",X,+^(0),DA)=""
	;;^DD(356.9,.02,1,5,2)
	;;=K ^IBT(356.9,"ADGPM",X,+^IBT(356,DA,0),DA)
	;;^DD(356.9,.02,1,5,"%D",0)
	;;=^^1^1^2940213^^
	;;^DD(356.9,.02,1,5,"%D",1,0)
	;;=Cross-reference of all diagnoses by admission movement.
	;;^DD(356.9,.02,1,5,"DT")
	;;=2930901
	;;^DD(356.9,.02,12)
	;;=Must be an admission movement
	;;^DD(356.9,.02,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356.9,.02,21,0)
	;;=^^3^3^2940213^^^
	;;^DD(356.9,.02,21,1,0)
	;;=This field should point to the admission movement of the inpatient episode
	;;^DD(356.9,.02,21,2,0)
	;;=that this diagnosis is for.  For ASIH movements it should point to
	;;^DD(356.9,.02,21,3,0)
	;;=the admission in the acute setting.
	;;^DD(356.9,.02,"DT")
	;;=2930901
	;;^DD(356.9,.03,0)
	;;=ONSET DATE THIS VISIT^RDX^^0;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X K:$G(X)+.9<+$G(^DGPM(+$P(^IBT(356.9,DA,0),U,2),0)) X
	;;^DD(356.9,.03,1,0)
	;;=^.1
	;;^DD(356.9,.03,1,1,0)
	;;=356.9^D
	;;^DD(356.9,.03,1,1,1)
	;;=S ^IBT(356.9,"D",$E(X,1,30),DA)=""
	;;^DD(356.9,.03,1,1,2)
	;;=K ^IBT(356.9,"D",$E(X,1,30),DA)
	;;^DD(356.9,.03,1,1,"DT")
	;;=2930713
	;;^DD(356.9,.03,1,2,0)
	;;=356.9^APD1^MUMPS
	;;^DD(356.9,.03,1,2,1)
	;;=S:$P(^IBT(356.9,DA,0),U,2) ^IBT(356.9,"APD",+$P(^(0),U,2),-X,DA)=""
	;;^DD(356.9,.03,1,2,2)
	;;=K ^IBT(356,"APD",+$P(^IBT(356.9,DA,0),U,2),-X,DA)
	;;^DD(356.9,.03,1,2,"%D",0)
	;;=^^1^1^2940213^^^^
	;;^DD(356.9,.03,1,2,"%D",1,0)
	;;=cross reference of all diagnoses by tracking id and inverse date.
	;;^DD(356.9,.03,1,2,"DT")
	;;=2930901
	;;^DD(356.9,.03,3)
	;;=Dates must be during the admission.
	;;^DD(356.9,.03,21,0)
	;;=^^4^4^2930825^^^^
	;;^DD(356.9,.03,21,1,0)
	;;=This is the date of the onset of this diagnosis for this episode of care.
	;;^DD(356.9,.03,21,2,0)
	;;=If the diagnosis is for an admission then the date of onset should be
	;;^DD(356.9,.03,21,3,0)
	;;=within the dates of admission and discharge.  If the diagnosis is for an
	;;^DD(356.9,.03,21,4,0)
	;;=outpatient visit then the date of onset should be the visit date.
	;;^DD(356.9,.03,"DT")
	;;=2930902
	;;^DD(356.9,.04,0)
	;;=TYPE^*S^1:PRIMARY;2:SECONDARY;3:ADMITTING;^0;4^Q
	;;^DD(356.9,.04,1,0)
	;;=^.1
	;;^DD(356.9,.04,1,1,0)
	;;=356.9^ATP^MUMPS
	;;^DD(356.9,.04,1,1,1)
	;;=S:$P(^IBT(356.9,DA,0),U,2) ^IBT(356.9,"ATP",$P(^(0),U,2),X,DA)=""
	;;^DD(356.9,.04,1,1,2)
	;;=K ^IBT(356.9,"ATP",+$P(^IBT(356.9,DA,0),U,2),X,DA)
	;;^DD(356.9,.04,1,1,"%D",0)
	;;=^^2^2^2930720^
	;;^DD(356.9,.04,1,1,"%D",1,0)
	;;=Cross reference of primary diagnosis for a tracking entry so only one
	;;^DD(356.9,.04,1,1,"%D",2,0)
	;;=diagnosis can be primary at a time.
	;;^DD(356.9,.04,1,1,"DT")
	;;=2930720
	;;^DD(356.9,.04,1,2,0)
	;;=356.9^ADG2^MUMPS
	;;^DD(356.9,.04,1,2,1)
	;;=S:X=3&($P(^IBT(356.9,DA,0),U,2))&(+^(0)) ^IBT(356.9,"ADG",+$P(^(0),U,2),+^(0),DA)=""
	;;^DD(356.9,.04,1,2,2)
	;;=K ^IBT(356.9,"ADG",+$P(^IBT(356.9,DA,0),U,2),+^(0),DA)

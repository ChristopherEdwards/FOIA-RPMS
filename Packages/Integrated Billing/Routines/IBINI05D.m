IBINI05D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.02,21,5,0)
	;;= 
	;;^DD(356,.02,"DT")
	;;=2930831
	;;^DD(356,.03,0)
	;;=VISIT^P9000010'^AUPNVSIT(^0;3^Q
	;;^DD(356,.03,1,0)
	;;=^.1
	;;^DD(356,.03,1,1,0)
	;;=356^AVSIT
	;;^DD(356,.03,1,1,1)
	;;=S ^IBT(356,"AVSIT",$E(X,1,30),DA)=""
	;;^DD(356,.03,1,1,2)
	;;=K ^IBT(356,"AVSIT",$E(X,1,30),DA)
	;;^DD(356,.03,1,1,"%D",0)
	;;=^^1^1^2930712^
	;;^DD(356,.03,1,1,"%D",1,0)
	;;=Regular cross-reference of claim by visit.
	;;^DD(356,.03,1,1,"DT")
	;;=2930712
	;;^DD(356,.03,3)
	;;=
	;;^DD(356,.03,21,0)
	;;=^^4^4^2930709^
	;;^DD(356,.03,21,1,0)
	;;=This is the visit for the patient that is being tracked in this entry.
	;;^DD(356,.03,21,2,0)
	;;= 
	;;^DD(356,.03,21,3,0)
	;;=This field is a place holder for when visit tracking is implemented.  It
	;;^DD(356,.03,21,4,0)
	;;=will point to the visit that is being tracked.
	;;^DD(356,.03,"DT")
	;;=2930712
	;;^DD(356,.04,0)
	;;=OUTPATIENT ENCOUNTER^P409.68'^SCE(^0;4^Q
	;;^DD(356,.04,1,0)
	;;=^.1
	;;^DD(356,.04,1,1,0)
	;;=356^ASCE
	;;^DD(356,.04,1,1,1)
	;;=S ^IBT(356,"ASCE",$E(X,1,30),DA)=""
	;;^DD(356,.04,1,1,2)
	;;=K ^IBT(356,"ASCE",$E(X,1,30),DA)
	;;^DD(356,.04,1,1,"%D",0)
	;;=^^1^1^2930712^
	;;^DD(356,.04,1,1,"%D",1,0)
	;;=Regular cross-reference of claims by outpatient encounters.
	;;^DD(356,.04,1,1,"DT")
	;;=2930712
	;;^DD(356,.04,1,2,0)
	;;=356^AENC^MUMPS
	;;^DD(356,.04,1,2,1)
	;;=S:$P(^IBT(356,DA,0),U,2) ^IBT(356,"AENC",+$P(^(0),U,2),X,DA)=""
	;;^DD(356,.04,1,2,2)
	;;=K ^IBT(356,"AENC",+$P(^IBT(356,DA,0),U,2),X,DA)
	;;^DD(356,.04,1,2,"%D",0)
	;;=^^1^1^2930831^
	;;^DD(356,.04,1,2,"%D",1,0)
	;;=Cross reference of outpatient encounters by patient.
	;;^DD(356,.04,1,2,"DT")
	;;=2930831
	;;^DD(356,.04,21,0)
	;;=^^3^3^2930709^
	;;^DD(356,.04,21,1,0)
	;;=This is the outpatient encounter that is being tracked.  If this is
	;;^DD(356,.04,21,2,0)
	;;=entered and the provider and/or diagnosis for the encounter are entered
	;;^DD(356,.04,21,3,0)
	;;=then the inforamation will be extracted from the encounter file.
	;;^DD(356,.04,"DT")
	;;=2930831
	;;^DD(356,.05,0)
	;;=ADMISSION^*P405'^DGPM(^0;5^S DIC("S")="I $P(^(0),U,2)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356,.05,1,0)
	;;=^.1
	;;^DD(356,.05,1,1,0)
	;;=356^ADM^MUMPS
	;;^DD(356,.05,1,1,1)
	;;=S:$P(^IBT(356,DA,0),"^",2) ^IBT(356,"ADM",+$P(^(0),"^",2),X,DA)=""
	;;^DD(356,.05,1,1,2)
	;;=K ^IBT(356,"ADM",+$P(^IBT(356,DA,0),"^",2),X,DA)
	;;^DD(356,.05,1,1,"%D",0)
	;;=^^1^1^2940121^^^
	;;^DD(356,.05,1,1,"%D",1,0)
	;;=Cross reference of all admissions by patient.
	;;^DD(356,.05,1,1,"DT")
	;;=2930702
	;;^DD(356,.05,1,2,0)
	;;=356^AD
	;;^DD(356,.05,1,2,1)
	;;=S ^IBT(356,"AD",$E(X,1,30),DA)=""
	;;^DD(356,.05,1,2,2)
	;;=K ^IBT(356,"AD",$E(X,1,30),DA)
	;;^DD(356,.05,1,2,"%D",0)
	;;=^^1^1^2940121^^
	;;^DD(356,.05,1,2,"%D",1,0)
	;;=Regular x-ref of admission movement ifn
	;;^DD(356,.05,1,2,"DT")
	;;=2930804
	;;^DD(356,.05,3)
	;;=
	;;^DD(356,.05,12)
	;;=Only admissions for this patient.
	;;^DD(356,.05,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=1"
	;;^DD(356,.05,21,0)
	;;=^^4^4^2930709^
	;;^DD(356,.05,21,1,0)
	;;=This is the admission that is being tracked.  When an entry is added for
	;;^DD(356,.05,21,2,0)
	;;=inpatient care for any date the software will find the current admission
	;;^DD(356,.05,21,3,0)
	;;=for that date and use the current admission from the patient movement
	;;^DD(356,.05,21,4,0)
	;;=file.
	;;^DD(356,.05,"DT")
	;;=2931018
	;;^DD(356,.06,0)
	;;=EPISODE DATE^D^^0;6^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356,.06,1,0)
	;;=^.1^^-1
	;;^DD(356,.06,1,1,0)
	;;=356^D
	;;^DD(356,.06,1,1,1)
	;;=S ^IBT(356,"D",$E(X,1,30),DA)=""

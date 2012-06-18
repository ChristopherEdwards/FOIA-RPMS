IBINI07F	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.94)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.94,.03,1,3,"%D",2,0)
	;;=by provider.
	;;^DD(356.94,.03,1,3,"DT")
	;;=2940222
	;;^DD(356.94,.03,12)
	;;=Must be a provder.
	;;^DD(356.94,.03,12.1)
	;;=S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U,1),+Y))"
	;;^DD(356.94,.03,21,0)
	;;=^^2^2^2940202^
	;;^DD(356.94,.03,21,1,0)
	;;=Enter the name of the provider who is responsible for care of this 
	;;^DD(356.94,.03,21,2,0)
	;;=patient.
	;;^DD(356.94,.03,"DT")
	;;=2940222
	;;^DD(356.94,.04,0)
	;;=TYPE PROVIDER^R*S^1:ATTENDING;2:PROVIDER;3:ADMITTING;^0;4^Q
	;;^DD(356.94,.04,1,0)
	;;=^.1
	;;^DD(356.94,.04,1,1,0)
	;;=356.94^ADG2^MUMPS
	;;^DD(356.94,.04,1,1,1)
	;;=S:X=3&($P(^IBT(356.94,DA,0),U,2))&($P(^(0),U,3)) ^IBT(356.94,"ADG",+$P(^(0),U,2),+$P(^(0),U,3),DA)=""
	;;^DD(356.94,.04,1,1,2)
	;;=K ^IBT(356.94,"ADG",+$P(^IBT(356.94,DA,0),U,2),+$P(^(0),U,3),DA)
	;;^DD(356.94,.04,1,1,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.04,1,1,"%D",1,0)
	;;=Cross reference of all admitting provider entries by admission movement,
	;;^DD(356.94,.04,1,1,"%D",2,0)
	;;=by provider.
	;;^DD(356.94,.04,1,1,"DT")
	;;=2940222
	;;^DD(356.94,.04,1,2,0)
	;;=356.94^ATP1^MUMPS
	;;^DD(356.94,.04,1,2,1)
	;;=S:$P(^IBT(356.94,DA,0),U,2) ^IBT(356.94,"ATP",+$P(^(0),U,2),X,DA)=""
	;;^DD(356.94,.04,1,2,2)
	;;=K ^IBT(356.94,"ATP",+$P(^IBT(356.94,DA,0),U,2),X,DA)
	;;^DD(356.94,.04,1,2,"%D",0)
	;;=^^2^2^2940222^
	;;^DD(356.94,.04,1,2,"%D",1,0)
	;;=Cross reference of all inpatient provider entries by admission movement
	;;^DD(356.94,.04,1,2,"%D",2,0)
	;;=by type of provider.
	;;^DD(356.94,.04,1,2,"DT")
	;;=2940222
	;;^DD(356.94,.04,12)
	;;=Only one admitting physician allowed.
	;;^DD(356.94,.04,12.1)
	;;=S DIC("S")="I $$DICS^IBTRE5(Y)"
	;;^DD(356.94,.04,21,0)
	;;=^^18^18^2940202^
	;;^DD(356.94,.04,21,1,0)
	;;=Enter whether this physician is an attending physician, admitting
	;;^DD(356.94,.04,21,2,0)
	;;=physician, or the daily care provider (or resident).
	;;^DD(356.94,.04,21,3,0)
	;;= 
	;;^DD(356.94,.04,21,4,0)
	;;=It may be that the admitting physician is different from either the
	;;^DD(356.94,.04,21,5,0)
	;;=attending or provider.  If the admission to acure care does not meet UR
	;;^DD(356.94,.04,21,6,0)
	;;=criteria, it is important to track the admitting physician.
	;;^DD(356.94,.04,21,7,0)
	;;= 
	;;^DD(356.94,.04,21,8,0)
	;;=The attending physician is the physician responsible for the care of
	;;^DD(356.94,.04,21,9,0)
	;;=the patient, more than one physician may be the attending.
	;;^DD(356.94,.04,21,10,0)
	;;= 
	;;^DD(356.94,.04,21,11,0)
	;;=The provider is the physician directly providing patient care.  In
	;;^DD(356.94,.04,21,12,0)
	;;=affiliated hospitals this can be a resident or intern who is not 
	;;^DD(356.94,.04,21,13,0)
	;;=necessarily responsible (the attending is responsible).
	;;^DD(356.94,.04,21,14,0)
	;;= 
	;;^DD(356.94,.04,21,15,0)
	;;=Because UR reviews are done every day, it is important to be able
	;;^DD(356.94,.04,21,16,0)
	;;=to accurately track attendings and providers related to care that
	;;^DD(356.94,.04,21,17,0)
	;;=does not meet critea.  
	;;^DD(356.94,.04,21,18,0)
	;;= 
	;;^DD(356.94,.04,"DT")
	;;=2940222

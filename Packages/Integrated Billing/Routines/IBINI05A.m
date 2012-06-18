IBINI05A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.7,.03,1,1,0)
	;;=355.7^APP2^MUMPS
	;;^DD(355.7,.03,1,1,1)
	;;=S:$P(^IBA(355.7,DA,0),U,2) ^IBA(355.7,"APP",+$P(^(0),U,2),X,+^(0),DA)=""
	;;^DD(355.7,.03,1,1,2)
	;;=K ^IBA(355.7,"APP",+$P(^IBA(355.7,DA,0),U,2),X,+^(0),DA)
	;;^DD(355.7,.03,1,1,"%D",0)
	;;=^^2^2^2931129^
	;;^DD(355.7,.03,1,1,"%D",1,0)
	;;=Cross reference of riders by patient, policy, rider.  Used to make sure
	;;^DD(355.7,.03,1,1,"%D",2,0)
	;;=only one entry for each policy.
	;;^DD(355.7,.03,1,1,"DT")
	;;=2931129
	;;^DD(355.7,.03,2)
	;;=S Y(0)=Y S Y=$P($G(^DIC(36,+$P($G(^DPT(+$P(^IBA(355.7,DA,0),U,2),.312,+$G(Y),0)),U),0)),U)
	;;^DD(355.7,.03,2.1)
	;;=S Y=$P($G(^DIC(36,+$P($G(^DPT(+$P(^IBA(355.7,DA,0),U,2),.312,+$G(Y),0)),U),0)),U)
	;;^DD(355.7,.03,3)
	;;=Select the correct policy for this patient.  Answer must be 1-30 characters in length.
	;;^DD(355.7,.03,4)
	;;=S DFN=$P(^IBA(355.7,DA,0),U,2) D DISP^IBCNS W !
	;;^DD(355.7,.03,21,0)
	;;=^^3^3^2940213^
	;;^DD(355.7,.03,21,1,0)
	;;=This is the policy for the patient that this is a rider for.
	;;^DD(355.7,.03,21,2,0)
	;;= 
	;;^DD(355.7,.03,21,3,0)
	;;=One or more riders may be associated with any policy for any patient.
	;;^DD(355.7,.03,"DT")
	;;=2931129

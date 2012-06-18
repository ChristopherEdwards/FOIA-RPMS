IBINI0AT	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.0304,5,21,2,0)
	;;=is not filled in for Billable Ambulatory Surgical Codes then a BASC
	;;^DD(399.0304,5,21,3,0)
	;;=revenue code and amount will not be calculated.
	;;^DD(399.0304,5,"DT")
	;;=2930903
	;;^DD(399.0304,6,0)
	;;=ASSOCIATED CLINIC^*P44'^SC(^0;7^S DIC("S")="I $P(^(0),U,3)=""C"",$S('$D(^(""I"")):1,'^(""I""):1,'$D(DGPROCDT):0,^(""I"")>DGPROCDT:1,'$P(^(""I""),U,2):0,1:$P(^(""I""),U,2)'>DGPROCDT)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.0304,6,12)
	;;=Only active clinics!
	;;^DD(399.0304,6,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)=""C"",$S('$D(^(""I"")):1,'^(""I""):1,'$D(DGPROCDT):0,^(""I"")>DGPROCDT:1,'$P(^(""I""),U,2):0,1:$P(^(""I""),U,2)'>DGPROCDT)"
	;;^DD(399.0304,6,21,0)
	;;=^^3^3^2920415^^^
	;;^DD(399.0304,6,21,1,0)
	;;=Enter the clinic where this procedure was performed.  This field must
	;;^DD(399.0304,6,21,2,0)
	;;=be completed in order for this procedure to successfully be transfered
	;;^DD(399.0304,6,21,3,0)
	;;=to the Add/Edit Stop code logic for inclusion in OPC workload.
	;;^DD(399.0304,6,"DT")
	;;=2911231
	;;^DD(399.0304,7,0)
	;;=*ASSOCIATED DIAGNOSIS^P80'^ICD9(^0;8^Q
	;;^DD(399.0304,7,3)
	;;=Enter the diagnosis related to this procedure.
	;;^DD(399.0304,7,21,0)
	;;=^^2^2^2931117^^^^
	;;^DD(399.0304,7,21,1,0)
	;;=This is the diagnosis most closely related to this procedure.  Used on the
	;;^DD(399.0304,7,21,2,0)
	;;=HFCA 1500, block 24e.
	;;^DD(399.0304,7,23,0)
	;;=^^2^2^2931117^
	;;^DD(399.0304,7,23,1,0)
	;;=Replaced by (399,304,10-13) so that could point to the diagnosis file (362.3).
	;;^DD(399.0304,7,23,2,0)
	;;="*"ed for deletion 11/16/93.
	;;^DD(399.0304,7,"DT")
	;;=2931116
	;;^DD(399.0304,8,0)
	;;=PLACE OF SERVICE^P353.1'^IBE(353.1,^0;9^Q
	;;^DD(399.0304,8,3)
	;;=Enter the Place of Service appropriate for this procedure.
	;;^DD(399.0304,8,21,0)
	;;=^^2^2^2930604^^
	;;^DD(399.0304,8,21,1,0)
	;;=This is the Place of Service appropriate for this Procedure.  Used only
	;;^DD(399.0304,8,21,2,0)
	;;=for the HCFA 1500 claim form.
	;;^DD(399.0304,8,"DT")
	;;=2930604
	;;^DD(399.0304,9,0)
	;;=TYPE OF SERVICE^P353.2'^IBE(353.2,^0;10^Q
	;;^DD(399.0304,9,3)
	;;=Enter the Type of Service appropriate for this procedure.
	;;^DD(399.0304,9,21,0)
	;;=^^2^2^2930604^
	;;^DD(399.0304,9,21,1,0)
	;;=This is the Type of Service to be associated with this procedure.  Applies
	;;^DD(399.0304,9,21,2,0)
	;;=only to the HCFA 1500 claim form.
	;;^DD(399.0304,9,"DT")
	;;=2930604
	;;^DD(399.0304,10,0)
	;;=ASSOCIATED DIAGNOSIS (1)^*P362.3'^IBA(362.3,^0;11^S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.0304,10,3)
	;;=Enter the diagnosis related to this procedure.
	;;^DD(399.0304,10,12)
	;;=Only Diagnosis for this bill may be chosen.
	;;^DD(399.0304,10,12.1)
	;;=S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))"
	;;^DD(399.0304,10,21,0)
	;;=^^2^2^2931130^^^^
	;;^DD(399.0304,10,21,1,0)
	;;=The diagnosis most closely related to this procedure.  Used only for the
	;;^DD(399.0304,10,21,2,0)
	;;=HCFA 1500, block 24e.
	;;^DD(399.0304,10,23,0)
	;;=^^1^1^2931130^^^^
	;;^DD(399.0304,10,23,1,0)
	;;=Converted from (399,304,7) with IB 2.0.
	;;^DD(399.0304,10,"DT")
	;;=2931130
	;;^DD(399.0304,11,0)
	;;=ASSOCIATED DIAGNOSIS (2)^*P362.3'^IBA(362.3,^0;12^S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.0304,11,3)
	;;=Enter a diagnosis related to this procedure.
	;;^DD(399.0304,11,12)
	;;=Only Diagnosis for this bill may be chosen.
	;;^DD(399.0304,11,12.1)
	;;=S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))"

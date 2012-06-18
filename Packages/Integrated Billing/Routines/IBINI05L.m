IBINI05L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.25,.1)
	;;=RANDOM SAMPLE?
	;;^DD(356,.25,3)
	;;=
	;;^DD(356,.25,21,0)
	;;=^^7^7^2930712^
	;;^DD(356,.25,21,1,0)
	;;=Enter if this is to be tracked as a Random Sample for UR purposes.  The
	;;^DD(356,.25,21,2,0)
	;;=Claims tracking module is designed to flag one admission per week
	;;^DD(356,.25,21,3,0)
	;;=each from the 3 major bedsections, Medicine, Surgery, and Psychiatry,
	;;^DD(356,.25,21,4,0)
	;;=as a random sample that is to have utilization review follow-up.  If
	;;^DD(356,.25,21,5,0)
	;;=there is not sufficient activity in your facility for the automated
	;;^DD(356,.25,21,6,0)
	;;=tracker to set up the minimum random sample, then you may manually
	;;^DD(356,.25,21,7,0)
	;;=add entires to be tracked for UR purposes.
	;;^DD(356,.25,"DT")
	;;=2930712
	;;^DD(356,.26,0)
	;;=TRACKED AS SPECIAL CONDITION^S^1:TURP;2:COPD;3:CVD;0:NONE;^0;26^Q
	;;^DD(356,.26,.1)
	;;=SPECIAL CONDITION?
	;;^DD(356,.26,3)
	;;=
	;;^DD(356,.26,21,0)
	;;=^^8^8^2940124^^^^
	;;^DD(356,.26,21,1,0)
	;;=If you are tracking special conditions for follow up by UR then
	;;^DD(356,.26,21,2,0)
	;;=indicate that this is a special condition UR case and UR will be
	;;^DD(356,.26,21,3,0)
	;;=required and the information about this case will appear on special
	;;^DD(356,.26,21,4,0)
	;;=condition reports.
	;;^DD(356,.26,21,5,0)
	;;= 
	;;^DD(356,.26,21,6,0)
	;;=The choices are:   TURP -- Transurethral Prostatectomy
	;;^DD(356,.26,21,7,0)
	;;=                   COPD -- Chronic Obstructive Pulmonary Disease
	;;^DD(356,.26,21,8,0)
	;;=                   CVD  -- Cerebrovascular Disease
	;;^DD(356,.26,"DT")
	;;=2940124
	;;^DD(356,.27,0)
	;;=TRACKED AS A LOCAL ADDITION?^S^1:YES;0:NO;^0;27^Q
	;;^DD(356,.27,.1)
	;;=LOCAL ADDITION?
	;;^DD(356,.27,3)
	;;=
	;;^DD(356,.27,21,0)
	;;=^^2^2^2930712^
	;;^DD(356,.27,21,1,0)
	;;=If this is being track as a local addition for UR purposes then
	;;^DD(356,.27,21,2,0)
	;;=enter 'YES'.
	;;^DD(356,.27,"DT")
	;;=2930624
	;;^DD(356,.28,0)
	;;=ESTIMATED MT CHARGES^NJ10,2^^0;28^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(356,.28,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(356,.28,21,0)
	;;=^^2^2^2930712^
	;;^DD(356,.28,21,1,0)
	;;=Enter the estimated amount of Means Test copayment charges that
	;;^DD(356,.28,21,2,0)
	;;=are to be paid by the patient for this case.
	;;^DD(356,.28,"DT")
	;;=2930712
	;;^DD(356,.29,0)
	;;=ESTIMATED TOTAL CHARGES^NJ10,2^^0;29^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(356,.29,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(356,.29,21,0)
	;;=^^8^8^2940213^^
	;;^DD(356,.29,21,1,0)
	;;=Enter the estimated total charges from this case.  This is the estimated
	;;^DD(356,.29,21,2,0)
	;;=total amount due the government.  
	;;^DD(356,.29,21,3,0)
	;;= 
	;;^DD(356,.29,21,4,0)
	;;=The total estimated charges minus the estimated payments from all sources
	;;^DD(356,.29,21,5,0)
	;;=will be the amount not anticipated to be reimbursed from this case.
	;;^DD(356,.29,21,6,0)
	;;=Comparing estimated receipt versus the actual amount received will
	;;^DD(356,.29,21,7,0)
	;;=help determine if all payers have sufficiently re-imbursed the 
	;;^DD(356,.29,21,8,0)
	;;=government.
	;;^DD(356,.29,"DT")
	;;=2930712
	;;^DD(356,.3,0)
	;;=ADMITTING REASON (ICD-9)^*P356.9'^IBT(356.9,^0;30^S DIC("S")="I $P(^(0),U,4)=3" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(356,.3,12)
	;;=Must be the admitting diagnosis for this admission movement.
	;;^DD(356,.3,12.1)
	;;=S DIC("S")="I $P(^(0),U,4)=3"
	;;^DD(356,.3,21,0)
	;;=^^1^1^2930901^^

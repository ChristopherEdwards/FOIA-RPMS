IBCNSEH	;ALB/AAS - EXTENDED HELP FOR INSURANCE MANAGEMENT - 28-MAY-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
INS	; -- Help for Insurance Type
	Q:'$G(IBCNSEH)
	W !!,"The way we store and think about patient insurance information has been"
	W !,"dramatically changed.  We are separating out information that is specific"
	W !,"to an insurance company, specific to the patient, specific to the group plan,"
	W !,"specific to the annual benefits available, and the annual benefits aready"
	W !,"used."
	W !!,"To start, you must select the insurance company for the patient's policy.",!
	Q
PAT	; -- Help for entering patient specific information
	Q:'$G(IBCNSEH)
	W !!,"Now you may enter the patient specific policy information."
	W !,"Most of these fields will be familiar to experienced users.  The field"
	W !,"'SUBSCRIBER ID' used to be called 'INSURANCE NUMBER' and "
	W !,"has been modified to allow entering just 'SS' to retrieve"
	W !,"the patients SSN.  This field is the identifier for the policy or patient"
	W !,"that the carrier uses.  See the new help.",!
	Q
POL	; -- Help for policy specific information
	Q:'$G(IBCNSEH)
	W !!,"You can now edit information specific to the Group PLAN.  Remember, updating"
	W !,"PLAN information will affect all patients with this plan, not just"
	W !,"the current patient.",!
	Q
	;
SEL	; -- help for selecting a new HIP
	Q:'$G(IBCNSEH)
	W !!,"Each Insurance policy entry for a patient must be associated with a"
	W !,"Group Insurance Plan for the Insurance company you just selected."
	W !,"You will be given a choice of selecting previously entered Group Plans or"
	W !,"you may enter a new one.  If you enter a new Group Insurance Plan you"
	W !,"must enter whether or not this is a group or individual plan.",!
	Q
AB	;
	Q:'$G(IBCNSEH)
	Q
BU	;
	Q:'$G(IBCNSEH)
	Q

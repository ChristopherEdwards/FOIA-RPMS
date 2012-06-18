IBCNSEVT	;ALB/AAS - NEW INSURANCE POLICY EVENT DRIVER ; 12-DEC-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	; -- Invokes items on the IB NEW INSURANCE EVENT protocol menu
	;    Input  =:  dfn      = patient file ien
	;               ibevta   = insurnace type zeroth node of new policy
	;                          contains effective/expiration dates
	;               ibevt1   = insurance type 1 nde of new policy
	;                          contains date added and by whom
	;               ibcdfn   = internal number of policy as in ^dpt(dfn,.312,ibcdfn,0))
	;
	N DTOUT,DIROUT
	;S X=$O(^ORD(101,"B","IBCN NEW INSURANCE EVENTS",0))_";ORD(101," D EN1^XQOR:X
	S X="IBCN NEW INSURANCE EVENTS",DIC=101 D EN1^XQOR
	K X,DIC
	Q
	;
	;
AFTER	; -- get exemption after change
	;    input  =:  dfn    = patient file ien
	;
	S IBEVTA=$G(^DPT(DFN,.312,IBCDFN,0))
	S IBEVT1=$G(^DPT(DFN,.312,IBCDFN,1))
	Q

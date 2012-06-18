IBCNSU1	;ALB/AAS - INSURANCE UTILITY ROUTINE ; 19-MAY-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
RCHK(X)	; -- Input transform for different revenue codes in file 36
	;    Returns 1 if passes, 0 if not pass input transform
	;
	N I,Y,RC,NO S Y=0
	I $G(X)="" G RCHKQ
	F I=1:1 S RC=$P(X,",",I) Q:RC=""  I $S(RC?3N:0,RC?5N:0,1:1) S NO=1 Q
	I '$G(NO) S Y=1
RCHKQ	Q Y
	;
BU(DFN,IBCPOL,IBYR,IBCDFN,IBASK)	; -- Return entry in Benefits Used file
	;     Input:  IBCDFN  = pointer to patient file policy (2.312)
	;             DFN     = patient pointer        
	;             IBCPOL  = pointer to health insurance policy file
	;             IBYR    = fileman internal date, year will be calendar
	;                       year of the internal date, Default = dt
	;             IBASK   = 1 if want to ask okay to add new entry
	;
	;    Output:  IBCBU   = pointer to Benefits Used file if added,
	;                       else null
	;
	N DIR,IBCBU
	S IBCBU=""
	I $G(IBCPOL)="" G BUQ
	I $G(IBYR)="" S IBYR=DT
	;
	;if no match display message
	I '$O(^IBA(355.4,"APY",IBCPOL,-IBYR,0)) W !!,"You cannot add a new Benefits Used BENEFIT YEAR",!! G BUQ
	;
	; -- try to find entry for policy for year
	S IBCBU=$O(^IBA(355.5,"APPY",DFN,IBCPOL,-IBYR,IBCDFN,0))
	;
	; -- if no match add new entry
	I 'IBCBU D
	.I $G(IBASK) S DIR(0)="Y",DIR("A")="Are you adding a new Benefits Used YEAR",DIR("B")="YES" D ^DIR I $D(DIRUT)!(Y<1) S VALMQUIT="" Q
	.S IBCBU=$$ADDBU(DFN,IBCPOL,IBYR,IBCDFN)
	.Q
	;
BUQ	Q IBCBU
	;
ADDBU(DFN,IBCPOL,IBYR,IBCDFN)	; -- add entries to Benefits Used file
	;     Input:  DFN     = pointer to patient file
	;             IBCDFN  = point to patient policy (2.312)
	;             IBCPOL  = pointer to health insurance policy file
	;             IBYR    = fileman internal date, year will be calendar
	;                       year of the internal date, Default = dt
	;
	;    Output:  IBCBU   = pointer to Benefits Used file if added,
	;                       else null
	;
	N %DT,IBN1,IBCBU,DIC,DIE,DR,DA,DLAYGO,DO,DD
	S IBCBU=""
	I $G(IBCDFN)="" G ADDBUQ
	I $G(IBCPOL)="" G ADDBUQ
	I $G(IBYR)="" S IBYR=DT
	K DD,DO,DIC,DR S DIC="^IBA(355.5,",DIC(0)="L",DLAYGO=355.5
	;
	;S IBYR=$E(IBYR,1,3)_"0000"
	S X=IBCPOL D FILE^DICN I +Y<0 G ADDBUQ
	S (IBCBU,DA)=+Y,DIE="^IBA(355.5,",DR=".02////"_DFN_";.03////"_IBYR_";.17////"_IBCDFN_";1.01///NOW;1.02////"_DUZ
	D ^DIE K DIC,DIE,DA,DR
ADDBUQ	Q IBCBU

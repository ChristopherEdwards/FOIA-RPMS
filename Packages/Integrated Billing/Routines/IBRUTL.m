IBRUTL	;ALB/CPM - INTEGRATED BILLING - A/R INTERFACE UTILITIES ; 03-MAR-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
IB(IEN,RETN)	; Are there any IB Actions on hold for this bill?
	;         Input:   IEN         -- ien of Bill(#399), A/R(#430)
	;                  RETN (opt)  -- Want array of IB Actions? (1-Yes,0-No)
	;                                 if yes, returns IBA(num)=ibn
	;         Returns: 1 -- Yes, 0 -- No
	;
	N ATYPE,BTYPE,BILLS,DFN,IBFR,IB0,IBTO,IBU,IBN,IBND,IBNUM,IBOK
	S:'$D(RETN) RETN=0 S BILLS=0
	;
	; - determine patient, bill type and billing dates
	S IB0=$G(^DGCR(399,IEN,0)),IBU=$G(^("U")),DFN=+$P(IB0,"^",2)
	S BTYPE=$S(+$P(IB0,"^",5)<3:"I",1:"O"),IBFR=+IBU,IBTO=$P(IBU,"^",2)
	;
	; - loop through all bills on hold, and set flag if there is an
	; - IB Action of the same type as the UB-82 which has been billed
	; - within the statement dates of the UB-82.  Store all actions
	; - in the array IBA if required.
	S (IBN,IBNUM)=0 F  S IBN=$O(^IB("AH",DFN,IBN)) Q:'IBN  D  I IBOK Q:'RETN  S IBNUM=IBNUM+1,IBA(IBNUM)=IBN
	. S IBOK=0,IBND=$G(^IB(IBN,0)) Q:'IBND
	. S ATYPE=$S($P($G(^IBE(350.1,+$P(IBND,"^",3),0)),"^")["OPT":"O",1:"I") Q:ATYPE'=BTYPE
	. Q:$P(IBND,"^",15)<IBFR!($P(IBND,"^",14)>IBTO)  S (IBOK,BILLS)=1
	;
	Q BILLS
	;
	;
HOLD(X,IBN,IBDUZ,IBSEQNO)	; Place IB Action on hold?
	;         Input:        X -- Zeroth node of IB Action
	;                     IBN -- ien of IB Action
	;                   IBDUZ -- User ID
	;                 IBSEQNO -- 1 (New Action), 3 (Update Action)
	;         Returns:      1 -- Yes, 0 -- No
	;
	N DFN,IBINS,IBINDT,IBOUTP,HOLD,IBHOLDP,IBDUZ,I
	S IBHOLDP=$P($G(^IBE(350.9,1,1)),"^",20),DFN=+$P(X,"^",2)
	;
	I $P(X,"^",5)=8 G HOLDQ ; action is already on hold
	I '$P($G(^IBE(350.1,+$P(X,"^",3),0)),"^",10) G HOLDQ ; action can't be placed on hold
	;
	; - see if patient has insurance on Event date
	S IBINDT=$P($G(^IB(+$P(X,"^",16),0)),"^",17),IBOUTP=1
	D ^IBCNS S:IBHOLDP HOLD=IBINS
	;
	; - generate bulletin if patient has insurance, bulletin not suppressed
	I IBINS,'$P($G(^IBE(350.9,1,0)),"^",15) D ^IBRBUL
	;
	; - update action to 'Hold' if parameter is set and vet has insurance
	I IBHOLDP,IBINS S DIE="^IB(",DA=IBN,DR=".05////8" D ^DIE,UP3^IBR:IBSEQNO=3 K DA,DIE,DR,IBI,IBJ
	;
HOLDQ	Q +$G(HOLD)

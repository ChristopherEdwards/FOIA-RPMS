IBCNSP0	;ALB/AAS - INSURANCE MANAGEMENT - EXPANDED POLICY  ; 05-MAR-1993
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
CONTACT	; -- Insurance Contact Information
	N OFFSET,START
	S START=22,OFFSET=42
	N IBTRC,IBTRCD,IBTCOD
	S IBTCOD=$O(^IBE(356.11,"ACODE",85,0))
	;
	S IBTRC=0,IBTRCD=""
	F  S IBTRC=$O(^IBT(356.2,"D",DFN,IBTRC)) Q:'IBTRC  D
	.Q:$P($G(^IBT(356.2,+IBTRC,1)),"^",5)'=IBCDFN  ; must be same policy
	.Q:$P($G(^IBT(356.2,+IBTRC,0)),"^",4)'=IBTCOD  ; must be ins. ver. type
	.S IBTRCD=$G(^IBT(356.2,+IBTRC,0))
	.;S IBLCNT=IBLCNT+1
	.;D SET(START
	;
	D SET(START,OFFSET," Insurance Contact (last) ",IORVON,IORVOFF)
	D SET(START+1,OFFSET," Person Contacted: "_$$EXPAND^IBTRE(356.2,.06,$P(IBTRCD,"^",6)))
	D SET(START+2,OFFSET,"Method of Contact: "_$$EXPAND^IBTRE(356.2,.17,$P(IBTRCD,"^",17)))
	D SET(START+3,OFFSET,"  Contact's Phone: "_$$EXPAND^IBTRE(356.2,.07,$P(IBTRCD,"^",7)))
	D SET(START+4,OFFSET,"    Call Ref. No.: "_$$EXPAND^IBTRE(356.2,.09,$P(IBTRCD,"^",9)))
	D SET(START+4,OFFSET,"     Contact Date: "_$$EXPAND^IBTRE(356.2,.01,$P(IBTRCD,"^")))
	Q
	;
POLICY	; -- Policy Region
	; -- if pointer to policy file exists get data from policy file
	N OFFSET,START,IBP
	S START=1,OFFSET=2
	D SET(START,OFFSET," Plan Information ",IORVON,IORVOFF)
	D SET(START+1,OFFSET,"   Is Group Plan: "_$S($P(IBCPOLD,"^",2)=1:"YES",1:"NO"))
	D SET(START+2,OFFSET,"      Group Name: "_$P(IBCPOLD,"^",3))
	D SET(START+3,OFFSET,"    Group Number: "_$P(IBCPOLD,"^",4))
	D SET(START+4,OFFSET,"    Type of Plan: "_$P($G(^IBE(355.1,+$P(IBCPOLD,"^",9),0)),"^"))
	; -- in case pointer is missing
	I '$G(^IBA(355.3,+$P(IBCDFND,"^",18),0)) D
	.D SET(START+1,OFFSET,"Insurance Number: "_$P(IBCDFND,"^",2))
	.D SET(START+2,OFFSET,"      Group Name: "_$P(IBCDFND,"^",15))
	.D SET(START+3,OFFSET,"    Group Number: "_$P(IBCDFND,"^",3))
	.Q
	Q
	;
INS	; -- Insurance Co. Region
	N OFFSET,START,IBADD,IBCDFNDA
	S START=1,OFFSET=45
	D SET(START,OFFSET," Insurance Company ",IORVON,IORVOFF)
	D SET(START+1,OFFSET,"   Company: "_$P($G(^DIC(36,+IBCDFND,0)),"^"))
	S IBCDFNDA=$G(^DIC(36,+IBCDFND,.11))
	G:IBCDFNDA="" INSQ
	D SET(START+2,OFFSET,"    Street: "_$P(IBCDFNDA,"^")) S IBADD=1
	I $P(IBCDFNDA,"^",2)'="" D SET(START+3,OFFSET,"  Street 2: "_$P(IBCDFNDA,"^",2)) S IBADD=2
	I $P(IBCDFNDA,"^",3)'="" D SET(START+4,OFFSET,"  Street 3: "_$P(IBCDFNDA,"^",3)) S IBADD=3
	D SET(START+2+IBADD,OFFSET,"City/State: "_$E($P(IBCDFNDA,"^",4),1,15)_$S($P(IBCDFNDA,"^",4)="":"",1:", ")_$P($G(^DIC(5,+$P(IBCDFNDA,"^",5),0)),"^",2)_" "_$E($P(IBCDFNDA,"^",6),1,5))
	;
INSQ	Q
	;
BLANK(LINE)	; -- Build blank line
	D SET^VALM10(.LINE,$J("",80))
	Q
	;
SET(LINE,COL,TEXT,ON,OFF)	; -- set display info in array
	D:'$D(@VALMAR@(LINE,0)) BLANK(.LINE)
	D SET^VALM10(.LINE,$$SETSTR^VALM1(.TEXT,@VALMAR@(LINE,0),.COL,$L(TEXT)))
	D:$G(ON)]""!($G(OFF)]"") CNTRL^VALM10(.LINE,.COL,$L(TEXT),$G(ON),$G(OFF))
	W:'(LINE#5) "."
	Q

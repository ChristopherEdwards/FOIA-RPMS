IBCNSP	;ALB/AAS - INSURANCE MANAGEMENT - EXPANDED POLICY ; 05-MAR-1993
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
%	;
EN	; -- main entry point for IBCNS EXPANDED POLICY
	K VALMQUIT,IBPPOL
	S IBTOP="IBCNSP"
	D EN^VALM("IBCNS EXPANDED POLICY")
	Q
	;
HDR	; -- header code
	S VALMHDR(1)="Expanded Policy Information for: "_$E($P(^DPT(DFN,0),"^"),1,20)
	S VALMHDR(2)=$E($P($G(^DIC(36,+$P(IBPPOL,"^",5),0)),"^"),1,20)_" Insurance Company"
	Q
	;
INIT	; -- init variables and list array
	K VALMQUIT
	S VALMCNT=0,VALMBG=1
	I '$D(IBPPOL) D PPOL Q:$D(VALMQUIT)
	K ^TMP("IBCNSVP",$J)
	D BLD,HDR
	Q
	;
BLD	; -- list builder
	K ^TMP("IBCNSVP",$J),^TMP("IBCNSVPDX",$J)
	D KILL^VALM10()
	F I=1:1:35 D BLANK(.I)
	S VALMCNT=35
	N IBCDFND,IBCDFND1,IBCDFND2
	S IBCDFND=$G(^DPT(DFN,.312,$P(IBPPOL,"^",4),0)),IBCNS=+IBCDFND
	S IBCDFND1=$G(^DPT(DFN,.312,$P(IBPPOL,"^",4),1))
	S IBCDFND2=$G(^DPT(DFN,.312,$P(IBPPOL,"^",4),2))
	S IBCPOL=+$P(IBCDFND,"^",18),IBCNS=+IBCDFND,IBCDFN=$P(IBPPOL,"^",4)
	S IBCPOLD=$G(^IBA(355.3,+$P(IBCDFND,"^",18),0))
	S IBCPOLD1=$G(^IBA(355.3,+$P(IBCDFND,"^",18),1))
	D POLICY^IBCNSP0,INS^IBCNSP0,CONTACT^IBCNSP0,EFFECT,UR,COMMENT,EMP,^IBCNSP01
	Q
	;
COMMENT	; -- Comment region
	N START,OFFSET
	S START=30,OFFSET=2
	D SET(START,OFFSET," Comment -- Patient Policy ",IORVON,IORVOFF)
	D SET(START+1,OFFSET,$S($P(IBCDFND1,"^",8)="":"None",1:$P(IBCDFND1,"^",8)))
	D SET(START+3,OFFSET," Comment -- Group Plan ",IORVON,IORVOFF)
	S (IBLCNT,IBI)=0 F  S IBI=$O(^IBA(355.3,+IBCPOL,11,IBI)) Q:IBI<1  D
	.S IBLCNT=IBLCNT+1
	.D SET(START+3+IBLCNT,OFFSET,"  "_$E($G(^IBA(355.3,+IBCPOL,11,IBI,0)),1,80))
	S IBLCNT=IBLCNT+1 D SET(START+3+IBLCNT,OFFSET,"  ")
	Q
	;
EFFECT	; -- Effective date region
	N START,OFFSET
	S START=9,OFFSET=45
	D SET(START,OFFSET," Effective Dates ",IORVON,IORVOFF)
	D SET(START+1,OFFSET," Effective Date: "_$$DAT1^IBOUTL($P(IBCDFND,"^",8)))
	D SET(START+2,OFFSET,"Expiration Date: "_$$DAT1^IBOUTL($P(IBCDFND,"^",4)))
	Q
	;
UR	; -- UR of insurance region
	N START,OFFSET
	S START=9,OFFSET=2
	D SET(START,OFFSET," Utilization Review Info ",IORVON,IORVOFF)
	D SET(START+1,OFFSET,"         Require UR: "_$$EXPAND^IBTRE(355.3,.05,$P(IBCPOLD,"^",5)))
	D SET(START+2,OFFSET,"   Require Pre-Cert: "_$$EXPAND^IBTRE(355.3,.06,$P(IBCPOLD,"^",6)))
	D SET(START+3,OFFSET,"   Exclude Pre-Cond: "_$$EXPAND^IBTRE(355.3,.07,$P(IBCPOLD,"^",7)))
	D SET(START+4,OFFSET,"Benefits Assignable: "_$$EXPAND^IBTRE(355.3,.08,$P(IBCPOLD,"^",8)))
	Q
EMP	; -- Insurance Employer Region
	N OFFSET,START,IBADD
	S START=15,OFFSET=40
	D SET(START,OFFSET," Subscriber's Employer Information ",IORVON,IORVOFF)
	D SET(START+1,OFFSET,"Claims to Employer: "_$S(+IBCDFND2:"Yes, Send to Employer",1:"No, Send to Insurance Company"))
	;I +IBCDFND2 W !!,"If ROI applies, make sure current consent is signed.",!! D PAUSE^VALM1
	;
	D SET(START+2,OFFSET,"           Company: "_$P(IBCDFND2,"^",9))
	D SET(START+3,OFFSET,"            Street: "_$P(IBCDFND2,"^",2)) S IBADD=1
	I $P(IBCDFND2,"^",3)'="" D SET(START+4,OFFSET,"          Street 2: "_$P(IBCDFND2,"^",3)) S IBADD=2
	I $P(IBCDFND2,"^",4)'="" D SET(START+5,OFFSET,"          Street 3: "_$P(IBCDFND2,"^",4)) S IBADD=3
	D SET(START+3+IBADD,OFFSET,"        City/State: "_$E($P(IBCDFND2,"^",5),1,15)_$S($P(IBCDFND2,"^",5)="":"",1:", ")_$P($G(^DIC(5,+$P(IBCDFND2,"^",6),0)),"^",2)_" "_$E($P(IBCDFND2,"^",7),1,5))
	D SET(START+4+IBADD,OFFSET,"             Phone: "_$P(IBCDFND2,"^",8))
	;
EMPQ	Q
	; 
HELP	; -- help code
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	; -- exit code
	K IBPPOL,VALMQUIT,IBCNS,IBCPOL,IBCPOLD,IBCPOLD1,IBCDFND,IBCDFND1,IBCDFND2
	D CLEAN^VALM10,CLEAR^VALM1
	Q
	;
EXPND	; -- expand code
	Q
	;
PPOL	; -- select patient, select policy
	I '$D(DFN) D  G:$D(VALMQUIT) PPOLQ
	.S DIC="^DPT(",DIC(0)="AEQMN" D ^DIC
	.S DFN=+Y
	I $G(DFN)<1 S VALMQUIT="" G PPOLQ
	;
	I '$O(^DPT(DFN,.312,0)) W !!,"Patient doesn't have Insurance" K DFN G PPOL
	;
	S DIC="^DPT("_DFN_",.312,",DIC(0)="AEQMN",DIC("A")="Select Patient Policy: "
	D ^DIC I +Y<1 S VALMQUIT=""
	G:$D(VALMQUIT) PPOLQ
	S IBPPOL="^2^"_DFN_"^"_+Y_"^"_$G(^DPT(DFN,.312,+Y,0))
PPOLQ	K DIC Q
	;
BLANK(LINE)	; -- Build blank line
	D SET^VALM10(.LINE,$J("",80))
	Q
	;
SET(LINE,COL,TEXT,ON,OFF)	; -- set display info in array
	I '$D(@VALMAR@(LINE,0)) D BLANK(.LINE) S VALMCNT=$G(VALMCNT)+1
	D SET^VALM10(.LINE,$$SETSTR^VALM1(.TEXT,@VALMAR@(LINE,0),.COL,$L(TEXT)))
	D:$G(ON)]""!($G(OFF)]"") CNTRL^VALM10(.LINE,.COL,$L(TEXT),$G(ON),$G(OFF))
	W:'(LINE#5) "."
	Q

IBCNSM4	;ALB/AAS - INSURANCE MANAGEMENT, LIST MANAGER INIT ROUTINE ; 21-OCT-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	; -- main entry point
EN	;
	D DT^DICRW
	K XQORS,VALMEVL,DFN,IBFASTXT
	I '$G(IBVIEW) D EN^VALM("IBCNS PATIENT INSURANCE")
	I $G(IBVIEW) D EN^VALM("IBCNS VIEW PAT INS")
ENQ	K DFN,IBFASTXT,IBEXP1,IBEXP2,IBCDFN,IBFILE,IBI,IBLCNT,IBN,IBCGN,IBCNT,IBDA,IBDIF,IBPPOL,IBDUZ,IBCPOL,IBCDFND1,IBCDFN,IBCNS,IBYE
	Q
	;
	;
INIT	; -- set up inital variables
	S U="^",VALMCNT=0,VALMBG=1
	K ^TMP("IBNSM",$J),^TMP("IBNSMDX",$J)
	D:'$D(DFN) PAT G:$D(VALMQUIT) INITQ
	D BLD^IBCNSM
	;
INITQ	Q
	;
	;
PAT	; -- select patient you are working with
	S DIC(0)="AEQMN",DIC="^DPT(" D ^DIC I +Y<1 S VALMQUIT="" Q
	S DFN=+Y
	Q
	;
HDR	; -- screen header for initial screen
	D PID^VADPT
	S VALMHDR(1)="Insurance Management for Patient: "_$E($P($G(^DPT(DFN,0)),"^"),1,20)_" "_$E($G(^(0)),1)_VA("BID")
	S VALMHDR(2)=" "
	Q
	;
FNL	; -- exit and clean up
	K ^TMP("IBNSM",$J),^TMP("IBNSMDX",$J)
	K IBFASTXT
	D CLEAN^VALM10
	Q

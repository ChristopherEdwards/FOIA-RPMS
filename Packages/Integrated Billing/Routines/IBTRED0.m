IBTRED0	;ALB/AAS - EXPAND/EDIT CLAIMS TRACKING ENTRY - CONT. ; 01-JUL-1993
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	I '$G(IBTRN)!($G(IORVON)="") G ^IBTRED
	D CLIN,BILL,PRE
	Q
	;
CLIN	; -- clinical data region
	N OFFSET,START,IBICD
	S START=7,OFFSET=2
	;
CLIN1	N IBETYP S IBETYP=$$TRTP^IBTRE1(IBTRN) I 'IBETYP!(IBETYP>2) Q
	D SET^IBCNSP(START,OFFSET," Clinical Information ",IORVON,IORVOFF)
	I "12"[IBETYP D @IBETYP
	Q
	;
1	; -- inpatient clinical data
	;D SET^IBCNSP(START+1,OFFSET,"      Provider: "_$E($P($G(VAIN(2)),"^",2),1,15))
	D SET^IBCNSP(START+1,OFFSET,"      Provider: "_$E($$APROV^IBTRE6(IBTRN),1,15))
	D SET^IBCNSP(START+2,OFFSET,"Admitting Diag: "_$E($$ADMDIAG^IBTRE6(IBTRN),1,23))
	D SET^IBCNSP(START+3,OFFSET,"  Primary Diag: "_$E($$PDIAG^IBTRE6(IBTRN),1,23))
	D LISTP^IBTRE6(IBTRN,.IBICD)
	D SET^IBCNSP(START+4,OFFSET," 1st Procedure: "_$E($$PROC^IBTRE6(+$G(IBICD(1)),1),1,23))
	D SET^IBCNSP(START+5,OFFSET," 2nd Procedure: "_$E($$PROC^IBTRE6(+$G(IBICD(2)),1),1,23))
	Q
	;
2	; -- outpatient clinic data
	S IBOE=$P(IBTRND,"^",4)
	I +IBOE<1 D SET^IBCNSP(START+1,OFFSET,"  No Outpatient Encounter Found") Q
	N SDDXY,SDPRY D SET^SDCO3(+IBOE) S IBPCNT=SDCNT D SET^SDCO4(IBOE) S IBDCNT=SDCNT
	D SET^IBCNSP(START+1,OFFSET,"      Provider: "_$E($P($G(^VA(200,+$P($G(SDPRY(1)),"^",2),0)),"^"),1,23)) ;sdd(409.44
	D SET^IBCNSP(START+2,OFFSET,"      Provider: "_$E($P($G(^VA(200,+$P($G(SDPRY(2)),"^",2),0)),"^"),1,23)) ;sdd(409.44
	D SET^IBCNSP(START+3,OFFSET,"     Diagnosis: "_$E($$DIAG^IBTRE6(+$P($G(SDDXY(1)),"^",2),1),1,23)) ;sdd(409.43
	D SET^IBCNSP(START+4,OFFSET,"     Diagnosis: "_$E($$DIAG^IBTRE6(+$P($G(SDDXY(2)),"^",2),1),1,23)) ;sdd(409.43
	D SET^IBCNSP(START+5,OFFSET,"  Special Cond: "_$$ENCL^IBTRED(IBOE))
	Q
	;
BILL	; -- billing information region
	N OFFSET,START
	S START=15,OFFSET=2
	S IBDGCR=$G(^DGCR(399,+$P(IBTRND,"^",11),0)),IBDGCRU1=$G(^("U1"))
	S IBAMNT=$$BILLD^IBTRED1(IBTRN)
	D SET^IBCNSP(START,OFFSET+20," Billing Information ",IORVON,IORVOFF)
	D SET^IBCNSP(START+1,OFFSET,"    Episode Billable: "_$S(+$P(IBTRND,"^",19):"NO",1:"YES"))
	D SET^IBCNSP(START+2,OFFSET," Non-Billable Reason: "_$E($P($G(^IBE(356.8,+$P(IBTRND,"^",19),0)),"^"),1,20))
	D SET^IBCNSP(START+3,OFFSET,"      Next Bill Date: "_$$DAT1^IBOUTL($P(IBTRND,"^",17)))
	D SET^IBCNSP(START+4,OFFSET,"Work. Comp/OWCP/Tort: "_$E($$EXPAND^IBTRE(356,.12,$P(IBTRND,"^",12)),1,14))
	D SET^IBCNSP(START+5,OFFSET,"        Initial Bill: "_$P(IBDGCR,"^"))
	D SET^IBCNSP(START+6,OFFSET,"         Bill Status: "_$E($$EXPAND^IBTRE(399,.13,$P(IBDGCR,"^",13)),1,14))
	I +$P(IBTRND,"^",19) D SET^IBCNSP(START+7,OFFSET," Additional Comment: "_$E($P(IBTRND1,"^",8),1,60))
	D BILL1
	Q
	;
BILL1	; -- other side of billing info
	N OFFSET,START
	S START=15,OFFSET=45
	D SET^IBCNSP(START+1,OFFSET,"       Total Charges: $ "_$J($P(IBAMNT,"^"),8))
	D SET^IBCNSP(START+2,OFFSET,"Estimated Recv (Pri): $ "_$J($P(IBTRND,"^",21),8))
	D SET^IBCNSP(START+3,OFFSET,"Estimated Recv (Sec): $ "_$J($P(IBTRND,"^",22),8))
	D SET^IBCNSP(START+4,OFFSET,"Estimated Recv (ter): $ "_$J($P(IBTRND,"^",23),8))
	D SET^IBCNSP(START+5,OFFSET,"  Means Test Charges: $ "_$J($P(IBTRND,"^",28),8))
	D SET^IBCNSP(START+6,OFFSET,"         Amount Paid: $ "_$J($P(IBAMNT,"^",2),8))
	Q
	;
PRE	; -- pre-certification region
	N OFFSET,START,IBTRC,IBTRCD
	;S START=15,OFFSET=45
	S START=1,OFFSET=45
	D SET^IBCNSP(START,OFFSET," Treatment Authorization Info ",IORVON,IORVOFF)
	D SET^IBCNSP(START+1,OFFSET,"   Authorization Number: "_$$PRECRT^IBTRC1(IBTRN))
	D SET^IBCNSP(START+2,OFFSET,"      No. Days Approved: "_$J($$DAY^IBTRE(IBTRN),3))
	D SET^IBCNSP(START+3,OFFSET,"Second Opinion Required: "_$$EXPAND^IBTRE(356,.14,$P(IBTRND,"^",14)))
	D SET^IBCNSP(START+4,OFFSET,"Second Opinion Obtained: "_$$EXPAND^IBTRE(356,.15,$P(IBTRND,"^",15)))
	Q
	;
SPCOND(IBTRN)	; -- see if sc or other special condition for patient
	; -- if inpt. look in ptf. if opt look opt encounter file
	;
	Q ""

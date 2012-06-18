IBTRKR31	;ALB/AAS - CLAIMS TRACKING - DBLCHK RX FILLS ; 13-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	; -- Double check rx data routine
DBLCHK(IBTRN)	; -- double check rx before billing, input tracking id
	N IBX,IBFILL,IBFILLD,IBRXN,IBTRND,IBRMARK,IBRXSTAT,IBDEA,IBDRUG,IBRXDATA,X,Y
	S IBX=0
	S IBTRND=$G(^IBT(356,+IBTRN,0)) I IBTRND="" G DBLCHKQ
	S IBRXN=$P(IBTRND,"^",8),IBFILL=$P(IBTRND,"^",10)
	S IBFILLD=$G(^PSRX(+IBRXN,1,+IBFILL,0))
	;
	I IBFILL<1!(IBRXN<1) S IBRMARK="INVALID PRESCRIPTION ENTRY" G DBLCHKQ
	;
	S IBRXDATA=$G(^PSRX(IBRXN,0)),IBRXSTAT=$P(IBRXDATA,"^",15)
	S DFN=+$P(IBRXDATA,"^",2),IBDT=+IBFILLD
	I IBDT=$P($O(^DPT(DFN,"S",(IBDT-.00001))),".") S IBRMARK="REFILL ON VISIT DATE" G DBLCHKQ
	;
	; -- check rx status (not  deleted)
	I IBRXSTAT=13 S IBRMARK="PRESCRIPTION DELETED" G DBLCHKQ
	;
	; -- Version 6 and refill not released or returned to stock
	I +$G(^PS(59.7,1,49.99))'<6,'$P(IBFILLD,"^",18) S IBRMARK=4 G DBLCHKQ
	I $P(IBFILLD,"^",16) S IBRMARK="PRESCRIPTION NOT RELEASED" G DBLCHKQ
	;
	; -- check drug (not investigational, supply, or over the counter drug
	S IBDRUG=$P(IBRXDATA,"^",6)
	S IBDEA=$P($G(^PSDRUG(+$P(IBRXDATA,"^",6),0)),"^",3)
	I IBDEA["I"!(IBDEA["S")!(IBDEA["9") S IBRMARK="DRUG NOT BILLABLE" G DBLCHKQ ; investigational drug, supply or otc
	;
	S IBX=1
	;
DBLCHKQ	I $G(IBRMARK) D
	.S IBRMARK=$O(^IBE(356.8,"B",IBRMARK,0)) I 'IBRMARK S IBRMARK=999
	.N DA,DR,DIC,DIE
	.L +^IBT(356,+IBTRN):5 I '$T Q
	.S DA=IBTRN,DIE="^IBT(356,",DR=".19////"_IBRMARK
	.D ^DIE
	.L -^IBT(356,+IBTRN)
	Q IBX
	;
	;
BULL	; -- send bulletin
	;
	S XMSUB="Rx Refills added to Claims Tracking Complete"
	S IBT(1)="The process to automatically add Rx Refills has successfully completed."
	S IBT(1.1)=""
	S IBT(2)="              Start Date: "_$$DAT1^IBOUTL(IBTSBDT)
	S IBT(3)="                End Date: "_$$DAT1^IBOUTL(IBTSEDT)
	I $D(IBMESS) S IBT(3.1)=IBMESS
	S IBT(4)=""
	S IBT(5)="  Total Rx fills checked: "_$G(IBCNT)
	S IBT(6)="Total NSC Rx fills Added: "_$G(IBCNT1)
	S IBT(7)=" Total SC Rx fills Added: "_$G(IBCNT2)
	S IBT(8)=""
	S IBT(9)="*The fills added as SC require determination and editing to be billed"
	D SEND
BULLQ	Q
	;
SEND	S XMDUZ="INTEGRATED BILLING PACKAGE",XMTEXT="IBT("
	K XMY S XMN=0
	S XMY(DUZ)=""
	D ^XMD
	K X,Y,IBI,IBT,IBGRP,XMDUZ,XMTEXT,XMY,XMSUB
	Q

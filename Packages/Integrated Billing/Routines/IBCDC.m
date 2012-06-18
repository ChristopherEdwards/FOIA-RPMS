IBCDC	;ALB/ARH - AUTOMATED BILLER (CLEAN-UP) ; 9/5/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	I $D(^TMP("IBEABD",$J)) D SEABD
	I $D(^TMP("IBCE",$J)) D SETCOMM^IBCDE
	I $D(^TMP("IBILL",$J)) D SCTB
	Q
	;
SEABD	;reset EABD on events
	;^TMP("IBEABD",$J,IBTRN,IBDT(=new date))
	I $D(^TMP("IBEABD",$J)) S IBTRN=0 F  S IBTRN=$O(^TMP("IBEABD",$J,IBTRN)) Q:'IBTRN  D
	. S IBEABD=$O(^TMP("IBEABD",$J,IBTRN,"")) D EABD(IBTRN,IBEABD)
	K IBTRN,IBEABD
	Q
	;
EABD(DA,EABD)	; set EABD (356,.17) of claims tracking entry DA to the value in EABD
	N X,Y,DIE,DR,DTOUT Q:'$D(^IBT(356,+$G(DA),0))  I '$G(EABD) S EABD="@"
	S DIE="^IBT(356,",DR=".17////"_EABD D ^DIE
	Q
	;
SCTB	;set Claims Tracking/Bill file (356,.17) entries  (causes .17 set)
	;^TMP("IBILL",$J,IBTRN,IBIFN)
	I $D(^TMP("IBILL",$J)) S IBTRN=0 F  S IBTRN=$O(^TMP("IBILL",$J,IBTRN)) Q:'IBTRN  D
	. S IBIFN=0 F  S IBIFN=$O(^TMP("IBILL",$J,IBTRN,IBIFN)) Q:'IBIFN  D CTB(IBTRN,IBIFN)
	K IBTRN,IBIFN
	Q
	;
CTB(TRN,IFN)	; set Claims Tracking/Bill file (356.399) entries which also sets (356,.17)
	N X,Y,DIE,DR,DTOUT I '$G(TRN)!'$G(IFN) Q
	I '$D(^IBT(356.399,"ACB",TRN,IFN)) S DIC="^IBT(356.399,",DIC(0)="L",DIC("DR")=".02////"_IFN,X=TRN K DD,DO D FILE^DICN
	K X,Y,DIC
	Q
	;
BSTAT(IFN)	; updates certain files/fields based on the status of the bill passed in
	;SHOULD BE CALLED BY ANY ROUTINE THAT CAUSES A BILLS STATUS TO CHANGE TO CANCELED OR PRINTED
	;if bill status is canceled: deletes bill comments (362.1) and deletes the initial bill number from (356,.11)
	;if bill is printed: deletes bills comments (362.1)
	;NOTE THAT ENTRIES IN 356.399 ARE NOT DELETED IF BILL IS CANCELLED, just the initial bill number in 356
	N X,Y,IBI,IBX,IBY,TRN,STAT S IFN=+$G(IFN),STAT=$G(^DGCR(399,IFN,0)),STAT=+$P(STAT,U,13) I STAT<4 G BSTATQ
	I STAT=7 S IBX=$$FBILL(IFN) I +IBX F IBI=1:1 S TRN=$P(IBX,U,IBI) Q:'TRN  D  ;modifiy claims tracking entry
	. I $P($G(^IBT(356,TRN,0)),U,11)=IFN S DIE="^IBT(356,",DA=TRN,DR=".11///@" D ^DIE K DIE,DA,DR ;delete initial bill #
	I STAT>3 S IBX=$$FINDB^IBCDE(IFN) I +IBX F IBI=1:1 S IBY=$P(IBX,U,IBI) Q:'IBY  D
	. S DIK="^IBA(362.1,",DA=+IBY D ^DIK K DIK,DA ; delete comment entries for bill
BSTATQ	Q
	;
COPYB(IFN,IFN1)	;function for copy a bill, adds comment to comment file (362.1) for bill and event
	;and adds an entry to the event/bill file (356.399)  (IFN is old bill, IFN1 new bill)  nothing returned
	N X,Y,IBX1,IBX,IBY,COMM,IBI S IFN=+$G(IFN),IBX=$G(^DGCR(399,IFN,0)) I IBX="" G COPYBE
	S COMM="Copied from bill "_$P(IBX,U,1) S IBX=$$FBILL(IFN) I 'IBX G COPYBE
	F IBI=1:1 S IBY=$P(IBX,U,IBI) Q:'IBY  D CTB(IBY,IFN1) S IBX1=$$COMM1^IBCDE(IBY,IFN1) I +IBX1 D COMM2^IBCDE(IBX1,COMM)
COPYBE	Q
	;
FBILL(IFN)	;returns all events associated with a bill (356.399), string of event IFN's separated by "^"
	N X,Y S X="",IFN=+$G(IFN) I '$D(^DGCR(399,IFN,0)) G FBILLE
	S Y=0 F  S Y=$O(^IBT(356.399,"C",IFN,Y)) Q:'Y  S X=X_+$G(^IBT(356.399,Y,0))_U
FBILLE	Q X

IBARX1	;ALB/AAS - INTEGRATED BILING, PHARMACY COPAY INTERFACE (CONT.) ; 21-FEB-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;  - process 1 rx entry and accumulate totals
	;
RX	I $P(IBX,"^")'?1.N1":"1.N.ANP S Y="-1^IB012" G RXQ
	I $P(IBX,"^",2)<1 S Y="-1^IB013" G RXQ
	;
	D BDESC
	;
	S DA=IBATYP D COST^IBAUTL S IBCHRG=$P(IBX,"^",2)*X1,IBTOTL=IBTOTL+IBCHRG
	S IBWHER=2
	D ADD^IBAUTL
	I +Y<1 G RXQ
	S IBPARNT=$S($D(IBPARNT):IBPARNT,1:IBN)
	S $P(^IB(IBN,1),"^",1)=IBDUZ,$P(^IB(IBN,0),"^",2,13)=DFN_"^"_IBATYP_"^"_$P(IBX,"^")_"^2^"_$P(IBX,"^",2)_"^"_IBCHRG_"^"_IBDESC_"^"_IBPARNT_"^^"_IBIL_"^"_IBTRAN_"^"_IBFAC
	K IBPARNT,^IB("AC",1,IBN) ;S ^IB("AC",2,IBN)=""
	D INDEX
	S IBSAVY(IBJ)=IBN_"^"_IBCHRG_"^"_IBIL
	S:'$D(IBNOS) IBNOS="" S IBNOS=IBN_"^"_IBNOS
RXQ	Q
	;
CANRX	;  - ibx = ibn for parent entry
	;  - ibn = new cancellation entry
	S IBY(IBJ)=1
	I '$D(^IBE(350.3,+$P(IBX,"^",2),0)) S (Y,IBY(IBJ))="-1^IB020" G CANRXQ
	I '$D(^IB(+IBX,0)) S (Y,IBY(IBJ))="-1^IB021" G CANRXQ
	S IBND=^IB(+IBX,0)
	S IBCRES=$P(IBX,"^",2)
	;  -find most recent entry for parent ibx
	;  -if status isn't an update or new, error already cancelled?
	D LAST I IBLAST'=IBPARNT,$D(^IB(IBLAST,0)),$P(^IBE(350.1,$P(^IB(IBLAST,0),"^",3),0),"^",5)=2 S (Y,IBY(IBJ))="-1^IB026^ Ref. No: "_+^IB(+IBLAST,0) G CANRXQ ;already cancelled
	;
	S IBPARNT=$P(IBND,"^",9) I '$D(^IB(IBPARNT,0)) S (Y,IBY(IBJ))="-1^IB027" G CANRXQ
	S IBATYP=$P(^IBE(350.1,$P(IBND,"^",3),0),"^",6) ;cancellation action type for parent
	I '$D(^IBE(350.1,+IBATYP,0)) S (Y,IBY(IBJ))="-1^IB022" G CANRXQ
	S IBSEQNO=$P(^IBE(350.1,+IBATYP,0),"^",5) I 'IBSEQNO S (Y,IBY(IBJ))="-1^IB023" G CANRXQ
	S IBIL=$P(IBND,"^",11) I IBIL="" S (Y,IBY(IBJ))="-1^IB024" G CANRXQ
	S IBUNIT=$S($D(^IB(+IBLAST,0)):$P(^(0),"^",6),1:$P(IBND,"^",6)) I IBUNIT<1 S (Y,IBY(IBJ))="-1^IB025" G CANRXQ
	S DA=IBATYP D COST^IBAUTL S IBCHRG=IBUNIT*X1,IBTOTL=IBTOTL+IBCHRG
	S IBWHER=2
	D ADD^IBAUTL I +Y<1 S IBY(IBJ)=Y G CANRXQ
	S $P(^IB(IBN,1),"^",1)=IBDUZ,$P(^IB(IBN,0),"^",2,13)=DFN_"^"_IBATYP_"^"_$P(IBND,"^",4)_"^2^"_IBUNIT_"^"_IBCHRG_"^"_$P(IBND,"^",8)_"^"_IBPARNT_"^"_IBCRES_"^"_IBIL_"^^"_IBFAC
	K ^IB("AC",1,IBN) ;S ^IB("AC",2,IBN)=""
	D INDEX
	S Y(IBJ)=IBN_"^"_IBCHRG_"^"_IBIL
	S IBNOS=IBN
CANRXQ	Q
	;
BDESC	;  -return brief description
	N X,Y S IBDESC="",X=$P(IBX,"^")
	I $D(^IBE(350.1,IBATYP,20)) X ^(20) S IBDESC=X
	Q
LAST	;find last entry
	S IBLAST=""
	S IBPARNT=$P(^IB(+IBX,0),"^",9) I 'IBPARNT S IBPARNT=+IBX
	S IBLDT=$O(^IB("APDT",IBPARNT,"")) I +IBLDT F IBL=0:0 S IBL=$O(^IB("APDT",IBPARNT,IBLDT,IBL)) Q:'IBL  S IBLAST=IBL
	I IBLAST="" S IBLAST=IBPARNT
	Q
	;
INDEX	;cross-reference entry
	N X,Y
	S DA=IBN,DIK="^IB(" D IX^DIK
	K DIK Q
	;
SERV(Y)	; -- Service check for Pharmacy
	;    called by the screen in the input transform for the IB SERVICE/SECTION
	;    field of the PHARMACY SITE file.
	;    input = Y internal entry number in service section file
	;    output = 1 if okay to use (service matches) or 0 if not okay
	;
	; -- screen logic for field 1003 in file 59.9 should be 
	;    S DIC("S")="I $$SERV^IBARX1(+Y)"
	;
	Q $S('$G(Y):0,1:$D(^IBE(350.1,"ANEW",Y,1,1))&$D(^IBE(350.1,"ANEW",Y,1,2)))

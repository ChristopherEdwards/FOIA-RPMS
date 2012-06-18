IBARXEU3	;ALB/AAS - RX COPAY EXEMPTION PROCESS AR CANCELS ; 8-JAN-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
CANCEL	; -- cancel old ib and ar logic if going from non-exempt to exempt
	;    based on updated income testing.
	; -- called whenever adding an exemption
	;    requires event driver variables.
	;
	Q:'IBSTAT  ; non-exempt patient
	N IBDT,IBEDT,IBCODA,IBCODP,IBSITE,IBAFY,IBATYP,IBCANDT,IBCHRG,IBCRES,IBERR,IBFAC,IBIL,IBL,IBLAST,IBLDT,IBN,IBND,IBNN,IBNOW,IBPARNT,IBPARNT1,IBSEQNO,IBUNIT,LST
	;
	; -- if new code is income < pension (120) and no prior code or 
	;               prior code was no income data cancel charges
	;
	S IBCODP=$$ACODE^IBARXEU0(IBEVTP),IBCODA=$$ACODE^IBARXEU0(IBEVTA)
	I '$$NETW^IBARXEU1 G:IBCODA'=120 CANCELQ I $S(IBCODP="":0,IBCODP=210:0,1:1) G CANCELQ
	I $$NETW^IBARXEU1,$S(IBCODA=120:$S(IBCODP="":0,IBCODP=210:0,1:1),IBCODA=150:$S(IBCODP=130:0,1:1),1:1) G CANCELQ
	;
	; -- set begin and end dates
	S IBDT=+IBEVTP
	I IBDT<$$STDATE^IBARXEU S IBDT=$$STDATE^IBARXEU
	; -- if new exemption is most current, set begin date to dt, else set to exemption date
	S IBEDT=$S(+$$LST^IBARXEU0(DFN,DT)=+IBEVTA:DT,1:+IBEVTA)
	;
	; -- see if exemption prior to one being canceled same
	S LST=$$LST^IBARXEU0(DFN,+IBEVTP-.01)
	I +LST,$P(IBEVTP,"^",5)=$P(LST,"^",5) S IBDT=+LST
	D CANDT^IBARXEU4
	;
	; -- See if patient has any bills
	S X=$O(^IB("APTDT",DFN,(IBDT-.01))) I 'X!(X>(IBEDT+.9)) G CANCELQ
	;
	; -- cancel bills in IB
	D ARPARM^IBAUTL
	S IBBDT=$P(IBCANDT,"^")-.0001
	F  S IBBDT=$O(^IB("APTDT",DFN,IBBDT)) Q:'IBBDT!((IBEDT+.9)<IBBDT)  S IBN=0 F  S IBN=$O(^IB("APTDT",DFN,IBBDT,IBN)) Q:'IBN  D BILL
	;
	; -- cancel bills in AR
	Q:$P(IBCANDT,"^",2)<$P(IBCANDT,"^")  D ARCAN^IBARXEU4(DFN,IBSTAT,$P(IBCANDT,"^"),$P(IBCANDT,"^",2))
	;
CANCELQ	Q
	;
BILL	; -- process cancelling one bill
	S X=$G(^IB(IBN,0)) Q:X=""
	Q:+$P(X,"^",4)'=52  ;quit if not pharmacy co-pay
	;
	; -- find parent
	S IBPARNT=$P(X,"^",9)
	;
	S IBPARDT=$P($G(^IB(IBPARNT,1)),"^",2) ; get date of parent charge
	I $S(IBPARDT="":1,IBPARDT<IBDT:1,IBPARDT>(IBEDT+.9):1,1:0) Q  ; ignore charges started before or after date range
	;
	; -- get must recent ibaction
	S IBPARNT1=IBPARNT F  S IBPARNT1=$P($G(^IB(IBPARNT,0)),"^",9) Q:IBPARNT1=IBPARNT  S IBPARNT=IBPARNT1 ;gets parent of parents
	D LAST
	;
	Q:$P(^IBE(350.1,$P(^IB(IBLAST,0),"^",3),0),"^",5)=2  ;quit if already cancelled
	;
	S IBCRES=$O(^IBE(350.3,"B","RX COPAY INCOME EXEMPTION",0)) ; get cancellation reason
	;
	D CANRX
	Q
	;
CANRX	; -- do acutal cancellation without calling ar
	;    input :  iblast := last entry for parnt
	;             ibparnt := parent charge
	;             ibnd    := ^(0) node of iblast
	;
	;    returns: ibnn    := entry number of new node
	;
	N IBN
	S IBNN="" ;return new node in ibnn
	I $D(^IB(IBLAST,0)),$P(^IBE(350.1,$P(^IB(IBLAST,0),"^",3),0),"^",5)=2 G CANRXQ ;already cancelled
	S IBND=$G(^IB(+IBLAST,0)),IBDUZ=DUZ
	;
	S IBATYP=$P(^IBE(350.1,+$P($G(^IB(IBPARNT,0)),"^",3),0),"^",6) ;cancellation action type for parent
	I '$D(^IBE(350.1,+IBATYP,0)) G CANRXQ
	S IBSEQNO=$P(^IBE(350.1,+IBATYP,0),"^",5) I 'IBSEQNO G CANRXQ
	S IBIL=$P($G(^IB(IBPARNT,0)),"^",11)
	S IBUNIT=$S($P(IBND,"^",6):$P(IBND,"^",6),$D(^IB(IBPARNT,0)):$P(^(0),"^",6),1:0) I IBUNIT<1 G CANRXQ
	S DA=IBATYP D COST^IBAUTL S IBCHRG=IBUNIT*X1
	;
	D ADD^IBAUTL I +Y<1 G CANRXQ
	S $P(^IB(IBN,1),"^",1)=IBDUZ,$P(^IB(IBN,0),"^",2,13)=DFN_"^"_IBATYP_"^"_$P(IBND,"^",4)_"^11^"_IBUNIT_"^"_IBCHRG_"^"_$P(IBND,"^",8)_"^"_IBPARNT_"^"_IBCRES_"^"_IBIL_"^^"_IBFAC
	K ^IB("AC",1,IBN)
	S DA=IBN,DIK="^IB(" D IX^DIK
	S IBNN=IBN
	;
	; -- update parent to cancelled
	;    note: parent status=10, cancellation due to exemption reason only
	;          on charge cancelled so reports work right.
	S DIE="^IB(",DA=IBPARNT,DR=".05////10;.1////"_IBCRES D ^DIE K DIE,DA,DR
CANRXQ	Q
	;
LAST	; -- find most recent (the last) entry for a parent action
	S IBLAST=""
	S IBLDT=$O(^IB("APDT",IBPARNT,"")) I +IBLDT F IBL=0:0 S IBL=$O(^IB("APDT",IBPARNT,IBLDT,IBL)) Q:'IBL  S IBLAST=IBL
	I IBLAST="" S IBLAST=IBPARNT
	Q

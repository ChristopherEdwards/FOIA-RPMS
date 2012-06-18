IBAMTS2	;ALB/CPM - PROCESS UPDATED OUTPATIENT ENCOUNTERS ; 25-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
UPD	; Perform encounter update actions.
	;
	; - was check out deleted?
	I IBAST'=2,IBBST=2 S IBCRES=$S(IBAST=8:5,1:1)
	;
	; - see if checked out appt classifications were changed
	I IBAST=2,IBBST=2 D CLSF^IBAMTS1(1,.IBCLSF) S IBACT=$$CLUPD() G:'IBACT UPDQ D  I IBACT'=1 G UPDQ
	.I IBACT=1 S IBCRES=2 Q
	.I IBACT=2 N IBCLSF D NEW^IBAMTS1
	;
	; - cancel charge if there is a cancellation reason, and the billed
	; - charge was for the appointment that is no longer billable
	I '$G(IBCRES) G UPDQ
	I '$$LINK(IBOE,$S(IBEVT:IBEVT,1:IBEV0),IBBILLED) G UPDQ
	D CANC G:IBY<0 UPDQ
	;
	; - look for other billable visits if Category C
	I '$$BIL^DGMTUB(DFN,IBDT) G UPDQ
	S IBBILLED=0,IBD=IBDAT-.1
	F  S IBD=$O(^SCE("ADFN",DFN,IBD)) Q:'IBD!($P(IBD,".")'=IBDAT)  D  Q:IBBILLED
	.S IBOEN=0 F  S IBOEN=$O(^SCE("ADFN",DFN,IBD,IBOEN)) Q:'IBOEN  D  Q:IBBILLED
	..;
	..Q:IBOEN=IBOE  ; skip encounter that was just cancelled
	..S IBEVT=$G(^SCE(IBOEN,0)) Q:'IBEVT  ; no zeroth node
	..Q:$P(IBEVT,"^",12)'=2  ; not checked out
	..I $P(IBEVT,"^",10)=1 S IBBILLED=1 Q  ; C&P exam -- stop looking
	..Q:$P(IBEVT,"^",6)  ; skip child events
	..;
	..; - perform batch edit
	..S IBORG=+$P(IBEVT,"^",8),IBAPTY=+$P(IBEVT,"^",10)
	..I IBORG=3 S IBDISP=+$P($G(^DPT(DFN,"DIS",+$P(IBEVT,"^",9),0)),"^",7) Q:'IBDISP
	..Q:'$$CHKS^IBAMTS1
	..;
	..; - check classifications
	..S IBCLSF=$$ENCL(IBOEN)
	..I +IBCLSF!($P(IBCLSF,"^",2))!($P(IBCLSF,"^",4)) Q  ; care was related to ao/ir/ec
	..S IBSL="409.68:"_IBOEN ; set softlink
	..;
	..; - ready to bill another encounter
	..D BLD^IBAMTS1 S IBBILLED=1
	;
	;
UPDQ	K IBCLSF,IBACT,IBC,IBOEN,IBEVT
	Q
	;
CRES	; List of cancellation reasons
	;;CHECK OUT DELETED
	;;CLASSIFICATION CHANGED
	;;MT OP APPT NO-SHOW
	;;MT OP APPT CANCELLED
	;;RECD INPATIENT CARE
	;
LINK(IBOE,IBEVT,IBN)	; Was the billed charge for the current appointment?
	;  Input:     IBOE  --  Pointer to outpatient encounter in file #409.68
	;            IBEVT  --  Zeroth node of encounter in file #409.68
	;              IBN  --  Pointer to charge in file #350
	;  Output:       0  --  Charge was not for current appointment
	;                1  --  Charge was for current appointment
	I '$G(IBOE)!'$G(IBEVT)!'$G(IBN) G LINKQ
	N IBSL,Y S IBSL=$P($G(^IB(IBN,0)),"^",4)
	I +IBSL=44 S Y=$P(IBSL,";",1,2)=("44:"_$P(IBEVT,"^",4)_";S:"_+IBEVT) G LINKQ
	I +IBSL=409.68 S Y=IBSL=("409.68:"_IBOE)
LINKQ	Q +$G(Y)
	;
CLUPD()	; Examine changes in the classification.
	;  Output:    0  --  no changes
	;             1  --  changes require charges to be cancelled
	;             2  --  changes require appt to be billed
	;             3  --  [ec] cancel charge, create deferred charge
	;             4  --  [ec] pass deferred charge, disposition case
	N I,Y S Y=0
	I IBCLSF("BEFORE")=IBCLSF("AFTER") G CLUPDQ
	F I=1,2,4 I '$P(IBCLSF("BEFORE"),"^",I),$P(IBCLSF("AFTER"),"^",I) S Y=$S(I=4:3,1:1) G CLUPDQ
	F I=1,2,4 I $P(IBCLSF("BEFORE"),"^",I),'$P(IBCLSF("AFTER"),"^",I) S Y=$S(I=4:4,1:2) Q
CLUPDQ	Q Y
	;
CANC	; Determine cancellation reason and cancel charge
	;  Input variables:   IBCRES  --  Code for reason to be determined
	;                   IBBILLED  --  Charge to be cancelled
	S IBCRES=$P($T(CRES+IBCRES),";;",2),IBCRES=+$O(^IBE(350.3,"B",IBCRES,0))
	D CANCH^IBECEAU4(IBBILLED,IBCRES)
	Q
	;
ENCL(IBOE)	; Return classification results for an encounter.
	;  Input:    IBOE  --  Pointer to outpatient encounter in file #409.68
	;  Output:   ao^ir^sc^ec, where, for each piece,
	;                      1 - care was related to condition, and
	;                      0 (or null) - care not related to condition
	N CL,CLD,X,Y S Y=""
	S CL=0 F  S CL=$O(^SDD(409.42,"OE",+$G(IBOE),CL)) Q:'CL  S CLD=$G(^SDD(409.42,CL,0)) I CLD S $P(Y,"^",+CLD)=+$P(CLD,"^",3)
	Q Y

IBTUTL1	;ALB/AAS - CLAIMS TRACKING UTILITY ROUTINE ; 21-JUN-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
OPT(DFN,IBETYP,IBTDT,ENCTR,IBRMARK,IBVSIT)	; -- add outpatient care entries
	; -- input   dfn  := patient pointer to 2
	;          ibetyp := pointer to type entry in 356.6
	;          ibtdt  := episode date
	;          enctr  := pointer to opt. encounter file (optional)
	;        ibrmark  := text of reason not billable (optional)
	;         ibvsit  := pointer to visit file (optional)
	;
	N X,Y,DA,DR,DIE,DIC
	I $G(IBETYP) S IBETYP=$O(^IBE(356.6,"AC",2,0))
	S X=$O(^IBT(356,"APTY",DFN,IBETYP,IBTDT,0)) I X S IBTRN=X G OPTQ
	D ADDT^IBTUTL
	I '$G(ENCTR) I $P($G(^DPT(DFN,"S",IBTDT,0)),"^",20) S ENCTR=$P(^(0),"^",20)
	S DA=IBTRN,DIE="^IBT(356,"
	I IBTRN<1 G OPTQ
	L +^IBT(356,+IBTRN):10 I '$T G OPTQ
	S DR=".02////"_$G(DFN)_";.03////"_$G(IBVSIT)_";.04////"_$G(ENCTR)_";.06////"_+IBTDT_";.18////"_IBETYP_";.2////1;.24////"_$$INSURED^IBCNS1(DFN)_";1.01///NOW;1.02////"_DUZ_";.17////"_$$EABD^IBTUTL(IBETYP)
	I $G(IBRMARK)'="" S DR=DR_";.19///"_IBRMARK
	D ^DIE K DA,DR,DIE
	L -^IBT(356,+IBTRN)
OPTQ	Q
	;
REFILL(DFN,IBETYP,IBTDT,IBRXN,IBRXN1,IBRMARK)	; -- add refill
	; -- input   dfn   := patient pointer to 2
	;          ibetyp  := pointer to type entry in 356.6
	;          ibtdt   := episode date (refill date)
	;          ibrxn   := pointer to 52
	;          ibrxn1  := refill multiple entry
	;          ibrmark := non billable reason if unsure
	;
	N X,Y,DA,DR,DIE,DIC
	S X=$O(^IBT(356,"APTY",DFN,IBETYP,IBTDT,0)) I X S IBTRN=X G REFILLQ
	D ADDT^IBTUTL
	I IBTRN<1 G REFILLQ
	S DA=IBTRN,DIE="^IBT(356,"
	L +^IBT(356,+IBTRN):10 I '$T G REFILLQ
	S DR=".02////"_$G(DFN)_";.06////"_+IBTDT_";.08////"_IBRXN_";.1////"_IBRXN1_";.18////"_IBETYP_";.2////1;.24////"_$$INSURED^IBCNS1(DFN)_";1.01///NOW;1.02////"_DUZ_";.17////"_$$EABD^IBTUTL(IBETYP)
	I $G(IBRMARK)'="" S DR=DR_";.19///"_IBRMARK
	D ^DIE K DA,DR,DIE
	L -^IBT(356,+IBTRN)
REFILLQ	Q
	;
PRO(DFN,IBTDT,IBPRO,IBRMARK)	; -- add prosthetic entries
	; -- input   dfn  := patient pointer to 2
	;          ibetyp := pointer to type entry in 356.6
	;          ibtdt  := episode date
	;
	N X,Y,DA,DR,DIE,DIC,IBETYP
	;S IBETYP=$O(^IBE(356.6,"ACODE",4,0))
	S IBETYP=$O(^IBE(356.6,"AC",3,0)) ;prosthetics type
	S X=$O(^IBT(356,"APRO",IBPRO,0)) I X S IBTRN=X G PROQ
	D ADDT^IBTUTL
	I IBTRN<1 G PROQ
	S DA=IBTRN,DIE="^IBT(356,"
	L +^IBT(356,+IBTRN):10 I '$T G PROQ
	S DR=".02////"_$G(DFN)_";.06////"_+IBTDT_";.09////"_IBPRO_";.18////"_IBETYP_";.2////1;.24////"_$$INSURED^IBCNS1(DFN)_";1.01///NOW;1.02////"_DUZ_";.17////"_$$EABD^IBTUTL(IBETYP)
	I $G(IBRMARK)'="" S DR=DR_";.19///"_IBRMARK
	D ^DIE K DA,DR,DIE
	L -^IBT(356,+IBTRN)
PROQ	Q
	;
PT(DFN)	; -- format patient name - last 4 for output
	S Y="" I '$G(DFN) G PTQ
	I '$D(VA("PID")) D PID^VADPT
	S Y=$E($P($G(^DPT(DFN,0)),"^"),1,20)_" "_$E($G(^(0)),1)_VA("BID")
PTQ	Q Y
	;
PRODATA(IBDA)	; -- return data from prosthetics file
	N IBDA0,DA,DIC,DIE,DR
	K IBRMPR ; only one array at a time
	I '$G(IBDA) G PRODAQ
	S IBDA0=$G(^RMPR(660,+IBDA,0))
	G:IBDA0="" PRODAQ
DIQ	S DIC="^RMPR(660,",DR=".01;1:5;7;10;12:17;24"
	S DIQ="IBRMPR",DIQ(0)="E",DA=IBDA
	D EN^DIQ1
PRODAQ	Q

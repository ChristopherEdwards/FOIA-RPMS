IBTRKR2	;ALB/AAS - ADD/TRACK SCHEDULED ADMISSION ; 9-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	;
EN	; -- add scheduled admissions to claims tracking file
	N I,J,X,Y,IBTRKR,IBI,IBJ,DFN,IBDATA
	S IBTRKR=$G(^IBE(350.9,1,6))
	G:'$P(IBTRKR,"^",2) ENQ ; inpatient tracking off
	S:'$G(IBTSBDT) IBTSBDT=$$FMADD^XLFDT(DT,-3)-.1
	S:'$G(IBTSEDT) IBTSEDT=$$FMADD^XLFDT(DT,7)+.9
	I IBTSBDT<+IBTRKR S IBTSBDT=+IBTRKR-.1 ; start date can't be before ct start date
	S IBI=IBTSBDT-.0001 F  S IBI=$O(^DGS(41.1,"C",IBI)) Q:'IBI!(IBI>IBTSEDT)  S IBJ="" F  S IBJ=$O(^DGS(41.1,"C",IBI,IBJ)) Q:'IBJ  D
	.S IBDATA=$G(^DGS(41.1,IBJ,0))
	.S DFN=+IBDATA
	.Q:'DFN  ;  no patient
	.Q:$P(IBDATA,"^",13)  ; canceled
	.Q:$P(IBDATA,"^",17)  ; already admitted
	.;if not in ct add
	.S IBTRN=$O(^IBT(356,"ASCH",IBJ,0))
	.I 'IBTRN D  Q
	..I $P(IBTRKR,"^",2)=2 D SCH^IBTUTL2(DFN,IBI,IBJ) Q
	..I $P(IBTRKR,"^",2)=1,$$INSURED^IBCNS1(DFN,+IBI) D SCH^IBTUTL2(DFN,IBI,IBJ)
	..Q
	.; -- if inactive re-activate
	.I '$P(^IBT(356,+IBTRN,0),"^",20) D
	..N X,Y,I,J,DA,DR,DIE,DIC
	..S DA=IBTRN,DR=".2////1",DIE="^IBT(356," D ^DIE
	.Q
	;
ENQ	K IBTSEDT,IBTSBDT
	Q
	;
SCH(DGPMCA)	; -- is this admission movement a scheduled admission
	; -- output scheduled admission pointer
	;
	N IBTSA S IBTSA=0
	I '$G(DGPMCA) G SCHQ
	S IBTSA=+$O(^DGS(41.1,"AMVT",DGPMCA,0))
SCHQ	Q IBTSA

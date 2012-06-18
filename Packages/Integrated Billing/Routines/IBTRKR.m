IBTRKR	;ALB/AAS - CLAIMS TRACKER - AUTO-ENROLLER ; 4-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
INP	; -- Inpatient Tracker
	;    called by ibamtd  from DGPM MOVEMENT EVENTS
	;
	W:'$D(IB20) !,"Updating Claims Tracking"
	;
	N X,Y,DA,DR,DIE,DIC,IBTRN,IBRANDOM,IBTRKR,IBMVTYP,IBMVA,IBMVP,IBMVDA
	S IBTRKR=$G(^IBE(350.9,1,6))
	G:'$P(IBTRKR,"^",2) INPQ ; tracking off
	I '$D(VAIN(1)) D INP^VADPT
	;
	S IBMVTP=$S($P(DGPMA,"^",2):$P(DGPMA,"^",2),1:$P(DGPMP,"^",2)) ;movement type
	S IBMVAD=$S(DGPMA'="":$P(DGPMA,"^",14),1:$P(DGPMP,"^",14)) ; admission movement
	Q:'IBMVTP!('IBMVAD)
	;
	I IBMVTP=1 D 1 ; is add/edit admission
	I IBMVTP=3 D 3
	I IBMVTP=6 D 6
INPQ	I $G(IBTRN) W:'$D(IB20) ".... Entry ",$S($G(IBNEW):"Added.",1:"Edited."),!
	Q
1	;
ADMIT	; -- process admission movements
	Q:IBMVTP'=1
	;
	I DGPMA="" D  G ADMITQ ; is deleted admission
	.S IBTRN=$O(^IBT(356,"AD",+IBMVAD,0)) Q:'IBTRN
	.;inactivate record
	.S DA=IBTRN,DR=".2////0",DIE="^IBT(356,"
	.D ^DIE K DA,DR,DIC,DIE
	.Q
	;
	I DFN=$P($G(^IBT(356,+$O(^IBT(356,"AD",+IBMVAD,0)),0)),"^",2) D  G ADMITQ ;see if already there
	.; -- if different dates or inactive, update
	.S IBTRN=$O(^IBT(356,"AD",+IBMVAD,0))
	.I $P($G(^IBT(356,+IBTRN,0)),U,6)'=+$E(+DGPMA,1,12)!('$P($G(^IBT(356,+IBTRN,0)),U,20)) D
	..N DA,DR,DIC,DIE
	..S DA=IBTRN,DIE="^IBT(356,",DR=".06////"_+$E(+DGPMA,1,12)_";.2////1"
	..D ^DIE
	;
	I +$G(VAIN(3)) S IBRANDOM=$$RANDOM^IBTRKR1(+VAIN(3))
	;
	I $P(IBTRKR,"^",2)=2 D ADM^IBTUTL(IBMVAD,+$E(+DGPMA,1,12),$G(IBRANDOM),$P(DGPMA,"^",27))
	I $P(IBTRKR,"^",2)=1,($$INSURED^IBCNS1(DFN,+DGPMA)!($G(IBRANDOM))) D ADM^IBTUTL(IBMVAD,+$E(+DGPMA,1,12),$G(IBRANDOM),$P(DGPMA,"^",27))
ADMITQ	Q
	;
3	; -- if discharge and is tracked, set up discharge reviews
	;I IBMVTP=3 D
	;.S IBTRN=$O(^IBT(356,"AD",+IBMVAD,0)) Q:'IBTRN
	;.I '$P($G(^IBT(356,+IBTRN,0)),"^",16) Q  ;hospital ur not required
	;.I $O(^IBT(356,"AD",+IBMVAD,0)) D PRE^IBTUTL2($E(+DGPMA,1,7),IBTRN,30)
DSQ	Q
	;
6	; -- specialty change
	I DGPMA="" G SPQ ;is deleted movement, don't worry
	I +DGPMA<$$FMADD^XLFDT(+DT,-7) G SPQ ; past spec change don't worry
	;
	N IBTSA,IBTSP,IBTRN
	S IBTSA=$P($G(^DIC(42.4,+$P($G(^DIC(45.7,+$P(DGPMA,"^",9),0)),"^",2),0)),"^",3)
	;
	I DGPMP'="" D  ;is changed
	.S IBTSP=$P($G(^DIC(42.4,+$P($G(^DIC(45.7,+$P(DGPMP,"^",9),0)),"^",2),0)),"^",3)
	.Q
	;
	I DGPMP="" D
	.N IBDT S IBDT=9999999.9999999-$P(DGPMA,"^")
	.S IBTSP=$P($G(^DIC(45.7,+$O(^(+$O(^DGPM("ATS",+DFN,+IBMVAD,+IBDT)),0)),0)),"^",2)
	.S IBTSP=$P($G(^DIC(42.4,+IBTSP,0)),"^",3)
	.Q
	;
	G:IBTSA=IBTSP SPQ ; is not a change in major bed section
	;
	; -- add hr and ir if it is being tracked
	S IBTRN=$O(^IBT(356,"AD",+IBMVAD,0))
	;
	I $O(^IBT(356.1,"C",+IBTRN,0)) D  ; tracked as a hosp. review
	.I $$ALREADY(356.1,+DGPMA) Q
	.D PRE^IBTUTL2($E(+DGPMA,1,7),IBTRN,30)
	.I $G(IBTRV) S DA=IBTRV,DIE="^IBT(356.1,",DR="11///Entry created by major change in specialty." D ^DIE K DA,DR,DIC,DIE
	.Q
	;
	I $O(^IBT(356.2,"C",+IBTRN,0)) D  ;tracked as an ins. review
	.I $$ALREADY(356.2,+DGPMA) Q
	.I $P($G(^IBT(356,+IBTRN,0)),"^",24) D COM^IBTUTL3($E(+DGPMA,1,12),IBTRN,30)
	.I $G(IBTRC) S DA=IBTRC,DIE="^IBT(356.2,",DR="11///Entry created by major change in specialty." D ^DIE K DA,DR,DIC,DIE
	.Q
SPQ	Q
	;
ALREADY(FILE,DATE)	; -- see if already is review for date
	N X,Y,IBX
	S IBX=0
	S X=$P(DATE,".")+.25
	S Y=$O(^IBT(FILE,"ATIDT",+IBTRN,-X)) S Y=-Y I Y,$P(Y,".")=$P(DATE,".") S IBX=1
	Q IBX
	;
NIGHTLY	; -- nightly job for claims tracking, called by IBAMTC
	;
	D UPDATE^IBTRKR1 ; update claims tracking site parameters (random sampler)
	D ^IBTRKR2 ;       add scheduled admissions to tracking
	D ^IBTRKR3 ;       add rx refill to outpatient encounters
	D ^IBTRKR4 ;       add outpatient encounters to tracking
	D ^IBTRKR5 ;       add outpatient prosthetics item to tracking
	Q

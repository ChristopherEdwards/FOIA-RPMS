IBCONS3	;ALB/AAS - NSC W/INSURANCE OUTPUT, TRACKING INTEFACE ; 21-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
TRACK	; -- Claims tracking interface for patients with insurance reports.
	;
	I $D(ZTQUEUED),$$S^%ZTLOAD S (ZTSTOP,IBQUIT)=1
	;
	N IBTRN
	S IBRMARK=""
	; -- if there get reason not billable
	I IBINPT D  ;look for inpatient tracking records
	.Q:'$G(IBADMVT)
	.S IBTRN=$O(^IBT(356,"AD",+IBADMVT,0))
	.Q:'$G(IBTRN)
	.S IBRMARK=$$RMARK(IBTRN)
	.Q
	;
	I 'IBINPT D  ;look for outpatient tracking records
	.I $G(IBOE) S IBTRN=$O(^IBT(356,"ASCE",+IBOE,0))
	.I '$G(IBOE) D
	..S IBETYP=+$O(^IBE(356.6,"B","OUTPATIENT VISIT",0))
	..S X=$O(^IBT(356,"APTY",DFN,IBETYP,($P(I,".")-.0000001))) S:$P(X,".")=$P(I,".") IBTRN=$O(^(X,0))
	.Q:'$G(IBTRN)
	.S IBRMARK=$$RMARK(IBTRN)
	.Q
	;
	; -- if not in ct and parameter set to add, add to ct.
	I '$G(IBTRN),$P(IBTRKR,"^",23) D ADD
	;
TRACKQ	Q
	;
ADD	; -- if not there see if should add
	;    if inpatient, not before ct start date, inpt tracking on
	I IBINPT,I'<+IBTRKR,$P(IBTRKR,"^",2) D
	.;
	.Q:'$G(IBADMVT)
	.N I,J,X,Y,DA,DR,DIE,DIC,IBETYP,IBADMDT,IBTRN
	.S IBADMDT=$P(^DGPM(IBADMVT,0),"^")
	.S IBETYP=+$O(^IBE(356.6,"B","INPATIENT ADMISSION",0))
	.S IBTRN=$O(^IBT(356,"ASCH",+$$SCH^IBTRKR2(IBADMVT),0))
	.D:'IBTRN ADDT^IBTUTL
	.I IBTRN<1 Q
	.S DA=IBTRN,DIE="^IBT(356,"
	.L +^IBT(356,+IBTRN):10 I '$T Q
	.S DR=$$ADMDR^IBTUTL(IBADMDT,IBETYP,IBADMVT,0)
	.D ^DIE
	.L -^IBT(356,+IBTRN)
	.Q
	;
	; -- if outpatient, not before ct start date, opt tracking on
	I 'IBINPT,I'<+IBTRKR,$P(IBTRKR,"^",3),I'>$$FMDIFF^XLFDT(DT,-2) D
	.;
	.N IBTDT S IBTDT=I
	.N I,J,X,Y,DA,DR,DIC,DIE,IBETYP,IBTRN
	.S IBETYP=+$O(^IBE(356.6,"B","OUTPATIENT VISIT",0))
	.;
	.; -- if encounter add encounter
	.I +$G(IBOE) D  Q
	..S X=$P($G(^SCE(+IBOE,0)),"^",6) I X,X'=+IBOE Q
	..D OPT^IBTUTL1(DFN,IBETYP,IBTDT,+IBOE) Q
	.;
	.S IBTDT=$P(IBTDT,".")
	.; -- must not be before encounter is created
	.Q:IBTDT>($$FMDIFF^XLFDT(DT,-2))
	.;
	.; -- see if already entry for same day.
	.S X=$O(^IBT(356,"APTY",DFN,IBETYP,(IBTDT-.0000001))) I $P(X,".")=IBTDT Q
	.D ADDT^IBTUTL
	.S DA=IBTRN,DIE="^IBT(356,"
	.I IBTRN<1 Q
	.L +^IBT(356,+IBTRN):10 I '$T Q
	.S DR=".02////"_$G(DFN)_";.06////"_IBTDT_";.18////"_IBETYP_";.2////1;.24////1;1.01///NOW;1.02////"_DUZ_";.17////"_$$EABD^IBTUTL(IBETYP)
	.D ^DIE
	.L -^IBT(356,+IBTRN)
	.Q
ADDQ	Q
	;
RMARK(IBTRN)	; -- returns external reason not billable
	Q $P($G(^IBE(356.8,+$P($G(^IBT(356,+$G(IBTRN),0)),"^",19),0)),"^")

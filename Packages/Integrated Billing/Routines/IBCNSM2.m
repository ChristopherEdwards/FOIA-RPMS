IBCNSM2	;ALB/AAS - INSURANCE MANAGEMENT - EDIT ROUTINE ; 22-OCT-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	S U="^"
	;
BU	; -- Enter Edit benefits already used
	D FULL^VALM1
	N I,J,IBXX,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.Q:IBPPOL=""
	.S IBCNS=$P(IBPPOL,"^",5),IBCPOL=$P(IBPPOL,"^",22)
	.D EN^VALM("IBCNS BENEFITS USED BY DATE")
	.Q
	S VALMBCK="R" Q
	;
EP	; -- Enter Edit Patient Insurance Policy Information
	;
	S VALMBCK="R" Q
	;
EI	;  -- Enter Edit Insurance Company Information
	; -- if coming from benefit screen
	;    ibcns=insurance co number
	D FULL^VALM1
	I $G(IBCNS)>0 D EN^VALM("IBCNS INSURANCE COMPANY") G EIQ
	;
	; -- if coming from list of policies, allow selection
	N I,J,IBXX,IBCNS,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
	.S I=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.S IBCNS=$P(I,"^",5)
	.D EN^VALM("IBCNS INSURANCE COMPANY")
EIQ	S VALMBCK="R" Q
	;
VC	; -- Verify Insurance Coverage
	D FULL^VALM1
	N I,J,IBXX,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.Q:IBPPOL=""  D VFY
	;
EXIT	; -- Kill variables, refresh screen
	;
	D BLD^IBCNSM
	K I,J,IBXX,DA,DR,IBDUZZ
	S VALMBCK="R" Q
	;
VFY	; -- Display most recent verification
	;
	N DA,DR,IBDUZ
	D FULL^VALM1
	S IBCH=$P(IBPPOL,U,1)
	S IBDUZ=$P($G(^DPT(DFN,.312,$P(IBPPOL,U,4),1)),U,4)
	I 'IBDUZ D REVASK Q
	W !!," "_IBCH_" LAST VERIFIED BY "_$P($G(^VA(200,+IBDUZ,0)),U)_" ON "_$$DAT1^IBOUTL($P($G(^DPT(DFN,.312,$P(IBPPOL,U,4),1)),U,3))_". . ."
	I $P($P($G(^DPT(DFN,.312,$P(IBPPOL,U,4),1)),U,3),".")=DT W !,"COVERAGE VERIFIED TODAY, "_$$DAT1^IBOUTL(DT) H 3
	E  D REVASK
	Q
	;
REVASK	; -- Determine whether user wishes to re-verify
	;
	N Y
	W:'IBDUZ !
	S DIR("B")="No",DIR(0)="YO",DIR("A")=$S('IBDUZ:" "_IBCH_" NEVER PREVIOUSLY VERIFIED.  DO YOU WISH TO VERIFY COVERAGE",1:"ARE YOU RE-VERIFYING COVERAGE TODAY")
	D ^DIR K DIR Q:$D(DIRUT)
	I Y D REVFY
	Q
	;
REVFY	; -- Re-verify
	;
	S DA(1)=DFN,DA=$P(IBPPOL,U,4),DIE="^DPT(DFN,.312,",DR="1.03////"_DT_";1.04////"_DUZ D ^DIE K DIE
	S IBDUZ=$P($G(^DPT(DFN,.312,$P(IBPPOL,U,4),1)),U,4)
	W !," "_IBCH_" VERIFIED BY "_$P($G(^VA(200,+IBDUZ,0)),U)_" ON "_$$DAT1^IBOUTL($P($G(^DPT(DFN,.312,$P(IBPPOL,U,4),1)),U,3)) D PAUSE^VALM1
	Q

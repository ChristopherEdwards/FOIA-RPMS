IBCNSM1	;ALB/AAS - INSURANCE MANAGEMENT - OUTPUTS ; 22-OCT-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	G EN^IBCNSM
	;
VP	; -- View Patient Policy Info
	D FULL^VALM1
	N I,J,IBXX,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D  ;W !,"Entry ",X,"Selected" D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.Q:IBPPOL=""
	.D EN^VALM("IBCNS EXPANDED POLICY")
	.Q
	I '$G(IBFASTXT) D BLD^IBCNSM
	S VALMBCK="R" Q
	;
AB	; -- Edit Annual Benefits
	D FULL^VALM1
	N I,J,IBXX,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.Q:IBPPOL=""
	.S IBCNS=$P(IBPPOL,"^",5),IBCPOL=$P(IBPPOL,"^",22)
	.D FULL^VALM1
	.D EN^VALM("IBCNS ANNUAL BENEFITS")
	.Q
	S VALMBCK="R" Q
	;
UP	; -- Print new, not verified insurance
	;
	N I,J,IBXX,IBCNS,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) W !,IBXX,! H 2 Q:'IBXX  D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.Q:IBPPOL=""
	.S IBCNS=$P(IBPPOL,"^",5),IBCPOL=$P(IBPPOL,"^",22)
	.S INSCO=^DIC(36,IBCNS,0)
	.W !!,$P(INSCO,"^"),!! H 2
	.W !!,$P(IBPPOL,"^",4),!! H 2
	.Q
	D FULL^VALM1
	W !!,"REPORT OF NEW NOT VERIFIED INSURANCE",!! H 2
	S VALMBCK="R" Q
	;
PC	; -- Print Patient Insurance info
	;N IBLINE,IBCY,IBWP
	N IBWP
	;
PCWP	; -- Print Insurance Coverage, Worksheet
	;
	N I,J,IBXX,IBLINE,IBCY,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX  D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.Q:IBPPOL=""
	.S IBCPOL=$P(IBPPOL,"^",22)
	.S IBLINE=$S($G(IBWP):1,1:0)
	.S IBCY=$S($G(IBWP):0,1:1)
	.D WPPC^IBCNSM5
	.Q
	S VALMBCK="R" Q
	;
WP	; -- Print Worksheet
	N IBWP
	S IBWP=1
	D PCWP
	S VALMBCK="R" Q
	;
DP	; -- Delete insurance policy
	D FULL^VALM1
	I '$D(^XUSEC("IB INSURANCE SUPERVISOR",DUZ)) D SORRY^IBTRE1 G DPQ
	N I,J,IBXX,DIR,DIRUT,IBBCNT,BLD,IBCOVP,VALMY
	D EN^VALM2($G(XQORNOD(0)))
	S IBCOVP=$P($G(^DPT(DFN,.31)),"^",11)
	I $D(VALMY) S IBXX=0 F  S IBXX=$O(VALMY(IBXX)) Q:'IBXX!$D(DIRUT)  D
	.S IBPPOL=$G(^TMP("IBNSMDX",$J,$O(^TMP("IBNSM",$J,"IDX",IBXX,0))))
	.; do some error checking here
	.I $$DELP^IBCNSU(DFN,$P(IBPPOL,"^",5)) D  Q
	..W !,"You can't delete this policy, there are bills associated with it."
	..W ! S J=0 F  S J=$O(^DGCR(399,"AE",DFN,$P(IBPPOL,"^",5),J)) Q:'J  I $P(^DGCR(399,J,"S"),"^",17)="" W $P(^DGCR(399,J,0),"^")_"   " S IBBCNT=$G(IBBCNT)+1 W:'(IBBCNT#8) !
	..K IBBCNT
	..Q
	.;
	.S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are You Sure you want to delete policy #"_IBXX
	.D ^DIR K DIR I Y'=1 W !,"Policy #",IBXX," not Deleted!" Q
	.S IBCDFN=$P(IBPPOL,"^",4)
	.D DP1
	.Q
DPQ	D COVERED^IBCNSM31(DFN,$G(IBCOVP))
	D PAUSE^VALM1,BLD^IBCNSM:$G(BLD)
	S VALMBCK="R" Q
	;
DP1	; -- actual deletion
	N DA,DIC,DIK
	;
	; -- if individual policy, and is right patient, delete HIP
	S BLD=1
	S IBCPOL=$P($G(^DPT(DFN,.312,IBCDFN,0)),"^",18),IBCPOLD=$G(^IBA(355.3,+IBCPOL,0))
	I '$P(IBCPOLD,"^",2),DFN=$P(IBCPOLD,"^",10) S DA=IBCPOL,DIK="^IBA(355.3," D ^DIK K DA,DIC,DIK
	;
	; -- delete entry in patient file
	S DA=IBCDFN,DA(1)=DFN,DIK="^DPT("_DFN_",.312," D ^DIK
	W:$G(IBXX) !,"Entry ",$G(IBXX)," Deleted"
	Q

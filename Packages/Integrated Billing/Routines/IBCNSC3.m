IBCNSC3	;ALB/NLR - INACTIVATE AND REPOINT INS STUFF1 ; 20-APR-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
RPTASK	; -- ask if user wishes to repoint patients to active insurance company
	;
	N IBR
	S DIR(0)="YO",DIR("A")="DO YOU WISH TO REPOINT "_$S(IBC=1:"THIS PATIENT",1:"THESE PATIENTS")_" TO ANOTHER INSURANCE COMPANY",DIR("B")="No"
	W !
	D ^DIR K DIR G:'Y!$D(DIRUT) R3Q
	W !
	S DIC="^DIC(36,",DIC(0)="QEAZ",DIC("A")="REPOINT "_$S(IBC=1:"THIS PATIENT",1:"THESE PATIENTS")_" TO WHICH (ACTIVE) INSURANCE COMPANY: ",DIC("S")="I +$P(^(0),U,5)=0" D ^DIC K DIC G:$D(DIRUT) R3Q
	Q:+Y<1
	S IBR=+Y D SAVE
	;
REPOINT	; -- get parameters for call to DIE
	;
	S DFN=0 F  S DFN=$O(^DPT("AB",IBCNS,DFN)) Q:'DFN!('IBR)  D RPT1
	Q
RPT1	;
	S IBD=0 F  S IBD=$O(^DPT("AB",IBCNS,DFN,IBD)) Q:'IBD  D CALLDIE D RPT2
	Q
RPT2	;
	S IBN=0 F  S IBN=$O(^IBA(355.3,"B",IBCNS,IBN)) Q:'IBN  S DA=IBN D CALLDIE1
	;
R3Q	Q
	;
VERIFY	; -- allow user to change mind about inactivating company
	;
	W !
	S DIR("B")="No",DIR(0)="YO",DIR("A")="ARE YOU REALLY SURE YOU WISH TO INACTIVATE "_IBN
	S DIR("?",1)="You are about to change "_IBN_" to inactive."
	S DIR("?",2)="This means you will no longer be able to bill "
	S DIR("?")=""_IBN_" for its patients' charges."
	D ^DIR K DIR I $D(DIRUT) S IBQUIT=1
	S:Y IBV=1
	Q
	;
HDR	; -- print header
	;
	W:$E(IOST,1,2)["C-"!($G(IBPAG)) @IOF
	S IBPAG=$G(IBPAG)+1
	W !,?1,"PATIENTS WITH "_$S(+IBV=0:"ACTIVE",+IBV=1:"INACTIVATED")_" INSURANCE, "_$P(^DIC(36,IBCNS,0),U),?69,"PAGE ",IBPAG,?77,$$DAT1^IBOUTL(DT)
	W !?1,"PATIENT",?31,"PATIENT ID",?52,"EFF DATE",?63,"EXP DATE",?74,"SUBSCR ID",?95,"WHOSE INS",?106,"EMPLOYER",!
	W $TR($J(" ",IOM)," ","-")
	Q
	;
BUILD	; -- set list of patients in ^tmp array
	;
	K ^TMP($J,"IBCNSC2")
	S DFN=0
	F  S DFN=$O(^DPT("AB",IBCNS,DFN)),X=$$PT^IBEFUNC(DFN),IBNA=$P(X,U,1),IBNO=$P(X,U,2) S:IBNA="" IBNA="<Pt. "_DFN_" Name Missing>" Q:'DFN  S IBD=0 F  S IBD=$O(^DPT("AB",IBCNS,DFN,IBD)) Q:'IBD  D
	.S IBIND=$G(^DPT(DFN,.312,IBD,0))
	.;S IBIND2=$G(^DPT(DFN,.312,IBD,2))
	.I IBCNS'=$P(+IBIND,U) Q  ;bad x-ref,maybe later take action
	.D SET
	Q
	;
CALLDIE	; -- get name of active insurance co., repoint patients to same 
	;
	;S DIE="^DPT(DFN,.312,",DA(1)=DFN,DA=IBD,DR=".01////"_$G(IBR) D ^DIE K DIE
	S DIE="^DPT(DFN,.312,",DA(1)=DFN,DA=IBD,DR=".01///`"_$G(IBR) D ^DIE K DIE
	Q
CALLDIE1	; -- stuff .01 field of 355.3 with newly-assigned ins. co.
	;
	;S DIE="^IBA(355.3,",DA=IBN,DR=".01////"_$G(IBR) D ^DIE K DIE
	S DIE="^IBA(355.3,",DA=IBN,DR=".01///`"_$G(IBR) D ^DIE K DIE
	Q
	;
SET	; -- store data to be printed in temp array
	;
	; ^tmp($j,"ibcnsc2",patient name,dfn,ien of policy) =
	;    patient id^effective date^expiration date^subscriber id^whose insurance^employer
	;
	S IBWI=$P(IBIND,"^",6)
	S VAOA("A")=$S(IBWI="v":5,IBWI="s":6,1:5)
	D OAD^VADPT
	S EMPLOYER=VAOA(9)
	S ^TMP($J,"IBCNSC2",IBNA,DFN,IBD)=IBNO_"^"_$P(IBIND,"^",8)_U_$P(IBIND,"^",4)_"^"_$P(IBIND,"^",2)_"^"_IBWI_"^"_EMPLOYER
	Q
	;
SAVE	; -- save off field repointed too
	N DA,DR,DIC,DIE
	Q:'$G(IBR)
	S DA=IBCNS,DR=".16////"_IBR,DIE="^DIC(36," D ^DIE
	Q

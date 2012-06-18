IBCNSM3	;ALB/AAS - INSURANCE MANAGEMENT - OUTPUTS ; 28-MAY-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	G EN^IBCNSM
	;
AD	; -- Add new insurance policy
	N X,Y,DO,DD,DA,DR,DIC,DIE,DIK,DIR,DIRUT,IBCNSP,IBCPOL,IBQUIT,IBOK,IBCDFN,IBAD,IBGRP,IBADPOL,IBCOVP
	S IBCNSEH=$P($G(^IBE(350.9,1,4)),"^",1),IBQUIT=0,IBADPOL=1
	D FULL^VALM1
	S IBCOVP=$P($G(^DPT(DFN,.31)),"^",11)
	I '$D(^DPT(DFN,.312,0)) S ^DPT(DFN,.312,0)="^2.312PAI^^"
	;
	D INS^IBCNSEH
	; -- Select insurance company
	;    If one already exists for same co. ask are you sure you are
	;    adding a new one
	S DIR(0)="350.9,4.06"
	S DIR("A")="Select INSURANCE COMPANY",DIR("??")="^D ADH^IBCNSM3"
	S DIR("?")="Select the Insurance Company for the policy you are entering"
	D ^DIR K DIR S IBCNSP=+Y I Y<1 G ADQ
	I $P($G(^DIC(36,+IBCNSP,0)),"^",2)="N" W !,"This company does not reimburse.  "
	I $P($G(^DIC(36,+IBCNSP,0)),"^",5) W !,*7,"Warning: Inactive Company" H 3 K IBCNSP G ADQ
	I $$DUPCO^IBCNSOK1(DFN,IBCNSP,"",1) H 3
	;
	; -- see if can use existing policy
	D SEL^IBCNSEH
	S IBCPOL=$$LK^IBCNSM31(IBCNSP) I IBCPOL>0 D OK G:IBQUIT ADQ S:'IBOK IBCPOL=-1
	I IBCPOL<1 S IBCPOL=$$NEW(IBCNSP)
	I IBCPOL<1 G ADQ
	;
	; -- file new patient policy
	S DIC("DR")=".18////"_IBCPOL_";1.09////1;1.05///NOW;1.06////"_DUZ
	K DD,DO S DA(1)=DFN,DIC="^DPT("_DFN_",.312,",DIC(0)="L",X=IBCNSP D FILE^DICN K DIC S IBCDFN=+Y,IBNEW=1 I +Y<1 G ADQ
	;
	; -- Edit patient policy data
	D PAT^IBCNSEH,PATPOL(IBCDFN)
	;
	; -- edit PLAN data if hold key
	I '$D(^XUSEC("IB INSURANCE SUPERVISOR",DUZ)) G ADQ
	I '$G(IBQUIT) D POL^IBCNSEH,EDPOL(IBCDFN)
	I '$G(IBNEW) D AI^IBCNSP1
	G ADQ
	;
ADQ	D COVERED^IBCNSM31(DFN,IBCOVP)
	I $G(IBNEW),$G(IBCDFN)>0 D AFTER^IBCNSEVT,^IBCNSEVT
	I $G(IBCPOL)>0 D BLD^IBCNSM
	S VALMBCK="R"
	Q
	;
PATPOL(IBCDFN)	; -- edit patient specific policy info
	I '$G(IBCDFN) G PATPOLQ
	D SAVEPT^IBCNSP3(DFN,IBCDFN)
	;
	; -- give warning if expired or inactive co.
	I $P(^DPT(DFN,.312,IBCDFN,0),"^",4),$P(^(0),"^",4)'>DT W !,"WARNING:  This appears to be an expired policy!",!
	I $P(^DIC(36,+$P(^DPT(DFN,.312,IBCDFN,0),"^"),0),"^",5) W !,*7,"WARNING:  This insurance company is INACTIVE!",!
	;
	N IBAD,IBDIF,DA,DR,DIC,DIE
	S DIE="^DPT("_DFN_",.312,",DA(1)=DFN,DA=IBCDFN
	S DR="S IBAD="""";8;@333;3;D FUTURE^IBCNSM31;6;S IBAD=X;I IBAD'=""v"" S Y=""@10"";17///^S X=""`""_DFN;16///^S X=""01"";S Y=""@20"";@10;17;16//^S X=$S(IBAD=""s"":""02"",1:"""");@20;1;I $G(IBREG) S Y=""@99"";.2;@99"
	I $G(IBREG),$D(^XUSEC("IB INSURANCE SUPERVISOR",DUZ)) S DR=".01//;"_DR
	L +^DPT(DFN,.312,+IBCDFN):5 I '$T D LOCKED^IBTRCD1 G PATPOLQ
	D ^DIE I $D(Y)!($D(DTOUT)) S IBQUIT=1
	I '$D(DA) S IBQUIT=1 G PATPOLQ
	K IBFUTUR
	D COMPPT^IBCNSP3(DFN,IBCDFN)
	I IBDIF D UPDATPT^IBCNSP3(DFN,IBCDFN)
	L -^DPT(DFN,.312,+IBCDFN)
	;
	D FUTURE^IBCNSM31 K Y,IBFUTUR
PATPOLQ	Q
	;
EDPOL(IBCDFN)	; -- Edit GROUP PLAN specific info
	I '$G(IBCDFN) G EDPOLQ
	N DA,DR,DIE,DIC,IBAD,IBCPOL,IBDIF
	S IBCPOL=$P($G(^DPT(DFN,.312,IBCDFN,0)),"^",18)
	L +^IBA(355.3,+IBCPOL):5 I '$T D LOCKED^IBTRCD1 G EDPOLQ
	I IBCPOL D
	.D SAVE^IBCNSP3(IBCPOL)
	.S DIE="^IBA(355.3,",DA=IBCPOL
	.S DR="S IBAD=$P($G(^IBA(355.3,DA,0)),U,2),Y=$S(IBAD=0:""@55"",IBAD="""":""@1"",1:""@25"");@1;.02;@25;.03;.04;@55;.09;.05;.06;.07;.08//YES;"
	.I $D(IBREG),'$G(IBNEWP) S DR="S IBAD=$P($G(^IBA(355.3,DA,0)),U,2),Y=$S(IBAD=0:""@55"",IBAD="""":""@1"",1:""@25"");@1;.02;@25;D 3^IBCNSM31;D 4^IBCNSM31;@55;.09;.05;.06;.07;.08//YES;"
	.D ^DIE
	.D COMP^IBCNSP3(IBCPOL)
	.I IBDIF D UPDATE^IBCNSP3(IBCPOL),UPDATPT^IBCNSP3(DFN,IBCDFN) I $$DUPPOL^IBCNSOK1(IBCPOL,1)
	L -^IBA(355.3,+IBCPOL)
EDPOLQ	Q
	;
NEW(IBCNSC)	; -- ask if add new policy, if yes file (addh^ibcnsu)
	N IBCPOL,DIR,Y,X,IBGRP
	S IBCPOL=-1
	S DIR(0)="Y",DIR("B")="NO",DIR("A")="ARE YOU ADDING "_$P(^DIC(36,+IBCNSC,0),"^")_" AS A NEW GROUP INSURANCE PLAN"
	S DIR("?")="If this is a group plan that has not been previously entered an you wish to add it answer 'YES'.  If you do not wish to add a new group plan enter 'NO'."
	D ^DIR K DIR
	I Y<1!($D(DIRUT)) G NEWQ
	;
	; -- is group policy
	S DIR("?")="Answer 'YES' if this is a group insurance plan, that is, more than one patient may have a policy covered by this plan.  Answer 'NO' if this is an individual insurance plan."
	S DIR(0)="355.3,.02",DIR("A")="IS THIS A GROUP PLAN" D ^DIR K DIR S IBGRP=Y
	I $D(DIRUT) G NEWQ
	;
	; -- file new policy in policy file
	S IBCPOL=$$ADDH^IBCNSU(IBCNSC,IBGRP)
NEWQ	Q IBCPOL
	;
OK	; -- ask okay
	S IBQUIT=0,DIR(0)="Y",DIR("A")="       ...OK",DIR("B")="YES" D ^DIR K DIR
	I $D(DIRUT) S IBQUIT=1
	S IBOK=Y
	Q
	;
ADH	; -- show existing policies for help
	N DIR,DA,%A
	W !!,"The patient currently has the following Insurance Policies"
	D DISP^IBCNS
	Q

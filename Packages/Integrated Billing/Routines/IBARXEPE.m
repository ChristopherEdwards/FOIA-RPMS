IBARXEPE	;ALB/AAS - EDIT EXEMPTION LETTER - 28-APR-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	I '$D(DT) D DT^DICRW
	;
EDIT	; -- Edit form letter
	I '$D(IOF) D HOME^%ZIS
	W @IOF,"Edit Exemption Patient Notification Letter",!!!
	S IBQUIT=0
	S DIC("B")="IB NOW EXEMPT",DIC(0)="AEQMNL",DIC="^IBE(354.6," D ^DIC K DIC S (IBLET,DA)=+Y G:DA<1 EDQ
	S DR=""
	I $P($G(^IBE(354.6,DA,0)),"^",4)="" S DR=".04////15;"
	S DIE="^IBE(354.6,",DR=DR_"2;1;.04" D ^DIE
	;
	W !!
TEST	S DIR(0)="Y",DIR("A")="Test Print Letter",DIR("B")="YES" D ^DIR K DIR
	I Y'=1 G EDQ
	W !
	S DIC="^DPT(",DIC(0)="AEQM",DIC("S")="I $P($G(^IBA(354,+Y,0)),U,4)",DIC("A")="Select Exempt BILLING PATIENT: "
	D ^DIC K DIC I +Y<1 G EDQ
	S DFN=+Y,IBDATA=$$PT^IBEFUNC(DFN),IBNAM=$P(IBDATA,"^")
	S %ZIS="QM" D ^%ZIS G:POP EDQ
	I $D(IO("Q")) K IO("Q") S ZTRTN="ED1^IBARXEPE",ZTSAVE("IB*")="",ZTSAVE("DFN")="",ZTDESC="Test Print Exemption Letter" D ^%ZTLOAD K ZTSK D HOME^%ZIS G EDQ
	U IO
	; 
ED1	S IBALIN=$P($G(^IBE(354.6,IBLET,0)),"^",4)
	I IBALIN<10!(IBALIN>25) S IBALIN=15
	D ONE^IBARXEPL
	;
EDQ	D END^IBARXEPL
	Q
